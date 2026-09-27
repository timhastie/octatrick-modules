# octatrick-modules

Four firmware modules for the Elektron Octatrack (OS 1.40C, MKI and MKII),
written for [sambanks/octabam](https://github.com/sambanks/octabam)'s build
system. **This repository is the source of truth for the modules**: octabam
consumes it as a git submodule (`modules/<name>/upstream`, pinned to a tag),
and the ready-to-build fork below does the same.

[![Octatrick demo video: the FM synth, scale quantizer and direct jump running on a real Octatrack MKI](https://img.youtube.com/vi/1DqUzvs8J3U/maxresdefault.jpg)](https://www.youtube.com/watch?v=1DqUzvs8J3U)

**Demo video:** [Octatrick running on a real Octatrack MKI (YouTube)](https://www.youtube.com/watch?v=1DqUzvs8J3U)
-- the FM synth, scale quantizer and direct jump in use. Click the picture
to watch.

## The modules

- **`synth/`** (key `SYNTH MACHINE`) -- a two-operator FM synth machine: any
  FLEX track whose sample is named FMSYNTH*.wav becomes a synth (a silent
  4 s marker file will do; SYNTH*.wav is still accepted; the marker never
  ends the note -- the AMP envelope or a key release does), with its own PLAYBACK page (PTCH RATO INDX FINE
  FDBK DEC: PTCH in semitones, -64..+63, FINE in cents), and on the LFO
  page VOIC (1 = mono, 2..4 = paraphonic: the most voices the track sounds
  at once, keys and chords alike) and CHRD (32 chord shapes as four-note
  voicings in priority order, in Syntakt order since 2.8 -- the triads MIN
  MAJ SU2 SU4, the sevenths and adds, the rest, the two-note intervals
  last (a CHRD byte saved by 2.7 names another shape) -- each at four
  detents -- the root position
  and three inversions (MIN MIN1 MIN2 MIN3 MAJ ...): VOIC 2 / 3 / 4 plays
  2 / 3 / 4 notes of any shape, a new chord replaces the last; lockable
  per step, snapped to SCALE); a voice is 1/sqrt(VOIC) of the mono voice,
  equal power, with a peak limiter holding the sum at the mono voice's
  full scale. A chord fingered on the CHROMATIC keys or over MIDI IN
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
  file). Three ROM units. `quantizer/README.md`.
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

**In octabam** (once merged, or on the PR branch): the module folders
`modules/synth`, `modules/quantizer`, `modules/direct-jump` and
`modules/tuner` are thin wrappers whose `upstream/` is this repository. Clone with
`--recurse-submodules` (or `git submodule update --init`), then follow
octabam's build guide (`docs/remixes/BUILDING.md`): `make setup`, `make os`
and `make recon` with your own OS 1.40C, and

```
make image REMIX=octatrick-usb BUILD=1 VERSION=OCTATRICK1
```

(`REMIX=octatrick` for the build without USB, `REMIX=octatrick-tuner` for
USB plus the tuner.) The remixes `remixes/octatrick.py` (synth, quantizer
and direct jump plus the fourteen stock effects, fallback NONE, so both DSP
payloads and the effect chooser stay stock), `remixes/octatrick-usb.py`
(the same plus markandrus's USB MIDI and USB AUDIO) and
`remixes/octatrick-tuner.py` (`octatrick-usb` plus TUNER) live in octabam
beside the wrappers.

**Ready to build today:** [timhastie/octatrick](https://github.com/timhastie/octatrick)
is octabam's `main` plus those wrappers, this repository as the submodule,
and the three remixes -- the tree the author's own images are built from.

**Standalone:** the manifests import `remix.schema` from octabam's `tools/`
and the build runs from octabam's repo root, so this repository is not
built on its own; it is linked into an octabam checkout.

## Status

`octatrick-usb` at tag `v9` (OCTATRICK9) is flashed and in use on the
author's Octatrack MKI (26 Sep 2026): the synth, the quantizer and direct
jump work, and USB audio works on the MKI on all 20 channels. Tag `v10`
(the runtime page clone, SCALE/GLIDE in battery RAM, the tuner) is
emulator-verified and not yet flashed. Every feature
was verified in an emulator before flashing (the companion repository
[timhastie/octa-panel](https://github.com/timhastie/octa-panel) has a
real-time build of octabam's emulator and a virtual front panel). Read
octabam's `docs/remixer/FLASHING.md` first, power-cycle the unit after an
OS upgrade, and SAVE or SYNC TO CARD after changing project settings.

Combining with other modules: the synth page is pinned at the start of the
second free gap (`0x400d24d0`), which octabam's `tempo-bus` also uses, so
the ledger refuses that pair; the synth engine shares the sample-RAM
reserve with the other DRAM modules (USB, MIDI SCENES) inside one runtime.

## Tags

- (unreleased, branch `tuning`, 27 Sep 2026) -- the tuning system: PTCH in
  semitones and RATE as FINE on synth tracks, the -4..+4 CHROMATIC octave
  with exact recorded locks, chord shapes in priority order, and the
  quantizer's `qz_polytrack` offset fix (VOIC read on every track).
  Emulator-verified as OCTATRIK12, not flashed.
- `v10` -- the synth page's FM SYNTH descriptor is built at runtime (no
  stock bytes in the repository, the pinned page cave 1,672 B); SCALE and
  GLIDE moved into battery-backed RAM and survive a power cycle (the
  quantizer's `glide.s` is gone: two jsr detours, in stock's boot sanitiser
  and in the project defaults, keep the bytes sane); the TUNER module;
  `tools/stock_scan.py`. Emulator-verified, not yet flashed.
- `v9` -- the OCTATRICK9 state: the modules exactly as flashed on the
  author's MKI on 26 Sep 2026, with the manifests' source paths made
  location-independent (no byte of any image changes).

## Credits

- [Sam Banks](https://github.com/sambanks) -- octabam: the build system,
  the ledger, the DRAM platform, the emulators and the gates these modules
  are written against.
- [Maxolydian](https://github.com/mxldyn/octamax) -- octamax, the reverse
  engineering of the OS format, memory map and parameter tables that made
  any of this reachable.
- Bryan T ([bryantysinger](https://github.com/bryantysinger)) -- the EMAC
  notes in octabam's firmware documentation (the `objdump -m m68k:cfv4e`
  route for the EMAC regions radare2 cannot decode, `docs/remixer/
  TOOLING.md`), which the synth's EMAC rate arithmetic was written against.
- [markandrus](https://github.com/markandrus/octemu) -- USB MIDI and USB
  AUDIO, carried in the `octatrick-usb` remix.

## Unofficial

Not affiliated with, endorsed by or supported by Elektron. No firmware is
distributed here: every image is built on your machine from your own copy
of OS 1.40C, and modifying your unit's firmware is outside Elektron's
licence terms and warranty. Back up your projects before flashing.

## License

[MIT](LICENSE), Tim Hastie 2026, for this repository's own code and
documentation. It does not extend to Elektron's firmware, nor to octabam,
which is Sam Banks's under its own MIT licence.
