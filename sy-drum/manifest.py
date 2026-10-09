"""SY DRUM -- a drum machine for the Octatrack's FLEX tracks, modelled on a classic
analog two-voice drum synthesizer (the SY-1 circuit; README.md), running on SYNTH
MACHINE's engine: chosen in the machine list (SELECT MACHINE TYPE or SRC SETUP: the
row after FM SYNTH), it plays PTCH MODE WDTH SWEP SPED DEC on its PLAYBACK page (stock
p-locks, LFOs and scenes reach them) with a dedicated LFO / S&H on its PLAYBACK SETUP
page (LSPD LDEP WAVE S&H, Part settings). Requires SYNTH MACHINE (synth/): the machine
list, the sample-free voice transport, the engine-owned AMP envelope, the keys and MIDI
are that module's; SYNTH MACHINE assembles its calls into this unit when SY DRUM is in
the remix (synth/manifest.py remix_include: HAVE_SYDRUM).

One DRAM unit (sydrum.s, with engine.inc.s and synth/engine_abi.inc through its
remix.inc) and one detour of its own: the page resolver's epilogue (0x40031ed6), where
a SY DRUM track gets its PLAYBACK page. Verified in ot_emu (README.md).
"""

import os

from remix.schema import Category, Detour, Kind, Linked, Module, Proof

# This module's directory relative to the build's cwd (octabam's repo root): "modules/
# sy-drum" checked out directly, "modules/sy-drum/upstream/sy-drum" as octabam's
# submodule of timhastie/octatrick-modules. SYNTH MACHINE's directory is its sibling.
_HERE = os.path.relpath(os.path.dirname(os.path.realpath(__file__)))
_DIR = os.path.dirname(os.path.realpath(__file__))


def _read(*parts):
    with open(os.path.join(_DIR, *parts), encoding="utf-8") as source:
        return source.read()


def remix_include(modules):
    """sydrum.s's remix.inc, included twice: pass 1 at the top of the unit -- the flag
    SYNTH MACHINE's units use (always 1 here: SY DRUM requires SYNTH MACHINE and is in this
    remix) and the equates the two share (synth/engine_abi.inc, one copy); pass 2 at its
    end -- the engine (engine.inc.s), whose 40 KB of tables would otherwise put the glue's
    16-bit references out of reach."""
    return "\n".join((".ifndef SD_PASS1", ".set SD_PASS1, 1", ".set HAVE_SYDRUM, 1",
                      _read("..", "synth", "engine_abi.inc"), ".else", _read("engine.inc.s"), ".endif"))


PAGE_HOOK = 0x40031ed6                  # `moveml %sp@,%d2-%d5; lea %sp@(16),%sp` (the page resolver's epilogue)
PAGE_STOCK = bytes.fromhex("4cd7003c" "4fef0010")

MODULE = Module(
    name="sy-drum",
    key="SY DRUM",
    kind=Kind.CF_PATCH,
    requires=("SYNTH MACHINE",),
    category=Category.MACHINES,
    author="timhastie/octatrick-modules",
    author_url="https://github.com/timhastie/octatrick-modules",
    proof=Proof.PORT,
    proof_note="ot_emu (MKII panel, DSP lockstep) with SYNTH MACHINE 2.11: the machine-list walk, "
               "renders sample-identical to the dev line's on-board engine, save / reload; not yet on hardware",
    doc="SY DRUM in the machine list (after FM SYNTH): a two-voice analog-style drum machine on FLEX "
        "tracks -- PTCH MODE (A..F) WDTH SWEP SPED DEC with stock p-locks, LFOs and scenes, and a "
        "dedicated LFO / S&H (LSPD LDEP WAVE S&H) on its PLAYBACK SETUP page. Needs SYNTH MACHINE.",
    linked=(
        Linked("sydrum", os.path.join(_HERE, "sydrum.s"), cpu="5475", dram=True, include=remix_include),
    ),
    detours=(
        Detour(PAGE_HOOK, PAGE_STOCK, "sydrum", "sd_page",
               "the page resolver's epilogue: the PLAYBACK page of a FLEX track with SY DRUM chosen (\"SY\", 1) "
               "is SY DRUM's (PTCH MODE WDTH SWEP SPED DEC; its SETUP half LSPD LDEP WAVE S&H); every other "
               "lookup untouched",
               kind="jmp", pad_to=8),
    ),
)
