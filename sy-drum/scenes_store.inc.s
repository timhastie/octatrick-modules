| ==== SETUP SCENES: the store and the morph (2.18; the development line's b59 setup scenes) =====
| SY DRUM's four PLAYBACK SETUP controls (LSPD LDEP WAVE S&H) are scene assignable. The stock
| scene block has 30 usable bytes a track, all taken by the five parameter pages, so the
| assignments live in a parallel table, as the dedicated step locks do:
|
|   sc_table  16 banks x 4096 bytes (a DramRegion, uninitialised: sc_reset and the project
|             load fill it before sc_ready_mask lets any reader in). A bank = WORKING then
|             PART-SAVED, 2048 bytes each: [part 0..3][scene 0..15][track 0..7][control A..D];
|             a byte is raw 0..127 or 255 = not assigned. On the card: syscenNN.work / .strd
|             (tools/scenes_io.h, the development line's format).
|
| THE MORPH (ss_scene_stage, the setup stage's scene step, setup_stage.inc.s): the crossfader
| sweeps every value between the two sides, as it does a stock parameter. With the track's
| weight long at 0x80003c60 + 4 t (high word = -WA, Q15, written by stock from the crossfader
| position): out = (A * WA + B * (0x8000 - WA) + 0x4000) >> 15, rounded to the control's step
| (one raw value). A side with no assignment, or a side whose scene is disabled (0x80000006 A /
| 0x80000007 B), takes the Part value; neither side assigned leaves the Part value. The result
| replaces the Part value before the step lock is laid over it: a step lock wins over a scene,
| as on FM SYNTH's VOIC / CHRD (step lock, else scene, else Part). WAVE and S&H sweep too:
| WAVE walks OFF TRI SQR RND, S&H switches at the midpoint. Applied every frame (the engine's
| LFO reads its controls every frame; S&H captures at each hit as before).
        .set    SC_BANK_BYTES, 4096
        .set    SC_HALF_BYTES, 2048
        .global sc_row, sc_write, sc_reset, sc_refresh, sc_mark_dirty, sc_empty
        .global sc_ready_mask, sc_blocked_mask, sc_dirty_mask, sc_generation, sc_cache
        .global ss_scene_stage

| d0 bank, d1 part, d2 scene, d3 track -> a0 = the WORKING row (4 bytes). Data registers
| kept; a coordinate out of range returns the read-only FF row.
sc_row:
        lea     sc_empty:l,%a0
        cmpi.l  #16,%d0
        bcc     sc_row_out
        cmpi.l  #4,%d1
        bcc     sc_row_out
        cmpi.l  #16,%d2
        bcc     sc_row_out
        cmpi.l  #8,%d3
        bcc     sc_row_out
        move.l  %d0,-(%sp)
        lsl.l   #3,%d0                   | bank * 8: two halves of four parts (the working half first)
        add.l   %d1,%d0
        lsl.l   #4,%d0
        add.l   %d2,%d0
        lsl.l   #3,%d0
        add.l   %d3,%d0
        lsl.l   #2,%d0
        lea     sc_table:l,%a0
        adda.l  %d0,%a0
        move.l  (%sp)+,%d0
sc_row_out:
        rts

| d0 bank -> dirty, edit generation + 1. All registers kept.
sc_mark_dirty:
        cmpi.l  #16,%d0
        bcc     sc_md_out
        lea     -12(%sp),%sp
        movem.l %d1/%a0-%a1,(%sp)
        moveq   #1,%d1
        lsl.l   %d0,%d1
        lea     sc_dirty_mask:l,%a0
        or.l    %d1,(%a0)
        lea     sc_generation:l,%a1
        addq.l  #1,(%a1,%d0.l*4)
        movem.l (%sp),%d1/%a0-%a1
        lea     12(%sp),%sp
sc_md_out:
        rts

| d0 bank, d1 part, d2 scene, d3 track, d4 control, d5 raw 0..max / 255 (remove).
| d0 returns 1 changed, 0 unchanged, -1 invalid / bank not ready. Other registers kept.
sc_write:
        lea     -16(%sp),%sp
        movem.l %d6/%a0-%a1,(%sp)
        move.w  %sr,%d6
        move.l  %d6,12(%sp)
        move.w  #0x2700,%sr              | check, edit and generation are atomic
        cmpi.l  #16,%d0
        bcc     sc_wr_bad
        cmpi.l  #4,%d4
        bcc     sc_wr_bad
        move.l  sc_ready_mask:l,%d6
        btst    %d0,%d6
        beq     sc_wr_bad
        move.l  sc_blocked_mask:l,%d6
        btst    %d0,%d6
        bne     sc_wr_bad
        cmpi.l  #255,%d5
        beq     sc_wr_value
        cmpi.l  #127,%d5
        bhi     sc_wr_bad
sc_wr_value:
        bsr     sc_row
        lea     sc_empty:l,%a1
        cmpa.l  %a1,%a0
        beq     sc_wr_bad
        mvz.b   (%a0,%d4.l),%d6
        cmp.l   %d6,%d5
        beq     sc_wr_same
        move.b  %d5,(%a0,%d4.l)
        bsr     sc_mark_dirty
        moveq   #1,%d0
        bra     sc_wr_out
sc_wr_same:
        moveq   #0,%d0
        bra     sc_wr_out
sc_wr_bad:
        moveq   #-1,%d0
sc_wr_out:
        move.l  12(%sp),%d6
        move.w  %d6,%sr
        movem.l (%sp),%d6/%a0-%a1
        lea     16(%sp),%sp
        rts

| Project lifecycle (sl_reset calls it): every assignment gone, nothing ready. All registers kept.
sc_reset:
        lea     -12(%sp),%sp
        movem.l %d0-%d1/%a0,(%sp)
        clr.l   sc_ready_mask:l          | close the readers before the table is rewritten
        lea     sc_table:l,%a0
        move.l  #16*SC_BANK_BYTES/4,%d0
        moveq   #-1,%d1
sc_rs_table:
        move.l  %d1,(%a0)+
        subq.l  #1,%d0
        bne     sc_rs_table
        lea     sc_generation:l,%a0
        moveq   #16,%d0
sc_rs_gen:
        clr.l   (%a0)+
        subq.l  #1,%d0
        bne     sc_rs_gen
        clr.l   sc_blocked_mask:l
        clr.l   sc_dirty_mask:l
        clr.l   sc_clip_valid:l
        movem.l (%sp),%d0-%d1/%a0
        lea     12(%sp),%sp
        rts

| Once a frame, before the stages (sd_tick calls it): where the selected scene A and scene B
| rows of the current bank / Part are. sc_cache = two pointers to 8 tracks x 4 bytes; a
| disabled side, an unready bank or a Part pointer in flux points at the FF rows (no morph).
| Bank and Part are the UI's (0x100b14ce / PART_IDX), as the Part pointer the selection is
| read from is. Clobbers d0, d1, a0, a1.
sc_refresh:
        move.l  %a2,-(%sp)
        move.l  %d2,-(%sp)
        lea     sc_cache:l,%a1
        lea     sc_empty:l,%a0
        move.l  %a0,(%a1)
        move.l  %a0,4(%a1)
        mvz.b   0x100b14ce,%d0
        cmpi.l  #15,%d0
        bhi     sc_rf_out
        move.l  sc_ready_mask:l,%d1
        btst    %d0,%d1
        beq     sc_rf_out
        move.l  sc_blocked_mask:l,%d1
        btst    %d0,%d1
        bne     sc_rf_out
        mvz.b   PART_IDX,%d1
        cmpi.l  #3,%d1
        bhi     sc_rf_out
        lsl.l   #3,%d0
        add.l   %d1,%d0
        lsl.l   #8,%d0
        add.l   %d0,%d0                  | (bank * 8 + part) * 512
        lea     sc_table:l,%a0
        adda.l  %d0,%a0                  | the Part's 16 working scenes
        move.l  PART_PTR,%d0
        cmpi.l  #0x40000000,%d0
        bcs     sc_rf_out
        cmpi.l  #0x48000000,%d0
        bcc     sc_rf_out
        move.l  #6322,%d2
        mulu.l  %d2,%d1
        add.l   %d1,%d0
        addi.l  #0x8ed90,%d0
        movea.l %d0,%a2                  | the Part's selected scene A, scene B
        tst.b   0x80000006               | scene A's side off: stock ignores it
        bne     sc_rf_b
        mvz.b   (%a2),%d0
        cmpi.l  #15,%d0
        bhi     sc_rf_b
        lsl.l   #5,%d0
        lea     (%a0,%d0.l),%a1
        move.l  %a1,sc_cache:l
sc_rf_b:
        tst.b   0x80000007
        bne     sc_rf_out
        mvz.b   1(%a2),%d0
        cmpi.l  #15,%d0
        bhi     sc_rf_out
        lsl.l   #5,%d0
        lea     (%a0,%d0.l),%a1
        move.l  %a1,sc_cache+4:l
sc_rf_out:
        move.l  (%sp)+,%d2
        movea.l (%sp)+,%a2
        rts

| THE SCENE STAGE. d2 = track, a1 = the track's working row (the Part default, before the
| step lock), rewritten in place. Clobbers d0, d1, d3, a0, a2. A track with no assignment
| in either selected scene leaves after nine instructions with its row untouched.
ss_scene_stage:
        lea     sc_cache:l,%a2
        movea.l (%a2)+,%a0
        move.l  (%a0,%d2.l*4),%d0        | scene A's four bytes for this track
        movea.l (%a2),%a0
        move.l  (%a0,%d2.l*4),%d1        | scene B's
        move.l  %d0,%d3
        and.l   %d1,%d3
        addq.l  #1,%d3
        bne     sc_morph
        rts
sc_morph:
        lea     -12(%sp),%sp
        movem.l %d5-%d7,(%sp)
        lea     0x80003c60,%a0           | stock's weight long of the track: high word = -WA (Q15)
        mvs.w   (%a0,%d2.l*4),%d3
        neg.l   %d3
        bpl     sc_mo_pos
        moveq   #0,%d3
sc_mo_pos:
        cmpi.l  #0x8000,%d3
        bls     sc_mo_w
        move.l  #0x8000,%d3
sc_mo_w:
        moveq   #3,%d5                   | control D first: the rows' low bytes
sc_mo_ctl:
        mvz.b   %d0,%d6                  | A
        mvz.b   %d1,%d7                  | B
        lsr.l   #8,%d0
        lsr.l   #8,%d1
        cmpi.l  #255,%d6
        bne     sc_mo_a
        cmpi.l  #255,%d7
        beq     sc_mo_next               | neither side: the Part value stands
        mvz.b   (%a1,%d5.l),%d6          | A not assigned: the Part value fades to B
        bra     sc_mo_mix
sc_mo_a:
        cmpi.l  #255,%d7
        bne     sc_mo_mix
        mvz.b   (%a1,%d5.l),%d7          | B not assigned
sc_mo_mix:
        sub.l   %d7,%d6
        muls.l  %d3,%d6                  | (A - B) * WA
        lsl.l   #8,%d7
        lsl.l   #7,%d7
        add.l   %d7,%d6                  | + B * 0x8000  =  A * WA + B * (0x8000 - WA)
        addi.l  #0x4000,%d6              | to the nearest step
        asr.l   #8,%d6
        asr.l   #7,%d6
        move.b  %d6,(%a1,%d5.l)
sc_mo_next:
        subq.l  #1,%d5
        bpl     sc_mo_ctl
        movem.l (%sp),%d5-%d7
        lea     12(%sp),%sp
        rts

        .section .data
        .balign 4
sc_empty:       .fill 8,4,0xffffffff     | the FF rows: 8 tracks, nothing assigned
sc_cache:       .long sc_empty, sc_empty | the selected scene A / scene B rows of this frame
sc_ready_mask:  .long 0                  | per bank: loaded (or fresh), edits and the morph allowed
sc_blocked_mask: .long 0                 | per bank: a file of a later version is on the card -- never overwritten
sc_dirty_mask:  .long 0
sc_generation:  .fill 16,4,0
sc_clip_valid:  .long 0                  | bit 0 scene clip, 1 scene undo, 2 part clip, 3 part undo, 4 / 5 track clip / undo
sc_scene_clip:  .fill 8,4,0xffffffff     | one scene: 8 tracks x 4
sc_scene_undo:  .fill 8,4,0xffffffff
sc_part_clip:   .fill 128,4,0xffffffff   | one Part's working scenes: 16 x 8 x 4
sc_part_undo:   .fill 128,4,0xffffffff
sc_track_clip:  .fill 16,4,0xffffffff    | one track's 16 scenes x 4 (a full track copy)
sc_track_undo:  .fill 16,4,0xffffffff
sc_ui_entry:    .byte 0                  | diagnostic: which entry took the last scene-held turn (scenes_ui.inc.s)
        .balign 4
        .section .text
