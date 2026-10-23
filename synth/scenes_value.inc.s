| FM SYNTH scene selection. Scalar controls switch at the crossfader midpoint.
| Scene values are resolved before the step-lock overlay; absent/disabled scene
| sides retain the Part's bytes. No stock scene or LFO slot is written here.
        .global fs_resolve,fs_effective

| d2 = track, d4 = control (0 VOIC, 1 CHRD) -> d0 = scene value or 255.
| Other registers preserved. The sounding track owns its bank and Part.
fs_resolve:
        lea     -32(%sp),%sp
        movem.l %d1-%d3/%d5-%d6/%a0-%a2,(%sp)
        cmpi.l  #8,%d2
        bcc     fs_rs_none
        cmpi.l  #2,%d4
        bcc     fs_rs_none
        move.l  %d2,%d3
        lea     0x8000182a,%a0
        mvz.b   (%a0,%d3.l),%d0
        cmpi.l  #16,%d0
        bcc     fs_rs_none
        mvz.b   8(%a0,%d3.l),%d1
        cmpi.l  #4,%d1
        bcc     fs_rs_none
        move.l  fl_ready_mask:l,%d5
        btst    %d0,%d5
        beq     fs_rs_none
        move.l  fl_blocked_mask:l,%d5
        btst    %d0,%d5
        bne     fs_rs_none
        move.l  #0x9b340,%d5
        mulu.l  %d0,%d5
        lea     0x400e21e0,%a1
        adda.l  %d5,%a1
        mvz.b   0x100b14ce,%d5
        cmp.l   %d0,%d5
        bne     fs_rs_part
        movea.l PART_PTR,%a1
        cmpa.l  #0x40000000,%a1
        bcs     fs_rs_none
        cmpa.l  #0x48000000,%a1
        bcc     fs_rs_none
fs_rs_part:
        move.l  #6322,%d5
        mulu.l  %d1,%d5
        adda.l  %d5,%a1
        adda.l  #0x8ed90,%a1
        lea     0x80003c60,%a0
        mvs.w   (%a0,%d3.l*4),%d5
        neg.l   %d5                     | stock A weight in Q15
        cmpi.l  #0x4000,%d5
        bhi     fs_rs_a                 | A side below midpoint; equality selects B
        tst.b   0x80000007
        bne     fs_rs_none
        addq.l  #1,%a1
        bra     fs_rs_selected
fs_rs_a:
        tst.b   0x80000006
        bne     fs_rs_none
fs_rs_selected:
        mvz.b   (%a1),%d2
        jsr     fl_scene_row:l
        mvz.b   (%a0,%d4.l),%d0
        bra     fs_rs_out
fs_rs_none:
        move.l  #255,%d0
fs_rs_out:
        movem.l (%sp),%d1-%d3/%d5-%d6/%a0-%a2
        lea     32(%sp),%sp
        rts

| d2 = track -> d0 VOIC, d1 CHRD, base plus scene. Step locks are overlaid
| by fl_effective. Preserve all registers except the two return values.
fs_effective:
        lea     -12(%sp),%sp
        movem.l %d4-%d6,(%sp)
        bsr     fs_play_default
        move.l  %d0,%d5
        move.l  %d1,%d6
        moveq   #0,%d4
        bsr     fs_resolve
        cmpi.l  #255,%d0
        beq     fs_ef_chord
        move.l  %d0,%d5
fs_ef_chord:
        moveq   #1,%d4
        bsr     fs_resolve
        cmpi.l  #255,%d0
        beq     fs_ef_clamp
        move.l  %d0,%d6
fs_ef_clamp:
        move.l  %d5,%d0
        subq.l  #1,%d0
        cmpi.l  #3,%d0
        bls     fs_ef_voice
        moveq   #1,%d5
fs_ef_voice:
        move.l  %d5,%d0
        move.l  %d6,%d1
        andi.l  #127,%d1
        movem.l (%sp),%d4-%d6
        lea     12(%sp),%sp
        rts

| The Part default for the sounding context. Before any track is published,
| fall back to the UI Part so stopped chromatic previews have a valid patch.
        .global fs_play_default
fs_play_default:
        lea     -20(%sp),%sp
        movem.l %d3-%d5/%a0-%a1,(%sp)
        cmpi.l  #8,%d2
        bcc     fs_pd_fallback
        lea     0x8000182a,%a0
        mvz.b   (%a0,%d2.l),%d3
        cmpi.l  #16,%d3
        bcc     fs_pd_fallback
        mvz.b   8(%a0,%d2.l),%d4
        cmpi.l  #4,%d4
        bcc     fs_pd_fallback
        move.l  #0x9b340,%d5
        mulu.l  %d3,%d5
        lea     0x400e21e0,%a1
        adda.l  %d5,%a1
        mvz.b   0x100b14ce,%d5
        cmp.l   %d3,%d5
        bne     fs_pd_part
        movea.l PART_PTR,%a1
        cmpa.l  #0x40000000,%a1
        bcs     fs_pd_fallback
        cmpa.l  #0x48000000,%a1
        bcc     fs_pd_fallback
fs_pd_part:
        move.l  #6322,%d5
        mulu.l  %d4,%d5
        adda.l  %d5,%a1
        moveq   #30,%d5
        mulu.l  %d2,%d5
        adda.l  %d5,%a1
        adda.l  #0x8ef60,%a1
        mvz.b   (%a1),%d0
        mvz.b   1(%a1),%d1
        subq.l  #1,%d0
        cmpi.l  #3,%d0
        bls     fs_pd_voice
        moveq   #0,%d0
fs_pd_voice:
        addq.l  #1,%d0
        andi.l  #127,%d1
        bra     fs_pd_out
fs_pd_fallback:
        jsr     po_setup_default:l
fs_pd_out:
        movem.l (%sp),%d3-%d5/%a0-%a1
        lea     20(%sp),%sp
        rts
