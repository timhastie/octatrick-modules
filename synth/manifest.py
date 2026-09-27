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
0x40004008) -- and since OCTATRICK2.8 the STATIC entry 0x400d6434 (the same
stock renderer) -- is repointed to sy_render, which, on a sample track with
LEG MONO and GLIDE, slides the record's PTCH word toward its target before
the stock call (poly.s sy_sample; a sample START snaps), and, for a synth track,
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
PTCH RATO INDX FINE FDBK DEC, whose title makes the footer read FM SYNTH>FLEX,
whose formatters print the ratio table's value, 0..127 and HOLD/ms/s, and
whose widgets draw the M->C operator diagram, a sideband spectrum, the
modulator with its feedback loop and the index envelope over the stock dial.
THE TUNING SYSTEM (27 Sep 2026): on a synth track PTCH is semitones, raw 64
= 0, one unit a semitone, -64..+63 (the clone's range 0..127, a signed whole
number on the page, the plain one-a-detent knob handler), and RATE is FINE,
-64..+63 cents (raw 64 = 0, printed "+12c", default 64); the engine (poly.s
sy_word) reads both so and folds any pitch into the stock curve by octaves.
The quantizer module follows the same units on synth tracks (its PTCH knob,
p-lock and CHROMATIC key hooks; the CHROMATIC octave runs -4..+4 there).
Sample tracks are untouched.
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

MIDI IN (30 Sep 2026, poly.s "MIDI IN"): MIDI notes into a synth track
behave like the panel keys. The STANDARD note map's chromatic block
(0x4000e6e2; AUDIO NOTE IN = STANDARD, or FOLLOW TM in the TRACKS trig
mode) posted a voice command and a PTCH lock byte per listening track with
no identity: the engine took every note as a sequencer trig. Five detours,
synth tracks only, sample tracks byte for byte stock: the voice command
0x4000e746 (po_mon: raw = note - 20, semitones, 84 = 0, 20..127 = -64..+43,
0..19 clamp, stored as the lock byte before the START; the note joins the track's held-note list, its (identity 0x80
| note, raw) is queued for the engine's START, which starts one voice per
queued note-on at its own pitch with the engine's key rules -- "----": one
voice a note, VOIC the polyphony, a repeated note-on absorbed; a shape:
chord memory), the note-off's compare 0x4000dfd4 and its octave switch 0x4000de10 (po_moff, po_mogate: the note leaves
the list; a paraphonic track releases that note's voice alone and only the
last note's release posts the stock AMP release), the octave switch
0x4000e452 (po_mgate: a note outside 72..96 whose channel addresses a
synth track goes to the chromatic block for the channel's synth tracks
alone; the STANDARD functions of 24..71 do not run for such a channel),
the 0x41 event's live recorder 0x400625e0 (po_mrec: the note goes through
po_keyrec as a key of its own -- fingered chords from a MIDI keyboard are
recognised and locked as PTCH / CHRD / VOIC on the first note's step; a
single note records its trig and a PTCH lock in semitones) and its
trig-held branch 0x4006262a (po_mtrig: the held trig's PTCH lock in
semitones). Velocity is ignored (stock keeps none for audio tracks), MIDI
note OUT and the panel keys are untouched; FOLLOW TM with the CHROMATIC
trig mode is the key handler's own path (key = note - 72, 25 keys) and is
unchanged.

TRANSPOSING A HELD STEP (4 Oct 2026). FUNC + UP / DOWN with a [TRIG] key
held for locking on a synth track in GRID RECORDING (any trig mode: the
keys edit steps whatever the mode there) moves every held step's PTCH lock
an octave (12 semitones) up or down, clamped -64..+63, a step without a
lock starting from the Part's PTCH; one detour at the trig-mode selector's
window test 0x40051fce (po_octave), which stores as the lock editor does
and redraws the page. No trig held, a sample track, GRID RECORDING off:
the selector, byte for byte.

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

# The kind table: kind -> renderer, 8 longs at 0x400d6434 (0 STATIC, 1 FLEX,
# 2 THRU, 3 NEIGHBOR, 4 PICKUP). STATIC and FLEX share the stock sample
# renderer 0x40004008; both entries point at sy_render since OCTATRICK2.8
# (the STATIC one for the pitch slides of poly.s sy_sample; no marker scan
# on a STATIC track, whose voice is always a sample). PICKUP keeps stock's.
KIND_TABLE_STATIC = 0x400d6434
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
# MIDI IN (30 Sep 2026, poly.s "MIDI IN"): the STANDARD map's chromatic block
# and the note-off, the octave switch of the audio-track note-on, and the 0x41
# event handler's live recorder (docs/firmware/MIDI.md appendix B).
MIDI_MAP_HOOK = 0x4000e746               # `moveq #29,%d1; movel %d1,%a5@(0,%d2:l:4)`: the START, posted before the lock byte
MIDI_MAP_STOCK = bytes.fromhex("721d" "2b812c00")
MIDI_OFF_HOOK = 0x4000dfd4               # `mvsb %a0@,%d1; mvsb %a3@,%d0; cmpl %d1,%d0; bnes 0x4000dff8`
MIDI_OFF_STOCK = bytes.fromhex("7310" "7113" "b081" "661c")
MIDI_GATE_HOOK = 0x4000e452              # `movel %d6,%d0; subql #2,%d0; moveq #5,%d2; cmpl %d0,%d2`
MIDI_GATE_STOCK = bytes.fromhex("2006" "5580" "7405" "b480")
MIDI_OFFGATE_HOOK = 0x4000de10           # `subql #2,%d0; moveq #5,%d3; cmpl %d0,%d3` (the note-off's octave switch)
MIDI_OFFGATE_STOCK = bytes.fromhex("5580" "7605" "b680")
MIDI_REC_HOOK = 0x400625e0               # `movel %a2@(4),%d0; movel %d0,0x46c7e956`
MIDI_REC_STOCK = bytes.fromhex("202a0004" "23c046c7e956")
MIDI_TRIG_HOOK = 0x4006262a              # `mvsb %a2@(2),%d2; moveal %d2,%a0; lea %a0@(0,%d2:l:4),%a0`
MIDI_TRIG_STOCK = bytes.fromhex("752a0002" "2042" "41f02c00")
# LEG (2 Oct 2026): the AMP SETUP window (FUNC + AMP) stages, draws and edits
# the STOCK AMP descriptor by address; five detours hand every audio track the
# clone with LEG in the sixth box (poly.s po_amp_desc: OFF / MONO / POLY on a
# synth track, OFF / MONO on any other audio track since 3 Oct 2026; the
# master track keeps the stock record).
AMP_STAGE_HOOK = 0x40059d56              # `pea 0x400d3988` (the window's staging of page 2)
AMP_STAGE_STOCK = bytes.fromhex("4879400d3988")
AMP_DRAW1_HOOK = 0x4003685a              # `lea 0x400d39c2,%a4; lea 0x400d3a6a,%a3` (the drawer: names, formatters)
AMP_DRAW1_STOCK = bytes.fromhex("49f9400d39c2" "47f9400d3a6a")
AMP_DRAW2_HOOK = 0x400368ac              # `movel 0x400d3b16,%sp@-; movel 0x400d3b12,%sp@-` (the enable pair, the widget pass)
AMP_DRAW2_STOCK = bytes.fromhex("2f39400d3b16" "2f39400d3b12")
AMP_DRAW3_HOOK = 0x40036946              # the same pair, the name pass
AMP_DRAW3_STOCK = AMP_DRAW2_STOCK
AMP_EDIT_HOOK = 0x4003ae40               # `addil #0x400d3988,%d0; moveal %d0,%a1; moveal %a1@(298),%a0` (the page-2 editor's handler read)
AMP_EDIT_STOCK = bytes.fromhex("0680400d3988" "2240" "2069012a")
AMP_LANE_HOOK = 0x4003af0a               # `lea 0x8000083c,%a0; moveb %d2,%a0@(0,%d0:l)` (the page-2 editor's live-lane write)
AMP_LANE_STOCK = bytes.fromhex("41f98000083c" "11820800")
# Transposing a held step (4 Oct 2026, poly.s po_octave): the FUNC + UP/DOWN
# handler 0x40051fc4 (the trig-mode selector; both keys' records in the FUNC
# layer's tables 0x400bf628 / 0x400bf2b4 name it) tests its window here.
OCT_HOOK = 0x40051fce                    # `tstl 0x400bebae` (the selector window's handle: closed, a press opens it; open, presses step the mode)
OCT_STOCK = bytes.fromhex("4ab9400bebae")

# The FM voice engine is a DRAM unit since 24 Sep 2026 (poly.s, the
# paraphonic engine): linked into the platform runtime at the base of the
# arena reserve, depacked by the loader at boot; the kind table's FLEX entry
# is rewritten to its sy_render by a SymbolRef (the pointer's stock value
# asserted first). synth.s, the ROM cave it replaced, is kept for the record.
# ---- phase 3: the page (modules/synth/page.s) ----------------------------------
# The PLAYBACK page presents the synth: a detour in the page-descriptor
# resolver (0x40031da4, the kind-0 `tbl[machine]` load at 0x40031ece) returns a
# runtime clone of the FLEX descriptor -- names PTCH RATO INDX FINE FDBK DEC, the title
# "FM SYNTH" (the footer reads FM SYNTH>FLEX), formatters (the ratio table's
# value, 0..127, HOLD/ms/s), widgets that draw the operator diagram, the
# sideband spectrum, the feedback loop and the index envelope over the stock
# dial -- when the current track's assigned FLEX sample is named FMSYNTH* (or SYNTH*).
# The clone itself is built at runtime by poly.s (po_pgdesc, first use) from
# the stock record in the image plus the override list in page.s; the cave
# carries no stock bytes. Pinned at the second zero run: the override list
# holds absolute pointers into the cave. One 6-byte poke (`movel
# %a0@(0,%d0:l:4),%d0; bras` -> `jmp pg_resolve`).
PAGE_AT = 0x400d24d0
PAGE_LEN = 1812
RESOLVER_HOOK = 0x40031ece
RESOLVER_STOCK = bytes.fromhex("20300c00" "6002")
# Ratified bytes: page.s with m68k-elf-as -mcpu=5475, linked at PAGE_AT (26 Sep 2026: the
# runtime clone -- 1,672 B, down from 1,948: the 402-byte copy of the stock descriptor is gone,
# and the "%d" formatter is the stock's own; 27 Sep 2026: 1,800 B with the tuning system's
# PTCH and FINE formatters and the range / handler overrides; 30 Sep 2026: 1812 B, the
# FMSYNTH* marker name -- a leading "FM" is skipped before the SYNTH compare).
PINNED_PAGE = bytes.fromhex(
    "20300c000c80400d31ae6600008e243c000018b24c012800d4892803e58cd883"
    "d4842042d1fc0008f04b75900c820000007f62000066283c000004484c024800"
    "0684100b14f020442248283c000000ff7b98670000140c850000002f66000004"
    "224853846600ffea3a3c464dba5166000004548941fa002a78057b987599ba82"
    "6600001853846600fff22079400d64382068fffc43fa00124e904ef940031ed6"
    "53594e544800000000090009400d25d8001c001e400d25e100610001400d25ff"
    "006a0004400d2600009a0004400d260400ca0018400d260800fe0008400d2620"
    "010a0008400d2628012a0004400d260001360004400d2600018e0004400d2630"
    "ffff000000000000464d2053594e5448005241544f0000494e4458000046494e"
    "4500004644424b0000444543000000400000000000000080400d2634400d267a"
    "4003c178400d26604003c178400d26fc400d2794400d279a400d27a0400d27a6"
    "55551551202f000804800000004041fa03996e00000841f9400b465d2f002f08"
    "2f2f000c4eb940013a084fef000c4e75202f000804800000004041fa03716e00"
    "ffdc41fa036e6000ffd42f02202f000ce48802800000001f41fa036e73f00a00"
    "2001e0880281000000ff74644c021000e0896700003e0c81000000326700001c"
    "2f012f00487a030a2f2f00144eb940013a084fef0010600000302f00487a02fa"
    "2f2f00104eb940013a084fef000c600000182f004879400b465d2f2f00104eb9"
    "40013a084fef000c241f4e752f02202f000c6700007c22004c001000203c0000"
    "07d04c010000068000001f80223c00003f014c4100000c80000003e86400001c"
    "2f004879400b465d2f2f00104eb940013a084fef000c60000048223c000003e8"
    "24004c41200272644c4100002202e789d282d28290812f002f02487a02612f2f"
    "00144eb940013a084fef001060000012487a02522f2f000c4eb940013a08508f"
    "241f4e7570006000001470016000000e7002600000087003600000024fefffd4"
    "48d77cfc2e002f2f00482f2f00482f2f00482f2f00482f2f00482f2f00482f2f"
    "00484eb9400479b44fef001c202f004008000001660001902c2f003c4a876700"
    "00125387670000185387670000b2600000c841fa02d0610001786000012641fa"
    "03906100016c220670034c001000707f4c401001740b94817008720161000174"
    "2406700a4c002000707f4c40200267000012700672016100015a700a72016100"
    "015224060482000000146f00002270084c002000706b4c402002670000127004"
    "72016100012e700c72016100012624060482000000386f0000aa70064c002000"
    "70474c4020026700009a7002720161000102700e7201610000fa6000008641fa"
    "0268610000cc4a866700007841fa029e610000ce6000006c41fa02d6610000b2"
    "70017201740b610000ca2a3c00007fff4a86670000122a06700d4c005000707f"
    "4c4050055485780b7e0224075382e98a4c4520020c82000000106f0000047410"
    "41fa00d475b02800264220072202240461000080280b52870c870000000f6f00"
    "ffca202f0040080000006700001841fa0150701022100a81fff0000020c15380"
    "6c00fff2202f00345e802f00202f003452802f002f2f0050487a00ce4eb94001"
    "28a84fef00104cd77cfc4fef002c4e7543fa010e701022d853806c00fffa4e75"
    "43fa00fe70102218839953806c00fff84e7541fa00ec41f00c00263c80000000"
    "e2ab8790e28b5281b4816c00fff64e7525642e253032640025642e350025642e"
    "25647300484f4c44002b2564002b25646300256463000b090706050403030202"
    "01010101010101000040008000c0010001030140016a018001c0020002030280"
    "03000380040004030480050005800600068007000780080009000a000b000c00"
    "0d000e000f001000000000110000000d00000001400d2a90400d2a4cfff80000"
    "fff80000fff80000fff80000fff80000fff80000fff80000fff80000fff80000"
    "fff80000fff80000fff80000fff80000fff80000fff80000fff80000fff80000"
    "0000000000000000000000000000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000000000000000000000000000"
    "0000000000000000000000003f80000020800000208000003f80000004000000"
    "04000000150000000e000000040000003f80000020800000208000003f800000"
    "000000000000000000000000000000000000000000000000000000003f800000"
    "20800000208000002080000020800000208000003f8000000000000000000000"
    "000000000000000000000000000000000000000007f000000e10000004100000"
    "0010000000100000001000000010000000100000001000000010000004100000"
    "07f0000000000000000000000000000000000000800000008000000080000000"
    "8000000080000000800000008000000080000000800000008000000080000000"
    "8000000080000000800000008000000000000000"
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
        "FDBK/DEC with icons and the title FM SYNTH; PTCH is semitones (-64..+63) "
        "and RATE is FINE (cents) on a synth track. A FLEX or STATIC sample track "
        "with LEG MONO and GLIDE slides its pitch (2.8).",
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
                  "samples become the FM voice; a sample's PTCH slides with LEG MONO + GLIDE)"),
        SymbolRef(KIND_TABLE_STATIC, int.from_bytes(STOCK_RENDERER, "big"), "poly", "sy_render",
                  "kind table STATIC renderer -> sy_render too (2.8: a STATIC sample's PTCH slides "
                  "with LEG MONO + GLIDE; no marker scan, the stock call otherwise)"),
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
        Detour(MIDI_MAP_HOOK, MIDI_MAP_STOCK, "poly", "po_mon",
               "MIDI IN note-on (the STANDARD map's chromatic block): a synth track's PTCH raw is note - 20 (semitones, 84 = 0), stored before the START, and the note is posted to the engine as a key of its own",
               kind="jmp"),
        Detour(MIDI_OFF_HOOK, MIDI_OFF_STOCK, "poly", "po_moff",
               "MIDI IN note-off: a paraphonic synth track releases that note's voice alone; the last note's release posts the stock AMP release",
               kind="jmp", pad_to=8),
        Detour(MIDI_GATE_HOOK, MIDI_GATE_STOCK, "poly", "po_mgate",
               "MIDI IN note gate: a note outside 72..96 addressed to a synth track plays it chromatically (20..127 = -64..+43 semitones)",
               kind="jmp", pad_to=8),
        Detour(MIDI_OFFGATE_HOOK, MIDI_OFFGATE_STOCK, "poly", "po_mogate",
               "MIDI IN note-off gate: a note outside 72..96 addressed to a synth track reaches the chromatic note-off (po_moff)",
               kind="jmp"),
        Detour(MIDI_REC_HOOK, MIDI_REC_STOCK, "poly", "po_mrec",
               "MIDI IN live recorder (the 0x41 event): a synth track's note records through po_keyrec (fingered chords; the PTCH lock in semitones)",
               kind="jmp", pad_to=10),
        Detour(MIDI_TRIG_HOOK, MIDI_TRIG_STOCK, "poly", "po_mtrig",
               "MIDI IN with a trig held: a synth track's held trig gets its PTCH lock in semitones",
               kind="jmp", pad_to=8),
        Detour(OCT_HOOK, OCT_STOCK, "poly", "po_octave",
               "FUNC + UP/DOWN (the trig-mode selector): with a trig held on a synth track in GRID RECORDING, any trig mode, "
               "the held steps' PTCH lock moves an octave instead (no trig held, a sample track, GRID RECORDING off: the selector)",
               kind="jmp"),
        Detour(AMP_STAGE_HOOK, AMP_STAGE_STOCK, "poly", "po_ampstage",
               "AMP SETUP window (FUNC + AMP) staging: an audio track stages the AMP clone whose sixth box is LEG (OFF / MONO / POLY on a synth track, OFF / MONO on a sample track; the master track stock)",
               kind="jmp"),
        Detour(AMP_DRAW1_HOOK, AMP_DRAW1_STOCK, "poly", "po_ampdraw1",
               "AMP SETUP drawer: the page-2 names and formatters from the clone on an audio track",
               kind="jmp", pad_to=12),
        Detour(AMP_DRAW2_HOOK, AMP_DRAW2_STOCK, "poly", "po_ampdraw2",
               "AMP SETUP drawer: the enable nibbles from the clone (the widget pass)",
               kind="jmp", pad_to=12),
        Detour(AMP_DRAW3_HOOK, AMP_DRAW3_STOCK, "poly", "po_ampdraw3",
               "AMP SETUP drawer: the enable nibbles from the clone (the name pass)",
               kind="jmp", pad_to=12),
        Detour(AMP_EDIT_HOOK, AMP_EDIT_STOCK, "poly", "po_ampedit",
               "AMP page-2 editor: slot 11 of an audio track steps LEG 0..2 (synth) or 0..1 (sample) (po_legknob); the Part byte and its battery-RAM shadow as stock writes them",
               kind="jmp", pad_to=12),
        Detour(AMP_LANE_HOOK, AMP_LANE_STOCK, "poly", "po_amplane",
               "AMP page-2 editor's live-lane write: a synth track's LEG never reaches the lane (the DSP's copy reads 0)",
               kind="jmp", pad_to=10),
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
