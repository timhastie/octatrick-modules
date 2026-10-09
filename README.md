# octatrick-modules

Five firmware modules for the Elektron Octatrack (OS 1.40C, MKI and MKII),
written for [sambanks/octabam](https://github.com/sambanks/octabam)'s build
system. **This repository is the source of truth for the modules**: octabam
consumes it as a git submodule (`modules/<name>/upstream`, pinned to a tag),
and the ready-to-build fork below does the same.

[![Octatrick demo video: the FM synth, scale quantizer and direct jump running on a real Octatrack MKI](https://img.youtube.com/vi/1DqUzvs8J3U/maxresdefault.jpg)](https://www.youtube.com/watch?v=1DqUzvs8J3U)

**Demo video:** [Octatrick running on a real Octatrack MKI (YouTube)](https://www.youtube.com/watch?v=1DqUzvs8J3U)
-- the FM synth, scale quantizer and direct jump in use. Click the picture
to watch.

## The modules

- **`synth/`** (key `SYNTH MACHINE`) -- a two-operator FM synth machine:
  **FM SYNTH is a machine of its own in the track's machine list** (since
  2.10: FUNC + SRC, or SELECT MACHINE TYPE -- no sample or marker file
  needed; see "Selecting FM SYNTH from the machine list" in
  [synth/README.md](synth/README.md)), and any
  FLEX track whose sample is named FMSYNTH*.wav still becomes a synth (a silent
  4 s marker file will do; SYNTH*.wav is still accepted; the marker never
  ends the note -- the AMP envelope or a key release does), with its own PLAYBACK page (PTCH RATO INDX FINE
  FDBK DEC: PTCH in semitones, -64..+63, FINE in cents -- 0c the moment a
  track becomes a synth track), and on the LFO
  page VOIC (1 = mono, 2..4 = paraphonic: the most voices the track sounds
  at once, keys and chords alike) and CHRD (32 chord shapes as four-note
  voicings in priority order, in Syntakt order since 2.8 -- the triads MIN
  MAJ SU2 SU4, the sevenths and adds, the rest, the two-note intervals
  last (a CHRD byte saved by 2.7 names another shape) -- each at four
  detents -- the root position
  and three inversions (MIN MIN1 MIN2 MIN3 MAJ ...): VOIC 2 / 3 / 4 plays
  2 / 3 / 4 notes of any shape, a new chord replaces the last; lockable
  per step, snapped to SCALE); a voice is 1/sqrt(VOIC) of the mono voice,
  equal power; since 2.9 there is no limiter (a full 4-note chord sits
  about 6 dB above a single note and never clips). A chord fingered on the CHROMATIC keys or over MIDI IN
  during live recording (VOIC 2..4, CHRD "----") is recognised and
  recorded as locks on the first key's step -- keys within a rolling 150
  ms of each other, at any tempo; PTCH the bass, CHRD the shape AND its
  inversion (an exact voicing match first, the pitch classes second), VOIC
  the voices that were heard; a legato hand-over (the earlier key lifted
  within 50 ms) records single notes instead; two keys in one panel scan
  both sound; and one key is one voice: a second START for a held key (a
  bounce, the recorder's own copy under the finger) no longer doubles the
  note. The CHROMATIC keyboard of
  a synth track spans octaves -4..+4 (FUNC + LEFT/RIGHT). The engine is
  a DRAM unit in octabam's sample-RAM reserve (10 MB off the sample pool);
  the page is a pinned ROM cave whose FM SYNTH descriptor is a runtime
  clone of the stock FLEX record, built in the unit's RAM on first use --
  the repository carries no byte of the stock record. The AMP SETUP page
  (FUNC + AMP) of every audio track has a sixth box, LEG -- the legato
  switch, a Part byte saved with the project (a stock Part reads OFF; set
  MONO for the legato GLIDE used to give): OFF / MONO on a sample track
  (MONO: a key over a held key changes the pitch without a retrigger, and
  since 2.8 a FLEX or STATIC track with LEG MONO and GLIDE SLIDES every
  pitch change -- a legato key, a trigless trig's PTCH lock, the knob, an
  LFO -- over the GLIDE time, a sample trig starting at its own pitch),
  OFF / MONO / POLY on a synth track: MONO is legato at VOIC 1, POLY at
  any VOIC -- a key played over a held chord slides the sounding chord to
  its new voicing (or, with no shape, the newest voice), no retrigger,
  recorded as a trigless trig; GLIDE is the slide time only, everywhere.
  In GRID RECORDING, a placed trig held + FUNC + DOWN / UP moves that
  step's PTCH lock an octave down / up (every held trig; clamped -64..+63;
  a step without a lock starts from the Part's PTCH), the page showing the
  new value; with no trig held FUNC + UP / DOWN is still the trig-mode
  selector, as it is on every sample track.
  `synth/README.md`.
- **`quantizer/`** (key `SCALE QUANTIZER`) -- a SCALE row in PROJECT >
  CONTROL > SEQUENCER (24 scales): the PTCH knob, parameter locks and
  CHROMATIC trig keys snap to the scale; a GLIDE row, the synth's slide
  time (the legato switch is the track's LEG setting on every audio track:
  the quantizer's key hooks ask the synth engine); live recording on synth tracks writes the played note
  length as an AMP HOLD lock and hands every recorded key to the synth
  engine, which records fingered chords; on synth tracks the quantizer works in the
  synth's semitone units and gives the CHROMATIC keyboard its -4..+4
  octaves. SCALE and GLIDE live in the unit's
  battery-backed RAM (`0x100b14ec` / `0x100b14ed`), so they survive a power
  cycle like the stock project settings do (since v10; before, they came
  back OFF at every power-on although SAVE had written them to the project
  file). Since Octatrick 2.9 a ROOT row (C..B, `0x100b14ee`) under SCALE:
  the scale is built on the root -- knob, locks, keys and the synth's chord
  snap all read one root-rotated mask, and key 1 of the CHROMATIC keyboard
  sounds the root -- and the unit itself is a DRAM unit of the platform
  runtime: only a 192-byte core (the boot clamps, the defaults, the mask)
  and the two pinned stubs stay in the OS image. `quantizer/README.md`.
- **`direct-jump/`** (key `DIRECT JUMP`) -- CHAIN AFTER gains a DIRECT option
  (option 2 of the list): a pattern chosen while the sequencer runs starts
  at the next step, at the step count the old pattern had reached. One ROM
  cave on the pattern-queue setter, two pokes. `direct-jump/README.md`.
- **`tuner/`** (key `TUNER`) -- hold UP and press TEMPO: a tuner window for
  the current audio track (note, octave, a +-50 cent needle, Hz) from the
  track's post-FX pre-fader audio, detected on the ColdFire (McLeod NSDF +
  YIN refine, integer only) in the UI task; TEMPO, YES, NO or the chord
  close it, and TEMPO alone, FUNC + TEMPO and UP alone stay stock. One DRAM
  unit, three detours, no ROM cave. `tuner/README.md`.
- **`processor-load/`** (key `PROCESSOR LOAD`) -- how busy the ColdFire
  is making audio, in the stock TEMPO popup: `47%`, the mean share of
  real time spent in the audio frame interrupt over the last quarter
  second, timed on the stock DMA timer 3; `!` from 70 %, `--%` while there
  is no fresh reading, and with FUNC held `W112`, the longest single block
  of the quarter second in % of a block's 362.8 us. Standalone (no USB, no
  other module); it conflicts with octabam's CF METER and TEMPO BUS. One
  DRAM unit, four detours, one poke. `processor-load/README.md` says what
  the number means, what it cannot see (the DSPs, the UI, the card, USB)
  and its limits.

Each directory is one octabam module: `manifest.py` (the declaration, in
octabam's `tools/remix/schema.py` vocabulary), the GNU-as `.s` sources, and
a README that says what was measured and what was inferred. The manifests
derive their source paths from their own location (`_HERE`), so the same
file serves at `modules/<name>/` and at `modules/<name>/upstream/<name>/`.

**No stock bytes.** The sources carry no byte sequence of Elektron's OS
beyond the displaced instructions at each hook site (octabam's
CONTRIBUTING.md, "The one rule"): `tools/stock_scan.py --stock
<octabam>/out/raw/section_3_MAIN_OS.bin` looks every data directive, hex
constant and assembled unit up in your own stock image and lists what
matches (the hook-site replays and a few call idioms the assembler shares
with the stock compiler; no data).

## Using them

**In octabam** (merged 30 Sep 2026, sambanks/octabam PR #526): the module
folders `modules/synth`, `modules/quantizer`, `modules/direct-jump` and
`modules/tuner` are thin wrappers whose `upstream/` is this repository
(tag `v2.9`). Clone octabam with `--recurse-submodules` (or `git submodule
update --init`), follow its build guide (`docs/guide/BUILDING.md`: `make
setup`, `make os` and `make recon` with your own OS 1.40C), and

```
make image REMIX=octatrick BUILD=1 VERSION=OCTATRK2.9
```

builds the one `octatrick` remix: the four modules with markandrus's USB
MIDI and 20-channel USB audio out, Bryan T's USB audio in (the computer's
audio onto inputs A-D) and the stock effects less SPATIALIZER (its DSP
words hold the USB input). The author's own images have been built from
octabam's `main` since 30 Sep 2026.

PROCESSOR LOAD is not one of octabam's wrappers yet: copy (or link) this
repository's `processor-load/` to `modules/processor-load/` in an octabam
checkout (the manifest serves at either path) and add `"PROCESSOR LOAD"` to
a remix's `modules`.

**Standalone:** the manifests import `remix.schema` from octabam's `tools/`
and the build runs from octabam's repo root, so this repository is not
built on its own; it is linked into an octabam checkout.

## Status

`octatrick-usb` at tag `v9.1` (the OCTATRICK9 state; hardware-confirmed
again as OCTATRIK10 with the FM SYNTH page built at run time) was flashed
and in use on the author's Octatrack MKI (26 Sep 2026): the synth, the
quantizer and direct jump work, and USB audio works on the MKI on all 20
channels. Every test build since -- 2.3 .. 2.8 and the 2.9 line up to the
build before its last two fixes -- was flashed and tested on the same MKI
from the author's tree
([timhastie/octatrick](https://github.com/timhastie/octatrick), the same
wrappers over the same submodule); at 2.9 ROOT, the quantizer as a DRAM
unit, FINE 0c, the engine-owned AMP envelope and the limiter's removal ran
there, the held-chord crackle and the live-key pops gone, by ear; the tuner
(UP + TEMPO) works there too (29 Sep 2026). The last two 2.9 fixes (a sequencer trig on a sounding note, the index ramp) are
emulator-verified and not yet flashed; so is FM SYNTH in the machine list
(2.10, 8 Oct 2026). Every feature was verified in an
emulator before flashing (the companion repository
[timhastie/octa-panel](https://github.com/timhastie/octa-panel) has a
real-time build of octabam's emulator and a virtual front panel). Read
octabam's flashing notes first, power-cycle the unit after an OS upgrade,
and SAVE or SYNC TO CARD after changing project settings.

Combining with other modules: the synth page is pinned at the start of the
second free gap (`0x400d24d0`), which octabam's `tempo-bus` also uses, so
the ledger refuses that pair; the synth engine shares the sample-RAM
reserve with the other DRAM modules (USB, MIDI SCENES) inside one runtime.
PROCESSOR LOAD declares conflicts with octabam's CF METER (the same two
frame-interrupt sites) and TEMPO BUS (the TEMPO popup), and runs beside
everything in the `octatrick` remix.

## Tags

Only tagged versions are releases; the numbered builds between two tags
(2.3 .. 2.7 on the way to 2.8, the 2.9 builds before the tag) were test
builds on the author's unit and were never tagged.

- 2.11 (not tagged yet; 8 Oct 2026): PROCESSOR LOAD, a new module -- the
  ColdFire's audio-interrupt load in the TEMPO popup (the TEMPO meter of the
  author's diagnostic builds since b48, made standalone: its own UI tick,
  started by the stock startup flag, no USB; FUNC held shows the longest
  block). Emulator-verified; not yet flashed.
- 2.10 (not tagged yet; 5 - 8 Oct 2026): FM SYNTH in the machine list,
  four synth changes and three fixes. FM SYNTH is the sixth row of SRC SETUP
  (FUNC + SRC) and of SELECT MACHINE TYPE on every track: it plays with no
  sample and no marker file (the chooser adapted from Modwerk's FM Synth
  module, MIT); the marker files still work. A stock or older build reads such
  a track as a plain FLEX track: choose FLEX or STATIC before downgrading. The
  quantizer of the same tag is needed for CHROMATIC keys on such a track.
  The DEC knob puts HOLD at 127, the last position on the right (the index
  holds); 0 is the shortest decay (prints `0`) and 1..126 are unchanged. A
  saved DEC 0 (was HOLD) now decays at once; a saved 127 (was 2.0 s) now holds. The
  note-start click is gone: every attack lasts at least one carrier period
  and is S-shaped (attacks below C3 are slower: C1 reaches full level in
  31 ms, C3 in 9.4 ms), a pitch change on a sounding mono note crossfades, a
  stolen voice fades over a period, and a chord-memory or stolen voice that
  must move UP fades out first and starts its note cold (that note starts up
  to one period of the old note late). LFO SETUP's destination list on a synth track names
  the FM SYNTH page's parameters (PTCH RATO INDX FINE FDBK DEC ...) and
  steps over SPD3 / DEP3 (VOIC / CHRD). A held CHROMATIC key sustains and
  releases at the key-up; HOLD gates sequencer trigs only. The fixes, after
  the author's test of the first 2.10 build on his MKI: a note restarted
  while it still sounds (a quick re-press, a trig on its own tail) no longer
  clicks at a short DEC (the index envelope restarts and the index ramps over
  at least one carrier period, where DEC 0 dropped it within a frame); a
  second key inside a paraphonic voice's fade no longer drops the first
  key's note; a live-recorded legato phrase no longer goes silent at its
  first trigless step on playback. And the engine leaves 6 dB of headroom
  (the author's decision, 8 Oct): the mono voice and each paraphonic voice
  are 6.02 dB lower, so VOL 0 is the reference and VOL up to about +6 stays
  clean (not Modwerk 0.1.2's 18.06 dB).
- `v2.9` -- Octatrick 2.9 (29 Sep 2026): a ROOT row under SCALE (the scale
  is built on it; battery RAM `0x100b14ee`); the quantizer as a DRAM unit
  (a 192-byte core stays in the OS image); FINE 0c the moment a track
  becomes a synth track; no limiter; the engine owns the AMP envelope (no
  pops, no crackle; a voice is never cut); a sequencer trig on a sounding
  note delivered in the panel key's form; the index envelope ramps at a
  warm START. The line up to the build before the last two fixes ran on
  the author's MKI; the last two fixes are emulator-verified.
- `v2.8` -- Octatrick 2.8 (28 Sep 2026): MIDI IN on synth tracks, chord
  recording with inversions, LEG legato modes, sample-track glide, step
  transpose, the TUNER module, SCALE / GLIDE in battery-backed RAM, the
  tuning system (PTCH in semitones, FINE in cents), `tools/stock_scan.py`.
  Flashed and tested on the author's MKI through the test builds 2.3 .. 2.8.
- `v9.1` -- the OCTATRICK9 state with the FM SYNTH page built at run time
  (no stock bytes in the repository; hardware-confirmed as OCTATRIK10), the
  manifests' source paths location-independent. The history starts here:
  no commit carries stock OS bytes.

## Credits

- [Sam Banks](https://github.com/sambanks) -- octabam: the build system,
  the ledger, the DRAM platform, the emulators and the gates these modules
  are written against; and the CF METER probe, whose two frame-interrupt
  sites and DMA-timer-3 method PROCESSOR LOAD's measurement uses.
- [Maxolydian](https://github.com/mxldyn/octamax) -- octamax, the reverse
  engineering of the OS format, memory map and parameter tables that made
  any of this reachable.
- Bryan T ([bryantysinger](https://github.com/bryantysinger)) -- the EMAC
  notes in octabam's firmware documentation (the `objdump -m m68k:cfv4e`
  route for the EMAC regions radare2 cannot decode, `docs/remixer/
  TOOLING.md`), which the synth's EMAC rate arithmetic was written against.
- [markandrus](https://github.com/markandrus/octemu) -- USB MIDI and USB
  AUDIO, carried in the `octatrick-usb` remix.
- Modwerk contributors ([repeat98/modwerk](https://github.com/repeat98/modwerk),
  MIT) -- the FM SYNTH machine chooser: the sixth machine row in SRC SETUP and
  SELECT MACHINE TYPE, the `FM`, 1 Part signature, the Part-validator guard
  and the sample-free START / source path, adapted from Modwerk's FM Synth
  module (derived from its Analog BD chooser hooks, Sam Banks' MIT notice) and
  ported to this repository's manifests. Their notices are in [LICENSE](LICENSE).

## Unofficial

Not affiliated with, endorsed by or supported by Elektron. No firmware is
distributed here: every image is built on your machine from your own copy
of OS 1.40C, and modifying your unit's firmware is outside Elektron's
licence terms and warranty. Back up your projects before flashing.

## License

[MIT](LICENSE), Tim Hastie 2026, for this repository's own code and
documentation. The FM SYNTH machine chooser (`synth/machine.s` and its parts of
`synth/poly.s`, `synth/page.s` and `quantizer/quantizer.s`) is adapted from
Modwerk's FM Synth module under its MIT notices (Copyright (c) 2026 Modwerk
contributors; Copyright (c) 2026 Sam Banks), reproduced in [LICENSE](LICENSE).
It does not extend to Elektron's firmware, nor to octabam, which is Sam
Banks's under its own MIT licence.
