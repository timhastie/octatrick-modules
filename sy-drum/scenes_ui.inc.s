| ==== SETUP SCENES: the UI (2.18; the development line's b59 scene UI, for SY DRUM's page) ======
| Hold [SCENE A] / [SCENE B] on SY DRUM's PLAYBACK SETUP page and turn encoder A-D: the scene
| selected on that side stores a value for that control (scenes_store.inc.s). Stock's own
| scene editors reject an open setup window, so the four stock scene handlers are entered
| through detours that take the gesture first: SYNTH MACHINE's (synth/scenes_ui.inc.s) hold
| the sites and hand a gesture that is not FM SYNTH's to sc_ui_*_hook here; the setup window's
| own knob callback (sydrum.s sd_setup_edit) asks sc_ui_edit too. The stock press gesture:
| pressing an encoder assigns an unassigned control at its Part default; press and release
| with no turn removes an assignment. Neither the Part default, a step lock nor the stock
| scene block is written. A held trig wins (the turn is then a step lock).
        .global sc_ui_edit, sc_ui_value, sc_ui_entry
        .global sc_ui_knob_a_hook, sc_ui_knob_b_hook, sc_ui_key_a_hook, sc_ui_key_b_hook

| d0 = 1 iff the visible PLAYBACK SETUP is a SY DRUM track's and a scene is held with no
| trig held (a held trig keeps the turn for the step locks). Every other register kept.
sc_ui_context:
        lea     -12(%sp),%sp
        movem.l %d1-%d2/%a0,(%sp)
        move.l  0x400bcd14,%d0
        cmpi.l  #0x400bb7c8,%d0          | the setup window is the active one
        bne     sc_uc_no
        tst.l   0x400bb7d0
        beq     sc_uc_no
        tst.l   0x80000012
        bne     sc_uc_no
        tst.l   0x460d5db4
        bne     sc_uc_no
        tst.l   0x460d169c               | 1 scene A held / 2 scene B
        beq     sc_uc_no
        tst.w   0x460d174a
        bne     sc_uc_no
        mvz.b   0x100b14ce,%d0
        cmpi.l  #15,%d0
        bhi     sc_uc_no
        mvz.b   0x100b14cc,%d2
        cmpi.l  #7,%d2
        bhi     sc_uc_no
        mvz.b   PART_IDX,%d0
        cmpi.l  #3,%d0
        bhi     sc_uc_no
        move.l  PART_PTR,%d0
        cmpi.l  #0x40000000,%d0
        bcs     sc_uc_no
        cmpi.l  #0x48000000,%d0
        bcc     sc_uc_no
        jsr     sd_kind:l                | sydrum.s: 2 = SY DRUM on this track of the current Part
        beq     sc_uc_no
        moveq   #1,%d0
        bra     sc_uc_out
sc_uc_no:
        moveq   #0,%d0
sc_uc_out:
        movem.l (%sp),%d1-%d2/%a0
        lea     12(%sp),%sp
        rts

| d0 = 1 iff the UI's bank is ready for scene reads and edits. Every other register kept.
sc_ui_readable:
        move.l  %d1,-(%sp)
        mvz.b   0x100b14ce,%d0
        cmpi.l  #16,%d0
        bcc     sc_ur_no
        move.l  sc_ready_mask:l,%d1
        btst    %d0,%d1
        beq     sc_ur_no
        move.l  sc_blocked_mask:l,%d1
        btst    %d0,%d1
        bne     sc_ur_no
        moveq   #1,%d0
        bra     sc_ur_out
sc_ur_no:
        moveq   #0,%d0
sc_ur_out:
        move.l  (%sp)+,%d1
        rts

| -> d0 bank, d1 part, d2 the held side's selected scene, d3 track (the UI's), a0 =
| the row. Call after sc_ui_context. A selection out of range gives the FF row.
sc_ui_row:
        mvz.b   PART_IDX,%d1
        move.l  #6322,%d0
        mulu.l  %d1,%d0
        movea.l PART_PTR,%a0
        adda.l  %d0,%a0
        adda.l  #0x8ed90,%a0
        moveq   #2,%d0
        cmp.l   0x460d169c,%d0
        bne     sc_ur_a
        addq.l  #1,%a0                   | scene B's selection
sc_ur_a:
        mvz.b   (%a0),%d2
        mvz.b   0x100b14ce,%d0
        mvz.b   0x100b14cc,%d3
        jmp     sc_row:l

| a3 = control, d3 = the stock pressed-accelerated delta. d0 = 1 when a scene owns the
| gesture (the caller must then not store the Part default). Other registers kept.
sc_ui_edit:
        lea     -52(%sp),%sp
        movem.l %d1-%d7/%a0-%a5,(%sp)
        bsr     sc_ui_context
        tst.l   %d0
        beq     sc_ue_out
        cmpa.l  #4,%a3
        bcc     sc_ue_handled            | the hidden E / F
        bsr     sc_ui_readable
        tst.l   %d0
        beq     sc_ue_handled            | a blocked bank still consumes the gesture
        move.l  %a3,%d4
        move.l  %d3,-(%sp)
        move.l  %d4,-(%sp)
        jsr     0x4003249c               | the stock encoder accumulator (one step a threshold, as the Part value's edit)
        addq.l  #8,%sp
        movea.l %d0,%a4
        moveq   #1,%d0
        move.l  %d0,0x460d1698           | turned: the release must not remove it
        bsr     sc_ui_row
        mvz.b   (%a0,%d4.l),%d5
        cmpi.l  #255,%d5
        bne     sc_ue_have
        jsr     sl_ui_default:l          | not assigned yet: start from the Part default
sc_ue_have:
        add.l   %a4,%d5
        bpl     sc_ue_pos
        moveq   #0,%d5
sc_ue_pos:
        jsr     sl_ui_max:l
        mvz.b   (%a0,%d4.l),%d6
        cmp.l   %d6,%d5
        bls     sc_ue_write
        move.l  %d6,%d5
sc_ue_write:
        jsr     sc_write:l
        cmpi.l  #1,%d0
        bne     sc_ue_handled
        bsr     sc_ui_changed
sc_ue_handled:
        moveq   #2,%d0
        move.b  %d0,sc_ui_entry:l        | (diagnostic: 2 = the setup window's callback, 1 = a scene handler detour)
        moveq   #1,%d0
sc_ue_out:
        movem.l (%sp),%d1-%d7/%a0-%a5
        lea     52(%sp),%sp
        rts

| The marks stock's scene editors leave (0x40053498): the Part is dirty (bank + 0x95048
| and 0x100b145e, bit = part), the bank and the project changed, the edited side.
sc_ui_changed:
        lea     -16(%sp),%sp
        movem.l %d0-%d1/%a0-%a1,(%sp)
        mvz.b   PART_IDX,%d1
        moveq   #1,%d0
        lsl.l   %d1,%d0
        movea.l PART_PTR,%a0
        adda.l  #0x95048,%a0
        mvz.b   (%a0),%d1
        or.l    %d0,%d1
        move.b  %d1,(%a0)
        mvz.b   0x100b145e,%d1
        or.l    %d0,%d1
        move.b  %d1,0x100b145e
        movea.l PART_PTR,%a0
        adda.l  #0x9b332,%a0
        moveq   #1,%d0
        move.l  %d0,(%a0)
        move.l  %d0,0x100f8598
        jsr     0x40027e00
        move.l  0x460d169c,%d0
        move.l  %d0,0x460d1694
        movem.l (%sp),%d0-%d1/%a0-%a1
        lea     16(%sp),%sp
        rts

| d4 = control -> d0 = the held scene's value for it on the visible setup page, or -1
| (no scene held / not assigned / bank not ready). Other registers kept. The widget's question.
sc_ui_value:
        lea     -20(%sp),%sp
        movem.l %d1-%d3/%a0-%a1,(%sp)
        cmpi.l  #3,%d4
        bhi     sc_uv_no
        bsr     sc_ui_context
        tst.l   %d0
        beq     sc_uv_no
        bsr     sc_ui_readable
        tst.l   %d0
        beq     sc_uv_no
        bsr     sc_ui_row
        mvz.b   (%a0,%d4.l),%d0
        cmpi.l  #255,%d0
        bne     sc_uv_out
sc_uv_no:
        moveq   #-1,%d0
sc_uv_out:
        movem.l (%sp),%d1-%d3/%a0-%a1
        lea     20(%sp),%sp
        rts

| The four stock scene handlers: SYNTH MACHINE's detours (synth/scenes_ui.inc.s) come here when
| the gesture is not FM SYNTH's; each replays the instructions its stock site displaced. The
| held side is 0x460d169c, whichever function stock entered.
sc_ui_knob_a_hook:
        bsr     sc_ui_knob
        tst.l   %d0
        bne     sc_uh_done
        lea     -36(%sp),%sp
        movem.l %d2-%d7/%a2-%a4,(%sp)
        jmp     0x400534a0
sc_ui_knob_b_hook:
        bsr     sc_ui_knob
        tst.l   %d0
        bne     sc_uh_done
        lea     -32(%sp),%sp
        movem.l %d2-%d7/%a2-%a3,(%sp)
        jmp     0x40052ea0
sc_ui_key_a_hook:
        bsr     sc_ui_key
        tst.l   %d0
        bne     sc_uh_done
        lea     -40(%sp),%sp
        movem.l %d2-%d7/%a2-%a5,(%sp)
        jmp     0x40054364
sc_ui_key_b_hook:
        bsr     sc_ui_key
        tst.l   %d0
        bne     sc_uh_done
        lea     -44(%sp),%sp
        movem.l %d2-%d7/%a2-%a6,(%sp)
        jmp     0x40053a70
sc_uh_done:
        rts

| (slot, raw delta) at 8 / 12(sp) of the hook's caller frame. d0 = 1 handled.
sc_ui_knob:
        lea     -56(%sp),%sp
        movem.l %d1-%d7/%a0-%a6,(%sp)
        bsr     sc_ui_context
        tst.l   %d0
        beq     sc_uk_out
        moveq   #0,%d0
        movea.l 64(%sp),%a3
        cmpa.l  #6,%a3
        bcc     sc_uk_out                | not an encoder A-F: stock (which rejects it here)
        move.l  68(%sp),%d3
        move.l  %a3,%d0
        moveq   #24,%d1
        mulu.l  %d1,%d0
        lea     0x46c7de2e,%a0           | encoder A's pressed flag + control * 24
        tst.l   (%a0,%d0.l)
        beq     sc_uk_edit
        move.l  %d3,%d0
        lsl.l   #3,%d0
        sub.l   %d3,%d0
        move.l  %d0,%d3                  | pressed: x 7, as the held-trig knob hook
sc_uk_edit:
        bsr     sc_ui_edit
        movea.l 0x400bb7f4,%a0           | the setup window's redraw
        jsr     (%a0)
        moveq   #1,%d0
        move.b  %d0,sc_ui_entry:l
sc_uk_out:
        movem.l (%sp),%d1-%d7/%a0-%a6
        lea     56(%sp),%sp
        rts

| (key 0x38.., event: nonzero = press) at 8 / 12(sp) of the hook's caller frame.
sc_ui_key:
        lea     -56(%sp),%sp
        movem.l %d1-%d7/%a0-%a6,(%sp)
        move.l  64(%sp),%d4
        subi.l  #0x38,%d4
        cmpi.l  #5,%d4
        bhi     sc_ky_no
        bsr     sc_ui_context
        tst.l   %d0
        beq     sc_ky_no
        cmpi.l  #4,%d4
        bcc     sc_ky_handled
        bsr     sc_ui_readable
        tst.l   %d0
        beq     sc_ky_handled
        bsr     sc_ui_row
        mvz.b   (%a0,%d4.l),%d6
        tst.l   68(%sp)
        beq     sc_ky_release
        cmpi.l  #255,%d6
        beq     sc_ky_assign
        clr.l   0x460d1698               | press on an assigned control: a release with no turn removes it
        bra     sc_ky_handled
sc_ky_assign:
        jsr     sl_ui_default:l          | press on an unassigned control: assign at the Part default
        moveq   #1,%d6
        move.l  %d6,0x460d1698
        bra     sc_ky_write
sc_ky_release:
        tst.l   0x460d1698
        bne     sc_ky_handled
        cmpi.l  #255,%d6
        beq     sc_ky_handled
        move.l  #255,%d5
sc_ky_write:
        jsr     sc_write:l
        cmpi.l  #1,%d0
        bne     sc_ky_handled
        bsr     sc_ui_changed
        movea.l 0x400bb7f4,%a0
        jsr     (%a0)
sc_ky_handled:
        moveq   #1,%d0
        bra     sc_ky_out
sc_ky_no:
        moveq   #0,%d0
sc_ky_out:
        movem.l (%sp),%d1-%d7/%a0-%a6
        lea     56(%sp),%sp
        rts
