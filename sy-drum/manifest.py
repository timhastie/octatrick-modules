"""SY DRUM -- a drum machine for the Octatrack's FLEX tracks, modelled on a classic
analog two-voice drum synthesizer (the SY-1 circuit; README.md), running on SYNTH
MACHINE's engine: chosen in the machine list (SELECT MACHINE TYPE or SRC SETUP: the
row after FM SYNTH), it plays PTCH MODE WDTH SWEP SPED DEC on its PLAYBACK page (stock
p-locks, LFOs and scenes reach them) with a dedicated LFO / S&H on its PLAYBACK SETUP
page (LSPD LDEP WAVE S&H: the Part's defaults, each lockable per step -- the development
line's dedicated step locks, kept in sylockNN files beside the project's banks). Requires
SYNTH MACHINE (synth/): the machine
list, the sample-free voice transport, the engine-owned AMP envelope, the keys and MIDI
are that module's; SYNTH MACHINE assembles its calls into this unit when SY DRUM is in
the remix (synth/manifest.py remix_include: HAVE_SYDRUM).

One DRAM unit (sydrum.s, with engine.inc.s, the step locks' sources and
synth/engine_abi.inc through its remix.inc), a 2 MiB DramRegion (the lock table) and 52
detours of its own: the page resolver's epilogue (0x40031ed6), where a SY DRUM track gets
its PLAYBACK page, the setup editor (0x4003a524), and the step locks' 50 (sequencer, UI,
clipboard, card I/O; LOCK_HOOKS). Verified in ot_emu (README.md).
"""

import os

from remix.schema import Category, Detour, DramRegion, Kind, Linked, Module, Proof

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
    16-bit references out of reach, then the step locks (the setup stage, the lock table's
    code, the sequencer / UI / clipboard hooks and the card I/O; LOCKS below)."""
    return "\n".join((".ifndef SD_PASS1", ".set SD_PASS1, 1", ".set HAVE_SYDRUM, 1",
                      _read("..", "synth", "engine_abi.inc"), ".else", _read("engine.inc.s"),
                      *(_read(name + ".inc.s") for name in LOCKS), ".endif", ""))


# The step locks' sources, in the unit after the engine (pass 2 of remix.inc).
LOCKS = ("setup_stage", "locks_store", "locks_seq", "locks_ui", "locks_sparse", "locks_clip",
         "locks_transform", "locks_delete", "locks_live", "locks_io")


PAGE_HOOK = 0x40031ed6                  # `moveml %sp@,%d2-%d5; lea %sp@(16),%sp` (the page resolver's epilogue)
PAGE_STOCK = bytes.fromhex("4cd7003c" "4fef0010")
SETUP_EDIT_HOOK = 0x4003a524            # `lea 0x400d5f38,%a0; moveal %a0@(0,%d2:l:4),%a5` (the PLAYBACK SETUP editor)
SETUP_EDIT_STOCK = bytes.fromhex("41f9400d5f38" "2a702c00")

# The step locks' stock hooks (the development line's, 8 Oct 2026, less its setup-scene and
# LFO-destination hooks): (address, the displaced instructions, the routine, what it does).
# Each is a jmp detour padded to the displaced length; the routines are in locks_*.inc.s.
LOCK_HOOKS = (
    (0x4000bafe, "4cd030de48d230de", "sl_seq_consume",
     "Accepted/due event queue copy; d5 queueIndex=slot*8+track."),
    (0x4000c422, "2a6f00b84295", "sl_seq_full_restore",
     "Full Part/default publication and same-Part reload clear prior native lock state; preserve pending accepted row."),
    (0x4000c62e, "41f946104d15", "sl_seq_publish",
     "After native lock restoration and application, before existing po_retrig."),
    (0x40022c16, "c08167567001", "sl_io_background_request",
     "locks-only background dirty predicate"),
    (0x40026768, "2f02222f000c", "sl_clip_raw_capture_hook",
     "SY DRUM step lock clip raw capture hook"),
    (0x4002689c, "4fefffe448d71c3c", "sl_clip_page_copy_hook",
     "SY DRUM step lock clip page copy hook"),
    (0x40026990, "4fefffe448d71c3c", "sl_clip_page_undo_hook",
     "SY DRUM step lock clip page undo hook"),
    (0x40026eb0, "202f0004223c00008ed8", "sl_clip_pat_copy_hook",
     "SY DRUM step lock clip pat copy hook"),
    (0x40026ef0, "202f000841ef0004", "sl_clip_pat_undo_hook",
     "SY DRUM step lock clip pat undo hook"),
    (0x400294c0, "4feffff048d71c04", "sl_clip_track_capture_hook",
     "SY DRUM step lock clip track capture hook"),
    (0x40029754, "4fefffe448d73c1c", "sl_clip_full_capture_hook",
     "SY DRUM step lock clip full capture hook"),
    (0x4002a38c, "4fefffdc48d71cfc", "sl_clip_track_store_hook",
     "SY DRUM step lock clip track store hook"),
    (0x4002aefc, "4fefffd048d77cfc", "sl_clip_page_store_hook",
     "SY DRUM step lock clip page store hook"),
    (0x4002b450, "42b9460c80f4", "sl_clip_raw_restore_hook",
     "SY DRUM step lock clip raw restore hook"),
    (0x4002b654, "4fefffbc48d77cfc", "sl_clip_full_store_hook",
     "SY DRUM step lock clip full store hook"),
    (0x4002b9b0, "4feffff048d7041c", "sl_clip_pat_store_hook",
     "SY DRUM step lock clip pat store hook"),
    (0x4002bf38, "4fefffc048d77cfc", "sl_sparse_capture_hook",
     "Snapshot native tag1 selected-trig clipboard or undo companion rows"),
    (0x4002cb92, "103c0001e9a84680", "sl_sparse_store_hook",
     "Paste companion row using exact native selected-trig mapping"),
    (0x40033aac, "4cd77cfc4fef002c", "sl_ui_cache_full_tail",
     "Overlay companion locks after full native has-lock cache refresh"),
    (0x40033b32, "4cd7001c4fef000c", "sl_ui_cache_row_tail",
     "Overlay companion locks after native single-row cache refresh"),
    (0x400388a8, "4aaf003867000168", "sl_live_erase_hook",
     "Clear companion rows at actual live playhead for full trig or all-lock erase"),
    (0x40038b06, "4cd77cfc4fef0030", "sl_live_erase_tail",
     "Retain companion has-lock bit after native selected-column live erase"),
    (0x400398b4, "4fefffd448d77cfc", "sl_clear_page_hook",
     "Clear companion rows with native audio page clear"),
    (0x40039df4, "4fefffc448d77cfc", "sl_clear_track_hook",
     "Clear companion rows when native clears normal audio track sequence"),
    (0x4003a614, "43f3bc0141f946c7d244", "sl_live_edit_hook",
     "SY DRUM step lock live edit hook"),
    (0x4003d916, "202f007c08000000", "sl_shift_hook",
     "Rotate companion rows over exact native active sequence length"),
    (0x40040e14, "4fefffd448d77cfc", "sl_clear_selected_hook",
     "Clear companion rows with native selected-trig/all-locks clear"),
    (0x4005040c, "4fefffb448d77cfc", "sl_ui_key_hook",
     "Dedicated setup encoder press/release on held audio trigs"),
    (0x40050fd6, "4eb94002ce54", "sl_ui_trig_press_hook",
     "a trig press changed the held mask -- redraw an open SY DRUM PLAYBACK SETUP window, then the stock call"),
    (0x4005fbd2, "4eb94002ce54", "sl_ui_trig_rel_hook",
     "a trig release changed the held mask -- redraw an open SY DRUM PLAYBACK SETUP window, then the stock call"),
    (0x400508e4, "4fefffb048d77cfc", "sl_ui_held_knob_hook",
     "Handle SY DRUM dedicated setup held-trig knob map before native modal-window rejection"),
    (0x400603f2, "41f946c7d48c", "sl_grid_delete_hook",
     "Clear companion row after ordinary GRID tap-delete clears the native audio lock row inline."),
    (0x4008485e, "7192722db280", "sl_io_dispatch",
     "engine dispatch preflush/context"),
    (0x4008ec4c, "4feffebc48d70c3c", "sl_io_delete",
     "remove only known lock companions on explicit project delete"),
    (0x4008eda4, "4feffdcc48d77cfc", "sl_io_bank_store",
     "selected mask STORED save"),
    (0x4008ee74, "4e56fdd048d73cfc", "sl_io_project_store",
     "project WORK/STORED save"),
    (0x4008f0b0, "4feffdcc48d77cfc", "sl_io_bank_restore",
     "selected mask saved restore"),
    (0x4008f180, "4e56fdd048d73cfc", "sl_io_project_restore",
     "project saved lock restore"),
    (0x400905d4, "4feffeb848d77cfc", "sl_io_banks_load",
     "validated project cache load"),
    (0x400909d8, "2f0a42a74eb94000fd34", "sl_io_clear",
     "clear project cache, clip and sequencer state"),
    (0x400912c4, "4fefff9848d73cfc", "sl_io_export",
     "carry validated companion pair to export"),
    (0x400917c8, "4e56febc48d73cfc", "sl_io_banks_save",
     "WORK flush and SAVE TO NEW/empty destination"),
    (0x400919e4, "4feffff448d7001c", "sl_io_card_sync",
     "all dirty lock banks before card SYNC"),
    (0x4009a664, "4cd73cfc4fef0028", "sl_page_nonempty_tail",
     "Protect companion-only destination page from scale auto-overwrite"),
    (0x4009b220, "2f0243f980006500", "sl_seq_queue_clear",
     "Stock future queue reset only; active/pending/scratch preserved."),
    (0x4009b86e, "43f946c7a874", "sl_seq_promote_a",
     "First native scratch-to-queue-zero promotion; d3 track."),
    (0x4009c04e, "43f946c7a874", "sl_seq_promote_b",
     "Second native scratch-to-queue-zero promotion; d4 track."),
    (0x4009c8bc, "4fefffac48d77cfc", "sl_duplicate_hook",
     "Duplicate companion page for explicit or scale-driven audio page duplication"),
    (0x4009d1e8, "4fefff9848d77cfc", "sl_seq_produce",
     "Stock audio queue producer prologue; source bank/pattern/step are cdecl arguments."),
    (0x4009d39e, "260dc08367000576", "sl_seq_eligible",
     "After native condition acceptance; ephemeral dedicated-only lock trigger acceptance."),
)

# The lock table: 16 banks x 8,192 rows x 16 bytes, uninitialised DRAM at the top of the
# platform's arena reserve (locks_store.inc.s; sl_reset fills it before any reader).
LOCK_TABLE_BYTES = 16 * 8192 * 16

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
        "dedicated LFO / S&H (LSPD LDEP WAVE S&H) on its PLAYBACK SETUP page, lockable per step "
        "(sylockNN files beside the banks). Needs SYNTH MACHINE.",
    linked=(
        Linked("sydrum", os.path.join(_HERE, "sydrum.s"), cpu="5475", dram=True, include=remix_include),
    ),
    detours=(
        Detour(PAGE_HOOK, PAGE_STOCK, "sydrum", "sd_page",
               "the page resolver's epilogue: the PLAYBACK page of a FLEX track with SY DRUM chosen (\"SY\", 1) "
               "is SY DRUM's (PTCH MODE WDTH SWEP SPED DEC; its SETUP half LSPD LDEP WAVE S&H); every other "
               "lookup untouched",
               kind="jmp", pad_to=8),
        Detour(SETUP_EDIT_HOOK, SETUP_EDIT_STOCK, "sydrum", "sd_setup_edit",
               "PLAYBACK SETUP editor on SY DRUM's page: held trigs edit the step locks, a default edit "
               "releases the playing step's lock of that control; every other page stock",
               kind="jmp", pad_to=10),
    ) + tuple(Detour(address, bytes.fromhex(stock), "sydrum", symbol, what, kind="jmp",
                     pad_to=len(stock) // 2)
              for address, stock, symbol, what in LOCK_HOOKS),
    dram_regions=(DramRegion("sl_work_table", LOCK_TABLE_BYTES),),
    conflicts=(("KITS", "both hook the project load / save / reload / clear jobs and the pattern clipboard "
                        "(SY DRUM's step-lock files and clipboard)"),
               ("PLOCKS P2", "both hook the sequencer's lock queue and clear paths and the held-trig encoder "
                             "(SY DRUM's step locks)"),),
)
