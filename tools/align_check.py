#!/usr/bin/env python3
"""align_check.py -- no ColdFire code at an odd address, no jump to one.

A ColdFire takes an ADDRESS ERROR on an instruction fetch from an odd
address: a jump, a call, a branch or a return to one stops the firmware.
GNU as does not warn when a `.text` that follows odd-length data (an
.ascii string, a .byte table) starts its instructions at an odd address,
and the emulators in use execute such code silently -- every test passes
and the unit faults at the first call. This check reads a finished octabam
build and refuses it then.

Run it in the octabam checkout that built the image, with octabam's Python
(it reads the remix through octabam's own registry), after `make bus` or
`make image`:

    .venv/bin/python3 modules/synth/upstream/tools/align_check.py [--remix NAME] [--octabam DIR]

The remix defaults to the one out/mainos_bus.remix names (the last build);
the check refuses an out/ tree whose bus is not that remix's.

What it checks, for every module of the remix:
  1. LINKED UNITS (schema.Linked: the DRAM units of the platform runtime and
     the ROM-placed units) and SOURCE CAVES (CavePatch.source): each is
     assembled again with line rows (--gdwarf-2: one row per source line
     that emits an instruction, none for data directives), with the same
     CPU, `remix.inc` (the unit's `include`, generated again from the
     registry) and defsym values the build used (read back from the build's
     objects), and linked at the same address. The bytes must be the ones
     the image carries (the runtime's raw image; a ROM unit or cave read
     from the bus), or the check stops (exit 2): the rows then describe
     exactly the code that ships. With line rows GNU as itself refuses an
     opcode at an odd address ("unaligned opcodes detected in executable
     segment") and names the label; every row is checked even as well. A
     code symbol is a symbol at a row.
  2. TRANSFERS the build wrote into the bus: every Detour (jmp / jsr / lea
     abs.l at its site), SymbolRef (the u32 at its address), cave hook
     (jsr at hook_addr) and Poke that writes a jmp / jsr abs.l or a pointer
     into a checked unit's code: the target must be even, and a jmp / jsr
     into a checked unit must land on an instruction row.

Exit status 0 = clean, 1 = an odd address (listed), 2 = cannot check.
Needs m68k-elf-as / ld / objcopy / objdump / nm on PATH.
"""
import argparse, hashlib, pathlib, re, subprocess, sys, tempfile

ODD_AS = ("unaligned opcodes", "aligned to odd boundary")


def run(args, cwd=None):
    return subprocess.run([str(a) for a in args], cwd=cwd, capture_output=True, text=True)


def must(args, cwd=None):
    r = run(args, cwd)
    if r.returncode:
        sys.stderr.write(f"align_check: {args[0]} failed\n{r.stderr[-3000:]}\n")
        sys.exit(2)
    return r.stdout


def nm(path):
    """[(address, type, name)] of every symbol, undefined ones with address None."""
    out = []
    for line in must(["m68k-elf-nm", path]).splitlines():
        f = line.split()
        if len(f) == 3:
            out.append((int(f[0], 16), f[1], f[2]))
        elif len(f) == 2 and f[0] == "U":
            out.append((None, "U", f[1]))
    return out


def text_start(elf):
    m = re.search(r"\.text\s+[0-9a-f]+\s+([0-9a-f]+)", must(["m68k-elf-objdump", "-h", elf]))
    return int(m.group(1), 16)


def rows_of(elf):
    """Addresses that start an instruction line (DWARF line rows)."""
    rows = set()
    for line in must(["m68k-elf-objdump", "--dwarf=decodedline", elf]).splitlines():
        if line.startswith(("File name", "CU:", "Contents", "Decoded")):
            continue
        c = line.split()
        if len(c) >= 3 and re.fullmatch(r"0x[0-9a-f]+|0", c[2]):
            rows.add(int(c[2], 16))
    return rows


def assemble(src, cpu, inc, asdefs, obj, cwd, what):
    """Assemble with line rows. None when it assembles; a FAIL text when GNU as
    refuses an opcode at an odd address; exit 2 on any other error."""
    args = ["m68k-elf-as", f"-mcpu={cpu}", "--gdwarf-2", *(["-I", inc] if inc else [])]
    args += [x for n, v in asdefs for x in ("--defsym", f"{n}=0x{v:x}")]
    r = run(args + ["-o", obj, src], cwd)
    if r.returncode == 0:
        return None
    odd = [l.split("Warning: ", 1)[-1] for l in r.stderr.splitlines() if any(s in l for s in ODD_AS)]
    if odd:
        return (f"{what} ({src}): code at odd addresses -- GNU as names {len(odd)}:\n"
                + "\n".join("    " + x for x in odd[:100]))
    sys.stderr.write(f"align_check: m68k-elf-as failed on {src}\n{r.stderr[-3000:]}\n")
    sys.exit(2)


def defsym_values(obj, names):
    """The values the build gave `names` (--defsym), read back from its object."""
    have = {n: a for a, t, n in nm(obj) if t in "aA" and a is not None}
    return tuple((n, have[n]) for n in names if n in have)


def link_defsyms(objs, elf):
    """--defsym pairs for the names the objects leave undefined, valued as the
    build's linked ELF has them."""
    defined, undef = set(), set()
    for o in objs:
        for a, t, n in nm(o):
            (undef if t == "U" else defined).add(n)
    have = {n: a for a, t, n in nm(elf) if a is not None}
    return [(n, have[n]) for n in sorted(undef - defined) if n in have]


def nearest(syms, addr):
    best = None
    for a, n in syms:
        if a <= addr and (best is None or a > best[0]) and not n.startswith(".L"):
            best = (a, n)
    return "?" if best is None else (best[1] if best[0] == addr else f"{best[1]}+{addr - best[0]}")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--octabam", default=".", help="the octabam checkout that built the image (default .)")
    ap.add_argument("--remix", help="the remix built (default: out/mainos_bus.remix's)")
    ap.add_argument("-v", "--verbose", action="store_true", help="one line per linked object")
    a = ap.parse_args()
    ob = pathlib.Path(a.octabam).resolve()
    sys.path.insert(0, str(ob / "tools"))
    sys.path.insert(0, str(ob / "tools" / "build"))
    from remix import registry                       # octabam's
    from dsp_modmap import BASE                      # the bus's load address
    bus_p, tag = ob / "out/mainos_bus.bin", ob / "out/mainos_bus.remix"
    if not bus_p.exists() or not tag.exists():
        print("align_check: no out/mainos_bus.bin / .remix -- build first (make bus)")
        sys.exit(2)
    bus = bus_p.read_bytes()
    built, built_sha = (tag.read_text().split() + ["", ""])[:2]
    name = a.remix or built
    if name != built or hashlib.sha256(bus).hexdigest() != built_sha:
        print(f"align_check: out/ holds remix {built!r} (bus sha256 {built_sha[:16]}), not a build of "
              f"{name!r} -- build it first")
        sys.exit(2)
    remix = registry.remix(name)
    mods = registry.modules()
    sel = [mods[k] for k in remix.modules]
    fails, notes = [], []
    code = []                       # (lo, hi, rows, symbols, what): every checked unit's code
    with tempfile.TemporaryDirectory(prefix="align_check_") as tmp:
        tmp = pathlib.Path(tmp)
        # ---- 1a. the platform runtime: every DRAM unit, one link ---------
        dram = [(m, u) for m in sel for u in getattr(m, "linked", ()) if u.dram]
        rt = ob / "out/platform/runtime"
        if dram:
            objs, origs = [], []
            for i, (m, u) in enumerate(dram):
                orig = rt / f"{i:02d}_{u.label}.o"
                if not orig.exists():
                    print(f"align_check: {orig} missing -- not this remix's build")
                    sys.exit(2)
                origs.append(orig)
                inc = None
                if u.include is not None:
                    d = tmp / f"{i:02d}_{u.label}.inc"
                    d.mkdir()
                    (d / "remix.inc").write_text(u.include({k: mods[k] for k in remix.modules}))
                    inc = str(d)
                obj = tmp / f"{i:02d}_{u.label}.o"
                f = assemble(ob / u.source, "54455", inc, defsym_values(orig, [n for n, _ in u.defsyms]),
                             obj, rt, f"{m.key} {u.label}")
                if f:
                    fails.append(f)
                objs.append(obj)
            if not fails:
                elf, raw = tmp / "runtime.elf", tmp / "runtime.bin"
                base = text_start(rt / "runtime.elf")
                must(["m68k-elf-ld", f"-Ttext=0x{base:x}",
                      *[f"--defsym={n}=0x{v:x}" for n, v in link_defsyms(origs, rt / "runtime.elf")],
                      "-o", elf, *objs])
                must(["m68k-elf-objcopy", "-O", "binary", elf, raw])
                if raw.read_bytes() != (rt / "runtime.bin").read_bytes():
                    print("align_check: the DRAM units assembled with line rows do not link to the build's "
                          "runtime.bin -- cannot check this build")
                    sys.exit(2)
                syms = sorted((ad, n) for ad, t, n in nm(elf) if ad is not None and t in "tT")
                code.append((base, base + raw.stat().st_size, rows_of(elf), syms,
                             f"platform runtime ({len(dram)} DRAM units)"))
        # ---- 1b. ROM-placed linked units and source caves ----------------
        rom = [(m, u, ob / "out/linked" / m.name / u.label, u.cpu, (), u.include)
               for m in sel for u in getattr(m, "linked", ()) if not u.dram]
        rom += [(m, c, ob / "out/linked/caves" / re.sub(r"\W+", "_", c.label), c.cpu, (".text",), None)
                for m in sel for c in getattr(m, "cf_patches", ()) if c.source]
        for m, u, work, cpu, sections, include in rom:
            if not (work / "u.elf").exists():
                notes.append(f"{m.key} {u.label}: no linked object in out/ (written as pinned bytes) -- unchecked")
                continue
            inc = None
            if include is not None:
                d = tmp / f"rom_{u.label}.inc"
                d.mkdir()
                (d / "remix.inc").write_text(include({k: mods[k] for k in remix.modules}))
                inc = str(d)
            obj, elf, raw = tmp / f"rom_{u.label}.o", tmp / f"rom_{u.label}.elf", tmp / f"rom_{u.label}.bin"
            f = assemble(ob / u.source, cpu, inc, defsym_values(work / "u.o", [n for n, _ in u.defsyms]),
                         obj, None, f"{m.key} {u.label}")
            if f:
                fails.append(f)
                continue
            at = text_start(work / "u.elf")
            must(["m68k-elf-ld", f"-Ttext=0x{at:x}",
                  *[f"--defsym={n}=0x{v:x}" for n, v in link_defsyms([work / "u.o"], work / "u.elf")],
                  "-o", elf, obj])
            must(["m68k-elf-objcopy", "-O", "binary", *[x for s in sections for x in ("-j", s)], elf, raw])
            b = raw.read_bytes()
            if bus[at - BASE:at - BASE + len(b)] != b:
                print(f"align_check: {m.key} {u.label} assembled with line rows is not the bus's bytes at "
                      f"0x{at:08x} -- cannot check this build")
                sys.exit(2)
            syms = sorted((ad, n) for ad, t, n in nm(elf) if ad is not None and t in "tT")
            code.append((at, at + len(b), rows_of(elf), syms, f"{m.key} {u.label}"))
        # ---- 1c. every row even ------------------------------------------
        for lo, hi, rows, syms, what in code:
            odd = sorted(r for r in rows if r & 1)
            if odd:
                fails.append(f"{what}: {len(odd)} instruction(s) at odd addresses:\n"
                             + "\n".join(f"    0x{r:08x} ({nearest(syms, r)})" for r in odd[:100]))
        # ---- 2. the transfers in the bus ---------------------------------
        def rd(addr, n):
            return bus[addr - BASE:addr - BASE + n]

        def into(t):
            for lo, hi, rows, syms, what in code:
                if lo <= t < hi:
                    return rows, syms, what
            return None

        transfers = []
        for m in sel:
            for d in getattr(m, "detours", ()):
                w = rd(d.site, 6)
                kind = {b"\x4e\xf9": "jmp", b"\x4e\xb9": "jsr"}.get(w[:2], d.kind)
                transfers.append((kind, d.site, int.from_bytes(w[2:], "big"), f"{m.key} detour {d.unit}:{d.symbol}"))
            for r in getattr(m, "symbol_refs", ()):
                transfers.append(("ref", r.addr, int.from_bytes(rd(r.addr, 4), "big"),
                                  f"{m.key} symbol ref {r.unit}:{r.symbol}"))
            for c in getattr(m, "cf_patches", ()):
                if c.hook_addr is not None:
                    w = rd(c.hook_addr, 6)
                    transfers.append(("jsr", c.hook_addr, int.from_bytes(w[2:], "big"), f"{m.key} cave hook {c.label}"))
            for p in getattr(m, "pokes", ()):
                w = rd(p.addr, len(p.write))
                for o in range(0, len(w) - 5):
                    if (p.addr + o) % 2 == 0 and w[o:o + 2] in (b"\x4e\xf9", b"\x4e\xb9"):
                        transfers.append(({b"\x4e\xf9": "jmp", b"\x4e\xb9": "jsr"}[w[o:o + 2]], p.addr + o,
                                          int.from_bytes(w[o + 2:o + 6], "big"), f"{m.key} poke {p.note}"))
                if len(w) == 4 and p.addr % 2 == 0 and into(int.from_bytes(w, "big")):
                    transfers.append(("ptr", p.addr, int.from_bytes(w, "big"), f"{m.key} poke {p.note}"))
        bad = []
        for kind, at, t, what in transfers:
            if t & 1:
                bad.append(f"    {kind} 0x{at:08x} -> 0x{t:08x}: ODD target ({what})")
                continue
            hit = into(t)
            if hit and kind in ("jmp", "jsr") and t not in hit[0]:
                bad.append(f"    {kind} 0x{at:08x} -> 0x{t:08x} ({nearest(hit[1], t)} in {hit[2]}): "
                           f"not the start of an instruction ({what})")
        if bad:
            fails.append(f"{len(bad)} bad transfer target(s):\n" + "\n".join(bad[:200]))
    for n in notes:
        print("align_check: note -- " + n)
    if fails:
        print(f"align_check: FAIL -- remix {name} (bus sha256 {built_sha[:16]}): ColdFire address error on a unit")
        print("\n".join("  " + f for f in fails))
        sys.exit(1)
    if a.verbose:
        for lo, hi, rows, syms, what in code:
            print(f"  0x{lo:08x}..0x{hi:08x} {what}: {len(rows):,} rows, "
                  f"{sum(1 for ad, _n in syms if ad in rows):,} code symbols")
    nrows = sum(len(c[2]) for c in code)
    ncode = sum(sum(1 for ad, _n in c[3] if ad in c[2]) for c in code)
    print(f"align_check: ok -- remix {name} (bus sha256 {built_sha[:16]}): {nrows:,} instruction rows "
          f"({ncode:,} at a code symbol) in {len(code)} linked objects, all even; {len(transfers)} detour / "
          f"symbol-ref / hook / poke targets even, every jmp / jsr into them on an instruction")
    sys.exit(0)


if __name__ == "__main__":
    main()
