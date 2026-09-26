"""SYNTH MACHINE -- phases 2+3: a FLEX track whose sample is named SYNTH* plays a
two-operator FM voice instead of the sample. The ColdFire generates the
track's SOURCE sample data every frame, at the track's final pitch, and the
DSP does the rest exactly as for a sample -- RATE, the AMP envelope, filter,
FX1/FX2, level, pan, mute, cue -- while PTCH (with locks, LFOs, scenes,
chromatic keys, the quantizer) is folded into the voice's own phase
increments with the stock renderer's rate arithmetic. Nothing changes for a
track whose sample is not named SYNTH*.

THE VOICE: carrier = sin(phi_c + INDEX * sin(phi_m + FEEDBACK * m_prev)),
phi_m at RATIO times the pitch. The FLEX PLAYBACK page's other slots are its
parameters, read per frame from the DSP parameter record (halfwords, raw <<
8): STRT = RATIO (32-step table 0.25..16), LEN = INDEX (0..8 rad), RTRG =
FEEDBACK (0..0.25 cycle), RTIM = DECAY of the index toward 1/16 (time
constant 2 s * (raw/127)^2; 0 = hold). Phase 3 relabels the slots.

WHERE IT HOOKS. The per-frame record packer (0x4000d3fc) renders each track's
audio through a per-track renderer pointer copied from the kind table
0x400d6434 (kind = machine type; 0 STATIC, 1 FLEX, 2 THRU, 3 NEIGHBOR,
4 PICKUP, 5-7 silent). The FLEX entry 0x400d6438 (stock: the sample renderer
0x40004008) is repointed to the cave's sy_render, which, for a synth track,
writes PTCH := 0 semitones and RATE := 1.0 into the record around the stock
call (so the voice lifecycle, streaming, positions and the record's headers
stay stock's, at 16 source samples a frame), restores them, clears the retrig
count the packer latched at a voice start (RTRG is FEEDBACK, not a retrig),
and overwrites the source pairs the stock renderer shipped. One 4-byte poke,
no displaced instructions.

THE MARKER. The voice struct (0x800049d8 + 0xa8 * track) holds the slot's
settings record at +8 (0x100b14f0 + 0x448 * slot, its path string at +0);
on the frame a voice starts (bit 4 of 0x46104d0c + track, the packer's
event byte) the file name after the last '/' is compared with "SYNTH" and
the result cached per track. Any WAV named SYNTH*.wav in any FLEX slot is
the machine; sample locks choose it per step. A stock unit plays the file
itself (the shipped SYNTH.wav is silence).

THE PAGE (phase 3). The page-descriptor resolver 0x40031da4 is detoured at
its PLAYBACK-page table load (0x40031ece): for a track whose assigned FLEX
slot's sample is named SYNTH* -- by the settings record's path, loaded into
flex RAM or not -- it returns a clone of the FLEX descriptor whose slots read
PTCH RATO INDX RATE FDBK DEC, whose title makes the footer read FM SYNTH>FLEX,
whose formatters print the ratio table's value, 0..127 and HOLD/ms/s, and
whose widgets draw the M->C operator diagram, a sideband spectrum, the
modulator with its feedback loop and the index envelope over the stock dial.
The clone is built AT RUNTIME, on first use, by the DRAM unit (poly.s
po_pgdesc: the stock record copied out of the image into the unit's RAM,
then the fields page.s lists -- title, the four names, four formatter and
four widget pointers, the enable nibbles -- written over the copy; the stock
record is never touched, a non-synth track gets it as before, and the flag
and buffer are zero after every boot). The pinned page cave (page.s,
0x400d24d0) holds the resolver stub, the override list, the formatters, the
widgets and the icon data, and reaches the builder through the long
published before sy_render (whose address the kind table's FLEX entry
holds) -- so no stock bytes are in the repository (26 Sep 2026; until then
page.s carried a patched copy of the 402-byte stock record). Ranges,
defaults and knob handlers are the stock record's; every other page and
every non-synth track draws as stock.

THE ENGINE IN DRAM, AND PARAPHONIC CHORDS (phase 5, 24 Sep 2026). The
voice engine is a DRAM unit now, modules/synth/poly.s (`Linked(dram=True)`:
linked into the platform runtime at the arena reserve's base, appended
behind the loader, depacked at boot; the unit gives up 10 MB of sample
memory); the kind table's FLEX entry is pointed at its sy_render by a
SymbolRef (octabam's 4-byte stock pointer rewritten to a symbol; the fork
had added a Detour of kind "ptr" for the same job). On a synth track the LFO page is always a clone
(built from the stock record on first use, a detour at the page resolver's
LFO-descriptor load) whose slot 2 is VOIC (1..4, default 1; SPD3's byte, a
stock or out-of-range byte reads 1) and slot 5 CHRD (the chord shape, "----"
while VOIC is 1); LFO 3 is muted on a synth track (two detours at the LFO
engine's depth read -- the routine and its copy inlined in the frame
builder; its default PMTR is PTCH). VOIC is the switch: 1 = the mono synth
of phase 4, bit for bit (GLIDE legato, the stock lifecycle); 2..4 = that
many voices playing the chord shape at every trig or live key, per-voice
release from the AMP REL byte, per-voice glide, live keys held together
(the quantizer's key hooks feed the engine through a pinned mailbox), every
chord note snapped onto the quantizer's SCALE (its mask through the pinned
trampoline SCALE_AT).

Verified in ot_emu through the virtual panel and the pipe (README);
flashed as OCTATRICK9 on an MKI, 26 Sep 2026 (emulator-verified since).
"""

import os

from remix.schema import CavePatch, Detour, Kind, Linked, Module, SymbolRef

# This module's own directory, relative to the build's cwd (octabam's repo
# root): "modules/synth" when the module is checked out directly, and
# "modules/synth/upstream/synth" when it is octabam's submodule of
# timhastie/octatrick-modules. Every source path below is built from it,
# so one manifest serves both layouts.
_HERE = os.path.relpath(os.path.dirname(os.path.realpath(__file__)))

# The kind table's FLEX entry: kind -> renderer, 8 longs at 0x400d6434.
KIND_TABLE_FLEX = 0x400d6438
STOCK_RENDERER = bytes.fromhex("40004008")
# Phase 5 (24 Sep 2026, poly.s): the LFO engine's depth read `mvsw %a2@(0x12,
# %d2:l:2),%d0; lea %a0@(0,%d4:l:2),%a1` (LFO 3 is muted on a synth track)
# and the page resolver's LFO-descriptor load `movel #0x400d37f6,%d0; bras
# 0x40031ed6` (the VOIC/CHRD page for a synth track).
LFO_DEPTH_HOOK = 0x40003ca4              # the routine 0x40003b90
LFO_DEPTH_HOOK2 = 0x4000d03e             # its copy inlined in the frame builder (0x4000cf40..)
LFO_DEPTH_STOCK = bytes.fromhex("71722a12" "43f04a00")
LFO_PAGE_HOOK = 0x40031e62
LFO_PAGE_STOCK = bytes.fromhex("203c400d37f6" "606c")

# The FM voice engine is a DRAM unit since 24 Sep 2026 (poly.s, the
# paraphonic engine): linked into the platform runtime at the base of the
# arena reserve, depacked by the loader at boot; the kind table's FLEX entry
# is rewritten to its sy_render by a SymbolRef (the pointer's stock value
# asserted first). synth.s, the ROM cave it replaced, is kept for the record.
# ---- phase 3: the page (modules/synth/page.s) ----------------------------------
# The PLAYBACK page presents the synth: a detour in the page-descriptor
# resolver (0x40031da4, the kind-0 `tbl[machine]` load at 0x40031ece) returns a
# runtime clone of the FLEX descriptor -- names PTCH RATO INDX RATE FDBK DEC, the title
# "FM SYNTH" (the footer reads FM SYNTH>FLEX), formatters (the ratio table's
# value, 0..127, HOLD/ms/s), widgets that draw the operator diagram, the
# sideband spectrum, the feedback loop and the index envelope over the stock
# dial -- when the current track's assigned FLEX sample is named SYNTH*.
# The clone itself is built at runtime by poly.s (po_pgdesc, first use) from
# the stock record in the image plus the override list in page.s; the cave
# carries no stock bytes. Pinned at the second zero run: the override list
# holds absolute pointers into the cave. One 6-byte poke (`movel
# %a0@(0,%d0:l:4),%d0; bras` -> `jmp pg_resolve`).
PAGE_AT = 0x400d24d0
PAGE_LEN = 1672
RESOLVER_HOOK = 0x40031ece
RESOLVER_STOCK = bytes.fromhex("20300c00" "6002")
# Ratified bytes: page.s with m68k-elf-as -mcpu=5475, linked at PAGE_AT (26 Sep 2026: the
# runtime clone -- 1,672 B, down from 1,948: the 402-byte copy of the stock descriptor is gone,
# and the "%d" formatter is the stock's own).
PINNED_PAGE = bytes.fromhex(
    "20300c000c80400d31ae66000082243c000018b24c012800d4892803e58cd883"
    "d4842042d1fc0008f04b75900c820000007f6200005a283c000004484c024800"
    "0684100b14f020442248283c000000ff7b98670000140c850000002f66000004"
    "224853846600ffea41fa002a78057b987599ba826600001853846600fff22079"
    "400d64382068fffc43fa00124e904ef940031ed653594e544800000000090009"
    "400d25b4001c000c400d25bd002e000c400d25c900ce0008400d25d800da0008"
    "400d25e000fe0008400d25e8010a0008400d25f0018e0004400d25f8ffff0000"
    "00000000464d2053594e5448005241544f0000494e445800004644424b000044"
    "4543000000000000400d25fc4003c1784003c178400d267e400d2716400d271c"
    "400d2722400d2728555515512f02202f000ce48802800000001f41fa036073f0"
    "0a002001e0880281000000ff74644c021000e0896700003e0c81000000326700"
    "001c2f012f00487a030a2f2f00144eb940013a084fef0010600000302f00487a"
    "02fa2f2f00104eb940013a084fef000c600000182f004879400b465d2f2f0010"
    "4eb940013a084fef000c241f4e752f02202f000c6700007c22004c001000203c"
    "000007d04c010000068000001f80223c00003f014c4100000c80000003e86400"
    "001c2f004879400b465d2f2f00104eb940013a084fef000c60000048223c0000"
    "03e824004c41200272644c4100002202e789d282d28290812f002f02487a0261"
    "2f2f00144eb940013a084fef001060000012487a02522f2f000c4eb940013a08"
    "508f241f4e7570006000001470016000000e7002600000087003600000024fef"
    "ffd448d77cfc2e002f2f00482f2f00482f2f00482f2f00482f2f00482f2f0048"
    "2f2f00484eb9400479b44fef001c202f004008000001660001902c2f003c4a87"
    "670000125387670000185387670000b2600000c841fa02c26100017860000126"
    "41fa03826100016c220670034c001000707f4c401001740b9481700872016100"
    "01742406700a4c002000707f4c40200267000012700672016100015a700a7201"
    "6100015224060482000000146f00002270084c002000706b4c40200267000012"
    "700472016100012e700c72016100012624060482000000386f0000aa70064c00"
    "200070474c4020026700009a7002720161000102700e7201610000fa60000086"
    "41fa025a610000cc4a866700007841fa0290610000ce6000006c41fa02c86100"
    "00b270017201740b610000ca2a3c00007fff4a86670000122a06700d4c005000"
    "707f4c4050055485780b7e0224075382e98a4c4520020c82000000106f000004"
    "741041fa00c775b02800264220072202240461000080280b52870c870000000f"
    "6f00ffca202f0040080000006700001841fa0142701022100a81fff0000020c1"
    "53806c00fff2202f00345e802f00202f003452802f002f2f0050487a00c04eb9"
    "400128a84fef00104cd77cfc4fef002c4e7543fa0100701022d853806c00fffa"
    "4e7543fa00f070102218839953806c00fff84e7541fa00de41f00c00263c8000"
    "0000e2ab8790e28b5281b4816c00fff64e7525642e253032640025642e350025"
    "642e25647300484f4c44000b0907060504030302020101010101010100400080"
    "00c0010001030140016a018001c0020002030280030003800400040304800500"
    "05800600068007000780080009000a000b000c000d000e000f00100000000011"
    "0000000d00000001400d2a04400d29c0fff80000fff80000fff80000fff80000"
    "fff80000fff80000fff80000fff80000fff80000fff80000fff80000fff80000"
    "fff80000fff80000fff80000fff80000fff80000000000000000000000000000"
    "0000000000000000000000000000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000000000000000000000000000"
    "3f80000020800000208000003f8000000400000004000000150000000e000000"
    "040000003f80000020800000208000003f800000000000000000000000000000"
    "000000000000000000000000000000003f800000208000002080000020800000"
    "20800000208000003f8000000000000000000000000000000000000000000000"
    "000000000000000007f000000e10000004100000001000000010000000100000"
    "001000000010000000100000001000000410000007f000000000000000000000"
    "0000000000000000800000008000000080000000800000008000000080000000"
    "8000000080000000800000008000000080000000800000008000000080000000"
    "8000000000000000"
)
assert len(PINNED_PAGE) == PAGE_LEN, len(PINNED_PAGE)
assert PINNED_PAGE[:4] == bytes.fromhex("20300c00")     # pg_resolve replays the table load


def emit_page(addr: int):
    """The source is the only truth for the bytes (b""); the resolver's kind-0
    table load becomes a jmp to pg_resolve (+0)."""
    assert addr == PAGE_AT, "the page cave is pinned"
    return b"", ((RESOLVER_HOOK, RESOLVER_STOCK,
                  bytes.fromhex("4ef9") + addr.to_bytes(4, "big")),)


MODULE = Module(
    name="synth",
    key="SYNTH MACHINE",
    kind=Kind.CF_PATCH,
    doc="A FLEX track whose sample is named SYNTH* plays a two-operator FM "
        "voice (STRT/LEN/RTRG/RTIM = ratio/index/feedback/decay); the DSP "
        "shapes and effects it as a sample. Its PLAYBACK page reads RATO/INDX/"
        "FDBK/DEC with icons and the title FM SYNTH.",
    linked=(
        Linked("poly", os.path.join(_HERE, "poly.s"), cpu="5475", dram=True),
    ),
    # The kind table's FLEX entry is a 4-byte data pointer, not an
    # instruction: upstream octabam's SymbolRef (a stock u32 rewritten to a
    # linked symbol, the stock value asserted first) is what the fork's
    # Detour(kind="ptr") did (ported 25 Sep 2026).
    symbol_refs=(
        SymbolRef(KIND_TABLE_FLEX, int.from_bytes(STOCK_RENDERER, "big"), "poly", "sy_render",
                  "kind table FLEX renderer -> the DRAM unit's sy_render (SYNTH*-named "
                  "samples become the FM voice)"),
    ),
    detours=(
        Detour(LFO_DEPTH_HOOK, LFO_DEPTH_STOCK, "poly", "po_lfo3",
               "LFO engine (the routine) depth read: LFO 3 reads depth 0 on a synth track",
               kind="jmp", pad_to=8),
        Detour(LFO_DEPTH_HOOK2, LFO_DEPTH_STOCK, "poly", "po_lfo3b",
               "LFO engine (the frame builder's inlined copy) depth read: the same",
               kind="jmp", pad_to=8),
        Detour(LFO_PAGE_HOOK, LFO_PAGE_STOCK, "poly", "po_lfopage",
               "page resolver LFO descriptor: a synth track gets the VOIC/CHRD clone",
               kind="jmp", pad_to=8),
    ),
    cf_patches=(
        CavePatch(
            label="synth page",
            cave_addr=PAGE_AT,                # pinned: the descriptor clone's pointers
            pinned=PINNED_PAGE,
            source=os.path.join(_HERE, "page.s"),
            emit=emit_page,
            reference=lambda addr: PINNED_PAGE,
            report_note=" (page-descriptor resolver 0x40031ece -> pg_resolve: the "
                        "PLAYBACK page of a SYNTH track reads RATIO/INDEX/FDBK/DECAY "
                        "with icons; title FM SYNTH)",
        ),
    ),
)
