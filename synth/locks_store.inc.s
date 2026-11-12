| FM SYNTH standalone step + scene lock storage. 255 means absent.
| fmlock version 1: header 32, step pairs, working and saved Part scene pairs.
| Scene and step edits share the bank generation, ready/blocked masks and card snapshot.
| (2.23) LOCK LANES. A row is two bytes, VOIC and CHRD (2.22 kept each in a 16-byte row whose
| other 14 bytes were always 0xFF and never reached the card). Rows live in 128-byte lanes taken
| on demand from a pool: a step lane holds the 64 rows of one (bank, pattern, track), lane id
| (bank*16+pattern)*8+track (0..2047); a scene lane holds the 16 scenes' pairs of two tracks of
| one (bank, Part), working then saved, lane id 2048+(bank*4+Part)*4+track/2 (2048..2303).
| fl_lane_index holds per lane id 0 (no lane: its rows read 255) or 1 + its pool page; zeroed
| memory is therefore an empty index, and values past the pool are refused, never read (room
| for a later state). A lane is taken by the first lock written into it (fl_lane_take, with
| interrupts masked: the page is filled with 0xFF before its index entry is published) and goes
| back to the pool only through fl_reset, fl_bank_free (a load or restore of that bank, which
| is not ready meanwhile) and fl_lane_gc (the UI tick: a lane whose rows are all 255 again;
| fl_lane_gen counts every free, so the engine task's file snapshot retries across one).
| FL_POOL_LANES pages: 2,304 on a card build, every lane, so nothing is ever refused there. A
| smaller pool (a package) refuses a new lock that needs a lane past it (fl_lane_full counts
| the refusals for the toast) and locks_io.c blocks a bank whose file needs more lanes than are
| free. The card files are byte for byte 2.22's.
        .global fl_ready_mask,fl_blocked_mask,fl_dirty_mask,fl_generation

        .ifndef FL_POOL_LANES
        .set FL_POOL_LANES,2304
        .endif
        .ifndef FL_PACKAGE                       | 1: a module package for a loader base (locks_io.c)
        .set FL_PACKAGE,0
        .endif
        .ifndef FL_LANES_IN_BSS
        .set FL_LANES_IN_BSS,FL_PACKAGE
        .endif
        .set FL_CONTROLS,2
        .set FL_ROW,2
        .set FL_ROWS,8192
        .set FL_LANE,128
        .set FL_LANES,2304
        .set FL_STEP_LANES,2048
        .if FL_POOL_LANES < 1 || FL_POOL_LANES > FL_LANES
        .error "FL_POOL_LANES is 1..2304"
        .endif
        .set FL_SCENE_BANK_BYTES,2048
        .set FL_PAIR_BYTES,FL_ROWS*2+FL_SCENE_BANK_BYTES
        .set FL_MIGRATION_BANK_BYTES,160
        .set FL_PAYLOAD_BYTES,FL_PAIR_BYTES+FL_MIGRATION_BANK_BYTES
        .set FL_FILE_BYTES,FL_PAYLOAD_BYTES+32
        .global fl_row,fl_row_take,fl_mark_dirty,fl_write,fl_reset
        .global fl_lane_page,fl_lane_take,fl_lane_release,fl_bank_free,fl_lane_gc
        .global fl_lane_index,fl_lane_pool,fl_lane_stack,fl_lane_free,fl_lane_gen,fl_lane_full,fl_lane_gc_mask
        .global fl_steps_read,fl_steps_write,fl_empty_row
        .global fl_payload_validate,fl_crc32,fl_file_validate,fl_file_pack,fl_file_seal,fl_bank_publish

| d0 lane id (0..2303) -> a0 its page, or 0 when the lane is not taken. Other registers kept.
fl_lane_page:
        move.l  %d0,-(%sp)
        lea     fl_lane_index:l,%a0
        mvz.w   (%a0,%d0.l*2),%d0
        subq.l  #1,%d0
        cmpi.l  #FL_POOL_LANES,%d0
        bcc     fl_lp_none               | 0 (no lane) wraps to 0xffffffff
        lsl.l   #7,%d0
        lea     fl_lane_pool:l,%a0
        adda.l  %d0,%a0
        move.l  (%sp)+,%d0
        rts
fl_lp_none:
        suba.l  %a0,%a0
        move.l  (%sp)+,%d0
        rts

| d0 lane id -> a0 its page, taken now when it had none (0xFF-filled, then published), or 0 when
| no page is free (fl_lane_full counted) or the entry holds another state. Interrupts are masked
| inside; every other register kept.
fl_lane_take:
        bsr     fl_lane_page
        cmpa.l  #0,%a0
        bne     fl_lt_out
        lea     -24(%sp),%sp
        movem.l %d0-%d4/%a1,(%sp)
        move.w  %sr,%d4
        move.w  #0x2700,%sr
        bsr     fl_lane_page             | again, masked
        cmpa.l  #0,%a0
        bne     fl_lt_done
        lea     fl_lane_index:l,%a1
        tst.w   (%a1,%d0.l*2)
        bne     fl_lt_refuse
        move.l  fl_lane_free:l,%d1
        beq     fl_lt_full
        subq.l  #1,%d1
        move.l  %d1,fl_lane_free:l
        lea     fl_lane_stack:l,%a0
        mvz.w   (%a0,%d1.l*2),%d1        | the page
        move.l  %d1,%d2
        lsl.l   #7,%d2
        lea     fl_lane_pool:l,%a0
        adda.l  %d2,%a0
        moveq   #-1,%d2
        moveq   #FL_LANE/4,%d3
fl_lt_fill:
        move.l  %d2,(%a0)+
        subq.l  #1,%d3
        bne     fl_lt_fill
        lea     -FL_LANE(%a0),%a0
        addq.l  #1,%d1
        move.w  %d1,(%a1,%d0.l*2)        | published once filled
        bra     fl_lt_done
fl_lt_full:
        addq.l  #1,fl_lane_full:l
fl_lt_refuse:
        suba.l  %a0,%a0
fl_lt_done:
        move.w  %d4,%sr
        movem.l (%sp),%d0-%d4/%a1
        lea     24(%sp),%sp
fl_lt_out:
        rts

| d0 lane id: its page (if any) back to the pool, the entry 0, fl_lane_gen counted. Interrupts
| masked inside; every register kept.
fl_lane_release:
        lea     -16(%sp),%sp
        movem.l %d1-%d3/%a0,(%sp)
        move.w  %sr,%d3
        move.w  #0x2700,%sr
        lea     fl_lane_index:l,%a0
        mvz.w   (%a0,%d0.l*2),%d1
        subq.l  #1,%d1
        cmpi.l  #FL_POOL_LANES,%d1
        bcc     fl_lr_out
        clr.w   (%a0,%d0.l*2)
        move.l  fl_lane_free:l,%d2
        lea     fl_lane_stack:l,%a0
        move.w  %d1,(%a0,%d2.l*2)
        addq.l  #1,%d2
        move.l  %d2,fl_lane_free:l
        addq.l  #1,fl_lane_gen:l
fl_lr_out:
        move.w  %d3,%sr
        movem.l (%sp),%d1-%d3/%a0
        lea     16(%sp),%sp
        rts

| d0 bank: every lane of it (128 step lanes, 16 scene lanes) back to the pool. For a load or
| restore of the bank (not ready meanwhile) and a fresh bank. Every register kept.
fl_bank_free:
        cmpi.l  #16,%d0
        bcc     fl_bf_ret
        lea     -12(%sp),%sp
        movem.l %d0-%d2,(%sp)
        move.l  %d0,%d2
        lsl.l   #7,%d0
        move.l  #128,%d1
fl_bf_steps:
        bsr     fl_lane_release
        addq.l  #1,%d0
        subq.l  #1,%d1
        bne     fl_bf_steps
        move.l  %d2,%d0
        lsl.l   #4,%d0
        addi.l  #FL_STEP_LANES,%d0
        moveq   #16,%d1
fl_bf_scenes:
        bsr     fl_lane_release
        addq.l  #1,%d0
        subq.l  #1,%d1
        bne     fl_bf_scenes
        movem.l (%sp),%d0-%d2
        lea     12(%sp),%sp
fl_bf_ret:
        rts

| d0 bank: each lane of it whose rows are all 255 goes back to the pool, one lane at a time with
| interrupts masked and only while the bank is ready and not blocked (a load or restore frees
| and fills the bank's lanes itself). The UI tick runs it (locks_io.c). Every register kept.
fl_lane_gc:
        cmpi.l  #16,%d0
        bcc     fl_gc_ret
        lea     -28(%sp),%sp
        movem.l %d0-%d5/%a0,(%sp)
        move.l  %d0,%d3
        lsl.l   #7,%d0
        move.l  #144,%d4
fl_gc_lane:
        move.w  %sr,%d5
        move.w  #0x2700,%sr
        move.l  fl_ready_mask:l,%d1
        btst    %d3,%d1
        beq     fl_gc_next
        move.l  fl_blocked_mask:l,%d1
        btst    %d3,%d1
        bne     fl_gc_next
        bsr     fl_lane_page
        cmpa.l  #0,%a0
        beq     fl_gc_next
        moveq   #FL_LANE/4,%d2
        moveq   #-1,%d1
fl_gc_cmp:
        cmp.l   (%a0)+,%d1
        bne     fl_gc_next
        subq.l  #1,%d2
        bne     fl_gc_cmp
        bsr     fl_lane_release
fl_gc_next:
        move.w  %d5,%sr
        addq.l  #1,%d0
        subq.l  #1,%d4
        beq     fl_gc_done
        cmpi.l  #16,%d4
        bne     fl_gc_lane
        move.l  %d3,%d0
        lsl.l   #4,%d0
        addi.l  #FL_STEP_LANES,%d0
        bra     fl_gc_lane
fl_gc_done:
        movem.l (%sp),%d0-%d5/%a0
        lea     28(%sp),%sp
fl_gc_ret:
        rts

| d0 bank, d1 pattern, d2 track, d3 step -> a0 the step's row (VOIC, CHRD), or fl_empty_row
| (every byte 255, 16 of them) when a coordinate is off or the lane is not taken. Other
| registers kept.
fl_row:
        cmpi.l  #16,%d0
        bcc     fl_row_empty
        cmpi.l  #16,%d1
        bcc     fl_row_empty
        cmpi.l  #8,%d2
        bcc     fl_row_empty
        cmpi.l  #64,%d3
        bcc     fl_row_empty
        move.l  %d0,-(%sp)
        lsl.l   #4,%d0
        add.l   %d1,%d0
        lsl.l   #3,%d0
        add.l   %d2,%d0
        bsr     fl_lane_page
        move.l  (%sp)+,%d0
        cmpa.l  #0,%a0
        beq     fl_row_empty
        adda.l  %d3,%a0
        adda.l  %d3,%a0
        rts
fl_row_empty:
        lea     fl_empty_row:l,%a0
        rts

| fl_row's coordinates -> a0 the step's row, its lane taken now when it had none, or 0 (a
| coordinate off, or no free page). Other registers kept.
fl_row_take:
        suba.l  %a0,%a0
        cmpi.l  #16,%d0
        bcc     fl_rt_out
        cmpi.l  #16,%d1
        bcc     fl_rt_out
        cmpi.l  #8,%d2
        bcc     fl_rt_out
        cmpi.l  #64,%d3
        bcc     fl_rt_out
        move.l  %d0,-(%sp)
        lsl.l   #4,%d0
        add.l   %d1,%d0
        lsl.l   #3,%d0
        add.l   %d2,%d0
        bsr     fl_lane_take
        move.l  (%sp)+,%d0
        cmpa.l  #0,%a0
        beq     fl_rt_out
        adda.l  %d3,%a0
        adda.l  %d3,%a0
fl_rt_out:
        rts

| d0 bank, d1 first row of the bank ((pattern*8+track)*64+step), d3 rows, a1 destination ->
| the rows copied (two bytes each; a lane not taken reads 255), a1 past them. Other registers
| kept. Lanes are read as they stand: the engine task's file snapshot retries on fl_lane_gen.
fl_steps_read:
        lea     -24(%sp),%sp
        movem.l %d0-%d4/%a0,(%sp)
        move.l  %d0,%d4
        lsl.l   #7,%d4                   | the bank's first lane id
fl_sx_lane:
        tst.l   %d3
        beq     fl_sx_done
        move.l  %d1,%d0
        lsr.l   #6,%d0
        add.l   %d4,%d0
        bsr     fl_lane_page
        move.l  %d1,%d2
        andi.l  #63,%d2                  | first row in this lane
        moveq   #64,%d0
        sub.l   %d2,%d0
        cmp.l   %d3,%d0
        bls     fl_sx_count
        move.l  %d3,%d0
fl_sx_count:
        add.l   %d0,%d1
        sub.l   %d0,%d3
        cmpa.l  #0,%a0
        beq     fl_sx_empty
        adda.l  %d2,%a0
        adda.l  %d2,%a0
fl_sx_copy:
        move.w  (%a0)+,(%a1)+
        subq.l  #1,%d0
        bne     fl_sx_copy
        bra     fl_sx_lane
fl_sx_empty:
        move.w  #-1,(%a1)+
        subq.l  #1,%d0
        bne     fl_sx_empty
        bra     fl_sx_lane
fl_sx_done:
        movem.l (%sp),%d0-%d4/%a0
        lea     24(%sp),%sp
        rts

| d0 bank, d1 first row, d3 rows, a1 source (two bytes a row; a1 past them) or 0 (every row
| 255) -> the rows written; d4 = 1 when one changed, else 0; a0 used. A row with a lock whose
| lane cannot be taken stays as it was (fl_lane_full counted). Other registers kept. The caller
| owns the rows (interrupts masked, or the bank not ready).
fl_steps_write:
        lea     -24(%sp),%sp
        movem.l %d0-%d3/%d5-%d6,(%sp)
        moveq   #0,%d4
        move.l  %d0,%d5
        lsl.l   #7,%d5
fl_sy_row:
        tst.l   %d3
        beq     fl_sy_done
        move.l  #0xffff,%d6
        cmpa.l  #0,%a1
        beq     fl_sy_have
        mvz.w   (%a1)+,%d6
fl_sy_have:
        move.l  %d1,%d0
        lsr.l   #6,%d0
        add.l   %d5,%d0
        bsr     fl_lane_page
        cmpa.l  #0,%a0
        bne     fl_sy_lane
        cmpi.l  #0xffff,%d6
        beq     fl_sy_next               | no lane and no lock
        bsr     fl_lane_take
        cmpa.l  #0,%a0
        beq     fl_sy_next               | no free page: refused
fl_sy_lane:
        move.l  %d1,%d0
        andi.l  #63,%d0
        add.l   %d0,%d0
        adda.l  %d0,%a0
        mvz.w   (%a0),%d0
        cmp.l   %d0,%d6
        beq     fl_sy_next
        move.w  %d6,(%a0)
        moveq   #1,%d4
fl_sy_next:
        addq.l  #1,%d1
        subq.l  #1,%d3
        bra     fl_sy_row
fl_sy_done:
        movem.l (%sp),%d0-%d3/%d5-%d6
        lea     24(%sp),%sp
        rts

fl_mark_dirty:
        cmpi.l  #16,%d0
        bcc     fl_mark_out
        lea     -8(%sp),%sp
        movem.l %d1/%a0,(%sp)
        moveq   #1,%d1
        lsl.l   %d0,%d1
        or.l    %d1,fl_dirty_mask:l
        or.l    %d1,fl_lane_gc_mask:l    | (2.23) the UI tick looks for lanes emptied by the edit
        lea     fl_generation:l,%a0
        addq.l  #1,(%a0,%d0.l*4)
        movem.l (%sp),%d1/%a0
        addq.l  #8,%sp
fl_mark_out:
        rts

fl_write:
        lea     -16(%sp),%sp
        movem.l %d6/%a0-%a1,(%sp)
        move.w  %sr,%d6
        move.l  %d6,12(%sp)
        move.w  #0x2700,%sr
        cmpi.l  #16,%d0
        bcc     fl_write_bad
        cmpi.l  #FL_CONTROLS,%d4
        bcc     fl_write_bad
        move.l  fl_ready_mask:l,%d6
        btst    %d0,%d6
        beq     fl_write_bad
        move.l  fl_blocked_mask:l,%d6
        btst    %d0,%d6
        bne     fl_write_bad
fl_write_af:
        cmpi.l  #255,%d5
        beq     fl_write_value_ok
        tst.l   %d4
        bne     fl_write_nonzero
        tst.l   %d5
        beq     fl_write_bad
fl_write_nonzero:
        lea     fl_maxima:l,%a1
        mvz.b   (%a1,%d4.l),%d6
        cmp.l   %d6,%d5
        bhi     fl_write_bad
fl_write_value_ok:
        cmpi.l  #16,%d1
        bcc     fl_write_bad
        cmpi.l  #8,%d2
        bcc     fl_write_bad
        cmpi.l  #64,%d3
        bcc     fl_write_bad
        bsr     fl_row
        lea     fl_empty_row:l,%a1
        cmpa.l  %a1,%a0
        bne     fl_write_have
        cmpi.l  #255,%d5
        beq     fl_write_same            | no lane, nothing to remove
        bsr     fl_row_take
        cmpa.l  #0,%a0
        beq     fl_write_bad             | no free page: the lock is refused (fl_lane_full)
fl_write_have:
        mvz.b   (%a0,%d4.l),%d6
        cmp.l   %d6,%d5
        beq     fl_write_same
        move.b  %d5,(%a0,%d4.l)
        bsr     fl_mark_dirty
fl_write_changed:
        moveq   #1,%d0
        bra     fl_write_out
fl_write_same:
        moveq   #0,%d0
        bra     fl_write_out
fl_write_bad:
        moveq   #-1,%d0
fl_write_out:
        move.l  12(%sp),%d6
        move.w  %d6,%sr
        movem.l (%sp),%d6/%a0-%a1
        lea     16(%sp),%sp
        rts

| Every lane free, every page on the stack (the first take gets page 0). No reader takes a row
| meanwhile: fl_reset has cleared the ready mask first, and no writer runs on a bank not ready.
fl_lane_reset:
        lea     -12(%sp),%sp
        movem.l %d0-%d1/%a0,(%sp)
        lea     fl_lane_index:l,%a0
        move.l  #FL_LANES/2,%d0
fl_lz_index:
        clr.l   (%a0)+
        subq.l  #1,%d0
        bne     fl_lz_index
        lea     fl_lane_stack:l,%a0
        move.l  #FL_POOL_LANES,%d0
fl_lz_stack:
        subq.l  #1,%d0
        move.w  %d0,(%a0)+
        tst.l   %d0
        bne     fl_lz_stack
        move.w  %sr,%d1
        move.w  #0x2700,%sr
        move.l  #FL_POOL_LANES,%d0
        move.l  %d0,fl_lane_free:l
        addq.l  #1,fl_lane_gen:l
        clr.l   fl_lane_gc_mask:l
        move.w  %d1,%sr
        movem.l (%sp),%d0-%d1/%a0
        lea     12(%sp),%sp
        rts

fl_reset:
        lea     -12(%sp),%sp
        movem.l %d0-%d1/%a0,(%sp)
        clr.l   fl_ready_mask:l
        moveq   #-1,%d0
        move.l  %d0,fl_blocked_mask:l
        bsr     fl_lane_reset            | (2.23) in place of 2 MiB and 32 KiB of 0xFF
        lea     fl_generation:l,%a0
        moveq   #16,%d0
fl_reset_generations:
        clr.l   (%a0)+
        subq.l  #1,%d0
        bne     fl_reset_generations
        lea     fl_migration_table:l,%a0
        move.l  #16*FL_MIGRATION_BANK_BYTES/4,%d0
fl_reset_migration:
        clr.l   (%a0)+
        subq.l  #1,%d0
        bne     fl_reset_migration
        jsr     fs_reset:l
        clr.l   fl_ready_mask:l
        clr.l   fl_blocked_mask:l
        clr.l   fl_dirty_mask:l
        movem.l (%sp),%d0-%d1/%a0
        lea     12(%sp),%sp
        rts

fl_payload_validate:
        lea     -8(%sp),%sp
        movem.l %d1/%a0,(%sp)
        cmpi.l  #FL_PAYLOAD_BYTES,%d0
        bne     fl_pv_bad
        move.l  #FL_PAIR_BYTES,%d1
fl_pv_pair:
        mvz.b   (%a0)+,%d0
        cmpi.l  #255,%d0
        beq     fl_pv_chord
        subq.l  #1,%d0
        cmpi.l  #3,%d0
        bhi     fl_pv_bad
fl_pv_chord:
        mvz.b   (%a0)+,%d0
        cmpi.l  #127,%d0
        bls     fl_pv_next
        cmpi.l  #255,%d0
        bne     fl_pv_bad
fl_pv_next:
        subq.l  #2,%d1
        bne     fl_pv_pair
fl_pv_good:
        move.l  (%a0),%d0
        cmpi.l  #2,%d0
        bhi     fl_pv_bad
        moveq   #0,%d0
        bra     fl_pv_out
fl_pv_bad:
        moveq   #-1,%d0
fl_pv_out:
        movem.l (%sp),%d1/%a0
        addq.l  #8,%sp
        rts

fl_crc32:
        lea     -20(%sp),%sp
        movem.l %d1-%d3/%a0-%a1,(%sp)
        move.l  %d0,%d1
        moveq   #-1,%d0
        lea     fl_crc_table:l,%a1
        tst.l   %d1
        beq     fl_crc_done
fl_crc_byte:
        mvz.b   (%a0)+,%d2
        eor.l   %d0,%d2
        andi.l  #255,%d2
        move.l  (%a1,%d2.l*4),%d3
        lsr.l   #8,%d0
        eor.l   %d3,%d0
        subq.l  #1,%d1
        bne     fl_crc_byte
fl_crc_done:
        not.l   %d0
        movem.l (%sp),%d1-%d3/%a0-%a1
        lea     20(%sp),%sp
        rts

fl_file_validate:
        lea     -16(%sp),%sp
        movem.l %d2-%d3/%a0-%a1,(%sp)
        move.l  %d0,%d2
        cmpi.l  #10,%d1
        bcs     fl_fv_header
        cmpi.l  #16,%d2
        bcc     fl_fv_header
        move.l  (%a0),%d0
        cmpi.l  #0x464d4c4f,%d0
        bne     fl_fv_header
        move.l  4(%a0),%d0
        cmpi.l  #0x434b5300,%d0
        bne     fl_fv_header
        mvz.w   8(%a0),%d0
        move.l  #FL_PAYLOAD_BYTES,%d3
        cmpi.l  #1,%d0
        bne     fl_fv_version
fl_fv_length:
        moveq   #32,%d0
        add.l   %d3,%d0
        cmp.l   %d0,%d1
        bne     fl_fv_header
        mvz.w   10(%a0),%d0
        cmpi.l  #32,%d0
        bne     fl_fv_header
        cmp.w   12(%a0),%d2
        bne     fl_fv_header
        tst.w   14(%a0)
        bne     fl_fv_header
        move.l  16(%a0),%d0
        cmp.l   %d3,%d0
        bne     fl_fv_header
        moveq   #28,%d0
        bsr     fl_crc32
        cmp.l   28(%a0),%d0
        bne     fl_fv_crc
        movea.l %a0,%a1
        lea     32(%a0),%a0
        move.l  %d3,%d0
        bsr     fl_crc32
        cmp.l   24(%a1),%d0
        bne     fl_fv_crc
        move.l  %d3,%d0
        bsr     fl_payload_validate
        tst.l   %d0
        bne     fl_fv_values
        move.l  20(%a1),%d1
        moveq   #0,%d0
        bra     fl_fv_out
fl_fv_header:
        moveq   #-1,%d0
        bra     fl_fv_error
fl_fv_version:
        moveq   #-2,%d0
        bra     fl_fv_error
fl_fv_crc:
        moveq   #-3,%d0
        bra     fl_fv_error
fl_fv_values:
        moveq   #-4,%d0
fl_fv_error:
        moveq   #0,%d1
fl_fv_out:
        movem.l (%sp),%d2-%d3/%a0-%a1
        lea     16(%sp),%sp
        rts

| d0 bank, d1 generation, a1 the file buffer -> the bank's rows, scene pairs and checkpoint
| packed behind the header and sealed (d0 0), or -1.
fl_file_pack:
        cmpi.l  #16,%d0
        bcc     fl_fp_bad
        lea     -20(%sp),%sp
        movem.l %d1-%d3/%a0-%a1,(%sp)
        lea     32(%a1),%a1
        moveq   #0,%d1
        move.l  #FL_ROWS,%d3
        bsr     fl_steps_read
        moveq   #0,%d1
        moveq   #1,%d2
        move.l  #FL_SCENE_BANK_BYTES/2,%d3
        jsr     fl_scenes_read:l
        move.l  #FL_MIGRATION_BANK_BYTES,%d3
        mulu.l  %d0,%d3
        lea     fl_migration_table:l,%a0
        adda.l  %d3,%a0
        moveq   #FL_MIGRATION_BANK_BYTES/4,%d3
fl_fp_migration:
        move.l  (%a0)+,(%a1)+
        subq.l  #1,%d3
        bne     fl_fp_migration
        movem.l (%sp),%d1-%d3/%a0-%a1
        lea     20(%sp),%sp
        bra     fl_file_seal
fl_fp_bad:
        moveq   #-1,%d0
        rts

fl_file_seal:
        lea     -24(%sp),%sp
        movem.l %d1-%d3/%a0-%a2,(%sp)
        move.l  %d0,%d2
        cmpi.l  #16,%d2
        bcc     fl_fs_bad
        lea     32(%a1),%a0
        move.l  #FL_PAYLOAD_BYTES,%d0
        bsr     fl_payload_validate
        tst.l   %d0
        bne     fl_fs_bad
        move.l  #0x464d4c4f,%d0
        move.l  %d0,(%a1)
        move.l  #0x434b5300,%d0
        move.l  %d0,4(%a1)
        move.l  #0x00010020,%d0
        move.l  %d0,8(%a1)
        move.w  %d2,12(%a1)
        clr.w   14(%a1)
        move.l  #FL_PAYLOAD_BYTES,%d0
        move.l  %d0,16(%a1)
        move.l  %d1,20(%a1)
        lea     32(%a1),%a0
        move.l  #FL_PAYLOAD_BYTES,%d0
        bsr     fl_crc32
        move.l  %d0,24(%a1)
        movea.l %a1,%a0
        moveq   #28,%d0
        bsr     fl_crc32
        move.l  %d0,28(%a1)
        moveq   #0,%d0
        bra     fl_fs_out
fl_fs_bad:
        moveq   #-1,%d0
fl_fs_out:
        movem.l (%sp),%d1-%d3/%a0-%a2
        lea     24(%sp),%sp
        rts

| d0 bank, d1 generation, a0 a validated payload -> the bank's lanes freed and refilled from it
| (a lane only where a row or pair holds a lock), checkpoint, generation and ready (d0 0); -1 for
| a bad payload; -2 when the pool cannot hold the bank's lanes (its lanes freed again, left as
| publish() set it: blocked, not ready).
fl_bank_publish:
        lea     -32(%sp),%sp
        movem.l %d1-%d5/%a0-%a2,(%sp)
        move.l  %d0,%d5
        cmpi.l  #16,%d5
        bcc     fl_bp_bad
        move.l  #FL_PAYLOAD_BYTES,%d0
        bsr     fl_payload_validate
        tst.l   %d0
        bne     fl_bp_bad
        move.l  %d5,%d0
        bsr     fl_bank_free
        movea.l fl_lane_full:l,%a2
        movea.l %a0,%a1
        moveq   #0,%d1
        move.l  #FL_ROWS,%d3
        bsr     fl_steps_write
        moveq   #0,%d1
        moveq   #1,%d2
        move.l  #FL_SCENE_BANK_BYTES/2,%d3
        jsr     fl_scenes_write:l
        cmpa.l  fl_lane_full:l,%a2
        bne     fl_bp_pool
        move.l  #FL_MIGRATION_BANK_BYTES,%d3
        mulu.l  %d5,%d3
        lea     fl_migration_table:l,%a0
        adda.l  %d3,%a0
        moveq   #FL_MIGRATION_BANK_BYTES/4,%d3
fl_bp_migration:
        move.l  (%a1)+,(%a0)+
        subq.l  #1,%d3
        bne     fl_bp_migration
        move.l  (%sp),%d1
        lea     fl_generation:l,%a0
        move.l  %d1,(%a0,%d5.l*4)
        moveq   #1,%d3
        lsl.l   %d5,%d3
        lea     fl_ready_mask:l,%a0
        or.l    %d3,(%a0)
        not.l   %d3
        lea     fl_dirty_mask:l,%a0
        and.l   %d3,(%a0)
        lea     fl_blocked_mask:l,%a0
        and.l   %d3,(%a0)
        moveq   #0,%d0
        bra     fl_bp_out
fl_bp_pool:
        move.l  %d5,%d0
        bsr     fl_bank_free
        moveq   #-2,%d0
        bra     fl_bp_out
fl_bp_bad:
        moveq   #-1,%d0
fl_bp_out:
        movem.l (%sp),%d1-%d5/%a0-%a2
        lea     32(%sp),%sp
        rts

        .section .data
        .balign 4
fl_empty_row:
        .long   0xffffffff,0xffffffff,0xffffffff,0xffffffff
fl_maxima:
        .byte   4,127,255,255
fl_ready_mask:
        .long   0
fl_blocked_mask:
        .long   0
fl_dirty_mask:
        .long   0
fl_generation:
        .fill   16,4,0
fl_lane_free:                            | pages on fl_lane_stack
        .long   0
fl_lane_gen:                             | counts every page given back
        .long   0
fl_lane_full:                            | counts every lock refused for want of a page
        .long   0
fl_lane_gc_mask:                         | banks edited since the UI tick last looked for empty lanes
        .long   0
        .if FL_LANES_IN_BSS
| A package: the index, the page stack and the pool are zeroed at admission (no lane, no page
| free until fl_reset) and travel in neither the package file nor the upload.
        .section .bss
        .balign 4
fl_lane_index:
        .space  FL_LANES*2
fl_lane_stack:
        .space  ((FL_POOL_LANES*2+3)/4)*4
fl_lane_pool:
        .space  FL_POOL_LANES*FL_LANE
        .global fl_migration_table
fl_migration_table:                      | a card build's DramRegion (synth/manifest.py)
        .space  16*FL_MIGRATION_BANK_BYTES
        .endif
        .section .text

        .balign 4
fl_crc_table:
        .long 0x00000000,0x77073096,0xee0e612c,0x990951ba
        .long 0x076dc419,0x706af48f,0xe963a535,0x9e6495a3
        .long 0x0edb8832,0x79dcb8a4,0xe0d5e91e,0x97d2d988
        .long 0x09b64c2b,0x7eb17cbd,0xe7b82d07,0x90bf1d91
        .long 0x1db71064,0x6ab020f2,0xf3b97148,0x84be41de
        .long 0x1adad47d,0x6ddde4eb,0xf4d4b551,0x83d385c7
        .long 0x136c9856,0x646ba8c0,0xfd62f97a,0x8a65c9ec
        .long 0x14015c4f,0x63066cd9,0xfa0f3d63,0x8d080df5
        .long 0x3b6e20c8,0x4c69105e,0xd56041e4,0xa2677172
        .long 0x3c03e4d1,0x4b04d447,0xd20d85fd,0xa50ab56b
        .long 0x35b5a8fa,0x42b2986c,0xdbbbc9d6,0xacbcf940
        .long 0x32d86ce3,0x45df5c75,0xdcd60dcf,0xabd13d59
        .long 0x26d930ac,0x51de003a,0xc8d75180,0xbfd06116
        .long 0x21b4f4b5,0x56b3c423,0xcfba9599,0xb8bda50f
        .long 0x2802b89e,0x5f058808,0xc60cd9b2,0xb10be924
        .long 0x2f6f7c87,0x58684c11,0xc1611dab,0xb6662d3d
        .long 0x76dc4190,0x01db7106,0x98d220bc,0xefd5102a
        .long 0x71b18589,0x06b6b51f,0x9fbfe4a5,0xe8b8d433
        .long 0x7807c9a2,0x0f00f934,0x9609a88e,0xe10e9818
        .long 0x7f6a0dbb,0x086d3d2d,0x91646c97,0xe6635c01
        .long 0x6b6b51f4,0x1c6c6162,0x856530d8,0xf262004e
        .long 0x6c0695ed,0x1b01a57b,0x8208f4c1,0xf50fc457
        .long 0x65b0d9c6,0x12b7e950,0x8bbeb8ea,0xfcb9887c
        .long 0x62dd1ddf,0x15da2d49,0x8cd37cf3,0xfbd44c65
        .long 0x4db26158,0x3ab551ce,0xa3bc0074,0xd4bb30e2
        .long 0x4adfa541,0x3dd895d7,0xa4d1c46d,0xd3d6f4fb
        .long 0x4369e96a,0x346ed9fc,0xad678846,0xda60b8d0
        .long 0x44042d73,0x33031de5,0xaa0a4c5f,0xdd0d7cc9
        .long 0x5005713c,0x270241aa,0xbe0b1010,0xc90c2086
        .long 0x5768b525,0x206f85b3,0xb966d409,0xce61e49f
        .long 0x5edef90e,0x29d9c998,0xb0d09822,0xc7d7a8b4
        .long 0x59b33d17,0x2eb40d81,0xb7bd5c3b,0xc0ba6cad
        .long 0xedb88320,0x9abfb3b6,0x03b6e20c,0x74b1d29a
        .long 0xead54739,0x9dd277af,0x04db2615,0x73dc1683
        .long 0xe3630b12,0x94643b84,0x0d6d6a3e,0x7a6a5aa8
        .long 0xe40ecf0b,0x9309ff9d,0x0a00ae27,0x7d079eb1
        .long 0xf00f9344,0x8708a3d2,0x1e01f268,0x6906c2fe
        .long 0xf762575d,0x806567cb,0x196c3671,0x6e6b06e7
        .long 0xfed41b76,0x89d32be0,0x10da7a5a,0x67dd4acc
        .long 0xf9b9df6f,0x8ebeeff9,0x17b7be43,0x60b08ed5
        .long 0xd6d6a3e8,0xa1d1937e,0x38d8c2c4,0x4fdff252
        .long 0xd1bb67f1,0xa6bc5767,0x3fb506dd,0x48b2364b
        .long 0xd80d2bda,0xaf0a1b4c,0x36034af6,0x41047a60
        .long 0xdf60efc3,0xa867df55,0x316e8eef,0x4669be79
        .long 0xcb61b38c,0xbc66831a,0x256fd2a0,0x5268e236
        .long 0xcc0c7795,0xbb0b4703,0x220216b9,0x5505262f
        .long 0xc5ba3bbe,0xb2bd0b28,0x2bb45a92,0x5cb36a04
        .long 0xc2d7ffa7,0xb5d0cf31,0x2cd99e8b,0x5bdeae1d
        .long 0x9b64c2b0,0xec63f226,0x756aa39c,0x026d930a
        .long 0x9c0906a9,0xeb0e363f,0x72076785,0x05005713
        .long 0x95bf4a82,0xe2b87a14,0x7bb12bae,0x0cb61b38
        .long 0x92d28e9b,0xe5d5be0d,0x7cdcefb7,0x0bdbdf21
        .long 0x86d3d2d4,0xf1d4e242,0x68ddb3f8,0x1fda836e
        .long 0x81be16cd,0xf6b9265b,0x6fb077e1,0x18b74777
        .long 0x88085ae6,0xff0f6a70,0x66063bca,0x11010b5c
        .long 0x8f659eff,0xf862ae69,0x616bffd3,0x166ccf45
        .long 0xa00ae278,0xd70dd2ee,0x4e048354,0x3903b3c2
        .long 0xa7672661,0xd06016f7,0x4969474d,0x3e6e77db
        .long 0xaed16a4a,0xd9d65adc,0x40df0b66,0x37d83bf0
        .long 0xa9bcae53,0xdebb9ec5,0x47b2cf7f,0x30b5ffe9
        .long 0xbdbdf21c,0xcabac28a,0x53b39330,0x24b4a3a6
        .long 0xbad03605,0xcdd70693,0x54de5729,0x23d967bf
        .long 0xb3667a2e,0xc4614ab8,0x5d681b02,0x2a6f2b94
        .long 0xb40bbe37,0xc30c8ea1,0x5a05df1b,0x2d02ef8d
