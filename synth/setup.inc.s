| FM SYNTH PLAYBACK SETUP: project-owned defaults, effective readers and descriptor.
| New lock state belongs to fmlock files; the engine's budget arithmetic is unchanged.
        .text
        .global po_fm_kind, po_setup_default, po_setup_patch, po_setup_edit
        .global po_read_voic, po_read_chrd
        .set PLAY_SETUP, 0x8ef60

| d2 track -> d0 FM boolean. Every other register preserved.
po_fm_kind:
        bsr     po_signed
        cmpi.l  #1,%d0
        seq     %d0
        andi.l  #1,%d0
        rts

| d2 track -> d0 VOIC, d1 CHRD, other registers preserved.
| The Part stores LOOP/SLIC in the FLEX SETUP column. Out-of-range VOIC is mono.
po_setup_default:
        lea     -8(%sp),%sp
        movem.l %d3/%a0,(%sp)
        moveq   #1,%d0
        moveq   #0,%d1
        cmpi.l  #8,%d2
        bcc     po_sd_out
        movea.l PART_PTR,%a0
        cmpa.l  #0x40000000,%a0
        bcs     po_sd_out
        cmpa.l  #0x48000000,%a0
        bcc     po_sd_out
        mvz.b   PART_IDX,%d3
        cmpi.l  #4,%d3
        bcc     po_sd_out
        mulu.w  #6322,%d3
        adda.l  %d3,%a0
        move.l  %d2,%d3
        mulu.w  #30,%d3
        adda.l  %d3,%a0
        adda.l  #PLAY_SETUP,%a0
        mvz.b   (%a0),%d0
        subq.l  #1,%d0
        cmpi.l  #3,%d0
        bls     po_sd_voice
        moveq   #0,%d0
po_sd_voice:
        addq.l  #1,%d0
        mvz.b   1(%a0),%d1
        andi.l  #127,%d1
po_sd_out:
        movem.l (%sp),%d3/%a0
        lea     8(%sp),%sp
        rts

| Effective VOIC -> d1 or CHRD -> d0, all other registers preserved.
| Both use the same step > scene > Part precedence at every reader.
po_read_voic:
        move.l  %d0,-(%sp)
        jsr     fl_effective:l
        move.l  %d0,%d1
        move.l  (%sp)+,%d0
        rts
po_read_chrd:
        move.l  %d1,-(%sp)
        jsr     fl_effective:l
        move.l  %d1,%d0
        move.l  (%sp)+,%d1
        rts

| a0 descriptor: replace only SETUP A/B. Other four boxes stay from stock.
po_setup_patch:
        lea     -12(%sp),%sp
        movem.l %d0/%a0-%a1,(%sp)
        movea.l %a0,%a1
        lea     po_voic(%pc),%a0
        move.l  (%a0),0x3a(%a1)
        move.w  4(%a0),0x3e(%a1)
        lea     po_chrd(%pc),%a0
        move.l  (%a0),0x40(%a1)
        move.w  4(%a0),0x44(%a1)
        lea     po_fmt_voic(%pc),%a0
        move.l  %a0,0xca+24(%a1)
        lea     po_fmt_chord(%pc),%a0
        move.l  %a0,0xca+28(%a1)
        lea     po_setup_knob(%pc),%a0
        move.l  %a0,0x12a+24(%a1)
        move.l  %a0,0x12a+28(%a1)
        moveq   #1,%d0
        move.l  %d0,0x6a+24(%a1)
        move.b  %d0,0x5e+6(%a1)
        moveq   #4,%d0
        move.l  %d0,0x9a+24(%a1)
        clr.l   0x6a+28(%a1)
        clr.b   0x5e+7(%a1)
        move.l  #128,%d0
        move.l  %d0,0x9a+28(%a1)
        move.l  0x18e(%a1),%d0
        andi.l  #0x00ffffff,%d0
        ori.l   #0x11000000,%d0
        move.l  %d0,0x18e(%a1)
        movea.l %a1,%a0
        jsr     fl_ui_patch:l
        movem.l (%sp),%d0/%a0-%a1
        lea     12(%sp),%sp
        rts

| (slot, detents, value): one raw increment per click. The setup editor has
| already applied pressed acceleration; remove it for these discrete controls.
po_setup_knob:
        move.l  4(%sp),%d0
        subi.l  #6,%d0
        cmpi.l  #1,%d0
        bls     po_sk_index
        move.l  4(%sp),%d0
po_sk_index:
        mulu.w  #24,%d0
        lea     0x46c7de2e,%a0
        move.l  8(%sp),%d1
        tst.l   (%a0,%d0.l)
        beq     po_sk_add
        moveq   #7,%d0
        divs.l  %d0,%d1
po_sk_add:
        move.l  12(%sp),%d0
        add.l   %d1,%d0
        rts

| Called at synth's existing SETUP edit site, after descriptor resolution.
| a5 descriptor, a3 control, d3 delta, d4 track. d0 handled, others preserved.
po_setup_edit:
        move.l  %a0,-(%sp)
        lea     po_pgdesc_buf(%pc),%a0
        cmpa.l  %a0,%a5
        movea.l (%sp)+,%a0
        bne     po_se_no
        cmpa.l  #2,%a3
        bcc     po_se_no
        jsr     fs_ui_edit:l
        tst.l   %d0
        bne     po_se_out
        jsr     fl_ui_edit:l
        tst.l   %d0
        bne     po_se_out
        lea     -8(%sp),%sp
        movem.l %d2/%d4,(%sp)
        move.l  %d4,%d2
        move.l  %a3,%d4
        jsr     fl_seq_release_control:l
        movem.l (%sp),%d2/%d4
        lea     8(%sp),%sp
po_se_no:
        moveq   #0,%d0
po_se_out:
        rts
