# SY DRUM -- a drum machine in the machine list (2.11)

SY DRUM is a percussion voice for FLEX tracks: two oscillators, a sweep, a two-pole filter opened by the decay
envelope, six modes, and a dedicated LFO with sample-and-hold. It runs on SYNTH MACHINE's engine (`synth/`, key
`SYNTH MACHINE`) and is chosen in the track's machine list, in the row after FM SYNTH.

SY DRUM is modelled on the 1979 Pearl Syncussion SY-1, written from a study of that unit's circuit. It is not affiliated with or endorsed by Pearl or Behringer. Syncussion is a trademark of its owner.

The module is key `SY DRUM` and **requires `SYNTH MACHINE`** (octabam refuses a remix that has SY DRUM without it):
the machine list, the sample-free voice, the engine-owned AMP envelope, the CHROMATIC keys, MIDI IN, LEG and the
live recorder are that module's. With SY DRUM in the remix, SYNTH MACHINE assembles its calls into SY DRUM's unit
and adds the row; without it, SYNTH MACHINE is byte for byte the FM-only engine.

## Choosing it

- **SELECT MACHINE TYPE**: press the track key twice (QUICK ASSIGN), LEFT (`<< MACHINE`), DOWN to `SY DRUM` (the
  seventh row: STATIC FLEX THRU NEIGHBOR PICKUP FM SYNTH SY DRUM; the window shows six rows and scrolls), YES.
- **SRC SETUP**: hold FUNC and press the PLAYBACK (SRC) key, DOWN to `SY DRUM`, YES.

The track is stored as FLEX with `S`, `Y`, 1 in the first three bytes of its NEIGHBOR PLAYBACK column (the FM
SYNTH mechanism; synth/README.md, "Selecting FM SYNTH from the machine list"): no sample and no marker file. The
PLAYBACK page reads `PTCH MODE WDTH SWEP SPED DEC`, the title and footer `SY DRUM`, and both lists open on the
`SY DRUM` row. Choosing it on a track that does not play SY DRUM yet sets the knobs to PTCH 0, MODE A, WDTH 64,
SWEP 0, SPED 64, DEC 64 and the setup to LSPD 64, LDEP 0, WAVE OFF, S&H OFF; choosing it again keeps the patch.
Choosing any other row clears the mark and puts the stock FLEX setup values back (LSPD .. S&H are no sample
settings). The choice is a Part byte like the machine: saved with the Part and the project, copied and pasted
with the Part.

**Downgrading**: a build without SY DRUM reads such a track as a plain FLEX track with no sample (silent); the stock
loader then clamps its PLAYBACK / SETUP bytes into FLEX's ranges. Choose a stock machine and SAVE before flashing
such a build.

## Knobs (PLAYBACK)

| Knob | Display | Meaning |
| --- | --- | --- |
| PTCH | -64..+63 semitones | C4 at 0; the CHROMATIC keys, MIDI IN and the SCALE quantizer use semitones. |
| MODE | A..F | Triangle; exponential FM; mixed oscillators; independently swept oscillators; FM pseudo-saw; noise. The six choices are spaced evenly across the dial. |
| WDTH | 0..127 | The decay envelope opens the two-pole low-pass filter; turn left for a darker attack and tail (at C4 with no sweep or LFO, WDTH 0 sets the poles to 50 / 200 Hz). |
| SWEP | -64..+63 | Negative starts above PTCH and sweeps down; positive starts below and sweeps up; 0 is off. |
| SPED | 20 ms..1.1 s | The sweep's time constant; clockwise is longer and slower. |
| DEC | 6 ms..2.5 s | The amplitude decay's time constant at C4; higher tuning shortens it. |

These are the FLEX PLAYBACK bytes, so stock p-locks, the three LFOs and scenes reach them as on any FLEX track. An
encoder pressed gives steps of seven; with FUNCTION held a detent moves PTCH 12, MODE 1, WDTH 16, SWEP 12, SPED 16,
DEC 16. The AMP page (ATK, HOLD, REL, VOL, BAL) works as on FM SYNTH: the engine runs the envelope; a CHROMATIC key
sustains while held, sequencer trigs use HOLD.

## The LFO (PLAYBACK SETUP: FUNC + PLAYBACK)

| Encoder | Control | Meaning |
| --- | --- | --- |
| A | LSPD | Free-running LFO speed, 0.40..200.0 Hz (raw 0..64: 0.40..4.56 Hz, above it exponential to 200 Hz). |
| B | LDEP | Continuous LFO depth, 0..127; nominally +-24 semitones at maximum. |
| C | WAVE | OFF, TRI, SQR or RND. RND steps to a new random value each LFO cycle when S&H is off. |
| D | S&H | Capture the selected waveform at each hit; RND draws a fresh random value per hit. WAVE OFF samples the triangle. |
| E, F | blank | |

The oscillator runs on between hits. S&H has its own fixed nominal +-24-semitone range, independent of LDEP;
switching S&H off makes the next hit capture zero. Continuous TRI / SQR and S&H add to the tuning, so they move the
oscillators' pitch, the filter's tracking and the tuning-dependent decay. With RND and S&H on, each hit draws a new
value and holds it to the next hit. The random streams are separate for each track and are not restarted by notes;
a cold boot starts them again.

The four setup controls are **Part settings** in this version: saved with the Part, edited on the page, not
lockable per step, not in scenes and not LFO destinations (see "What v1 leaves out"). The three ordinary Octatrack
LFOs work on the PLAYBACK knobs as on any track; the LFO page is the stock one (no VOIC / CHRD: SY DRUM is one
voice a track).

## Playing it

- One voice a track, any number of tracks: every SY DRUM track has its own state and patch.
- A trig recharges both envelopes; a trig on a sounding note keeps the oscillators' phase and the filter (warm).
- LEG MONO (AMP SETUP's sixth box): a legato key recharges the envelopes when its pitch arrives, without a new START.
  SY DRUM offers LEG OFF / MONO, as a sample track does.
- PTCH, SWEP, the CHROMATIC keys and MIDI notes are in semitones, as on FM SYNTH; the SCALE quantizer snaps PTCH.
- No chords, no VOIC, no fingered-chord recording (FM SYNTH's).

## What v1 leaves out

The author's development builds (Octatrick 3.0) have more than this module: per-step locks of the four setup
controls (kept in companion files on the card), setup scenes, the setup controls as LFO destinations, and a marker
file that selects the machine from a FLEX slot. They need a private card file format and about seventy more stock
hooks across copy, paste, clear, undo and save, so they stay out of the public module; they can follow as an
addition (nothing stored here would change).

## How it works

- `sydrum.s` is one DRAM unit in octabam's platform reserve, linked beside SYNTH MACHINE's `poly.s` and `machine.s`.
  Its `remix.inc` (written per remix by the manifest) brings `synth/engine_abi.inc` -- the equates the two modules
  share, one copy -- and, at the unit's end, `engine.inc.s`, the engine: the model in fixed point, its tables and
  the per-track state (`sy1_*`).
- SYNTH MACHINE's `poly.s` calls it where its own FM engine runs, when the remix carries SY DRUM: at a START
  (`sd_trigger`: the envelopes recharge; `sy1_kind[t]`, the engine a track's last START chose, 0 FM or 1 SY DRUM),
  every frame (`sy1_mono_frame`: the controls from the frame's parameter record), every render call
  (`sy1_mono_render`: the samples), and once a frame from its clock (`sd_tick`: the setup controls to the engine,
  the CF record's sample settings neutral on SY DRUM tracks, the LFOs). The machine-list row is `sd_row` in
  SYNTH MACHINE's row table (`synth/machine.s`, `ml_rows`).
- One hook of its own: the page resolver's epilogue (`0x40031ed6`, `sd_page`): a FLEX track whose page would be the
  stock FLEX page and which has SY DRUM chosen gets SY DRUM's page -- a run-time clone of the FM SYNTH page (itself a
  clone of the stock FLEX record built in RAM; the repository carries no byte of it) with SY DRUM's title, names,
  ranges, formatters, widgets and knob handler, and a setup half with LSPD LDEP WAVE S&H. The same clone is SRC
  SETUP's page for the SY DRUM row.
- `tools/gen_tables.py --check` checks the generated tables against the calibration constants; `tools/sy1_model.py`
  and `tools/sy1_mod_model.py` are the float reference models the engine was written against.

## Measured

(filled in below by date)
