# octatrick-modules

Three firmware modules for the Elektron Octatrack (OS 1.40C, MKI and MKII),
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
  FLEX track whose sample is named SYNTH*.wav becomes a synth (a silent 4 s
  marker file will do), with its own PLAYBACK page (PTCH RATO INDX RATE
  FDBK DEC), and on the LFO page VOIC (1 = mono, 2..4 = paraphonic) and
  CHRD (32 chord shapes, lockable per step, snapped to SCALE). The engine is
  a DRAM unit in octabam's sample-RAM reserve (10 MB off the sample pool);
  the page is a pinned ROM cave. `synth/README.md`.
- **`quantizer/`** (key `SCALE QUANTIZER`) -- a SCALE row in PROJECT >
  CONTROL > SEQUENCER (24 scales): the PTCH knob, parameter locks and
  CHROMATIC trig keys snap to the scale; a GLIDE row with 303-style legato
  for the synth; live recording on synth tracks writes the played note
  length as an AMP HOLD lock. Four ROM units. `quantizer/README.md`.
- **`direct-jump/`** (key `DIRECT JUMP`) -- CHAIN AFTER gains a DIRECT option
  (option 2 of the list): a pattern chosen while the sequencer runs starts
  at the next step, at the step count the old pattern had reached. One ROM
  cave on the pattern-queue setter, two pokes. `direct-jump/README.md`.

Each directory is one octabam module: `manifest.py` (the declaration, in
octabam's `tools/remix/schema.py` vocabulary), the GNU-as `.s` sources, and
a README that says what was measured and what was inferred. The manifests
derive their source paths from their own location (`_HERE`), so the same
file serves at `modules/<name>/` and at `modules/<name>/upstream/<name>/`.

## Using them

**In octabam** (once merged, or on the PR branch): the three module folders
`modules/synth`, `modules/quantizer` and `modules/direct-jump` are thin
wrappers whose `upstream/` is this repository. Clone with
`--recurse-submodules` (or `git submodule update --init`), then follow
octabam's build guide (`docs/remixes/BUILDING.md`): `make setup`, `make os`
and `make recon` with your own OS 1.40C, and

```
make image REMIX=octatrick-usb BUILD=1 VERSION=OCTATRICK1
```

(`REMIX=octatrick` for the build without USB.) The remixes
`remixes/octatrick.py` (the three modules plus the fourteen stock effects,
fallback NONE, so both DSP payloads and the effect chooser stay stock) and
`remixes/octatrick-usb.py` (the same plus markandrus's USB MIDI and USB
AUDIO) live in octabam beside the wrappers.

**Ready to build today:** [timhastie/octatrick](https://github.com/timhastie/octatrick)
is octabam's `main` plus those wrappers, this repository as the submodule,
and the two remixes -- the tree the author's own images are built from.

**Standalone:** the manifests import `remix.schema` from octabam's `tools/`
and the build runs from octabam's repo root, so this repository is not
built on its own; it is linked into an octabam checkout.

## Status

`octatrick-usb` at tag `v9` (OCTATRICK9) is flashed and in use on the
author's Octatrack MKI (26 Sep 2026): the synth, the quantizer and direct
jump work, and USB audio works on the MKI on all 20 channels. Every feature
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
