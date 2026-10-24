| ==== SETUP SCENES: the stock scene and Part operations carry them (2.18; the development line's
| b59 scene operations) ==========================================================================
| The ten stock entries are SYNTH MACHINE's detours (synth/scenes_ops.inc.s: its own VOIC / CHRD
| table first); with SY DRUM in the remix each of them ends here instead of in stock. Each does
| its row work on SY DRUM's table with the UI's bank (0x100b14ce), restores every register,
| replays the displaced instructions and continues in stock:
|   scene COPY 0x400274cc (part, scene)        -> sc_scene_clip
|   scene undo snapshot 0x400275a0 (op, part, scene) -> sc_scene_undo
|   scene WRITE 0x40025b40 (src, part, scene)  paste (src = the clipboard 0x460c8122)
|                                              or undo (src = 0x460bf218)
|   scene CLEAR 0x40038c30 (scene)             the UI's Part
|   Part SAVE 0x4004a908 (part)                working -> part-saved
|   Part RELOAD 0x4004aab4 (part)              part-saved -> working (only when stock's
|                                              saved flag bank + 0x9b312 + part is set)
|   Part CLEAR 0x4004a9d0 (part)               working -> FF (stock then falls into SAVE)
|   Part COPY 0x4002932c (part)                -> sc_part_clip
|   Part undo snapshot 0x400292a0 (op, part)   -> sc_part_undo
|   Part WRITE 0x40029a4c (src, part)          paste / undo, by src as for a scene
| sc_track_xfer: a full track copy / paste (SY DRUM's sl_clip_full_* hooks) carries that track's
| 16 scene rows of the Part, as FM SYNTH's fs_track_xfer does its own.
        .global sc_scene_copy_hook, sc_scene_undo_hook, sc_scene_write_hook, sc_scene_clear_hook
        .global sc_part_save_hook, sc_part_reload_hook, sc_part_clear_hook
        .global sc_part_copy_hook, sc_part_undo_hook, sc_part_write_hook, sc_track_xfer
        .set    SC_CLIP_SRC, 0x460c8122
        .set    SC_UNDO_SRC, 0x460bf218

| d1 part, d2 scene -> a0 = the 32 bytes of that scene in the UI's bank (track 0's
| row), or 0 when a coordinate is off or the bank is not ready. d0 = the bank.
sc_op_scene:
        move.l  %d3,-(%sp)
        mvz.b   0x100b14ce,%d0
        moveq   #0,%d3
        jsr     sc_row:l
        move.l  (%sp)+,%d3
sc_op_check:
        move.l  %d1,-(%sp)
        cmpa.l  #sc_empty,%a0
        beq     sc_op_none
        move.l  sc_ready_mask:l,%d1
        btst    %d0,%d1
        beq     sc_op_none
        move.l  sc_blocked_mask:l,%d1
        btst    %d0,%d1
        beq     sc_op_ok
sc_op_none:
        suba.l  %a0,%a0
sc_op_ok:
        move.l  (%sp)+,%d1
        cmpa.l  #0,%a0
        rts
| d1 part -> a0 = the 512 working bytes of that Part (scene 0, track 0), or 0.
sc_op_part:
        move.l  %d2,-(%sp)
        moveq   #0,%d2
        bsr     sc_op_scene
        move.l  (%sp)+,%d2
        cmpa.l  #0,%a0
        rts
| a0 -> a1, d3 longs. Clobbers d3, a0, a1.
sc_op_copy:
        move.l  (%a0)+,(%a1)+
        subq.l  #1,%d3
        bne     sc_op_copy
        rts
| a1, d3 longs := FF. Clobbers d3, a1, d4.
sc_op_fill:
        moveq   #-1,%d4
sc_op_fill1:
        move.l  %d4,(%a1)+
        subq.l  #1,%d3
        bne     sc_op_fill1
        rts
| d4 = a valid bit to set.
sc_op_valid:
        lea     sc_clip_valid:l,%a1
        or.l    %d4,(%a1)
        rts
        .macro  sc_op_enter
        lea     -64(%sp),%sp
        movem.l %d0-%d7/%a0-%a6,(%sp)
        move.w  %sr,%d0
        move.l  %d0,60(%sp)
        move.w  #0x2700,%sr              | the table copy and its generation are atomic
        .endm
        .macro  sc_op_leave
        move.l  60(%sp),%d0
        move.w  %d0,%sr
        movem.l (%sp),%d0-%d7/%a0-%a6
        lea     64(%sp),%sp
        .endm

sc_scene_copy_hook:                      | (part, scene)
        sc_op_enter
        move.l  68(%sp),%d1
        move.l  72(%sp),%d2
        bsr     sc_op_scene
        beq     sc_sch_out
        lea     sc_scene_clip:l,%a1
        moveq   #8,%d3
        bsr     sc_op_copy
        moveq   #1,%d4
        bsr     sc_op_valid
sc_sch_out:
        sc_op_leave
        lea     -24(%sp),%sp
        movem.l %d2-%d7,(%sp)
        jmp     0x400274d4

sc_scene_undo_hook:                      | (op, part, scene)
        sc_op_enter
        move.l  72(%sp),%d1
        move.l  76(%sp),%d2
        bsr     sc_op_scene
        beq     sc_suh_out
        lea     sc_scene_undo:l,%a1
        moveq   #8,%d3
        bsr     sc_op_copy
        moveq   #2,%d4
        bsr     sc_op_valid
sc_suh_out:
        sc_op_leave
        lea     -24(%sp),%sp
        movem.l %d2-%d7,(%sp)
        jmp     0x400275a8

sc_scene_write_hook:                     | (src, part, scene)
        sc_op_enter
        move.l  68(%sp),%d5
        lea     sc_scene_clip:l,%a2
        moveq   #1,%d4
        cmpi.l  #SC_CLIP_SRC,%d5
        beq     sc_swh_src
        lea     sc_scene_undo:l,%a2
        moveq   #2,%d4
        cmpi.l  #SC_UNDO_SRC,%d5
        bne     sc_swh_out               | another source: not ours
sc_swh_src:
        and.l   sc_clip_valid:l,%d4
        beq     sc_swh_out               | nothing of ours was captured with it
        move.l  72(%sp),%d1
        move.l  76(%sp),%d2
        bsr     sc_op_scene
        beq     sc_swh_out
        movea.l %a0,%a1
        movea.l %a2,%a0
        moveq   #8,%d3
        bsr     sc_op_copy
        jsr     sc_mark_dirty:l
sc_swh_out:
        sc_op_leave
        lea     -48(%sp),%sp
        movem.l %d2-%d7/%a2-%a6,(%sp)
        jmp     0x40025b48

sc_scene_clear_hook:                     | (scene), the UI's Part
        sc_op_enter
        mvz.b   PART_IDX,%d1
        move.l  68(%sp),%d2
        bsr     sc_op_scene
        beq     sc_sxh_out
        movea.l %a0,%a1
        moveq   #8,%d3
        bsr     sc_op_fill
        jsr     sc_mark_dirty:l
sc_sxh_out:
        sc_op_leave
        lea     -40(%sp),%sp
        movem.l %d2-%d7/%a2-%a5,(%sp)
        jmp     0x40038c38

sc_part_save_hook:                       | (part): working -> part-saved
        sc_op_enter
        move.l  68(%sp),%d1
        bsr     sc_op_part
        beq     sc_psh_out
        lea     SC_HALF_BYTES(%a0),%a1
        move.l  #128,%d3
        bsr     sc_op_copy
        jsr     sc_mark_dirty:l
sc_psh_out:
        sc_op_leave
        lea     -20(%sp),%sp
        movem.l %d2-%d4/%a2-%a3,(%sp)
        jmp     0x4004a910

sc_part_reload_hook:                     | (part): part-saved -> working, when stock has a saved Part
        sc_op_enter
        move.l  68(%sp),%d1
        bsr     sc_op_part
        beq     sc_prh_out
        movea.l PART_PTR,%a2
        adda.l  #0x9b312,%a2
        tst.b   (%a2,%d1.l)
        beq     sc_prh_out               | stock returns before touching the Part
        movea.l %a0,%a1
        lea     SC_HALF_BYTES(%a0),%a0
        move.l  #128,%d3
        bsr     sc_op_copy
        jsr     sc_mark_dirty:l
sc_prh_out:
        sc_op_leave
        lea     -32(%sp),%sp
        movem.l %d2-%d5/%a2-%a3,(%sp)
        jmp     0x4004aabc

sc_part_clear_hook:                      | (part): working -> none (stock falls into SAVE)
        sc_op_enter
        move.l  68(%sp),%d1
        bsr     sc_op_part
        beq     sc_pxh_out
        movea.l %a0,%a1
        move.l  #128,%d3
        bsr     sc_op_fill
        jsr     sc_mark_dirty:l
sc_pxh_out:
        sc_op_leave
        lea     -16(%sp),%sp
        movem.l %d2-%d3/%a2-%a3,(%sp)
        jmp     0x4004a9d8

sc_part_copy_hook:                       | (part)
        sc_op_enter
        move.l  68(%sp),%d1
        bsr     sc_op_part
        beq     sc_pch_out
        lea     sc_part_clip:l,%a1
        move.l  #128,%d3
        bsr     sc_op_copy
        moveq   #4,%d4
        bsr     sc_op_valid
sc_pch_out:
        sc_op_leave
        pea     0x18b2
        move.l  8(%sp),%d0
        jmp     0x40029334

sc_part_undo_hook:                       | (op, part)
        sc_op_enter
        move.l  72(%sp),%d1
        bsr     sc_op_part
        beq     sc_puh_out
        lea     sc_part_undo:l,%a1
        move.l  #128,%d3
        bsr     sc_op_copy
        moveq   #8,%d4
        bsr     sc_op_valid
sc_puh_out:
        sc_op_leave
        move.l  8(%sp),%d0
        lea     4(%sp),%a0
        jmp     0x400292a8

sc_part_write_hook:                      | (src, part)
        sc_op_enter
        move.l  68(%sp),%d5
        lea     sc_part_clip:l,%a2
        moveq   #4,%d4
        cmpi.l  #SC_CLIP_SRC,%d5
        beq     sc_pwh_src
        lea     sc_part_undo:l,%a2
        moveq   #8,%d4
        cmpi.l  #SC_UNDO_SRC,%d5
        bne     sc_pwh_out
sc_pwh_src:
        and.l   sc_clip_valid:l,%d4
        beq     sc_pwh_out
        move.l  72(%sp),%d1
        bsr     sc_op_part
        beq     sc_pwh_out
        movea.l %a0,%a1
        movea.l %a2,%a0
        move.l  #128,%d3
        bsr     sc_op_copy
        jsr     sc_mark_dirty:l
sc_pwh_out:
        sc_op_leave
        lea     -20(%sp),%sp
        movem.l %d2-%d5/%a2,(%sp)
        jmp     0x40029a54

| Whole-track COPY / PASTE carry the track's 16 scene rows of its Part (FM SYNTH's
| fs_track_xfer rule): d0 the native clipboard pointer, d1 pattern, d2 track, d5 0 capture /
| 1 restore; called by sl_clip_full_capture_hook / sl_clip_full_store_hook for the native
| full-track format (kind 4) after the machine guard accepted it. Every register preserved.
sc_track_xfer:
        sc_op_enter
        move.l  0(%sp),%d0
        lea     sc_track_clip:l,%a2
        lea     sl_clip_kind:l,%a3
        moveq   #16,%d6
        cmpi.l  #SC_CLIP_SRC,%d0
        beq     sc_tx_buffer
        cmpi.l  #SC_UNDO_SRC,%d0
        bne     sc_tx_out
        lea     sc_track_undo:l,%a2
        lea     sl_undo_kind:l,%a3
        moveq   #32,%d6
sc_tx_buffer:
        tst.l   %d5
        bne     sc_tx_restore_check
        move.l  %d6,%d0
        not.l   %d0
        and.l   %d0,sc_clip_valid:l      | a capture in progress: the old clip is no longer valid
        bra     sc_tx_context
sc_tx_restore_check:
        move.l  (%a3),%d0
        cmpi.l  #4,%d0                   | the same native clipboard generation / type (locks_clip.inc.s)
        bne     sc_tx_out
        move.l  sc_clip_valid:l,%d0
        and.l   %d6,%d0
        beq     sc_tx_out
sc_tx_context:
        cmpi.l  #16,%d1
        bcc     sc_tx_out
        cmpi.l  #8,%d2
        bcc     sc_tx_out
        move.l  %d2,%d3
        move.l  #36568,%d0
        mulu.l  %d1,%d0
        movea.l PART_PTR,%a0
        cmpa.l  #0x40000000,%a0
        bcs     sc_tx_out
        cmpa.l  #0x48000000,%a0
        bcc     sc_tx_out
        adda.l  %d0,%a0
        adda.l  #0x8e57,%a0              | the pattern's Part
        mvz.b   (%a0),%d1
        cmpi.l  #4,%d1
        bcc     sc_tx_out
        mvz.b   0x100b14ce,%d0
        cmpi.l  #16,%d0
        bcc     sc_tx_out
        moveq   #0,%d2
        jsr     sc_row:l
        bsr     sc_op_check
        beq     sc_tx_out
        moveq   #16,%d7
        tst.l   %d5
        bne     sc_tx_restore
sc_tx_capture:
        move.l  (%a0),(%a2)+
        adda.l  #32,%a0
        subq.l  #1,%d7
        bne     sc_tx_capture
        or.l    %d6,sc_clip_valid:l
        bra     sc_tx_out
sc_tx_restore:
        moveq   #0,%d4
sc_tx_restore_row:
        move.l  (%a2)+,%d6
        cmp.l   (%a0),%d6
        beq     sc_tx_restore_next
        move.l  %d6,(%a0)
        moveq   #1,%d4
sc_tx_restore_next:
        adda.l  #32,%a0
        subq.l  #1,%d7
        bne     sc_tx_restore_row
        tst.l   %d4
        beq     sc_tx_out
        jsr     sc_mark_dirty:l
sc_tx_out:
        sc_op_leave
        rts
