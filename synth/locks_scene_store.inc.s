| Per-bank scenes: four working Parts then four saved Parts; each Part is
| scene/track/control order. A row is VOIC,CHRD. No filesystem work here.
| (2.23) The pairs live in scene lanes (locks_store.inc.s): a scene word L = (Part*16+scene)*8+track
| (Part 0..7, 4..7 saved; the 2.22 table's and the file's order) is in lane
| 2048+(bank*4+Part%4)*4+track/2 at byte ((((Part/4)*16+scene)*2)+track%2)*2.
        .global fl_scene_row,fl_scene_row_take,fl_scene_write,fl_scene_empty,fl_scene_map
        .global fl_scenes_read,fl_scenes_write

| d0 bank, d1 scene word L -> d0 its lane id, d1 its byte offset in the lane. Other registers kept.
fl_scene_map:
        move.l  %d2,-(%sp)
        lsl.l   #4,%d0
        addi.l  #FL_STEP_LANES,%d0
        move.l  %d1,%d2
        lsr.l   #7,%d2
        andi.l  #3,%d2
        lsl.l   #2,%d2
        add.l   %d2,%d0
        move.l  %d1,%d2
        andi.l  #7,%d2
        lsr.l   #1,%d2
        add.l   %d2,%d0
        move.l  %d1,%d2
        lsr.l   #3,%d2
        andi.l  #15,%d2                  | the scene
        btst    #9,%d1
        beq     fl_sm_working
        addi.l  #16,%d2                  | a saved Part: the lane's second half
fl_sm_working:
        add.l   %d2,%d2
        btst    #0,%d1
        beq     fl_sm_even
        addq.l  #1,%d2
fl_sm_even:
        add.l   %d2,%d2
        move.l  %d2,%d1
        move.l  (%sp)+,%d2
        rts

| d0 bank,d1 Part 0..7 (4..7 saved),d2 scene,d3 track -> a0 pair or empty sentinel.
| All data registers preserved. Callers writing directly must validate first.
fl_scene_row:
        cmpi.l  #16,%d0
        bcc     fl_scene_row_empty
        cmpi.l  #8,%d1
        bcc     fl_scene_row_empty
        cmpi.l  #16,%d2
        bcc     fl_scene_row_empty
        cmpi.l  #8,%d3
        bcc     fl_scene_row_empty
        lea     -8(%sp),%sp
        movem.l %d0-%d1,(%sp)
        lsl.l   #4,%d1
        add.l   %d2,%d1
        lsl.l   #3,%d1
        add.l   %d3,%d1
        bsr     fl_scene_map
        jsr     fl_lane_page:l
        cmpa.l  #0,%a0
        beq     fl_scene_row_none
        adda.l  %d1,%a0
        movem.l (%sp),%d0-%d1
        addq.l  #8,%sp
        rts
fl_scene_row_none:
        movem.l (%sp),%d0-%d1
        addq.l  #8,%sp
fl_scene_row_empty:
        lea     fl_scene_empty:l,%a0
        rts

| fl_scene_row's coordinates -> a0 the pair, its lane taken now when it had none, or 0 (a
| coordinate off, or no free page). Data registers preserved.
fl_scene_row_take:
        suba.l  %a0,%a0
        cmpi.l  #16,%d0
        bcc     fl_srt_out
        cmpi.l  #8,%d1
        bcc     fl_srt_out
        cmpi.l  #16,%d2
        bcc     fl_srt_out
        cmpi.l  #8,%d3
        bcc     fl_srt_out
        lea     -8(%sp),%sp
        movem.l %d0-%d1,(%sp)
        lsl.l   #4,%d1
        add.l   %d2,%d1
        lsl.l   #3,%d1
        add.l   %d3,%d1
        bsr     fl_scene_map
        jsr     fl_lane_take:l
        cmpa.l  #0,%a0
        beq     fl_srt_none
        adda.l  %d1,%a0
fl_srt_none:
        movem.l (%sp),%d0-%d1
        addq.l  #8,%sp
fl_srt_out:
        rts

| d0 bank, d1 first scene word L, d2 stride (words), d3 count, a1 destination -> the pairs
| copied (a lane not taken reads 255), a1 past them. Other registers kept.
fl_scenes_read:
        lea     -24(%sp),%sp
        movem.l %d0-%d1/%d3-%d5/%a0,(%sp)
        move.l  %d0,%d5
        move.l  %d1,%d4
fl_sr2_word:
        tst.l   %d3
        beq     fl_sr2_done
        move.l  %d5,%d0
        move.l  %d4,%d1
        bsr     fl_scene_map
        jsr     fl_lane_page:l
        cmpa.l  #0,%a0
        beq     fl_sr2_empty
        adda.l  %d1,%a0
        move.w  (%a0),(%a1)+
        bra     fl_sr2_next
fl_sr2_empty:
        move.w  #-1,(%a1)+
fl_sr2_next:
        add.l   %d2,%d4
        subq.l  #1,%d3
        bra     fl_sr2_word
fl_sr2_done:
        movem.l (%sp),%d0-%d1/%d3-%d5/%a0
        lea     24(%sp),%sp
        rts

| d0 bank, d1 first scene word, d2 stride, d3 count, a1 source (a1 past it) or 0 (every pair
| 255) -> written; d4 = 1 when a pair changed, else 0; a0 used. A pair with a lock whose lane
| cannot be taken stays as it was (fl_lane_full counted). Other registers kept. The caller owns
| the pairs (interrupts masked, or the bank not ready).
fl_scenes_write:
        lea     -24(%sp),%sp
        movem.l %d0-%d3/%d5-%d6,(%sp)
        moveq   #0,%d4
        move.l  %d0,%d5
fl_sw2_word:
        tst.l   %d3
        beq     fl_sw2_done
        move.l  #0xffff,%d6
        cmpa.l  #0,%a1
        beq     fl_sw2_have
        mvz.w   (%a1)+,%d6
fl_sw2_have:
        move.l  %d1,-(%sp)
        move.l  %d5,%d0
        bsr     fl_scene_map
        jsr     fl_lane_page:l
        cmpa.l  #0,%a0
        bne     fl_sw2_lane
        cmpi.l  #0xffff,%d6
        beq     fl_sw2_skip
        jsr     fl_lane_take:l
        cmpa.l  #0,%a0
        beq     fl_sw2_skip
fl_sw2_lane:
        adda.l  %d1,%a0
        mvz.w   (%a0),%d0
        cmp.l   %d0,%d6
        beq     fl_sw2_skip
        move.w  %d6,(%a0)
        moveq   #1,%d4
fl_sw2_skip:
        move.l  (%sp)+,%d1
        add.l   %d2,%d1
        subq.l  #1,%d3
        bra     fl_sw2_word
fl_sw2_done:
        movem.l (%sp),%d0-%d3/%d5-%d6
        lea     24(%sp),%sp
        rts

| Same coordinates, d4 control,d5 value/255 -> d0 changed/unchanged/invalid.
| Bounds, readiness, value, edit and generation form one interrupt-masked operation.
fl_scene_write:
        lea     -16(%sp),%sp
        movem.l %d6/%a0-%a1,(%sp)
        move.w  %sr,%d6
        move.l  %d6,12(%sp)
        move.w  #0x2700,%sr
        cmpi.l  #16,%d0
        bcc     fl_sw_bad
        cmpi.l  #2,%d4
        bcc     fl_sw_bad
        move.l  fl_ready_mask:l,%d6
        btst    %d0,%d6
        beq     fl_sw_bad
        move.l  fl_blocked_mask:l,%d6
        btst    %d0,%d6
        bne     fl_sw_bad
        cmpi.l  #255,%d5
        beq     fl_sw_value
        tst.l   %d4
        bne     fl_sw_chord
        tst.l   %d5
        beq     fl_sw_bad
        cmpi.l  #4,%d5
        bhi     fl_sw_bad
        bra     fl_sw_value
fl_sw_chord:
        cmpi.l  #127,%d5
        bhi     fl_sw_bad
fl_sw_value:
        cmpi.l  #8,%d1
        bcc     fl_sw_bad
        cmpi.l  #16,%d2
        bcc     fl_sw_bad
        cmpi.l  #8,%d3
        bcc     fl_sw_bad
        bsr     fl_scene_row
        lea     fl_scene_empty:l,%a1
        cmpa.l  %a1,%a0
        bne     fl_sw_have
        cmpi.l  #255,%d5
        beq     fl_sw_same               | no lane, nothing to remove
        bsr     fl_scene_row_take
        cmpa.l  #0,%a0
        beq     fl_sw_bad                | no free page: refused (fl_lane_full)
fl_sw_have:
        mvz.b   (%a0,%d4.l),%d6
        cmp.l   %d6,%d5
        beq     fl_sw_same
        move.b  %d5,(%a0,%d4.l)
        jsr     fl_mark_dirty:l
        moveq   #1,%d0
        bra     fl_sw_out
fl_sw_same:
        moveq   #0,%d0
        bra     fl_sw_out
fl_sw_bad:
        moveq   #-1,%d0
fl_sw_out:
        move.l  12(%sp),%d6
        move.w  %d6,%sr
        movem.l (%sp),%d6/%a0-%a1
        lea     16(%sp),%sp
        rts

        .section .data
        .balign 4
fl_scene_empty:
        .long 0xffffffff
        .section .text
