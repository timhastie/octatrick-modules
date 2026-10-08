| SYNTH MACHINE -- FM SYNTH in the track's machine list (2.10, 8 Oct 2026): the sixth
| row of the machine window (FUNC + SRC) and of SRC SETUP. GNU as, -mcpu=5475; a DRAM
| unit linked beside poly.s (modules/synth/manifest.py, Linked "fmmachine").
|
| Adapted from Modwerk's FM Synth module (repeat98/modwerk, sdk/octabam/modules/synth:
| machine.s and registration.c, commit 1c1d938; MIT, Copyright (c) 2026 Modwerk
| contributors -- the dedicated chooser, the Part validation and the sample-free
| transport; derived there from Modwerk's Analog BD chooser hooks). Their C helpers are
| written out here by hand; the stubs keep their hook sites and register contracts.
| Changed for this repository: the machine window's commit shares its site with
| po_machwin (poly.s: one detour at 0x40079816 does both jobs); the PLAYBACK page of a
| chosen track is resolved by page.s's pg_resolve (no second resolver detour); no
| refusal path (every track 1..8 may be FM SYNTH); the six-row name table is filled at
| run time from the stock one; a track that already plays the FM voice through a
| marker file keeps its patch when FM SYNTH is chosen over it.
|
| THE STORAGE. A chosen track is stored as FLEX (the machine byte 1, so every stock
| FLEX path -- the PLAYBACK lanes, locks, LFOs, scenes, the DSP voice -- stays valid)
| with the signature "F", "M", 1 in the first three bytes of the track's NEIGHBOR
| PLAYBACK column: the bank blob + part * 6322 + 0x8edbc + 30 * track, and the same
| offset in the battery-RAM shadow. NEIGHBOR has no sample and its six PLAYBACK bytes
| are never written for a FLEX track; the stock validator's NEIGHBOR range is 0..127,
| so "F" (70), "M" (77) and 1 survive a load. A Part is saved, copied, pasted and
| reloaded with its signature like any other Part byte. Choosing FM SYNTH on a track
| that does not play the FM voice yet seeds the FLEX PLAYBACK bytes with PTCH 0, RATO
| 1, INDX 32, FINE 0c, FDBK 0, DEC 40 and the FLEX SETUP bytes with 0 (LOOP, SLIC,
| LEN, RATE, TSTR, TSNS: OFF); choosing it again keeps the patch; choosing any other
| row clears the signature (the FLEX bytes keep the FM values, as a marker track's do
| when its marker is replaced).
|
| The engine's side is poly.s: po_is_synth (and the quantizer's qz_is_synth) answer
| yes for a signed track, po_fmstart starts its voice without a sample, po_fmsource
| hands its source to sy_render, sy_call writes the source header stock would have.

        .text
        .global fm_machine_name, fm_name_a, fm_src_names
        .global fm_setup_row, fm_chooser_row, fm_setup_open, fm_chooser_open
        .global fm_setup_edit6, fm_setup_draw6
        .global fm_main_commit, fm_src_commit, fm_src_commit2
        .global fm_tick, fm_validate

        .set    FM_ROW, 5                | the sixth row: FM SYNTH
        .set    FLEX, 1
        .set    PART_PTR, 0x46c82456     | the bank blob; the Part = blob + part index * 6322
        .set    PART_IDX, 0x100b14cf
        .set    PART_OFF, 0x8ed80        | the Part's own +0 (what the validator is handed)
        .set    PART_SHADOW, 0x1001614e  | + part * 6322 + a blob offset = that Part byte's shadow (poly.s)
        .set    MACH_OFF, 0x8eda2        | + track: the machine byte
        .set    FLEX_PB, 0x8edb0         | + 30 * track: the FLEX PLAYBACK bytes (PTCH STRT LEN RATE RTRG RTIM)
        .set    SETUP_GAP, 0x1b0         | ... their FLEX SETUP bytes this far on (blob + 0x8ef60 + 30 * track)
        .set    SIG_OFF, 0x8edbc         | + 30 * track: the NEIGHBOR PLAYBACK bytes, "FM", 1
        .set    CURVALS, 0x80000810      | the live lanes, 72 B a track: flat slots 0..5 = the PLAYBACK page
        .set    CV_STRIDE, 72
        .set    CV_SETUP, 32             | + lane: the PLAYBACK page's SETUP bytes (LOOP SLIC LEN RATE TSTR TSNS)
        .set    CV_WORDS, 0x80000a50     | + 64 * track: the lane's value words (byte << 8), PLAYBACK first
        .set    CV_SLEW, 0x80000db4      | + 32 * track: the words' slew counters (0 = take the lane's value)
        .set    SRC_CURSOR, 0x460d5c30   | SRC SETUP's machine row (the sample-list window's)
        .set    NAMES, 0x400a78c8        | the stock machine-name table, five pointers (STATIC .. PICKUP)
        .set    PB_TABLE, 0x400d5f38     | the machine -> PLAYBACK descriptor table (slot 5: a spare)
        .set    FLEX_DEF, 0x400d320c     | the FLEX descriptor's defaults: 6 PLAYBACK, then 6 SETUP bytes
        .set    FM_DESC, 0x400d24d0      | page.s's fm_descriptor: the pinned page cave's first routine
        .set    NAME_RET, 0x400334de     | fm_machine_name's way back
        .set    NAME_A_RET, 0x4003d722
        .set    SETUP_ROW_RET, 0x4003c986
        .set    CHOOSER_HIT, 0x400786ce  | the chooser's row-equals-machine branch ...
        .set    CHOOSER_MISS, 0x400786fc | ... and its other one
        .set    SETUP_OPEN_RET, 0x400585e6
        .set    CHOOSER_OPEN_RET, 0x40078890
        .set    EDIT6_RET, 0x4003a536
        .set    DRAW6_RET, 0x4003cda0
        .set    SRC_COMMIT_RET, 0x4005a61c
        .set    SRC_COMMIT2_RET, 0x4005a856
        .set    TICK_A, 0x4005213c       | the UI tick's two calls fm_tick replays (the first is PC-relative
        .set    TICK_B, 0x4007e940       | in stock, so it is replayed by its absolute address)
        .set    TICK_RET, 0x40052228
        .set    VALIDATE_BODY, 0x40002320 | the Part validator after its prologue

| ---- fm_choose: d1 = the chosen row, d2 = the track (the current Part) -> d1 = the
| machine byte to store: row 5 -> FLEX, with the signature written into the Part and
| its shadow (and the twelve FLEX bytes seeded first unless the track already plays
| the FM voice: po_is_synth -- signed, or FLEX with a marker slot -- answered before
| the machine byte is stored); any other row unchanged, the signature cleared.
| Preserves every other register.
| The seed reaches the engine the way stock's reload of a track from its Part does
| (0x40001f18, and the frame builder's refresh at 0x4000c0b4 when a track's first trig
| comes from another bank or Part): the live lane's PLAYBACK bytes, its SETUP bytes
| (lane + 32), the PLAYBACK value words (CV_WORDS + 64 * track, byte << 8: what the
| copier hands the DSP and sy_render every frame) and the two slew counters of those
| bytes cleared. The frame builder refreshes them from the Part only at such a trig,
| so a track that had played a sample in this Part kept that sample's words and SETUP
| (b68 P5: RATE 127 = FINE +63c, STRT 0 = RATO 0.25, two octaves down: 67.8 Hz for C4).
fm_choose:
        lea     -32(%sp),%sp
        movem.l %d0/%d3/%a0-%a5,(%sp)
        movea.l PART_PTR,%a0
        mvz.b   PART_IDX,%d0
        move.l  #6322,%d3
        muls.l  %d3,%d0                  | part * 6322
        adda.l  %d0,%a0                  | the Part
        lea     PART_SHADOW,%a1
        adda.l  %d0,%a1                  | its shadow
        move.l  %d2,%d0
        mulu.w  #30,%d0                  | track * 30
        adda.l  %d0,%a0
        adda.l  %d0,%a1
        movea.l %a0,%a2
        adda.l  #SIG_OFF,%a2             | a2 = the signature in the Part
        movea.l %a1,%a3
        adda.l  #SIG_OFF,%a3             | a3 = ... in the shadow
        cmpi.l  #FM_ROW,%d1
        bne     fm_ch_clear
        jsr     po_is_synth              | (d2) the FM voice already: its patch is the user's
        bne     fm_ch_sign
        lea     FLEX_PB-SIG_OFF(%a2),%a0 | the FLEX PLAYBACK bytes in the Part (12 below the signature)
        lea     FLEX_PB-SIG_OFF(%a3),%a1 | ... in the shadow
        move.l  %d2,%d0
        mulu.w  #CV_STRIDE,%d0
        addi.l  #CURVALS,%d0
        movea.l %d0,%a4                  | the track's live lane, flat slots 0..5
        lea     fm_defaults(%pc),%a5
        moveq   #6,%d3
fm_ch_seed:
        move.b  (%a5)+,%d0
        move.b  %d0,(%a0)                | PLAYBACK k: the Part,
        move.b  %d0,(%a1)                | its shadow
        move.b  %d0,(%a4)+               | and the live lane (the page shows it at once)
        clr.b   SETUP_GAP(%a0)           | SETUP k: 0
        clr.b   SETUP_GAP(%a1)
        clr.b   CV_SETUP-1(%a4)          | ... and the lane's SETUP k
        addq.l  #1,%a0
        addq.l  #1,%a1
        subq.l  #1,%d3
        bne     fm_ch_seed
        move.l  %d2,%d0
        lsl.l   #6,%d0
        movea.l %d0,%a0
        adda.l  #CV_WORDS,%a0            | the track's PLAYBACK value words
        lea     fm_defaults(%pc),%a5
        moveq   #6,%d3
fm_ch_word:
        mvz.b   (%a5)+,%d0
        lsl.l   #8,%d0
        move.w  %d0,(%a0)+               | PLAYBACK k: byte << 8
        subq.l  #1,%d3
        bne     fm_ch_word
        move.l  %d2,%d0
        lsl.l   #5,%d0
        movea.l %d0,%a0
        adda.l  #CV_SLEW,%a0             | the track's slew counters (a long per four lane bytes)
        clr.l   (%a0)+                   | lane bytes 0..3: 0 = the next frame takes the lane's values
        clr.l   (%a0)                    | lane bytes 4..7
fm_ch_sign:
        move.b  #'F',(%a2)
        move.b  #'M',1(%a2)
        move.b  #1,2(%a2)
        move.b  #'F',(%a3)
        move.b  #'M',1(%a3)
        move.b  #1,2(%a3)
        moveq   #FLEX,%d1                | stored as FLEX
        bra     fm_ch_out
fm_ch_clear:
        movea.l %a2,%a0
        bsr     fm_unsign
        movea.l %a3,%a0
        bsr     fm_unsign
fm_ch_out:
        movem.l (%sp),%d0/%d3/%a0-%a5
        lea     32(%sp),%sp
        rts
| fm_unsign: a0 = a signature's place -> cleared when it holds "FM", 1 (d0 clobbered)
fm_unsign:
        mvz.w   (%a0),%d0
        cmpi.l  #0x464d,%d0
        bne     fm_us_out
        mvz.b   2(%a0),%d0
        subq.l  #1,%d0
        bne     fm_us_out
        clr.b   (%a0)
        clr.b   1(%a0)
        clr.b   2(%a0)
fm_us_out:
        rts

| ---- 0x40079816 (jmp, 8 B): the machine window's machine-byte write (FUNC + SRC, YES).
| a1 = the bank blob, d0 = part * 6322, d1 = the track, d2 = the part index, d4 = the
| chosen row, a0 = blob + part * 6322 + track. The row becomes the machine byte to store
| (fm_choose), then po_machwin (poly.s) replays the displaced `addal #0x8eda2,%a0; mvsb
| %a0@,%d3` with its FINE rule and stock stores d4 into the Part and its shadow.
fm_main_commit:
        move.l  %d2,-(%sp)
        move.l  %d1,-(%sp)
        move.l  %d1,%d2                  | the track
        move.l  %d4,%d1                  | the row
        bsr     fm_choose
        move.l  %d1,%d4                  | the machine to store
        move.l  (%sp)+,%d1
        move.l  (%sp)+,%d2
        jmp     po_machwin

| ---- 0x4005a616 / 0x4005a850 (jmp, 6 B each): SRC SETUP's two machine-byte writes:
| displaced `movel 0x460d5c30,%d1` (the chosen row), then stock stores d1 at a0 (the
| machine byte) and into the shadow. d2 = the track. The second site follows
| po_machlist's detour (0x4005a848, poly.s), which returns to it.
fm_src_commit:
        move.l  SRC_CURSOR,%d1           | displaced
        bsr     fm_choose
        jmp     SRC_COMMIT_RET
fm_src_commit2:
        move.l  SRC_CURSOR,%d1           | displaced
        bsr     fm_choose
        jmp     SRC_COMMIT2_RET

| ---- fm_type: d0 = a machine read through a0 = a pointer to it -> d0 = 5 when a0 is
| the current Part's machine byte of a track whose FM SYNTH is chosen (FLEX, signed),
| else d0 unchanged. Preserves every other register (registration.c's fm_type).
fm_type:
        cmpi.l  #FLEX,%d0
        bne     fm_ty_rts
        lea     -16(%sp),%sp
        movem.l %d1-%d2/%a0-%a1,(%sp)
        movea.l PART_PTR,%a1
        mvz.b   PART_IDX,%d1
        move.l  #6322,%d2
        muls.l  %d2,%d1
        adda.l  %d1,%a1                  | the Part
        move.l  %a0,%d2
        sub.l   %a1,%d2
        subi.l  #MACH_OFF,%d2            | the track, if a0 is one of its machine bytes
        moveq   #8,%d1
        cmp.l   %d1,%d2
        bhs     fm_ty_out                | (unsigned) another byte: unchanged
        movea.l %a1,%a0
        move.l  %d2,%d0
        jsr     po_sig                   | FLEX and "FM", 1?
        beq     fm_ty_flex
        moveq   #FM_ROW,%d0
        bra     fm_ty_out
fm_ty_flex:
        moveq   #FLEX,%d0
fm_ty_out:
        movem.l (%sp),%d1-%d2/%a0-%a1
        lea     16(%sp),%sp
fm_ty_rts:
        rts

| ---- 0x400334d8 (jmp, 6 B): the machine-name formatter name(row): row 5 -> "FM SYNTH";
| any other row replays the displaced `movel %d2,%sp@-; movel %sp@(8),%d1`.
fm_machine_name:
        moveq   #FM_ROW,%d0
        cmp.l   4(%sp),%d0
        beq     fm_mn_fm
        move.l  %d2,-(%sp)               | displaced
        move.l  8(%sp),%d1               | displaced
        jmp     NAME_RET
fm_mn_fm:
        lea     fm_name(%pc),%a0
        move.l  %a0,%d0
        rts

| ---- 0x4003d718 (jmp, 6 B): a track's machine name, d0 = its machine (0..4 checked),
| a0 = its machine byte; displaced `lea 0x400a78c8,%a0`, then d1 := the name (the
| instruction after, `movel %a0@(0,%d0:l:4),%d1`, is done here: rejoins after it).
fm_name_a:
        bsr     fm_type                  | FLEX + signed -> 5
        lea     NAMES,%a0                | displaced
        cmpi.l  #FM_ROW,%d0
        beq     fm_na_fm
        move.l  (%a0,%d0.l*4),%d1
        jmp     NAME_A_RET
fm_na_fm:
        lea     fm_name(%pc),%a0
        move.l  %a0,%d1
        lea     NAMES,%a0
        jmp     NAME_A_RET

| ---- 0x4003c980 (jmp, 6 B): SRC SETUP's row highlight: displaced `mvsb %a0@,%d0; lea
| %sp@(24),%sp` (a0 = the track's machine byte); a signed track's row is 5.
fm_setup_row:
        mvs.b   (%a0),%d0
        lea     24(%sp),%sp
        bsr     fm_type
        jmp     SETUP_ROW_RET

| ---- 0x400786c8 (jmp, 6 B): the machine window's row highlight: displaced `mvsb
| %a0@,%d0; cmpl %d0,%d2; bnes 0x400786fc` (d2 = the row drawn).
fm_chooser_row:
        mvs.b   (%a0),%d0
        bsr     fm_type
        cmp.l   %d0,%d2
        bne     fm_cr_miss
        jmp     CHOOSER_HIT
fm_cr_miss:
        jmp     CHOOSER_MISS

| ---- 0x400585dc (jmp, 10 B): SRC SETUP opens on the track's row: displaced `moveb
| %a0@,%d3; mvsb %d3,%d4; pea 0x400bb704`; d4 indexes the PLAYBACK descriptor table
| (slot 5: the FM SYNTH page, fm_tick), d3 is the row the window starts on.
fm_setup_open:
        move.b  (%a0),%d3
        move.l  %d0,-(%sp)
        mvs.b   %d3,%d0
        bsr     fm_type
        move.l  %d0,%d3
        move.l  (%sp)+,%d0
        mvs.b   %d3,%d4
        pea     (0x400bb704).l           | displaced
        jmp     SETUP_OPEN_RET

| ---- 0x40078886 (jmp, 10 B): the machine window opens on the track's row: displaced
| `mvsb %a0@,%d0; movel %d0,%sp@-; pea 0x460e7386`.
fm_chooser_open:
        mvs.b   (%a0),%d0
        bsr     fm_type
        move.l  %d0,-(%sp)
        pea     (0x460e7386).l           | displaced
        jmp     CHOOSER_OPEN_RET

| ---- 0x4003a52e / 0x4003cd98 (jmp, 8 B each): SRC SETUP's editor and drawer address the
| row's Part bytes at row * 6: displaced `movel %dN,%d0; lsll #3,%d0; addl %dN,%dN; subl
| %dN,%d0` (d2 / d6, the row; d0 / d7 := row * 6). Row 5 addresses FLEX's.
fm_setup_edit6:
        cmpi.l  #FM_ROW,%d2
        bne     fm_e6
        moveq   #FLEX,%d2
fm_e6:
        move.l  %d2,%d0
        lsl.l   #3,%d0
        add.l   %d2,%d2
        sub.l   %d2,%d0
        jmp     EDIT6_RET
fm_setup_draw6:
        cmpi.l  #FM_ROW,%d6
        bne     fm_d6
        moveq   #FLEX,%d6
fm_d6:
        move.l  %d6,%d7
        lsl.l   #3,%d7
        add.l   %d6,%d6
        sub.l   %d6,%d7
        jmp     DRAW6_RET

| ---- 0x4005221e (jmp, 10 B): the UI tick: displaced `jsr 0x4005213c; jsr 0x4007e940`,
| replayed; then SRC SETUP's six-row name table is filled from the stock one and the
| PLAYBACK descriptor table's spare slot 5 gets the FM SYNTH page (page.s, built on
| first use), so the SRC SETUP window has a page for row 5.
fm_tick:
        jsr     TICK_A                   | displaced
        jsr     TICK_B                   | displaced
        lea     NAMES,%a0
        lea     fm_src_names(%pc),%a1
        moveq   #5,%d0
fm_tk_copy:
        move.l  (%a0)+,(%a1)+
        subq.l  #1,%d0
        bne     fm_tk_copy
        lea     fm_name(%pc),%a0
        move.l  %a0,(%a1)                | row 5
        jsr     FM_DESC                  | d0 = the FM SYNTH page (d0/d1/a0/a1 clobbered)
        move.l  %d0,PB_TABLE+4*FM_ROW
        jmp     TICK_RET

| ---- 0x40002318 (jmp, 8 B): the Part validator (4(sp) = the Part's +0), entered before
| its prologue. The stock validator clamps every column's PLAYBACK bytes into its
| descriptor's ranges -- FLEX's PTCH into 4..124, where FM SYNTH's PTCH is 0..127
| (-64..+63 semitones) -- and the SETUP bytes into theirs. For each signed track the
| twelve FLEX bytes are swapped for the stock FLEX defaults (read from the descriptor),
| the stock validator runs, and the FM bytes are put back. d0 = the stock result.
fm_validate:
        lea     -116(%sp),%sp            | 96 B: 8 tracks x 12 saved bytes; 20 B: d2-d4/a2-a3
        movem.l %d2-%d4/%a2-%a3,96(%sp)
        movea.l 120(%sp),%a2
        suba.l  #PART_OFF,%a2            | blob-relative: + MACH_OFF / SIG_OFF / FLEX_PB
        moveq   #0,%d3                   | the signed tracks
        moveq   #0,%d2
fm_vd_save:
        movea.l %a2,%a0
        move.l  %d2,%d0
        jsr     po_sig
        beq     fm_vd_snext
        bset    %d2,%d3
        bsr     fm_vd_ptrs               | a0 = its FLEX bytes, a1 = its save area, a3 = the defaults
        moveq   #6,%d4
fm_vd_s1:
        move.b  (%a0),(%a1)
        move.b  SETUP_GAP(%a0),6(%a1)
        move.b  (%a3),(%a0)
        move.b  6(%a3),SETUP_GAP(%a0)
        addq.l  #1,%a0
        addq.l  #1,%a1
        addq.l  #1,%a3
        subq.l  #1,%d4
        bne     fm_vd_s1
fm_vd_snext:
        addq.l  #1,%d2
        moveq   #8,%d0
        cmp.l   %d0,%d2
        bne     fm_vd_save
        move.l  120(%sp),-(%sp)
        bsr     fm_stock_validate
        addq.l  #4,%sp
        moveq   #0,%d2
fm_vd_rest:
        btst    %d2,%d3
        beq     fm_vd_rnext
        move.l  %d0,-(%sp)
        bsr     fm_vd_ptrs4              | (the stack is 4 deeper here)
        move.l  (%sp)+,%d0
        moveq   #6,%d4
fm_vd_r1:
        move.b  (%a1),(%a0)
        move.b  6(%a1),SETUP_GAP(%a0)
        addq.l  #1,%a0
        addq.l  #1,%a1
        subq.l  #1,%d4
        bne     fm_vd_r1
fm_vd_rnext:
        addq.l  #1,%d2
        moveq   #8,%d4
        cmp.l   %d4,%d2
        bne     fm_vd_rest
        movem.l 96(%sp),%d2-%d4/%a2-%a3
        lea     116(%sp),%sp
        rts
| fm_vd_ptrs: d2 = the track -> a0 = blob-relative Part a2 + FLEX_PB + 30 * track, a1 =
| the caller's save area + 12 * track, a3 = the stock FLEX defaults (d0 clobbered).
fm_vd_ptrs:
        lea     4(%sp),%a1               | the caller's frame: its save area at its 0(sp)
        bra     fm_vd_p
fm_vd_ptrs4:
        lea     8(%sp),%a1
fm_vd_p:
        move.l  %d2,%d0
        mulu.w  #12,%d0
        adda.l  %d0,%a1
        move.l  %d2,%d0
        mulu.w  #30,%d0
        movea.l %a2,%a0
        adda.l  %d0,%a0
        adda.l  #FLEX_PB,%a0
        lea     FLEX_DEF,%a3
        rts
fm_stock_validate:
        lea     -96(%sp),%sp             | displaced
        movem.l %d2-%d7/%a2-%fp,(%sp)    | displaced
        jmp     VALIDATE_BODY

fm_defaults:
        .byte   64, 12, 32, 64, 0, 40    | PTCH 0, RATO 1, INDX 32, FINE 0c, FDBK 0, DEC 40 (Modwerk's)
fm_name:
        .asciz  "FM SYNTH"
        .balign 4
| SRC SETUP's name table (the lea at 0x4003c928 points here): the stock five, copied
| by fm_tick, and "FM SYNTH".
fm_src_names:
        .long   0, 0, 0, 0, 0, 0
