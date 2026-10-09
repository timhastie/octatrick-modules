#!/usr/bin/env python3
"""stock_scan.py -- is there an Elektron byte in the module sources?

For every file under this repository's module directories (direct-jump/,
quantizer/, synth/, tuner/ -- every top-level directory that holds a
manifest.py; `--root` names another tree, such as an octabam checkout's
modules/<name>/upstream) the scan decodes every byte sequence a file can
carry:

  * .py manifests: every string constant that parses as hex (bytes.fromhex;
    adjacent literals concatenate as Python does), so a PINNED_* cave or a
    *_STOCK hook-site constant is one blob;
  * .s sources: runs of .byte/.short/.word/.long data directives (numeric
    operands, big-endian; labels and comments do not break a run) and
    .ascii/.asciz strings; .fill/.rept/.space are skipped (a repeated
    value is ignored anyway);
  * any other file (README.md, ...): every run of >= 32 hex digits;
  * plus, for a .s file, its ASSEMBLED AND LINKED .text (m68k-elf-as
    -mcpu=54455, ld at an arbitrary address, when the toolchain is present;
    a symbol resolves into the unit itself, never into stock) -- the
    stronger check, since a displaced instruction is code, not a data
    directive.

Every 16-byte window of every blob is looked up in the user's stock image
(--stock, octabam's out/raw/section_3_MAIN_OS.bin, base 0x40000400);
windows of one repeated value are ignored. A hit is reported as
file:blob-line+offset -> the stock address, merged into maximal runs. The
only hits allowed are the displaced instructions at a hook site (octabam's
CONTRIBUTING.md, "The one rule") and the idioms the assembler shares with
the stock compiler; read the list by hand.

Run from anywhere:  python3 tools/stock_scan.py --stock <octabam>/out/raw/section_3_MAIN_OS.bin [--root DIR] [--no-asm]
Exit status 0 = no hits, 1 = hits (the allowed hook-site runs included: judge them).
"""
import argparse, ast, os, pathlib, re, shutil, subprocess, sys, tempfile

BASE = 0x40000400
W = 16
# The repository root: this file lives in tools/. Every top-level directory
# with a manifest.py is a module and is scanned.
REPO = pathlib.Path(__file__).resolve().parent.parent
# Hook-site displaced instruction sequences the rule allows (CONTRIBUTING.md):
# (repo path, stock address of the run) -- the manifests' *_STOCK constants
# and their replay in the caves. Filled from a first run and checked by hand.
ALLOWED_NOTE = "hook-site displaced instructions (allowed by CONTRIBUTING.md)"


def low_entropy(w: bytes) -> bool:
    """A window that says nothing about the firmware: one repeated value, a
    pattern of period <= 4 (a mask table, zero-padded longs), or <= 3
    distinct byte values (small numbers with zero padding)."""
    if len(set(w)) <= 3:
        return True
    for p in (1, 2, 3, 4):
        if w == (w[:p] * W)[:W]:
            return True
    return False


def windows_index(stock: bytes):
    idx = {}
    for i in range(len(stock) - W + 1):
        w = stock[i:i + W]
        if low_entropy(w):
            continue
        idx.setdefault(w, []).append(i)
    return idx


def blobs_py(text: str):
    """(line, blob) for every string constant that is hex."""
    out = []
    try:
        tree = ast.parse(text)
    except SyntaxError:
        return out
    for n in ast.walk(tree):
        if isinstance(n, ast.Constant) and isinstance(n.value, str):
            s = re.sub(r"\s+", "", n.value)
            if len(s) >= 2 * W and re.fullmatch(r"[0-9a-fA-F]+", s) and len(s) % 2 == 0:
                out.append((n.lineno, bytes.fromhex(s)))
    return out


_DIR = re.compile(r"^\s*(?:[A-Za-z_.$][\w.$]*:\s*)*\.(byte|short|word|long|ascii|asciz|fill|rept|space|skip|endr|align|set|text|data|global|globl)\b(.*)$")


def _num(tok: str):
    tok = tok.strip()
    if tok.startswith("'") and len(tok) >= 3:
        return ord(tok[1])
    try:
        return int(tok, 0)
    except ValueError:
        return None


def blobs_s(text: str):
    """(line, blob) per run of data directives; a run breaks at anything
    that is not a data directive, a label or a comment."""
    out, cur, start = [], bytearray(), None
    def flush():
        nonlocal cur, start
        if len(cur) >= W:
            out.append((start, bytes(cur)))
        cur, start = bytearray(), None
    for ln, raw in enumerate(text.splitlines(), 1):
        line = raw.split("|", 1)[0].rstrip()
        if not line.strip() or re.fullmatch(r"\s*[A-Za-z_.$][\w.$]*:\s*", line):
            continue
        m = _DIR.match(line)
        if not m:
            flush(); continue
        d, args = m.group(1), m.group(2).strip()
        if d in ("ascii", "asciz"):
            for s in re.findall(r'"((?:[^"\\]|\\.)*)"', args):
                b = ast.literal_eval('b"' + s + '"')
                if start is None: start = ln
                cur += b + (b"\0" if d == "asciz" else b"")
            continue
        if d in ("byte", "short", "word", "long"):
            size = {"byte": 1, "short": 2, "word": 2, "long": 4}[d]
            vals = [_num(t) for t in args.split(",")] if args else []
            if any(v is None for v in vals):
                flush(); continue           # a symbol: an address, not stock data
            if start is None: start = ln
            for v in vals:
                cur += (v & ((1 << (8 * size)) - 1)).to_bytes(size, "big")
            continue
        if d in ("align",):
            continue
        flush()
    flush()
    return out


def blobs_hexruns(text: str):
    out = []
    for ln, line in enumerate(text.splitlines(), 1):
        for m in re.finditer(r"(?<![0-9a-fA-Fx])([0-9a-fA-F]{32,})(?![0-9a-fA-F])", line):
            s = m.group(1)
            if len(s) % 2: s = s[:-1]
            out.append((ln, bytes.fromhex(s)))
    return out


def sydrum_locks(directory: pathlib.Path):
    """2.11: the step locks' sources sy-drum's remix.inc appends after the engine, in the
    manifest's order (its LOCKS tuple, read without importing octabam's schema)."""
    tree = ast.parse((directory / "manifest.py").read_text())
    for node in tree.body:
        if isinstance(node, ast.Assign) and any(getattr(t, "id", None) == "LOCKS" for t in node.targets):
            return ast.literal_eval(node.value)
    return ()


def remix_variants(path: pathlib.Path):
    """2.11: a unit that includes "remix.inc" (octabam writes it per remix from the
    manifest's Linked.include) is assembled once per flag setting, with the file this
    repository's manifests build: HAVE_SYDRUM 0 and 1 (the SY DRUM call-outs) and
    synth/engine_abi.inc; sy-drum's unit (two passes) also gets its engine and its step
    locks (the .inc.s files are only ever assembled inside that unit). Without it
    the assembly would fail and the stronger check be skipped. [None] when the unit
    includes nothing."""
    text = path.read_text(errors="replace")
    if '.include "remix.inc"' not in text:
        return [None]
    abi = (REPO / "synth" / "engine_abi.inc").read_text()
    if path.parent.name == "sy-drum":
        engine = (path.parent / "engine.inc.s").read_text()
        locks = [(path.parent / f"{n}.inc.s").read_text() for n in sydrum_locks(path.parent)]
        return ["\n".join((".ifndef SD_PASS1", ".set SD_PASS1, 1", ".set HAVE_SYDRUM, 1", abi,
                           ".else", engine, *locks, ".endif"))]
    return [f".set HAVE_SYDRUM, {f}\n" + abi for f in (0, 1)]


def blob_asm(path: pathlib.Path, inc=None):
    if not shutil.which("m68k-elf-as") or not shutil.which("m68k-elf-objcopy"):
        return None
    with tempfile.TemporaryDirectory() as d:
        o, b = os.path.join(d, "u.o"), os.path.join(d, "u.bin")
        extra = []
        if inc is not None:
            pathlib.Path(d, "remix.inc").write_text(inc)
            extra = ["-I", d]
        r = subprocess.run(["m68k-elf-as", "-mcpu=54455", *extra, "-o", o, str(path)], capture_output=True, text=True)
        if r.returncode:
            if inc is not None:
                sys.exit(f"{path}: does not assemble with its remix.inc:\n{r.stderr}")
            return None
        # Link before scanning: an unlinked object's relocations are zero longs,
        # and zeros beside an absolute stock-routine constant (a formatter
        # table) matched a stock pointer table once. Any address will do --
        # a resolved symbol points into the unit, never into stock; unresolved
        # cross-unit symbols are left at 0 (ignore-all) and reported as such.
        e = os.path.join(d, "u.elf")
        r = subprocess.run(["m68k-elf-ld", "-Ttext=0x400d0000", "--unresolved-symbols=ignore-all",
                            "-o", e, o], capture_output=True, text=True)
        if r.returncode:
            return None
        r = subprocess.run(["m68k-elf-objcopy", "-O", "binary", "-j", ".text", e, b], capture_output=True, text=True)
        if r.returncode:
            return None
        return pathlib.Path(b).read_bytes()


def scan_blob(idx, blob: bytes):
    """Maximal runs: [(blob offset, stock offset, length)]."""
    hits = []
    i = 0
    while i <= len(blob) - W:
        w = blob[i:i + W]
        if w in idx and not low_entropy(w):
            runs = []
            for so in idx[w]:
                n = W                    # extend the run as far as it matches
                while i + n < len(blob) and so + n < STOCK_LEN and blob[i + n] == STOCK[so + n]:
                    n += 1
                runs.append((so, n))
            longest = max(n for _, n in runs)
            hits.append((i, longest, sorted(runs, key=lambda r: -r[1])))
            i += longest - W + 1         # past this run: one report per run
        else:
            i += 1
    return hits


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--stock", default="out/raw/section_3_MAIN_OS.bin",
                    help="the stock main-OS section (octabam: out/raw/section_3_MAIN_OS.bin)")
    ap.add_argument("--root", default=str(REPO), help="the tree whose module directories are scanned (default: this repository)")
    ap.add_argument("--no-asm", action="store_true")
    a = ap.parse_args()
    global STOCK, STOCK_LEN
    STOCK = pathlib.Path(a.stock).read_bytes(); STOCK_LEN = len(STOCK)
    idx = windows_index(STOCK)
    seen = set(); files = 0; blobs = 0; hits = []
    top = pathlib.Path(a.root)
    roots = sorted(d for d in top.iterdir() if d.is_dir() and (d / "manifest.py").is_file())
    if not roots:
        sys.exit(f"{top}: no module directory (a directory with a manifest.py)")
    print("modules:", ", ".join(d.name for d in roots))
    for root in roots:
        for p in sorted(root.rglob("*")):
            if not p.is_file() or ".git" in p.parts or "__pycache__" in p.parts:
                continue
            rel = p.relative_to(top).as_posix()
            if rel in seen:
                continue
            seen.add(rel); files += 1
            try:
                text = p.read_text(errors="replace")
            except Exception:
                text = ""
            items = []
            if p.suffix == ".py":
                items += [("hex", ln, b) for ln, b in blobs_py(text)]
            if p.suffix.lower() == ".s":
                items += [("data", ln, b) for ln, b in blobs_s(text)]
                if not a.no_asm and not p.name.endswith(".inc.s"):    # (an include: assembled in its unit)
                    for inc in remix_variants(p):
                        b = blob_asm(p, inc)
                        if b is not None:
                            items.append(("asm", 0, b))
            if p.suffix not in (".py", ".s") and p.suffix.lower() not in (".png", ".wav", ".jpg"):
                items += [("hexrun", ln, b) for ln, b in blobs_hexruns(text)]
            if p.suffix.lower() in (".png", ".wav", ".jpg"):
                items.append(("binary", 0, p.read_bytes()))
            for kind, ln, b in items:
                blobs += 1
                for off, n, runs in scan_blob(idx, b):
                    hits.append((rel, kind, ln, off, n, runs))
    print(f"scanned {files} files, {blobs} blobs, against {STOCK_LEN:,} B of stock (base 0x{BASE:08x}); "
          f"{len(hits)} run(s) of >= {W} stock bytes (low-entropy windows ignored)")
    for rel, kind, ln, off, n, runs in hits:
        where = f"{rel}:{ln}+{off}" if ln else f"{rel}:{kind}+0x{off:x}"
        at = ", ".join(f"0x{BASE + so:08x}({m} B)" for so, m in runs[:3]) + (f" +{len(runs) - 3} more" if len(runs) > 3 else "")
        print(f"  {where:44s} {kind:6s} {n:4d} B == stock {at}")
    return 1 if hits else 0


if __name__ == "__main__":
    sys.exit(main())
