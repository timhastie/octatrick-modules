"""SY DRUM -- a drum machine for the Octatrack's FLEX tracks, modelled on a classic
analog drum synthesizer (the SY-1 circuit; README.md), one voice a track, running on SYNTH
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
synth/engine_abi.inc through its remix.inc), a 2 MiB DramRegion (the lock table) and 53
detours of its own: the page resolver's epilogue (0x40031ed6), where a SY DRUM track gets
its PLAYBACK page, the setup editor (0x4003a524), and the step locks' 51 (sequencer, UI,
clipboard, card I/O; LOCK_HOOKS). Not with STEM REC: the lock table and STEM REC's buffers
together exceed the platform reserve (conflicts). Verified in ot_emu (README.md).
"""

import importlib.util
import os

from remix.schema import Category, Detour, DramRegion, Kind, Linked, Module, Proof

# This module's directory relative to the build's cwd (octabam's repo root): "modules/
# sy-drum" checked out directly, "modules/sy-drum/upstream/sy-drum" as octabam's
# submodule of timhastie/octatrick-modules. SYNTH MACHINE's directory is its sibling.
_HERE = os.path.relpath(os.path.dirname(os.path.realpath(__file__)))
_DIR = os.path.dirname(os.path.realpath(__file__))

# The displaced bytes of each detour are read from the build's own MAIN OS section (stock_guard.py, the same
# reader the synth and quantizer modules carry): no stock bytes in this file.
_guard_spec = importlib.util.spec_from_file_location("sd_stock_guard", os.path.join(_HERE, "stock_guard.py"))
_guard_module = importlib.util.module_from_spec(_guard_spec)
_guard_spec.loader.exec_module(_guard_module)
stock_guard = _guard_module.stock_guard


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
                      ".global sl_io_dispatch,sl_io_background_request,sl_io_tick_hook",
                      *(_read(name + ".inc.s") for name in LOCKS), ".endif", ""))


# The step locks' sources, in the unit after the engine (pass 2 of remix.inc).
LOCKS = ("setup_stage", "locks_store", "locks_seq", "locks_ui", "locks_sparse", "locks_clip",
         "locks_transform", "locks_delete", "locks_live", "scenes_store", "scenes_ui", "scenes_ops",
         "locks_io")


PAGE_HOOK = 0x40031ed6                  # the restore of d2-d5 from the stack and the release of 16 stack bytes (the page resolver's epilogue)
PAGE_LEN = 8
SETUP_EDIT_HOOK = 0x4003a524            # the machine table's address 0x400d5f38 into a0 and the descriptor pointer it holds for row d2 into a5 (the PLAYBACK SETUP editor)
SETUP_EDIT_LEN = 10

# The step locks' stock hooks (the development line's, 8 Oct 2026, less its setup-scene and
# LFO-destination hooks): (address, the displaced length, the routine, what it does).
# Each is a jmp detour padded to the displaced length; the routines are in locks_*.inc.s.
LOCK_HOOKS = (
    (0x4000bafe, 8, "sl_seq_consume",
     "Accepted/due event queue copy; d5 queueIndex=slot*8+track."),
    (0x4000c422, 6, "sl_seq_full_restore",
     "Full Part/default publication and same-Part reload clear prior native lock state; preserve pending accepted row."),
    (0x4000c62e, 6, "sl_seq_publish",
     "After native lock restoration and application, before existing po_retrig."),
    (0x40022c16, 6, "sl_io_background_request",
     "locks-only background dirty predicate"),
    (0x4005224a, 8, "sl_io_tick_hook",
     "UI tick's transport test: while the sequencer plays, the lock files' own background flush"),
    (0x40026768, 6, "sl_clip_raw_capture_hook",
     "SY DRUM step lock clip raw capture hook"),
    (0x4002689c, 8, "sl_clip_page_copy_hook",
     "SY DRUM step lock clip page copy hook"),
    (0x40026990, 8, "sl_clip_page_undo_hook",
     "SY DRUM step lock clip page undo hook"),
    (0x40026eb0, 10, "sl_clip_pat_copy_hook",
     "SY DRUM step lock clip pat copy hook"),
    (0x40026ef0, 8, "sl_clip_pat_undo_hook",
     "SY DRUM step lock clip pat undo hook"),
    (0x400294c0, 8, "sl_clip_track_capture_hook",
     "SY DRUM step lock clip track capture hook"),
    (0x40029754, 8, "sl_clip_full_capture_hook",
     "SY DRUM step lock clip full capture hook"),
    (0x4002a38c, 8, "sl_clip_track_store_hook",
     "SY DRUM step lock clip track store hook"),
    (0x4002aefc, 8, "sl_clip_page_store_hook",
     "SY DRUM step lock clip page store hook"),
    (0x4002b450, 6, "sl_clip_raw_restore_hook",
     "SY DRUM step lock clip raw restore hook"),
    (0x4002b654, 8, "sl_clip_full_store_hook",
     "SY DRUM step lock clip full store hook"),
    (0x4002b9b0, 8, "sl_clip_pat_store_hook",
     "SY DRUM step lock clip pat store hook"),
    (0x4002bf38, 8, "sl_sparse_capture_hook",
     "Snapshot native tag1 selected-trig clipboard or undo companion rows"),
    (0x4002cb92, 8, "sl_sparse_store_hook",
     "Paste companion row using exact native selected-trig mapping"),
    (0x40033aac, 8, "sl_ui_cache_full_tail",
     "Overlay companion locks after full native has-lock cache refresh"),
    (0x40033b32, 8, "sl_ui_cache_row_tail",
     "Overlay companion locks after native single-row cache refresh"),
    (0x400388a8, 8, "sl_live_erase_hook",
     "Clear companion rows at actual live playhead for full trig or all-lock erase"),
    (0x40038b06, 8, "sl_live_erase_tail",
     "Retain companion has-lock bit after native selected-column live erase"),
    (0x400398b4, 8, "sl_clear_page_hook",
     "Clear companion rows with native audio page clear"),
    (0x40039df4, 8, "sl_clear_track_hook",
     "Clear companion rows when native clears normal audio track sequence"),
    (0x4003a614, 10, "sl_live_edit_hook",
     "SY DRUM step lock live edit hook"),
    (0x4003d916, 8, "sl_shift_hook",
     "Rotate companion rows over exact native active sequence length"),
    (0x40040e14, 8, "sl_clear_selected_hook",
     "Clear companion rows with native selected-trig/all-locks clear"),
    (0x4005040c, 8, "sl_ui_key_hook",
     "Dedicated setup encoder press/release on held audio trigs"),
    (0x40050fd6, 6, "sl_ui_trig_press_hook",
     "a trig press changed the held mask -- redraw an open SY DRUM PLAYBACK SETUP window, then the stock call"),
    (0x4005fbd2, 6, "sl_ui_trig_rel_hook",
     "a trig release changed the held mask -- redraw an open SY DRUM PLAYBACK SETUP window, then the stock call"),
    (0x400508e4, 8, "sl_ui_held_knob_hook",
     "Handle SY DRUM dedicated setup held-trig knob map before native modal-window rejection"),
    (0x400603f2, 6, "sl_grid_delete_hook",
     "Clear companion row after ordinary GRID tap-delete clears the native audio lock row inline."),
    (0x4008485e, 6, "sl_io_dispatch",
     "engine dispatch preflush/context"),
    (0x4008ec4c, 8, "sl_io_delete",
     "remove only known lock companions on explicit project delete"),
    (0x4008eda4, 8, "sl_io_bank_store",
     "selected mask STORED save"),
    (0x4008ee74, 8, "sl_io_project_store",
     "project WORK/STORED save"),
    (0x4008f0b0, 8, "sl_io_bank_restore",
     "selected mask saved restore"),
    (0x4008f180, 8, "sl_io_project_restore",
     "project saved lock restore"),
    (0x400905d4, 8, "sl_io_banks_load",
     "validated project cache load"),
    (0x400909d8, 10, "sl_io_clear",
     "clear project cache, clip and sequencer state"),
    (0x400912c4, 8, "sl_io_export",
     "carry validated companion pair to export"),
    (0x400917c8, 8, "sl_io_banks_save",
     "WORK flush and SAVE TO NEW/empty destination"),
    (0x400919e4, 8, "sl_io_card_sync",
     "all dirty lock banks before card SYNC"),
    (0x4009a664, 8, "sl_page_nonempty_tail",
     "Protect companion-only destination page from scale auto-overwrite"),
    (0x4009b220, 8, "sl_seq_queue_clear",
     "Stock future queue reset only; active/pending/scratch preserved."),
    (0x4009b86e, 6, "sl_seq_promote_a",
     "First native scratch-to-queue-zero promotion; d3 track."),
    (0x4009c04e, 6, "sl_seq_promote_b",
     "Second native scratch-to-queue-zero promotion; d4 track."),
    (0x4009c8bc, 8, "sl_duplicate_hook",
     "Duplicate companion page for explicit or scale-driven audio page duplication"),
    (0x4009d1e8, 8, "sl_seq_produce",
     "Stock audio queue producer prologue; source bank/pattern/step are cdecl arguments."),
    (0x4009d39e, 8, "sl_seq_eligible",
     "After native condition acceptance; ephemeral dedicated-only lock trigger acceptance."),
)

# The lock table: 16 banks x 8,192 rows x 16 bytes, uninitialised DRAM at the top of the
# platform's arena reserve (locks_store.inc.s; sl_reset fills it before any reader).
LOCK_TABLE_BYTES = 16 * 8192 * 16

# (2.18) The setup scene table: 16 banks x (working + Part-saved) x 4 Parts x 16 scenes x 8 tracks
# x 4 controls, uninitialised DRAM beside the lock table (scenes_store.inc.s; sc_reset and the
# project load fill it before sc_ready_mask lets a reader in).
SCENE_TABLE_BYTES = 16 * 2 * 4 * 16 * 8 * 4

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
               "renders sample-identical to the development builds' on-board engine, save / reload; not yet on hardware",
    doc="SY DRUM in the machine list (after FM SYNTH): an analog-style drum machine, one voice a track, on FLEX "
        "tracks -- PTCH MODE (A..F) WDTH SWEP SPED DEC with stock p-locks, LFOs and scenes, and a "
        "dedicated LFO / S&H (LSPD LDEP WAVE S&H) on its PLAYBACK SETUP page, lockable per step "
        "(sylockNN files beside the banks). Needs SYNTH MACHINE.",
    linked=(
        Linked("sydrum", os.path.join(_HERE, "sydrum.s"), cpu="5475", dram=True, include=remix_include),
    ),
    detours=(
        Detour(PAGE_HOOK, stock_guard(PAGE_HOOK, PAGE_LEN), "sydrum", "sd_page",
               "the page resolver's epilogue: the PLAYBACK page of a FLEX track with SY DRUM chosen (\"SY\", 1) "
               "is SY DRUM's (PTCH MODE WDTH SWEP SPED DEC; its SETUP half LSPD LDEP WAVE S&H); every other "
               "lookup untouched",
               kind="jmp", pad_to=8),
        Detour(SETUP_EDIT_HOOK, stock_guard(SETUP_EDIT_HOOK, SETUP_EDIT_LEN), "sydrum", "sd_setup_edit",
               "PLAYBACK SETUP editor on SY DRUM's page: held trigs edit the step locks, a default edit "
               "releases the playing step's lock of that control; every other page stock",
               kind="jmp", pad_to=10),
    ),  # Shared lock sites are dispatched by SYNTH MACHINE; SY helpers remain local.
    dram_regions=(DramRegion("sl_work_table", LOCK_TABLE_BYTES),
                  DramRegion("sc_table", SCENE_TABLE_BYTES)),
    conflicts=(("KITS", "both hook the project load / save / reload / clear jobs and the pattern clipboard "
                        "(SY DRUM's step-lock files and clipboard)"),
               ("PLOCKS P2", "both hook the sequencer's lock queue and clear paths and the held-trig encoder "
                             "(SY DRUM's step locks)"),
               ("STEM REC", "both take DRAM regions at the top of the platform reserve: SY DRUM's 2 MiB lock table "
                            "and STEM REC's ring, stack and stream buffers do not fit it together (the build "
                            "refuses: the runtime would end above the lowest region)"),),
)
