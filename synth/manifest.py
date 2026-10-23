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
constant 2 s * (raw/127)^2; 127 = hold, 0 = the shortest). Phase 3
relabels the slots.

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
whose formatters print the ratio table's value, 0..127 and ms/s/HOLD, and
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
had added a Detour of kind "ptr" for the same job). Since 2.17 VOIC and CHRD occupy the PLAYBACK SETUP LOOP/SLIC
boxes; all three LFO speeds and depths remain stock. FM PMTR appends native
values 30/31 for VOIC/CHRD, applied into private words and latched at note START.
Independent FM step and scene tables resolve step > selected scene > Part
before the module LFO offset and existing cap. PMTR retains native Part-byte
storage and cannot be locked on a trig.
VOIC is the switch: 1 = the mono synth
of phase 4, bit for bit (GLIDE legato, the stock lifecycle); 2..4 = that
many voices playing the chord shape at every trig or live key, per-voice
release from the AMP REL byte, per-voice glide, live keys held together
(the quantizer's key hooks feed the engine through a pinned mailbox), every
chord note snapped onto the quantizer's SCALE (its mask through the pinned
trampoline SCALE_AT).

CLICKS AND CRACKLE (28 Sep 2026, poly.s po_fill / po_st_note / po_fade): the
peak limiter's gain and every paraphonic voice's gain ramp linearly across
the 16-sample frame from last frame's value to this frame's (the per-frame
steps were a click at each of the 8 attack frames and a beat-rate crackle
while a chord was held: Tim's MKI, 2.3 .. 2.9); a silent voice starts both
operators at phase 0 with a 16-frame (5.8 ms) attack ramp; a retriggered,
stolen or chord-memory-cut voice is phase-continuous and fades over one
frame instead of being cut. The level law is unchanged (T_GMAX = 32768 /
sqrt(VOIC), chords held at the mono voice's peak). README "Clicks and crackle".
The mono voice (VOIC 1; poly.s sy_render's marker block, sy_mono / sy_loop)
got the same treatment in the next commit: its gain ramps linearly per sample
across each render call (S_GPREV -> S_GAIN, one divs.l a call, a 16 x 16
multiply on gain / 2 -- bit for bit the old output at full gain), a 16-frame
attack (RAMP_STEP 2048), both operators at phase 0 from silence, phase-
the safety-net cut a one-frame fade. OCTATRIK11's pop on every note.
BUILD 25: T_MLEG (MIDI IN's legato flag, po_mon / po_mrec) moved +126 -> +37 --
it aliased S_LASTF's word (the warm rule's frame stamp).
BUILD 26: EVERY START IS COLD -- the warm rule (S_GPREV != 0 and S_LASTF within a
frame: keep the phases and the gain) and S_LASTF are gone; every START clears
S_PHC / S_PHM / S_LASTM / S_GAIN / S_GPREV, both operators at phase 0 and the
gain ramps from 0 over 16 frames. The DSP's AMP envelope restarts at full on the
start frame's first sample at EVERY start, so a warm start after the envelope had
released the note (a re-press, REL 20) exposed the CF's full continuous gain as a
bare step (x22 .. x25 the steady slope) and the CF cannot see that envelope (no
release event covers every path: a sequencer HOLD ends inside the DSP). A phase
reset at gain 0 is inaudible; a retrigger while sounding gets a short dip (the
normal retrigger character); LEG MONO hand-overs never START. The paraphonic
voices keep their warm rule (phase kept, gain ramped from where it is: clean).
PLAN B (28 Sep 2026, BUILD 31): THE ENGINE OWNS THE AMP ENVELOPE. On a synth
track the DSP is presented with an always-open envelope -- sy_render writes the
DSP voice record's halfwords 0/1/2 (0x80000110 + (ping << 9) + 64 t: ATK / HOLD /
REL) := 0 / 0x7f00 / 0x7f00 every synth call, after the copier, the scene morph
and the LFO stage and before the DMA, the live lane the UI shows untouched (the
shape of the PTCH / RATE override) -- and applies ATK / HOLD / REL from the live
lane itself (locks, scenes, LFOs included) with the DSP's laws as measured in
stage 1: ATK a linear ramp to full in 3.85 ms x 2^(v/8.53) (the 16-frame ramp
the floor), HOLD the DSP's timer from the START (po_hold128 steps x frames a
step; 127 = INF) for live keys and trigs alike, ending the note by itself, REL
exponential with tau = 0.295 ms x 2^(v/8.53) floored at 1 ms (a ~2 ms minimum
fade even at REL 0; 127 = INF). THE START RULE replaces BUILD 27/28's four
conditions: a voice that still sounds (S_GPREV / V_GPREV != 0) continues the
SAME oscillator phase-continuously from its current level (the attack re-runs
from there); a silent one starts at phase 0 from 0. Note ends: every note-off
path (po_rel), the HOLD timer, MIDI note-off, the key mask, the sequencer trig,
and STOP (BUILD 31's po_stop, a detour at the frame builder's consumption of
0x46c80350 taken for the sequencer's STOP word; that word is the metronome's
click, and 2.12 removes po_stop -- see BUILD 33 and 2.12 below). Voice
stealing and chord-memory cuts fade over 8 frames (2.9 ms, state 3). The
per-frame peak limiter is REMOVED: the sum is clamped (saturated) only; the
level law 1/sqrt(VOIC) is unchanged. README "The engine owns the envelope".
BUILD 32 (round 2): a START across a VOIC change never cuts the sounding tone
(VOIC 1 -> 2..4: po_carry moves the mono voice into a fading paraphonic voice;
2..4 -> 1: the voices fade over 8 frames under the mono voice, po_fade_frame /
po_fill_add); STOP ends every voice (S_ON bit 2: REL INF takes the 1 ms floor,
so the level reaches 0 and the next START is cold); T_AK moved off T_POS.
BUILD 37 (29 Sep 2026): SEQUENCER TRIGS ON A STILL-SOUNDING NOTE NO LONGER BUMP.
The frame builder's sequencer path posts a trig on a sounding track to the DSP as
the command byte 0x10 | n (the CF START bit with the trig's sub-frame position n;
0x46104d15[t], copied into the packer's nibble byte at 0x4000c642); the DSP
crossfades its old voice under the new one for ~26 samples, and since both are
the engine's one continuous stream (the warm START rule) the sum is a +5.6 dB /
1.8 ms bump at every trig (BUILD 33's take a: per-frame amplitude 1.85 1.58 1.32
1.13). The panel key's START reaches the DSP as 0x30 (bits 4 and 5, nibble 0)
and is clean. po_retrig, a detour at the copy (0x4000c634), rewrites every START
byte on a synth track whose engine voice is on (S_ON) to that clean form; the
trig lands a frame boundary early (at most 0.34 ms). Measured (BUILD 37's log,
a trig on every step at 120 BPM, VOIC 1 C4, ATK 0 HOLD INF REL 60 INDX 0): max
|step| / the tone's slope x1.01, max |d2| 9, per-frame amplitude 1.00 on every
frame of every trig, the fix fired on every trig (po_rtlog: 39 rewrites, the
bytes 0x14 0x1c 0x15 0x1d ... -> 0x30). po_rtlog (po_clock + 32) stays: 272 B
of counters and a ring, cheap and peekable.

BUILD 38 (29 Sep 2026): A WARM START RAMPS THE INDEX ENVELOPE. With a non-zero
INDX the START rule's instant restart of the FM index envelope (S_ENV / V_ENV :=
ENV_ONE while the carrier continued) was a hard step at every sequencer trig on a
sounding note (BUILD 37 take b: x7.45 the tone's slope, |d2| 4961, 2008 -> 4786
in one sample, the centroid 322 -> 498 Hz in a frame). Now sy_cold / po_st_note
arm a 16-frame ramp (S_ERAMP +81 / V_ERAMP +62): the envelope climbs linearly
from its current value to ENV_ONE in 5.8 ms (sy_env_ramp / po_fr_envk: the
remaining distance over the remaining frames), then the DEC decay runs from the
peak as before; a cold START (a silent voice) keeps the instant restart. And the
per-sample multiplier I * E is interpolated across every frame: S_IEFF / V_IEFF
are the running value, sy_loop / po_fi_loop step them by S_ISTEP (+126, the
word S_HOLD / S_KEYED held) / V_ISTEP (+38), (target - running) / 16, once a
frame -- no frame-edge step for the ramp, the decay or a knob. V_GPREV is a word
at +60. Measured (BUILD 38's log, take b: HOLD INF REL 60 INDX 40 DEC 40,
a trig every step): max |step| / the tone's slope x1.07, max |d2| 88 against
the take's own 99.9th pct 108, the centroid moving over ~8 ms.

BUILD 33 (round 3): STOP ENDS THE ENGINE'S VOICES AT THE STOCK VOICE KILL. Round 2
measured (an independent rerun's STOP log) that po_stop's site 0x4000b2c8 never runs
on the rig for any STOP form -- the global word's writers (0x4009bbb8 / 0x4009c3a0
/ 0x400a4d8c) sit behind [0x80000060] and the pattern-state bytes 0x80006511/12,
and the frame builder's consumer behind two more gates -- so a REL INF tone kept
sounding 1.1 .. 1.6 s past STOP until the stock voice ended, S_GPREV stayed at
full, and the next START after a STOP was warm at full into a re-opened DSP
voice: a click. What every UI path uses to end a stock voice HARD is the VOICE
KILL 0x40006820(t; t >= 8 = all tracks, recursing per track): the sequencer's
STOP / pattern change 0x40043c50, the sample preview stop 0x40093ec0 /
0x40096ad4, the loaders 0x4007eb3e / 0x4008044e / 0x4000f518, the frame
builder's own 0x4000d45a. po_kill is a detour at its CF voice-byte clear
0x4000685c (interrupts masked, d1 = the track): the killed track's engine
record ends at that instant -- S_GAIN / S_GPREV / S_HTIM / S_ON := 0, the four
paraphonic voices freed with V_KEY / V_HOLD 0 -- so nothing of ours sounds
after the kill and the next START is cold. po_stop stayed as belt-and-braces (a
killed track has S_ON 0: it does nothing there) -- until 2.12.
2.12 (10 Oct 2026): A HELD NOTE OR CHORD IS NO LONGER RELEASED AT EVERY METRONOME
CLICK. The global word 0x46c80350 is the METRONOME's: while the sequencer plays,
the beat code writes 3 (the bar's first beat) or 1 (the other beats), every writer
behind METRONOME_ENABLED (0x80000060 -- the gate BUILD 33 saw closed on the rig),
and the frame builder turns it into the DSP-wide click command 0x46104d14 and
clears it at 0x4000b2c8. po_stop, hooked at that clear, therefore ran at every
click and nowhere else: every synth track's mono voice took the released flag and
STOPPED (REL INF: cut within 5 ms), every sounding paraphonic voice released, while
the keys were still held. The detour and po_stop are removed; 0x4000b2c8 is
stock; STOP stays po_kill's (above).
History, BUILD 27: WARM ONLY WHEN THE DSP IS PROVABLY SUSTAINING AT FULL -- BUILD 26's
cold start made a new key while the old note still sounds (LEG OFF, HOLD INF) a
hard cut at the frame edge (a -12 dB 5 ms click). sy_cold keeps the phases and
the gain (the pitch changes, no ramp) only when (a) the HOLD the lane held at the
sounding note's START was INF (S_HOLD, +126, stored at every START, locks
applied), (b) no release reached the frame builder since (S_ON bit 1: po_rel, a
detour at the builder's mailbox-0x40 consumer 0x4000b51a, one site for the panel
release, the MIDI note-off and the sequencer; not set when the same word carries
the START, bit 2 -- the panel's key-while-held), (c) S_GPREV != 0; else cold.
BUILD 28: (d) THE START IS A LIVE KEY'S OR A MIDI NOTE'S -- a sequencer trig
STARTs the mono voice with no note-off anywhere (at HOLD INF the flag is never
set), and the DSP restarts something at each trig the CF cannot see: warm there
layered (+5.75 dB over the mono voice, a bare step a trig, BUILD 27 measured).
sy_cold reads qz_pkey[t] (KEYS_AT, the identity the quantizer posts for a
CHROMATIC key, index + 1, and po_mon for a MIDI note, 0x80 | note; 0 for a
sequencer trig -- what po_start takes as d7) before the mono path clears it,
stores it at S_KEYED (+127, the record's last byte, peekable) and the START is
warm only when it is nonzero as well; a sequencer START is always cold.
Also BUILD 26: the ramp's step a sample is (target - previous) / 16, the FRAME's
slope, and S_GPREV takes the gain the ramp reached -- a sequencer trig splits
every frame at its sub-frame offset, so dividing by the call's samples put the
frame's whole step into the short second call (a stair on every sequencer note,
103/s; BUILD 25's warm rule made those notes a bare step each, x14 .. x24).
Measured BUILD 26: onset x0.99, re-press 50 / 200 / 600 ms x1.07 / x1.02 / x1.07,
16th trigs HOLD 6 max |d2| 24 (was 4769), the retrigger while sounding a cut to
0 then the 16-frame attack (the cost, -15 dB for 6 ms); README.

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

FINE DEFAULTS TO 0c (28 Sep 2026, poly.s po_assign / po_machwin /
po_machlist). FINE is the stock RATE byte, whose default is 127 (+63c), so a
fresh synth track read +63c until the user turned it down (Tim's report).
Three 8-byte jmp detours at the stock sites that make a track a FLEX track
of a slot -- the slot assigner's slot-byte write 0x400795ba (both the
machine window and the sample-list window call the assigner 0x40079424
when the slot differs) and the two windows' machine-only writes 0x40079816
/ 0x4005a848 (the slot equal, the machine changed) -- reset RATE := 64 in
the Part's FLEX PLAYBACK bytes, their battery-RAM shadow and the live lane
when the track IS a synth track after the write (FLEX, the FLEX slot's
sample named FMSYNTH* / SYNTH*) and WAS NOT one before it (the machine not
FLEX, or the slot not a marker). A synth track already keeps its FINE
(re-assignments, project load, Part reload, pattern change, warm boot: no
site runs), a sample track is never written, RATE p-locks are untouched.
THE NEW-PROJECT CASE (BUILD 22, poly.s po_loadsel): Tim's MKI still read
+63c on the FIRST FM machine of a project -- in a fresh project every track
already owns its slot in both columns (T1 = slot 1 .. T8 = slot 8, every slot
empty; the port boots them STATIC), the first marker is loaded INTO the
track's own slot, and neither the machine nor the
slot byte changes (the assigner takes its same-slot exit; the sample-list
window's LOAD FILE never touches the Part): none of the three sites runs.
The fourth site is the file browser's select 0x40022610, whose `jsr
0x40013a08` (sprintf) writes the chosen path into the slot's settings record
-- `jsr po_loadsel` reads the slot's marker state before and after the
write and, when it went non-marker -> marker, resets FINE on every FLEX
track whose FLEX slot is that slot. A marker over a marker, a sample over a
marker, a STATIC slot, a recorder buffer: untouched.

A MACHINE CHANGE RESETS THE TRACK TO THE NEW MACHINE'S INIT (2.12, machine.s
ml_reset). To or from FM SYNTH / SY DRUM -- through the lists (fm_choose), the
slot assigner (po_assign -> ml_became) or the file browser (po_loadsel) -- the
track's PLAYBACK and SETUP, AMP and AMP SETUP, LFO page and LFO SETUP take the
new machine's init (a stock machine's: the stock page descriptors' defaults, as
the stock Part initialiser writes them); step and scene locks are kept, as in
the stock firmware (SY DRUM's lock rows too); FX1 / FX2 stay. The browser's select unloads the slot (0x40025288 clears its
settings record) before the path write -- twice: the browser's load callback
0x400226f4 unloads it, then calls the select, which unloads it again -- so the
file the slot had is read at the callback's call: one more jsr detour,
0x40022732 -> po_unload.

FM SYNTH IN THE MACHINE LIST (2.10, 8 Oct 2026, machine.s; adapted from
Modwerk's FM Synth module, MIT, Modwerk contributors). FM SYNTH is the sixth
row of SELECT MACHINE TYPE (the track key twice, then LEFT) and of SRC SETUP
(FUNC + SRC). Choosing it stores the track as FLEX with "F", "M", 1 in the
first three bytes of its NEIGHBOR PLAYBACK column (the bank blob + part *
6322 + 0x8edbc + 30 * track, and the battery-RAM shadow): no marker file, no
sample. Fourteen detours (the machine window's commit shares MACHWIN_HOOK),
six pokes (the lists' bound 5 -> 6) and one SymbolRef (the kind table's FLEX
START callback -> po_fmstart: the voice starts without a sample; the frame
builder's second supplier call -> po_fmsource: its source is sy_render). The
page cave gained fm_descriptor (pg_resolve moved to +16) and the signature
test; the quantizer's qz_is_synth tests the signature too. The marker files
still select the engine.

THE MACHINE LIST FOR MORE THAN ONE MACHINE (2.11, machine.s): the rows after
PICKUP are a table (ml_rows) assembled per remix -- FM SYNTH always, SY DRUM
(sy-drum/) when the remix carries it -- and the six pokes became six detours
that take the remix's row count (6 with FM SYNTH alone, 7 with SY DRUM), so
a second machine module adds a row without a site of its own. The units
include a per-remix remix.inc (remix_include below): HAVE_SYDRUM and the
equates shared with SY DRUM (engine_abi.inc); with HAVE_SYDRUM 0 the engine
(poly.s) is byte for byte 2.10's (until 2.15: the marker path is off). ANALOG BD is a declared conflict (it owns
the same chooser sites).

THE SELECTION GUARD (2.15, machine.s; limits in machine_limits.inc). FM
SYNTH and SY DRUM render on the ColdFire; the lists refuse a choice that would
take the active Part past 2 SY DRUM tracks, 1 FM SYNTH track, or FM SYNTH with
more than 1 SY DRUM track (the popup says why, nothing is written). Stock's
paste and undo stores that write a machine byte -- the SRC page's, the whole
track's and the Part's -- are guarded the same way (six more detours, with the
FLEX list's sample preview), and a track keeps no signature once it leaves
FLEX. The 2.10 marker path is off: a FLEX track whose slot holds an FMSYNTH* /
SYNTH* file plays that file as a sample (po_slot_marker answers no slot; the
engine's start, the LFO page, the PLAYBACK page and the quantizer test the
list's signature only), so every FM voice is one the guard counted.

Verified in ot_emu through the virtual panel and the pipe (README);
flashed as OCTATRICK9 on an MKI, 26 Sep 2026 (emulator-verified since).
"""

import os

from remix.schema import CavePatch, Detour, DramRegion, Kind, Linked, Module, SymbolRef
import importlib.util

# This module's own directory, relative to the build's cwd (octabam's repo
# root): "modules/synth" when the module is checked out directly, and
# "modules/synth/upstream/synth" when it is octabam's submodule of
# timhastie/octatrick-modules. Every source path below is built from it,
# so one manifest serves both layouts.
_HERE = os.path.relpath(os.path.dirname(os.path.realpath(__file__)))
_guard_spec = importlib.util.spec_from_file_location("fm_stock_guard", os.path.join(_HERE, "stock_guard.py"))
_guard_module = importlib.util.module_from_spec(_guard_spec)
_guard_spec.loader.exec_module(_guard_module)
stock_guard = _guard_module.stock_guard


_hooks_spec = importlib.util.spec_from_file_location("fm_hook_map", os.path.join(_HERE, "hook_map.py"))
_hooks = importlib.util.module_from_spec(_hooks_spec)
_hooks_spec.loader.exec_module(_hooks)
LOCK_HOOKS = _hooks.LOCK_HOOKS
SCENE_HOOKS = (
    (0x40053498, "fs_ui_knob_a_hook", "Scene A held: edit the FM setup scene parameter"),
    (0x40052e98, "fs_ui_knob_b_hook", "Scene B held: edit the FM setup scene parameter"),
    (0x4005435c, "fs_ui_key_a_hook", "Scene A held: clear the pressed FM setup scene parameter"),
    (0x40053a68, "fs_ui_key_b_hook", "Scene B held: clear the pressed FM setup scene parameter"),
    (0x400274cc, "fs_scene_copy_hook", "Capture companion setup scene locks with scene COPY"),
    (0x400275a0, "fs_scene_undo_hook", "Capture companion setup scene locks with scene undo"),
    (0x40025b40, "fs_scene_write_hook", "Restore companion setup scene locks with scene paste or undo"),
    (0x40038c30, "fs_scene_clear_hook", "Clear companion setup scene locks with scene CLEAR"),
    (0x4004a908, "fs_part_save_hook", "Save the Part's companion scene locks"),
    (0x4004aab4, "fs_part_reload_hook", "Reload the Part's saved companion scene locks"),
    (0x4004a9d0, "fs_part_clear_hook", "Clear the Part's companion scene locks"),
    (0x4002932c, "fs_part_copy_hook", "Capture the Part's companion scene locks with COPY"),
    (0x400292a0, "fs_part_undo_hook", "Capture the Part's companion scene locks with undo"),
    (0x40029a4c, "fs_part_write_hook", "Restore companion scene locks after the Part paste guard accepts"),
)


def poly_include(modules):
    names = ("setup", "locks_store", "locks_scene_store", "scenes_value", "scenes_ui",
             "scenes_ops", "locks_effective", "locks_seq", "locks_ui", "locks_sparse",
             "locks_clip", "locks_transform", "locks_delete", "locks_live", "locks_io",
             "lfo_destinations")
    sources = []
    for name in names:
        with open(os.path.join(_HERE, name + ".inc.s"), encoding="utf-8") as source:
            sources.append(source.read())
    return "\n".join((".ifndef FM_PASS1", ".set FM_PASS1, 1", remix_include(modules),
                       ".else", *sources, ".endif", ""))


def engine_abi():
    """synth/engine_abi.inc: the equates SYNTH MACHINE's units share with the machine
    modules that run on its engine (sy-drum). Read from disk, so one file is the truth."""
    with open(os.path.join(os.path.dirname(os.path.realpath(__file__)), "engine_abi.inc"),
              encoding="utf-8") as source:
        return source.read()


def remix_include(modules):
    """The `remix.inc` each unit of this module includes (octabam's Linked.include, written
    per remix): HAVE_SYDRUM -- 1 when SY DRUM (sy-drum/) is in the remix: its machine-list row
    and the engine's calls into its unit are assembled; 0 assembles nothing of it, byte for
    byte the 2.10 engine (poly.s) -- then the shared equates."""
    return f".set HAVE_SYDRUM, {int('SY DRUM' in modules)}\n" + engine_abi()


def machine_limits():
    """synth/machine_limits.inc: the machine list's selection-guard limits (2.15; machine.s
    ml_guard). Read from disk into machine.s's remix.inc only, so one file holds them."""
    with open(os.path.join(os.path.dirname(os.path.realpath(__file__)), "machine_limits.inc"),
              encoding="utf-8") as source:
        return source.read()


def machine_include(modules):
    """machine.s's remix.inc: the units' shared one, then the guard's limits."""
    return remix_include(modules) + machine_limits()

# The kind table: kind -> renderer, 8 longs at 0x400d6434 (0 STATIC, 1 FLEX,
# 2 THRU, 3 NEIGHBOR, 4 PICKUP). STATIC and FLEX share the stock sample
# renderer 0x40004008; both entries point at sy_render since OCTATRICK2.8
# (the STATIC one for the pitch slides of poly.s sy_sample; no marker scan
# on a STATIC track, whose voice is always a sample). PICKUP keeps stock's.
KIND_TABLE_STATIC = 0x400d6434
KIND_TABLE_FLEX = 0x400d6438

# Phase 5 (24 Sep 2026, poly.s): the LFO engine's depth read `mvsw %a2@(0x12,
# %d2:l:2),%d0; lea %a0@(0,%d4:l:2),%a1` (LFO 3 is muted on a synth track)
# and the page resolver's LFO-descriptor load `movel #0x400d37f6,%d0; bras
# 0x40031ed6` (the VOIC/CHRD page for a synth track).
LFO_DEPTH_HOOK = 0x40003ca4              # the routine 0x40003b90
LFO_DEPTH_HOOK2 = 0x4000d03e             # its copy inlined in the frame builder (0x4000cf40..)

LFO_PAGE_HOOK = 0x40031e62

# MIDI IN (30 Sep 2026, poly.s "MIDI IN"): the STANDARD map's chromatic block
# and the note-off, the octave switch of the audio-track note-on, and the 0x41
# event handler's live recorder (docs/firmware/MIDI.md appendix B).
MIDI_MAP_HOOK = 0x4000e746               # `moveq #29,%d1; movel %d1,%a5@(0,%d2:l:4)`: the START, posted before the lock byte

MIDI_OFF_HOOK = 0x4000dfd4               # `mvsb %a0@,%d1; mvsb %a3@,%d0; cmpl %d1,%d0; bnes 0x4000dff8`

MIDI_GATE_HOOK = 0x4000e452              # `movel %d6,%d0; subql #2,%d0; moveq #5,%d2; cmpl %d0,%d2`

RETRIG_HOOK = 0x4000c634                 # the frame builder's per-track copy of the DSP command byte 0x46104d15[t] into the packer's nibble byte 0x46104d0c[t]: `moveal 114(sp),a1; moveb (a0,a1.l),d0` (a0 = 0x46104d15; BUILD 37: po_retrig turns a sequencer START on a sounding synth voice, 0x10 | n, into the key's clean 0x30)

KILL_HOOK = 0x4000685c                   # the stock VOICE KILL 0x40006820(t): `clrb %d0; moveb %d0,%a1@(0,%a0:l)`, the CF voice byte 0x800049d8 + 168 t := 0, interrupts masked; d1 = t (BUILD 33: po_kill ends the engine's voices of the track at that instant)

REL_HOOK = 0x4000b51a                    # `moveal %sp@(114),%a3; movel %a1@(0,%a3:l:4),%d0` (the frame builder's AMP-release consumer, mailbox bit 6: every note-off path)

MIDI_OFFGATE_HOOK = 0x4000de10           # `subql #2,%d0; moveq #5,%d3; cmpl %d0,%d3` (the note-off's octave switch)

MIDI_REC_HOOK = 0x400625e0               # `movel %a2@(4),%d0; movel %d0,0x46c7e956`

MIDI_TRIG_HOOK = 0x4006262a              # `mvsb %a2@(2),%d2; moveal %d2,%a0; lea %a0@(0,%d2:l:4),%a0`

# LEG (2 Oct 2026): the AMP SETUP window (FUNC + AMP) stages, draws and edits
# the STOCK AMP descriptor by address; five detours hand every audio track the
# clone with LEG in the sixth box (poly.s po_amp_desc: OFF / MONO / POLY on a
# synth track, OFF / MONO on any other audio track since 3 Oct 2026; the
# master track keeps the stock record).
AMP_STAGE_HOOK = 0x40059d56              # `pea 0x400d3988` (the window's staging of page 2)

AMP_DRAW1_HOOK = 0x4003685a              # `lea 0x400d39c2,%a4; lea 0x400d3a6a,%a3` (the drawer: names, formatters)

AMP_DRAW2_HOOK = 0x400368ac              # `movel 0x400d3b16,%sp@-; movel 0x400d3b12,%sp@-` (the enable pair, the widget pass)

AMP_DRAW3_HOOK = 0x40036946              # the same pair, the name pass

AMP_EDIT_HOOK = 0x4003ae40               # `addil #0x400d3988,%d0; moveal %d0,%a1; moveal %a1@(298),%a0` (the page-2 editor's handler read)

AMP_LANE_HOOK = 0x4003af0a               # `lea 0x8000083c,%a0; moveb %d2,%a0@(0,%d0:l)` (the page-2 editor's live-lane write)

# Transposing a held step (4 Oct 2026, poly.s po_octave): the FUNC + UP/DOWN
# handler 0x40051fc4 (the trig-mode selector; both keys' records in the FUNC
# layer's tables 0x400bf628 / 0x400bf2b4 name it) tests its window here.
OCT_HOOK = 0x40051fce                    # `tstl 0x400bebae` (the selector window's handle: closed, a press opens it; open, presses step the mode)

# FINE defaults to 0c when a track becomes a synth track (28 Sep 2026, poly.s
# po_assign / po_machwin / po_machlist): the slot assigner's slot-byte write and
# the two windows' machine-only writes.
ASSIGN_HOOK = 0x400795ba                 # `addal #0x8f04a,%a0; moveb %d1,%a0@` (the assigner 0x40079424: the Part's slot byte of the new machine)

MACHWIN_HOOK = 0x40079816                # `addal #0x8eda2,%a0; mvsb %a0@,%d3` (the machine window's apply path 0x400797cc: the machine byte, the slot equal)

LISTWIN_HOOK = 0x4005a848                # `addal #0x8eda2,%a0; mvsb %a0@,%d4` (the sample-list window's apply path 0x4005a826: the same)

# The new-project case (Tim, MKI: the FIRST FM machine of a project read +63c;
# poly.s po_loadsel): the file browser's select 0x40022610 writes the chosen path
# into the slot's settings record -- the only way a FLEX slot's FILE changes
# under a track that already has that slot (a fresh project: T1 = FLEX slot 1 ..
# T8 = slot 8, every slot empty; the assigner then takes its same-slot exit and
# the sample-list window's LOAD FILE never touches the Part).
LOADSEL_HOOK = 0x40022686                # `jsr 0x40013a08` (sprintf: record, "%s..", path) in the browser's select 0x40022610

UNLOAD_HOOK = 0x40022732                 # `jsr 0x40025288` (the slot unload: machine, slot) in the browser's load callback 0x400226f4, before its call of the select


# 2.10 (8 Oct 2026): FM SYNTH IN THE MACHINE LIST (machine.s; after Modwerk's FM Synth
# module, MIT, Modwerk contributors -- its dedicated chooser, Part validation and
# sample-free transport). FM SYNTH is the sixth row of the machine window (FUNC + SRC)
# and of SRC SETUP; a chosen track is stored as FLEX with "FM", 1 in its NEIGHBOR
# PLAYBACK bytes (the Part + 0x8edbc + 30 * track, and the battery-RAM shadow), so it
# needs no marker file and no sample. The marker files still select the engine.
# The machine window's commit shares MACHWIN_HOOK (fm_main_commit, then po_machwin).
FM_NAME_HOOK = 0x400334d8                # `movel %d2,%sp@-; movel %sp@(8),%d1` (the machine-name formatter name(row))

FM_NAMES_HOOK = 0x4003c928               # `lea 0x400a78c8,%a5` (SRC SETUP's name table: five pointers)

FM_NAME_A_HOOK = 0x4003d718              # `lea 0x400a78c8,%a0` (a track's machine name, a0 = its machine byte)

FM_SETUP_ROW_HOOK = 0x4003c980           # `mvsb %a0@,%d0; lea %sp@(24),%sp` (SRC SETUP's row highlight)

FM_CHOOSER_ROW_HOOK = 0x400786c8         # `mvsb %a0@,%d0; cmpl %d0,%d2; bnes 0x400786fc` (the machine window's row highlight)

FM_SETUP_OPEN_HOOK = 0x400585dc          # `moveb %a0@,%d3; mvsb %d3,%d4; pea 0x400bb704` (SRC SETUP opens on the track's row)

FM_CHOOSER_OPEN_HOOK = 0x40078886        # `mvsb %a0@,%d0; movel %d0,%sp@-; pea 0x460e7386` (the machine window opens on it)

FM_EDIT6_HOOK = 0x4003a52e               # `movel %d2,%d0; lsll #3,%d0; addl %d2,%d2; subl %d2,%d0` (SRC SETUP's editor: row * 6)

FM_DRAW6_HOOK = 0x4003cd98               # `movel %d6,%d7; lsll #3,%d7; addl %d6,%d6; subl %d6,%d7` (its drawer: the same)

FM_TICK_HOOK = 0x4005221e                # `jsr %pc@(0x4005213c); jsr 0x4007e940` (the UI tick)

FM_SRC_COMMIT_HOOK = 0x4005a616          # `movel 0x460d5c30,%d1` (SRC SETUP's machine-byte write: the chosen row)

FM_SRC_COMMIT2_HOOK = 0x4005a850         # the same instruction on its second path (after LISTWIN_HOOK, which returns here)

FM_VALIDATE_HOOK = 0x40002318            # `lea %sp@(-96),%sp; moveml %d2-%d7/%a2-%fp,%sp@` (the Part validator's prologue)

FM_SOURCE_HOOK = 0x4000d514              # `moveal %a4@+,%a0; movel %a0,%a3@+; pea 0x10` (the frame builder's second supplier call)

# 2.11: the machine list's six row-count / row-bound sites (machine.s ml_*; pokes 5 -> 6 until 2.10)
ML_WIN_COUNT_HOOK = 0x40079248            # `pea 5; pea 6` (the machine window's list init: rows, visible)

ML_SRC_COUNT_HOOK = 0x400585fa            # `pea 5; pea 5` (SRC SETUP's list init: rows, visible)

ML_NAME_BOUND_HOOK = 0x4003c950           # `moveq #4,%d1; cmpl %d2,%d1; bcss 0x4003c95a` (SRC SETUP's name lookup)

ML_DRAW_BOUND_HOOK = 0x40078678           # `moveq #4,%d0; cmpl %d2,%d0; blts 0x400786a2` (the machine window's drawer)
  # ... movel %d2,%sp@-; moveal %d3,%a0; jsr %a0@ (12 B)
ML_HI_BOUND_HOOK = 0x400786ce             # `moveq #4,%d0; cmpl %d2,%d0; blts 0x400786fc` (its highlight)

ML_CUR_BOUND_HOOK = 0x40079904            # `moveq #4,%d3; cmpl %d4,%d3; bgew 0x400797cc` (its cursor)

ML_CLAMP_HOOKS = (0x40078c22, 0x40078cb0, 0x40078d2e, 0x40078dee, 0x40078e7c)  # the machine window's row clamp after a list move
   # `moveq #5,%d1; cmpl %d0,%d1; bges +2; moveq #5,%d0`
# 2.15: the selection guard's paste guards (machine.s fm_page_store .. fm_preview): stock's copy / paste and
# undo write the machine byte without the lists -- the SRC page's store, the whole track's and the Part's
# (each guarded where its paste and its undo call it) -- and the FLEX list's sample preview makes a track FLEX
PAGE_STORE_HOOK = 0x40027e98              # `moveb %a2@(19),%d3; mvsb %d3,%d6; moveb %a2@(18),%d7` (the SRC page's store 0x40027e4c, page 0)

TRACK_PASTE_HOOK = 0x4002b99e             # `pea 0x460c8122; jsr %pc@(0x4002b654)` (the whole track's paste calls its store: the clipboard)

TRACK_UNDO_HOOK = 0x4002b962              # `pea 0x460bf218; jsr %pc@(0x4002b654)` (... its undo: the undo buffer)

PART_PASTE_HOOK = 0x40029b8a              # `pea 0x460c8122; jsr %pc@(0x40029a4c)` (the Part's paste calls its store: the clipboard)

PART_UNDO_HOOK = 0x40029b54               # `pea 0x460bf218; jsr %pc@(0x40029a4c)` (... its undo: the undo buffer)

PREVIEW_HOOK = 0x40096d22                 # `mvsb %a0@,%d3; movel %d3,0x46105424; moveb #1,%a0@` (the FLEX list's sample preview 0x40096c54)

KIND_TABLE_FLEX_START = 0x400d6458       # the kind table's FLEX START callback (stock 0x4000f450)
FLEX_START = 0x4000f450

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
# value, 0..127, ms/s/HOLD), widgets that draw the operator diagram, the
# sideband spectrum, the feedback loop and the index envelope over the stock
# dial -- when FM SYNTH is chosen in the track's machine list (until 2.14 also when its
# assigned FLEX sample was named FMSYNTH* or SYNTH*: the marker path is off since 2.15).
# The clone itself is built at runtime by poly.s (po_pgdesc, first use) from
# the stock record in the image plus the override list in page.s; the cave
# carries no stock bytes. Pinned at the second zero run: the override list
# holds absolute pointers into the cave. One 6-byte poke (`movel
# %a0@(0,%d0:l:4),%d0; bras` -> `jmp pg_resolve`).
PAGE_AT = 0x400d24d0
PAGE_LEN = 1752
PG_RESOLVE_AT = 16                       # pg_resolve's offset in the cave (fm_descriptor, 16 B, is first)
RESOLVER_HOOK = 0x40031ece

# 2.10 (6 Oct 2026, poly.s "THE LFO DESTINATION LIST"): LFO SETUP's PMTR. The
# formatter 0x4003bf64 (the LFO descriptor's slot-6 formatter) picks the PLAYBACK
# names from the machine table and the LFO names from the stock descriptor
# itself, not through the page resolver; the audio edit 0x400392cc walks all 30
# destinations. On a synth track the names become the FM SYNTH page's and the
# PLAYBACK clone's. All stock LFO destinations remain available.
LFD_NAME_HOOK = 0x4003bff2               # `lea 0x400d5f38,%a0; bras 0x4003c054` (page 0: the machine table)

LFD_LFO_HOOK = 0x4003bffa                # `lea 0x400d37f6,%a2; bras 0x4003c058` (page 1: the LFO descriptor)

LFD_EDIT_HOOK = 0x400392cc               # `movel %d3,%d0; moveq #6,%d2; remsl %d2,%d7,%d0` (the audio PMTR edit after its branches)

# Ratified bytes: page.s with m68k-elf-as -mcpu=5475, linked at PAGE_AT (26 Sep 2026: the
# runtime clone -- 1,672 B, down from 1,948: the 402-byte copy of the stock descriptor is gone,
# and the "%d" formatter is the stock's own; 27 Sep 2026: 1,800 B with the tuning system's
# PTCH and FINE formatters and the range / handler overrides; 30 Sep 2026: 1812 B, the
# FMSYNTH* marker name -- a leading "FM" is skipped before the SYNTH compare; 5 Oct 2026:
# still 1812 B, DEC's HOLD moved from raw 0 to raw 127 -- short branches pay for the compare;
# 8 Oct 2026: 1868 B, the FM SYNTH machine -- fm_descriptor (16 B) first, so pg_resolve is at
# +16, and pg_resolve's test of the Part's "FM", 1 ahead of the marker scan; still inside the
# zero run 0x400d24d0..0x400d2ce0, 2064 B; 15 Oct 2026 (2.15): 1752 B, the marker scan gone --
# the page is FM SYNTH's for a track chosen in the list only).
PINNED_PAGE = bytes.fromhex(
    "2079400d64382068fffc43fa00604ed020300c000c80400d31ae66000048243c"
    "000018b24c012800d48920422803c8fc001ed1c4d1fc0008edbc7bd00c850000"
    "464d660000207ba800020c8500000001660000122079400d64382068fffc43fa"
    "000c4e904ef940031ed6000000090009400d259c001c001e400d25a500610001"
    "400d25c3006a0004400d25c4009a0004400d25c800ca0018400d25cc00fe0008"
    "400d25e4010a0008400d25ec012a0004400d25c401360004400d25c4018e0004"
    "400d25f4ffff000000000000464d2053594e5448005241544f0000494e445800"
    "0046494e4500004644424b0000444543000000400000000000000080400d25f8"
    "400d263e4003c178400d26244003c178400d26c0400d2758400d275e400d2764"
    "400d276a55551551202f000804800000004041fa03996e00000841f9400b465d"
    "2f002f082f2f000c4eb940013a084fef000c4e75202f000804800000004041fa"
    "03716e00ffdc41fa036e6000ffd42f02202f000ce48802800000001f41fa036e"
    "73f00a002001e0880281000000ff74644c021000e0896700003e0c8100000032"
    "6700001c2f012f00487a030a2f2f00144eb940013a084fef0010600000302f00"
    "487a02fa2f2f00104eb940013a084fef000c600000182f004879400b465d2f2f"
    "00104eb940013a084fef000c241f4e752f02202f000c727fb081647822004c00"
    "1000203c000007d04c010000068000001f80223c00003f014c4100000c800000"
    "03e8641a2f004879400b465d2f2f00104eb940013a084fef000c60000048223c"
    "000003e824004c41200272644c4100002202e789d282d28290812f002f02487a"
    "02612f2f00144eb940013a084fef001060000012487a02522f2f000c4eb94001"
    "3a08508f241f4e7570006000001470016000000e700260000008700360000002"
    "4fefffd448d77cfc2e002f2f00482f2f00482f2f00482f2f00482f2f00482f2f"
    "00482f2f00484eb9400479b44fef001c202f004008000001660001902c2f003c"
    "4a87670000125387670000185387670000b2600000c841fa02d0610001786000"
    "012641fa03906100016c220670034c001000707f4c401001740b948170087201"
    "610001742406700a4c002000707f4c40200267000012700672016100015a700a"
    "72016100015224060482000000146f00002270084c002000706b4c4020026700"
    "0012700472016100012e700c72016100012624060482000000386f0000aa7006"
    "4c00200070474c4020026700009a7002720161000102700e7201610000fa6000"
    "008641fa0268610000cc4a866700007841fa029e610000ce6000006c41fa02d6"
    "610000b270017201740b610000ca2a3c00007fff707fbc8064102a06700d4c00"
    "5000707f4c4050055485780b7e0224075382e98a4c4520020c82000000106f00"
    "0004741041fa00d475b02800264220072202240461000080280b52870c870000"
    "000f6f00ffca202f0040080000006700001841fa0150701022100a81fff00000"
    "20c153806c00fff2202f00345e802f00202f003452802f002f2f0050487a00ce"
    "4eb9400128a84fef00104cd77cfc4fef002c4e7543fa010e701022d853806c00"
    "fffa4e7543fa00fe70102218839953806c00fff84e7541fa00ec41f00c00263c"
    "80000000e2ab8790e28b5281b4816c00fff64e7525642e253032640025642e35"
    "0025642e25647300484f4c44002b2564002b25646300256463000b0907060504"
    "0303020201010101010101000040008000c0010001030140016a018001c00200"
    "0203028003000380040004030480050005800600068007000780080009000a00"
    "0b000c000d000e000f001000000000110000000d00000001400d2a54400d2a10"
    "fff80000fff80000fff80000fff80000fff80000fff80000fff80000fff80000"
    "fff80000fff80000fff80000fff80000fff80000fff80000fff80000fff80000"
    "fff8000000000000000000000000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000000000000000000000000000"
    "000000000000000000000000000000003f80000020800000208000003f800000"
    "0400000004000000150000000e000000040000003f8000002080000020800000"
    "3f80000000000000000000000000000000000000000000000000000000000000"
    "3f80000020800000208000002080000020800000208000003f80000000000000"
    "00000000000000000000000000000000000000000000000007f000000e100000"
    "0410000000100000001000000010000000100000001000000010000000100000"
    "0410000007f00000000000000000000000000000000000008000000080000000"
    "8000000080000000800000008000000080000000800000008000000080000000"
    "800000008000000080000000800000008000000000000000"
)
assert len(PINNED_PAGE) == PAGE_LEN, len(PINNED_PAGE)
assert PINNED_PAGE[PG_RESOLVE_AT:PG_RESOLVE_AT + 4] == bytes.fromhex("20300c00")  # pg_resolve replays the table load
assert PAGE_AT + PAGE_LEN <= 0x400d2ce0                  # the zero run's end


def emit_page(addr: int):
    """The source is the only truth for the bytes (b""); the resolver's kind-0
    table load becomes a jmp to pg_resolve (+16, after fm_descriptor)."""
    assert addr == PAGE_AT, "the page cave is pinned"
    return b"", ((RESOLVER_HOOK, stock_guard(RESOLVER_HOOK, 6),
                  bytes.fromhex("4ef9") + (addr + PG_RESOLVE_AT).to_bytes(4, "big")),)


MODULE = Module(
    name="synth",
    key="SYNTH MACHINE",
    kind=Kind.CF_PATCH,
    # 2.11: ANALOG BD (octabam modules/analog-bassdrum) owns the same machine-list sites
    # (the sixth row and its hooks); the ledger refuses the pair on bytes already, this
    # names the reason.
    conflicts=(("ANALOG BD", "both own the machine list's rows after PICKUP (the same chooser sites)"),),
    doc="FM SYNTH in the machine list (FUNC + SRC, or SELECT MACHINE TYPE) plays a two-operator FM "
        "voice (STRT/LEN/RTRG/RTIM = ratio/index/feedback/decay); the DSP "
        "shapes and effects it as a sample. Its PLAYBACK page reads RATO/INDX/"
        "FDBK/DEC with icons and the title FM SYNTH; PTCH is semitones (-64..+63) "
        "and RATE is FINE (cents) on a synth track, 0c the moment a track becomes one. "
        "A FLEX or STATIC sample track with LEG MONO and GLIDE slides its pitch (2.8).",
    linked=(
        Linked("poly", os.path.join(_HERE, "poly.s"), cpu="5475", dram=True, include=poly_include),
        Linked("fmmachine", os.path.join(_HERE, "machine.s"), cpu="5475", dram=True, include=machine_include),
    ),
    dram_regions=(DramRegion("fl_work_table", 2097152),
                  DramRegion("fl_scene_table", 32768),
                  DramRegion("fl_migration_table", 2560),
                  DramRegion("fl_migration_text", 262144)),
    # The kind table's FLEX entry is a 4-byte data pointer, not an
    # instruction: upstream octabam's SymbolRef (a stock u32 rewritten to a
    # linked symbol, the stock value asserted first) is what the fork's
    # Detour(kind="ptr") did (ported 25 Sep 2026).
    symbol_refs=(
        SymbolRef(KIND_TABLE_FLEX, 0x40004008, "poly", "sy_render",
                  "kind table FLEX renderer -> the DRAM unit's sy_render (a track chosen as FM SYNTH "
                  "becomes the FM voice; a sample's PTCH slides with LEG MONO + GLIDE)"),
        SymbolRef(KIND_TABLE_STATIC, 0x40004008, "poly", "sy_render",
                  "kind table STATIC renderer -> sy_render too (2.8: a STATIC sample's PTCH slides "
                  "with LEG MONO + GLIDE; no marker scan, the stock call otherwise)"),
        SymbolRef(KIND_TABLE_FLEX_START, FLEX_START, "poly", "po_fmstart",
                  "kind table FLEX START callback -> po_fmstart (2.10): a track whose FM SYNTH is chosen in the "
                  "machine list starts its voice without a sample; every other FLEX track the stock callback"),
    ),
    detours=(

        Detour(LFO_DEPTH_HOOK, stock_guard(LFO_DEPTH_HOOK, 8), "poly", "lf_lfo_standalone",
               "Route module PMTR destinations into safe private LFO output words in the standalone engine",
               kind="jmp", pad_to=8),

        Detour(LFO_DEPTH_HOOK2, stock_guard(LFO_DEPTH_HOOK2, 8), "poly", "po_lfo3b",
               "LFO frame clock tap and safe module PMTR outputs; stock depth arithmetic for every LFO",
               kind="jmp", pad_to=8),

        Detour(LFO_PAGE_HOOK, stock_guard(LFO_PAGE_HOOK, 8), "poly", "lf_page",
               "FM LFO descriptor with appended VOIC and CHRD destinations; all three speeds and depths remain stock",
               kind="jmp", pad_to=8),
        Detour(LFD_EDIT_HOOK, stock_guard(LFD_EDIT_HOOK, 8), "poly", "lf_pmtr_edit",
               "Append PMTR values 30 and 31 on FM tracks without indexing the stock order tables beyond 29",
               kind="jmp", pad_to=8),
        Detour(0x40058488, stock_guard(0x40058488, 6), "poly", "lf_stage",
               "LFO SETUP stages the FM PMTR destination count", kind="jmp"),
        Detour(0x4003a45c, stock_guard(0x4003a45c, 6), "poly", "lf_move",
               "LFO SETUP row movement stages the FM PMTR destination count", kind="jmp"),
        Detour(0x400574cc, stock_guard(0x400574cc, 6), "poly", "lf_draw",
               "LFO SETUP draws the two appended PMTR labels on FM tracks", kind="jmp"),
        Detour(0x40039020, stock_guard(0x40039020, 6), "poly", "lf_edit",
               "LFO SETUP edits the FM PMTR destination count", kind="jmp"),

        Detour(LFD_NAME_HOOK, stock_guard(LFD_NAME_HOOK, 8), "poly", "po_lfdname",
               "LFO SETUP PMTR formatter, PLAYBACK names: the page resolver's descriptor (the FM SYNTH page on a synth track) instead of the machine table's; the master track and every other machine stock",
               kind="jmp", pad_to=8),


        Detour(MIDI_MAP_HOOK, stock_guard(MIDI_MAP_HOOK, 6), "poly", "po_mon",
               "MIDI IN note-on (the STANDARD map's chromatic block): a synth track's PTCH raw is note - 20 (semitones, 84 = 0), stored before the START, and the note is posted to the engine as a key of its own",
               kind="jmp"),
        Detour(MIDI_OFF_HOOK, stock_guard(MIDI_OFF_HOOK, 8), "poly", "po_moff",
               "MIDI IN note-off: a paraphonic synth track releases that note's voice alone; the last note's release posts the stock AMP release",
               kind="jmp", pad_to=8),
        Detour(REL_HOOK, stock_guard(REL_HOOK, 8), "poly", "po_rel",
               "the frame builder's AMP-release consumer (mailbox 0x40, every note-off path): a synth voice takes the released flag -- plan B: the engine's own release starts (po_mono_env)",
               kind="jmp", pad_to=8),
        Detour(RETRIG_HOOK, stock_guard(RETRIG_HOOK, 8), "poly", "po_retrig",
               "the frame builder's copy of the DSP command byte into the packer's nibble byte (every START form's funnel): a START posted on a synth track whose engine voice is on (S_ON) becomes the key's clean form 0x30 -- the CF START bit with sub-frame position 0 -- so the DSP does not crossfade its old voice under the engine's one continuous stream (BUILD 37: the +5.6 dB bump at a sequencer trig on a still-sounding note)",
               kind="jmp", pad_to=8),
        Detour(KILL_HOOK, stock_guard(KILL_HOOK, 6), "poly", "po_kill",
               "the stock VOICE KILL's CF voice-byte clear (STOP / pattern change 0x40043c50, the loaders, the sample preview, the frame builder's end mask): the engine's voices of the killed track end at that instant (S_GAIN / S_GPREV / S_HTIM / S_ON := 0, the paraphonic voices freed) -- the DSP voice is dead, the next START is cold (BUILD 33)",
               kind="jmp"),
        Detour(MIDI_GATE_HOOK, stock_guard(MIDI_GATE_HOOK, 8), "poly", "po_mgate",
               "MIDI IN note gate: a note outside 72..96 addressed to a synth track plays it chromatically (20..127 = -64..+43 semitones)",
               kind="jmp", pad_to=8),
        Detour(MIDI_OFFGATE_HOOK, stock_guard(MIDI_OFFGATE_HOOK, 6), "poly", "po_mogate",
               "MIDI IN note-off gate: a note outside 72..96 addressed to a synth track reaches the chromatic note-off (po_moff)",
               kind="jmp"),
        Detour(MIDI_REC_HOOK, stock_guard(MIDI_REC_HOOK, 10), "poly", "po_mrec",
               "MIDI IN live recorder (the 0x41 event): a synth track's note records through po_keyrec (fingered chords; the PTCH lock in semitones)",
               kind="jmp", pad_to=10),
        Detour(MIDI_TRIG_HOOK, stock_guard(MIDI_TRIG_HOOK, 10), "poly", "po_mtrig",
               "MIDI IN with a trig held: a synth track's held trig gets its PTCH lock in semitones",
               kind="jmp", pad_to=10),      # the whole 10-byte displaced span (the lea's extension word included)
        Detour(OCT_HOOK, stock_guard(OCT_HOOK, 6), "poly", "po_octave",
               "FUNC + UP/DOWN (the trig-mode selector): with a trig held on a synth track in GRID RECORDING, any trig mode, "
               "the held steps' PTCH lock moves an octave instead (no trig held, a sample track, GRID RECORDING off: the selector)",
               kind="jmp"),
        Detour(AMP_STAGE_HOOK, stock_guard(AMP_STAGE_HOOK, 6), "poly", "po_ampstage",
               "AMP SETUP window (FUNC + AMP) staging: an audio track stages the AMP clone whose sixth box is LEG (OFF / MONO / POLY on a synth track, OFF / MONO on a sample track; the master track stock)",
               kind="jmp"),
        Detour(AMP_DRAW1_HOOK, stock_guard(AMP_DRAW1_HOOK, 12), "poly", "po_ampdraw1",
               "AMP SETUP drawer: the page-2 names and formatters from the clone on an audio track",
               kind="jmp", pad_to=12),
        Detour(AMP_DRAW2_HOOK, stock_guard(AMP_DRAW2_HOOK, 12), "poly", "po_ampdraw2",
               "AMP SETUP drawer: the enable nibbles from the clone (the widget pass)",
               kind="jmp", pad_to=12),
        Detour(AMP_DRAW3_HOOK, stock_guard(AMP_DRAW3_HOOK, 12), "poly", "po_ampdraw3",
               "AMP SETUP drawer: the enable nibbles from the clone (the name pass)",
               kind="jmp", pad_to=12),
        Detour(AMP_EDIT_HOOK, stock_guard(AMP_EDIT_HOOK, 12), "poly", "po_ampedit",
               "AMP page-2 editor: slot 11 of an audio track steps LEG 0..2 (synth) or 0..1 (sample) (po_legknob); the Part byte and its battery-RAM shadow as stock writes them",
               kind="jmp", pad_to=12),
        Detour(AMP_LANE_HOOK, stock_guard(AMP_LANE_HOOK, 10), "poly", "po_amplane",
               "AMP page-2 editor's live-lane write: a synth track's LEG never reaches the lane (the DSP's copy reads 0)",
               kind="jmp", pad_to=10),
        Detour(ASSIGN_HOOK, stock_guard(ASSIGN_HOOK, 8), "poly", "po_assign",
               "slot assigner (both windows): a track that becomes a synth track by this slot write -- FLEX with an FMSYNTH*/SYNTH* slot, "
               "not one before -- gets FINE 0c (RATE := 64 in the Part, its shadow and the live lane); a synth track already, or a sample track: untouched",
               kind="jmp", pad_to=8),
        Detour(MACHWIN_HOOK, stock_guard(MACHWIN_HOOK, 8), "fmmachine", "fm_main_commit",
               "machine window, the machine-only write (the slot equal): row 5 (FM SYNTH) is stored as FLEX with the Part's \"FM\", 1 (seeded "
               "unless the track plays the FM voice already), any other row clears it (2.10, machine.s); then po_machwin: a track that "
               "becomes a synth track by the machine change gets FINE 0c",
               kind="jmp", pad_to=8),
        Detour(LISTWIN_HOOK, stock_guard(LISTWIN_HOOK, 8), "poly", "po_machlist",
               "sample-list window, the machine-only write: the same",
               kind="jmp", pad_to=8),
        Detour(LOADSEL_HOOK, stock_guard(LOADSEL_HOOK, 6), "poly", "po_loadsel",
               "file browser select: the slot's path write (stock's sprintf, called from the stub) -- a FLEX slot's file going "
               "non-marker -> FMSYNTH*/SYNTH* makes every FLEX track holding that slot a synth track: FINE 0c for each (the new-project case: "
               "T1 = FLEX slot 1, the first marker loaded into slot 1, no machine or slot byte changes)",
               kind="jsr"),
        Detour(UNLOAD_HOOK, stock_guard(UNLOAD_HOOK, 6), "poly", "po_unload",
               "file browser load callback: the slot unload before the select (2.12) -- the FLEX slot's marker state is kept for "
               "po_loadsel (the unload clears the slot's record), then the stock unload",
               kind="jsr"),
        # ---- FM SYNTH in the machine list (2.10, machine.s; MACHWIN_HOOK above) ----
        Detour(FM_NAME_HOOK, stock_guard(FM_NAME_HOOK, 6), "fmmachine", "fm_machine_name",
               "the machine-name formatter: row 5 reads FM SYNTH (the machine window's sixth row)",
               kind="jmp"),
        Detour(FM_NAMES_HOOK, stock_guard(FM_NAMES_HOOK, 6), "fmmachine", "fm_src_names",
               "SRC SETUP's machine-name table: six rows, the stock five (copied at run time) and FM SYNTH",
               kind="lea"),
        Detour(FM_NAME_A_HOOK, stock_guard(FM_NAME_A_HOOK, 6), "fmmachine", "fm_name_a",
               "a track's machine name: FM SYNTH for a chosen track (FLEX with the Part's \"FM\", 1)",
               kind="jmp"),
        Detour(FM_SETUP_ROW_HOOK, stock_guard(FM_SETUP_ROW_HOOK, 6), "fmmachine", "fm_setup_row",
               "SRC SETUP's row highlight: a chosen track's row is FM SYNTH",
               kind="jmp"),
        Detour(FM_CHOOSER_ROW_HOOK, stock_guard(FM_CHOOSER_ROW_HOOK, 6), "fmmachine", "fm_chooser_row",
               "the machine window's row highlight: the same",
               kind="jmp"),
        Detour(FM_SETUP_OPEN_HOOK, stock_guard(FM_SETUP_OPEN_HOOK, 10), "fmmachine", "fm_setup_open",
               "SRC SETUP opens on FM SYNTH for a chosen track (its page: the descriptor table's slot 5, fm_tick)",
               kind="jmp", pad_to=10),
        Detour(FM_CHOOSER_OPEN_HOOK, stock_guard(FM_CHOOSER_OPEN_HOOK, 10), "fmmachine", "fm_chooser_open",
               "the machine window opens on FM SYNTH for a chosen track",
               kind="jmp", pad_to=10),
        Detour(FM_EDIT6_HOOK, stock_guard(FM_EDIT6_HOOK, 8), "fmmachine", "fm_setup_edit6",
               "SRC SETUP's editor addresses row 5's Part bytes as FLEX's",
               kind="jmp", pad_to=8),
        Detour(FM_DRAW6_HOOK, stock_guard(FM_DRAW6_HOOK, 8), "fmmachine", "fm_setup_draw6",
               "SRC SETUP's drawer: the same",
               kind="jmp", pad_to=8),
        Detour(FM_TICK_HOOK, stock_guard(FM_TICK_HOOK, 10), "fmmachine", "fm_tick",
               "the UI tick (its two calls replayed): SRC SETUP's six names refreshed and the PLAYBACK descriptor table's "
               "spare slot 5 (0x400d5f4c) := the FM SYNTH page (page.s fm_descriptor)",
               kind="jmp", pad_to=10),
        Detour(FM_SRC_COMMIT_HOOK, stock_guard(FM_SRC_COMMIT_HOOK, 6), "fmmachine", "fm_src_commit",
               "SRC SETUP's machine-byte write: row 5 is stored as FLEX with the signature, any other row clears it",
               kind="jmp"),
        Detour(FM_SRC_COMMIT2_HOOK, stock_guard(FM_SRC_COMMIT2_HOOK, 6), "fmmachine", "fm_src_commit2",
               "the same on SRC SETUP's second path (po_machlist's detour returns to this site)",
               kind="jmp"),
        # ---- 2.15: the selection guard on stock's paste / undo stores and the FLEX preview (machine.s) ----
        Detour(PAGE_STORE_HOOK, stock_guard(PAGE_STORE_HOOK, 10), "fmmachine", "fm_page_store",
               "the SRC page's paste / undo store: FLEX pasted over a track whose signature place names a row is refused past the "
               "selection guard's limits (nothing stored, the popup's message)",
               kind="jmp", pad_to=10),
        Detour(TRACK_PASTE_HOOK, stock_guard(TRACK_PASTE_HOOK, 10), "fmmachine", "fm_track_paste",
               "the whole track's paste: a clip whose machine is a row's (FLEX + signature) is refused past the limits of the Part it "
               "lands in (nothing pasted: the pattern track and SY DRUM's lock rows neither)",
               kind="jmp", pad_to=10),
        Detour(TRACK_UNDO_HOOK, stock_guard(TRACK_UNDO_HOOK, 10), "fmmachine", "fm_track_undo",
               "the whole track's undo: the same test on what it restores",
               kind="jmp", pad_to=10),
        Detour(PART_PASTE_HOOK, stock_guard(PART_PASTE_HOOK, 10), "fmmachine", "fm_part_paste",
               "the Part's paste: a Part that holds more than the limits (saved by an older build) is refused whole",
               kind="jmp", pad_to=10),
        Detour(PART_UNDO_HOOK, stock_guard(PART_UNDO_HOOK, 10), "fmmachine", "fm_part_undo",
               "the Part's undo: the same test on what it restores",
               kind="jmp", pad_to=10),
        Detour(PREVIEW_HOOK, stock_guard(PREVIEW_HOOK, 12), "fmmachine", "fm_preview",
               "the FLEX list's sample preview makes a track FLEX while it plays: a track that was not FLEX loses the signature it "
               "kept first, so the preview plays the sample and no row's machine is revived",
               kind="jmp", pad_to=12),
        Detour(FM_VALIDATE_HOOK, stock_guard(FM_VALIDATE_HOOK, 8), "fmmachine", "fm_validate",
               "the Part validator: a chosen track's twelve FLEX bytes sit out the stock clamps (FLEX's PTCH 4..124; FM SYNTH's is "
               "0..127) -- the stock defaults in their place while it runs, the FM bytes back after",
               kind="jmp", pad_to=8),
        Detour(FM_SOURCE_HOOK, stock_guard(FM_SOURCE_HOOK, 8), "poly", "po_fmsource",
               "the frame builder's second supplier call: a chosen track's supplier is sy_render (an empty FLEX voice gets stock's "
               "silent one)",
               kind="jmp", pad_to=8),
        # ---- the machine list's row count and bounds (2.11, machine.s; 2.10 poked them to 6 rows) ----
        Detour(ML_WIN_COUNT_HOOK, stock_guard(ML_WIN_COUNT_HOOK, 8), "fmmachine", "ml_win_count",
               "the machine window's list init: 5 + the remix's machine-list rows (6 with FM SYNTH, 7 with SY DRUM), six visible",
               kind="jmp", pad_to=8),
        Detour(ML_SRC_COUNT_HOOK, stock_guard(ML_SRC_COUNT_HOOK, 8), "fmmachine", "ml_src_count",
               "SRC SETUP's machine selector: 5 + the machine-list rows, five visible",
               kind="jmp", pad_to=8),
        Detour(ML_NAME_BOUND_HOOK, stock_guard(ML_NAME_BOUND_HOOK, 6), "fmmachine", "ml_name_bound",
               "SRC SETUP's name lookup admits the machine-list rows",
               kind="jmp"),
        Detour(ML_DRAW_BOUND_HOOK, stock_guard(ML_DRAW_BOUND_HOOK, 12), "fmmachine", "ml_draw_bound",
               "the machine window's row drawer draws name(row + top) up to the last row: SELECT MACHINE TYPE scrolls like SRC SETUP",
               kind="jmp", pad_to=12),
        Detour(ML_HI_BOUND_HOOK, stock_guard(ML_HI_BOUND_HOOK, 6), "fmmachine", "ml_hi_bound",
               "the machine window highlights the machine-list rows",
               kind="jmp"),
        Detour(ML_CUR_BOUND_HOOK, stock_guard(ML_CUR_BOUND_HOOK, 8), "fmmachine", "ml_cur_bound",
               "the machine window applies a machine-list row under its cursor",
               kind="jmp", pad_to=8),
    ) + tuple(
        Detour(a, stock_guard(a, 8), "fmmachine", f"ml_clamp{i + 1}",
               "the machine window's row clamp after a list move: 0 .. the last row (stock 0..5)",
               kind="jmp", pad_to=8)
        for i, a in enumerate(ML_CLAMP_HOOKS)) + tuple(
        Detour(site, stock_guard(site, length), "poly", symbol, reason,
               kind="jmp", pad_to=length)
        for site, length, symbol, reason in LOCK_HOOKS
    ) + tuple(
        Detour(site, stock_guard(site, 8), "poly", symbol, reason,
               kind="jmp", pad_to=8)
        for site, symbol, reason in SCENE_HOOKS
    ),
    # 2.11: the six row-count / row-bound constants were pokes (5 -> 6) until 2.10; a poke is
    # static, the number of rows is the remix's (FM SYNTH, + SY DRUM): six detours read it.
    pokes=(),
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
