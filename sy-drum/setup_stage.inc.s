| ==== THE SETUP STAGE: the four EFFECTIVE PLAYBACK SETUP bytes of a SY DRUM track ======
| (the development line's setup_stage, 8 Oct 2026, for its SY kind; 2.18 adds its scene and
| LFO stages, in FM SYNTH's VOIC / CHRD order: step lock, else scene, else Part, then LFO):
|
|   base (the Part default: the live lane's setup bytes LSPD LDEP WAVE S&H)
|     -> ss_scene_stage: the crossfader's morph of the selected scenes A / B
|        (scenes_store.inc.s), in place of the Part value where a scene is assigned
|     -> the step lock (the dedicated lock table: sl_seq_active[t], 255 = none)
|     -> ss_lfo_stage: the offsets of the stock LFOs whose destination is one of the four
|        controls (PMTR 30..33; synth/lfo_destinations.inc.s routes them to its words)
|     -> ss_commit: clamp to SY DRUM's maxima (LSPD 127, LDEP 127, WAVE 3, S&H 1),
|        publish ss_eff[t], hand the engine its copy (sy1_mod_params[t])
|
| WHEN. ss_stage(d2 = track) is the tail of sl_seq_refresh_track (locks_seq.inc.s) for a
| SY DRUM track (ss_kind[t] 2): once a frame for every track from sd_tick (sl_seq_tick;
| the frame builder's LFO pass), and once more in the frame builder at sl_seq_publish
| (0x4000c62e) for a track whose accepted event is published, before that frame's START
| dispatch -- so a step's lock is the effective value its own START reads. A track that is
| not SY DRUM (ss_kind[t] 0) is not staged: sy1_setup_tick's Part values stand.
|
| THE ARRAYS (8 tracks x 4 bytes, control A..D at +0..+3, raw 0..127):
|   ss_kind[t]  byte: 0 not SY DRUM / 2 SY DRUM (the development line's numbering: 1 is its
|               FM kind) -- written by sl_seq_refresh_track.
|   ss_base[t]  the Part default as the live lane holds it (0x80000830 + 72 t: the stock UI
|               and Part loader keep it equal to the Part's setup bytes).
|   ss_eff[t]   the effective bytes, clamped: what the engine reads (its copy).
        .text
        .global ss_stage, ss_commit, ss_kind, ss_base, ss_eff

| d2 = a SY DRUM track. Clobbers d0, d1, d3, a0-a2.
ss_stage:
        move.l  %d2,%d0
        moveq   #72,%d1
        mulu.l  %d1,%d0
        lea     0x80000830,%a0
        adda.l  %d0,%a0                  | the live lane's six setup bytes
        move.l  (%a0),%d0                | BASE: A..D
        lea     ss_base:l,%a1
        move.l  %d0,(%a1,%d2.l*4)
        lea     ss_pre:l,%a1
        lea     (%a1,%d2.l*4),%a1
        move.l  %d0,(%a1)
        jsr     ss_scene_stage:l         | SCENE: the morph replaces the Part value (a1, d2 kept)
        move.l  %d2,%d0                  | the active entry is an SL_ROW (16-byte) row
        lsl.l   #4,%d0
        lea     sl_seq_active:l,%a0      | LOCK: the accepted event's dedicated row (255 = no lock)
        adda.l  %d0,%a0
        move.l  (%a0),%d0
        addq.l  #1,%d0
        beq     ss_st_lfo                | 0xffffffff: no lock on any control
        moveq   #3,%d1
ss_st_lock:
        mvz.b   (%a0,%d1.l),%d0
        cmpi.l  #255,%d0
        beq     ss_st_lock1
        move.b  %d0,(%a1,%d1.l)          | a step lock wins over the scene
ss_st_lock1:
        subq.l  #1,%d1
        bpl     ss_st_lock
ss_st_lfo:
        bsr     ss_lfo_stage             | LFO: a1 = ss_pre[t], or the modulated row (ss_lfo_row[t])
                                         | (falls into the commit)
| ss_commit: d2 = track, a1 = four bytes A..D -> ss_eff[t] (clamped to SY DRUM's maxima)
| and the engine's copy. Clobbers d0, d1, d3, a0, a2.
ss_commit:
        lea     ss_kind:l,%a2
        mvz.b   (%a2,%d2.l),%d3
        cmpi.l  #2,%d3
        bne     ss_cm_out
        lea     ss_eff:l,%a0
        lea     (%a0,%d2.l*4),%a0
        move.l  (%a1),%d0
        move.l  #0x8080fcfe,%d1          | the bits no legal row has (above 127 127 3 1)
        and.l   %d0,%d1
        bne     ss_cm_clamp
        move.l  %d0,(%a0)                | all four within their maxima (the usual case): one store
        bra     ss_cm_engine
ss_cm_clamp:
        lea     ss_max:l,%a2             | the four maxima
        moveq   #3,%d1
ss_cm_byte:
        mvz.b   (%a1,%d1.l),%d0
        mvz.b   (%a2,%d1.l),%d3
        cmp.l   %d3,%d0
        bls     ss_cm_store
        move.l  %d3,%d0
ss_cm_store:
        move.b  %d0,(%a0,%d1.l)
        subq.l  #1,%d1
        bpl     ss_cm_byte
        move.l  (%a0),%d0
ss_cm_engine:
        lea     sy1_mod_params:l,%a0     | the engine's LSPD / LDEP / WAVE / S&H
        move.l  %d0,(%a0,%d2.l*4)
ss_cm_out:
        rts

| ==== THE LFO STAGE (2.18): d2 = a SY DRUM track, a1 = ss_pre[t] (after the scene and the lock).
| The three stock LFOs of the track can take one of the four controls as destination: PMTR 30
| LSPD, 31 LDEP, 32 WAVE, 33 S&H (the stock Part byte; LFO SETUP lists them after the stock 30).
| synth/lfo_destinations.inc.s (lf_apply, at the stock depth read) gives the stock LFO apply a
| private word of its own for such an LFO -- lf_scratch[3 t + lfo], preset to the parameter
| midpoint LF_MID (63.5 << 8) so the stock adds its signed, DEP-scaled output and clamps as for
| a stock parameter at its midpoint -- and records the destination in lf_targets[3 t + lfo]
| (0 when lf_apply last saw any other destination of this track's; the stock apply skips it for a
| stock destination, so a target is only taken while it equals the LFO's PMTR byte in this frame's
| CF record, 0x80000510 + 384 ping + 48 t + 0x1e + lfo, as lf_latch does for VOIC / CHRD -- an LFO
| moved back to a stock destination leaves no frozen offset). Here each such word less the midpoint is a
| signed offset; the offsets on one control add (several LFOs on one control stack) and are
| scaled to the control's values as VOIC / CHRD's are: one raw unit per 256 on LSPD and LDEP
| (+-63 at DEP 127, as a stock parameter), one shape per 4096 on WAVE (+-3, OFF..RND) and one
| step per 8192 on S&H (+-1); signed division truncates toward zero, so a tiny output stays
| neutral. The sum is clamped to 0..the control's maximum, never wrapped. Every frame (sd_tick
| runs at track 0's third LFO, so a word is this frame's or the previous one's). A track with
| no LFO on these controls keeps a1 and costs the three target tests. Clobbers d0, d1, d3, a0,
| a2; d2 kept.
        .set    SS_LF_MID, 16256         | synth/lfo_destinations.inc.s LF_MID (63.5 << 8)
ss_lfo_stage:
        lea     lf_targets:l,%a0
        move.l  %d2,%d0
        add.l   %d0,%d0
        add.l   %d2,%d0                  | 3 t: this track's three LFOs
        mvz.b   (%a0,%d0.l),%d1
        subi.l  #30,%d1
        cmpi.l  #3,%d1
        bls     ss_lf_work
        mvz.b   1(%a0,%d0.l),%d1
        subi.l  #30,%d1
        cmpi.l  #3,%d1
        bls     ss_lf_work
        mvz.b   2(%a0,%d0.l),%d1
        subi.l  #30,%d1
        cmpi.l  #3,%d1
        bls     ss_lf_work
        rts                              | no LFO on a setup control
ss_lf_work:
        lea     -24(%sp),%sp
        movem.l %d4-%d7/%a3-%a4,(%sp)
        moveq   #0,%d4                   | the summed offsets of LSPD, LDEP, WAVE, S&H (midpoint removed)
        moveq   #0,%d5
        moveq   #0,%d6
        moveq   #0,%d7
        lea     lf_scratch:l,%a3
        movea.l %d0,%a4                  | 3 t
        move.l  PING_AT,%d0
        andi.l  #1,%d0
        mulu.w  #0x180,%d0
        move.l  %d2,%d1
        mulu.w  #48,%d1
        add.l   %d1,%d0
        lea     0x80000510+0x1e,%a2
        adda.l  %d0,%a2                  | this frame's CF record: the track's three LFO PMTR bytes
        moveq   #2,%d3                   | the LFO
ss_lf_each:
        move.l  %a4,%d1
        add.l   %d3,%d1                  | 3 t + lfo
        mvz.b   (%a0,%d1.l),%d0          | its destination
        cmp.b   (%a2,%d3.l),%d0
        bne     ss_lf_next               | stale: the LFO's PMTR is no longer this destination
        mvs.w   (%a3,%d1.l*2),%d1
        subi.l  #SS_LF_MID,%d1           | midpoint + offset -> the signed offset
        cmpi.l  #30,%d0
        bne     ss_lf_1
        add.l   %d1,%d4
        bra     ss_lf_next
ss_lf_1:
        cmpi.l  #31,%d0
        bne     ss_lf_2
        add.l   %d1,%d5
        bra     ss_lf_next
ss_lf_2:
        cmpi.l  #32,%d0
        bne     ss_lf_3
        add.l   %d1,%d6
        bra     ss_lf_next
ss_lf_3:
        cmpi.l  #33,%d0
        bne     ss_lf_next
        add.l   %d1,%d7
ss_lf_next:
        subq.l  #1,%d3
        bpl     ss_lf_each
        move.l  #256,%d1                 | the scale of each control's offset
        divs.l  %d1,%d4
        divs.l  %d1,%d5
        move.l  #4096,%d1
        divs.l  %d1,%d6
        move.l  #8192,%d1
        divs.l  %d1,%d7
        lea     ss_lfo_row:l,%a2
        lea     (%a2,%d2.l*4),%a2        | the modulated row of its own: ss_pre[t] stays the stage's input
        lea     ss_max:l,%a0
        mvz.b   (%a1),%d0
        add.l   %d4,%d0
        mvz.b   (%a0),%d1
        bsr     ss_lf_clamp
        move.b  %d0,(%a2)
        mvz.b   1(%a1),%d0
        add.l   %d5,%d0
        mvz.b   1(%a0),%d1
        bsr     ss_lf_clamp
        move.b  %d0,1(%a2)
        mvz.b   2(%a1),%d0
        add.l   %d6,%d0
        mvz.b   2(%a0),%d1
        bsr     ss_lf_clamp
        move.b  %d0,2(%a2)
        mvz.b   3(%a1),%d0
        add.l   %d7,%d0
        mvz.b   3(%a0),%d1
        bsr     ss_lf_clamp
        move.b  %d0,3(%a2)
        movea.l %a2,%a1
        movem.l (%sp),%d4-%d7/%a3-%a4
        lea     24(%sp),%sp
        rts
| d0 = a value, d1 = its maximum -> d0 clamped to 0..d1.
ss_lf_clamp:
        tst.l   %d0
        bpl     ss_lf_cl_hi
        moveq   #0,%d0
ss_lf_cl_hi:
        cmp.l   %d1,%d0
        ble     ss_lf_cl_out
        move.l  %d1,%d0
ss_lf_cl_out:
        rts

        .data
        .balign 4
ss_base:        .fill 8,4,0x40000000     | per track: the Part default A..D (the stage's input)
ss_pre:         .fill 8,4,0x40000000     | per track: the base, its scene morph, the active lock laid over it
ss_eff:         .fill 8,4,0x40000000     | per track: THE EFFECTIVE BYTES (clamped; the engine's copy)
ss_lfo_row:     .fill 8,4,0x40000000     | per track: the LFO stage's modulated row (2.18)
ss_kind:        .fill 8,1,0              | per track: 0 not SY DRUM / 2 SY DRUM
ss_max:         .byte 127,127,3,1        | LSPD LDEP WAVE S&H
        .balign 4
        .text
