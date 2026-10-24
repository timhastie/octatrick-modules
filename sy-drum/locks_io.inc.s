| GENERATED from tools/locks_io.c (with tools/scenes_io.h, tools/gjlocks_io.h); do not edit.
| Run python3 sy-drum/tools/gen_locks_io.py (m68k-elf-gcc on PATH)
| Source SHA256 (the .c, scenes_io.h, gjlocks_io.h) ffe9a162d314b88510f8f485901c9edad637ead01f91863a492d07d25a08791c
#NO_APP
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"SY LOCKS RECOVERED"
.LC1:
	.string	"SY LOCK FILE ERROR"
	.text
	.align	2
	.globl	sl_io_ui_warning
	.type	sl_io_ui_warning, @function
sl_io_ui_warning:
	mov3q.l #1,%d0
	cmp.l 4(%sp),%d0
	jeq .L6
	move.l #.LC1,%d0
	pea 48.w
	move.l %d0,-(%sp)
	jsr sl_io_toast
	addq.l #8,%sp
	rts
.L6:
	move.l #.LC0,%d0
	pea 48.w
	move.l %d0,-(%sp)
	jsr sl_io_toast
	addq.l #8,%sp
	rts
	.size	sl_io_ui_warning, .-sl_io_ui_warning
	.align	2
	.type	snapshot, @function
snapshot:
	lea (-24,%sp),%sp
	movem.l #7196,(%sp)
	move.l 28(%sp),%d2
	mov3q.l #3,%d3
	lea sl_generation,%a2
	lea sl_io_core_bank,%a4
	lea sl_io_core_pack,%a3
.L11:
	move.l (%a2,%d2.l*4),%d4
	move.l %d2,-(%sp)
	jsr (%a4)
	pea sl_io_file
	move.l %d0,-(%sp)
	move.l %d4,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L12
	subq.l #1,%d3
	cmp.l (%a2,%d2.l*4),%d4
	jeq .L17
	tst.l %d3
	jne .L11
	movem.l (%sp),#7196
	moveq #-62,%d0
	lea (24,%sp),%sp
	rts
.L12:
	movem.l (%sp),#7196
	moveq #-60,%d0
	lea (24,%sp),%sp
	rts
.L17:
	lea sl_io_file+32,%a0
	clr.l %d1
.L10:
	move.b (%a0)+,%d0
	not.l %d0
	mvz.b %d0,%d0
	or.l %d0,%d1
	cmp.l #sl_io_file+49184,%a0
	jne .L10
	tst.l %d1
	sne %d1
	move.l 32(%sp),%a0
	clr.l %d0
	move.l %d4,(%a0)
	movem.l (%sp),#7196
	move.l 36(%sp),%a0
	mvs.b %d1,%d1
	neg.l %d1
	move.l %d1,(%a0)
	lea (24,%sp),%sp
	rts
	.size	snapshot, .-snapshot
	.align	2
	.type	fresh_bank, @function
fresh_bank:
	move.l %d2,-(%sp)
	move.l 8(%sp),%d2
	move.l %d2,-(%sp)
	jsr sl_io_core_bank
	addq.l #4,%sp
	move.l %d0,%a0
	add.l #131072,%d0
.L19:
	move.b #-1,(%a0)+
	cmp.l %a0,%d0
	jne .L19
	jsr sl_io_irq_lock
	mov3q.l #1,%d1
	lsl.l %d2,%d1
	lea sl_generation,%a0
	clr.l (%a0,%d2.l*4)
	move.l %d0,8(%sp)
	move.l (%sp)+,%d2
	or.l %d1,sl_ready_mask
	not.l %d1
	and.l %d1,sl_dirty_mask
	and.l %d1,sl_blocked_mask
	jra sl_io_irq_restore
	.size	fresh_bank, .-fresh_bank
	.align	2
	.type	sg_publish, @function
sg_publish:
	lea (-28,%sp),%sp
	movem.l #1052,(%sp)
	move.l 32(%sp),%d3
	mov3q.l #1,%d2
	move.l 40(%sp),%a1
	move.l 36(%sp),20(%sp)
	move.l %d3,-(%sp)
	move.l %a1,20(%sp)
	lsl.l %d3,%d2
	lea sl_io_irq_lock,%a2
	jsr sl_io_core_bank
	move.l %d0,28(%sp)
	jsr (%a2)
	move.l sl_ready_mask,%d4
	and.l %d2,%d4
	move.l %d0,-(%sp)
	not.l %d2
	and.l %d2,sl_ready_mask
	jsr sl_io_irq_restore
	move.l 32(%sp),%a0
	addq.l #8,%sp
	addq.l #6,%a0
	move.l 16(%sp),%a1
	tst.l %a1
	jeq .L27
	move.l %a1,%d0
	add.l #32768,%d0
.L25:
	move.b (%a1),(%a0)
	addq.l #4,%a1
	move.b -3(%a1),1(%a0)
	move.b -2(%a1),2(%a0)
	move.b -1(%a1),3(%a0)
	lea (16,%a0),%a0
	cmp.l %d0,%a1
	jne .L25
.L26:
	jsr (%a2)
	move.l 20(%sp),%d1
	lea sg_generation,%a0
	move.l %d1,(%a0,%d3.l*4)
	and.l %d2,sg_dirty_mask
	move.l %d0,32(%sp)
	and.l %d2,sg_blocked_mask
	and.l %d2,sg_protected_mask
	or.l %d4,sl_ready_mask
	movem.l (%sp),#1052
	lea (28,%sp),%sp
	jra sl_io_irq_restore
.L27:
	clr.l %d0
.L24:
	st %d1
	move.b #-1,(%a0)
	addq.l #4,%d0
	lea (16,%a0),%a0
	move.b %d1,-13(%a0)
	move.b %d1,-14(%a0)
	move.b %d1,-15(%a0)
	cmp.l #32768,%d0
	jeq .L26
	st %d1
	move.b #-1,(%a0)
	addq.l #4,%d0
	lea (16,%a0),%a0
	move.b %d1,-13(%a0)
	move.b %d1,-14(%a0)
	move.b %d1,-15(%a0)
	cmp.l #32768,%d0
	jne .L24
	jra .L26
	.size	sg_publish, .-sg_publish
	.align	2
	.type	sc_publish, @function
sc_publish:
	lea (-20,%sp),%sp
	moveq #12,%d1
	movem.l #1052,(%sp)
	move.l 24(%sp),%d4
	mov3q.l #1,%d2
	move.l 32(%sp),%a1
	move.l 28(%sp),16(%sp)
	mvz.w %d4,%d0
	lsl.l %d4,%d2
	lsl.l %d1,%d0
	move.l %d2,%d3
	not.l %d3
	and.l %d3,sc_ready_mask
	move.l %d0,%a0
	clr.l %d0
	add.l #sc_table,%a0
	tst.l %a1
	jeq .L34
.L35:
	lea (%a1,%d0.l),%a2
	move.b (%a2),(%a0,%d0.l)
	addq.l #1,%d0
	cmp.l #4096,%d0
	jne .L35
.L36:
	jsr sl_io_irq_lock
	move.l 16(%sp),%a2
	lea sc_generation,%a0
	move.l %a2,(%a0,%d4.l*4)
	or.l %d2,sc_ready_mask
	move.l %d0,24(%sp)
	and.l %d3,sc_dirty_mask
	and.l %d3,sc_blocked_mask
	movem.l (%sp),#1052
	lea (20,%sp),%sp
	jra sl_io_irq_restore
.L34:
	st %d1
	move.b %d1,(%a0,%d0.l)
	addq.l #1,%d0
	cmp.l #4096,%d0
	jeq .L36
	st %d1
	move.b %d1,(%a0,%d0.l)
	addq.l #1,%d0
	cmp.l #4096,%d0
	jne .L34
	jra .L36
	.size	sc_publish, .-sc_publish
	.section	.rodata.str1.1
.LC2:
	.string	"sylock"
.LC3:
	.string	".strd"
.LC4:
	.string	".work"
	.text
	.align	2
	.type	path_for.part.0, @function
path_for.part.0:
	lea (-12,%sp),%sp
	clr.l %d0
	movem.l #3076,(%sp)
	move.l 20(%sp),%a1
	move.l 16(%sp),%a2
	move.l 24(%sp),%d2
	move.b (%a1),%d1
	jeq .L46
.L44:
	move.b %d1,(%a2,%d0.l)
	move.l %d0,%a0
	addq.l #1,%d0
	move.b (%a1,%d0.l),%d1
	jeq .L65
	cmp.l #245,%d0
	jne .L44
.L46:
	movem.l (%sp),#3076
	moveq #-63,%d0
	lea (12,%sp),%sp
	rts
.L65:
	moveq #47,%d1
	lea 2(%a2,%a0.l),%a3
	lea .LC2,%a1
	move.b %d1,(%a2,%d0.l)
	moveq #115,%d0
.L48:
	move.b %d0,(%a3)+
	addq.l #1,%a1
	move.b (%a1),%d0
	cmp.l #.LC2+6,%a1
	jne .L48
	move.l %d2,%d0
	moveq #9,%d1
	lea 8(%a2,%a0.l),%a1
	addq.l #1,%d0
	cmp.l %d0,%d1
	jcc .L49
	moveq #49,%d1
	add.l #38,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jne .L51
.L66:
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l #.LC4,%d2
	move.l %d2,%a1
.L53:
	move.b %d0,(%a3)+
	move.b 1(%a1),%d0
	addq.l #1,%a1
	tst.b %d0
	jne .L53
	lea 10(%a1,%a0.l),%a0
	clr.l %d0
	move.l %a0,%d1
	sub.l %d2,%d1
	clr.b %d2
	move.b %d2,(%a2,%d1.l)
	movem.l (%sp),#3076
	lea (12,%sp),%sp
	rts
.L49:
	moveq #48,%d1
	move.l %d2,%d0
	add.l #49,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jeq .L66
.L51:
	move.l #.LC3,%d2
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l %d2,%a1
	jra .L53
	.size	path_for.part.0, .-path_for.part.0
	.section	.rodata.str1.1
.LC5:
	.string	"r"
.LC6:
	.string	"SYLOCKS"
	.text
	.align	2
	.type	read_bank, @function
read_bank:
	subq.l #8,%sp
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.l 28(%sp),-(%sp)
	move.l 28(%sp),-(%sp)
	move.l 28(%sp),-(%sp)
	pea sl_io_path
	jsr (path_for.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L93
	pea 512.w
	pea sl_io_sector
	pea .LC5
	pea sl_io_path
	pea sl_io_object
	jsr sl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L109
	lea sl_io_object,%a0
	move.l (%a0),-(%sp)
	move.l %a0,12(%sp)
	jsr sl_io_fs_size
	addq.l #4,%sp
	move.l 8(%sp),%a0
	tst.l %d0
	jge .L110
	move.l %a0,-(%sp)
	move.l %d0,12(%sp)
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l 8(%sp),%d1
.L67:
	move.l (%sp)+,%d2
	move.l %d1,%d0
	move.l (%sp)+,%a2
	addq.l #8,%sp
	rts
.L110:
	move.l %d0,12(%sp)
	moveq #32,%d2
	cmp.l %d0,%d2
	jcs .L111
	move.l %d0,-(%sp)
	pea sl_io_file
	pea sl_io_object
	jsr sl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L112
.L86:
	tst.l %d1
	jlt .L113
.L74:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
.L85:
	move.l (%sp)+,%d2
	moveq #-60,%d1
	move.l %d1,%d0
	move.l (%sp)+,%a2
	addq.l #8,%sp
	rts
.L109:
	moveq #-12,%d0
	cmp.l %d1,%d0
	jeq .L94
	moveq #-10,%d2
	cmp.l %d1,%d2
	jeq .L85
	move.l (%sp)+,%d2
	move.l %d1,%d0
	move.l (%sp)+,%a2
	addq.l #8,%sp
	rts
.L111:
	moveq #32,%d0
	move.l %d0,-(%sp)
	pea sl_io_file
	pea sl_io_object
	jsr sl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jne .L86
.L112:
	lea .LC6,%a0
	clr.l %d0
.L73:
	lea sl_io_file,%a2
	addq.l #1,%a0
	mvz.b (%a2,%d0.l),%d2
	mvz.b -1(%a0),%d1
	addq.l #1,%d0
	cmp.l %d2,%d1
	jne .L114
	moveq #8,%d1
	cmp.l %d0,%d1
	jne .L73
	moveq #9,%d0
	cmp.l 12(%sp),%d0
	jcc .L74
	tst.b sl_io_file+8.l
	jne .L83
	move.b sl_io_file+9,%d0
	mov3q.l #1,%d2
	move.l %d0,%d1
	subq.l #1,%d1
	mvz.b %d1,%d1
	cmp.l %d1,%d2
	jcc .L115
.L83:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
.L79:
	move.l (%sp)+,%d2
	moveq #-61,%d1
	move.l %d1,%d0
	move.l (%sp)+,%a2
	addq.l #8,%sp
	rts
.L113:
	pea sl_io_object
	move.l %d1,12(%sp)
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l 8(%sp),%d1
	move.l %d1,%d0
	move.l (%sp)+,%d2
	move.l (%sp)+,%a2
	addq.l #8,%sp
	rts
.L94:
	move.l (%sp)+,%d2
	mov3q.l #1,%d1
	move.l %d1,%d0
	move.l (%sp)+,%a2
	addq.l #8,%sp
	rts
.L115:
	moveq #15,%d1
	cmp.l 12(%sp),%d1
	jcc .L74
	tst.b sl_io_file+10.l
	jne .L83
	mvz.b sl_io_file+11,%d1
	moveq #32,%d2
	cmp.l %d1,%d2
	jne .L83
	move.b sl_io_file+15,%d2
	move.b sl_io_file+14,%d1
	move.w %d2,%a0
	move.l %a0,%d2
	or.l %d2,%d1
	tst.b %d1
	jne .L83
	mvz.b %d0,%d0
	subq.l #1,%d0
	tst.l %d0
	jeq .L96
	mvz.w #49184,%d0
.L82:
	cmp.l 12(%sp),%d0
	jne .L74
	move.l 12(%sp),%a0
	pea -32(%a0)
	pea sl_io_file+32
	pea sl_io_object
	jsr sl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jne .L86
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L67
	move.l 32(%sp),-(%sp)
	move.l 16(%sp),-(%sp)
	pea sl_io_file
	move.l 36(%sp),-(%sp)
	jsr sl_io_core_validate
	lea (16,%sp),%sp
	moveq #-2,%d1
	cmp.l %d0,%d1
	jeq .L79
	tst.l %d0
	jlt .L85
	move.l 12(%sp),%a0
	cmp.l #32800,%a0
	jeq .L116
	move.l (%sp)+,%d2
	clr.l %d1
	move.l %d1,%d0
	move.l (%sp)+,%a2
	addq.l #8,%sp
	rts
.L96:
	mvz.w #32800,%d0
	jra .L82
.L116:
	lea sl_io_file+49178,%a0
	lea sl_io_file+32796,%a1
.L90:
	moveq #-1,%d0
	subq.l #4,%a1
	move.w %d0,4(%a0)
	move.b 7(%a1),3(%a0)
	move.b 6(%a1),2(%a0)
	move.b 5(%a1),1(%a0)
	move.b 4(%a1),(%a0)
	subq.l #6,%a0
	cmp.l #sl_io_file+26,%a0
	jne .L90
	pea sl_io_file
	move.l 36(%sp),%a0
	move.l (%a0),-(%sp)
	move.l 32(%sp),-(%sp)
	jsr sl_io_core_seal
	lea (12,%sp),%sp
	moveq #-60,%d1
	add.l %d0,%d0
	subx.l %d0,%d0
	move.l (%sp)+,%d2
	move.l (%sp)+,%a2
	and.l %d0,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L114:
	moveq #9,%d1
	cmp.l 12(%sp),%d1
	jcc .L74
	moveq #15,%d2
	cmp.l 12(%sp),%d2
	jcc .L74
	mvz.w #49184,%d0
	jra .L82
.L93:
	move.l (%sp)+,%d2
	moveq #-63,%d1
	move.l %d1,%d0
	move.l (%sp)+,%a2
	addq.l #8,%sp
	rts
	.size	read_bank, .-read_bank
	.section	.rodata.str1.1
.LC7:
	.string	"syscen"
	.text
	.align	2
	.type	sc_path.part.0, @function
sc_path.part.0:
	lea (-12,%sp),%sp
	clr.l %d0
	movem.l #3076,(%sp)
	move.l 20(%sp),%a1
	move.l 16(%sp),%a2
	move.l 24(%sp),%d2
	move.b (%a1),%d1
	jeq .L120
.L118:
	move.b %d1,(%a2,%d0.l)
	move.l %d0,%a0
	addq.l #1,%d0
	move.b (%a1,%d0.l),%d1
	jeq .L139
	cmp.l #245,%d0
	jne .L118
.L120:
	movem.l (%sp),#3076
	moveq #-63,%d0
	lea (12,%sp),%sp
	rts
.L139:
	moveq #47,%d1
	lea 2(%a2,%a0.l),%a3
	lea .LC7,%a1
	move.b %d1,(%a2,%d0.l)
	moveq #115,%d0
.L122:
	move.b %d0,(%a3)+
	addq.l #1,%a1
	move.b (%a1),%d0
	cmp.l #.LC7+6,%a1
	jne .L122
	move.l %d2,%d0
	moveq #9,%d1
	lea 8(%a2,%a0.l),%a1
	addq.l #1,%d0
	cmp.l %d0,%d1
	jcc .L123
	moveq #49,%d1
	add.l #38,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jne .L125
.L140:
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l #.LC4,%d2
	move.l %d2,%a1
.L127:
	move.b %d0,(%a3)+
	move.b 1(%a1),%d0
	addq.l #1,%a1
	tst.b %d0
	jne .L127
	lea 10(%a1,%a0.l),%a0
	clr.l %d0
	move.l %a0,%d1
	sub.l %d2,%d1
	clr.b %d2
	move.b %d2,(%a2,%d1.l)
	movem.l (%sp),#3076
	lea (12,%sp),%sp
	rts
.L123:
	moveq #48,%d1
	move.l %d2,%d0
	add.l #49,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jeq .L140
.L125:
	move.l #.LC3,%d2
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l %d2,%a1
	jra .L127
	.size	sc_path.part.0, .-sc_path.part.0
	.section	.rodata.str1.1
.LC8:
	.string	"sylkgj"
	.text
	.align	2
	.type	sg_path.part.0, @function
sg_path.part.0:
	lea (-12,%sp),%sp
	clr.l %d0
	movem.l #3076,(%sp)
	move.l 20(%sp),%a1
	move.l 16(%sp),%a2
	move.l 24(%sp),%d2
	move.b (%a1),%d1
	jeq .L144
.L142:
	move.b %d1,(%a2,%d0.l)
	move.l %d0,%a0
	addq.l #1,%d0
	move.b (%a1,%d0.l),%d1
	jeq .L163
	cmp.l #245,%d0
	jne .L142
.L144:
	movem.l (%sp),#3076
	moveq #-63,%d0
	lea (12,%sp),%sp
	rts
.L163:
	moveq #47,%d1
	lea 2(%a2,%a0.l),%a3
	lea .LC8,%a1
	move.b %d1,(%a2,%d0.l)
	moveq #115,%d0
.L146:
	move.b %d0,(%a3)+
	addq.l #1,%a1
	move.b (%a1),%d0
	cmp.l #.LC8+6,%a1
	jne .L146
	move.l %d2,%d0
	moveq #9,%d1
	lea 8(%a2,%a0.l),%a1
	addq.l #1,%d0
	cmp.l %d0,%d1
	jcc .L147
	moveq #49,%d1
	add.l #38,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jne .L149
.L164:
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l #.LC4,%d2
	move.l %d2,%a1
.L151:
	move.b %d0,(%a3)+
	move.b 1(%a1),%d0
	addq.l #1,%a1
	tst.b %d0
	jne .L151
	lea 10(%a1,%a0.l),%a0
	clr.l %d0
	move.l %a0,%d1
	sub.l %d2,%d1
	clr.b %d2
	move.b %d2,(%a2,%d1.l)
	movem.l (%sp),#3076
	lea (12,%sp),%sp
	rts
.L147:
	moveq #48,%d1
	move.l %d2,%d0
	add.l #49,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jeq .L164
.L149:
	move.l #.LC3,%d2
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l %d2,%a1
	jra .L151
	.size	sg_path.part.0, .-sg_path.part.0
	.section	.rodata.str1.1
.LC9:
	.string	"w"
	.text
	.align	2
	.type	sg_write_file.constprop.0, @function
sg_write_file.constprop.0:
	subq.l #4,%sp
	move.l 12(%sp),-(%sp)
	move.l 12(%sp),-(%sp)
	pea sl_io_base
	pea sl_io_path
	jsr (sg_path.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L170
	pea 512.w
	pea sl_io_sector
	pea .LC9
	pea sl_io_path
	pea sl_io_object
	jsr sl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L165
	move.l #32800,-(%sp)
	pea sl_io_file
	pea sl_io_object
	jsr sl_io_fs_write
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L173
	tst.l %d1
	jlt .L169
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	moveq #-60,%d1
.L165:
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L173:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jle .L165
	clr.l %d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L169:
	pea sl_io_object
	move.l %d1,4(%sp)
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l (%sp),%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L170:
	moveq #-63,%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
	.size	sg_write_file.constprop.0, .-sg_write_file.constprop.0
	.align	2
	.type	sc_write_file.constprop.0, @function
sc_write_file.constprop.0:
	subq.l #4,%sp
	move.l 12(%sp),-(%sp)
	move.l 12(%sp),-(%sp)
	pea sl_io_base
	pea sl_io_path
	jsr (sc_path.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L179
	pea 512.w
	pea sl_io_sector
	pea .LC9
	pea sl_io_path
	pea sl_io_object
	jsr sl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L174
	pea 4128.w
	pea sl_io_file
	pea sl_io_object
	jsr sl_io_fs_write
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L182
	tst.l %d1
	jlt .L178
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	moveq #-60,%d1
.L174:
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L182:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jle .L174
	clr.l %d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L178:
	pea sl_io_object
	move.l %d1,4(%sp)
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l (%sp),%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L179:
	moveq #-63,%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
	.size	sc_write_file.constprop.0, .-sc_write_file.constprop.0
	.align	2
	.type	write_buffer.constprop.0, @function
write_buffer.constprop.0:
	subq.l #4,%sp
	move.l 12(%sp),-(%sp)
	move.l 12(%sp),-(%sp)
	pea sl_io_base
	pea sl_io_path
	jsr (path_for.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L188
	pea 512.w
	pea sl_io_sector
	pea .LC9
	pea sl_io_path
	pea sl_io_object
	jsr sl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L183
	move.l #49184,-(%sp)
	pea sl_io_file
	pea sl_io_object
	jsr sl_io_fs_write
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L191
	tst.l %d1
	jlt .L187
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	moveq #-60,%d1
.L183:
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L191:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jle .L183
	clr.l %d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L187:
	pea sl_io_object
	move.l %d1,4(%sp)
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l (%sp),%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L188:
	moveq #-63,%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
	.size	write_buffer.constprop.0, .-write_buffer.constprop.0
	.section	.rodata.str1.1
.LC10:
	.string	"SYSCENE"
	.text
	.align	2
	.type	sc_snapshot, @function
sc_snapshot:
	lea (-16,%sp),%sp
	mov3q.l #3,%d0
	move.l 20(%sp),%d1
	movem.l #3084,(%sp)
	moveq #12,%d3
	mvz.w %d1,%d2
	lea sc_generation,%a2
	lsl.l %d3,%d2
	add.l #sc_table,%d2
.L199:
	move.l (%a2,%d1.l*4),%d3
	lea sl_io_file,%a3
	lea sl_io_file+32,%a0
	move.l %d2,%a1
.L193:
	move.b (%a1)+,(%a0)+
	cmp.l #sl_io_file+4128,%a0
	jne .L193
	cmp.l (%a2,%d1.l*4),%d3
	jeq .L207
	subq.l #1,%d0
	tst.l %d0
	jne .L199
	movem.l (%sp),#3084
	moveq #-62,%d0
	lea (16,%sp),%sp
	rts
.L207:
	lea .LC10,%a0
.L195:
	move.b (%a0)+,(%a3)+
	cmp.l #.LC10+8,%a0
	jne .L195
	clr.b %d0
	move.b %d1,sl_io_file+13
	mov3q.l #-1,%d1
	move.l %d3,sl_io_file+20
	lea sl_io_file+32,%a0
	lea sl_crc_table,%a1
	move.b %d0,sl_io_file+12
	clr.w %d0
	move.w %d0,sl_io_file+14
	move.l #65568,%d0
	move.l %d0,sl_io_file+8
	mvz.w #4096,%d0
	move.l %d0,sl_io_file+16
.L196:
	mvz.b (%a0)+,%d0
	move.l %d1,%d2
	lsr.l #8,%d2
	eor.l %d1,%d0
	mvz.b %d0,%d0
	move.l (%a1,%d0.l*4),%d1
	eor.l %d2,%d1
	cmp.l #sl_io_file+4128,%a0
	jne .L196
	not.l %d1
	move.l %d1,sl_io_file+24
	mov3q.l #-1,%d1
	lea sl_io_file,%a0
.L197:
	mvz.b (%a0)+,%d0
	move.l %d1,%d2
	lsr.l #8,%d2
	eor.l %d1,%d0
	mvz.b %d0,%d0
	move.l (%a1,%d0.l*4),%d1
	eor.l %d2,%d1
	cmp.l #sl_io_file+28,%a0
	jne .L197
	move.l 24(%sp),%a0
	not.l %d1
	move.l %d1,sl_io_file+28
	clr.l %d0
	move.l %d3,(%a0)
	movem.l (%sp),#3084
	lea (16,%sp),%sp
	rts
	.size	sc_snapshot, .-sc_snapshot
	.align	2
	.type	sc_read, @function
sc_read:
	lea (-16,%sp),%sp
	movem.l #1036,(%sp)
	move.l 28(%sp),-(%sp)
	move.l 28(%sp),-(%sp)
	move.l 28(%sp),-(%sp)
	pea sl_io_path
	jsr (sc_path.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L228
	pea 512.w
	pea sl_io_sector
	pea .LC5
	pea sl_io_path
	pea sl_io_object
	jsr sl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L237
	lea sl_io_object,%a2
	move.l (%a2),-(%sp)
	jsr sl_io_fs_size
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jge .L238
	move.l %a2,-(%sp)
	move.l %d0,16(%sp)
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l 12(%sp),%d1
.L208:
	movem.l (%sp),#1036
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L238:
	moveq #32,%d3
	cmp.l %d0,%d3
	jcs .L239
	move.l %d0,-(%sp)
	pea sl_io_file
	pea sl_io_object
	move.l %d1,24(%sp)
	jsr sl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d2
	mov3q.l #1,%d0
	move.l 12(%sp),%d1
	cmp.l %d2,%d0
	jeq .L240
.L213:
	tst.l %d2
	jlt .L241
.L221:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
.L216:
	movem.l (%sp),#1036
	moveq #-60,%d1
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L237:
	moveq #-12,%d0
	cmp.l %d1,%d0
	jeq .L229
	moveq #-10,%d2
	cmp.l %d1,%d2
	jeq .L216
	movem.l (%sp),#1036
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L239:
	moveq #32,%d0
	move.l %d0,-(%sp)
	pea sl_io_file
	pea sl_io_object
	move.l %d1,24(%sp)
	jsr sl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d2
	mov3q.l #1,%d0
	move.l 12(%sp),%d1
	cmp.l %d2,%d0
	jne .L213
.L240:
	lea .LC10,%a0
	clr.l %d0
	lea sl_io_file,%a2
.L214:
	mvz.b (%a2,%d0.l),%d3
	mvz.b (%a0),%d2
	addq.l #1,%a0
	addq.l #1,%d0
	cmp.l %d3,%d2
	jne .L221
	moveq #8,%d2
	cmp.l %d0,%d2
	jne .L214
	moveq #9,%d3
	cmp.l %d1,%d3
	jcc .L221
	tst.b sl_io_file+8.l
	jne .L220
	mvz.b sl_io_file+9,%d0
	subq.l #1,%d0
	tst.l %d0
	jeq .L242
.L220:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	movem.l (%sp),#1036
	moveq #-61,%d1
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L241:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l %d2,%d1
	move.l %d1,%d0
	movem.l (%sp),#1036
	lea (16,%sp),%sp
	rts
.L229:
	movem.l (%sp),#1036
	mov3q.l #1,%d1
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L242:
	moveq #15,%d3
	cmp.l %d1,%d3
	jcc .L221
	mvz.b sl_io_file+11,%d0
	moveq #32,%d2
	cmp.l %d0,%d2
	jne .L220
	move.b sl_io_file+14,%d3
	move.b sl_io_file+10,%d0
	move.b sl_io_file+15,%d2
	move.w %d3,%a0
	move.l %a0,%d3
	or.l %d3,%d0
	or.l %d2,%d0
	tst.b %d0
	jne .L220
	cmp.l #4128,%d1
	jne .L221
	pea 4096.w
	pea sl_io_file+32
	pea sl_io_object
	jsr sl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L243
	tst.l %d1
	jge .L221
	pea sl_io_object
	move.l %d1,16(%sp)
	jsr sl_io_fs_close
	addq.l #4,%sp
	movem.l (%sp),#1036
	move.l 12(%sp),%d1
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L243:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L208
	tst.b sl_io_file+12.l
	jne .L216
	mvz.b sl_io_file+13,%d0
	cmp.l 24(%sp),%d0
	jne .L216
	mvz.w #4096,%d1
	cmp.l sl_io_file+16.l,%d1
	jne .L216
	mov3q.l #-1,%d1
	lea sl_io_file,%a0
	lea sl_crc_table,%a2
.L224:
	mvz.b (%a0)+,%d0
	move.l %d1,%d2
	lsr.l #8,%d2
	eor.l %d1,%d0
	mvz.b %d0,%d0
	move.l (%a2,%d0.l*4),%d1
	eor.l %d2,%d1
	cmp.l #sl_io_file+28,%a0
	jne .L224
	not.l %d1
	cmp.l sl_io_file+28.l,%d1
	jne .L216
	mov3q.l #-1,%d1
	lea sl_io_file+32,%a1
.L225:
	mvz.b (%a1)+,%d0
	move.l %d1,%d2
	lsr.l #8,%d2
	eor.l %d1,%d0
	mvz.b %d0,%d0
	move.l (%a2,%d0.l*4),%d1
	eor.l %d2,%d1
	cmp.l #sl_io_file+4128,%a1
	jne .L225
	not.l %d1
	cmp.l sl_io_file+24.l,%d1
	jne .L216
	lea sl_io_file+32,%a0
.L226:
	move.b (%a0),%d0
	addq.l #1,%a0
	moveq #126,%d2
	add.l #-128,%d0
	mvz.b %d0,%d0
	cmp.l %d0,%d2
	jcc .L216
	cmp.l %a1,%a0
	jne .L226
	movem.l (%sp),#1036
	move.l 32(%sp),%a0
	clr.l %d1
	move.l %d1,%d0
	move.l sl_io_file+20,(%a0)
	lea (16,%sp),%sp
	rts
.L228:
	movem.l (%sp),#1036
	moveq #-63,%d1
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
	.size	sc_read, .-sc_read
	.section	.rodata.str1.1
.LC11:
	.string	"SYLOCKGJ"
	.text
	.align	2
	.type	sg_snapshot, @function
sg_snapshot:
	lea (-36,%sp),%sp
	movem.l #7420,(%sp)
	move.l 40(%sp),%d3
	mov3q.l #3,%d2
	lea sg_generation,%a2
	move.l %d3,-(%sp)
	jsr sl_io_core_bank
	addq.l #4,%sp
	move.l %d0,%a4
.L251:
	move.l (%a2,%d3.l*4),%d4
	lea (6,%a4),%a0
	clr.l %d0
	lea sl_io_file,%a3
	lea sl_io_file+32,%a1
.L245:
	move.b (%a0),(%a1)
	lea (16,%a0),%a0
	move.b -15(%a0),1(%a1)
	move.b -14(%a0),2(%a1)
	addq.l #4,%a1
	move.b -13(%a0),%d6
	move.b %d6,-1(%a1)
	move.b -16(%a0),%d1
	move.b -15(%a0),%d5
	move.b -14(%a0),%d7
	and.l %d6,%d1
	and.l %d5,%d1
	and.l %d7,%d1
	not.l %d1
	mvz.b %d1,%d1
	or.l %d1,%d0
	cmp.l #sl_io_file+32800,%a1
	jne .L245
	cmp.l (%a2,%d3.l*4),%d4
	jeq .L259
	subq.l #1,%d2
	tst.l %d2
	jne .L251
	movem.l (%sp),#7420
	moveq #-62,%d0
	lea (36,%sp),%sp
	rts
.L259:
	lea .LC11,%a0
.L247:
	move.b (%a0)+,(%a3)+
	cmp.l #.LC11+8,%a0
	jne .L247
	clr.b %d1
	move.b %d3,sl_io_file+13
	mov3q.l #-1,%d2
	move.l %d4,sl_io_file+20
	lea sl_io_file+32,%a0
	lea sl_crc_table,%a1
	move.b %d1,sl_io_file+12
	clr.w %d1
	move.w %d1,sl_io_file+14
	move.l #65568,%d1
	move.l %d1,sl_io_file+8
	mvz.w #32768,%d1
	move.l %d1,sl_io_file+16
.L248:
	mvz.b (%a0)+,%d1
	move.l %d2,%d3
	lsr.l #8,%d3
	eor.l %d2,%d1
	mvz.b %d1,%d1
	move.l (%a1,%d1.l*4),%d2
	eor.l %d3,%d2
	cmp.l #sl_io_file+32800,%a0
	jne .L248
	not.l %d2
	move.l %d2,sl_io_file+24
	mov3q.l #-1,%d2
	lea sl_io_file,%a0
.L249:
	mvz.b (%a0)+,%d1
	move.l %d2,%d3
	lsr.l #8,%d3
	eor.l %d2,%d1
	mvz.b %d1,%d1
	move.l (%a1,%d1.l*4),%d2
	eor.l %d3,%d2
	cmp.l #sl_io_file+28,%a0
	jne .L249
	tst.l %d0
	sne %d1
	move.l 44(%sp),%a0
	not.l %d2
	move.l %d2,sl_io_file+28
	clr.l %d0
	move.l %d4,(%a0)
	movem.l (%sp),#7420
	move.l 48(%sp),%a0
	mvs.b %d1,%d1
	neg.l %d1
	move.l %d1,(%a0)
	lea (36,%sp),%sp
	rts
	.size	sg_snapshot, .-sg_snapshot
	.align	2
	.type	flush.part.0.constprop.0, @function
flush.part.0.constprop.0:
	lea (-52,%sp),%sp
	movem.l #31996,(%sp)
	move.l sl_dirty_mask,%d0
	move.l %sp,%d6
	move.l sl_blocked_mask,%d4
	not.l %d4
	move.l sl_ready_mask,%d2
	move.l %sp,%d5
	move.l sl_io_protected_mask,%d1
	not.l %d1
	clr.l %d3
	and.l %d2,%d0
	add.l #48,%d6
	add.l #44,%d5
	lea snapshot,%a2
	lea sl_io_irq_lock,%a5
	lea sl_generation,%a4
	lea sl_io_irq_restore,%a3
	and.l %d0,%d4
	and.l %d1,%d4
	and.l 56(%sp),%d4
.L265:
	mov3q.l #1,%d2
	lsl.l %d3,%d2
	move.l %d4,%d0
	and.l %d2,%d0
	tst.l %d0
	jne .L299
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L265
.L303:
	sub.l %a6,%a6
.L262:
	move.l sg_dirty_mask,%d1
	move.l %sp,%d6
	move.l sl_ready_mask,%d2
	move.l %sp,%d5
	move.l sl_blocked_mask,%d3
	not.l %d3
	move.l sg_blocked_mask,%d0
	not.l %d0
	and.l %d2,%d1
	move.l sg_protected_mask,%d2
	not.l %d2
	clr.l %d7
	add.l #48,%d6
	add.l #44,%d5
	lea sg_snapshot,%a2
	lea sl_io_irq_lock,%a5
	lea sg_generation,%a4
	lea sl_io_irq_restore,%a3
	and.l %d1,%d3
	and.l %d0,%d3
	and.l %d2,%d3
	and.l 56(%sp),%d3
.L270:
	mov3q.l #1,%d2
	lsl.l %d7,%d2
	move.l %d3,%d0
	and.l %d2,%d0
	tst.l %d0
	jne .L300
	addq.l #1,%d7
	moveq #16,%d0
	cmp.l %d7,%d0
	jne .L270
.L306:
	clr.l %d4
.L267:
	move.l sc_dirty_mask,%d3
	move.l %sp,%d5
	move.l sc_ready_mask,%d2
	clr.l %d6
	move.l sc_blocked_mask,%d0
	not.l %d0
	add.l #48,%d5
	and.l %d2,%d3
	lea sc_snapshot,%a2
	lea (sc_write_file.constprop.0),%a3
	lea sc_generation,%a5
	lea sl_io_irq_restore,%a4
	and.l %d0,%d3
	and.l 56(%sp),%d3
.L274:
	mov3q.l #1,%d2
	lsl.l %d6,%d2
	move.l %d3,%d0
	and.l %d2,%d0
	tst.l %d0
	jne .L301
	addq.l #1,%d6
	moveq #16,%d0
	cmp.l %d6,%d0
	jne .L274
.L309:
	clr.l %d0
.L272:
	tst.l %a6
	jne .L260
	tst.l %d4
	jeq .L278
	move.l %d4,%a6
.L260:
	move.l %a6,%d0
	movem.l (%sp),#31996
	lea (52,%sp),%sp
	rts
.L299:
	move.l %d6,-(%sp)
	move.l %d5,-(%sp)
	move.l %d3,-(%sp)
	jsr (%a2)
	lea (12,%sp),%sp
	move.l %d0,%a6
	tst.l %d0
	jne .L262
	move.l %d2,%d0
	and.l sl_present_mask,%d0
	or.l 48(%sp),%d0
	jeq .L263
	clr.l -(%sp)
	move.l %d3,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	move.l %d0,%a6
	tst.l %d0
	jne .L262
	or.l %d2,sl_present_mask
.L263:
	move.l 44(%sp),%d7
	not.l %d2
	jsr (%a5)
	cmp.l (%a4,%d3.l*4),%d7
	jeq .L302
	move.l %d0,-(%sp)
	jsr (%a3)
	and.l %d2,sl_io_protected_mask
	addq.l #4,%sp
.L304:
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L265
	jra .L303
.L302:
	move.l %d0,-(%sp)
	and.l %d2,sl_dirty_mask
	jsr (%a3)
	and.l %d2,sl_io_protected_mask
	addq.l #4,%sp
	jra .L304
.L300:
	move.l %d6,-(%sp)
	move.l %d5,-(%sp)
	move.l %d7,-(%sp)
	jsr (%a2)
	lea (12,%sp),%sp
	tst.l %d0
	jne .L276
	move.l %d2,%d0
	and.l sg_present_mask,%d0
	or.l 48(%sp),%d0
	jeq .L268
	clr.l -(%sp)
	move.l %d7,-(%sp)
	jsr (sg_write_file.constprop.0)
	addq.l #8,%sp
	move.l %d0,%d4
	tst.l %d0
	jne .L267
	or.l %d2,sg_present_mask
.L268:
	move.l 44(%sp),%d4
	jsr (%a5)
	cmp.l (%a4,%d7.l*4),%d4
	jeq .L305
	move.l %d0,-(%sp)
	jsr (%a3)
	addq.l #4,%sp
.L307:
	addq.l #1,%d7
	moveq #16,%d0
	cmp.l %d7,%d0
	jne .L270
	jra .L306
.L305:
	not.l %d2
	move.l %d0,-(%sp)
	and.l %d2,sg_dirty_mask
	jsr (%a3)
	addq.l #4,%sp
	jra .L307
.L301:
	move.l %d5,-(%sp)
	move.l %d6,-(%sp)
	jsr (%a2)
	addq.l #8,%sp
	tst.l %d0
	jne .L277
	clr.l -(%sp)
	move.l %d6,-(%sp)
	jsr (%a3)
	addq.l #8,%sp
	tst.l %d0
	jne .L272
	move.l 48(%sp),%d7
	jsr sl_io_irq_lock
	cmp.l (%a5,%d6.l*4),%d7
	jeq .L308
	move.l %d0,-(%sp)
	jsr (%a4)
	addq.l #4,%sp
.L310:
	addq.l #1,%d6
	moveq #16,%d0
	cmp.l %d6,%d0
	jne .L274
	jra .L309
.L308:
	not.l %d2
	move.l %d0,-(%sp)
	and.l %d2,sc_dirty_mask
	jsr (%a4)
	addq.l #4,%sp
	jra .L310
.L278:
	move.l %d0,%a6
	move.l %a6,%d0
	movem.l (%sp),#31996
	lea (52,%sp),%sp
	rts
.L276:
	move.l sc_dirty_mask,%d3
	move.l %sp,%d5
	move.l sc_ready_mask,%d2
	moveq #-62,%d4
	move.l sc_blocked_mask,%d0
	not.l %d0
	clr.l %d6
	and.l %d2,%d3
	add.l #48,%d5
	lea sc_snapshot,%a2
	lea (sc_write_file.constprop.0),%a3
	lea sc_generation,%a5
	lea sl_io_irq_restore,%a4
	and.l %d0,%d3
	and.l 56(%sp),%d3
	jra .L274
.L277:
	moveq #-62,%d0
	jra .L272
	.size	flush.part.0.constprop.0, .-flush.part.0.constprop.0
	.align	2
	.type	store_mask, @function
store_mask:
	lea (-52,%sp),%sp
	movem.l #31996,(%sp)
	move.l 56(%sp),%d4
	tst.l sl_io_loaded
	jeq .L329
	move.l %d4,%d3
	and.l sl_blocked_mask,%d3
	tst.l %d3
	jne .L313
	move.l %d4,%d0
	and.l sl_ready_mask,%d0
	cmp.l %d4,%d0
	jne .L313
	move.l %sp,%d6
	move.l %sp,%d5
	add.l #48,%d6
	add.l #44,%d5
	lea snapshot,%a2
	lea sl_io_irq_lock,%a5
	lea sl_generation,%a4
	lea sl_io_irq_restore,%a3
.L314:
	mov3q.l #1,%d2
	lsl.l %d3,%d2
	move.l %d4,%d0
	and.l %d2,%d0
	tst.l %d0
	jne .L357
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L314
.L361:
	sub.l %a6,%a6
.L315:
	move.l sl_ready_mask,%d0
	move.l %sp,%d7
	move.l sl_blocked_mask,%d3
	clr.l %d6
	add.l #48,%d7
	lea sg_snapshot,%a2
	or.l sg_blocked_mask,%d3
	lea sl_io_irq_lock,%a5
	lea sg_generation,%a4
	not.l %d3
	and.l %d0,%d3
	and.l %d4,%d3
.L323:
	mov3q.l #1,%d2
	lsl.l %d6,%d2
	move.l %d3,%d0
	and.l %d2,%d0
	tst.l %d0
	jne .L358
	addq.l #1,%d6
	moveq #16,%d0
	cmp.l %d6,%d0
	jne .L323
.L364:
	clr.l %d5
.L320:
	move.l sc_blocked_mask,%d3
	not.l %d3
	and.l sc_ready_mask,%d3
	move.l %sp,%d6
	clr.l %d7
	lea sc_generation,%a2
	add.l #48,%d6
	lea sc_snapshot,%a4
	lea (sc_write_file.constprop.0),%a3
	lea sl_io_irq_restore,%a5
	and.l %d4,%d3
.L328:
	mov3q.l #1,%d2
	lsl.l %d7,%d2
	move.l %d3,%d0
	and.l %d2,%d0
	tst.l %d0
	jeq .L324
	tst.l (%a2,%d7.l*4)
	jne .L325
	move.l %d2,%d0
	and.l sc_dirty_mask,%d0
	tst.l %d0
	jeq .L324
.L325:
	move.l %d6,-(%sp)
	move.l %d7,-(%sp)
	jsr (%a4)
	addq.l #8,%sp
	tst.l %d0
	jne .L331
	clr.l -(%sp)
	move.l %d7,-(%sp)
	jsr (%a3)
	addq.l #8,%sp
	tst.l %d0
	jne .L326
	mov3q.l #1,-(%sp)
	move.l %d7,-(%sp)
	jsr (%a3)
	addq.l #8,%sp
	tst.l %d0
	jne .L326
	move.l 48(%sp),%d4
	jsr sl_io_irq_lock
	cmp.l (%a2,%d7.l*4),%d4
	jeq .L359
	move.l %d0,-(%sp)
	jsr (%a5)
	addq.l #4,%sp
.L324:
	addq.l #1,%d7
	moveq #16,%d0
	cmp.l %d7,%d0
	jne .L328
	clr.l %d0
.L326:
	tst.l %a6
	jne .L311
.L366:
	tst.l %d5
	jeq .L332
	move.l %d5,%a6
.L311:
	move.l %a6,%d0
	movem.l (%sp),#31996
	lea (52,%sp),%sp
	rts
.L357:
	move.l %d6,-(%sp)
	move.l %d5,-(%sp)
	move.l %d3,-(%sp)
	jsr (%a2)
	lea (12,%sp),%sp
	move.l %d0,%a6
	tst.l %d0
	jne .L315
	move.l %d2,%d0
	and.l sl_present_mask,%d0
	or.l 48(%sp),%d0
	jeq .L317
	clr.l -(%sp)
	move.l %d3,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	move.l %d0,%a6
	tst.l %d0
	jne .L315
	mov3q.l #1,-(%sp)
	move.l %d3,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	move.l %d0,%a6
	tst.l %d0
	jne .L315
	or.l %d2,sl_present_mask
.L317:
	move.l 44(%sp),%d7
	not.l %d2
	jsr (%a5)
	cmp.l (%a4,%d3.l*4),%d7
	jeq .L360
	move.l %d0,-(%sp)
	jsr (%a3)
	and.l %d2,sl_io_protected_mask
	addq.l #4,%sp
.L362:
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L314
	jra .L361
.L360:
	move.l %d0,-(%sp)
	and.l %d2,sl_dirty_mask
	jsr (%a3)
	and.l %d2,sl_io_protected_mask
	addq.l #4,%sp
	jra .L362
.L358:
	move.l %d7,-(%sp)
	pea 48(%sp)
	move.l %d6,-(%sp)
	jsr (%a2)
	lea (12,%sp),%sp
	tst.l %d0
	jne .L330
	move.l %d2,%d0
	and.l sg_present_mask,%d0
	or.l 48(%sp),%d0
	jeq .L321
	clr.l -(%sp)
	move.l %d6,-(%sp)
	jsr (sg_write_file.constprop.0)
	addq.l #8,%sp
	move.l %d0,%d5
	tst.l %d0
	jne .L320
	mov3q.l #1,-(%sp)
	move.l %d6,-(%sp)
	jsr (sg_write_file.constprop.0)
	addq.l #8,%sp
	move.l %d0,%d5
	tst.l %d0
	jne .L320
	or.l %d2,sg_present_mask
.L321:
	move.l 44(%sp),%d5
	not.l %d2
	jsr (%a5)
	cmp.l (%a4,%d6.l*4),%d5
	jeq .L363
	move.l %d0,-(%sp)
	jsr sl_io_irq_restore
	and.l %d2,sg_protected_mask
	addq.l #4,%sp
.L365:
	addq.l #1,%d6
	moveq #16,%d0
	cmp.l %d6,%d0
	jne .L323
	jra .L364
.L363:
	move.l %d0,-(%sp)
	and.l %d2,sg_dirty_mask
	jsr sl_io_irq_restore
	and.l %d2,sg_protected_mask
	addq.l #4,%sp
	jra .L365
.L359:
	not.l %d2
	move.l %d0,-(%sp)
	and.l %d2,sc_dirty_mask
	jsr (%a5)
	addq.l #4,%sp
	jra .L324
.L332:
	move.l %d0,%a6
	move.l %a6,%d0
	movem.l (%sp),#31996
	lea (52,%sp),%sp
	rts
.L331:
	moveq #-62,%d0
	tst.l %a6
	jne .L311
	jra .L366
.L330:
	move.l sc_blocked_mask,%d3
	not.l %d3
	and.l sc_ready_mask,%d3
	move.l %sp,%d6
	moveq #-62,%d5
	clr.l %d7
	lea sc_generation,%a2
	add.l #48,%d6
	lea sc_snapshot,%a4
	lea (sc_write_file.constprop.0),%a3
	lea sl_io_irq_restore,%a5
	and.l %d4,%d3
	jra .L328
.L313:
	move.l sl_ready_mask,%d0
	move.l %sp,%d7
	move.l sl_blocked_mask,%d3
	clr.l %d6
	move.w #-61,%a6
	add.l #48,%d7
	or.l sg_blocked_mask,%d3
	lea sg_snapshot,%a2
	lea sl_io_irq_lock,%a5
	lea sg_generation,%a4
	not.l %d3
	and.l %d0,%d3
	and.l %d4,%d3
	jra .L323
.L329:
	move.w #-60,%a6
	move.l %a6,%d0
	movem.l (%sp),#31996
	lea (52,%sp),%sp
	rts
	.size	store_mask, .-store_mask
	.align	2
	.type	sg_read, @function
sg_read:
	lea (-16,%sp),%sp
	movem.l #1036,(%sp)
	move.l 28(%sp),-(%sp)
	move.l 28(%sp),-(%sp)
	move.l 28(%sp),-(%sp)
	pea sl_io_path
	jsr (sg_path.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L387
	pea 512.w
	pea sl_io_sector
	pea .LC5
	pea sl_io_path
	pea sl_io_object
	jsr sl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L396
	lea sl_io_object,%a2
	move.l (%a2),-(%sp)
	jsr sl_io_fs_size
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jge .L397
	move.l %a2,-(%sp)
	move.l %d0,16(%sp)
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l 12(%sp),%d1
.L367:
	movem.l (%sp),#1036
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L397:
	moveq #32,%d3
	cmp.l %d0,%d3
	jcs .L398
	move.l %d0,-(%sp)
	pea sl_io_file
	pea sl_io_object
	move.l %d1,24(%sp)
	jsr sl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d2
	mov3q.l #1,%d0
	move.l 12(%sp),%d1
	cmp.l %d2,%d0
	jeq .L399
.L372:
	tst.l %d2
	jlt .L400
.L380:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
.L375:
	movem.l (%sp),#1036
	moveq #-60,%d1
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L396:
	moveq #-12,%d0
	cmp.l %d1,%d0
	jeq .L388
	moveq #-10,%d2
	cmp.l %d1,%d2
	jeq .L375
	movem.l (%sp),#1036
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L398:
	moveq #32,%d0
	move.l %d0,-(%sp)
	pea sl_io_file
	pea sl_io_object
	move.l %d1,24(%sp)
	jsr sl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d2
	mov3q.l #1,%d0
	move.l 12(%sp),%d1
	cmp.l %d2,%d0
	jne .L372
.L399:
	lea .LC11,%a0
	clr.l %d0
	lea sl_io_file,%a2
.L373:
	mvz.b (%a2,%d0.l),%d3
	mvz.b (%a0),%d2
	addq.l #1,%a0
	addq.l #1,%d0
	cmp.l %d3,%d2
	jne .L380
	moveq #8,%d2
	cmp.l %d0,%d2
	jne .L373
	moveq #9,%d3
	cmp.l %d1,%d3
	jcc .L380
	tst.b sl_io_file+8.l
	jne .L379
	mvz.b sl_io_file+9,%d0
	subq.l #1,%d0
	tst.l %d0
	jeq .L401
.L379:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	movem.l (%sp),#1036
	moveq #-61,%d1
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L400:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l %d2,%d1
	move.l %d1,%d0
	movem.l (%sp),#1036
	lea (16,%sp),%sp
	rts
.L388:
	movem.l (%sp),#1036
	mov3q.l #1,%d1
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L401:
	moveq #15,%d3
	cmp.l %d1,%d3
	jcc .L380
	mvz.b sl_io_file+11,%d0
	moveq #32,%d2
	cmp.l %d0,%d2
	jne .L379
	move.b sl_io_file+14,%d3
	move.b sl_io_file+10,%d0
	move.b sl_io_file+15,%d2
	move.w %d3,%a0
	move.l %a0,%d3
	or.l %d3,%d0
	or.l %d2,%d0
	tst.b %d0
	jne .L379
	cmp.l #32800,%d1
	jne .L380
	move.l #32768,-(%sp)
	pea sl_io_file+32
	pea sl_io_object
	jsr sl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L402
	tst.l %d1
	jge .L380
	pea sl_io_object
	move.l %d1,16(%sp)
	jsr sl_io_fs_close
	addq.l #4,%sp
	movem.l (%sp),#1036
	move.l 12(%sp),%d1
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L402:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L367
	tst.b sl_io_file+12.l
	jne .L375
	mvz.b sl_io_file+13,%d0
	cmp.l 24(%sp),%d0
	jne .L375
	mvz.w #32768,%d1
	cmp.l sl_io_file+16.l,%d1
	jne .L375
	mov3q.l #-1,%d1
	lea sl_io_file,%a0
	lea sl_crc_table,%a2
.L383:
	mvz.b (%a0)+,%d0
	move.l %d1,%d2
	lsr.l #8,%d2
	eor.l %d1,%d0
	mvz.b %d0,%d0
	move.l (%a2,%d0.l*4),%d1
	eor.l %d2,%d1
	cmp.l #sl_io_file+28,%a0
	jne .L383
	not.l %d1
	cmp.l sl_io_file+28.l,%d1
	jne .L375
	mov3q.l #-1,%d1
	lea sl_io_file+32,%a1
.L384:
	mvz.b (%a1)+,%d0
	move.l %d1,%d2
	lsr.l #8,%d2
	eor.l %d1,%d0
	mvz.b %d0,%d0
	move.l (%a2,%d0.l*4),%d1
	eor.l %d2,%d1
	cmp.l #sl_io_file+32800,%a1
	jne .L384
	not.l %d1
	cmp.l sl_io_file+24.l,%d1
	jne .L375
	lea sl_io_file+32,%a0
.L385:
	move.b (%a0),%d0
	addq.l #1,%a0
	moveq #126,%d2
	add.l #-128,%d0
	mvz.b %d0,%d0
	cmp.l %d0,%d2
	jcc .L375
	cmp.l %a1,%a0
	jne .L385
	movem.l (%sp),#1036
	move.l 32(%sp),%a0
	clr.l %d1
	move.l %d1,%d0
	move.l sl_io_file+20,(%a0)
	lea (16,%sp),%sp
	rts
.L387:
	movem.l (%sp),#1036
	moveq #-63,%d1
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
	.size	sg_read, .-sg_read
	.align	2
	.type	restore_preflight.part.0, @function
restore_preflight.part.0:
	lea (-28,%sp),%sp
	movem.l #16444,(%sp)
	move.l 32(%sp),%d3
	clr.l %d2
	lea read_bank,%a6
.L405:
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	and.l %d3,%d0
	tst.l %d0
	jne .L404
.L407:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L405
	move.l %sp,%d5
	clr.l %d2
	add.l #24,%d5
	lea sg_read,%a6
.L406:
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	and.l %d3,%d0
	tst.l %d0
	jne .L409
.L411:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L406
	movem.l (%sp),#16444
	clr.l %d0
	lea (28,%sp),%sp
	rts
.L404:
	pea 20(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	jsr (%a6)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jcc .L407
	movem.l (%sp),#16444
	lea (28,%sp),%sp
	rts
.L409:
	move.l %d5,-(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	jsr (%a6)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jcc .L411
	moveq #-61,%d1
	cmp.l %d0,%d1
	jeq .L411
	movem.l (%sp),#16444
	lea (28,%sp),%sp
	rts
	.size	restore_preflight.part.0, .-restore_preflight.part.0
	.align	2
	.type	restore_mask, @function
restore_mask:
	link.w %fp,#-52
	movem.l #15612,(%sp)
	move.l 8(%fp),%d5
	move.l %fp,%d6
	clr.l %d2
	subq.l #4,%d6
	lea sc_read,%a2
.L426:
	mov3q.l #1,%d3
	lsl.l %d2,%d3
	move.l %d5,%d0
	and.l %d3,%d0
	tst.l %d0
	jeq .L421
	move.l %d3,%d0
	and.l sc_blocked_mask,%d0
	tst.l %d0
	jeq .L464
.L421:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L426
.L469:
	move.l %fp,%d6
	clr.l %d4
	subq.l #4,%d6
	lea sg_publish,%a3
	lea sl_io_irq_lock,%a4
.L440:
	mov3q.l #1,%d3
	lsl.l %d4,%d3
	move.l %d5,%d0
	and.l %d3,%d0
	tst.l %d0
	jne .L465
.L427:
	addq.l #1,%d4
	moveq #16,%d1
	cmp.l %d4,%d1
	jne .L440
	clr.l %d0
.L420:
	movem.l -52(%fp),#15612
	unlk %fp
	rts
.L464:
	move.l %d6,-(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jeq .L466
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L467
	moveq #-61,%d1
	cmp.l %d0,%d1
	jeq .L468
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L421
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L426
	jra .L469
.L465:
	pea -8(%fp)
	mov3q.l #1,-(%sp)
	move.l %d4,-(%sp)
	pea sl_io_base
	jsr read_bank
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L470
	tst.l %d0
	jne .L420
	clr.l -(%sp)
	move.l %d4,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jne .L420
	or.l %d3,sl_blocked_mask
	pea sl_io_file+32
	move.l -8(%fp),-(%sp)
	move.l %d4,-(%sp)
	move.l %d3,%d2
	not.l %d2
	and.l %d2,sl_ready_mask
	jsr sl_io_core_publish
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L441
	move.l %d3,%d0
	or.l sl_present_mask,%d0
	and.l %d2,sl_io_protected_mask
	clr.l %d2
	lea sg_read,%a2
	lea (sg_write_file.constprop.0),%a5
	move.l %d0,sl_present_mask
.L439:
	mov3q.l #1,%d7
	lsl.l %d2,%d7
	move.l %d3,%d0
	and.l %d7,%d0
	tst.l %d0
	jne .L471
.L432:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jeq .L427
.L463:
	mov3q.l #1,%d7
	lsl.l %d2,%d7
	move.l %d3,%d0
	and.l %d7,%d0
	tst.l %d0
	jeq .L432
.L471:
	move.l %d6,-(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	move.l %d0,-12(%fp)
	tst.l %d0
	jeq .L472
	mov3q.l #1,%d1
	cmp.l -12(%fp),%d1
	jeq .L473
	moveq #-61,%d0
	cmp.l -12(%fp),%d0
	jeq .L460
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	jsr (%a4)
	move.l %d0,-(%sp)
	or.l %d7,sg_blocked_mask
	jsr sl_io_irq_restore
	or.l %d7,sg_present_mask
	lea (16,%sp),%sp
	move.l -12(%fp),%d1
	move.l %d1,sl_io_last_error
	tst.l sl_io_warning
	jne .L432
	move.l %d1,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L463
	jra .L427
.L472:
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr (%a5)
	pea sl_io_file+32
	move.l -4(%fp),-(%sp)
	move.l %d2,-(%sp)
	move.l %d0,-12(%fp)
	jsr (%a3)
	lea (20,%sp),%sp
	or.l %d7,sg_present_mask
	tst.l -12(%fp)
	jeq .L432
	move.l -12(%fp),%d0
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L432
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L463
	jra .L427
.L460:
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	jsr (%a4)
	addq.l #1,%d2
	move.l %d0,-(%sp)
	or.l %d7,sg_blocked_mask
	jsr sl_io_irq_restore
	or.l %d7,sg_present_mask
	lea (16,%sp),%sp
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L463
	jra .L427
.L473:
	move.l %d7,%d0
	and.l sg_blocked_mask,%d0
	tst.l %d0
	jne .L460
	move.l %d6,-(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	moveq #-61,%d1
	cmp.l %d0,%d1
	jeq .L460
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	pea sl_io_path
	jsr (sg_path.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jeq .L474
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	not.l %d7
	lea (12,%sp),%sp
	and.l %d7,sg_present_mask
.L475:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L463
	jra .L427
.L466:
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr (sc_write_file.constprop.0)
	pea sl_io_file+32
	move.l -4(%fp),-(%sp)
	move.l %d2,-(%sp)
	move.l %d0,%d3
	jsr sc_publish
	lea (20,%sp),%sp
	tst.l %d3
	jeq .L421
	move.l %d3,sl_io_last_error
	tst.l sl_io_warning
	jne .L421
	move.l %d3,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L426
	jra .L469
.L470:
	clr.l -(%sp)
	move.l %d4,-(%sp)
	pea sl_io_base
	pea sl_io_path
	jsr (path_for.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L429
	pea sl_io_path
	jsr sl_io_fs_remove
	addq.l #4,%sp
	tst.l %d0
	jge .L429
	moveq #-12,%d1
	cmp.l %d0,%d1
	jne .L420
.L429:
	move.l %d4,-(%sp)
	jsr fresh_bank
	move.l %d3,%d2
	not.l %d2
	addq.l #4,%sp
	lea sg_read,%a2
	move.l %d2,%d0
	and.l sl_present_mask,%d0
	and.l %d2,sl_io_protected_mask
	clr.l %d2
	lea (sg_write_file.constprop.0),%a5
	move.l %d0,sl_present_mask
	jra .L439
.L474:
	pea sl_io_path
	jsr sl_io_fs_remove
	addq.l #4,%sp
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	not.l %d7
	lea (12,%sp),%sp
	and.l %d7,sg_present_mask
	jra .L475
.L468:
	jsr sl_io_irq_lock
	or.l %d3,sc_blocked_mask
	not.l %d3
	addq.l #1,%d2
	move.l %d0,-(%sp)
	and.l %d3,sc_ready_mask
	jsr sl_io_irq_restore
	addq.l #4,%sp
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L426
	jra .L469
.L467:
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	pea sl_io_path
	jsr (sc_path.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jeq .L476
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr sc_publish
	lea (12,%sp),%sp
.L477:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L426
	jra .L469
.L476:
	pea sl_io_path
	jsr sl_io_fs_remove
	addq.l #4,%sp
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr sc_publish
	lea (12,%sp),%sp
	jra .L477
.L441:
	movem.l -52(%fp),#15612
	moveq #-60,%d0
	unlk %fp
	rts
	.size	restore_mask, .-restore_mask
	.align	2
	.globl	sl_io_play_tick
	.type	sl_io_play_tick, @function
sl_io_play_tick:
	move.l %d2,-(%sp)
	tst.l sl_io_loaded
	jne .L491
.L479:
	clr.l sl_io_play_ticks
.L478:
	move.l (%sp)+,%d2
	rts
.L491:
	move.l sl_dirty_mask,%d1
	move.l sl_ready_mask,%a0
	move.l %a0,%d2
	move.l sl_blocked_mask,%d0
	and.l %d2,%d1
	or.l sl_io_protected_mask,%d0
	not.l %d0
	and.l %d1,%d0
	tst.l %d0
	jne .L480
	move.l sg_dirty_mask,%d1
	move.l sl_ready_mask,%a0
	move.l %a0,%d2
	move.l sl_blocked_mask,%d0
	and.l %d2,%d1
	or.l sg_blocked_mask,%d0
	or.l sg_protected_mask,%d0
	not.l %d0
	and.l %d1,%d0
	tst.l %d0
	jne .L480
	move.l sc_dirty_mask,%d0
	move.l sc_ready_mask,%a0
	move.l %a0,%d2
	move.l sc_blocked_mask,%d1
	not.l %d1
	and.l %d2,%d0
	and.l %d1,%d0
	tst.l %d0
	jeq .L479
.L480:
	move.l sl_io_play_ticks,%d0
	moveq #59,%d1
	addq.l #1,%d0
	cmp.l %d0,%d1
	jcc .L492
	clr.l sl_io_play_ticks
	tst.l sl_io_flush_pending
	jne .L478
	tst.l 1175264744
	jne .L478
	mov3q.l #1,%d2
	cmp.l -2147483512.l,%d2
	jeq .L478
	tst.l 269452412
	jne .L478
	jsr sl_io_stock_card_ready
	tst.l %d0
	jeq .L478
	moveq #-128,%d0
	pea sl_io_flush_job
	move.l #1175263182,-(%sp)
	mov3q.l #1,sl_io_flush_pending
	move.b %d0,sl_io_flush_job
	jsr sl_io_queue_post
	addq.l #8,%sp
	move.l (%sp)+,%d2
	rts
.L492:
	move.l (%sp)+,%d2
	move.l %d0,sl_io_play_ticks
	rts
	.size	sl_io_play_tick, .-sl_io_play_tick
	.align	2
	.globl	sl_io_before_job
	.type	sl_io_before_job, @function
sl_io_before_job:
	subq.l #4,%sp
	move.l %d2,-(%sp)
	move.l 12(%sp),%a0
	move.b (%a0),%d1
	mvz.b %d1,%d0
	cmp.l #128,%d0
	jeq .L528
	move.l %d0,sl_io_job_kind
	mov3q.l #2,%d2
	cmp.l %d0,%d2
	jeq .L529
	clr.l sl_io_warning
	moveq #18,%d2
	cmp.l %d0,%d2
	jcs .L495
	move.l #401296,%d2
	btst %d0,%d2
	jeq .L495
	tst.l sl_io_loaded
	jne .L500
	moveq #8,%d1
	cmp.l %d0,%d1
	jeq .L525
	moveq #12,%d1
	cmp.l %d0,%d1
	jeq .L525
.L495:
	clr.l %d0
.L493:
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L529:
	tst.l sl_io_loaded
	jeq .L495
	move.l #65535,-(%sp)
	jsr (flush.part.0.constprop.0)
	addq.l #4,%sp
.L504:
	tst.l %d0
	jeq .L493
	move.l %d0,sl_io_last_error
	move.l sl_io_warning,%d1
	tst.l %d1
	jne .L493
.L502:
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,12(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
.L530:
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L528:
	clr.l sl_io_flush_pending
	tst.l sl_io_loaded
	jeq .L495
	move.l #65535,-(%sp)
	jsr (flush.part.0.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jeq .L493
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L495
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l (%sp)+,%d2
	clr.l %d0
	addq.l #4,%sp
	rts
.L500:
	move.l #65535,-(%sp)
	move.l %d1,8(%sp)
	jsr (flush.part.0.constprop.0)
	move.l 8(%sp),%d1
	addq.l #4,%sp
	and.l #251,%d1
	subq.l #8,%d1
	tst.l %d1
	jne .L504
	tst.l sl_blocked_mask
	jeq .L504
	move.l sl_io_warning,%d1
	moveq #-61,%d0
	move.l %d0,sl_io_last_error
	tst.l %d1
	jne .L493
	jra .L502
.L525:
	tst.l sl_blocked_mask
	jeq .L495
	moveq #-61,%d0
	moveq #-61,%d2
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,12(%sp)
	move.l %d2,sl_io_last_error
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
	jra .L530
	.size	sl_io_before_job, .-sl_io_before_job
	.align	2
	.globl	sl_io_reject_job
	.type	sl_io_reject_job, @function
sl_io_reject_job:
	lea (-12,%sp),%sp
	moveq #20,%d1
	move.l %d2,-(%sp)
	move.l 20(%sp),%a0
	move.l 24(%sp),12(%sp)
	mvz.b (%a0),%d0
	cmp.l %d0,%d1
	jcs .L531
	move.w .L534(%pc,%d0.l*2),%d0
	ext.l %d0
	jmp %pc@(2,%d0:l)
	.balignw 2,0x284c
	.swbeg	&21
.L534:
	.word .L531-.L534
	.word .L531-.L534
	.word .L536-.L534
	.word .L531-.L534
	.word .L539-.L534
	.word .L531-.L534
	.word .L531-.L534
	.word .L539-.L534
	.word .L539-.L534
	.word .L539-.L534
	.word .L537-.L534
	.word .L536-.L534
	.word .L535-.L534
	.word .L531-.L534
	.word .L531-.L534
	.word .L531-.L534
	.word .L531-.L534
	.word .L533-.L534
	.word .L533-.L534
	.word .L533-.L534
	.word .L533-.L534
.L531:
	move.l (%sp)+,%d2
	lea (12,%sp),%sp
	rts
.L539:
	mvz.w #270,%d0
	move.w #271,%a1
	mvz.w #269,%d1
	move.l %d0,4(%sp)
	mvz.w #268,%d0
.L538:
	mvz.b (%a0,%d1.l),%d1
	mvz.b (%a0,%a1.l),%d2
	mvz.b (%a0,%d0.l),%d0
	swap %d1
	clr.w %d1
	move.l %d2,8(%sp)
	moveq #24,%d2
	lsl.l %d2,%d0
	move.l 4(%sp),%d2
	move.l %d1,%a1
	mvz.b (%a0,%d2.l),%d1
	move.l %a1,%d2
	or.l %d2,%d0
	lsl.l #8,%d1
	or.l 8(%sp),%d0
	or.l %d1,%d0
	jeq .L531
	move.l 12(%sp),24(%sp)
	move.l %d0,20(%sp)
	move.l (%sp)+,%d2
	lea (12,%sp),%sp
	jra sl_io_post
.L533:
	moveq #10,%d2
	moveq #9,%d1
	move.w #11,%a1
	move.l %d2,4(%sp)
	moveq #8,%d0
	jra .L538
.L536:
	moveq #8,%d2
	mov3q.l #7,%d1
	move.w #9,%a1
	move.l %d2,4(%sp)
	mov3q.l #6,%d0
	jra .L538
.L537:
	moveq #12,%d0
	moveq #11,%d1
	move.l %d0,4(%sp)
	moveq #10,%d0
	move.w #13,%a1
	jra .L538
.L535:
	mvz.w #528,%d1
	move.w #529,%a1
	mvz.w #526,%d0
	move.l %d1,4(%sp)
	mvz.w #527,%d1
	jra .L538
	.size	sl_io_reject_job, .-sl_io_reject_job
	.align	2
	.globl	sl_io_banks_load
	.type	sl_io_banks_load, @function
sl_io_banks_load:
	lea (-572,%sp),%sp
	movem.l #31996,(%sp)
	move.l 588(%sp),-(%sp)
	move.l 588(%sp),-(%sp)
	move.l 588(%sp),-(%sp)
	move.l 588(%sp),-(%sp)
	lea sl_io_stock_directory,%a3
	jsr sl_io_stock_banks_load
	move.l %d0,60(%sp)
	clr.l -(%sp)
	clr.l -(%sp)
	jsr (%a3)
	lea (24,%sp),%sp
	tst.l %d0
	jeq .L545
	move.l %d0,%a1
	lea (52,%sp),%a0
	lea (312,%sp),%a2
.L548:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L547
	cmp.l %a0,%a2
	jne .L548
.L545:
	movem.l (%sp),#31996
	move.l 44(%sp),%d0
	lea (572,%sp),%sp
	rts
.L547:
	tst.l sl_io_loaded
	jeq .L549
	mov3q.l #4,%d0
	cmp.l sl_io_job_kind.l,%d0
	jeq .L549
	move.b 52(%sp),%d0
	jeq .L619
	lea sl_io_base,%a1
	lea (52,%sp),%a0
.L552:
	mvs.b (%a1),%d1
	mvs.b %d0,%d0
	addq.l #1,%a0
	addq.l #1,%a1
	cmp.l %d1,%d0
	jne .L549
	move.b (%a0),%d0
	jne .L552
	move.b (%a1),%d0
	jeq .L545
.L549:
	clr.l -(%sp)
	clr.l -(%sp)
	jsr (%a3)
	addq.l #8,%sp
	tst.l %d0
	jeq .L554
	move.l %d0,%a1
	move.l %a2,%a0
	lea (572,%sp),%a6
.L556:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L555
	cmp.l %a6,%a0
	jne .L556
.L554:
	moveq #-63,%d1
	move.l %d1,sl_io_last_error
	tst.l sl_io_warning
	jne .L545
	pea -63.w
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	movem.l (%sp),#31996
	move.l 44(%sp),%d0
	lea (572,%sp),%sp
	rts
.L555:
	jsr sl_reset
	jsr sl_clip_reset
	jsr sl_seq_reset
	clr.l sl_io_protected_mask
	clr.l sl_io_loaded
	clr.l sl_io_warning
	clr.l sl_io_last_error
	lea sl_io_base,%a0
.L558:
	addq.l #1,%a0
	addq.l #1,%a2
	move.b -1(%a2),%d0
	move.b %d0,-1(%a0)
	jeq .L557
	cmp.l %a6,%a2
	jne .L558
	clr.b %d1
	move.b %d1,sl_io_base
.L557:
	clr.l %d2
	mov3q.l #1,%d3
	lsl.l %d2,%d3
	clr.l %d0
	pea 48(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	clr.l 64(%sp)
	lea read_bank,%a6
	lea sg_read,%a3
	lea sg_publish,%a4
	move.l %d3,%d4
	not.l %d4
	and.l %d4,%d0
	lea sc_read,%a2
	lea sl_io_irq_restore,%a5
	move.l %d0,sl_present_mask
	jsr (%a6)
	lea (16,%sp),%sp
	move.l %d0,%d7
	mov3q.l #1,%d0
	cmp.l %d7,%d0
	jeq .L559
.L628:
	or.l %d3,sl_present_mask
	tst.l %d7
	jeq .L620
	pea 48(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	jsr (%a6)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L581
	or.l %d3,sl_present_mask
	tst.l %d0
	jne .L581
.L583:
	or.l %d3,sl_blocked_mask
	pea sl_io_file+32
	move.l 52(%sp),-(%sp)
	move.l %d2,-(%sp)
	and.l %d4,sl_ready_mask
	jsr sl_io_core_publish
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L561
	moveq #-61,%d0
	cmp.l %d7,%d0
	jeq .L621
	or.l %d3,sl_io_protected_mask
	tst.l %d7
	jlt .L564
	moveq #-60,%d7
.L564:
	move.l %d7,sl_io_last_error
	tst.l sl_io_warning
	jne .L561
	mov3q.l #1,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
.L561:
	pea 48(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	clr.l 64(%sp)
	and.l %d4,sg_present_mask
	jsr (%a3)
	lea (16,%sp),%sp
	move.l %d0,%d7
	tst.l %d0
	jeq .L622
.L566:
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L623
	pea 48(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	jsr (%a3)
	lea (16,%sp),%sp
	moveq #-61,%d1
	cmp.l %d7,%d1
	jeq .L569
	cmp.l %d0,%d1
	jeq .L569
	tst.l %d0
	jeq .L624
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr (%a4)
	jsr sl_io_irq_lock
	move.l %d0,-(%sp)
	or.l %d3,sg_blocked_mask
	jsr (%a5)
	or.l %d3,sg_present_mask
	move.l %d7,sl_io_last_error
	lea (16,%sp),%sp
	tst.l sl_io_warning
	jne .L567
	move.l %d7,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
.L567:
	pea 48(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	clr.l 64(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	move.l %d0,%d7
	tst.l %d0
	jeq .L625
.L572:
	mov3q.l #1,%d0
	cmp.l %d7,%d0
	jeq .L626
	pea 48(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	moveq #-61,%d1
	cmp.l %d7,%d1
	jeq .L575
	cmp.l %d0,%d1
	jeq .L575
	tst.l %d0
	jeq .L627
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	lea sc_publish,%a0
	jsr (%a0)
	move.l %d7,sl_io_last_error
	lea (12,%sp),%sp
	tst.l sl_io_warning
	jne .L573
	move.l %d7,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
.L573:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jeq .L578
.L630:
	mov3q.l #1,%d3
	lsl.l %d2,%d3
	move.l sl_present_mask,%d0
	pea 48(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	clr.l 64(%sp)
	move.l %d3,%d4
	not.l %d4
	and.l %d4,%d0
	move.l %d0,sl_present_mask
	jsr (%a6)
	lea (16,%sp),%sp
	move.l %d0,%d7
	mov3q.l #1,%d0
	cmp.l %d7,%d0
	jne .L628
.L559:
	pea 48(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	jsr (%a6)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jne .L629
	move.l %d2,-(%sp)
	jsr fresh_bank
	addq.l #4,%sp
	pea 48(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	clr.l 64(%sp)
	and.l %d4,sg_present_mask
	jsr (%a3)
	lea (16,%sp),%sp
	move.l %d0,%d7
	tst.l %d0
	jne .L566
.L622:
	pea sl_io_file+32
	move.l 52(%sp),-(%sp)
	move.l %d2,-(%sp)
	jsr (%a4)
	lea (12,%sp),%sp
	pea 48(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	clr.l 64(%sp)
	or.l %d3,sg_present_mask
	jsr (%a2)
	lea (16,%sp),%sp
	move.l %d0,%d7
	tst.l %d0
	jne .L572
.L625:
	pea sl_io_file+32
	move.l 52(%sp),-(%sp)
	move.l %d2,-(%sp)
	lea sc_publish,%a0
	addq.l #1,%d2
	jsr (%a0)
	lea (12,%sp),%sp
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L630
.L578:
	movem.l (%sp),#31996
	move.l 44(%sp),%d0
	mov3q.l #1,sl_io_loaded
	lea (572,%sp),%sp
	rts
.L620:
	or.l %d3,sl_blocked_mask
	pea sl_io_file+32
	move.l 52(%sp),-(%sp)
	move.l %d2,-(%sp)
	and.l %d4,sl_ready_mask
	jsr sl_io_core_publish
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L561
	pea 48(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	jsr (%a6)
	lea (16,%sp),%sp
	moveq #-61,%d1
	cmp.l %d0,%d1
	jeq .L631
	tst.l %d0
	jge .L561
.L565:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L561
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	jra .L561
.L569:
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr (%a4)
	jsr sl_io_irq_lock
	move.l %d0,-(%sp)
	or.l %d3,sg_blocked_mask
	jsr (%a5)
	lea (16,%sp),%sp
	or.l %d3,sg_present_mask
	moveq #-61,%d0
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L567
	pea -61.w
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	jra .L567
.L575:
	jsr sl_io_irq_lock
	or.l %d3,sc_blocked_mask
	move.l %d0,-(%sp)
	and.l %d4,sc_ready_mask
	jsr (%a5)
	addq.l #4,%sp
	moveq #-61,%d0
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L573
	pea -61.w
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	jra .L573
.L626:
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	lea sc_publish,%a0
	jsr (%a0)
	lea (12,%sp),%sp
	jra .L573
.L623:
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr (%a4)
	lea (12,%sp),%sp
	jra .L567
.L627:
	pea sl_io_file+32
	move.l 52(%sp),-(%sp)
	move.l %d2,-(%sp)
	lea sc_publish,%a0
	jsr (%a0)
	jsr sl_io_irq_lock
	move.l %d0,-(%sp)
	or.l %d3,sc_dirty_mask
	jsr (%a5)
	move.l %d7,sl_io_last_error
	lea (16,%sp),%sp
	tst.l sl_io_warning
	jne .L573
	mov3q.l #1,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	jra .L573
.L624:
	pea sl_io_file+32
	move.l 52(%sp),-(%sp)
	move.l %d2,-(%sp)
	jsr (%a4)
	lea (12,%sp),%sp
	or.l %d3,sg_protected_mask
	or.l %d3,sg_present_mask
	move.l %d7,sl_io_last_error
	tst.l sl_io_warning
	jne .L567
	mov3q.l #1,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	jra .L567
.L621:
	or.l %d3,sl_blocked_mask
	and.l %d4,sl_ready_mask
	or.l %d3,sl_io_protected_mask
	jra .L564
.L631:
	or.l %d3,sl_blocked_mask
	and.l %d4,sl_ready_mask
	move.l %d1,sl_io_last_error
	tst.l sl_io_warning
	jne .L561
	pea -61.w
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	jra .L561
.L581:
	or.l %d3,sl_blocked_mask
	move.l %d7,%d0
	and.l %d4,sl_ready_mask
	jra .L565
.L619:
	move.b sl_io_base,%d0
	jeq .L545
	jra .L549
.L629:
	or.l %d3,sl_present_mask
	tst.l %d0
	jeq .L583
	or.l %d3,sl_blocked_mask
	and.l %d4,sl_ready_mask
	jra .L565
	.size	sl_io_banks_load, .-sl_io_banks_load
	.align	2
	.globl	sl_io_banks_save
	.type	sl_io_banks_save, @function
sl_io_banks_save:
	lea (-288,%sp),%sp
	movem.l #19484,(%sp)
	move.l 304(%sp),-(%sp)
	move.l 304(%sp),-(%sp)
	move.l 304(%sp),-(%sp)
	move.l 304(%sp),-(%sp)
	jsr sl_io_stock_banks_save
	lea (16,%sp),%sp
	move.l sl_io_job_kind,%d1
	subq.l #8,%d1
	move.l %d0,%d3
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jcc .L633
	tst.l %d3
	jlt .L632
	tst.l sl_io_loaded
	jne .L660
.L632:
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (288,%sp),%sp
	rts
.L637:
	tst.l sl_io_loaded
	jeq .L639
	move.b 28(%sp),%d0
	jeq .L680
	lea sl_io_base,%a1
	lea (28,%sp),%a0
.L644:
	mvs.b (%a1),%d1
	mvs.b %d0,%d0
	addq.l #1,%a0
	addq.l #1,%a1
	cmp.l %d0,%d1
	jne .L639
	move.b (%a0),%d0
	jne .L644
	move.b (%a1),%d0
.L641:
	tst.b %d0
	jne .L639
	tst.l %d3
	jlt .L632
.L660:
	move.w 298(%sp),-(%sp)
	clr.w -(%sp)
	jsr (flush.part.0.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jeq .L632
.L684:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L663
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,32(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l 24(%sp),%d0
.L663:
	move.l %d0,%d3
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (288,%sp),%sp
	rts
.L633:
	clr.l -(%sp)
	clr.l -(%sp)
	jsr sl_io_stock_directory
	addq.l #8,%sp
	tst.l %d0
	jeq .L636
	lea (28,%sp),%a6
	move.l %sp,%d2
	move.l %d0,%a1
	add.l #288,%d2
	move.l %a6,%a0
.L638:
	move.b (%a1),%d1
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d1,-1(%a0)
	jeq .L637
	cmp.l %a0,%d2
	jne .L638
	clr.b %d1
	move.b %d1,28(%sp)
.L636:
	clr.b %d0
	moveq #-63,%d1
	clr.l sl_io_loaded
	move.l %d1,sl_io_last_error
	move.b %d0,sl_io_base
	tst.l sl_io_warning
	jne .L642
	pea -63.w
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
.L642:
	tst.l %d3
	jlt .L632
	moveq #-63,%d3
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (288,%sp),%sp
	rts
.L639:
	moveq #9,%d0
	cmp.l sl_io_job_kind.l,%d0
	jeq .L681
	lea sl_io_base,%a0
.L649:
	move.b (%a6),%d0
	addq.l #1,%a0
	addq.l #1,%a6
	move.b %d0,-1(%a0)
	jeq .L648
	cmp.l %a6,%d2
	jne .L649
	clr.b %d0
	move.b %d0,sl_io_base
.L648:
	clr.l sl_io_protected_mask
	mov3q.l #1,sl_io_loaded
	clr.l sg_present_mask
	clr.l sg_protected_mask
	clr.l %d4
	clr.l %d2
	lea (path_for.part.0),%a2
	lea sl_io_fs_open,%a3
.L650:
	sub.l %a6,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	pea sl_io_path
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jeq .L682
.L652:
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jne .L664
.L686:
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L650
	move.l %d4,sl_present_mask
	jsr sl_io_irq_lock
	move.l sl_blocked_mask,%d1
	not.l %d1
	and.l sl_ready_mask,%d1
	move.l %d0,-(%sp)
	or.l %d1,sl_dirty_mask
	jsr sl_io_irq_restore
	addq.l #4,%sp
	tst.l %d3
	jlt .L683
	move.l #65535,-(%sp)
	jsr store_mask
	addq.l #4,%sp
	tst.l %d0
	jeq .L632
	jra .L684
.L682:
	pea 512.w
	pea sl_io_sector
	pea .LC5
	pea sl_io_path
	pea sl_io_object
	jsr (%a3)
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L685
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	or.l %d0,%d4
.L687:
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jeq .L686
.L664:
	mov3q.l #1,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	pea sl_io_path
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L652
	jra .L682
.L685:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jeq .L652
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	or.l %d0,%d4
	jra .L687
.L683:
	move.l %d3,sl_io_last_error
	tst.l sl_io_warning
	jne .L632
	move.l %d3,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (288,%sp),%sp
	rts
.L681:
	jsr sl_reset
	jsr sl_clip_reset
	jsr sl_seq_reset
	mvz.w #65535,%d1
	clr.l sl_present_mask
	clr.l sl_io_warning
	lea sl_io_base,%a0
	move.l %d1,sl_ready_mask
	move.l %d1,sc_ready_mask
	clr.l sl_io_protected_mask
	clr.l sg_protected_mask
	clr.l sl_io_last_error
	jra .L649
.L680:
	move.b sl_io_base,%d0
	jra .L641
	.size	sl_io_banks_save, .-sl_io_banks_save
	.align	2
	.globl	sl_io_card_sync
	.type	sl_io_card_sync, @function
sl_io_card_sync:
	lea (-12,%sp),%sp
	move.l 16(%sp),%d1
	move.l 20(%sp),%a0
	move.l 24(%sp),%a1
	tst.l sl_io_loaded
	jne .L698
.L689:
	move.l %a1,24(%sp)
	move.l %a0,20(%sp)
	move.l %d1,16(%sp)
	lea (12,%sp),%sp
	jra sl_io_stock_card_sync
.L698:
	move.l #65535,-(%sp)
	move.l %d1,12(%sp)
	move.l %a0,8(%sp)
	move.l %a1,4(%sp)
	jsr (flush.part.0.constprop.0)
	addq.l #4,%sp
	move.l 8(%sp),%d1
	move.l 4(%sp),%a0
	move.l (%sp),%a1
	tst.l %d0
	jeq .L689
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L688
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,16(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l 8(%sp),%d0
.L688:
	lea (12,%sp),%sp
	rts
	.size	sl_io_card_sync, .-sl_io_card_sync
	.align	2
	.globl	sl_io_project_store
	.type	sl_io_project_store, @function
sl_io_project_store:
	subq.l #4,%sp
	move.l 16(%sp),-(%sp)
	move.l 16(%sp),-(%sp)
	move.l 16(%sp),-(%sp)
	jsr sl_io_stock_project_store
	lea (12,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L699
	move.l #65535,-(%sp)
	move.l %d0,4(%sp)
	jsr store_mask
	addq.l #4,%sp
	move.l (%sp),%d1
	tst.l %d0
	jne .L707
.L699:
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L707:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L704
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,8(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l (%sp),%d0
.L704:
	move.l %d0,%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
	.size	sl_io_project_store, .-sl_io_project_store
	.align	2
	.globl	sl_io_bank_store
	.type	sl_io_bank_store, @function
sl_io_bank_store:
	subq.l #4,%sp
	move.l 20(%sp),-(%sp)
	move.l 20(%sp),-(%sp)
	move.l 20(%sp),-(%sp)
	move.l 20(%sp),-(%sp)
	jsr sl_io_stock_bank_store
	lea (16,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L708
	move.w 14(%sp),-(%sp)
	clr.w -(%sp)
	move.l %d0,4(%sp)
	jsr store_mask
	addq.l #4,%sp
	move.l (%sp),%d1
	tst.l %d0
	jne .L716
.L708:
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L716:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L713
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,8(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l (%sp),%d0
.L713:
	move.l %d0,%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
	.size	sl_io_bank_store, .-sl_io_bank_store
	.align	2
	.globl	sl_io_project_restore
	.type	sl_io_project_restore, @function
sl_io_project_restore:
	move.l sl_blocked_mask,%d0
	subq.l #4,%sp
	mvz.w %d0,%d0
	tst.l %d0
	jne .L727
	move.l #65535,-(%sp)
	jsr (restore_preflight.part.0)
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jne .L718
	move.l 16(%sp),-(%sp)
	move.l 16(%sp),-(%sp)
	move.l 16(%sp),-(%sp)
	jsr sl_io_stock_project_restore
	lea (12,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L717
	move.l #65535,-(%sp)
	move.l %d0,4(%sp)
	jsr restore_mask
	addq.l #4,%sp
	move.l (%sp),%d1
	tst.l %d0
	jne .L730
.L717:
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L727:
	moveq #-61,%d1
.L718:
	move.l %d1,sl_io_last_error
	tst.l sl_io_warning
	jne .L717
	move.l %d1,-(%sp)
	pea sl_io_ui_warning
	move.l %d1,8(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l (%sp),%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L730:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L726
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,8(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l (%sp),%d0
.L726:
	move.l %d0,%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
	.size	sl_io_project_restore, .-sl_io_project_restore
	.align	2
	.globl	sl_io_bank_restore
	.type	sl_io_bank_restore, @function
sl_io_bank_restore:
	subq.l #4,%sp
	move.l %d2,-(%sp)
	move.l 16(%sp),%d2
	mvz.w %d2,%d2
	move.l %d2,%d0
	and.l sl_blocked_mask,%d0
	tst.l %d0
	jne .L740
	move.l %d2,-(%sp)
	jsr (restore_preflight.part.0)
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jne .L732
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	jsr sl_io_stock_bank_restore
	lea (16,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L731
	move.l %d2,-(%sp)
	move.l %d0,8(%sp)
	jsr restore_mask
	addq.l #4,%sp
	move.l 4(%sp),%d1
	tst.l %d0
	jne .L746
.L731:
	move.l (%sp)+,%d2
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L740:
	moveq #-61,%d1
.L732:
	move.l %d1,sl_io_last_error
	tst.l sl_io_warning
	jne .L731
	move.l %d1,-(%sp)
	pea sl_io_ui_warning
	move.l %d1,12(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d1
	move.l %d1,%d0
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L746:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L739
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,12(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
.L739:
	move.l (%sp)+,%d2
	move.l %d0,%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
	.size	sl_io_bank_restore, .-sl_io_bank_restore
	.align	2
	.globl	sl_io_clear
	.type	sl_io_clear, @function
sl_io_clear:
	jsr sl_io_stock_clear
	jsr sl_reset
	jsr sl_clip_reset
	jsr sl_seq_reset
	clr.b %d0
	clr.l sl_io_protected_mask
	clr.l sl_io_last_error
	clr.l sl_io_loaded
	clr.l sl_io_warning
	clr.l sl_present_mask
	clr.l sg_present_mask
	clr.l sg_protected_mask
	move.b %d0,sl_io_base
	rts
	.size	sl_io_clear, .-sl_io_clear
	.align	2
	.globl	sl_io_delete
	.type	sl_io_delete, @function
sl_io_delete:
	lea (-284,%sp),%sp
	movem.l #19468,(%sp)
	move.l 292(%sp),-(%sp)
	move.l 292(%sp),-(%sp)
	jsr sl_io_stock_directory
	addq.l #8,%sp
	tst.l %d0
	jeq .L750
	move.l %sp,%d3
	add.l #24,%d3
	move.l %d0,%a1
	move.l %d3,%a0
	lea (284,%sp),%a6
.L752:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L774
	cmp.l %a0,%a6
	jne .L752
.L750:
	moveq #-63,%d0
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L753
	pea -63.w
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
.L753:
	moveq #-63,%d0
.L749:
	movem.l (%sp),#19468
	lea (284,%sp),%sp
	rts
.L774:
	clr.l %d2
	lea (path_for.part.0),%a3
	lea sl_io_fs_remove,%a2
.L751:
	sub.l %a6,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	move.l %d3,-(%sp)
	pea sl_io_path
	jsr (%a3)
	lea (16,%sp),%sp
	tst.l %d0
	jeq .L797
.L778:
	moveq #-63,%d0
.L760:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L749
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,28(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	movem.l (%sp),#19468
	move.l 20(%sp),%d0
	lea (284,%sp),%sp
	rts
.L797:
	pea sl_io_path
	jsr (%a2)
	addq.l #4,%sp
	tst.l %d0
	jlt .L798
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jne .L776
.L801:
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L751
	sub.l %a6,%a6
	lea (sc_path.part.0),%a3
.L759:
	clr.l %d2
.L762:
	move.l %d2,-(%sp)
	move.l %a6,-(%sp)
	move.l %d3,-(%sp)
	pea sl_io_path
	jsr (%a3)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L778
	pea sl_io_path
	jsr (%a2)
	addq.l #4,%sp
	tst.l %d0
	jlt .L799
	subq.l #1,%d2
	tst.l %d2
	jne .L779
.L802:
	addq.l #1,%a6
	moveq #16,%d1
	cmp.l %a6,%d1
	jne .L759
	sub.l %a3,%a3
	lea (sg_path.part.0),%a6
.L763:
	clr.l %d2
.L766:
	move.l %d2,-(%sp)
	move.l %a3,-(%sp)
	move.l %d3,-(%sp)
	pea sl_io_path
	jsr (%a6)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L778
	pea sl_io_path
	jsr (%a2)
	addq.l #4,%sp
	tst.l %d0
	jlt .L800
	subq.l #1,%d2
	tst.l %d2
	jne .L782
.L803:
	addq.l #1,%a3
	moveq #16,%d1
	cmp.l %a3,%d1
	jne .L763
	move.l 292(%sp),-(%sp)
	move.l 292(%sp),-(%sp)
	jsr sl_io_stock_delete
	addq.l #8,%sp
	tst.l %d0
	jlt .L760
	movem.l (%sp),#19468
	lea (284,%sp),%sp
	rts
.L798:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jne .L760
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jeq .L801
.L776:
	mov3q.l #1,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	move.l %d3,-(%sp)
	pea sl_io_path
	jsr (%a3)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L778
	jra .L797
.L799:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jne .L760
	subq.l #1,%d2
	tst.l %d2
	jeq .L802
.L779:
	mov3q.l #1,%d2
	jra .L762
.L800:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jne .L760
	subq.l #1,%d2
	tst.l %d2
	jeq .L803
.L782:
	mov3q.l #1,%d2
	jra .L766
	.size	sl_io_delete, .-sl_io_delete
	.align	2
	.globl	sl_io_export
	.type	sl_io_export, @function
sl_io_export:
	lea (-1088,%sp),%sp
	movem.l #19580,(%sp)
	move.l %sp,%d2
	add.l #48,%d2
	lea sl_io_base,%a0
	move.l %d2,%a1
.L806:
	move.b (%a0),%d0
	addq.l #1,%a1
	addq.l #1,%a0
	move.b %d0,-1(%a1)
	jeq .L805
	cmp.l #sl_io_base+260,%a0
	jne .L806
.L807:
	moveq #-63,%d1
	move.l %d1,36(%sp)
.L804:
	movem.l (%sp),#19580
	move.l 36(%sp),%d0
	lea (1088,%sp),%sp
	rts
.L805:
	move.l 1100(%sp),-(%sp)
	move.l 1100(%sp),-(%sp)
	jsr sl_io_stock_directory
	move.l %sp,%d5
	add.l #316,%d5
	addq.l #8,%sp
	move.l %d5,%a2
	move.l %d5,%a0
	addq.l #1,%a0
	move.l %d0,%a1
	addq.l #1,%a1
	move.b -1(%a1),%d0
	lea (568,%sp),%a6
	move.b %d0,-1(%a0)
	jeq .L870
.L808:
	cmp.l %a6,%a0
	jeq .L807
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jne .L808
.L870:
	move.b 48(%sp),%d0
	move.l %d2,%a0
	tst.b %d0
	jeq .L871
.L809:
	mvs.b (%a2),%d1
	mvs.b %d0,%d0
	addq.l #1,%a0
	addq.l #1,%a2
	cmp.l %d1,%d0
	jne .L814
	move.b (%a0),%d0
	jne .L809
	move.b (%a2),%d0
	jeq .L807
.L814:
	move.l 1108(%sp),-(%sp)
	move.l 1108(%sp),-(%sp)
	move.l 1108(%sp),-(%sp)
	move.l 1108(%sp),-(%sp)
	move.l 1108(%sp),-(%sp)
	jsr sl_io_stock_export
	move.l %d0,56(%sp)
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L804
	move.l %sp,%d6
	clr.l %d4
	lea read_bank,%a3
	add.l #828,%d6
	lea (path_for.part.0),%a2
.L815:
	clr.l %d3
.L820:
	pea 40(%sp)
	move.l %d3,-(%sp)
	move.l %d4,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L816
	tst.l %d0
	jne .L824
	move.l %d3,-(%sp)
	move.l %d4,-(%sp)
	move.l %d2,-(%sp)
	move.l %a6,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L807
	move.l %d3,-(%sp)
	move.l %d4,-(%sp)
	move.l %d5,-(%sp)
	move.l %d6,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L807
	clr.l -(%sp)
	move.l %a6,-(%sp)
	move.l %d6,-(%sp)
	jsr sl_io_fs_copy
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L824
.L816:
	subq.l #1,%d3
	tst.l %d3
	jne .L841
	addq.l #1,%d4
	moveq #16,%d1
	cmp.l %d4,%d1
	jne .L815
	move.l %sp,%d6
	clr.l %d4
	add.l #44,%d6
	lea sc_read,%a3
	lea (sc_path.part.0),%a2
.L821:
	clr.l %d3
.L825:
	move.l %d6,-(%sp)
	move.l %d3,-(%sp)
	move.l %d4,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (16,%sp),%sp
	subq.l #1,%d0
	tst.l %d0
	jeq .L822
	move.l %d3,-(%sp)
	move.l %d4,-(%sp)
	move.l %d2,-(%sp)
	move.l %a6,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L823
	move.l %d3,-(%sp)
	move.l %d4,-(%sp)
	move.l %d5,-(%sp)
	pea 840(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L823
	clr.l -(%sp)
	move.l %a6,-(%sp)
	pea 836(%sp)
	jsr sl_io_fs_copy
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L824
.L822:
	subq.l #1,%d3
	tst.l %d3
	jne .L843
	addq.l #1,%d4
	moveq #16,%d1
	cmp.l %d4,%d1
	jne .L821
	clr.l %d4
	lea (sg_path.part.0),%a2
	clr.l %d3
	lea (828,%sp),%a3
.L832:
	move.l %d6,-(%sp)
	move.l %d3,-(%sp)
	move.l %d4,-(%sp)
	move.l %d2,-(%sp)
	jsr sg_read
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L828
	tst.l %d0
	jeq .L829
	moveq #-61,%d1
	cmp.l %d0,%d1
	jne .L824
.L829:
	move.l %d3,-(%sp)
	move.l %d4,-(%sp)
	move.l %d2,-(%sp)
	move.l %a6,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L823
	move.l %d3,-(%sp)
	move.l %d4,-(%sp)
	move.l %d5,-(%sp)
	move.l %a3,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L823
	clr.l -(%sp)
	move.l %a6,-(%sp)
	move.l %a3,-(%sp)
	jsr sl_io_fs_copy
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L824
.L828:
	subq.l #1,%d3
	tst.l %d3
	jne .L844
	addq.l #1,%d4
	moveq #16,%d1
	cmp.l %d4,%d1
	jeq .L804
	clr.l %d3
	jra .L832
.L823:
	moveq #-63,%d0
.L824:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L834
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,40(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l 32(%sp),%d0
.L834:
	movem.l (%sp),#19580
	move.l %d0,36(%sp)
	move.l 36(%sp),%d0
	lea (1088,%sp),%sp
	rts
.L841:
	mov3q.l #1,%d3
	jra .L820
.L843:
	mov3q.l #1,%d3
	jra .L825
.L871:
	move.b 308(%sp),%d0
	jne .L814
	jra .L807
.L844:
	mov3q.l #1,%d3
	jra .L832
	.size	sl_io_export, .-sl_io_export
	.local	sg_present_mask
.section .data
.balign 4
sg_present_mask:
.space 4
	.globl	sg_protected_mask
	.section	.data
	.align	2
	.type	sg_protected_mask, @object
	.size	sg_protected_mask, 4
sg_protected_mask:
	.zero	4
	.local	sl_io_play_ticks
.section .data
.balign 4
sl_io_play_ticks:
.space 4
	.local	sl_io_flush_pending
.section .data
.balign 4
sl_io_flush_pending:
.space 4
	.local	sl_io_flush_job
.section .data
.balign 4
sl_io_flush_job:
.space 16
	.local	sl_present_mask
.section .data
.balign 4
sl_present_mask:
.space 4
	.local	sl_io_warning
.section .data
.balign 4
sl_io_warning:
.space 4
	.local	sl_io_job_kind
.section .data
.balign 4
sl_io_job_kind:
.space 4
	.local	sl_io_loaded
.section .data
.balign 4
sl_io_loaded:
.space 4
	.globl	sl_io_protected_mask
	.align	2
	.type	sl_io_protected_mask, @object
	.size	sl_io_protected_mask, 4
sl_io_protected_mask:
	.zero	4
	.globl	sl_io_last_error
	.align	2
	.type	sl_io_last_error, @object
	.size	sl_io_last_error, 4
sl_io_last_error:
	.zero	4
	.local	sl_io_object
.section .data
.balign 4
sl_io_object:
.space 24
	.local	sl_io_sector
.section .data
.balign 4
sl_io_sector:
.space 512
	.local	sl_io_file
.section .data
.balign 4
sl_io_file:
.space 49184
	.local	sl_io_path
.section .data
.balign 4
sl_io_path:
.space 260
	.local	sl_io_base
.section .data
.balign 4
sl_io_base:
.space 260

        .section .text
sl_io_core_bank:
        move.l 4(%sp),%d0
        bsr sl_bank_ptr
        move.l %a0,%d0
        rts
sl_io_core_validate:
        move.l %a2,-(%sp)
        move.l 8(%sp),%d0
        move.l 12(%sp),%a0
        move.l 16(%sp),%d1
        move.l 20(%sp),%a2
        bsr sl_file_validate
        move.l %d1,(%a2)
        move.l (%sp)+,%a2
        rts
sl_io_core_pack:
        move.l 4(%sp),%d0
        move.l 8(%sp),%d1
        move.l 12(%sp),%a0
        move.l 16(%sp),%a1
        bra sl_file_pack
sl_io_core_publish:
        move.l 4(%sp),%d0
        move.l 8(%sp),%d1
        move.l 12(%sp),%a0
        bra sl_bank_publish
sl_io_core_seal:
        move.l 4(%sp),%d0
        move.l 8(%sp),%d1
        move.l 12(%sp),%a1
        bra sl_file_seal
sl_io_fs_open:
        jmp 0x40016864:l
sl_io_fs_read:
        jmp 0x40016564:l
sl_io_fs_write:
        jmp 0x400166b8:l
sl_io_fs_close:
        jmp 0x4001677c:l
sl_io_fs_size:
        move.l 0x46c8241e:l,%a0
        jmp (%a0)
sl_io_fs_copy:
        jmp 0x40016388:l
sl_io_fs_remove:
        move.l 0x46c82432:l,%a0
        jmp (%a0)
sl_io_stock_directory:
        jmp 0x40025230:l
sl_io_stock_card_ready:
        jmp 0x400255ec:l
sl_io_queue_post:
        jmp 0x40000c3c:l
sl_io_post:
        jmp 0x40084110:l
sl_io_toast:
        jmp 0x4005a2b8:l
sl_io_irq_lock:
        moveq #0,%d0
        move.w %sr,%d0
        move.w #0x2700,%sr
        rts
sl_io_irq_restore:
        move.l 4(%sp),%d0
        move.w %d0,%sr
        rts
| Displaced dispatcher switch prefix; a2 remains the stable stock job.
sl_io_dispatch:
        lea -16(%sp),%sp
        movem.l %d0-%d1/%a0-%a1,(%sp)
        move.l %a2,-(%sp)
        bsr sl_io_before_job
        addq.l #4,%sp
        tst.l %d0
        bpl sl_io_dispatch_resume
        move.l %d0,-(%sp)
        move.l %a2,-(%sp)
        bsr sl_io_reject_job
        addq.l #8,%sp
        movem.l (%sp),%d0-%d1/%a0-%a1
        lea 16(%sp),%sp
        jmp 0x4008484e:l
sl_io_dispatch_resume:
        movem.l (%sp),%d0-%d1/%a0-%a1
        lea 16(%sp),%sp
        mvz.b (%a2),%d0
        moveq #45,%d1
        cmp.l %d0,%d1
        jmp 0x40084864:l
| Existing UI timer schedules stock engine job2 when SY locks alone are dirty.
| No filesystem call, core call, allocation, or new queue descriptor here.
sl_io_background_request:
        and.l %d1,%d0
        bne sl_io_background_yes
        move.l %d1,-(%sp)
        move.l sl_dirty_mask:l,%d0
        and.l sl_ready_mask:l,%d0
        move.l sl_blocked_mask:l,%d1
        or.l sl_io_protected_mask:l,%d1
        not.l %d1
        and.l %d1,%d0
        tst.l %d0
        bne sl_io_background_some
        move.l sg_dirty_mask:l,%d0       | the G..J lock files (sylkgj) alone dirty
        and.l sl_ready_mask:l,%d0
        move.l sl_blocked_mask:l,%d1
        or.l sg_blocked_mask:l,%d1
        or.l sg_protected_mask:l,%d1
        not.l %d1
        and.l %d1,%d0
        tst.l %d0
        bne sl_io_background_some
        move.l sc_dirty_mask:l,%d0       | (2.18) the setup scene files (syscen) alone dirty
        and.l sc_ready_mask:l,%d0
        move.l sc_blocked_mask:l,%d1
        not.l %d1
        and.l %d1,%d0
        tst.l %d0
sl_io_background_some:
        move.l (%sp)+,%d1
        tst.l %d0
        beq sl_io_background_no
sl_io_background_yes:
        moveq #1,%d0
        jmp 0x40022c1c:l
sl_io_background_no:
        jmp 0x40022c70:l
| The UI tick's transport test (0x4005224a; d0 = the sequencer state 0x800065b8): stopped
| (0) or 2 continue to stock's background save counter; otherwise stock clears that counter
| (0x40052278) and the lock files get their own flush (sl_io_play_tick).
sl_io_tick_hook:
        tst.l %d0
        beq sl_io_tick_stock
        moveq #2,%d1
        cmp.l %d0,%d1
        beq sl_io_tick_stock
        lea -16(%sp),%sp
        movem.l %d0-%d1/%a0-%a1,(%sp)
        bsr sl_io_play_tick
        movem.l (%sp),%d0-%d1/%a0-%a1
        lea 16(%sp),%sp
        jmp 0x40052278:l
sl_io_tick_stock:
        jmp 0x40052254:l

sl_io_stock_banks_load:
lea -328(%sp),%sp
movem.l %d2-%d7/%a2-%a6,(%sp)
jmp 0x400905dc:l

sl_io_stock_banks_save:
link.w %a6,#-324
movem.l %d2-%d7/%a2-%a5,(%sp)
jmp 0x400917d0:l

sl_io_stock_card_sync:
lea -12(%sp),%sp
movem.l %d2-%d4,(%sp)
jmp 0x400919ec:l

sl_io_stock_project_store:
link.w %a6,#-560
movem.l %d2-%d7/%a2-%a5,(%sp)
jmp 0x4008ee7c:l

sl_io_stock_project_restore:
link.w %a6,#-560
movem.l %d2-%d7/%a2-%a5,(%sp)
jmp 0x4008f188:l

sl_io_stock_bank_store:
lea -564(%sp),%sp
movem.l %d2-%d7/%a2-%a6,(%sp)
jmp 0x4008edac:l

sl_io_stock_bank_restore:
lea -564(%sp),%sp
movem.l %d2-%d7/%a2-%a6,(%sp)
jmp 0x4008f0b8:l

sl_io_stock_export:
lea -104(%sp),%sp
movem.l %d2-%d7/%a2-%a5,(%sp)
jmp 0x400912cc:l

sl_io_stock_clear:
move.l %a2,-(%sp)
clr.l -(%sp)
jsr 0x4000fd34:l
jmp 0x400909e2:l

sl_io_stock_delete:
lea -324(%sp),%sp
movem.l %d2-%d5/%a2-%a3,(%sp)
jmp 0x4008ec54:l

.section .text
