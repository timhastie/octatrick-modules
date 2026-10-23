| FM SYNTH setup locks: immutable rows accompany accepted stock queue events.

        .text
        .global fl_seq_produce,fl_seq_eligible,fl_seq_promote_a,fl_seq_promote_b
        .global fl_seq_consume,fl_seq_publish,fl_seq_queue_clear,fl_seq_full_restore
        .global fl_seq_tick,fl_seq_reset,fl_seq_release_control

fl_seq_produce:
        lea     -12(%sp),%sp
        movem.l %d0/%d2/%a0,(%sp)
        move.l  16(%sp),%d2
        move.l  32(%sp),%d0
        bsr     fl_seq_queue_ptr
        cmpa.l  #0,%a0
        beq     fl_sp_done
        moveq   #-1,%d0
        move.l  %d0,(%a0)+
        move.l  %d0,(%a0)+
        move.l  %d0,(%a0)+
        move.l  %d0,(%a0)
fl_sp_done:
        movem.l (%sp),%d0/%d2/%a0
        lea     12(%sp),%sp
        .if HAVE_SYDRUM
        jmp sl_seq_produce:l
        .else
        lea     -104(%sp),%sp
        movem.l %d2-%d7/%a2-%a6,(%sp)
        jmp     0x4009d1f0
        .endif

fl_seq_source_kind:
        lea     -16(%sp),%sp
        movem.l %d1/%d3/%a0-%a1,(%sp)
        cmpi.l  #8,%d2
        bcc     fl_ssk_no
        cmpi.l  #16,%d0
        bcc     fl_ssk_no
        cmpi.l  #16,%d1
        bcc     fl_ssk_no
        move.l  #0x9b340,%d3
        mulu.l  %d0,%d3
        movea.l #0x400e21e0,%a0
        adda.l  %d3,%a0
        move.l  #0x8ed8,%d3
        mulu.l  %d1,%d3
        adda.l  %d3,%a0
        adda.l  #0x8e57,%a0
        mvz.b   (%a0),%d1
        suba.l  #0x8e57,%a0
        suba.l  %d3,%a0
        cmpi.l  #4,%d1
        bcc     fl_ssk_no
        lea     0x8000182a,%a1
        mvz.b   (%a1,%d2.l),%d3
        cmp.l   %d0,%d3
        bne     fl_ssk_part
        movea.l PART_PTR,%a0
        cmpa.l  #0x40000000,%a0
        bcs     fl_ssk_no
        cmpa.l  #0x48000000,%a0
        bcc     fl_ssk_no
fl_ssk_part:
        move.l  #6322,%d3
        mulu.l  %d1,%d3
        adda.l  %d3,%a0
        move.l  %d2,%d0
        jsr     po_sig:l
        beq     fl_ssk_out
        moveq   #1,%d0
        bra     fl_ssk_out
fl_ssk_no:
        moveq   #0,%d0
fl_ssk_out:
        movem.l (%sp),%d1/%d3/%a0-%a1
        lea     16(%sp),%sp
        tst.l   %d0
        rts

fl_seq_queue_ptr:
        cmpi.l  #8,%d2
        bcc     fl_sqp_bad
        cmpi.l  #-1,%d0
        beq     fl_sqp_scratch
        cmpi.l  #3,%d0
        bcc     fl_sqp_bad
        lsl.l   #3,%d0
        add.l   %d2,%d0
        lsl.l   #4,%d0
        lea     fl_seq_queue:l,%a0
        adda.l  %d0,%a0
        rts
fl_sqp_scratch:
        move.l  %d2,%d0
        lsl.l   #4,%d0
        lea     fl_seq_scratch:l,%a0
        adda.l  %d0,%a0
        rts
fl_sqp_bad:
        suba.l  %a0,%a0
        rts

fl_seq_eligible:
        move.l  %a5,%d3
        lea     -28(%sp),%sp
        movem.l %d0-%d4/%a0-%a1,(%sp)
        move.l  140(%sp),%d0
        bsr     fl_seq_bank_ok
        tst.l   %d0
        beq     fl_se_done
        move.l  %d7,%d2
        move.l  152(%sp),%d0
        bsr     fl_seq_queue_ptr
        cmpa.l  #0,%a0
        beq     fl_se_done
        movea.l %a0,%a1
        move.l  140(%sp),%d0
        move.l  144(%sp),%d1
        move.l  148(%sp),%d3
        jsr     fl_row:l
        move.l  (%a0)+,(%a1)+
        move.l  (%a0)+,(%a1)+
        move.l  (%a0)+,(%a1)+
        move.l  (%a0),(%a1)
        lea     -12(%a1),%a1
        move.l  (%sp),%d0
        and.l   12(%sp),%d0
        bne     fl_se_done
        move.l  4(%a1),%d4
        ori.l   #0xffff,%d4
        and.l   (%a1),%d4
        cmpi.l  #-1,%d4
        bne     fl_se_af
        bra     fl_se_none
fl_se_af:
        move.l  140(%sp),%d0
        bsr     fl_seq_source_kind
        tst.l   %d0
        beq     fl_se_none
        moveq   #-1,%d4
        cmp.l   (%a1),%d4
        bne     fl_se_lock
fl_se_none:
        moveq   #-1,%d0
        move.l  %d0,(%a1)+
        move.l  %d0,(%a1)+
        move.l  %d0,(%a1)+
        move.l  %d0,(%a1)
        bra     fl_se_done
fl_se_lock:
        move.l  12(%sp),%d0
        or.l    %d0,(%sp)
fl_se_done:
        movem.l (%sp),%d0-%d4/%a0-%a1
        lea     28(%sp),%sp
        .if HAVE_SYDRUM
        jmp sl_seq_eligible:l
        .else
        and.l   %d3,%d0
        beq     fl_se_absent
        jmp     0x4009d3a6
fl_se_absent:
        jmp     0x4009d91a
        .endif

fl_seq_promote_a:
        lea     -8(%sp),%sp
        movem.l %d0/%a0,(%sp)
        move.l  %d3,%d0
        bsr     fl_seq_promote
        movem.l (%sp),%d0/%a0
        lea     8(%sp),%sp
        .if HAVE_SYDRUM
        jmp sl_seq_promote_a:l
        .else
        lea     0x46c7a874,%a1
        jmp     0x4009b874
        .endif
fl_seq_promote_b:
        lea     -8(%sp),%sp
        movem.l %d0/%a0,(%sp)
        move.l  %d4,%d0
        bsr     fl_seq_promote
        movem.l (%sp),%d0/%a0
        lea     8(%sp),%sp
        .if HAVE_SYDRUM
        jmp sl_seq_promote_b:l
        .else
        lea     0x46c7a874,%a1
        jmp     0x4009c054
        .endif
fl_seq_promote:
        cmpi.l  #8,%d0
        bcc     fl_spro_out
        lsl.l   #4,%d0
        move.l  %a1,-(%sp)
        lea     fl_seq_scratch:l,%a0
        adda.l  %d0,%a0
        lea     fl_seq_queue:l,%a1
        adda.l  %d0,%a1
        move.l  (%a0)+,(%a1)+
        move.l  (%a0)+,(%a1)+
        move.l  (%a0)+,(%a1)+
        move.l  (%a0),(%a1)
        move.l  (%sp)+,%a1
fl_spro_out:
        rts

fl_seq_consume:
        lea     -12(%sp),%sp
        movem.l %d0/%a0-%a1,(%sp)
        cmpi.l  #24,%d5
        bcc     fl_sc_out
        mvz.b   130(%sp),%d0
        bsr     fl_seq_bank_ok
        tst.l   %d0
        beq     fl_sc_empty
        move.l  %d5,%d0
        lsl.l   #4,%d0
        lea     fl_seq_queue:l,%a1
        adda.l  %d0,%a1
        bra     fl_sc_store
fl_sc_empty:
        lea     fl_empty_row:l,%a1
fl_sc_store:
        move.l  %d5,%d0
        andi.l  #7,%d0
        move.l  %d1,-(%sp)
        move.l  fl_seq_cleanm:l,%d1
        bclr    %d0,%d1
        move.l  %d1,fl_seq_cleanm:l
        move.l  (%sp)+,%d1
        lsl.l   #4,%d0
        lea     fl_seq_pending:l,%a0
        adda.l  %d0,%a0
        move.l  (%a1)+,(%a0)+
        move.l  (%a1)+,(%a0)+
        move.l  (%a1)+,(%a0)+
        move.l  (%a1),(%a0)
fl_sc_out:
        movem.l (%sp),%d0/%a0-%a1
        lea     12(%sp),%sp
        .if HAVE_SYDRUM
        jmp sl_seq_consume:l
        .else
        movem.l (%a0),%d1-%d4/%d6-%d7/%a4-%a5
        movem.l %d1-%d4/%d6-%d7/%a4-%a5,(%a2)
        jmp     0x4000bb06
        .endif

fl_seq_full_restore:
        lea     -8(%sp),%sp
        movem.l %d0/%a0,(%sp)
        move.l  122(%sp),%d0
        cmpi.l  #8,%d0
        bcc     fl_sfr_out
        lsl.l   #4,%d0
        lea     fl_seq_active:l,%a0
        adda.l  %d0,%a0
        moveq   #-1,%d0
        move.l  %d0,(%a0)+
        move.l  %d0,(%a0)+
        move.l  %d0,(%a0)+
        move.l  %d0,(%a0)
fl_sfr_out:
        movem.l (%sp),%d0/%a0
        lea     8(%sp),%sp
        .if HAVE_SYDRUM
        jmp sl_seq_full_restore:l
        .else
        movea.l 184(%sp),%a5
        clr.l   (%a5)
        jmp     0x4000c428
        .endif

fl_seq_publish:
        lea     -32(%sp),%sp
        movem.l %d0-%d4/%a0-%a2,(%sp)
        move.l  146(%sp),%d2
        cmpi.l  #8,%d2
        bcc     fl_spl_out
        move.l  fl_seq_cleanm:l,%d0
        bclr    %d2,%d0
        move.l  %d0,fl_seq_cleanm:l
        move.l  %d2,%d0
        lsl.l   #4,%d0
        lea     fl_seq_active:l,%a0
        adda.l  %d0,%a0
        lea     fl_seq_pending:l,%a1
        adda.l  %d0,%a1
        lea     fl_seq_context:l,%a2
        move.w  150(%sp),%d0
        cmp.w   (%a2,%d2.l*2),%d0
        beq     fl_spl_flags
        move.w  %d0,(%a2,%d2.l*2)
        bsr     fl_seq_empty_a0
fl_spl_flags:
        mvz.b   150(%sp),%d0
        bsr     fl_seq_bank_ok
        tst.l   %d0
        bne     fl_spl_ready
        bsr     fl_seq_empty_a0
        move.l  %a0,-(%sp)
        movea.l %a1,%a0
        bsr     fl_seq_empty_a0
        movea.l (%sp)+,%a0
        bra     fl_spl_refresh
fl_spl_ready:
        move.l  %a4,%d4
        btst    #6,%d4
        bne     fl_spl_apply
        bsr     fl_seq_empty_a0
fl_spl_apply:
        btst    #3,%d4
        bne     fl_spl_refresh
        moveq   #0,%d3
fl_spl_control:
        mvz.b   (%a1,%d3.l),%d0
        cmpi.l  #255,%d0
        beq     fl_spl_next
        move.b  %d0,(%a0,%d3.l)
        btst    #2,%d4
        bne     fl_spl_next
        moveq   #-1,%d0
        move.b  %d0,(%a1,%d3.l)
fl_spl_next:
        addq.l  #1,%d3
        cmpi.l  #FL_CONTROLS,%d3
        bne     fl_spl_control
fl_spl_refresh:
        bsr     fl_seq_refresh_track
fl_spl_out:
        movem.l (%sp),%d0-%d4/%a0-%a2
        lea     32(%sp),%sp
        .if HAVE_SYDRUM
        jmp sl_seq_publish:l
        .else
        lea     0x46104d15,%a0
        jmp     0x4000c634
        .endif

fl_seq_refresh_track:
        lea     0x8000182a,%a0
        mvz.b   (%a0,%d2.l),%d0
        bsr     fl_seq_bank_ok
        tst.l   %d0
        bne     fl_srt_ready
        bsr     fl_seq_clear_track
fl_srt_ready:
        bsr     fl_seq_play_kind
        bne     fl_srt_synth
        move.l  fl_seq_cleanm:l,%d0
        btst    %d2,%d0
        beq     fl_seq_clear_track
        rts
fl_srt_synth:
        rts

| d2 sounding track -> d0 FM boolean. The per-track published bank/Part
| owns an accepted lock even when the UI changes Part mid-pattern.
fl_seq_play_kind:
        lea     -20(%sp),%sp
        movem.l %d1/%d3-%d4/%a0-%a1,(%sp)
        cmpi.l  #8,%d2
        bcc     fl_spk_no
        lea     0x8000182a,%a1
        mvz.b   (%a1,%d2.l),%d3
        cmpi.l  #16,%d3
        bcc     fl_spk_no
        mvz.b   8(%a1,%d2.l),%d4
        cmpi.l  #4,%d4
        bcc     fl_spk_no
        move.l  #0x9b340,%d1
        mulu.l  %d3,%d1
        lea     0x400e21e0,%a0
        adda.l  %d1,%a0
        mvz.b   0x100b14ce,%d1
        cmp.l   %d3,%d1
        bne     fl_spk_part
        movea.l PART_PTR,%a0
        cmpa.l  #0x40000000,%a0
        bcs     fl_spk_no
        cmpa.l  #0x48000000,%a0
        bcc     fl_spk_no
fl_spk_part:
        move.l  #6322,%d1
        mulu.l  %d4,%d1
        adda.l  %d1,%a0
        move.l  %d2,%d0
        jsr     po_sig:l
        bra     fl_spk_out
fl_spk_no:
        moveq   #0,%d0
fl_spk_out:
        movem.l (%sp),%d1/%d3-%d4/%a0-%a1
        lea     20(%sp),%sp
        tst.l   %d0
        rts

fl_seq_clear_track:
        move.l  fl_seq_cleanm:l,%d0
        bset    %d2,%d0
        move.l  %d0,fl_seq_cleanm:l
        move.l  %d2,%d0
        lsl.l   #4,%d0
        lea     fl_seq_active:l,%a0
        adda.l  %d0,%a0
        bsr     fl_seq_empty_a0
        move.l  %d2,%d0
        lsl.l   #4,%d0
        lea     fl_seq_pending:l,%a0
        adda.l  %d0,%a0

fl_seq_empty_a0:
        move.l  %d0,-(%sp)
        moveq   #-1,%d0
        move.l  %d0,(%a0)
        move.l  %d0,4(%a0)
        move.l  %d0,8(%a0)
        move.l  %d0,12(%a0)
        move.l  (%sp)+,%d0
        rts

fl_seq_tick:
        lea     -28(%sp),%sp
        movem.l %d0-%d3/%a0-%a2,(%sp)
        moveq   #0,%d2
fl_st_loop:
        bsr     fl_seq_refresh_track
        addq.l  #1,%d2
        cmpi.l  #8,%d2
        bne     fl_st_loop
        movem.l (%sp),%d0-%d3/%a0-%a2
        lea     28(%sp),%sp
        rts

fl_seq_release_control:
        cmpi.l  #8,%d2
        bcc     fl_src_out
        cmpi.l  #FL_CONTROLS,%d4
        bcc     fl_src_out
        lea     -8(%sp),%sp
        movem.l %d0/%a0,(%sp)
        move.l  %d2,%d0
        lsl.l   #4,%d0
        lea     fl_seq_active:l,%a0
        adda.l  %d0,%a0
        moveq   #-1,%d0
        move.b  %d0,(%a0,%d4.l)
        movem.l (%sp),%d0/%a0
        lea     8(%sp),%sp
fl_src_out:
        rts

fl_seq_bank_ok:
        move.l  %d1,-(%sp)
        cmpi.l  #16,%d0
        bcc     fl_sbo_no
        move.l  fl_ready_mask:l,%d1
        btst    %d0,%d1
        beq     fl_sbo_no
        move.l  fl_blocked_mask:l,%d1
        btst    %d0,%d1
        bne     fl_sbo_no
        moveq   #1,%d0
        bra     fl_sbo_out
fl_sbo_no:
        moveq   #0,%d0
fl_sbo_out:
        move.l  (%sp)+,%d1
        rts

fl_seq_queue_clear:
        lea     -8(%sp),%sp
        movem.l %d0/%a0,(%sp)
        lea     fl_seq_queue:l,%a0
        moveq   #96,%d0
fl_sqc_loop:
        move.l  #-1,(%a0)+
        subq.l  #1,%d0
        bne     fl_sqc_loop
        movem.l (%sp),%d0/%a0
        lea     8(%sp),%sp
        .if HAVE_SYDRUM
        jmp sl_seq_queue_clear:l
        .else
        move.l  %d2,-(%sp)
        lea     0x80006500,%a1
        jmp     0x4009b228
        .endif

fl_seq_reset:
        lea     -8(%sp),%sp
        movem.l %d0/%a0,(%sp)
        lea     fl_seq_queue:l,%a0
        move.l  #196,%d0
fl_sr_loop:
        move.l  #-1,(%a0)+
        subq.l  #1,%d0
        bne     fl_sr_loop
        move.l  #0xff,%d0
        move.l  %d0,fl_seq_cleanm:l
        movem.l (%sp),%d0/%a0
        lea     8(%sp),%sp
        rts

        .data
        .balign 4
fl_seq_queue:       .fill 96,4,0xffffffff
fl_seq_scratch:     .fill 32,4,0xffffffff
fl_seq_pending:     .fill 32,4,0xffffffff
fl_seq_active:      .fill 32,4,0xffffffff
fl_seq_context:     .fill 4,4,0xffffffff
fl_seq_cleanm:      .long 0xff
        .text
