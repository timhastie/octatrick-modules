| GENERATED from tools/locks_io.c; do not edit.
| Run python3 synth/tools/gen_locks_io.py (m68k-elf-gcc on PATH)
| Source SHA256 (the .c and migration_io.h) cee05f06108bea13446353eedd0a8a713ece891c2cc61fe08cae446f0ba43119
.if FL_PACKAGE
#NO_APP
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"FM LOCK FILE ERROR"
.LC1:
	.string	"FM LOCKS RECOVERED"
.LC2:
	.string	"FM LOCKS FULL"
	.text
	.align	2
	.globl	fl_io_ui_warning
	.type	fl_io_ui_warning, @function
fl_io_ui_warning:
	move.l 4(%sp),%d0
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L3
	moveq #-64,%d1
	cmp.l %d0,%d1
	jeq .L7
	move.l #.LC0,%d0
	pea 48.w
	move.l %d0,-(%sp)
	jsr fl_io_toast
	addq.l #8,%sp
	rts
.L7:
	move.l #.LC2,%d0
	pea 48.w
	move.l %d0,-(%sp)
	jsr fl_io_toast
	addq.l #8,%sp
	rts
.L3:
	move.l #.LC1,%d0
	pea 48.w
	move.l %d0,-(%sp)
	jsr fl_io_toast
	addq.l #8,%sp
	rts
	.size	fl_io_ui_warning, .-fl_io_ui_warning
	.align	2
	.type	fresh_bank, @function
fresh_bank:
	lea (-12,%sp),%sp
	movem.l #28,(%sp)
	move.l 16(%sp),%d3
	mov3q.l #1,%d2
	lsl.l %d3,%d2
	move.l %d3,-(%sp)
	jsr fl_io_core_free
	move.w %d3,%d0
	addq.l #4,%sp
	move.l %d2,%d4
	not.l %d4
	and.l %d4,fl_io_pool_mask
	mulu.w #160,%d0
	move.l %d0,%a0
	add.l #fl_migration_table+160,%d0
	add.l #fl_migration_table,%a0
.L9:
	clr.b (%a0)+
	cmp.l %a0,%d0
	jne .L9
	jsr fl_io_irq_lock
	lea fl_generation,%a0
	clr.l (%a0,%d3.l*4)
	or.l %d2,fl_ready_mask
	move.l %d0,16(%sp)
	and.l %d4,fl_dirty_mask
	and.l %d4,fl_blocked_mask
	movem.l (%sp),#28
	lea (12,%sp),%sp
	jra fl_io_irq_restore
	.size	fresh_bank, .-fresh_bank
	.align	2
	.type	snapshot, @function
snapshot:
	lea (-24,%sp),%sp
	movem.l #3132,(%sp)
	move.l 28(%sp),%d2
	mov3q.l #3,%d3
	lea fl_generation,%a2
	lea fl_io_core_pack,%a3
.L18:
	move.l (%a2,%d2.l*4),%d4
	pea fl_io_file
	move.l fl_lane_gen,%d5
	move.l %d4,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L19
	subq.l #1,%d3
	cmp.l (%a2,%d2.l*4),%d4
	jeq .L25
.L15:
	tst.l %d3
	jne .L18
	movem.l (%sp),#3132
	moveq #-62,%d0
	lea (24,%sp),%sp
	rts
.L25:
	cmp.l fl_lane_gen.l,%d5
	jne .L15
	lea fl_io_file+32,%a1
	clr.l %d1
	lea fl_io_file+18464,%a0
.L16:
	move.b (%a1)+,%d0
	not.l %d0
	mvz.b %d0,%d0
	or.l %d0,%d1
	cmp.l #fl_io_file+18464,%a1
	jne .L16
	lea fl_io_file+18624,%a1
.L17:
	mvz.b (%a0)+,%d0
	or.l %d0,%d1
	cmp.l %a1,%a0
	jne .L17
	tst.l %d1
	sne %d1
	move.l 32(%sp),%a0
	clr.l %d0
	move.l %d4,(%a0)
	movem.l (%sp),#3132
	move.l 36(%sp),%a0
	mvs.b %d1,%d1
	neg.l %d1
	move.l %d1,(%a0)
	lea (24,%sp),%sp
	rts
.L19:
	movem.l (%sp),#3132
	moveq #-60,%d0
	lea (24,%sp),%sp
	rts
	.size	snapshot, .-snapshot
	.section	.rodata.str1.1
.LC3:
	.string	"fmlock"
.LC4:
	.string	".strd"
.LC5:
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
	jeq .L29
.L27:
	move.b %d1,(%a2,%d0.l)
	move.l %d0,%a0
	addq.l #1,%d0
	move.b (%a1,%d0.l),%d1
	jeq .L48
	cmp.l #245,%d0
	jne .L27
.L29:
	movem.l (%sp),#3076
	moveq #-63,%d0
	lea (12,%sp),%sp
	rts
.L48:
	moveq #47,%d1
	lea 2(%a2,%a0.l),%a3
	lea .LC3,%a1
	move.b %d1,(%a2,%d0.l)
	moveq #102,%d0
.L31:
	move.b %d0,(%a3)+
	addq.l #1,%a1
	move.b (%a1),%d0
	cmp.l #.LC3+6,%a1
	jne .L31
	move.l %d2,%d0
	moveq #9,%d1
	lea 8(%a2,%a0.l),%a1
	addq.l #1,%d0
	cmp.l %d0,%d1
	jcc .L32
	moveq #49,%d1
	add.l #38,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jne .L34
.L49:
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l #.LC5,%d2
	move.l %d2,%a1
.L36:
	move.b %d0,(%a3)+
	move.b 1(%a1),%d0
	addq.l #1,%a1
	tst.b %d0
	jne .L36
	lea 10(%a1,%a0.l),%a0
	clr.l %d0
	move.l %a0,%d1
	sub.l %d2,%d1
	clr.b %d2
	move.b %d2,(%a2,%d1.l)
	movem.l (%sp),#3076
	lea (12,%sp),%sp
	rts
.L32:
	moveq #48,%d1
	move.l %d2,%d0
	add.l #49,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jeq .L49
.L34:
	move.l #.LC4,%d2
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l %d2,%a1
	jra .L36
	.size	path_for.part.0, .-path_for.part.0
	.section	.rodata.str1.1
.LC6:
	.string	"r"
.LC7:
	.string	"FMLOCKS"
	.text
	.align	2
	.type	read_bank, @function
read_bank:
	subq.l #8,%sp
	move.l %d2,-(%sp)
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	pea fl_io_path
	jsr (path_for.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L75
	pea 512.w
	pea fl_io_sector
	pea .LC6
	pea fl_io_path
	pea fl_io_object
	jsr fl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L85
	lea fl_io_object,%a0
	move.l (%a0),-(%sp)
	move.l %a0,8(%sp)
	jsr fl_io_fs_size
	addq.l #4,%sp
	move.l %d0,%d1
	move.l 4(%sp),%a0
	tst.l %d0
	jge .L86
	move.l %a0,-(%sp)
	move.l %d0,8(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l 4(%sp),%d1
.L50:
	move.l (%sp)+,%d2
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L86:
	moveq #32,%d2
	cmp.l %d0,%d2
	jcs .L87
	move.l %d0,-(%sp)
	pea fl_io_file
	pea fl_io_object
	move.l %d1,16(%sp)
	jsr fl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%a0
	mov3q.l #1,%d0
	move.l 4(%sp),%d1
	cmp.l %a0,%d0
	jeq .L88
.L55:
	tst.l %a0
	jlt .L89
.L79:
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
.L81:
	move.l (%sp)+,%d2
	moveq #-60,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L85:
	moveq #-12,%d0
	cmp.l %d1,%d0
	jeq .L76
	moveq #-10,%d2
	cmp.l %d1,%d2
	jeq .L81
	move.l (%sp)+,%d2
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L87:
	moveq #32,%d0
	move.l %d0,-(%sp)
	pea fl_io_file
	pea fl_io_object
	move.l %d1,16(%sp)
	jsr fl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%a0
	mov3q.l #1,%d0
	move.l 4(%sp),%d1
	cmp.l %a0,%d0
	jne .L55
.L88:
	lea .LC7,%a0
	clr.l %d0
.L56:
	lea fl_io_file,%a1
	addq.l #1,%a0
	mvz.b (%a1,%d0.l),%d2
	addq.l #1,%d0
	move.l %d2,8(%sp)
	mvz.b -1(%a0),%d2
	cmp.l 8(%sp),%d2
	jne .L90
	moveq #8,%d2
	cmp.l %d0,%d2
	jne .L56
	moveq #9,%d2
	cmp.l %d1,%d2
	jcc .L79
	tst.b fl_io_file+8.l
	jne .L68
	mvz.b fl_io_file+9,%d0
	subq.l #1,%d0
	tst.l %d0
	jeq .L91
.L68:
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
.L63:
	move.l (%sp)+,%d2
	moveq #-61,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L89:
	pea fl_io_object
	move.l %a0,8(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l 4(%sp),%d1
	move.l %d1,%d0
	move.l (%sp)+,%d2
	addq.l #8,%sp
	rts
.L76:
	move.l (%sp)+,%d2
	mov3q.l #1,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L91:
	moveq #15,%d0
	cmp.l %d1,%d0
	jcc .L79
	tst.b fl_io_file+10.l
	jne .L68
	mvz.b fl_io_file+11,%d0
	moveq #32,%d2
	cmp.l %d0,%d2
	jne .L68
	move.b fl_io_file+15,%d2
	move.b fl_io_file+14,%d0
	move.w %d2,%a0
	move.l %a0,%d2
	or.l %d2,%d0
	tst.b %d0
	jne .L68
.L67:
	cmp.l #18624,%d1
	jne .L79
	pea 18592.w
	pea fl_io_file+32
	pea fl_io_object
	jsr fl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L92
	tst.l %d1
	jge .L79
	pea fl_io_object
	move.l %d1,8(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l 4(%sp),%d1
	move.l %d1,%d0
	move.l (%sp)+,%d2
	addq.l #8,%sp
	rts
.L92:
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L50
	move.l 28(%sp),-(%sp)
	pea 18624.w
	pea fl_io_file
	move.l 32(%sp),-(%sp)
	jsr fl_io_core_validate
	lea (16,%sp),%sp
	moveq #-2,%d1
	cmp.l %d0,%d1
	jeq .L63
	add.l %d0,%d0
	subx.l %d0,%d0
	moveq #-60,%d1
	move.l (%sp)+,%d2
	and.l %d0,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L90:
	moveq #9,%d0
	cmp.l %d1,%d0
	jcc .L79
	moveq #15,%d2
	cmp.l %d1,%d2
	jcs .L67
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	jra .L81
.L75:
	move.l (%sp)+,%d2
	moveq #-63,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
	.size	read_bank, .-read_bank
	.section	.rodata.str1.1
.LC8:
	.string	"/project.work"
.LC9:
	.string	"/project.strd"
	.text
	.align	2
	.type	fl_mig_path.constprop.0, @function
fl_mig_path.constprop.0:
	move.l %a2,-(%sp)
	tst.l 8(%sp)
	jeq .L102
	lea .LC9,%a1
.L94:
	lea fl_io_base,%a0
	move.b (%a0),%d1
	jeq .L112
	clr.l %d0
	lea fl_io_path,%a2
.L100:
	move.b %d1,(%a2,%d0.l)
	addq.l #1,%d0
	move.b (%a0,%d0.l),%d1
	jeq .L113
	cmp.l #245,%d0
	jne .L100
	move.l (%sp)+,%a2
	moveq #-63,%d0
	rts
.L113:
	move.b (%a1),%d1
	jeq .L97
	lea (%a2,%d0.l),%a0
	addq.l #1,%a1
.L98:
	move.b %d1,(%a0)
	move.b (%a1)+,%d1
	move.l %a0,%d0
	addq.l #1,%a0
	tst.b %d1
	jne .L98
	sub.l #fl_io_path-1,%d0
.L97:
	clr.b %d1
	move.b %d1,(%a2,%d0.l)
	clr.l %d0
	move.l (%sp)+,%a2
	rts
.L102:
	lea .LC8,%a1
	jra .L94
.L112:
	move.b (%a1),%d1
	clr.l %d0
	lea fl_io_path,%a2
	addq.l #1,%a1
	lea (%a2,%d0.l),%a0
	jra .L98
	.size	fl_mig_path.constprop.0, .-fl_mig_path.constprop.0
	.align	2
	.type	fl_mig_text_read.constprop.0, @function
fl_mig_text_read.constprop.0:
	lea (-40,%sp),%sp
	movem.l #15612,(%sp)
	move.l 52(%sp),%a2
	move.l 44(%sp),-(%sp)
	move.l 52(%sp),%a0
	clr.l (%a0)
	clr.l (%a2)
	jsr (fl_mig_path.constprop.0)
	addq.l #4,%sp
	move.l %d0,%d4
	tst.l %d0
	jne .L135
	pea 512.w
	pea fl_io_sector
	pea .LC6
	pea fl_io_path
	pea fl_io_object
	jsr fl_io_fs_open
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L153
	lea fl_io_object,%a3
	move.l (%a3),-(%sp)
	jsr fl_io_fs_size
	addq.l #4,%sp
	move.l %d0,%d6
	tst.l %d0
	jlt .L117
	clr.l %d2
	clr.l %d5
	lea fl_io_fs_read,%a3
	lea fl_mig_line,%a4
	cmp.l %d6,%d5
	jcc .L122
.L132:
	move.l %d6,%d3
	sub.l %d5,%d3
	cmp.l #18624,%d3
	jls .L119
	mvz.w #18624,%d3
.L119:
	move.l %d3,-(%sp)
	pea fl_io_file
	pea fl_io_object
	jsr (%a3)
	lea (12,%sp),%sp
	mov3q.l #1,%d7
	cmp.l %d0,%d7
	jne .L120
	tst.l (%a2)
	jne .L122
	lea fl_io_file,%a0
	lea (%a0,%d3.l),%a1
.L129:
	move.l %a0,%a5
	moveq #17,%d0
	move.b (%a5)+,%d1
	cmp.l %d2,%d0
	jne .L137
	mvz.b %d1,%d1
	moveq #13,%d7
	cmp.l %d1,%d7
	jeq .L126
	moveq #10,%d0
	cmp.l %d1,%d0
	jeq .L126
	cmp.l %a1,%a5
	jeq .L138
	move.b (%a5),%d1
	addq.l #2,%a0
	mov3q.l #-1,%d2
.L131:
	moveq #10,%d0
	mov3q.l #-1,%d7
	eor.l %d1,%d0
	mvs.b %d1,%d1
	cmp.l %d2,%d7
	jeq .L128
	mvs.b (%a4,%d2.l),%d7
	cmp.l %d7,%d1
	jeq .L154
.L128:
	tst.b %d0
	sne %d0
	mvs.b %d0,%d2
	cmp.l %a0,%a1
	jeq .L130
	move.b (%a0)+,%d1
	jra .L131
.L154:
	addq.l #1,%d2
	cmp.l %a0,%a1
	jne .L129
.L130:
	add.l %d3,%d5
.L155:
	cmp.l %d6,%d5
	jcs .L132
.L122:
	moveq #17,%d0
	cmp.l %d2,%d0
	jeq .L126
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
.L134:
	tst.l %d0
	jlt .L139
	move.l %d4,%d0
	move.l 48(%sp),%a0
	move.l %d6,(%a0)
	movem.l (%sp),#15612
	lea (40,%sp),%sp
	rts
.L117:
	move.l %a3,-(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l %d6,%d4
	move.l %d4,%d0
	movem.l (%sp),#15612
	lea (40,%sp),%sp
	rts
.L137:
	move.l %a5,%a0
	jra .L131
.L153:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jeq .L136
.L139:
	move.l %d0,%d4
	move.l %d4,%d0
	movem.l (%sp),#15612
	lea (40,%sp),%sp
	rts
.L138:
	mov3q.l #-1,%d2
	add.l %d3,%d5
	jra .L155
.L136:
	mov3q.l #1,%d4
	move.l %d4,%d0
	movem.l (%sp),#15612
	lea (40,%sp),%sp
	rts
.L120:
	tst.l %d0
	jlt .L123
	pea fl_io_object
	moveq #-60,%d4
	jsr fl_io_fs_close
	addq.l #4,%sp
.L156:
	move.l %d4,%d0
	movem.l (%sp),#15612
	lea (40,%sp),%sp
	rts
.L126:
	pea fl_io_object
	mov3q.l #1,(%a2)
	jsr fl_io_fs_close
	addq.l #4,%sp
	jra .L134
.L123:
	pea fl_io_object
	move.l %d0,%d4
	jsr fl_io_fs_close
	addq.l #4,%sp
	jra .L156
.L135:
	moveq #-63,%d4
	move.l %d4,%d0
	movem.l (%sp),#15612
	lea (40,%sp),%sp
	rts
	.size	fl_mig_text_read.constprop.0, .-fl_mig_text_read.constprop.0
	.section	.rodata.str1.1
.LC10:
	.string	"w"
	.text
	.align	2
	.type	fl_mig_comment.constprop.0, @function
fl_mig_comment.constprop.0:
	link.w %fp,#-48
	movem.l #3132,(%sp)
	pea -4(%fp)
	pea -8(%fp)
	move.l 8(%fp),-(%sp)
	jsr (fl_mig_text_read.constprop.0)
	lea (12,%sp),%sp
	move.l %d0,-22(%fp)
	tst.l %d0
	jne .L157
	move.l -4(%fp),%d1
	move.l %d1,-14(%fp)
	tst.l %d1
	jeq .L192
.L157:
	movem.l -48(%fp),#3132
	move.l -22(%fp),%d0
	unlk %fp
	rts
.L192:
	move.l 8(%fp),-(%sp)
	jsr (fl_mig_path.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jne .L178
	pea 512.w
	pea fl_io_sector
	pea .LC6
	pea fl_io_path
	pea fl_io_object
	lea fl_io_fs_open,%a2
	jsr (%a2)
	lea (20,%sp),%sp
	move.l %d0,-22(%fp)
	tst.l %d0
	jlt .L157
	pea 512.w
	pea fl_io_sector2
	pea .LC10
	pea fl_io_path
	pea fl_io_object2
	jsr (%a2)
	lea (20,%sp),%sp
	move.l %d0,-22(%fp)
	tst.l %d0
	jlt .L193
	move.l -8(%fp),%d5
	tst.l %d5
	jeq .L194
	clr.l %d4
	lea fl_io_file,%a3
	lea fl_io_fs_write,%a2
.L167:
	move.l %d5,%d2
	sub.l %d4,%d2
	cmp.l #18624,%d2
	jls .L162
	mvz.w #18624,%d2
.L162:
	move.l %d2,-(%sp)
	pea fl_io_file
	pea fl_io_object
	jsr fl_io_fs_read
	move.l %a3,%d3
	move.l %a2,-18(%fp)
	lea (12,%sp),%sp
	mov3q.l #1,%d1
	move.l %d0,-22(%fp)
	cmp.l %d0,%d1
	jne .L189
	move.b -1(%a3,%d2.l),%d1
	move.l %d2,-(%sp)
	move.l %a3,-(%sp)
	pea fl_io_object2
	add.l %d2,%d4
	move.b %d1,-9(%fp)
	jsr (%a2)
	lea (12,%sp),%sp
	move.l %d0,-22(%fp)
	subq.l #1,%d0
	tst.l %d0
	jne .L166
	cmp.l %d4,%d5
	jhi .L167
	mvz.b -9(%fp),%d0
	moveq #10,%d1
	cmp.l %d0,%d1
	jeq .L171
	moveq #10,%d0
	mov3q.l #1,-14(%fp)
	move.b %d0,fl_io_file
.L171:
	moveq #35,%d0
	move.l -14(%fp),%a0
	add.l %d3,%a0
	lea fl_mig_line+1,%a1
.L172:
	move.b %d0,(%a0)
	move.b (%a1)+,%d0
	move.l %a0,%d1
	addq.l #1,%a0
	tst.b %d0
	jne .L172
	sub.l #fl_io_file-1,%d1
	move.l %d1,-(%sp)
	move.l -18(%fp),%a0
	pea fl_io_file
	pea fl_io_object2
	jsr (%a0)
	lea (12,%sp),%sp
	mov3q.l #1,%d1
	move.l %d0,-22(%fp)
	cmp.l %d0,%d1
	jne .L189
	pea fl_io_object
	lea fl_io_fs_close,%a2
	jsr (%a2)
	pea fl_io_object2
	move.l %d0,-22(%fp)
	jsr (%a2)
	addq.l #8,%sp
	tst.l -22(%fp)
	jlt .L157
	move.l %d0,-22(%fp)
	tst.l %d0
	jle .L157
	movem.l -48(%fp),#3132
	clr.l -22(%fp)
	move.l -22(%fp),%d0
	unlk %fp
	rts
.L189:
	tst.l %d0
	jlt .L164
.L185:
	pea fl_io_object
	lea fl_io_fs_close,%a2
	jsr (%a2)
	pea fl_io_object2
	jsr (%a2)
	movem.l -48(%fp),#3132
	addq.l #8,%sp
	moveq #-60,%d1
	move.l %d1,-22(%fp)
	move.l -22(%fp),%d0
	unlk %fp
	rts
.L166:
	tst.l -22(%fp)
	jge .L185
.L164:
	pea fl_io_object
	lea fl_io_fs_close,%a2
	jsr (%a2)
	pea fl_io_object2
	jsr (%a2)
	movem.l -48(%fp),#3132
	move.l -22(%fp),%d0
	addq.l #8,%sp
	unlk %fp
	rts
.L193:
	pea fl_io_object
	jsr fl_io_fs_close
	movem.l -48(%fp),#3132
	move.l -22(%fp),%d0
	addq.l #4,%sp
	unlk %fp
	rts
.L178:
	movem.l -48(%fp),#3132
	moveq #-63,%d1
	move.l %d1,-22(%fp)
	move.l -22(%fp),%d0
	unlk %fp
	rts
.L194:
	lea fl_io_fs_write,%a0
	move.l #fl_io_file,%d3
	move.l %a0,-18(%fp)
	move.l -14(%fp),%a0
	add.l %d3,%a0
	moveq #35,%d0
	lea fl_mig_line+1,%a1
	jra .L172
	.size	fl_mig_comment.constprop.0, .-fl_mig_comment.constprop.0
	.align	2
	.type	publish.constprop.0, @function
publish.constprop.0:
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	move.l 12(%sp),%d0
	mov3q.l #1,%d2
	pea fl_io_file+32
	lsl.l %d0,%d2
	move.l 20(%sp),-(%sp)
	move.l %d0,-(%sp)
	or.l %d2,fl_blocked_mask
	move.l %d2,%d3
	not.l %d3
	and.l %d3,fl_ready_mask
	jsr fl_io_core_publish
	lea (12,%sp),%sp
	moveq #-2,%d1
	cmp.l %d0,%d1
	jeq .L201
	tst.l %d0
	jlt .L198
	move.l (%sp)+,%d2
	clr.l %d0
	and.l %d3,fl_io_pool_mask
	move.l (%sp)+,%d3
	rts
.L198:
	move.l (%sp)+,%d2
	moveq #-60,%d0
	move.l (%sp)+,%d3
	rts
.L201:
	jsr fl_io_irq_lock
	or.l %d2,fl_io_pool_mask
	lea fl_lane_free,%a0
	move.l %d0,-(%sp)
	move.l (%a0),fl_io_pool_free
	jsr fl_io_irq_restore
	addq.l #4,%sp
	move.l (%sp)+,%d2
	moveq #-64,%d0
	move.l (%sp)+,%d3
	rts
	.size	publish.constprop.0, .-publish.constprop.0
	.align	2
	.type	write_buffer.constprop.0, @function
write_buffer.constprop.0:
	subq.l #4,%sp
	move.l 12(%sp),-(%sp)
	move.l 12(%sp),-(%sp)
	pea fl_io_base
	pea fl_io_path
	jsr (path_for.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L207
	pea 512.w
	pea fl_io_sector
	pea .LC10
	pea fl_io_path
	pea fl_io_object
	jsr fl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L202
	pea 18624.w
	pea fl_io_file
	pea fl_io_object
	jsr fl_io_fs_write
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L210
	tst.l %d1
	jlt .L206
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	moveq #-60,%d1
.L202:
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L210:
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jle .L202
	clr.l %d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L206:
	pea fl_io_object
	move.l %d1,4(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l (%sp),%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L207:
	moveq #-63,%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
	.size	write_buffer.constprop.0, .-write_buffer.constprop.0
	.align	2
	.type	store_ab, @function
store_ab:
	lea (-48,%sp),%sp
	movem.l #31868,(%sp)
	move.l 52(%sp),%d4
	move.l fl_blocked_mask,%d3
	and.l %d4,%d3
	tst.l %d3
	jne .L212
	move.l fl_ready_mask,%d0
	and.l %d4,%d0
	cmp.l %d0,%d4
	jne .L212
	move.l %sp,%d6
	move.l %sp,%d5
	add.l #44,%d6
	add.l #40,%d5
	lea snapshot,%a6
	lea fl_io_irq_lock,%a4
	lea fl_generation,%a3
	lea fl_io_irq_restore,%a2
.L213:
	mov3q.l #1,%d2
	lsl.l %d3,%d2
	move.l %d4,%d0
	and.l %d2,%d0
	tst.l %d0
	jne .L228
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L213
.L230:
	clr.l %d0
.L211:
	movem.l (%sp),#31868
	lea (48,%sp),%sp
	rts
.L228:
	move.l %d6,-(%sp)
	move.l %d5,-(%sp)
	move.l %d3,-(%sp)
	jsr (%a6)
	lea (12,%sp),%sp
	tst.l %d0
	jne .L211
	move.l %d2,%d0
	and.l fl_present_mask,%d0
	or.l 44(%sp),%d0
	jeq .L216
	clr.l -(%sp)
	move.l %d3,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jne .L211
	mov3q.l #1,-(%sp)
	move.l %d3,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jne .L211
	or.l %d2,fl_present_mask
.L216:
	move.l 40(%sp),%a5
	not.l %d2
	jsr (%a4)
	cmp.l (%a3,%d3.l*4),%a5
	jeq .L229
	move.l %d0,-(%sp)
	jsr (%a2)
	and.l %d2,fl_io_protected_mask
	addq.l #4,%sp
.L231:
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L213
	jra .L230
.L229:
	move.l %d0,-(%sp)
	and.l %d2,fl_dirty_mask
	jsr (%a2)
	and.l %d2,fl_io_protected_mask
	addq.l #4,%sp
	jra .L231
.L212:
	movem.l (%sp),#31868
	moveq #-61,%d0
	lea (48,%sp),%sp
	rts
	.size	store_ab, .-store_ab
	.align	2
	.type	own_post.isra.0, @function
own_post.isra.0:
	subq.l #4,%sp
	tst.l 1175264744
	jne .L232
	mov3q.l #1,%d0
	cmp.l -2147483512.l,%d0
	jeq .L232
	tst.l 269452412
	jeq .L243
.L232:
	addq.l #4,%sp
	rts
.L243:
	move.l 8(%sp),(%sp)
	jsr fl_io_stock_card_ready
	tst.l %d0
	jeq .L232
	jsr fl_io_irq_lock
	move.l (%sp),%d1
	or.l %d1,fl_io_own_work
	tst.l fl_io_flush_pending
	jne .L244
	move.l %d0,-(%sp)
	mov3q.l #1,fl_io_flush_pending
	jsr fl_io_irq_restore
	moveq #-127,%d0
	pea fl_io_flush_job
	move.l #1175263182,-(%sp)
	move.b %d0,fl_io_flush_job
	jsr fl_io_queue_post
	lea (12,%sp),%sp
	addq.l #4,%sp
	rts
.L244:
	move.l %d0,8(%sp)
	addq.l #4,%sp
	jra fl_io_irq_restore
	.size	own_post.isra.0, .-own_post.isra.0
	.align	2
	.type	flush_ab.constprop.0, @function
flush_ab.constprop.0:
	lea (-48,%sp),%sp
	movem.l #23804,(%sp)
	move.l fl_dirty_mask,%d0
	move.l %sp,%d6
	move.l fl_blocked_mask,%d4
	not.l %d4
	move.l fl_ready_mask,%d2
	move.l %sp,%d5
	move.l fl_io_protected_mask,%d1
	not.l %d1
	clr.l %d3
	and.l %d2,%d0
	add.l #44,%d6
	add.l #40,%d5
	lea snapshot,%a6
	lea fl_io_irq_lock,%a4
	lea fl_generation,%a3
	lea fl_io_irq_restore,%a2
	and.l %d0,%d4
	and.l %d1,%d4
	and.l 52(%sp),%d4
.L250:
	mov3q.l #1,%d2
	lsl.l %d3,%d2
	move.l %d4,%d0
	and.l %d2,%d0
	tst.l %d0
	jne .L260
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L250
.L262:
	clr.l %d0
.L245:
	movem.l (%sp),#23804
	lea (48,%sp),%sp
	rts
.L260:
	move.l %d6,-(%sp)
	move.l %d5,-(%sp)
	move.l %d3,-(%sp)
	jsr (%a6)
	lea (12,%sp),%sp
	tst.l %d0
	jne .L245
	move.l %d2,%d0
	and.l fl_present_mask,%d0
	or.l 44(%sp),%d0
	jeq .L248
	clr.l -(%sp)
	move.l %d3,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jne .L245
	or.l %d2,fl_present_mask
.L248:
	move.l 40(%sp),%d7
	not.l %d2
	jsr (%a4)
	cmp.l (%a3,%d3.l*4),%d7
	jeq .L261
	move.l %d0,-(%sp)
	jsr (%a2)
	and.l %d2,fl_io_protected_mask
	addq.l #4,%sp
.L263:
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L250
	jra .L262
.L261:
	move.l %d0,-(%sp)
	and.l %d2,fl_dirty_mask
	jsr (%a2)
	and.l %d2,fl_io_protected_mask
	addq.l #4,%sp
	jra .L263
	.size	flush_ab.constprop.0, .-flush_ab.constprop.0
	.align	2
	.type	fl_mig_capture, @function
fl_mig_capture:
	lea (-80,%sp),%sp
	movem.l #31996,(%sp)
	move.l 84(%sp),%d2
	move.l #635712,%d1
	muls.l %d2,%d1
	mvz.b 269161678,%d0
	add.l #1074668000,%d1
	move.l %d1,64(%sp)
	cmp.l %d2,%d0
	jeq .L352
.L266:
	move.w %d2,%d0
	mulu.w #160,%d0
	move.l %d0,%a0
	add.l #fl_migration_table,%a0
	move.l %a0,76(%sp)
	tst.b 3(%a0)
	jeq .L268
.L353:
	move.l 76(%sp),%a1
	addq.l #4,%a0
	clr.l %d0
	lea (12,%a1),%a1
.L269:
	mvz.b (%a0)+,%d1
	or.l %d1,%d0
	cmp.l %a1,%a0
	jne .L269
	tst.l %d0
	sne %d0
	mvs.b %d0,%d0
	neg.l %d0
	move.l %d0,72(%sp)
.L264:
	movem.l (%sp),#31996
	move.l 72(%sp),%d0
	lea (80,%sp),%sp
	rts
.L352:
	move.l 1187521622,%d0
	move.l %d0,%d1
	add.l #-1073741824,%d1
	cmp.l #134217727,%d1
	jhi .L266
	move.l %d0,64(%sp)
	move.w %d2,%d0
	mulu.w #160,%d0
	move.l %d0,%a0
	add.l #fl_migration_table,%a0
	move.l %a0,76(%sp)
	tst.b 3(%a0)
	jne .L353
.L268:
	move.l 64(%sp),%d1
	add.l #585088,%d1
	move.l %d1,60(%sp)
	clr.l %d3
	clr.l %d6
	move.l %d1,%d5
.L278:
	move.l %d5,%a2
	move.l %d5,%a3
	move.l %d5,%d1
	sub.l %a1,%a1
	add.l #5730,%d1
	lea (60,%a2),%a2
	lea (34,%a3),%a3
.L277:
	mvz.b (%a3,%a1.l),%d0
	subq.l #1,%d0
	tst.l %d0
	jeq .L354
.L273:
	addq.l #1,%a1
	add.l #32,%d1
	lea (30,%a2),%a2
	moveq #8,%d0
	cmp.l %a1,%d0
	jne .L277
	addq.l #1,%d6
	add.l #6322,%d5
	cmp.l %d6,%d0
	jne .L278
	move.l %d2,%d0
	add.l #128,%d0
	mvz.w %d0,%d0
	clr.l %d6
	clr.l %d4
	lea fl_io_core_taken,%a3
	lsl.l #4,%d0
	move.l %d0,%a2
.L282:
	mov3q.l #1,%d0
	lsl.l %d4,%d0
	and.l %d3,%d0
	tst.l %d0
	jne .L355
.L280:
	addq.l #1,%d4
	moveq #16,%d1
	cmp.l %d4,%d1
	jne .L282
.L360:
	mvz.w %d2,%d4
	move.l 64(%sp),%a6
	add.l #36439,%a6
	move.l 64(%sp),%d5
	add.l #621527,%d5
	lea fl_io_core_taken,%a4
	lsl.l #7,%d4
.L291:
	move.b (%a6),%d0
	mov3q.l #3,%d3
	mvz.b %d0,%d1
	cmp.l %d1,%d3
	jcc .L356
.L283:
	add.l #36568,%a6
	addq.l #8,%d4
	cmp.l %a6,%d5
	jne .L291
	cmp.l fl_lane_free.l,%d6
	jhi .L311
	move.l 76(%sp),%a0
	move.l 76(%sp),%d3
	addq.l #4,%d3
	move.l %d3,56(%sp)
	lea (12,%a0),%a0
	clr.l 52(%sp)
	move.l %a0,68(%sp)
	clr.l 72(%sp)
	lea fl_io_core_scene_set,%a2
.L301:
	sub.l %a3,%a3
	move.l 56(%sp),%a0
	mvz.w 54(%sp),%d3
	move.l 60(%sp),%a6
	clr.b (%a0)+
	move.l 60(%sp),%a5
	lsl.l #4,%d3
	move.l 60(%sp),%d4
	add.l #1634,%d4
	addq.l #1,56(%sp)
	lea (60,%a6),%a6
	lea (282,%a5),%a5
	move.l 60(%sp),%a0
	move.l 68(%sp),48(%sp)
	lea (34,%a0),%a0
	move.l %a0,44(%sp)
	add.l #128,%d3
.L300:
	mov3q.l #1,%d1
	move.l 44(%sp),%a0
	mvz.b (%a0,%a3.l),%d0
	cmp.l %d0,%d1
	jeq .L357
.L294:
	addq.l #1,%a3
	addq.l #1,%d3
	lea (30,%a6),%a6
	add.l #32,%d4
	addq.l #2,48(%sp)
	lea (24,%a5),%a5
	moveq #8,%d6
	cmp.l %a3,%d6
	jne .L300
.L363:
	mvz.w #6322,%d0
	moveq #16,%d7
	moveq #64,%d1
	add.l %d7,68(%sp)
	addq.l #8,52(%sp)
	add.l %d0,60(%sp)
	cmp.l 52(%sp),%d1
	jne .L301
	tst.l 72(%sp)
	jeq .L264
	move.l 64(%sp),%a4
	moveq #89,%d6
	add.l #36350,%a4
	clr.l 48(%sp)
	lea fl_io_core_set,%a2
.L302:
	mvz.b (%a4,%d6.l),%d0
	mov3q.l #3,%d3
	cmp.l %d0,%d3
	jcc .L358
.L303:
	mvz.w #512,%d0
	addq.l #8,48(%sp)
	move.l 48(%sp),%d1
	add.l #36568,%d6
	add.l %d0,52(%sp)
	cmp.l #128,%d1
	jne .L302
	move.l 76(%sp),%a0
	mov3q.l #1,(%a0)
	jsr fl_io_irq_lock
	mov3q.l #1,%d1
	lsl.l %d2,%d1
	lea fl_generation,%a0
	or.l %d1,fl_dirty_mask
	addq.l #1,(%a0,%d2.l*4)
	move.l %d0,-(%sp)
	jsr fl_io_irq_restore
	addq.l #4,%sp
	movem.l (%sp),#31996
	move.l 72(%sp),%d0
	lea (80,%sp),%sp
	rts
.L354:
	mvz.b (%a2),%d0
	moveq #70,%d7
	cmp.l %d0,%d7
	jne .L273
	mvz.b 1(%a2),%d0
	moveq #77,%d4
	cmp.l %d0,%d4
	jne .L273
	mvz.b 2(%a2),%d4
	mov3q.l #1,%d7
	cmp.l %d4,%d7
	jne .L273
	mov3q.l #3,%d0
	and.l %d6,%d0
	move.l %a1,%d7
	lsr.l #1,%d7
	move.l %d1,%a0
	lea (-4096,%a0),%a0
	move.l %d7,%a4
	lea (%a4,%d0.l*4),%a4
	move.l %a4,%d0
	lsl.l %d0,%d4
	mvz.b 8(%a0),%d0
	cmp.l #255,%d0
	jeq .L359
.L274:
	or.l %d4,%d3
.L275:
	lea (256,%a0),%a0
	cmp.l %a0,%d1
	jeq .L273
	mvz.b 8(%a0),%d0
	cmp.l #255,%d0
	jne .L274
.L359:
	mvz.b 11(%a0),%d0
	cmp.l #255,%d0
	jeq .L275
	or.l %d4,%d3
	jra .L275
.L355:
	pea (%a2,%d4.l)
	jsr (%a3)
	addq.l #4,%sp
	tst.l %d0
	jne .L280
	addq.l #1,%d6
	addq.l #1,%d4
	moveq #16,%d1
	cmp.l %d4,%d1
	jne .L282
	jra .L360
.L356:
	ext.w %d0
	move.l %d4,%a3
	move.l %a6,%d3
	lea (-34,%a3),%a3
	add.l #-34302,%d3
	mulu.w #6322,%d0
	move.l %d0,%d7
	add.l #585088,%d7
	add.l 64(%sp),%d7
	move.l %d7,%a2
	move.l %d7,%a5
	mvz.b 34(%a2),%d0
	sub.l %d7,%a3
	lea (34,%a2),%a2
	add.l #42,%d7
	lea (60,%a5),%a5
	subq.l #1,%d0
	tst.l %d0
	jeq .L361
.L286:
	addq.l #1,%a2
	lea (30,%a5),%a5
	add.l #2330,%d3
	cmp.l %a2,%d7
	jeq .L283
.L349:
	mvz.b (%a2),%d0
	subq.l #1,%d0
	tst.l %d0
	jne .L286
.L361:
	mvz.b (%a5),%d0
	moveq #70,%d1
	cmp.l %d0,%d1
	jne .L286
	mvz.b 1(%a5),%d0
	moveq #77,%d1
	cmp.l %d0,%d1
	jne .L286
	mvz.b 2(%a5),%d0
	subq.l #1,%d0
	tst.l %d0
	jne .L286
	pea (%a3,%a2.l)
	jsr (%a4)
	addq.l #4,%sp
	tst.l %d0
	jne .L286
	move.l %d3,%a0
	mvz.b -2040(%a0),%d0
	lea (-2048,%a0),%a0
	cmp.l #255,%d0
	jne .L287
.L362:
	mvz.b 11(%a0),%d0
	lea (32,%a0),%a0
	cmp.l #255,%d0
	jne .L287
	cmp.l %a0,%d3
	jeq .L286
	mvz.b 8(%a0),%d0
	cmp.l #255,%d0
	jeq .L362
.L287:
	addq.l #1,%d6
	addq.l #1,%a2
	lea (30,%a5),%a5
	add.l #2330,%d3
	cmp.l %a2,%d7
	jne .L349
	jra .L283
.L357:
	mvz.b (%a6),%d0
	moveq #70,%d6
	cmp.l %d0,%d6
	jne .L294
	mvz.b 1(%a6),%d0
	moveq #77,%d7
	cmp.l %d0,%d7
	jne .L294
	move.b 2(%a6),%d5
	mvz.b %d5,%d0
	cmp.l %d0,%d1
	jne .L294
	move.l 56(%sp),%a0
	move.l %a3,%d6
	lsl.l %d6,%d0
	mov3q.l #3,%d7
	move.b -1(%a0),%d1
	or.l %d1,%d0
	move.b %d0,-1(%a0)
	move.b 2(%a5),%d1
	move.l %d1,%d0
	subq.l #1,%d0
	mvz.b %d0,%d0
	cmp.l %d0,%d7
	jcc .L295
	move.b %d5,%d1
.L295:
	move.l 48(%sp),%a0
	move.l %d3,%d7
	move.l %d4,%a4
	add.l #-128,%d7
	move.b %d1,(%a0)
	moveq #127,%d1
	move.b 5(%a5),%d0
	and.l %d1,%d0
	move.b %d0,1(%a0)
.L299:
	mvz.b 8(%a4),%d0
	cmp.l #255,%d0
	jeq .L296
	move.b 8(%a4),%d0
	mov3q.l #3,%d6
	move.l %d0,%d1
	subq.l #1,%d1
	mvz.b %d1,%d1
	cmp.l %d1,%d6
	jcc .L297
	move.b %d5,%d0
.L297:
	mvz.b %d0,%d0
	move.l %d0,-(%sp)
	clr.l -(%sp)
	move.l %d7,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
.L296:
	mvz.b 11(%a4),%d0
	cmp.l #255,%d0
	jeq .L298
	move.b 11(%a4),%d0
	moveq #127,%d1
	and.l %d0,%d1
	move.l %d1,-(%sp)
	mov3q.l #1,-(%sp)
	move.l %d7,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
.L298:
	lea (256,%a4),%a4
	addq.l #8,%d7
	cmp.l %d7,%d3
	jne .L299
	mov3q.l #1,72(%sp)
	moveq #8,%d6
	addq.l #1,%a3
	addq.l #1,%d3
	lea (30,%a6),%a6
	add.l #32,%d4
	lea (24,%a5),%a5
	addq.l #2,48(%sp)
	cmp.l %a3,%d6
	jne .L300
	jra .L363
.L358:
	move.l 76(%sp),%a0
	move.l %d6,%d5
	move.l 52(%sp),%d3
	clr.l %d4
	lea 4(%a0,%d0.l),%a3
	mvz.b (%a3),%d0
	btst %d4,%d0
	jne .L364
.L304:
	addq.l #1,%d4
	add.l #64,%d3
	add.l #2330,%d5
	moveq #8,%d7
	cmp.l %d4,%d7
	jeq .L303
.L351:
	mvz.b (%a3),%d0
	btst %d4,%d0
	jeq .L304
.L364:
	move.l %d3,%a6
	move.l 64(%sp),%a5
	add.l %d5,%a5
	lea (-64,%a6),%a6
.L308:
	mvz.b 8(%a5),%d0
	cmp.l #255,%d0
	jeq .L305
	move.b 8(%a5),%d0
	mov3q.l #3,%d7
	move.l %d0,%d1
	subq.l #1,%d1
	mvz.b %d1,%d1
	cmp.l %d1,%d7
	jcc .L306
	moveq #1,%d0
.L306:
	mvz.b %d0,%d0
	move.l %d0,-(%sp)
	clr.l -(%sp)
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
.L305:
	mvz.b 11(%a5),%d0
	cmp.l #255,%d0
	jeq .L307
	move.b 11(%a5),%d0
	moveq #127,%d1
	and.l %d0,%d1
	move.l %d1,-(%sp)
	mov3q.l #1,-(%sp)
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
.L307:
	lea (32,%a5),%a5
	addq.l #1,%a6
	cmp.l %d3,%a6
	jne .L308
	addq.l #1,%d4
	add.l #64,%d3
	add.l #2330,%d5
	moveq #8,%d7
	cmp.l %d4,%d7
	jne .L351
	jra .L303
.L311:
	movem.l (%sp),#31996
	mov3q.l #2,72(%sp)
	move.l 72(%sp),%d0
	lea (80,%sp),%sp
	rts
	.size	fl_mig_capture, .-fl_mig_capture
	.align	2
	.type	fl_mig_apply_to, @function
fl_mig_apply_to:
	lea (-52,%sp),%sp
	movem.l #31996,(%sp)
	move.l 64(%sp),%d6
	clr.l %d4
	move.l 60(%sp),%d7
	add.l #-268525902,%d7
	move.l #269110990,%d5
	move.b 1074608214,%d0
	move.b %d0,46(%sp)
	move.w 58(%sp),%d0
	move.b 1074608217,%d2
	mulu.w #160,%d0
	move.l %d7,48(%sp)
	move.l %d0,%a6
	add.l #fl_migration_table,%a6
	move.l %a6,%d3
	add.l #12,%d3
	move.b %d2,47(%sp)
	lea (4,%a6),%a4
.L370:
	tst.l %d6
	jne .L378
	move.l 48(%sp),%a5
	add.l %d5,%a5
	move.l %a5,%d1
	clr.l %d0
	lea (60,%a5),%a1
	add.l #1634,%d1
	lea (282,%a5),%a3
	move.l %d3,%a2
	lea (34,%a5),%a5
.L369:
	mvz.b (%a4),%d2
	btst %d0,%d2
	jne .L396
.L367:
	addq.l #1,%d0
	lea (30,%a1),%a1
	addq.l #2,%a2
	add.l #32,%d1
	lea (24,%a3),%a3
	moveq #8,%d2
	cmp.l %d0,%d2
	jne .L369
	add.l #16,%d3
	addq.l #1,%a4
	add.l #6322,%d5
	addq.l #8,%d4
	moveq #64,%d7
	cmp.l %d4,%d7
	jne .L370
	move.l #-36350,%d4
	sub.l 60(%sp),%d4
	move.l 60(%sp),%a2
	add.l #36439,%a2
	move.l 60(%sp),%d3
	add.l #621527,%d3
	move.l 60(%sp),%d5
	add.l #585088,%d5
.L377:
	move.b (%a2),%d0
	mov3q.l #3,%d2
	mvz.b %d0,%d1
	cmp.l %d1,%d2
	jcc .L397
.L371:
	add.l #36568,%a2
	cmp.l %a2,%d3
	jne .L377
	movem.l (%sp),#31996
	lea (52,%sp),%sp
	rts
.L396:
	mvz.b (%a5,%d0.l),%d2
	subq.l #1,%d2
	tst.l %d2
	jne .L367
	mvz.b (%a1),%d2
	moveq #70,%d7
	cmp.l %d2,%d7
	jne .L367
	mvz.b 1(%a1),%d2
	moveq #77,%d7
	cmp.l %d2,%d7
	jne .L367
	mvz.b 2(%a1),%d2
	subq.l #1,%d2
	tst.l %d2
	jne .L367
	move.b (%a2),420(%a1)
	move.l %d1,%d2
	move.l %d1,%a0
	add.l #4096,%d2
	move.b 1(%a2),421(%a1)
	move.b 46(%sp),2(%a3)
	move.b 47(%sp),5(%a3)
.L368:
	st %d7
	lea (256,%a0),%a0
	move.b %d7,-248(%a0)
	move.b %d7,-245(%a0)
	cmp.l %a0,%d2
	jeq .L367
	st %d7
	lea (256,%a0),%a0
	move.b %d7,-248(%a0)
	move.b %d7,-245(%a0)
	cmp.l %a0,%d2
	jne .L368
	jra .L367
.L397:
	ext.w %d0
	lea 4(%a6,%d1.l),%a3
	move.l %d4,%d2
	clr.l %d1
	add.l %a2,%d2
	mulu.w #6322,%d0
	move.l %d0,%a4
	add.l %d5,%a4
	mvz.b (%a3),%d0
	lea (60,%a4),%a1
	lea (34,%a4),%a4
	btst %d1,%d0
	jne .L398
.L372:
	addq.l #1,%d1
	lea (30,%a1),%a1
	add.l #2330,%d2
	moveq #8,%d0
	cmp.l %d1,%d0
	jeq .L371
	mvz.b (%a3),%d0
	btst %d1,%d0
	jeq .L372
.L398:
	mvz.b (%a4,%d1.l),%d0
	subq.l #1,%d0
	tst.l %d0
	jne .L372
	mvz.b (%a1),%d0
	moveq #70,%d7
	cmp.l %d0,%d7
	jne .L372
	mvz.b 1(%a1),%d0
	moveq #77,%d7
	cmp.l %d0,%d7
	jne .L372
	mvz.b 2(%a1),%d0
	subq.l #1,%d0
	tst.l %d0
	jne .L372
	btst #0,%d6
	jeq .L399
	move.l #268525902,%a0
	move.l %a0,%d0
	add.l #2048,%d0
	add.l %d2,%a0
	add.l %d2,%d0
.L375:
	st %d7
	lea (32,%a0),%a0
	move.b %d7,-24(%a0)
	move.b %d7,-21(%a0)
	cmp.l %d0,%a0
	jeq .L372
	st %d7
	lea (32,%a0),%a0
	move.b %d7,-24(%a0)
	move.b %d7,-21(%a0)
	cmp.l %d0,%a0
	jne .L375
	jra .L372
.L378:
	move.l %d5,%a5
	move.l %a5,%d1
	lea (60,%a5),%a1
	clr.l %d0
	lea (282,%a5),%a3
	add.l #1634,%d1
	move.l %d3,%a2
	lea (34,%a5),%a5
	jra .L369
.L399:
	move.l 60(%sp),%a0
	move.l %a0,%d0
	add.l #2048,%d0
	add.l %d2,%a0
	add.l %d2,%d0
	jra .L375
	.size	fl_mig_apply_to, .-fl_mig_apply_to
	.align	2
	.type	fl_migrate_saved.constprop.0, @function
fl_migrate_saved.constprop.0:
	move.l fl_mig_active,%d1
	lea (-68,%sp),%sp
	movem.l #31996,(%sp)
	or.l fl_mig_pristine,%d1
	move.l 72(%sp),52(%sp)
	move.l 76(%sp),64(%sp)
	move.l %d1,60(%sp)
	tst.l %d1
	jeq .L401
	move.l #1074668000,%d7
	lea fl_migration_table+3,%a4
	clr.l 60(%sp)
	move.l %d7,44(%sp)
	clr.l 48(%sp)
.L415:
	move.l 48(%sp),%d2
	mov3q.l #1,%d1
	lsl.l %d2,%d1
	move.l 52(%sp),%d0
	and.l %d1,%d0
	move.l %d1,56(%sp)
	tst.l %d0
	jne .L446
.L414:
	move.l #635712,%d2
	addq.l #1,48(%sp)
	lea (160,%a4),%a4
	add.l %d2,44(%sp)
	cmp.l #fl_migration_table+2563,%a4
	jne .L415
.L401:
	lea fl_migration_table+3,%a2
	clr.l %d2
	lea fl_io_irq_lock,%a5
	lea fl_generation,%a3
	lea fl_io_irq_restore,%a4
.L419:
	mov3q.l #1,%d3
	lsl.l %d2,%d3
	move.l 52(%sp),%d0
	and.l %d3,%d0
	tst.l %d0
	jeq .L417
	mvz.b (%a2),%d0
	subq.l #1,%d0
	tst.l %d0
	jeq .L447
.L417:
	addq.l #1,%d2
	lea (160,%a2),%a2
	cmp.l #fl_migration_table+2563,%a2
	jne .L419
.L451:
	tst.l 60(%sp)
	jeq .L420
	tst.l 64(%sp)
	jeq .L421
	tst.l fl_io_loaded
	jeq .L428
	move.l 60(%sp),-(%sp)
	jsr store_ab
	addq.l #4,%sp
	tst.l %d0
	jne .L400
.L420:
	move.l 52(%sp),%d0
	not.l %d0
	and.l fl_mig_pending,%d0
	move.l %d0,fl_mig_pending
	tst.l fl_mig_active
	jeq .L424
	tst.l %d0
	jeq .L425
.L424:
	clr.l %d0
.L400:
	movem.l (%sp),#31996
	lea (68,%sp),%sp
	rts
.L446:
	mvz.b 269161678,%d0
	move.l 44(%sp),%d4
	cmp.l %d2,%d0
	jeq .L448
.L404:
	tst.b (%a4)
	jne .L414
	add.l #585088,%d4
	lea (9,%a4),%a6
	clr.l %d6
	lea (1,%a4),%a2
	clr.l %d5
.L406:
	move.l %d4,%a0
	move.l %d4,%a3
	lea (481,%a0),%a0
	clr.l %d0
	move.l %a6,%a1
	lea (34,%a3),%a3
.L411:
	mvz.b (%a3,%d0.l),%d1
	subq.l #1,%d1
	tst.l %d1
	jeq .L449
.L409:
	addq.l #1,%d0
	addq.l #2,%a1
	lea (30,%a0),%a0
	moveq #8,%d3
	cmp.l %d0,%d3
	jne .L411
.L450:
	lea (16,%a6),%a6
	addq.l #1,%a2
	add.l #6322,%d4
	addq.l #8,%d6
	moveq #64,%d7
	cmp.l %d6,%d7
	jne .L406
	tst.l %d5
	jeq .L414
	move.b #2,(%a4)
	move.l #635712,%d2
	lea (160,%a4),%a4
	jsr fl_io_irq_lock
	move.l 48(%sp),%a5
	move.l 56(%sp),%d1
	lea fl_generation,%a0
	or.l %d1,fl_dirty_mask
	addq.l #1,(%a0,%a5.l*4)
	move.l %d0,-(%sp)
	jsr fl_io_irq_restore
	addq.l #4,%sp
	mov3q.l #1,fl_mig_active
	addq.l #1,48(%sp)
	move.l 56(%sp),%d1
	add.l %d2,44(%sp)
	or.l %d1,60(%sp)
	cmp.l #fl_migration_table+2563,%a4
	jne .L415
	jra .L401
.L449:
	mvz.b -421(%a0),%d1
	move.l %a0,%d2
	moveq #70,%d7
	add.l #-421,%d2
	cmp.l %d1,%d7
	jne .L409
	move.l %d2,%a5
	moveq #77,%d3
	mvz.b 1(%a5),%d1
	cmp.l %d1,%d3
	jne .L409
	move.b 2(%a5),%d3
	mov3q.l #1,%d7
	mvz.b %d3,%d1
	cmp.l %d1,%d7
	jne .L409
	move.b (%a2),%d2
	lsl.l %d0,%d1
	mov3q.l #1,%d5
	mov3q.l #3,%d7
	or.l %d2,%d1
	move.b %d1,(%a2)
	move.b -1(%a0),%d1
	move.l %d1,%d2
	subq.l #1,%d2
	mvz.b %d2,%d2
	cmp.l %d2,%d7
	jcs .L410
	move.b %d1,%d3
.L410:
	move.b %d3,(%a1)
	moveq #127,%d2
	addq.l #1,%d0
	addq.l #2,%a1
	lea (30,%a0),%a0
	moveq #8,%d3
	move.b -30(%a0),%d1
	and.l %d2,%d1
	move.b %d1,-1(%a1)
	cmp.l %d0,%d3
	jne .L411
	jra .L450
.L448:
	move.l 1187521622,%d0
	move.l %d0,%d1
	add.l #-1073741824,%d1
	cmp.l #134217727,%d1
	jhi .L404
	move.l %d0,%d4
	jra .L404
.L447:
	move.b #2,(%a2)
	lea (160,%a2),%a2
	jsr (%a5)
	or.l %d3,fl_dirty_mask
	addq.l #1,(%a3,%d2.l*4)
	move.l %d0,-(%sp)
	jsr (%a4)
	or.l %d3,64(%sp)
	addq.l #4,%sp
	addq.l #1,%d2
	cmp.l #fl_migration_table+2563,%a2
	jne .L419
	jra .L451
.L425:
	clr.l -(%sp)
	mov3q.l #1,fl_mig_durable
	jsr (fl_mig_comment.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jne .L400
	mov3q.l #1,%d1
	cmp.l 64(%sp),%d1
	jne .L400
	movem.l (%sp),#31996
	mov3q.l #1,72(%sp)
	lea (68,%sp),%sp
	jra (fl_mig_comment.constprop.0)
.L421:
	tst.l fl_io_loaded
	jeq .L420
	move.l 60(%sp),-(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jeq .L420
	jra .L400
.L428:
	movem.l (%sp),#31996
	moveq #-60,%d0
	lea (68,%sp),%sp
	rts
	.size	fl_migrate_saved.constprop.0, .-fl_migrate_saved.constprop.0
	.align	2
	.type	fl_mig_run, @function
fl_mig_run:
	lea (-40,%sp),%sp
	movem.l #15612,(%sp)
	move.l 48(%sp),%a3
	move.l 44(%sp),%a5
	move.l %a5,%d1
	or.l %d1,fl_mig_known_mask
	move.l fl_mig_capture_mask,%d0
	tst.l %a3
	jne .L453
	not.l %d1
	and.l %d1,%d0
	move.l #1074668000,%d4
	clr.l %d5
	lea fl_migration_table+3,%a2
	move.l %d0,fl_mig_capture_mask
	clr.l %d0
.L471:
	mov3q.l #1,%d3
	lsl.l %d0,%d3
	move.l %a5,%d1
	and.l %d3,%d1
	tst.l %d1
	jeq .L456
	mvz.b 269161678,%d1
	move.l %d4,%a0
	cmp.l %d0,%d1
	jeq .L518
.L458:
	mvz.b (%a2),%d1
	mov3q.l #2,%d6
	cmp.l %d1,%d6
	jeq .L456
	subq.l #1,%d1
	tst.l %d1
	jeq .L461
	tst.l %a3
	jne .L519
.L456:
	addq.l #1,%d0
	add.l #635712,%d4
	lea (160,%a2),%a2
	moveq #16,%d1
	cmp.l %d0,%d1
	jne .L471
.L526:
	clr.l %d2
	lea fl_mig_capture,%a2
	lea fl_io_irq_restore,%a3
.L476:
	mov3q.l #1,%d3
	lsl.l %d2,%d3
	move.l %d3,%d0
	and.l %d5,%d0
	tst.l %d0
	jne .L520
.L473:
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L476
.L527:
	tst.l %d5
	jeq .L477
	clr.l fl_mig_durable
	tst.l fl_io_loaded
	jne .L521
.L478:
	move.l #1074668000,%a2
	clr.l %d2
	move.l #635698,%a4
	lea fl_mig_apply_to,%a3
.L486:
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	and.l %d5,%d0
	tst.l %d0
	jeq .L479
	mvz.b 269161678,%d0
	cmp.l %d0,%d2
	jeq .L522
.L480:
	clr.l -(%sp)
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (12,%sp),%sp
	move.l %a2,%d4
.L482:
	mvz.b 269161678,%d0
	cmp.l %d0,%d2
	jeq .L523
.L485:
	mov3q.l #1,(%a2,%a4.l)
.L479:
	addq.l #1,%d2
	add.l #635712,%a2
	moveq #16,%d6
	cmp.l %d2,%d6
	jne .L486
	or.l %d5,fl_mig_pending
	mov3q.l #1,fl_mig_active
.L477:
	movem.l (%sp),#15612
	clr.l %d0
	lea (40,%sp),%sp
	rts
.L518:
	move.l 1187521622,%d1
	move.l %d1,%a1
	add.l #-1073741824,%a1
	cmp.l #134217727,%a1
	jhi .L458
	move.l %d1,%a0
	jra .L458
.L519:
	move.l #629642,%a4
	move.l %a0,%d2
	add.l %a0,%a4
	add.l #585388,%d2
	move.l %d2,%a1
	move.l %d2,%a0
	lea (-266,%a1),%a1
	lea (-240,%a0),%a0
.L465:
	mvz.b (%a1),%d1
	addq.l #1,%a1
	subq.l #1,%d1
	tst.l %d1
	jeq .L524
.L463:
	lea (30,%a0),%a0
	cmp.l %a0,%d2
	jne .L465
	cmp.l %d2,%a4
	jeq .L456
	add.l #6322,%d2
	move.l %d2,%a1
	move.l %d2,%a0
	lea (-266,%a1),%a1
	lea (-240,%a0),%a0
	jra .L465
.L524:
	mvz.b (%a0),%d1
	moveq #70,%d6
	cmp.l %d1,%d6
	jne .L463
	mvz.b 1(%a0),%d1
	moveq #77,%d6
	cmp.l %d1,%d6
	jne .L463
	mvz.b 2(%a0),%d1
	subq.l #1,%d1
	tst.l %d1
	jne .L463
	cmp.l %d2,%a4
	jeq .L525
.L461:
	move.l %d3,%d1
	and.l fl_ready_mask,%d1
	tst.l %d1
	jeq .L468
	move.l %d3,%d1
	and.l fl_blocked_mask,%d1
	tst.l %d1
	jne .L468
	move.l %d3,%d1
	and.l fl_io_protected_mask,%d1
	tst.l %d1
	jne .L468
	or.l %d3,%d5
	addq.l #1,%d0
	add.l #635712,%d4
	lea (160,%a2),%a2
	moveq #16,%d1
	cmp.l %d0,%d1
	jne .L471
	jra .L526
.L520:
	move.l %d2,-(%sp)
	jsr (%a2)
	addq.l #4,%sp
	subq.l #2,%d0
	tst.l %d0
	jne .L473
	jsr fl_io_irq_lock
	or.l %d3,fl_blocked_mask
	move.l %d3,%d6
	not.l %d6
	and.l %d6,%d5
	lea fl_lane_free,%a0
	move.l %d0,-(%sp)
	or.l %d3,fl_io_pool_mask
	and.l %d6,fl_ready_mask
	move.l (%a0),fl_io_pool_free
	jsr (%a3)
	addq.l #4,%sp
	moveq #-64,%d0
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L473
	pea -64.w
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L476
	jra .L527
.L525:
	tst.l %a3
	jne .L461
	addq.l #1,%d0
	add.l #635712,%d4
	lea (160,%a2),%a2
	moveq #16,%d1
	cmp.l %d0,%d1
	jne .L471
	jra .L526
.L453:
	or.l %d1,%d0
	move.l #1074668000,%d4
	clr.l %d5
	lea fl_migration_table+3,%a2
	move.l %d0,fl_mig_capture_mask
	clr.l %d0
	jra .L471
.L522:
	move.l 1187521622,%d0
	move.l %d0,%d4
	add.l #-1073741824,%d0
	cmp.l #134217727,%d0
	jhi .L480
	clr.l -(%sp)
	move.l %d4,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (12,%sp),%sp
	cmp.l %a2,%d4
	jeq .L482
	clr.l -(%sp)
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (12,%sp),%sp
	mvz.b 269161678,%d0
	cmp.l %d0,%d2
	jne .L485
.L523:
	mov3q.l #1,-(%sp)
	move.l %d4,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	mov3q.l #1,269452696
	lea (12,%sp),%sp
	mov3q.l #1,(%a2,%a4.l)
	jra .L479
.L521:
	move.l %d5,-(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jeq .L478
	movem.l (%sp),#15612
	lea (40,%sp),%sp
	rts
.L468:
	movem.l (%sp),#15612
	moveq #-61,%d0
	lea (40,%sp),%sp
	rts
	.size	fl_mig_run, .-fl_mig_run
	.align	2
	.type	fl_migrate_restored.constprop.0, @function
fl_migrate_restored.constprop.0:
	link.w %fp,#-8
	move.l %d2,-(%sp)
	pea -4(%fp)
	pea -8(%fp)
	mov3q.l #1,-(%sp)
	jsr (fl_mig_text_read.constprop.0)
	lea (12,%sp),%sp
	mov3q.l #1,%d2
	move.l 8(%fp),%d1
	not.l %d1
	and.l %d1,fl_mig_known_mask
	and.l %d1,fl_mig_capture_mask
	cmp.l %d0,%d2
	jcc .L532
	move.l -12(%fp),%d2
	unlk %fp
	rts
.L532:
	tst.l -4(%fp)
	seq %d0
	and.l %d1,fl_mig_pending
	mvs.b %d0,%d0
	neg.l %d0
	move.l %d0,-(%sp)
	move.l 8(%fp),-(%sp)
	jsr fl_mig_run
	move.l -12(%fp),%d2
	addq.l #8,%sp
	unlk %fp
	rts
	.size	fl_migrate_restored.constprop.0, .-fl_migrate_restored.constprop.0
	.align	2
	.type	fl_migrate_load.constprop.0, @function
fl_migrate_load.constprop.0:
	link.w %fp,#-12
	move.l %d2,-(%sp)
	pea -4(%fp)
	pea -8(%fp)
	clr.l -(%sp)
	jsr (fl_mig_text_read.constprop.0)
	clr.l fl_mig_known_mask
	clr.l fl_mig_capture_mask
	clr.l fl_mig_pending
	clr.l fl_mig_active
	clr.l fl_mig_pristine
	clr.l fl_mig_durable
	lea (12,%sp),%sp
	tst.l %d0
	jne .L533
	move.l -4(%fp),%a1
	clr.l %d1
	lea fl_migration_table+3,%a0
	move.l %a1,fl_mig_active
	move.l %a1,fl_mig_marked
	move.l %a1,fl_mig_durable
.L535:
	move.b (%a0),%d0
	mov3q.l #2,%d2
	lea (160,%a0),%a0
	eor.l %d2,%d0
	tst.b %d0
	seq %d0
	mvs.b %d0,%d0
	neg.l %d0
	or.l %d0,%d1
	cmp.l #fl_migration_table+2563,%a0
	jne .L535
	tst.l %a1
	seq %d0
	mvs.b %d0,%d0
	neg.l %d0
	move.l %d0,-(%sp)
	move.l #65535,-(%sp)
	move.l %d1,-12(%fp)
	jsr fl_mig_run
	addq.l #8,%sp
	tst.l %d0
	jne .L533
	tst.l -12(%fp)
	jeq .L537
	mov3q.l #1,fl_mig_active
.L533:
	move.l -16(%fp),%d2
	unlk %fp
	rts
.L537:
	tst.l fl_mig_active
	jne .L533
	move.l -16(%fp),%d2
	mov3q.l #1,fl_mig_pristine
	unlk %fp
	rts
	.size	fl_migrate_load.constprop.0, .-fl_migrate_load.constprop.0
	.align	2
	.type	restore_mask, @function
restore_mask:
	lea (-32,%sp),%sp
	movem.l #19516,(%sp)
	move.l 36(%sp),%d5
	clr.l %d2
	lea read_bank,%a6
	lea (write_buffer.constprop.0),%a2
	lea (publish.constprop.0),%a3
.L550:
	mov3q.l #1,%d3
	lsl.l %d2,%d3
	move.l %d3,%d0
	and.l %d5,%d0
	tst.l %d0
	jne .L558
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L550
.L561:
	clr.l %d0
.L542:
	movem.l (%sp),#19516
	lea (32,%sp),%sp
	rts
.L558:
	pea 28(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	jsr (%a6)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L559
	tst.l %d0
	jne .L542
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr (%a2)
	addq.l #8,%sp
	tst.l %d0
	jne .L542
	move.l 28(%sp),-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	addq.l #8,%sp
	moveq #-64,%d1
	cmp.l %d0,%d1
	jeq .L560
	tst.l %d0
	jne .L551
	move.l %d3,%d0
	not.l %d3
	or.l fl_present_mask,%d0
	and.l %d3,fl_io_protected_mask
	move.l %d0,fl_present_mask
.L562:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L550
	jra .L561
.L559:
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	pea fl_io_path
	jsr (path_for.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L545
	pea fl_io_path
	jsr fl_io_fs_remove
	addq.l #4,%sp
	tst.l %d0
	jge .L545
	moveq #-12,%d1
	cmp.l %d0,%d1
	jne .L542
.L545:
	move.l %d2,-(%sp)
	jsr fresh_bank
	not.l %d3
	addq.l #4,%sp
	move.l %d3,%d0
	and.l fl_present_mask,%d0
	and.l %d3,fl_io_protected_mask
	move.l %d0,fl_present_mask
	jra .L562
.L560:
	move.l %d1,fl_io_last_error
	tst.l fl_io_warning
	jne .L549
	pea -64.w
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
.L549:
	addq.l #1,%d2
	moveq #16,%d0
	or.l %d3,fl_present_mask
	cmp.l %d2,%d0
	jne .L550
	jra .L561
.L551:
	movem.l (%sp),#19516
	moveq #-60,%d0
	lea (32,%sp),%sp
	rts
	.size	restore_mask, .-restore_mask
	.align	2
	.type	load_bank, @function
load_bank:
	lea (-28,%sp),%sp
	movem.l #17436,(%sp)
	move.l 32(%sp),%d3
	mov3q.l #1,%d2
	pea 24(%sp)
	clr.l -(%sp)
	lsl.l %d3,%d2
	move.l %d3,-(%sp)
	pea fl_io_base
	clr.l 40(%sp)
	lea read_bank,%a2
	move.l %d2,%d4
	not.l %d4
	and.l %d4,fl_present_mask
	jsr (%a2)
	lea (16,%sp),%sp
	move.l %d0,%a6
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jeq .L564
	or.l %d2,fl_present_mask
	tst.l %a6
	jeq .L598
	pea 24(%sp)
	mov3q.l #1,-(%sp)
	move.l %d3,-(%sp)
	pea fl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L582
	or.l %d2,fl_present_mask
	tst.l %d0
	jne .L582
.L583:
	move.l 24(%sp),-(%sp)
	move.l %d3,-(%sp)
	jsr (publish.constprop.0)
	addq.l #8,%sp
	move.l %d0,%d1
	moveq #-64,%d0
	cmp.l %d1,%d0
	jeq .L594
	tst.l %d1
	jne .L569
	moveq #-61,%d3
	cmp.l %a6,%d3
	jeq .L599
	or.l %d2,fl_io_protected_mask
	tst.l %a6
	jlt .L576
	move.w #-60,%a6
.L576:
	move.l %a6,fl_io_last_error
	tst.l fl_io_warning
	jne .L563
	mov3q.l #1,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	clr.l %d1
.L563:
	movem.l (%sp),#17436
	move.l %d1,%d0
	lea (28,%sp),%sp
	rts
.L598:
	move.l 24(%sp),-(%sp)
	move.l %d3,-(%sp)
	jsr (publish.constprop.0)
	addq.l #8,%sp
	move.l %d0,%d1
	moveq #-64,%d0
	cmp.l %d1,%d0
	jeq .L594
	tst.l %d1
	jne .L569
	pea 24(%sp)
	mov3q.l #1,-(%sp)
	move.l %d3,-(%sp)
	moveq #-61,%d3
	pea fl_io_base
	move.l %d1,36(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	move.l 20(%sp),%d1
	cmp.l %d0,%d3
	jeq .L600
	tst.l %d0
	jge .L563
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L563
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d1,28(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 20(%sp),%d1
.L602:
	movem.l (%sp),#17436
	move.l %d1,%d0
	lea (28,%sp),%sp
	rts
.L564:
	pea 24(%sp)
	mov3q.l #1,-(%sp)
	move.l %d3,-(%sp)
	pea fl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jne .L601
	move.l %d3,-(%sp)
	jsr fresh_bank
	addq.l #4,%sp
	movem.l (%sp),#17436
	clr.l %d1
	move.l %d1,%d0
	lea (28,%sp),%sp
	rts
.L601:
	or.l %d2,fl_present_mask
	tst.l %d0
	jeq .L583
	or.l %d2,fl_blocked_mask
	and.l %d4,fl_ready_mask
.L578:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L569
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
.L569:
	moveq #-60,%d1
	move.l %d1,%d0
	movem.l (%sp),#17436
	lea (28,%sp),%sp
	rts
.L599:
	or.l %d2,fl_blocked_mask
	and.l %d4,fl_ready_mask
	or.l %d2,fl_io_protected_mask
	jra .L576
.L600:
	or.l %d2,fl_blocked_mask
	and.l %d4,fl_ready_mask
	move.l %d3,fl_io_last_error
	tst.l fl_io_warning
	jne .L563
	pea -61.w
	pea fl_io_ui_warning
	move.l %d1,28(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 20(%sp),%d1
	jra .L602
.L582:
	or.l %d2,fl_blocked_mask
	move.l %a6,%d0
	and.l %d4,fl_ready_mask
	jra .L578
.L594:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L563
	pea -64.w
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	movem.l (%sp),#17436
	moveq #-64,%d1
	move.l %d1,%d0
	lea (28,%sp),%sp
	rts
	.size	load_bank, .-load_bank
	.align	2
	.type	load_project, @function
load_project:
	lea (-272,%sp),%sp
	movem.l #17412,(%sp)
	clr.l -(%sp)
	clr.l -(%sp)
	jsr fl_io_stock_directory
	addq.l #8,%sp
	tst.l %d0
	jeq .L608
	lea (12,%sp),%a6
	move.l %sp,%d2
	move.l %d0,%a1
	add.l #272,%d2
	move.l %a6,%a0
.L607:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L606
	cmp.l %a0,%d2
	jne .L607
.L608:
	movem.l (%sp),#17412
	moveq #-63,%d0
	lea (272,%sp),%sp
	rts
.L606:
	jsr fl_reset
	jsr fl_clip_reset
	jsr fl_seq_reset
	clr.l fl_io_protected_mask
	clr.l fl_io_loaded
	clr.l fl_io_warning
	clr.l fl_io_last_error
	clr.l fl_present_mask
	clr.l fl_io_pool_mask
	lea fl_io_base,%a0
.L610:
	addq.l #1,%a0
	addq.l #1,%a6
	move.b -1(%a6),%d0
	move.b %d0,-1(%a0)
	jeq .L609
	cmp.l %a6,%d2
	jne .L610
	clr.b %d0
	move.b %d0,fl_io_base
.L609:
	sub.l %a6,%a6
	lea load_bank,%a2
.L611:
	move.l %a6,-(%sp)
	jsr (%a2)
	addq.l #1,%a6
	addq.l #4,%sp
	moveq #16,%d0
	cmp.l %a6,%d0
	jne .L611
	movem.l (%sp),#17412
	clr.l %d0
	mov3q.l #1,fl_io_loaded
	lea (272,%sp),%sp
	rts
	.size	load_project, .-load_project
	.align	2
	.type	own_run, @function
own_run:
	lea (-280,%sp),%sp
	movem.l #16444,(%sp)
	jsr fl_io_irq_lock
	move.l fl_io_own_work,%d3
	clr.l fl_io_own_work
	clr.l fl_io_flush_pending
	move.l %d0,-(%sp)
	jsr fl_io_irq_restore
	addq.l #4,%sp
	move.w %d3,%ccr
	jne .L621
	tst.l fl_io_loaded
	jeq .L657
.L621:
	btst #1,%d3
	jne .L658
.L626:
	btst #0,%d3
	jeq .L620
	tst.l fl_io_loaded
	jeq .L620
	move.l #65535,-(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jne .L659
.L620:
	movem.l (%sp),#16444
	lea (280,%sp),%sp
	rts
.L658:
	tst.l fl_io_loaded
	jeq .L620
	sub.l %a6,%a6
	move.l %a6,%d0
	mov3q.l #1,%d2
	lsl.l %d0,%d2
	move.l fl_io_pool_mask,%d5
	move.l %d5,%d0
	and.l %d2,%d0
	tst.l %d0
	jne .L660
.L628:
	addq.l #1,%a6
	moveq #16,%d0
	cmp.l %a6,%d0
	jeq .L626
.L656:
	move.l %a6,%d0
	mov3q.l #1,%d2
	lsl.l %d0,%d2
	move.l %d5,%d0
	and.l %d2,%d0
	tst.l %d0
	jeq .L628
.L660:
	move.l %a6,-(%sp)
	clr.l fl_io_warning
	jsr load_bank
	addq.l #4,%sp
	move.l %d2,%d1
	and.l fl_io_pool_mask,%d1
	or.l %d0,%d1
	jne .L628
	tst.l fl_mig_marked
	seq %d0
	mvs.b %d0,%d0
	neg.l %d0
	move.l %d0,-(%sp)
	move.l %d2,-(%sp)
	jsr fl_mig_run
	addq.l #8,%sp
	tst.l %d0
	jeq .L628
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L628
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	addq.l #1,%a6
	moveq #16,%d0
	cmp.l %a6,%d0
	jne .L656
	jra .L626
.L657:
	clr.l -(%sp)
	clr.l -(%sp)
	jsr fl_io_stock_directory
	addq.l #8,%sp
	tst.l %d0
	jeq .L621
	move.l %d0,%a1
	lea (280,%sp),%a6
	lea (20,%sp),%a0
.L624:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L623
	cmp.l %a0,%a6
	jne .L624
	btst #1,%d3
	jeq .L626
	jra .L658
.L659:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L620
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	movem.l (%sp),#16444
	lea (280,%sp),%sp
	rts
.L623:
	jsr load_project
	tst.l %d0
	jne .L630
	jsr (fl_migrate_load.constprop.0)
	tst.l %d0
	jge .L621
.L625:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L621
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	btst #1,%d3
	jeq .L626
	jra .L658
.L630:
	moveq #-63,%d0
	jra .L625
	.size	own_run, .-own_run
	.align	2
	.globl	fl_io_play_tick
	.type	fl_io_play_tick, @function
fl_io_play_tick:
	move.l %d2,-(%sp)
	tst.l fl_io_loaded
	jeq .L662
	move.l fl_dirty_mask,%d1
	move.l fl_ready_mask,%a0
	move.l %a0,%d2
	move.l fl_blocked_mask,%d0
	and.l %d2,%d1
	or.l fl_io_protected_mask,%d0
	not.l %d0
	and.l %d1,%d0
	tst.l %d0
	jeq .L662
	move.l fl_io_play_ticks,%d0
	moveq #59,%d1
	addq.l #1,%d0
	cmp.l %d0,%d1
	jcc .L668
	clr.l fl_io_play_ticks
	tst.l fl_io_flush_pending
	jeq .L669
	move.l (%sp)+,%d2
	rts
.L662:
	move.l (%sp)+,%d2
	clr.l fl_io_play_ticks
	rts
.L669:
	mov3q.l #1,-(%sp)
	jsr (own_post.isra.0)
	addq.l #4,%sp
	move.l (%sp)+,%d2
	rts
.L668:
	move.l (%sp)+,%d2
	move.l %d0,fl_io_play_ticks
	rts
	.size	fl_io_play_tick, .-fl_io_play_tick
	.align	2
	.globl	fl_io_before_job
	.type	fl_io_before_job, @function
fl_io_before_job:
	subq.l #4,%sp
	move.l %d2,-(%sp)
	move.l 12(%sp),%a0
	cmp.l #fl_io_flush_job,%a0
	jeq .L704
	move.b (%a0),%d1
	mov3q.l #2,%d2
	mvz.b %d1,%d0
	move.l %d0,fl_io_job_kind
	cmp.l %d0,%d2
	jeq .L705
	clr.l fl_io_warning
	moveq #18,%d2
	cmp.l %d0,%d2
	jcs .L674
	move.l #401296,%d2
	btst %d0,%d2
	jeq .L674
	tst.l fl_io_loaded
	jne .L676
	moveq #8,%d1
	cmp.l %d0,%d1
	jeq .L701
	moveq #12,%d1
	cmp.l %d0,%d1
	jeq .L701
.L674:
	clr.l %d0
.L670:
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L705:
	tst.l fl_io_loaded
	jeq .L674
	move.l #65535,-(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
.L680:
	tst.l %d0
	jeq .L670
	move.l %d0,fl_io_last_error
	move.l fl_io_warning,%d1
	tst.l %d1
	jne .L670
.L678:
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,12(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
.L706:
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L676:
	move.l #65535,-(%sp)
	move.l %d1,8(%sp)
	jsr (flush_ab.constprop.0)
	move.l 8(%sp),%d1
	addq.l #4,%sp
	and.l #251,%d1
	subq.l #8,%d1
	tst.l %d1
	jne .L680
	tst.l fl_blocked_mask
	jeq .L680
	move.l fl_io_warning,%d1
	moveq #-61,%d0
	move.l %d0,fl_io_last_error
	tst.l %d1
	jne .L670
	jra .L678
.L701:
	tst.l fl_blocked_mask
	jeq .L674
	moveq #-61,%d0
	moveq #-61,%d2
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,12(%sp)
	move.l %d2,fl_io_last_error
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
	jra .L706
.L704:
	jsr own_run
	clr.l %d0
	jra .L670
	.size	fl_io_before_job, .-fl_io_before_job
	.align	2
	.globl	fl_io_reject_job
	.type	fl_io_reject_job, @function
fl_io_reject_job:
	lea (-12,%sp),%sp
	moveq #20,%d1
	move.l %d2,-(%sp)
	move.l 20(%sp),%a0
	move.l 24(%sp),12(%sp)
	mvz.b (%a0),%d0
	cmp.l %d0,%d1
	jcs .L707
	move.w .L710(%pc,%d0.l*2),%d0
	ext.l %d0
	jmp %pc@(2,%d0:l)
	.balignw 2,0x284c
	.swbeg	&21
.L710:
	.word .L707-.L710
	.word .L707-.L710
	.word .L712-.L710
	.word .L707-.L710
	.word .L715-.L710
	.word .L707-.L710
	.word .L707-.L710
	.word .L715-.L710
	.word .L715-.L710
	.word .L715-.L710
	.word .L713-.L710
	.word .L712-.L710
	.word .L711-.L710
	.word .L707-.L710
	.word .L707-.L710
	.word .L707-.L710
	.word .L707-.L710
	.word .L709-.L710
	.word .L709-.L710
	.word .L709-.L710
	.word .L709-.L710
.L707:
	move.l (%sp)+,%d2
	lea (12,%sp),%sp
	rts
.L715:
	mvz.w #270,%d0
	move.w #271,%a1
	mvz.w #269,%d1
	move.l %d0,4(%sp)
	mvz.w #268,%d0
.L714:
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
	jeq .L707
	move.l 12(%sp),24(%sp)
	move.l %d0,20(%sp)
	move.l (%sp)+,%d2
	lea (12,%sp),%sp
	jra fl_io_post
.L709:
	moveq #10,%d2
	moveq #9,%d1
	move.w #11,%a1
	move.l %d2,4(%sp)
	moveq #8,%d0
	jra .L714
.L712:
	moveq #8,%d2
	mov3q.l #7,%d1
	move.w #9,%a1
	move.l %d2,4(%sp)
	mov3q.l #6,%d0
	jra .L714
.L713:
	moveq #12,%d0
	moveq #11,%d1
	move.l %d0,4(%sp)
	moveq #10,%d0
	move.w #13,%a1
	jra .L714
.L711:
	mvz.w #528,%d1
	move.w #529,%a1
	mvz.w #526,%d0
	move.l %d1,4(%sp)
	mvz.w #527,%d1
	jra .L714
	.size	fl_io_reject_job, .-fl_io_reject_job
	.align	2
	.globl	fl_mig_marker_due
	.type	fl_mig_marker_due, @function
fl_mig_marker_due:
	move.l fl_io_loaded,%d0
	tst.l %d0
	jeq .L721
	move.l fl_mig_active,%d0
	tst.l %d0
	jeq .L721
	move.l fl_mig_durable,%d0
	tst.l %d0
	jeq .L721
	tst.l fl_mig_pending
	seq %d0
	mvs.b %d0,%d0
	neg.l %d0
.L721:
	rts
	.size	fl_mig_marker_due, .-fl_mig_marker_due
	.align	2
	.globl	fl_mig_retire_current
	.type	fl_mig_retire_current, @function
fl_mig_retire_current:
	lea (-40,%sp),%sp
	mov3q.l #7,%d0
	move.l 44(%sp),%d1
	movem.l #1036,(%sp)
	move.l 48(%sp),%a1
	cmp.l %d1,%d0
	jcs .L734
	tst.l fl_io_loaded
	jeq .L734
	move.b 269161678,%d0
	move.b 269161679,%d2
	move.l 1187521622,%a0
	mvz.b %d0,%d3
	move.b %d2,24(%sp)
	moveq #15,%d2
	move.l %d3,28(%sp)
	cmp.l %d3,%d2
	jcs .L734
	mvz.b 24(%sp),%d3
	mov3q.l #3,%d2
	move.l %d3,24(%sp)
	cmp.l %d3,%d2
	jcs .L734
	add.l #-1073741824,%a0
	cmp.l #134217727,%a0
	jhi .L734
	mov3q.l #1,%d3
	move.l 28(%sp),%d2
	lsl.l %d2,%d3
	move.l %d3,32(%sp)
	and.l fl_ready_mask,%d3
	tst.l %d3
	jeq .L734
	move.l 32(%sp),%d3
	and.l fl_blocked_mask,%d3
	tst.l %d3
	jne .L734
	ext.w %d0
	mov3q.l #1,%d3
	mulu.w #160,%d0
	move.l %d0,%a0
	add.l #fl_migration_table,%a0
	move.b 3(%a0),%d0
	mvz.b %d0,%d2
	cmp.l %d2,%d3
	jcs .L734
	tst.b %d0
	jne .L740
	move.l 32(%sp),%d0
	and.l fl_mig_known_mask,%d0
	tst.l %d0
	jeq .L734
	move.l 32(%sp),%d0
	and.l fl_mig_capture_mask,%d0
	tst.l %d0
	jne .L739
.L741:
	tst.l %a1
	jeq .L734
.L740:
	move.l %d1,12(%sp)
	move.l %a0,16(%sp)
	jsr fl_io_irq_lock
	mov3q.l #1,%d3
	move.l 16(%sp),%a0
	move.l %d0,36(%sp)
	move.l 12(%sp),%d1
	move.b 3(%a0),%d0
	mvz.b %d0,%d2
	cmp.l %d2,%d3
	jcc .L755
.L738:
	movem.l (%sp),#1036
	move.l 36(%sp),44(%sp)
	lea (40,%sp),%sp
	jra fl_io_irq_restore
.L734:
	movem.l (%sp),#1036
	lea (40,%sp),%sp
	rts
.L755:
	tst.b %d0
	jne .L742
	mov3q.l #1,(%a0)
.L742:
	move.l 24(%sp),%a1
	mov3q.l #1,%d2
	lsl.l %d1,%d2
	move.l 32(%sp),%d3
	lea 4(%a0,%a1.l),%a1
	move.l 28(%sp),%a0
	move.l %d2,%d1
	not.l %d1
	move.l %a1,%a2
	move.b (%a2),27(%sp)
	lea fl_generation,%a1
	move.b 27(%sp),%d2
	and.l %d2,%d1
	move.b %d1,(%a2)
	or.l %d3,fl_dirty_mask
	movem.l (%sp),#1036
	addq.l #1,(%a1,%a0.l*4)
	move.l 36(%sp),44(%sp)
	lea (40,%sp),%sp
	jra fl_io_irq_restore
.L739:
	move.l 28(%sp),-(%sp)
	move.l %d1,16(%sp)
	move.l %a0,20(%sp)
	move.l %a1,24(%sp)
	jsr fl_mig_capture
	addq.l #4,%sp
	move.l 16(%sp),%a0
	move.l 12(%sp),%d1
	move.l 20(%sp),%a1
	tst.b 3(%a0)
	jeq .L741
	move.l %d1,12(%sp)
	move.l %a0,16(%sp)
	jsr fl_io_irq_lock
	mov3q.l #1,%d3
	move.l 16(%sp),%a0
	move.l %d0,36(%sp)
	move.l 12(%sp),%d1
	move.b 3(%a0),%d0
	mvz.b %d0,%d2
	cmp.l %d2,%d3
	jcs .L738
	jra .L755
	.size	fl_mig_retire_current, .-fl_mig_retire_current
	.align	2
	.globl	fl_io_ui_tick
	.type	fl_io_ui_tick, @function
fl_io_ui_tick:
	lea (-280,%sp),%sp
	movem.l #16412,(%sp)
	tst.l 284(%sp)
	jne .L780
	move.l fl_io_full_seen,%d0
	clr.l fl_io_play_ticks
	cmp.l fl_lane_full.l,%d0
	jne .L781
.L759:
	move.l fl_lane_gc_mask,%d3
	tst.l %d3
	jeq .L760
	mov3q.l #1,%d1
	and.l %d3,%d1
	btst #0,%d3
	jne .L768
.L762:
	addq.l #1,%d1
	mov3q.l #1,%d0
	lsl.l %d1,%d0
	move.l %d0,%d2
	and.l %d3,%d2
	tst.l %d2
	jeq .L762
	move.l %d1,16(%sp)
	move.l %d0,%d2
	not.l %d2
	jsr fl_io_irq_lock
	move.l %d0,-(%sp)
	and.l %d2,fl_lane_gc_mask
	jsr fl_io_irq_restore
	move.l 20(%sp),%d1
	move.l %d1,-(%sp)
	jsr fl_io_core_gc
	addq.l #8,%sp
.L760:
	tst.l fl_io_pool_mask
	jeq .L763
	move.l fl_io_pool_free,%d0
	cmp.l fl_lane_free.l,%d0
	jcs .L782
.L763:
	tst.l fl_io_loaded
	jne .L756
	tst.l fl_io_flush_pending
	jeq .L783
.L756:
	movem.l (%sp),#16412
	lea (280,%sp),%sp
	rts
.L781:
	pea 48.w
	lea fl_lane_full,%a0
	move.l (%a0),fl_io_full_seen
	pea .LC2
	jsr fl_io_toast
	addq.l #8,%sp
	jra .L759
.L782:
	tst.l fl_io_flush_pending
	jne .L763
	mov3q.l #2,-(%sp)
	jsr (own_post.isra.0)
	addq.l #4,%sp
	jra .L763
.L780:
	jsr fl_io_play_tick
	move.l fl_io_full_seen,%d0
	cmp.l fl_lane_full.l,%d0
	jeq .L759
	jra .L781
.L783:
	clr.l -(%sp)
	clr.l -(%sp)
	jsr fl_io_stock_directory
	addq.l #8,%sp
	tst.l %d0
	jeq .L756
	move.l %d0,%a1
	lea (280,%sp),%a6
	lea (20,%sp),%a0
.L767:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L766
	cmp.l %a0,%a6
	jne .L767
	movem.l (%sp),#16412
	lea (280,%sp),%sp
	rts
.L768:
	clr.l %d1
	move.l %d1,16(%sp)
	moveq #-2,%d2
	jsr fl_io_irq_lock
	move.l %d0,-(%sp)
	and.l %d2,fl_lane_gc_mask
	jsr fl_io_irq_restore
	move.l 20(%sp),%d1
	move.l %d1,-(%sp)
	jsr fl_io_core_gc
	addq.l #8,%sp
	jra .L760
.L766:
	mov3q.l #4,-(%sp)
	jsr (own_post.isra.0)
	addq.l #4,%sp
	movem.l (%sp),#16412
	lea (280,%sp),%sp
	rts
	.size	fl_io_ui_tick, .-fl_io_ui_tick
	.align	2
	.globl	fl_io_engine_job
	.type	fl_io_engine_job, @function
fl_io_engine_job:
	move.l 4(%sp),%d0
	cmp.l #fl_io_flush_job,%d0
	jeq .L793
	move.l 4(%sp),-(%sp)
	jsr fl_io_before_job
	addq.l #4,%sp
	tst.l %d0
	jne .L794
	rts
.L794:
	move.l %d0,-(%sp)
	move.l 8(%sp),-(%sp)
	jsr fl_io_reject_job
	addq.l #8,%sp
	mov3q.l #1,%d0
.L795:
	rts
.L793:
	jsr own_run
	mov3q.l #1,%d0
	jra .L795
	.size	fl_io_engine_job, .-fl_io_engine_job
	.align	2
	.globl	fl_io_job_outstanding
	.type	fl_io_job_outstanding, @function
fl_io_job_outstanding:
	move.l fl_io_flush_pending,%d0
	rts
	.size	fl_io_job_outstanding, .-fl_io_job_outstanding
	.align	2
	.globl	fl_io_banks_load
	.type	fl_io_banks_load, @function
fl_io_banks_load:
	lea (-264,%sp),%sp
	move.l %a6,-(%sp)
	move.l 284(%sp),-(%sp)
	move.l 284(%sp),-(%sp)
	move.l 284(%sp),-(%sp)
	move.l 284(%sp),-(%sp)
	jsr fl_io_stock_banks_load
	move.l %d0,20(%sp)
	clr.l -(%sp)
	clr.l -(%sp)
	jsr fl_io_stock_directory
	lea (24,%sp),%sp
	tst.l %d0
	jeq .L798
	move.l %d0,%a1
	lea (8,%sp),%a0
	lea (268,%sp),%a6
.L801:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L800
	cmp.l %a0,%a6
	jne .L801
.L798:
	move.l 4(%sp),%d0
	move.l (%sp)+,%a6
	lea (264,%sp),%sp
	rts
.L800:
	tst.l fl_io_loaded
	jeq .L802
	mov3q.l #4,%d0
	cmp.l fl_io_job_kind.l,%d0
	jeq .L802
	move.b 8(%sp),%d0
	jeq .L819
	lea fl_io_base,%a1
	lea (8,%sp),%a0
.L805:
	mvs.b (%a1),%d1
	mvs.b %d0,%d0
	addq.l #1,%a0
	addq.l #1,%a1
	cmp.l %d0,%d1
	jne .L802
	move.b (%a0),%d0
	jne .L805
	move.b (%a1),%d0
	jeq .L798
.L802:
	jsr load_project
	tst.l %d0
	jne .L808
	jsr (fl_migrate_load.constprop.0)
	tst.l %d0
	jge .L798
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L798
.L820:
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
	move.l (%sp)+,%a6
	lea (264,%sp),%sp
	rts
.L808:
	moveq #-63,%d0
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L798
	jra .L820
.L819:
	move.b fl_io_base,%d0
	jeq .L798
	jra .L802
	.size	fl_io_banks_load, .-fl_io_banks_load
	.align	2
	.globl	fl_io_banks_save
	.type	fl_io_banks_save, @function
fl_io_banks_save:
	lea (-284,%sp),%sp
	movem.l #19484,(%sp)
	move.l 292(%sp),%d2
	move.l 300(%sp),-(%sp)
	move.l 300(%sp),-(%sp)
	move.l %d2,-(%sp)
	move.l 300(%sp),-(%sp)
	jsr fl_io_stock_banks_save
	lea (16,%sp),%sp
	move.l fl_io_job_kind,%d1
	subq.l #8,%d1
	move.l %d0,%d3
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jcc .L822
	tst.l %d3
	jlt .L821
	move.l fl_io_loaded,%a6
	tst.l %a6
	jne .L849
	mvz.w %d2,%d2
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	jsr (fl_migrate_saved.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jlt .L856
.L821:
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (284,%sp),%sp
	rts
.L822:
	clr.l -(%sp)
	clr.l -(%sp)
	jsr fl_io_stock_directory
	addq.l #8,%sp
	tst.l %d0
	jeq .L825
	lea (24,%sp),%a6
	move.l %d0,%a1
	move.l %a6,%a0
	lea (284,%sp),%a2
.L827:
	move.b (%a1),%d1
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d1,-1(%a0)
	jeq .L826
	cmp.l %a0,%a2
	jne .L827
	clr.b %d1
	move.b %d1,24(%sp)
.L825:
	clr.b %d0
	moveq #-63,%d1
	clr.l fl_io_loaded
	move.l %d1,fl_io_last_error
	move.b %d0,fl_io_base
	tst.l fl_io_warning
	jne .L831
	pea -63.w
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
.L831:
	tst.l %d3
	jlt .L821
	moveq #-63,%d3
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (284,%sp),%sp
	rts
.L826:
	tst.l fl_io_loaded
	jeq .L828
	move.b 24(%sp),%d0
	jeq .L875
	lea fl_io_base,%a1
	lea (24,%sp),%a0
.L833:
	mvs.b (%a1),%d1
	mvs.b %d0,%d0
	addq.l #1,%a0
	addq.l #1,%a1
	cmp.l %d0,%d1
	jne .L828
	move.b (%a0),%d0
	jne .L833
	move.b (%a1),%d0
.L830:
	tst.b %d0
	jne .L828
	tst.l %d3
	jlt .L821
.L849:
	mvz.w %d2,%d2
	move.l %d2,-(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jne .L856
	sub.l %a6,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	jsr (fl_migrate_saved.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jge .L821
.L856:
	move.l %d0,%d3
.L850:
	move.l %d3,fl_io_last_error
	tst.l fl_io_warning
	jne .L821
	move.l %d3,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (284,%sp),%sp
	rts
.L828:
	moveq #9,%d0
	cmp.l fl_io_job_kind.l,%d0
	jeq .L876
	lea fl_io_base,%a0
.L838:
	move.b (%a6),%d0
	addq.l #1,%a0
	addq.l #1,%a6
	move.b %d0,-1(%a0)
	jeq .L837
	cmp.l %a6,%a2
	jne .L838
	clr.b %d0
	move.b %d0,fl_io_base
.L837:
	mov3q.l #1,fl_io_loaded
	clr.l fl_io_protected_mask
	clr.l %d4
	clr.l %d2
	lea (path_for.part.0),%a2
	lea fl_io_fs_open,%a3
.L839:
	sub.l %a6,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	pea fl_io_path
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jeq .L877
.L841:
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jne .L853
.L879:
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L839
	move.l %d4,fl_present_mask
	jsr fl_io_irq_lock
	move.l fl_blocked_mask,%d1
	not.l %d1
	and.l fl_ready_mask,%d1
	move.l %d0,-(%sp)
	or.l %d1,fl_dirty_mask
	jsr fl_io_irq_restore
	addq.l #4,%sp
	tst.l %d3
	jlt .L850
	tst.l fl_io_loaded
	jeq .L854
	move.l #65535,-(%sp)
	jsr store_ab
	addq.l #4,%sp
	tst.l %d0
	jne .L856
	mvz.w #65535,%d2
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	jsr (fl_migrate_saved.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jge .L821
	jra .L856
.L877:
	pea 512.w
	pea fl_io_sector
	pea .LC6
	pea fl_io_path
	pea fl_io_object
	jsr (%a3)
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L878
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	or.l %d0,%d4
.L880:
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jeq .L879
.L853:
	mov3q.l #1,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	pea fl_io_path
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L841
	jra .L877
.L878:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jeq .L841
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	or.l %d0,%d4
	jra .L880
.L876:
	jsr fl_reset
	jsr fl_clip_reset
	jsr fl_seq_reset
	mvz.w #65535,%d1
	clr.l fl_present_mask
	clr.l fl_io_pool_mask
	clr.l fl_io_warning
	move.l %d1,fl_ready_mask
	clr.l fl_io_protected_mask
	clr.l fl_io_last_error
	clr.l fl_mig_pending
	clr.l fl_mig_active
	mov3q.l #1,fl_mig_pristine
	clr.l fl_mig_durable
	move.l %d1,fl_mig_known_mask
	clr.l fl_mig_capture_mask
	lea fl_io_base,%a0
	jra .L838
.L854:
	moveq #-60,%d3
	jra .L850
.L875:
	move.b fl_io_base,%d0
	jra .L830
	.size	fl_io_banks_save, .-fl_io_banks_save
	.align	2
	.globl	fl_io_card_sync
	.type	fl_io_card_sync, @function
fl_io_card_sync:
	lea (-12,%sp),%sp
	move.l 16(%sp),%d1
	move.l 20(%sp),%a0
	move.l 24(%sp),%a1
	tst.l fl_io_loaded
	jne .L891
.L882:
	move.l %a1,-(%sp)
	move.l %a0,-(%sp)
	move.l %d1,-(%sp)
	jsr fl_io_stock_card_sync
	lea (12,%sp),%sp
	tst.l %d0
	jge .L892
.L881:
	lea (12,%sp),%sp
	rts
.L891:
	move.l #65535,-(%sp)
	move.l %d1,12(%sp)
	move.l %a0,8(%sp)
	move.l %a1,4(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
	move.l 8(%sp),%d1
	move.l 4(%sp),%a0
	move.l (%sp),%a1
	tst.l %d0
	jeq .L882
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L881
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,16(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 8(%sp),%d0
	lea (12,%sp),%sp
	rts
.L892:
	clr.l 20(%sp)
	clr.l 16(%sp)
	lea (12,%sp),%sp
	jra (fl_migrate_saved.constprop.0)
	.size	fl_io_card_sync, .-fl_io_card_sync
	.align	2
	.globl	fl_io_project_store
	.type	fl_io_project_store, @function
fl_io_project_store:
	subq.l #4,%sp
	move.l %d2,-(%sp)
	move.l 20(%sp),-(%sp)
	move.l 20(%sp),-(%sp)
	move.l 20(%sp),-(%sp)
	jsr fl_io_stock_project_store
	lea (12,%sp),%sp
	move.l %d0,%d2
	tst.l %d0
	jlt .L893
	tst.l fl_io_loaded
	jeq .L899
	move.l #65535,-(%sp)
	jsr store_ab
	addq.l #4,%sp
	tst.l %d0
	jeq .L903
.L895:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L898
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,12(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
.L898:
	move.l %d0,%d2
.L893:
	move.l %d2,%d0
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L903:
	mov3q.l #1,-(%sp)
	move.l #65535,-(%sp)
	jsr (fl_migrate_saved.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jlt .L895
	move.l %d2,%d0
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L899:
	moveq #-60,%d0
	jra .L895
	.size	fl_io_project_store, .-fl_io_project_store
	.align	2
	.globl	fl_io_bank_store
	.type	fl_io_bank_store, @function
fl_io_bank_store:
	subq.l #4,%sp
	move.l %d2,-(%sp)
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	jsr fl_io_stock_bank_store
	lea (16,%sp),%sp
	move.l %d0,%d2
	tst.l %d0
	jlt .L904
	tst.l fl_io_loaded
	jeq .L910
	move.l 16(%sp),%d1
	mvz.w %d1,%d1
	move.l %d1,-(%sp)
	move.l %d1,8(%sp)
	jsr store_ab
	addq.l #4,%sp
	move.l 4(%sp),%d1
	tst.l %d0
	jeq .L914
.L906:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L909
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,12(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
.L909:
	move.l %d0,%d2
.L904:
	move.l %d2,%d0
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L914:
	mov3q.l #2,-(%sp)
	move.l %d1,-(%sp)
	jsr (fl_migrate_saved.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jlt .L906
	move.l %d2,%d0
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L910:
	moveq #-60,%d0
	jra .L906
	.size	fl_io_bank_store, .-fl_io_bank_store
	.align	2
	.globl	fl_io_project_restore
	.type	fl_io_project_restore, @function
fl_io_project_restore:
	move.l fl_blocked_mask,%d0
	subq.l #8,%sp
	move.l %a6,-(%sp)
	move.l %a2,-(%sp)
	mvz.w %d0,%d0
	move.l %d0,%a6
	tst.l %d0
	jne .L926
	lea read_bank,%a2
.L918:
	pea 12(%sp)
	mov3q.l #1,-(%sp)
	move.l %a6,-(%sp)
	pea fl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jcc .L932
	move.l %d1,fl_io_last_error
	tst.l fl_io_warning
	jne .L915
.L933:
	move.l %d1,-(%sp)
	pea fl_io_ui_warning
	move.l %d1,16(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 8(%sp),%d1
.L915:
	move.l (%sp)+,%a2
	move.l %d1,%d0
	move.l (%sp)+,%a6
	addq.l #8,%sp
	rts
.L932:
	addq.l #1,%a6
	moveq #16,%d0
	cmp.l %a6,%d0
	jne .L918
	move.l 28(%sp),-(%sp)
	move.l 28(%sp),-(%sp)
	move.l 28(%sp),-(%sp)
	jsr fl_io_stock_project_restore
	lea (12,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L915
	move.l #65535,-(%sp)
	move.l %d1,12(%sp)
	jsr restore_mask
	addq.l #4,%sp
	tst.l %d0
	jne .L922
	move.l #65535,-(%sp)
	jsr (fl_migrate_restored.constprop.0)
	addq.l #4,%sp
	move.l 8(%sp),%d1
	tst.l %d0
	jeq .L915
.L922:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L923
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,16(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 8(%sp),%d0
.L923:
	move.l (%sp)+,%a2
	move.l %d0,%d1
	move.l %d1,%d0
	move.l (%sp)+,%a6
	addq.l #8,%sp
	rts
.L926:
	moveq #-61,%d1
	move.l %d1,fl_io_last_error
	tst.l fl_io_warning
	jne .L915
	jra .L933
	.size	fl_io_project_restore, .-fl_io_project_restore
	.align	2
	.globl	fl_io_bank_restore
	.type	fl_io_bank_restore, @function
fl_io_bank_restore:
	lea (-28,%sp),%sp
	movem.l #17436,(%sp)
	move.l 36(%sp),%d3
	mvz.w %d3,%d3
	move.l %d3,%d2
	and.l fl_blocked_mask,%d2
	tst.l %d2
	jne .L947
	lea read_bank,%a2
.L937:
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	and.l %d3,%d0
	tst.l %d0
	jne .L936
.L939:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L937
	move.l 44(%sp),-(%sp)
	move.l 44(%sp),-(%sp)
	move.l 44(%sp),-(%sp)
	move.l 44(%sp),-(%sp)
	jsr fl_io_stock_bank_restore
	lea (16,%sp),%sp
	move.l %d0,%a6
	tst.l %d0
	jlt .L934
	move.l %d3,-(%sp)
	jsr restore_mask
	addq.l #4,%sp
	tst.l %d0
	jne .L943
	move.l %d3,-(%sp)
	jsr (fl_migrate_restored.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jne .L943
.L934:
	move.l %a6,%d0
	movem.l (%sp),#17436
	lea (28,%sp),%sp
	rts
.L936:
	pea 24(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	move.l %d0,%a6
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jcc .L939
	move.l %a6,fl_io_last_error
	tst.l fl_io_warning
	jne .L934
.L955:
	move.l %a6,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l %a6,%d0
	movem.l (%sp),#17436
	lea (28,%sp),%sp
	rts
.L943:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L945
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,28(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 20(%sp),%d0
.L945:
	move.l %d0,%a6
	move.l %a6,%d0
	movem.l (%sp),#17436
	lea (28,%sp),%sp
	rts
.L947:
	move.w #-61,%a6
	move.l %a6,fl_io_last_error
	tst.l fl_io_warning
	jne .L934
	jra .L955
	.size	fl_io_bank_restore, .-fl_io_bank_restore
	.align	2
	.globl	fl_io_clear
	.type	fl_io_clear, @function
fl_io_clear:
	jsr fl_io_stock_clear
	jsr fl_reset
	jsr fl_clip_reset
	jsr fl_seq_reset
	clr.b %d0
	clr.l fl_io_protected_mask
	clr.l fl_io_loaded
	clr.l fl_io_warning
	clr.l fl_io_last_error
	clr.l fl_present_mask
	clr.l fl_io_pool_mask
	move.b %d0,fl_io_base
	rts
	.size	fl_io_clear, .-fl_io_clear
	.align	2
	.globl	fl_io_delete
	.type	fl_io_delete, @function
fl_io_delete:
	lea (-284,%sp),%sp
	movem.l #19468,(%sp)
	move.l 292(%sp),-(%sp)
	move.l 292(%sp),-(%sp)
	jsr fl_io_stock_directory
	addq.l #8,%sp
	tst.l %d0
	jeq .L959
	move.l %sp,%d3
	add.l #24,%d3
	move.l %d0,%a1
	move.l %d3,%a0
	lea (284,%sp),%a6
.L961:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L971
	cmp.l %a0,%a6
	jne .L961
.L959:
	moveq #-63,%d0
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L962
	pea -63.w
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
.L962:
	moveq #-63,%d0
.L958:
	movem.l (%sp),#19468
	lea (284,%sp),%sp
	rts
.L971:
	clr.l %d2
	lea (path_for.part.0),%a2
	lea fl_io_fs_remove,%a3
.L960:
	sub.l %a6,%a6
.L967:
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	move.l %d3,-(%sp)
	pea fl_io_path
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jeq .L988
	moveq #-63,%d0
.L983:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L958
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,28(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	movem.l (%sp),#19468
	move.l 20(%sp),%d0
	lea (284,%sp),%sp
	rts
.L988:
	pea fl_io_path
	jsr (%a3)
	addq.l #4,%sp
	tst.l %d0
	jlt .L989
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jne .L973
.L990:
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L960
	move.l 292(%sp),-(%sp)
	move.l 292(%sp),-(%sp)
	jsr fl_io_stock_delete
	addq.l #8,%sp
	tst.l %d0
	jlt .L983
	movem.l (%sp),#19468
	lea (284,%sp),%sp
	rts
.L989:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jne .L983
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jeq .L990
.L973:
	mov3q.l #1,%a6
	jra .L967
	.size	fl_io_delete, .-fl_io_delete
	.align	2
	.globl	fl_io_export
	.type	fl_io_export, @function
fl_io_export:
	lea (-1084,%sp),%sp
	movem.l #19580,(%sp)
	lea (44,%sp),%a6
	lea fl_io_base,%a0
	move.l %a6,%a1
.L993:
	move.b (%a0),%d0
	addq.l #1,%a1
	addq.l #1,%a0
	move.b %d0,-1(%a1)
	jeq .L992
	cmp.l #fl_io_base+260,%a0
	jne .L993
.L994:
	moveq #-63,%d1
	move.l %d1,36(%sp)
.L991:
	movem.l (%sp),#19580
	move.l 36(%sp),%d0
	lea (1084,%sp),%sp
	rts
.L992:
	move.l 1096(%sp),-(%sp)
	move.l 1096(%sp),-(%sp)
	jsr fl_io_stock_directory
	move.l %sp,%d5
	add.l #312,%d5
	addq.l #8,%sp
	move.l %sp,%d3
	move.l %d5,%a2
	move.l %d5,%a0
	addq.l #1,%a0
	move.l %d0,%a1
	add.l #564,%d3
	move.b (%a1),%d0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L1032
.L995:
	cmp.l %d3,%a0
	jeq .L994
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jne .L995
.L1032:
	move.b 44(%sp),%d0
	move.l %a6,%a0
	tst.b %d0
	jeq .L1033
.L996:
	mvs.b (%a2),%d1
	mvs.b %d0,%d0
	addq.l #1,%a0
	addq.l #1,%a2
	cmp.l %d1,%d0
	jne .L1001
	move.b (%a0),%d0
	jne .L996
	move.b (%a2),%d0
	jeq .L994
.L1001:
	move.l 1104(%sp),-(%sp)
	move.l 1104(%sp),-(%sp)
	move.l 1104(%sp),-(%sp)
	move.l 1104(%sp),-(%sp)
	move.l 1104(%sp),-(%sp)
	jsr fl_io_stock_export
	move.l %d0,56(%sp)
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L991
	move.l %sp,%d6
	clr.l %d4
	lea read_bank,%a3
	add.l #824,%d6
	lea (path_for.part.0),%a2
	clr.l %d2
.L1008:
	pea 40(%sp)
	move.l %d2,-(%sp)
	move.l %d4,-(%sp)
	move.l %a6,-(%sp)
	jsr (%a3)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L1003
	tst.l %d0
	jne .L1027
	move.l %d2,-(%sp)
	move.l %d4,-(%sp)
	move.l %a6,-(%sp)
	move.l %d3,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L994
	move.l %d2,-(%sp)
	move.l %d4,-(%sp)
	move.l %d5,-(%sp)
	move.l %d6,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L994
	clr.l -(%sp)
	move.l %d3,-(%sp)
	move.l %d6,-(%sp)
	jsr fl_io_fs_copy
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L1027
.L1003:
	subq.l #1,%d2
	tst.l %d2
	jne .L1012
	addq.l #1,%d4
	moveq #16,%d1
	cmp.l %d4,%d1
	jeq .L991
	clr.l %d2
	jra .L1008
.L1027:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L1005
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,40(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 32(%sp),%d0
.L1005:
	movem.l (%sp),#19580
	move.l %d0,36(%sp)
	move.l 36(%sp),%d0
	lea (1084,%sp),%sp
	rts
.L1012:
	mov3q.l #1,%d2
	jra .L1008
.L1033:
	move.b 304(%sp),%d0
	jne .L1001
	jra .L994
	.size	fl_io_export, .-fl_io_export
	.section	.rodata
	.type	fl_mig_line, @object
	.size	fl_mig_line, 20
fl_mig_line:
	.string	"#SYNTH_VC_SETUP=1\r\n"
	.local	fl_mig_capture_mask
.section .bss
.balign 4
fl_mig_capture_mask:
.space 4
	.local	fl_mig_known_mask
.section .bss
.balign 4
fl_mig_known_mask:
.space 4
	.local	fl_mig_durable
.section .bss
.balign 4
fl_mig_durable:
.space 4
	.local	fl_mig_pristine
.section .bss
.balign 4
fl_mig_pristine:
.space 4
	.local	fl_mig_active
.section .bss
.balign 4
fl_mig_active:
.space 4
	.local	fl_mig_pending
.section .bss
.balign 4
fl_mig_pending:
.space 4
	.local	fl_io_play_ticks
.section .bss
.balign 4
fl_io_play_ticks:
.space 4
	.local	fl_io_own_work
.section .bss
.balign 4
fl_io_own_work:
.space 4
	.local	fl_io_flush_pending
.section .bss
.balign 4
fl_io_flush_pending:
.space 4
	.local	fl_io_flush_job
.section .bss
.balign 4
fl_io_flush_job:
.space 16
	.local	fl_mig_marked
.section .bss
.balign 4
fl_mig_marked:
.space 4
	.local	fl_io_full_seen
.section .bss
.balign 4
fl_io_full_seen:
.space 4
	.local	fl_io_pool_free
.section .bss
.balign 4
fl_io_pool_free:
.space 4
	.local	fl_io_pool_mask
.section .bss
.balign 4
fl_io_pool_mask:
.space 4
	.local	fl_present_mask
.section .bss
.balign 4
fl_present_mask:
.space 4
	.local	fl_io_warning
.section .bss
.balign 4
fl_io_warning:
.space 4
	.local	fl_io_job_kind
.section .bss
.balign 4
fl_io_job_kind:
.space 4
	.local	fl_io_loaded
.section .bss
.balign 4
fl_io_loaded:
.space 4
	.globl	fl_io_protected_mask
	.section	.bss
	.align	2
	.type	fl_io_protected_mask, @object
	.size	fl_io_protected_mask, 4
fl_io_protected_mask:
	.zero	4
	.globl	fl_io_last_error
	.align	2
	.type	fl_io_last_error, @object
	.size	fl_io_last_error, 4
fl_io_last_error:
	.zero	4
	.local	fl_io_object2
.section .bss
.balign 4
fl_io_object2:
.space 24
	.local	fl_io_object
.section .bss
.balign 4
fl_io_object:
.space 24
	.local	fl_io_sector2
.section .bss
.balign 4
fl_io_sector2:
.space 512
	.local	fl_io_sector
.section .bss
.balign 4
fl_io_sector:
.space 512
	.local	fl_io_file
.section .bss
.balign 4
fl_io_file:
.space 18624
	.local	fl_io_path
.section .bss
.balign 4
fl_io_path:
.space 260
	.local	fl_io_base
.section .bss
.balign 4
fl_io_base:
.space 260
.section .text
.else
#NO_APP
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"FM LOCK FILE ERROR"
.LC1:
	.string	"FM LOCKS RECOVERED"
.LC2:
	.string	"FM LOCKS FULL"
	.text
	.align	2
	.globl	fl_io_ui_warning
	.type	fl_io_ui_warning, @function
fl_io_ui_warning:
	move.l 4(%sp),%d0
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L3
	moveq #-64,%d1
	cmp.l %d0,%d1
	jeq .L7
	move.l #.LC0,%d0
	pea 48.w
	move.l %d0,-(%sp)
	jsr fl_io_toast
	addq.l #8,%sp
	rts
.L7:
	move.l #.LC2,%d0
	pea 48.w
	move.l %d0,-(%sp)
	jsr fl_io_toast
	addq.l #8,%sp
	rts
.L3:
	move.l #.LC1,%d0
	pea 48.w
	move.l %d0,-(%sp)
	jsr fl_io_toast
	addq.l #8,%sp
	rts
	.size	fl_io_ui_warning, .-fl_io_ui_warning
	.align	2
	.type	fresh_bank, @function
fresh_bank:
	lea (-12,%sp),%sp
	movem.l #28,(%sp)
	move.l 16(%sp),%d3
	mov3q.l #1,%d2
	lsl.l %d3,%d2
	move.l %d3,-(%sp)
	jsr fl_io_core_free
	move.w %d3,%d0
	addq.l #4,%sp
	move.l %d2,%d4
	not.l %d4
	and.l %d4,fl_io_pool_mask
	mulu.w #160,%d0
	move.l %d0,%a0
	add.l #fl_migration_table+160,%d0
	add.l #fl_migration_table,%a0
.L9:
	clr.b (%a0)+
	cmp.l %a0,%d0
	jne .L9
	jsr fl_io_irq_lock
	lea fl_generation,%a0
	clr.l (%a0,%d3.l*4)
	or.l %d2,fl_ready_mask
	move.l %d0,16(%sp)
	and.l %d4,fl_dirty_mask
	and.l %d4,fl_blocked_mask
	movem.l (%sp),#28
	lea (12,%sp),%sp
	jra fl_io_irq_restore
	.size	fresh_bank, .-fresh_bank
	.align	2
	.type	snapshot, @function
snapshot:
	lea (-24,%sp),%sp
	movem.l #3132,(%sp)
	move.l 28(%sp),%d2
	mov3q.l #3,%d3
	lea fl_generation,%a2
	lea fl_io_core_pack,%a3
.L18:
	move.l (%a2,%d2.l*4),%d4
	pea fl_io_file
	move.l fl_lane_gen,%d5
	move.l %d4,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L19
	subq.l #1,%d3
	cmp.l (%a2,%d2.l*4),%d4
	jeq .L25
.L15:
	tst.l %d3
	jne .L18
	movem.l (%sp),#3132
	moveq #-62,%d0
	lea (24,%sp),%sp
	rts
.L25:
	cmp.l fl_lane_gen.l,%d5
	jne .L15
	lea fl_io_file+32,%a1
	clr.l %d1
	lea fl_io_file+18464,%a0
.L16:
	move.b (%a1)+,%d0
	not.l %d0
	mvz.b %d0,%d0
	or.l %d0,%d1
	cmp.l #fl_io_file+18464,%a1
	jne .L16
	lea fl_io_file+18624,%a1
.L17:
	mvz.b (%a0)+,%d0
	or.l %d0,%d1
	cmp.l %a1,%a0
	jne .L17
	tst.l %d1
	sne %d1
	move.l 32(%sp),%a0
	clr.l %d0
	move.l %d4,(%a0)
	movem.l (%sp),#3132
	move.l 36(%sp),%a0
	mvs.b %d1,%d1
	neg.l %d1
	move.l %d1,(%a0)
	lea (24,%sp),%sp
	rts
.L19:
	movem.l (%sp),#3132
	moveq #-60,%d0
	lea (24,%sp),%sp
	rts
	.size	snapshot, .-snapshot
	.section	.rodata.str1.1
.LC3:
	.string	"fmlock"
.LC4:
	.string	".strd"
.LC5:
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
	jeq .L29
.L27:
	move.b %d1,(%a2,%d0.l)
	move.l %d0,%a0
	addq.l #1,%d0
	move.b (%a1,%d0.l),%d1
	jeq .L48
	cmp.l #245,%d0
	jne .L27
.L29:
	movem.l (%sp),#3076
	moveq #-63,%d0
	lea (12,%sp),%sp
	rts
.L48:
	moveq #47,%d1
	lea 2(%a2,%a0.l),%a3
	lea .LC3,%a1
	move.b %d1,(%a2,%d0.l)
	moveq #102,%d0
.L31:
	move.b %d0,(%a3)+
	addq.l #1,%a1
	move.b (%a1),%d0
	cmp.l #.LC3+6,%a1
	jne .L31
	move.l %d2,%d0
	moveq #9,%d1
	lea 8(%a2,%a0.l),%a1
	addq.l #1,%d0
	cmp.l %d0,%d1
	jcc .L32
	moveq #49,%d1
	add.l #38,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jne .L34
.L49:
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l #.LC5,%d2
	move.l %d2,%a1
.L36:
	move.b %d0,(%a3)+
	move.b 1(%a1),%d0
	addq.l #1,%a1
	tst.b %d0
	jne .L36
	lea 10(%a1,%a0.l),%a0
	clr.l %d0
	move.l %a0,%d1
	sub.l %d2,%d1
	clr.b %d2
	move.b %d2,(%a2,%d1.l)
	movem.l (%sp),#3076
	lea (12,%sp),%sp
	rts
.L32:
	moveq #48,%d1
	move.l %d2,%d0
	add.l #49,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jeq .L49
.L34:
	move.l #.LC4,%d2
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l %d2,%a1
	jra .L36
	.size	path_for.part.0, .-path_for.part.0
	.section	.rodata.str1.1
.LC6:
	.string	"r"
.LC7:
	.string	"FMLOCKS"
	.text
	.align	2
	.type	read_bank, @function
read_bank:
	subq.l #8,%sp
	move.l %d2,-(%sp)
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	pea fl_io_path
	jsr (path_for.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L75
	pea 512.w
	pea fl_io_sector
	pea .LC6
	pea fl_io_path
	pea fl_io_object
	jsr fl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L85
	lea fl_io_object,%a0
	move.l (%a0),-(%sp)
	move.l %a0,8(%sp)
	jsr fl_io_fs_size
	addq.l #4,%sp
	move.l %d0,%d1
	move.l 4(%sp),%a0
	tst.l %d0
	jge .L86
	move.l %a0,-(%sp)
	move.l %d0,8(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l 4(%sp),%d1
.L50:
	move.l (%sp)+,%d2
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L86:
	moveq #32,%d2
	cmp.l %d0,%d2
	jcs .L87
	move.l %d0,-(%sp)
	pea fl_io_file
	pea fl_io_object
	move.l %d1,16(%sp)
	jsr fl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%a0
	mov3q.l #1,%d0
	move.l 4(%sp),%d1
	cmp.l %a0,%d0
	jeq .L88
.L55:
	tst.l %a0
	jlt .L89
.L79:
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
.L81:
	move.l (%sp)+,%d2
	moveq #-60,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L85:
	moveq #-12,%d0
	cmp.l %d1,%d0
	jeq .L76
	moveq #-10,%d2
	cmp.l %d1,%d2
	jeq .L81
	move.l (%sp)+,%d2
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L87:
	moveq #32,%d0
	move.l %d0,-(%sp)
	pea fl_io_file
	pea fl_io_object
	move.l %d1,16(%sp)
	jsr fl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%a0
	mov3q.l #1,%d0
	move.l 4(%sp),%d1
	cmp.l %a0,%d0
	jne .L55
.L88:
	lea .LC7,%a0
	clr.l %d0
.L56:
	lea fl_io_file,%a1
	addq.l #1,%a0
	mvz.b (%a1,%d0.l),%d2
	addq.l #1,%d0
	move.l %d2,8(%sp)
	mvz.b -1(%a0),%d2
	cmp.l 8(%sp),%d2
	jne .L90
	moveq #8,%d2
	cmp.l %d0,%d2
	jne .L56
	moveq #9,%d2
	cmp.l %d1,%d2
	jcc .L79
	tst.b fl_io_file+8.l
	jne .L68
	mvz.b fl_io_file+9,%d0
	subq.l #1,%d0
	tst.l %d0
	jeq .L91
.L68:
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
.L63:
	move.l (%sp)+,%d2
	moveq #-61,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L89:
	pea fl_io_object
	move.l %a0,8(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l 4(%sp),%d1
	move.l %d1,%d0
	move.l (%sp)+,%d2
	addq.l #8,%sp
	rts
.L76:
	move.l (%sp)+,%d2
	mov3q.l #1,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L91:
	moveq #15,%d0
	cmp.l %d1,%d0
	jcc .L79
	tst.b fl_io_file+10.l
	jne .L68
	mvz.b fl_io_file+11,%d0
	moveq #32,%d2
	cmp.l %d0,%d2
	jne .L68
	move.b fl_io_file+15,%d2
	move.b fl_io_file+14,%d0
	move.w %d2,%a0
	move.l %a0,%d2
	or.l %d2,%d0
	tst.b %d0
	jne .L68
.L67:
	cmp.l #18624,%d1
	jne .L79
	pea 18592.w
	pea fl_io_file+32
	pea fl_io_object
	jsr fl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L92
	tst.l %d1
	jge .L79
	pea fl_io_object
	move.l %d1,8(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l 4(%sp),%d1
	move.l %d1,%d0
	move.l (%sp)+,%d2
	addq.l #8,%sp
	rts
.L92:
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L50
	move.l 28(%sp),-(%sp)
	pea 18624.w
	pea fl_io_file
	move.l 32(%sp),-(%sp)
	jsr fl_io_core_validate
	lea (16,%sp),%sp
	moveq #-2,%d1
	cmp.l %d0,%d1
	jeq .L63
	add.l %d0,%d0
	subx.l %d0,%d0
	moveq #-60,%d1
	move.l (%sp)+,%d2
	and.l %d0,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L90:
	moveq #9,%d0
	cmp.l %d1,%d0
	jcc .L79
	moveq #15,%d2
	cmp.l %d1,%d2
	jcs .L67
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	jra .L81
.L75:
	move.l (%sp)+,%d2
	moveq #-63,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
	.size	read_bank, .-read_bank
	.section	.rodata.str1.1
.LC8:
	.string	"/project.work"
.LC9:
	.string	"/project.strd"
	.text
	.align	2
	.type	fl_mig_path.constprop.0, @function
fl_mig_path.constprop.0:
	move.l %a2,-(%sp)
	tst.l 8(%sp)
	jeq .L102
	lea .LC9,%a1
.L94:
	lea fl_io_base,%a0
	move.b (%a0),%d1
	jeq .L112
	clr.l %d0
	lea fl_io_path,%a2
.L100:
	move.b %d1,(%a2,%d0.l)
	addq.l #1,%d0
	move.b (%a0,%d0.l),%d1
	jeq .L113
	cmp.l #245,%d0
	jne .L100
	move.l (%sp)+,%a2
	moveq #-63,%d0
	rts
.L113:
	move.b (%a1),%d1
	jeq .L97
	lea (%a2,%d0.l),%a0
	addq.l #1,%a1
.L98:
	move.b %d1,(%a0)
	move.b (%a1)+,%d1
	move.l %a0,%d0
	addq.l #1,%a0
	tst.b %d1
	jne .L98
	sub.l #fl_io_path-1,%d0
.L97:
	clr.b %d1
	move.b %d1,(%a2,%d0.l)
	clr.l %d0
	move.l (%sp)+,%a2
	rts
.L102:
	lea .LC8,%a1
	jra .L94
.L112:
	move.b (%a1),%d1
	clr.l %d0
	lea fl_io_path,%a2
	addq.l #1,%a1
	lea (%a2,%d0.l),%a0
	jra .L98
	.size	fl_mig_path.constprop.0, .-fl_mig_path.constprop.0
	.align	2
	.type	fl_mig_text_read.constprop.0, @function
fl_mig_text_read.constprop.0:
	lea (-40,%sp),%sp
	movem.l #15612,(%sp)
	move.l 52(%sp),%a2
	move.l 44(%sp),-(%sp)
	move.l 52(%sp),%a0
	clr.l (%a0)
	clr.l (%a2)
	jsr (fl_mig_path.constprop.0)
	addq.l #4,%sp
	move.l %d0,%d4
	tst.l %d0
	jne .L135
	pea 512.w
	pea fl_io_sector
	pea .LC6
	pea fl_io_path
	pea fl_io_object
	jsr fl_io_fs_open
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L153
	lea fl_io_object,%a3
	move.l (%a3),-(%sp)
	jsr fl_io_fs_size
	addq.l #4,%sp
	move.l %d0,%d6
	tst.l %d0
	jlt .L117
	clr.l %d2
	clr.l %d5
	lea fl_io_fs_read,%a3
	lea fl_mig_line,%a4
	cmp.l %d6,%d5
	jcc .L122
.L132:
	move.l %d6,%d3
	sub.l %d5,%d3
	cmp.l #18624,%d3
	jls .L119
	mvz.w #18624,%d3
.L119:
	move.l %d3,-(%sp)
	pea fl_io_file
	pea fl_io_object
	jsr (%a3)
	lea (12,%sp),%sp
	mov3q.l #1,%d7
	cmp.l %d0,%d7
	jne .L120
	tst.l (%a2)
	jne .L122
	lea fl_io_file,%a0
	lea (%a0,%d3.l),%a1
.L129:
	move.l %a0,%a5
	moveq #17,%d0
	move.b (%a5)+,%d1
	cmp.l %d2,%d0
	jne .L137
	mvz.b %d1,%d1
	moveq #13,%d7
	cmp.l %d1,%d7
	jeq .L126
	moveq #10,%d0
	cmp.l %d1,%d0
	jeq .L126
	cmp.l %a1,%a5
	jeq .L138
	move.b (%a5),%d1
	addq.l #2,%a0
	mov3q.l #-1,%d2
.L131:
	moveq #10,%d0
	mov3q.l #-1,%d7
	eor.l %d1,%d0
	mvs.b %d1,%d1
	cmp.l %d2,%d7
	jeq .L128
	mvs.b (%a4,%d2.l),%d7
	cmp.l %d7,%d1
	jeq .L154
.L128:
	tst.b %d0
	sne %d0
	mvs.b %d0,%d2
	cmp.l %a0,%a1
	jeq .L130
	move.b (%a0)+,%d1
	jra .L131
.L154:
	addq.l #1,%d2
	cmp.l %a0,%a1
	jne .L129
.L130:
	add.l %d3,%d5
.L155:
	cmp.l %d6,%d5
	jcs .L132
.L122:
	moveq #17,%d0
	cmp.l %d2,%d0
	jeq .L126
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
.L134:
	tst.l %d0
	jlt .L139
	move.l %d4,%d0
	move.l 48(%sp),%a0
	move.l %d6,(%a0)
	movem.l (%sp),#15612
	lea (40,%sp),%sp
	rts
.L117:
	move.l %a3,-(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l %d6,%d4
	move.l %d4,%d0
	movem.l (%sp),#15612
	lea (40,%sp),%sp
	rts
.L137:
	move.l %a5,%a0
	jra .L131
.L153:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jeq .L136
.L139:
	move.l %d0,%d4
	move.l %d4,%d0
	movem.l (%sp),#15612
	lea (40,%sp),%sp
	rts
.L138:
	mov3q.l #-1,%d2
	add.l %d3,%d5
	jra .L155
.L136:
	mov3q.l #1,%d4
	move.l %d4,%d0
	movem.l (%sp),#15612
	lea (40,%sp),%sp
	rts
.L120:
	tst.l %d0
	jlt .L123
	pea fl_io_object
	moveq #-60,%d4
	jsr fl_io_fs_close
	addq.l #4,%sp
.L156:
	move.l %d4,%d0
	movem.l (%sp),#15612
	lea (40,%sp),%sp
	rts
.L126:
	pea fl_io_object
	mov3q.l #1,(%a2)
	jsr fl_io_fs_close
	addq.l #4,%sp
	jra .L134
.L123:
	pea fl_io_object
	move.l %d0,%d4
	jsr fl_io_fs_close
	addq.l #4,%sp
	jra .L156
.L135:
	moveq #-63,%d4
	move.l %d4,%d0
	movem.l (%sp),#15612
	lea (40,%sp),%sp
	rts
	.size	fl_mig_text_read.constprop.0, .-fl_mig_text_read.constprop.0
	.section	.rodata.str1.1
.LC10:
	.string	"w"
	.text
	.align	2
	.type	fl_mig_comment.constprop.0, @function
fl_mig_comment.constprop.0:
	link.w %fp,#-48
	movem.l #3132,(%sp)
	pea -4(%fp)
	pea -8(%fp)
	move.l 8(%fp),-(%sp)
	jsr (fl_mig_text_read.constprop.0)
	lea (12,%sp),%sp
	move.l %d0,-22(%fp)
	tst.l %d0
	jne .L157
	move.l -4(%fp),%d1
	move.l %d1,-14(%fp)
	tst.l %d1
	jeq .L192
.L157:
	movem.l -48(%fp),#3132
	move.l -22(%fp),%d0
	unlk %fp
	rts
.L192:
	move.l 8(%fp),-(%sp)
	jsr (fl_mig_path.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jne .L178
	pea 512.w
	pea fl_io_sector
	pea .LC6
	pea fl_io_path
	pea fl_io_object
	lea fl_io_fs_open,%a2
	jsr (%a2)
	lea (20,%sp),%sp
	move.l %d0,-22(%fp)
	tst.l %d0
	jlt .L157
	pea 512.w
	pea fl_io_sector2
	pea .LC10
	pea fl_io_path
	pea fl_io_object2
	jsr (%a2)
	lea (20,%sp),%sp
	move.l %d0,-22(%fp)
	tst.l %d0
	jlt .L193
	move.l -8(%fp),%d5
	tst.l %d5
	jeq .L194
	clr.l %d4
	lea fl_io_file,%a3
	lea fl_io_fs_write,%a2
.L167:
	move.l %d5,%d2
	sub.l %d4,%d2
	cmp.l #18624,%d2
	jls .L162
	mvz.w #18624,%d2
.L162:
	move.l %d2,-(%sp)
	pea fl_io_file
	pea fl_io_object
	jsr fl_io_fs_read
	move.l %a3,%d3
	move.l %a2,-18(%fp)
	lea (12,%sp),%sp
	mov3q.l #1,%d1
	move.l %d0,-22(%fp)
	cmp.l %d0,%d1
	jne .L189
	move.b -1(%a3,%d2.l),%d1
	move.l %d2,-(%sp)
	move.l %a3,-(%sp)
	pea fl_io_object2
	add.l %d2,%d4
	move.b %d1,-9(%fp)
	jsr (%a2)
	lea (12,%sp),%sp
	move.l %d0,-22(%fp)
	subq.l #1,%d0
	tst.l %d0
	jne .L166
	cmp.l %d4,%d5
	jhi .L167
	mvz.b -9(%fp),%d0
	moveq #10,%d1
	cmp.l %d0,%d1
	jeq .L171
	moveq #10,%d0
	mov3q.l #1,-14(%fp)
	move.b %d0,fl_io_file
.L171:
	moveq #35,%d0
	move.l -14(%fp),%a0
	add.l %d3,%a0
	lea fl_mig_line+1,%a1
.L172:
	move.b %d0,(%a0)
	move.b (%a1)+,%d0
	move.l %a0,%d1
	addq.l #1,%a0
	tst.b %d0
	jne .L172
	sub.l #fl_io_file-1,%d1
	move.l %d1,-(%sp)
	move.l -18(%fp),%a0
	pea fl_io_file
	pea fl_io_object2
	jsr (%a0)
	lea (12,%sp),%sp
	mov3q.l #1,%d1
	move.l %d0,-22(%fp)
	cmp.l %d0,%d1
	jne .L189
	pea fl_io_object
	lea fl_io_fs_close,%a2
	jsr (%a2)
	pea fl_io_object2
	move.l %d0,-22(%fp)
	jsr (%a2)
	addq.l #8,%sp
	tst.l -22(%fp)
	jlt .L157
	move.l %d0,-22(%fp)
	tst.l %d0
	jle .L157
	movem.l -48(%fp),#3132
	clr.l -22(%fp)
	move.l -22(%fp),%d0
	unlk %fp
	rts
.L189:
	tst.l %d0
	jlt .L164
.L185:
	pea fl_io_object
	lea fl_io_fs_close,%a2
	jsr (%a2)
	pea fl_io_object2
	jsr (%a2)
	movem.l -48(%fp),#3132
	addq.l #8,%sp
	moveq #-60,%d1
	move.l %d1,-22(%fp)
	move.l -22(%fp),%d0
	unlk %fp
	rts
.L166:
	tst.l -22(%fp)
	jge .L185
.L164:
	pea fl_io_object
	lea fl_io_fs_close,%a2
	jsr (%a2)
	pea fl_io_object2
	jsr (%a2)
	movem.l -48(%fp),#3132
	move.l -22(%fp),%d0
	addq.l #8,%sp
	unlk %fp
	rts
.L193:
	pea fl_io_object
	jsr fl_io_fs_close
	movem.l -48(%fp),#3132
	move.l -22(%fp),%d0
	addq.l #4,%sp
	unlk %fp
	rts
.L178:
	movem.l -48(%fp),#3132
	moveq #-63,%d1
	move.l %d1,-22(%fp)
	move.l -22(%fp),%d0
	unlk %fp
	rts
.L194:
	lea fl_io_fs_write,%a0
	move.l #fl_io_file,%d3
	move.l %a0,-18(%fp)
	move.l -14(%fp),%a0
	add.l %d3,%a0
	moveq #35,%d0
	lea fl_mig_line+1,%a1
	jra .L172
	.size	fl_mig_comment.constprop.0, .-fl_mig_comment.constprop.0
	.align	2
	.type	publish.constprop.0, @function
publish.constprop.0:
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	move.l 12(%sp),%d0
	mov3q.l #1,%d2
	pea fl_io_file+32
	lsl.l %d0,%d2
	move.l 20(%sp),-(%sp)
	move.l %d0,-(%sp)
	or.l %d2,fl_blocked_mask
	move.l %d2,%d3
	not.l %d3
	and.l %d3,fl_ready_mask
	jsr fl_io_core_publish
	lea (12,%sp),%sp
	moveq #-2,%d1
	cmp.l %d0,%d1
	jeq .L201
	tst.l %d0
	jlt .L198
	move.l (%sp)+,%d2
	clr.l %d0
	and.l %d3,fl_io_pool_mask
	move.l (%sp)+,%d3
	rts
.L198:
	move.l (%sp)+,%d2
	moveq #-60,%d0
	move.l (%sp)+,%d3
	rts
.L201:
	jsr fl_io_irq_lock
	or.l %d2,fl_io_pool_mask
	lea fl_lane_free,%a0
	move.l %d0,-(%sp)
	move.l (%a0),fl_io_pool_free
	jsr fl_io_irq_restore
	addq.l #4,%sp
	move.l (%sp)+,%d2
	moveq #-64,%d0
	move.l (%sp)+,%d3
	rts
	.size	publish.constprop.0, .-publish.constprop.0
	.align	2
	.type	write_buffer.constprop.0, @function
write_buffer.constprop.0:
	subq.l #4,%sp
	move.l 12(%sp),-(%sp)
	move.l 12(%sp),-(%sp)
	pea fl_io_base
	pea fl_io_path
	jsr (path_for.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L207
	pea 512.w
	pea fl_io_sector
	pea .LC10
	pea fl_io_path
	pea fl_io_object
	jsr fl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L202
	pea 18624.w
	pea fl_io_file
	pea fl_io_object
	jsr fl_io_fs_write
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L210
	tst.l %d1
	jlt .L206
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	moveq #-60,%d1
.L202:
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L210:
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jle .L202
	clr.l %d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L206:
	pea fl_io_object
	move.l %d1,4(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l (%sp),%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L207:
	moveq #-63,%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
	.size	write_buffer.constprop.0, .-write_buffer.constprop.0
	.align	2
	.type	store_ab, @function
store_ab:
	lea (-48,%sp),%sp
	movem.l #31868,(%sp)
	move.l 52(%sp),%d4
	move.l fl_blocked_mask,%d3
	and.l %d4,%d3
	tst.l %d3
	jne .L212
	move.l fl_ready_mask,%d0
	and.l %d4,%d0
	cmp.l %d0,%d4
	jne .L212
	move.l %sp,%d6
	move.l %sp,%d5
	add.l #44,%d6
	add.l #40,%d5
	lea snapshot,%a6
	lea fl_io_irq_lock,%a4
	lea fl_generation,%a3
	lea fl_io_irq_restore,%a2
.L213:
	mov3q.l #1,%d2
	lsl.l %d3,%d2
	move.l %d4,%d0
	and.l %d2,%d0
	tst.l %d0
	jne .L228
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L213
.L230:
	clr.l %d0
.L211:
	movem.l (%sp),#31868
	lea (48,%sp),%sp
	rts
.L228:
	move.l %d6,-(%sp)
	move.l %d5,-(%sp)
	move.l %d3,-(%sp)
	jsr (%a6)
	lea (12,%sp),%sp
	tst.l %d0
	jne .L211
	move.l %d2,%d0
	and.l fl_present_mask,%d0
	or.l 44(%sp),%d0
	jeq .L216
	clr.l -(%sp)
	move.l %d3,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jne .L211
	mov3q.l #1,-(%sp)
	move.l %d3,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jne .L211
	or.l %d2,fl_present_mask
.L216:
	move.l 40(%sp),%a5
	not.l %d2
	jsr (%a4)
	cmp.l (%a3,%d3.l*4),%a5
	jeq .L229
	move.l %d0,-(%sp)
	jsr (%a2)
	and.l %d2,fl_io_protected_mask
	addq.l #4,%sp
.L231:
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L213
	jra .L230
.L229:
	move.l %d0,-(%sp)
	and.l %d2,fl_dirty_mask
	jsr (%a2)
	and.l %d2,fl_io_protected_mask
	addq.l #4,%sp
	jra .L231
.L212:
	movem.l (%sp),#31868
	moveq #-61,%d0
	lea (48,%sp),%sp
	rts
	.size	store_ab, .-store_ab
	.align	2
	.type	own_post.isra.0, @function
own_post.isra.0:
	subq.l #4,%sp
	tst.l 1175264744
	jne .L232
	mov3q.l #1,%d0
	cmp.l -2147483512.l,%d0
	jeq .L232
	tst.l 269452412
	jeq .L243
.L232:
	addq.l #4,%sp
	rts
.L243:
	move.l 8(%sp),(%sp)
	jsr fl_io_stock_card_ready
	tst.l %d0
	jeq .L232
	jsr fl_io_irq_lock
	move.l (%sp),%d1
	or.l %d1,fl_io_own_work
	tst.l fl_io_flush_pending
	jne .L244
	move.l %d0,-(%sp)
	mov3q.l #1,fl_io_flush_pending
	jsr fl_io_irq_restore
	moveq #-127,%d0
	pea fl_io_flush_job
	move.l #1175263182,-(%sp)
	move.b %d0,fl_io_flush_job
	jsr fl_io_queue_post
	lea (12,%sp),%sp
	addq.l #4,%sp
	rts
.L244:
	move.l %d0,8(%sp)
	addq.l #4,%sp
	jra fl_io_irq_restore
	.size	own_post.isra.0, .-own_post.isra.0
	.align	2
	.type	flush_ab.constprop.0, @function
flush_ab.constprop.0:
	lea (-48,%sp),%sp
	movem.l #23804,(%sp)
	move.l fl_dirty_mask,%d0
	move.l %sp,%d6
	move.l fl_blocked_mask,%d4
	not.l %d4
	move.l fl_ready_mask,%d2
	move.l %sp,%d5
	move.l fl_io_protected_mask,%d1
	not.l %d1
	clr.l %d3
	and.l %d2,%d0
	add.l #44,%d6
	add.l #40,%d5
	lea snapshot,%a6
	lea fl_io_irq_lock,%a4
	lea fl_generation,%a3
	lea fl_io_irq_restore,%a2
	and.l %d0,%d4
	and.l %d1,%d4
	and.l 52(%sp),%d4
.L250:
	mov3q.l #1,%d2
	lsl.l %d3,%d2
	move.l %d4,%d0
	and.l %d2,%d0
	tst.l %d0
	jne .L260
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L250
.L262:
	clr.l %d0
.L245:
	movem.l (%sp),#23804
	lea (48,%sp),%sp
	rts
.L260:
	move.l %d6,-(%sp)
	move.l %d5,-(%sp)
	move.l %d3,-(%sp)
	jsr (%a6)
	lea (12,%sp),%sp
	tst.l %d0
	jne .L245
	move.l %d2,%d0
	and.l fl_present_mask,%d0
	or.l 44(%sp),%d0
	jeq .L248
	clr.l -(%sp)
	move.l %d3,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jne .L245
	or.l %d2,fl_present_mask
.L248:
	move.l 40(%sp),%d7
	not.l %d2
	jsr (%a4)
	cmp.l (%a3,%d3.l*4),%d7
	jeq .L261
	move.l %d0,-(%sp)
	jsr (%a2)
	and.l %d2,fl_io_protected_mask
	addq.l #4,%sp
.L263:
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L250
	jra .L262
.L261:
	move.l %d0,-(%sp)
	and.l %d2,fl_dirty_mask
	jsr (%a2)
	and.l %d2,fl_io_protected_mask
	addq.l #4,%sp
	jra .L263
	.size	flush_ab.constprop.0, .-flush_ab.constprop.0
	.align	2
	.type	fl_mig_capture, @function
fl_mig_capture:
	lea (-80,%sp),%sp
	movem.l #31996,(%sp)
	move.l 84(%sp),%d2
	move.l #635712,%d1
	muls.l %d2,%d1
	mvz.b 269161678,%d0
	add.l #1074668000,%d1
	move.l %d1,64(%sp)
	cmp.l %d2,%d0
	jeq .L352
.L266:
	move.w %d2,%d0
	mulu.w #160,%d0
	move.l %d0,%a0
	add.l #fl_migration_table,%a0
	move.l %a0,76(%sp)
	tst.b 3(%a0)
	jeq .L268
.L353:
	move.l 76(%sp),%a1
	addq.l #4,%a0
	clr.l %d0
	lea (12,%a1),%a1
.L269:
	mvz.b (%a0)+,%d1
	or.l %d1,%d0
	cmp.l %a1,%a0
	jne .L269
	tst.l %d0
	sne %d0
	mvs.b %d0,%d0
	neg.l %d0
	move.l %d0,72(%sp)
.L264:
	movem.l (%sp),#31996
	move.l 72(%sp),%d0
	lea (80,%sp),%sp
	rts
.L352:
	move.l 1187521622,%d0
	move.l %d0,%d1
	add.l #-1073741824,%d1
	cmp.l #134217727,%d1
	jhi .L266
	move.l %d0,64(%sp)
	move.w %d2,%d0
	mulu.w #160,%d0
	move.l %d0,%a0
	add.l #fl_migration_table,%a0
	move.l %a0,76(%sp)
	tst.b 3(%a0)
	jne .L353
.L268:
	move.l 64(%sp),%d1
	add.l #585088,%d1
	move.l %d1,60(%sp)
	clr.l %d3
	clr.l %d6
	move.l %d1,%d5
.L278:
	move.l %d5,%a2
	move.l %d5,%a3
	move.l %d5,%d1
	sub.l %a1,%a1
	add.l #5730,%d1
	lea (60,%a2),%a2
	lea (34,%a3),%a3
.L277:
	mvz.b (%a3,%a1.l),%d0
	subq.l #1,%d0
	tst.l %d0
	jeq .L354
.L273:
	addq.l #1,%a1
	add.l #32,%d1
	lea (30,%a2),%a2
	moveq #8,%d0
	cmp.l %a1,%d0
	jne .L277
	addq.l #1,%d6
	add.l #6322,%d5
	cmp.l %d6,%d0
	jne .L278
	move.l %d2,%d0
	add.l #128,%d0
	mvz.w %d0,%d0
	clr.l %d6
	clr.l %d4
	lea fl_io_core_taken,%a3
	lsl.l #4,%d0
	move.l %d0,%a2
.L282:
	mov3q.l #1,%d0
	lsl.l %d4,%d0
	and.l %d3,%d0
	tst.l %d0
	jne .L355
.L280:
	addq.l #1,%d4
	moveq #16,%d1
	cmp.l %d4,%d1
	jne .L282
.L360:
	mvz.w %d2,%d4
	move.l 64(%sp),%a6
	add.l #36439,%a6
	move.l 64(%sp),%d5
	add.l #621527,%d5
	lea fl_io_core_taken,%a4
	lsl.l #7,%d4
.L291:
	move.b (%a6),%d0
	mov3q.l #3,%d3
	mvz.b %d0,%d1
	cmp.l %d1,%d3
	jcc .L356
.L283:
	add.l #36568,%a6
	addq.l #8,%d4
	cmp.l %a6,%d5
	jne .L291
	cmp.l fl_lane_free.l,%d6
	jhi .L311
	move.l 76(%sp),%a0
	move.l 76(%sp),%d3
	addq.l #4,%d3
	move.l %d3,56(%sp)
	lea (12,%a0),%a0
	clr.l 52(%sp)
	move.l %a0,68(%sp)
	clr.l 72(%sp)
	lea fl_io_core_scene_set,%a2
.L301:
	sub.l %a3,%a3
	move.l 56(%sp),%a0
	mvz.w 54(%sp),%d3
	move.l 60(%sp),%a6
	clr.b (%a0)+
	move.l 60(%sp),%a5
	lsl.l #4,%d3
	move.l 60(%sp),%d4
	add.l #1634,%d4
	addq.l #1,56(%sp)
	lea (60,%a6),%a6
	lea (282,%a5),%a5
	move.l 60(%sp),%a0
	move.l 68(%sp),48(%sp)
	lea (34,%a0),%a0
	move.l %a0,44(%sp)
	add.l #128,%d3
.L300:
	mov3q.l #1,%d1
	move.l 44(%sp),%a0
	mvz.b (%a0,%a3.l),%d0
	cmp.l %d0,%d1
	jeq .L357
.L294:
	addq.l #1,%a3
	addq.l #1,%d3
	lea (30,%a6),%a6
	add.l #32,%d4
	addq.l #2,48(%sp)
	lea (24,%a5),%a5
	moveq #8,%d6
	cmp.l %a3,%d6
	jne .L300
.L363:
	mvz.w #6322,%d0
	moveq #16,%d7
	moveq #64,%d1
	add.l %d7,68(%sp)
	addq.l #8,52(%sp)
	add.l %d0,60(%sp)
	cmp.l 52(%sp),%d1
	jne .L301
	tst.l 72(%sp)
	jeq .L264
	move.l 64(%sp),%a4
	moveq #89,%d6
	add.l #36350,%a4
	clr.l 48(%sp)
	lea fl_io_core_set,%a2
.L302:
	mvz.b (%a4,%d6.l),%d0
	mov3q.l #3,%d3
	cmp.l %d0,%d3
	jcc .L358
.L303:
	mvz.w #512,%d0
	addq.l #8,48(%sp)
	move.l 48(%sp),%d1
	add.l #36568,%d6
	add.l %d0,52(%sp)
	cmp.l #128,%d1
	jne .L302
	move.l 76(%sp),%a0
	mov3q.l #1,(%a0)
	jsr fl_io_irq_lock
	mov3q.l #1,%d1
	lsl.l %d2,%d1
	lea fl_generation,%a0
	or.l %d1,fl_dirty_mask
	addq.l #1,(%a0,%d2.l*4)
	move.l %d0,-(%sp)
	jsr fl_io_irq_restore
	addq.l #4,%sp
	movem.l (%sp),#31996
	move.l 72(%sp),%d0
	lea (80,%sp),%sp
	rts
.L354:
	mvz.b (%a2),%d0
	moveq #70,%d7
	cmp.l %d0,%d7
	jne .L273
	mvz.b 1(%a2),%d0
	moveq #77,%d4
	cmp.l %d0,%d4
	jne .L273
	mvz.b 2(%a2),%d4
	mov3q.l #1,%d7
	cmp.l %d4,%d7
	jne .L273
	mov3q.l #3,%d0
	and.l %d6,%d0
	move.l %a1,%d7
	lsr.l #1,%d7
	move.l %d1,%a0
	lea (-4096,%a0),%a0
	move.l %d7,%a4
	lea (%a4,%d0.l*4),%a4
	move.l %a4,%d0
	lsl.l %d0,%d4
	mvz.b 8(%a0),%d0
	cmp.l #255,%d0
	jeq .L359
.L274:
	or.l %d4,%d3
.L275:
	lea (256,%a0),%a0
	cmp.l %a0,%d1
	jeq .L273
	mvz.b 8(%a0),%d0
	cmp.l #255,%d0
	jne .L274
.L359:
	mvz.b 11(%a0),%d0
	cmp.l #255,%d0
	jeq .L275
	or.l %d4,%d3
	jra .L275
.L355:
	pea (%a2,%d4.l)
	jsr (%a3)
	addq.l #4,%sp
	tst.l %d0
	jne .L280
	addq.l #1,%d6
	addq.l #1,%d4
	moveq #16,%d1
	cmp.l %d4,%d1
	jne .L282
	jra .L360
.L356:
	ext.w %d0
	move.l %d4,%a3
	move.l %a6,%d3
	lea (-34,%a3),%a3
	add.l #-34302,%d3
	mulu.w #6322,%d0
	move.l %d0,%d7
	add.l #585088,%d7
	add.l 64(%sp),%d7
	move.l %d7,%a2
	move.l %d7,%a5
	mvz.b 34(%a2),%d0
	sub.l %d7,%a3
	lea (34,%a2),%a2
	add.l #42,%d7
	lea (60,%a5),%a5
	subq.l #1,%d0
	tst.l %d0
	jeq .L361
.L286:
	addq.l #1,%a2
	lea (30,%a5),%a5
	add.l #2330,%d3
	cmp.l %a2,%d7
	jeq .L283
.L349:
	mvz.b (%a2),%d0
	subq.l #1,%d0
	tst.l %d0
	jne .L286
.L361:
	mvz.b (%a5),%d0
	moveq #70,%d1
	cmp.l %d0,%d1
	jne .L286
	mvz.b 1(%a5),%d0
	moveq #77,%d1
	cmp.l %d0,%d1
	jne .L286
	mvz.b 2(%a5),%d0
	subq.l #1,%d0
	tst.l %d0
	jne .L286
	pea (%a3,%a2.l)
	jsr (%a4)
	addq.l #4,%sp
	tst.l %d0
	jne .L286
	move.l %d3,%a0
	mvz.b -2040(%a0),%d0
	lea (-2048,%a0),%a0
	cmp.l #255,%d0
	jne .L287
.L362:
	mvz.b 11(%a0),%d0
	lea (32,%a0),%a0
	cmp.l #255,%d0
	jne .L287
	cmp.l %a0,%d3
	jeq .L286
	mvz.b 8(%a0),%d0
	cmp.l #255,%d0
	jeq .L362
.L287:
	addq.l #1,%d6
	addq.l #1,%a2
	lea (30,%a5),%a5
	add.l #2330,%d3
	cmp.l %a2,%d7
	jne .L349
	jra .L283
.L357:
	mvz.b (%a6),%d0
	moveq #70,%d6
	cmp.l %d0,%d6
	jne .L294
	mvz.b 1(%a6),%d0
	moveq #77,%d7
	cmp.l %d0,%d7
	jne .L294
	move.b 2(%a6),%d5
	mvz.b %d5,%d0
	cmp.l %d0,%d1
	jne .L294
	move.l 56(%sp),%a0
	move.l %a3,%d6
	lsl.l %d6,%d0
	mov3q.l #3,%d7
	move.b -1(%a0),%d1
	or.l %d1,%d0
	move.b %d0,-1(%a0)
	move.b 2(%a5),%d1
	move.l %d1,%d0
	subq.l #1,%d0
	mvz.b %d0,%d0
	cmp.l %d0,%d7
	jcc .L295
	move.b %d5,%d1
.L295:
	move.l 48(%sp),%a0
	move.l %d3,%d7
	move.l %d4,%a4
	add.l #-128,%d7
	move.b %d1,(%a0)
	moveq #127,%d1
	move.b 5(%a5),%d0
	and.l %d1,%d0
	move.b %d0,1(%a0)
.L299:
	mvz.b 8(%a4),%d0
	cmp.l #255,%d0
	jeq .L296
	move.b 8(%a4),%d0
	mov3q.l #3,%d6
	move.l %d0,%d1
	subq.l #1,%d1
	mvz.b %d1,%d1
	cmp.l %d1,%d6
	jcc .L297
	move.b %d5,%d0
.L297:
	mvz.b %d0,%d0
	move.l %d0,-(%sp)
	clr.l -(%sp)
	move.l %d7,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
.L296:
	mvz.b 11(%a4),%d0
	cmp.l #255,%d0
	jeq .L298
	move.b 11(%a4),%d0
	moveq #127,%d1
	and.l %d0,%d1
	move.l %d1,-(%sp)
	mov3q.l #1,-(%sp)
	move.l %d7,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
.L298:
	lea (256,%a4),%a4
	addq.l #8,%d7
	cmp.l %d7,%d3
	jne .L299
	mov3q.l #1,72(%sp)
	moveq #8,%d6
	addq.l #1,%a3
	addq.l #1,%d3
	lea (30,%a6),%a6
	add.l #32,%d4
	lea (24,%a5),%a5
	addq.l #2,48(%sp)
	cmp.l %a3,%d6
	jne .L300
	jra .L363
.L358:
	move.l 76(%sp),%a0
	move.l %d6,%d5
	move.l 52(%sp),%d3
	clr.l %d4
	lea 4(%a0,%d0.l),%a3
	mvz.b (%a3),%d0
	btst %d4,%d0
	jne .L364
.L304:
	addq.l #1,%d4
	add.l #64,%d3
	add.l #2330,%d5
	moveq #8,%d7
	cmp.l %d4,%d7
	jeq .L303
.L351:
	mvz.b (%a3),%d0
	btst %d4,%d0
	jeq .L304
.L364:
	move.l %d3,%a6
	move.l 64(%sp),%a5
	add.l %d5,%a5
	lea (-64,%a6),%a6
.L308:
	mvz.b 8(%a5),%d0
	cmp.l #255,%d0
	jeq .L305
	move.b 8(%a5),%d0
	mov3q.l #3,%d7
	move.l %d0,%d1
	subq.l #1,%d1
	mvz.b %d1,%d1
	cmp.l %d1,%d7
	jcc .L306
	moveq #1,%d0
.L306:
	mvz.b %d0,%d0
	move.l %d0,-(%sp)
	clr.l -(%sp)
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
.L305:
	mvz.b 11(%a5),%d0
	cmp.l #255,%d0
	jeq .L307
	move.b 11(%a5),%d0
	moveq #127,%d1
	and.l %d0,%d1
	move.l %d1,-(%sp)
	mov3q.l #1,-(%sp)
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
.L307:
	lea (32,%a5),%a5
	addq.l #1,%a6
	cmp.l %d3,%a6
	jne .L308
	addq.l #1,%d4
	add.l #64,%d3
	add.l #2330,%d5
	moveq #8,%d7
	cmp.l %d4,%d7
	jne .L351
	jra .L303
.L311:
	movem.l (%sp),#31996
	mov3q.l #2,72(%sp)
	move.l 72(%sp),%d0
	lea (80,%sp),%sp
	rts
	.size	fl_mig_capture, .-fl_mig_capture
	.align	2
	.type	fl_mig_apply_to, @function
fl_mig_apply_to:
	lea (-52,%sp),%sp
	movem.l #31996,(%sp)
	move.l 64(%sp),%d6
	clr.l %d4
	move.l 60(%sp),%d7
	add.l #-268525902,%d7
	move.l #269110990,%d5
	move.b 1074608214,%d0
	move.b %d0,46(%sp)
	move.w 58(%sp),%d0
	move.b 1074608217,%d2
	mulu.w #160,%d0
	move.l %d7,48(%sp)
	move.l %d0,%a6
	add.l #fl_migration_table,%a6
	move.l %a6,%d3
	add.l #12,%d3
	move.b %d2,47(%sp)
	lea (4,%a6),%a4
.L370:
	tst.l %d6
	jne .L378
	move.l 48(%sp),%a5
	add.l %d5,%a5
	move.l %a5,%d1
	clr.l %d0
	lea (60,%a5),%a1
	add.l #1634,%d1
	lea (282,%a5),%a3
	move.l %d3,%a2
	lea (34,%a5),%a5
.L369:
	mvz.b (%a4),%d2
	btst %d0,%d2
	jne .L396
.L367:
	addq.l #1,%d0
	lea (30,%a1),%a1
	addq.l #2,%a2
	add.l #32,%d1
	lea (24,%a3),%a3
	moveq #8,%d2
	cmp.l %d0,%d2
	jne .L369
	add.l #16,%d3
	addq.l #1,%a4
	add.l #6322,%d5
	addq.l #8,%d4
	moveq #64,%d7
	cmp.l %d4,%d7
	jne .L370
	move.l #-36350,%d4
	sub.l 60(%sp),%d4
	move.l 60(%sp),%a2
	add.l #36439,%a2
	move.l 60(%sp),%d3
	add.l #621527,%d3
	move.l 60(%sp),%d5
	add.l #585088,%d5
.L377:
	move.b (%a2),%d0
	mov3q.l #3,%d2
	mvz.b %d0,%d1
	cmp.l %d1,%d2
	jcc .L397
.L371:
	add.l #36568,%a2
	cmp.l %a2,%d3
	jne .L377
	movem.l (%sp),#31996
	lea (52,%sp),%sp
	rts
.L396:
	mvz.b (%a5,%d0.l),%d2
	subq.l #1,%d2
	tst.l %d2
	jne .L367
	mvz.b (%a1),%d2
	moveq #70,%d7
	cmp.l %d2,%d7
	jne .L367
	mvz.b 1(%a1),%d2
	moveq #77,%d7
	cmp.l %d2,%d7
	jne .L367
	mvz.b 2(%a1),%d2
	subq.l #1,%d2
	tst.l %d2
	jne .L367
	move.b (%a2),420(%a1)
	move.l %d1,%d2
	move.l %d1,%a0
	add.l #4096,%d2
	move.b 1(%a2),421(%a1)
	move.b 46(%sp),2(%a3)
	move.b 47(%sp),5(%a3)
.L368:
	st %d7
	lea (256,%a0),%a0
	move.b %d7,-248(%a0)
	move.b %d7,-245(%a0)
	cmp.l %a0,%d2
	jeq .L367
	st %d7
	lea (256,%a0),%a0
	move.b %d7,-248(%a0)
	move.b %d7,-245(%a0)
	cmp.l %a0,%d2
	jne .L368
	jra .L367
.L397:
	ext.w %d0
	lea 4(%a6,%d1.l),%a3
	move.l %d4,%d2
	clr.l %d1
	add.l %a2,%d2
	mulu.w #6322,%d0
	move.l %d0,%a4
	add.l %d5,%a4
	mvz.b (%a3),%d0
	lea (60,%a4),%a1
	lea (34,%a4),%a4
	btst %d1,%d0
	jne .L398
.L372:
	addq.l #1,%d1
	lea (30,%a1),%a1
	add.l #2330,%d2
	moveq #8,%d0
	cmp.l %d1,%d0
	jeq .L371
	mvz.b (%a3),%d0
	btst %d1,%d0
	jeq .L372
.L398:
	mvz.b (%a4,%d1.l),%d0
	subq.l #1,%d0
	tst.l %d0
	jne .L372
	mvz.b (%a1),%d0
	moveq #70,%d7
	cmp.l %d0,%d7
	jne .L372
	mvz.b 1(%a1),%d0
	moveq #77,%d7
	cmp.l %d0,%d7
	jne .L372
	mvz.b 2(%a1),%d0
	subq.l #1,%d0
	tst.l %d0
	jne .L372
	btst #0,%d6
	jeq .L399
	move.l #268525902,%a0
	move.l %a0,%d0
	add.l #2048,%d0
	add.l %d2,%a0
	add.l %d2,%d0
.L375:
	st %d7
	lea (32,%a0),%a0
	move.b %d7,-24(%a0)
	move.b %d7,-21(%a0)
	cmp.l %d0,%a0
	jeq .L372
	st %d7
	lea (32,%a0),%a0
	move.b %d7,-24(%a0)
	move.b %d7,-21(%a0)
	cmp.l %d0,%a0
	jne .L375
	jra .L372
.L378:
	move.l %d5,%a5
	move.l %a5,%d1
	lea (60,%a5),%a1
	clr.l %d0
	lea (282,%a5),%a3
	add.l #1634,%d1
	move.l %d3,%a2
	lea (34,%a5),%a5
	jra .L369
.L399:
	move.l 60(%sp),%a0
	move.l %a0,%d0
	add.l #2048,%d0
	add.l %d2,%a0
	add.l %d2,%d0
	jra .L375
	.size	fl_mig_apply_to, .-fl_mig_apply_to
	.align	2
	.type	fl_migrate_saved.constprop.0, @function
fl_migrate_saved.constprop.0:
	move.l fl_mig_active,%d1
	lea (-68,%sp),%sp
	movem.l #31996,(%sp)
	or.l fl_mig_pristine,%d1
	move.l 72(%sp),52(%sp)
	move.l 76(%sp),64(%sp)
	move.l %d1,60(%sp)
	tst.l %d1
	jeq .L401
	move.l #1074668000,%d7
	lea fl_migration_table+3,%a4
	clr.l 60(%sp)
	move.l %d7,44(%sp)
	clr.l 48(%sp)
.L415:
	move.l 48(%sp),%d2
	mov3q.l #1,%d1
	lsl.l %d2,%d1
	move.l 52(%sp),%d0
	and.l %d1,%d0
	move.l %d1,56(%sp)
	tst.l %d0
	jne .L446
.L414:
	move.l #635712,%d2
	addq.l #1,48(%sp)
	lea (160,%a4),%a4
	add.l %d2,44(%sp)
	cmp.l #fl_migration_table+2563,%a4
	jne .L415
.L401:
	lea fl_migration_table+3,%a2
	clr.l %d2
	lea fl_io_irq_lock,%a5
	lea fl_generation,%a3
	lea fl_io_irq_restore,%a4
.L419:
	mov3q.l #1,%d3
	lsl.l %d2,%d3
	move.l 52(%sp),%d0
	and.l %d3,%d0
	tst.l %d0
	jeq .L417
	mvz.b (%a2),%d0
	subq.l #1,%d0
	tst.l %d0
	jeq .L447
.L417:
	addq.l #1,%d2
	lea (160,%a2),%a2
	cmp.l #fl_migration_table+2563,%a2
	jne .L419
.L451:
	tst.l 60(%sp)
	jeq .L420
	tst.l 64(%sp)
	jeq .L421
	tst.l fl_io_loaded
	jeq .L428
	move.l 60(%sp),-(%sp)
	jsr store_ab
	addq.l #4,%sp
	tst.l %d0
	jne .L400
.L420:
	move.l 52(%sp),%d0
	not.l %d0
	and.l fl_mig_pending,%d0
	move.l %d0,fl_mig_pending
	tst.l fl_mig_active
	jeq .L424
	tst.l %d0
	jeq .L425
.L424:
	clr.l %d0
.L400:
	movem.l (%sp),#31996
	lea (68,%sp),%sp
	rts
.L446:
	mvz.b 269161678,%d0
	move.l 44(%sp),%d4
	cmp.l %d2,%d0
	jeq .L448
.L404:
	tst.b (%a4)
	jne .L414
	add.l #585088,%d4
	lea (9,%a4),%a6
	clr.l %d6
	lea (1,%a4),%a2
	clr.l %d5
.L406:
	move.l %d4,%a0
	move.l %d4,%a3
	lea (481,%a0),%a0
	clr.l %d0
	move.l %a6,%a1
	lea (34,%a3),%a3
.L411:
	mvz.b (%a3,%d0.l),%d1
	subq.l #1,%d1
	tst.l %d1
	jeq .L449
.L409:
	addq.l #1,%d0
	addq.l #2,%a1
	lea (30,%a0),%a0
	moveq #8,%d3
	cmp.l %d0,%d3
	jne .L411
.L450:
	lea (16,%a6),%a6
	addq.l #1,%a2
	add.l #6322,%d4
	addq.l #8,%d6
	moveq #64,%d7
	cmp.l %d6,%d7
	jne .L406
	tst.l %d5
	jeq .L414
	move.b #2,(%a4)
	move.l #635712,%d2
	lea (160,%a4),%a4
	jsr fl_io_irq_lock
	move.l 48(%sp),%a5
	move.l 56(%sp),%d1
	lea fl_generation,%a0
	or.l %d1,fl_dirty_mask
	addq.l #1,(%a0,%a5.l*4)
	move.l %d0,-(%sp)
	jsr fl_io_irq_restore
	addq.l #4,%sp
	mov3q.l #1,fl_mig_active
	addq.l #1,48(%sp)
	move.l 56(%sp),%d1
	add.l %d2,44(%sp)
	or.l %d1,60(%sp)
	cmp.l #fl_migration_table+2563,%a4
	jne .L415
	jra .L401
.L449:
	mvz.b -421(%a0),%d1
	move.l %a0,%d2
	moveq #70,%d7
	add.l #-421,%d2
	cmp.l %d1,%d7
	jne .L409
	move.l %d2,%a5
	moveq #77,%d3
	mvz.b 1(%a5),%d1
	cmp.l %d1,%d3
	jne .L409
	move.b 2(%a5),%d3
	mov3q.l #1,%d7
	mvz.b %d3,%d1
	cmp.l %d1,%d7
	jne .L409
	move.b (%a2),%d2
	lsl.l %d0,%d1
	mov3q.l #1,%d5
	mov3q.l #3,%d7
	or.l %d2,%d1
	move.b %d1,(%a2)
	move.b -1(%a0),%d1
	move.l %d1,%d2
	subq.l #1,%d2
	mvz.b %d2,%d2
	cmp.l %d2,%d7
	jcs .L410
	move.b %d1,%d3
.L410:
	move.b %d3,(%a1)
	moveq #127,%d2
	addq.l #1,%d0
	addq.l #2,%a1
	lea (30,%a0),%a0
	moveq #8,%d3
	move.b -30(%a0),%d1
	and.l %d2,%d1
	move.b %d1,-1(%a1)
	cmp.l %d0,%d3
	jne .L411
	jra .L450
.L448:
	move.l 1187521622,%d0
	move.l %d0,%d1
	add.l #-1073741824,%d1
	cmp.l #134217727,%d1
	jhi .L404
	move.l %d0,%d4
	jra .L404
.L447:
	move.b #2,(%a2)
	lea (160,%a2),%a2
	jsr (%a5)
	or.l %d3,fl_dirty_mask
	addq.l #1,(%a3,%d2.l*4)
	move.l %d0,-(%sp)
	jsr (%a4)
	or.l %d3,64(%sp)
	addq.l #4,%sp
	addq.l #1,%d2
	cmp.l #fl_migration_table+2563,%a2
	jne .L419
	jra .L451
.L425:
	clr.l -(%sp)
	mov3q.l #1,fl_mig_durable
	jsr (fl_mig_comment.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jne .L400
	mov3q.l #1,%d1
	cmp.l 64(%sp),%d1
	jne .L400
	movem.l (%sp),#31996
	mov3q.l #1,72(%sp)
	lea (68,%sp),%sp
	jra (fl_mig_comment.constprop.0)
.L421:
	tst.l fl_io_loaded
	jeq .L420
	move.l 60(%sp),-(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jeq .L420
	jra .L400
.L428:
	movem.l (%sp),#31996
	moveq #-60,%d0
	lea (68,%sp),%sp
	rts
	.size	fl_migrate_saved.constprop.0, .-fl_migrate_saved.constprop.0
	.align	2
	.type	fl_mig_run, @function
fl_mig_run:
	lea (-40,%sp),%sp
	movem.l #15612,(%sp)
	move.l 48(%sp),%a3
	move.l 44(%sp),%a5
	move.l %a5,%d1
	or.l %d1,fl_mig_known_mask
	move.l fl_mig_capture_mask,%d0
	tst.l %a3
	jne .L453
	not.l %d1
	and.l %d1,%d0
	move.l #1074668000,%d4
	clr.l %d5
	lea fl_migration_table+3,%a2
	move.l %d0,fl_mig_capture_mask
	clr.l %d0
.L471:
	mov3q.l #1,%d3
	lsl.l %d0,%d3
	move.l %a5,%d1
	and.l %d3,%d1
	tst.l %d1
	jeq .L456
	mvz.b 269161678,%d1
	move.l %d4,%a0
	cmp.l %d0,%d1
	jeq .L518
.L458:
	mvz.b (%a2),%d1
	mov3q.l #2,%d6
	cmp.l %d1,%d6
	jeq .L456
	subq.l #1,%d1
	tst.l %d1
	jeq .L461
	tst.l %a3
	jne .L519
.L456:
	addq.l #1,%d0
	add.l #635712,%d4
	lea (160,%a2),%a2
	moveq #16,%d1
	cmp.l %d0,%d1
	jne .L471
.L526:
	clr.l %d2
	lea fl_mig_capture,%a2
	lea fl_io_irq_restore,%a3
.L476:
	mov3q.l #1,%d3
	lsl.l %d2,%d3
	move.l %d3,%d0
	and.l %d5,%d0
	tst.l %d0
	jne .L520
.L473:
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L476
.L527:
	tst.l %d5
	jeq .L477
	clr.l fl_mig_durable
	tst.l fl_io_loaded
	jne .L521
.L478:
	move.l #1074668000,%a2
	clr.l %d2
	move.l #635698,%a4
	lea fl_mig_apply_to,%a3
.L486:
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	and.l %d5,%d0
	tst.l %d0
	jeq .L479
	mvz.b 269161678,%d0
	cmp.l %d0,%d2
	jeq .L522
.L480:
	clr.l -(%sp)
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (12,%sp),%sp
	move.l %a2,%d4
.L482:
	mvz.b 269161678,%d0
	cmp.l %d0,%d2
	jeq .L523
.L485:
	mov3q.l #1,(%a2,%a4.l)
.L479:
	addq.l #1,%d2
	add.l #635712,%a2
	moveq #16,%d6
	cmp.l %d2,%d6
	jne .L486
	or.l %d5,fl_mig_pending
	mov3q.l #1,fl_mig_active
.L477:
	movem.l (%sp),#15612
	clr.l %d0
	lea (40,%sp),%sp
	rts
.L518:
	move.l 1187521622,%d1
	move.l %d1,%a1
	add.l #-1073741824,%a1
	cmp.l #134217727,%a1
	jhi .L458
	move.l %d1,%a0
	jra .L458
.L519:
	move.l #629642,%a4
	move.l %a0,%d2
	add.l %a0,%a4
	add.l #585388,%d2
	move.l %d2,%a1
	move.l %d2,%a0
	lea (-266,%a1),%a1
	lea (-240,%a0),%a0
.L465:
	mvz.b (%a1),%d1
	addq.l #1,%a1
	subq.l #1,%d1
	tst.l %d1
	jeq .L524
.L463:
	lea (30,%a0),%a0
	cmp.l %a0,%d2
	jne .L465
	cmp.l %d2,%a4
	jeq .L456
	add.l #6322,%d2
	move.l %d2,%a1
	move.l %d2,%a0
	lea (-266,%a1),%a1
	lea (-240,%a0),%a0
	jra .L465
.L524:
	mvz.b (%a0),%d1
	moveq #70,%d6
	cmp.l %d1,%d6
	jne .L463
	mvz.b 1(%a0),%d1
	moveq #77,%d6
	cmp.l %d1,%d6
	jne .L463
	mvz.b 2(%a0),%d1
	subq.l #1,%d1
	tst.l %d1
	jne .L463
	cmp.l %d2,%a4
	jeq .L525
.L461:
	move.l %d3,%d1
	and.l fl_ready_mask,%d1
	tst.l %d1
	jeq .L468
	move.l %d3,%d1
	and.l fl_blocked_mask,%d1
	tst.l %d1
	jne .L468
	move.l %d3,%d1
	and.l fl_io_protected_mask,%d1
	tst.l %d1
	jne .L468
	or.l %d3,%d5
	addq.l #1,%d0
	add.l #635712,%d4
	lea (160,%a2),%a2
	moveq #16,%d1
	cmp.l %d0,%d1
	jne .L471
	jra .L526
.L520:
	move.l %d2,-(%sp)
	jsr (%a2)
	addq.l #4,%sp
	subq.l #2,%d0
	tst.l %d0
	jne .L473
	jsr fl_io_irq_lock
	or.l %d3,fl_blocked_mask
	move.l %d3,%d6
	not.l %d6
	and.l %d6,%d5
	lea fl_lane_free,%a0
	move.l %d0,-(%sp)
	or.l %d3,fl_io_pool_mask
	and.l %d6,fl_ready_mask
	move.l (%a0),fl_io_pool_free
	jsr (%a3)
	addq.l #4,%sp
	moveq #-64,%d0
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L473
	pea -64.w
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L476
	jra .L527
.L525:
	tst.l %a3
	jne .L461
	addq.l #1,%d0
	add.l #635712,%d4
	lea (160,%a2),%a2
	moveq #16,%d1
	cmp.l %d0,%d1
	jne .L471
	jra .L526
.L453:
	or.l %d1,%d0
	move.l #1074668000,%d4
	clr.l %d5
	lea fl_migration_table+3,%a2
	move.l %d0,fl_mig_capture_mask
	clr.l %d0
	jra .L471
.L522:
	move.l 1187521622,%d0
	move.l %d0,%d4
	add.l #-1073741824,%d0
	cmp.l #134217727,%d0
	jhi .L480
	clr.l -(%sp)
	move.l %d4,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (12,%sp),%sp
	cmp.l %a2,%d4
	jeq .L482
	clr.l -(%sp)
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (12,%sp),%sp
	mvz.b 269161678,%d0
	cmp.l %d0,%d2
	jne .L485
.L523:
	mov3q.l #1,-(%sp)
	move.l %d4,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	mov3q.l #1,269452696
	lea (12,%sp),%sp
	mov3q.l #1,(%a2,%a4.l)
	jra .L479
.L521:
	move.l %d5,-(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jeq .L478
	movem.l (%sp),#15612
	lea (40,%sp),%sp
	rts
.L468:
	movem.l (%sp),#15612
	moveq #-61,%d0
	lea (40,%sp),%sp
	rts
	.size	fl_mig_run, .-fl_mig_run
	.align	2
	.type	fl_migrate_restored.constprop.0, @function
fl_migrate_restored.constprop.0:
	link.w %fp,#-8
	move.l %d2,-(%sp)
	pea -4(%fp)
	pea -8(%fp)
	mov3q.l #1,-(%sp)
	jsr (fl_mig_text_read.constprop.0)
	lea (12,%sp),%sp
	mov3q.l #1,%d2
	move.l 8(%fp),%d1
	not.l %d1
	and.l %d1,fl_mig_known_mask
	and.l %d1,fl_mig_capture_mask
	cmp.l %d0,%d2
	jcc .L532
	move.l -12(%fp),%d2
	unlk %fp
	rts
.L532:
	tst.l -4(%fp)
	seq %d0
	and.l %d1,fl_mig_pending
	mvs.b %d0,%d0
	neg.l %d0
	move.l %d0,-(%sp)
	move.l 8(%fp),-(%sp)
	jsr fl_mig_run
	move.l -12(%fp),%d2
	addq.l #8,%sp
	unlk %fp
	rts
	.size	fl_migrate_restored.constprop.0, .-fl_migrate_restored.constprop.0
	.align	2
	.type	restore_mask, @function
restore_mask:
	lea (-32,%sp),%sp
	movem.l #19516,(%sp)
	move.l 36(%sp),%d5
	clr.l %d2
	lea read_bank,%a6
	lea (write_buffer.constprop.0),%a2
	lea (publish.constprop.0),%a3
.L541:
	mov3q.l #1,%d3
	lsl.l %d2,%d3
	move.l %d3,%d0
	and.l %d5,%d0
	tst.l %d0
	jne .L549
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L541
.L552:
	clr.l %d0
.L533:
	movem.l (%sp),#19516
	lea (32,%sp),%sp
	rts
.L549:
	pea 28(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	jsr (%a6)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L550
	tst.l %d0
	jne .L533
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr (%a2)
	addq.l #8,%sp
	tst.l %d0
	jne .L533
	move.l 28(%sp),-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	addq.l #8,%sp
	moveq #-64,%d1
	cmp.l %d0,%d1
	jeq .L551
	tst.l %d0
	jne .L542
	move.l %d3,%d0
	not.l %d3
	or.l fl_present_mask,%d0
	and.l %d3,fl_io_protected_mask
	move.l %d0,fl_present_mask
.L553:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L541
	jra .L552
.L550:
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	pea fl_io_path
	jsr (path_for.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L536
	pea fl_io_path
	jsr fl_io_fs_remove
	addq.l #4,%sp
	tst.l %d0
	jge .L536
	moveq #-12,%d1
	cmp.l %d0,%d1
	jne .L533
.L536:
	move.l %d2,-(%sp)
	jsr fresh_bank
	not.l %d3
	addq.l #4,%sp
	move.l %d3,%d0
	and.l fl_present_mask,%d0
	and.l %d3,fl_io_protected_mask
	move.l %d0,fl_present_mask
	jra .L553
.L551:
	move.l %d1,fl_io_last_error
	tst.l fl_io_warning
	jne .L540
	pea -64.w
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
.L540:
	addq.l #1,%d2
	moveq #16,%d0
	or.l %d3,fl_present_mask
	cmp.l %d2,%d0
	jne .L541
	jra .L552
.L542:
	movem.l (%sp),#19516
	moveq #-60,%d0
	lea (32,%sp),%sp
	rts
	.size	restore_mask, .-restore_mask
	.align	2
	.type	load_bank, @function
load_bank:
	lea (-28,%sp),%sp
	movem.l #17436,(%sp)
	move.l 32(%sp),%d3
	mov3q.l #1,%d2
	pea 24(%sp)
	clr.l -(%sp)
	lsl.l %d3,%d2
	move.l %d3,-(%sp)
	pea fl_io_base
	clr.l 40(%sp)
	lea read_bank,%a2
	move.l %d2,%d4
	not.l %d4
	and.l %d4,fl_present_mask
	jsr (%a2)
	lea (16,%sp),%sp
	move.l %d0,%a6
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jeq .L555
	or.l %d2,fl_present_mask
	tst.l %a6
	jeq .L589
	pea 24(%sp)
	mov3q.l #1,-(%sp)
	move.l %d3,-(%sp)
	pea fl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L573
	or.l %d2,fl_present_mask
	tst.l %d0
	jne .L573
.L574:
	move.l 24(%sp),-(%sp)
	move.l %d3,-(%sp)
	jsr (publish.constprop.0)
	addq.l #8,%sp
	move.l %d0,%d1
	moveq #-64,%d0
	cmp.l %d1,%d0
	jeq .L585
	tst.l %d1
	jne .L560
	moveq #-61,%d3
	cmp.l %a6,%d3
	jeq .L590
	or.l %d2,fl_io_protected_mask
	tst.l %a6
	jlt .L567
	move.w #-60,%a6
.L567:
	move.l %a6,fl_io_last_error
	tst.l fl_io_warning
	jne .L554
	mov3q.l #1,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	clr.l %d1
.L554:
	movem.l (%sp),#17436
	move.l %d1,%d0
	lea (28,%sp),%sp
	rts
.L589:
	move.l 24(%sp),-(%sp)
	move.l %d3,-(%sp)
	jsr (publish.constprop.0)
	addq.l #8,%sp
	move.l %d0,%d1
	moveq #-64,%d0
	cmp.l %d1,%d0
	jeq .L585
	tst.l %d1
	jne .L560
	pea 24(%sp)
	mov3q.l #1,-(%sp)
	move.l %d3,-(%sp)
	moveq #-61,%d3
	pea fl_io_base
	move.l %d1,36(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	move.l 20(%sp),%d1
	cmp.l %d0,%d3
	jeq .L591
	tst.l %d0
	jge .L554
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L554
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d1,28(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 20(%sp),%d1
.L593:
	movem.l (%sp),#17436
	move.l %d1,%d0
	lea (28,%sp),%sp
	rts
.L555:
	pea 24(%sp)
	mov3q.l #1,-(%sp)
	move.l %d3,-(%sp)
	pea fl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jne .L592
	move.l %d3,-(%sp)
	jsr fresh_bank
	addq.l #4,%sp
	movem.l (%sp),#17436
	clr.l %d1
	move.l %d1,%d0
	lea (28,%sp),%sp
	rts
.L592:
	or.l %d2,fl_present_mask
	tst.l %d0
	jeq .L574
	or.l %d2,fl_blocked_mask
	and.l %d4,fl_ready_mask
.L569:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L560
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
.L560:
	moveq #-60,%d1
	move.l %d1,%d0
	movem.l (%sp),#17436
	lea (28,%sp),%sp
	rts
.L590:
	or.l %d2,fl_blocked_mask
	and.l %d4,fl_ready_mask
	or.l %d2,fl_io_protected_mask
	jra .L567
.L591:
	or.l %d2,fl_blocked_mask
	and.l %d4,fl_ready_mask
	move.l %d3,fl_io_last_error
	tst.l fl_io_warning
	jne .L554
	pea -61.w
	pea fl_io_ui_warning
	move.l %d1,28(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 20(%sp),%d1
	jra .L593
.L573:
	or.l %d2,fl_blocked_mask
	move.l %a6,%d0
	and.l %d4,fl_ready_mask
	jra .L569
.L585:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L554
	pea -64.w
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	movem.l (%sp),#17436
	moveq #-64,%d1
	move.l %d1,%d0
	lea (28,%sp),%sp
	rts
	.size	load_bank, .-load_bank
	.align	2
	.globl	fl_io_play_tick
	.type	fl_io_play_tick, @function
fl_io_play_tick:
	move.l %d2,-(%sp)
	tst.l fl_io_loaded
	jeq .L595
	move.l fl_dirty_mask,%d1
	move.l fl_ready_mask,%a0
	move.l %a0,%d2
	move.l fl_blocked_mask,%d0
	and.l %d2,%d1
	or.l fl_io_protected_mask,%d0
	not.l %d0
	and.l %d1,%d0
	tst.l %d0
	jeq .L595
	move.l fl_io_play_ticks,%d0
	moveq #59,%d1
	addq.l #1,%d0
	cmp.l %d0,%d1
	jcc .L601
	clr.l fl_io_play_ticks
	tst.l fl_io_flush_pending
	jeq .L602
	move.l (%sp)+,%d2
	rts
.L595:
	move.l (%sp)+,%d2
	clr.l fl_io_play_ticks
	rts
.L602:
	mov3q.l #1,-(%sp)
	jsr (own_post.isra.0)
	addq.l #4,%sp
	move.l (%sp)+,%d2
	rts
.L601:
	move.l (%sp)+,%d2
	move.l %d0,fl_io_play_ticks
	rts
	.size	fl_io_play_tick, .-fl_io_play_tick
	.align	2
	.globl	fl_io_before_job
	.type	fl_io_before_job, @function
fl_io_before_job:
	lea (-16,%sp),%sp
	move.l %d2,-(%sp)
	move.l 24(%sp),%a0
	cmp.l #fl_io_flush_job,%a0
	jeq .L655
	move.b (%a0),%d1
	mov3q.l #2,%d2
	mvz.b %d1,%d0
	move.l %d0,fl_io_job_kind
	cmp.l %d0,%d2
	jeq .L656
	clr.l fl_io_warning
	moveq #18,%d2
	cmp.l %d0,%d2
	jcs .L606
	move.l #401296,%d2
	btst %d0,%d2
	jeq .L606
	tst.l fl_io_loaded
	jne .L613
	moveq #8,%d1
	cmp.l %d0,%d1
	jeq .L651
	moveq #12,%d1
	cmp.l %d0,%d1
	jeq .L651
.L606:
	clr.l %d0
.L603:
	move.l (%sp)+,%d2
	lea (16,%sp),%sp
	rts
.L656:
	tst.l fl_io_loaded
	jeq .L606
	move.l #65535,-(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
.L617:
	tst.l %d0
	jeq .L603
	move.l %d0,fl_io_last_error
	move.l fl_io_warning,%d1
	tst.l %d1
	jne .L603
.L616:
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,16(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 8(%sp),%d0
.L657:
	move.l (%sp)+,%d2
	lea (16,%sp),%sp
	rts
.L613:
	move.l #65535,-(%sp)
	move.l %d1,8(%sp)
	jsr (flush_ab.constprop.0)
	move.l 8(%sp),%d1
	addq.l #4,%sp
	and.l #251,%d1
	subq.l #8,%d1
	tst.l %d1
	jne .L617
	tst.l fl_blocked_mask
	jeq .L617
	move.l fl_io_warning,%d1
	moveq #-61,%d0
	move.l %d0,fl_io_last_error
	tst.l %d1
	jne .L603
	jra .L616
.L651:
	tst.l fl_blocked_mask
	jeq .L606
	moveq #-61,%d0
	moveq #-61,%d2
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,16(%sp)
	move.l %d2,fl_io_last_error
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 8(%sp),%d0
	jra .L657
.L655:
	jsr fl_io_irq_lock
	move.l fl_io_own_work,%d1
	clr.l fl_io_own_work
	clr.l fl_io_flush_pending
	move.l %d1,16(%sp)
	move.l %d0,-(%sp)
	jsr fl_io_irq_restore
	addq.l #4,%sp
	move.l 16(%sp),%d2
	btst #1,%d2
	jne .L658
.L605:
	move.l 16(%sp),%d1
	btst #0,%d1
	jeq .L606
	tst.l fl_io_loaded
	jeq .L606
	move.l #65535,-(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jeq .L603
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L606
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l (%sp)+,%d2
	clr.l %d0
	lea (16,%sp),%sp
	rts
.L658:
	tst.l fl_io_loaded
	jeq .L606
	move.l fl_io_pool_mask,%d1
	mov3q.l #1,%d2
	move.l %d1,12(%sp)
	clr.l %d1
	lsl.l %d1,%d2
	move.l %d2,%d0
	and.l 12(%sp),%d0
	tst.l %d0
	jne .L659
.L607:
	addq.l #1,%d1
	moveq #16,%d0
	cmp.l %d1,%d0
	jeq .L605
.L654:
	mov3q.l #1,%d2
	lsl.l %d1,%d2
	move.l %d2,%d0
	and.l 12(%sp),%d0
	tst.l %d0
	jeq .L607
.L659:
	move.l %d1,-(%sp)
	move.l %d2,12(%sp)
	move.l %d1,8(%sp)
	clr.l fl_io_warning
	jsr load_bank
	move.l 12(%sp),%a0
	move.l %a0,%d2
	and.l fl_io_pool_mask,%d2
	addq.l #4,%sp
	move.l 4(%sp),%d1
	or.l %d2,%d0
	jne .L607
	tst.l fl_mig_marked
	seq %d0
	mvs.b %d0,%d0
	neg.l %d0
	move.l %d0,-(%sp)
	move.l %a0,-(%sp)
	move.l %d1,12(%sp)
	jsr fl_mig_run
	addq.l #8,%sp
	move.l 4(%sp),%d1
	tst.l %d0
	jeq .L607
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L607
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d1,12(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	moveq #16,%d0
	move.l 4(%sp),%d1
	addq.l #1,%d1
	cmp.l %d1,%d0
	jne .L654
	jra .L605
	.size	fl_io_before_job, .-fl_io_before_job
	.align	2
	.globl	fl_io_reject_job
	.type	fl_io_reject_job, @function
fl_io_reject_job:
	lea (-12,%sp),%sp
	moveq #20,%d1
	move.l %d2,-(%sp)
	move.l 20(%sp),%a0
	move.l 24(%sp),12(%sp)
	mvz.b (%a0),%d0
	cmp.l %d0,%d1
	jcs .L660
	move.w .L663(%pc,%d0.l*2),%d0
	ext.l %d0
	jmp %pc@(2,%d0:l)
	.balignw 2,0x284c
	.swbeg	&21
.L663:
	.word .L660-.L663
	.word .L660-.L663
	.word .L665-.L663
	.word .L660-.L663
	.word .L668-.L663
	.word .L660-.L663
	.word .L660-.L663
	.word .L668-.L663
	.word .L668-.L663
	.word .L668-.L663
	.word .L666-.L663
	.word .L665-.L663
	.word .L664-.L663
	.word .L660-.L663
	.word .L660-.L663
	.word .L660-.L663
	.word .L660-.L663
	.word .L662-.L663
	.word .L662-.L663
	.word .L662-.L663
	.word .L662-.L663
.L660:
	move.l (%sp)+,%d2
	lea (12,%sp),%sp
	rts
.L668:
	mvz.w #270,%d0
	move.w #271,%a1
	mvz.w #269,%d1
	move.l %d0,4(%sp)
	mvz.w #268,%d0
.L667:
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
	jeq .L660
	move.l 12(%sp),24(%sp)
	move.l %d0,20(%sp)
	move.l (%sp)+,%d2
	lea (12,%sp),%sp
	jra fl_io_post
.L662:
	moveq #10,%d2
	moveq #9,%d1
	move.w #11,%a1
	move.l %d2,4(%sp)
	moveq #8,%d0
	jra .L667
.L665:
	moveq #8,%d2
	mov3q.l #7,%d1
	move.w #9,%a1
	move.l %d2,4(%sp)
	mov3q.l #6,%d0
	jra .L667
.L666:
	moveq #12,%d0
	moveq #11,%d1
	move.l %d0,4(%sp)
	moveq #10,%d0
	move.w #13,%a1
	jra .L667
.L664:
	mvz.w #528,%d1
	move.w #529,%a1
	mvz.w #526,%d0
	move.l %d1,4(%sp)
	mvz.w #527,%d1
	jra .L667
	.size	fl_io_reject_job, .-fl_io_reject_job
	.align	2
	.globl	fl_mig_marker_due
	.type	fl_mig_marker_due, @function
fl_mig_marker_due:
	move.l fl_io_loaded,%d0
	tst.l %d0
	jeq .L674
	move.l fl_mig_active,%d0
	tst.l %d0
	jeq .L674
	move.l fl_mig_durable,%d0
	tst.l %d0
	jeq .L674
	tst.l fl_mig_pending
	seq %d0
	mvs.b %d0,%d0
	neg.l %d0
.L674:
	rts
	.size	fl_mig_marker_due, .-fl_mig_marker_due
	.align	2
	.globl	fl_mig_retire_current
	.type	fl_mig_retire_current, @function
fl_mig_retire_current:
	lea (-40,%sp),%sp
	mov3q.l #7,%d0
	move.l 44(%sp),%d1
	movem.l #1036,(%sp)
	move.l 48(%sp),%a1
	cmp.l %d1,%d0
	jcs .L687
	tst.l fl_io_loaded
	jeq .L687
	move.b 269161678,%d0
	move.b 269161679,%d2
	move.l 1187521622,%a0
	mvz.b %d0,%d3
	move.b %d2,24(%sp)
	moveq #15,%d2
	move.l %d3,28(%sp)
	cmp.l %d3,%d2
	jcs .L687
	mvz.b 24(%sp),%d3
	mov3q.l #3,%d2
	move.l %d3,24(%sp)
	cmp.l %d3,%d2
	jcs .L687
	add.l #-1073741824,%a0
	cmp.l #134217727,%a0
	jhi .L687
	mov3q.l #1,%d3
	move.l 28(%sp),%d2
	lsl.l %d2,%d3
	move.l %d3,32(%sp)
	and.l fl_ready_mask,%d3
	tst.l %d3
	jeq .L687
	move.l 32(%sp),%d3
	and.l fl_blocked_mask,%d3
	tst.l %d3
	jne .L687
	ext.w %d0
	mov3q.l #1,%d3
	mulu.w #160,%d0
	move.l %d0,%a0
	add.l #fl_migration_table,%a0
	move.b 3(%a0),%d0
	mvz.b %d0,%d2
	cmp.l %d2,%d3
	jcs .L687
	tst.b %d0
	jne .L693
	move.l 32(%sp),%d0
	and.l fl_mig_known_mask,%d0
	tst.l %d0
	jeq .L687
	move.l 32(%sp),%d0
	and.l fl_mig_capture_mask,%d0
	tst.l %d0
	jne .L692
.L694:
	tst.l %a1
	jeq .L687
.L693:
	move.l %d1,12(%sp)
	move.l %a0,16(%sp)
	jsr fl_io_irq_lock
	mov3q.l #1,%d3
	move.l 16(%sp),%a0
	move.l %d0,36(%sp)
	move.l 12(%sp),%d1
	move.b 3(%a0),%d0
	mvz.b %d0,%d2
	cmp.l %d2,%d3
	jcc .L708
.L691:
	movem.l (%sp),#1036
	move.l 36(%sp),44(%sp)
	lea (40,%sp),%sp
	jra fl_io_irq_restore
.L687:
	movem.l (%sp),#1036
	lea (40,%sp),%sp
	rts
.L708:
	tst.b %d0
	jne .L695
	mov3q.l #1,(%a0)
.L695:
	move.l 24(%sp),%a1
	mov3q.l #1,%d2
	lsl.l %d1,%d2
	move.l 32(%sp),%d3
	lea 4(%a0,%a1.l),%a1
	move.l 28(%sp),%a0
	move.l %d2,%d1
	not.l %d1
	move.l %a1,%a2
	move.b (%a2),27(%sp)
	lea fl_generation,%a1
	move.b 27(%sp),%d2
	and.l %d2,%d1
	move.b %d1,(%a2)
	or.l %d3,fl_dirty_mask
	movem.l (%sp),#1036
	addq.l #1,(%a1,%a0.l*4)
	move.l 36(%sp),44(%sp)
	lea (40,%sp),%sp
	jra fl_io_irq_restore
.L692:
	move.l 28(%sp),-(%sp)
	move.l %d1,16(%sp)
	move.l %a0,20(%sp)
	move.l %a1,24(%sp)
	jsr fl_mig_capture
	addq.l #4,%sp
	move.l 16(%sp),%a0
	move.l 12(%sp),%d1
	move.l 20(%sp),%a1
	tst.b 3(%a0)
	jeq .L694
	move.l %d1,12(%sp)
	move.l %a0,16(%sp)
	jsr fl_io_irq_lock
	mov3q.l #1,%d3
	move.l 16(%sp),%a0
	move.l %d0,36(%sp)
	move.l 12(%sp),%d1
	move.b 3(%a0),%d0
	mvz.b %d0,%d2
	cmp.l %d2,%d3
	jcs .L691
	jra .L708
	.size	fl_mig_retire_current, .-fl_mig_retire_current
	.align	2
	.globl	fl_io_ui_tick
	.type	fl_io_ui_tick, @function
fl_io_ui_tick:
	lea (-16,%sp),%sp
	movem.l #28,(%sp)
	tst.l 20(%sp)
	jne .L725
	move.l fl_io_full_seen,%d0
	clr.l fl_io_play_ticks
	cmp.l fl_lane_full.l,%d0
	jne .L726
.L712:
	move.l fl_lane_gc_mask,%d3
	tst.l %d3
	jeq .L713
	mov3q.l #1,%d1
	and.l %d3,%d1
	btst #0,%d3
	jne .L717
.L715:
	addq.l #1,%d1
	mov3q.l #1,%d0
	lsl.l %d1,%d0
	move.l %d0,%d2
	and.l %d3,%d2
	tst.l %d2
	jeq .L715
	move.l %d1,12(%sp)
	move.l %d0,%d2
	not.l %d2
	jsr fl_io_irq_lock
	move.l %d0,-(%sp)
	and.l %d2,fl_lane_gc_mask
	jsr fl_io_irq_restore
	move.l 16(%sp),%d1
	move.l %d1,-(%sp)
	jsr fl_io_core_gc
	addq.l #8,%sp
.L713:
	tst.l fl_io_pool_mask
	jeq .L709
	move.l fl_io_pool_free,%d0
	cmp.l fl_lane_free.l,%d0
	jcc .L709
	tst.l fl_io_flush_pending
	jeq .L727
.L709:
	movem.l (%sp),#28
	lea (16,%sp),%sp
	rts
.L726:
	pea 48.w
	lea fl_lane_full,%a0
	pea .LC2
	move.l (%a0),fl_io_full_seen
	jsr fl_io_toast
	addq.l #8,%sp
	jra .L712
.L725:
	jsr fl_io_play_tick
	move.l fl_io_full_seen,%d0
	cmp.l fl_lane_full.l,%d0
	jeq .L712
	jra .L726
.L727:
	movem.l (%sp),#28
	mov3q.l #2,20(%sp)
	lea (16,%sp),%sp
	jra (own_post.isra.0)
.L717:
	clr.l %d1
	move.l %d1,12(%sp)
	moveq #-2,%d2
	jsr fl_io_irq_lock
	move.l %d0,-(%sp)
	and.l %d2,fl_lane_gc_mask
	jsr fl_io_irq_restore
	move.l 16(%sp),%d1
	move.l %d1,-(%sp)
	jsr fl_io_core_gc
	addq.l #8,%sp
	jra .L713
	.size	fl_io_ui_tick, .-fl_io_ui_tick
	.align	2
	.globl	fl_io_banks_load
	.type	fl_io_banks_load, @function
fl_io_banks_load:
	link.w %fp,#-544
	movem.l #1036,(%sp)
	move.l 20(%fp),-(%sp)
	lea fl_io_stock_directory,%a2
	move.l 16(%fp),-(%sp)
	move.l 12(%fp),-(%sp)
	move.l 8(%fp),-(%sp)
	jsr fl_io_stock_banks_load
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %d0,-528(%fp)
	jsr (%a2)
	lea (24,%sp),%sp
	tst.l %d0
	jeq .L728
	move.l %fp,%d2
	move.l %d0,%a1
	lea (-520,%fp),%a0
	add.l #-260,%d2
.L731:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L730
	cmp.l %d2,%a0
	jne .L731
.L728:
	movem.l -544(%fp),#1036
	move.l -528(%fp),%d0
	unlk %fp
	rts
.L730:
	tst.l fl_io_loaded
	jeq .L732
	mov3q.l #4,%d0
	cmp.l fl_io_job_kind.l,%d0
	jeq .L732
	move.b -520(%fp),%d0
	jeq .L772
	lea fl_io_base,%a1
	lea (-520,%fp),%a0
.L735:
	mvs.b (%a1),%d1
	mvs.b %d0,%d0
	addq.l #1,%a0
	addq.l #1,%a1
	cmp.l %d1,%d0
	jne .L732
	move.b (%a0),%d0
	jne .L735
	move.b (%a1),%d0
	jeq .L728
.L732:
	clr.l -(%sp)
	clr.l -(%sp)
	jsr (%a2)
	addq.l #8,%sp
	tst.l %d0
	jeq .L737
	move.l %d0,%a1
	move.l %fp,%a2
	move.l %d2,-532(%fp)
	move.l %d2,%a0
.L739:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L738
	cmp.l %a0,%a2
	jne .L739
.L737:
	moveq #-63,%d0
.L745:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L728
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	movem.l -544(%fp),#1036
	move.l -528(%fp),%d0
	unlk %fp
	rts
.L738:
	jsr fl_reset
	jsr fl_clip_reset
	jsr fl_seq_reset
	clr.l fl_io_protected_mask
	clr.l fl_io_loaded
	clr.l fl_io_warning
	clr.l fl_io_last_error
	clr.l fl_present_mask
	clr.l fl_io_pool_mask
	lea fl_io_base,%a0
.L741:
	addq.l #1,%a0
	move.l -532(%fp),%a1
	addq.l #1,%a1
	move.b -1(%a1),%d0
	move.l %a1,-532(%fp)
	move.b %d0,-1(%a0)
	jeq .L740
	cmp.l %a1,%a2
	jne .L741
	clr.b %d0
	move.b %d0,fl_io_base
.L740:
	clr.l -532(%fp)
	lea load_bank,%a2
.L742:
	move.l -532(%fp),-(%sp)
	jsr (%a2)
	addq.l #4,%sp
	addq.l #1,-532(%fp)
	moveq #16,%d3
	cmp.l -532(%fp),%d3
	jne .L742
	move.l %d2,-(%sp)
	pea -524(%fp)
	clr.l -(%sp)
	mov3q.l #1,fl_io_loaded
	jsr (fl_mig_text_read.constprop.0)
	clr.l fl_mig_known_mask
	clr.l fl_mig_capture_mask
	clr.l fl_mig_pending
	clr.l fl_mig_active
	clr.l fl_mig_pristine
	clr.l fl_mig_durable
	lea (12,%sp),%sp
	tst.l %d0
	jne .L773
	move.l -260(%fp),%a1
	clr.l %d2
	lea fl_migration_table+3,%a0
	move.l #fl_migration_table+2563,%d1
	move.l %a1,fl_mig_active
	move.l %a1,fl_mig_marked
	move.l %a1,fl_mig_durable
.L746:
	move.b (%a0),%d0
	mov3q.l #2,%d3
	lea (160,%a0),%a0
	eor.l %d3,%d0
	tst.b %d0
	seq %d0
	mvs.b %d0,%d0
	neg.l %d0
	or.l %d0,%d2
	cmp.l %d1,%a0
	jne .L746
	tst.l %a1
	seq %d0
	mvs.b %d0,%d0
	neg.l %d0
	move.l %d0,-(%sp)
	move.l #65535,-(%sp)
	jsr fl_mig_run
	addq.l #8,%sp
	tst.l %d0
	jne .L745
	tst.l %d2
	jne .L774
	tst.l fl_mig_active
	jne .L728
	movem.l -544(%fp),#1036
	move.l -528(%fp),%d0
	mov3q.l #1,fl_mig_pristine
	unlk %fp
	rts
.L773:
	tst.l %d0
	jlt .L745
	movem.l -544(%fp),#1036
	move.l -528(%fp),%d0
	unlk %fp
	rts
.L774:
	movem.l -544(%fp),#1036
	move.l -528(%fp),%d0
	mov3q.l #1,fl_mig_active
	unlk %fp
	rts
.L772:
	move.b fl_io_base,%d0
	jeq .L728
	jra .L732
	.size	fl_io_banks_load, .-fl_io_banks_load
	.align	2
	.globl	fl_io_banks_save
	.type	fl_io_banks_save, @function
fl_io_banks_save:
	lea (-284,%sp),%sp
	movem.l #19484,(%sp)
	move.l 292(%sp),%d2
	move.l 300(%sp),-(%sp)
	move.l 300(%sp),-(%sp)
	move.l %d2,-(%sp)
	move.l 300(%sp),-(%sp)
	jsr fl_io_stock_banks_save
	lea (16,%sp),%sp
	move.l fl_io_job_kind,%d1
	subq.l #8,%d1
	move.l %d0,%d3
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jcc .L776
	tst.l %d3
	jlt .L775
	move.l fl_io_loaded,%a6
	tst.l %a6
	jne .L803
	mvz.w %d2,%d2
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	jsr (fl_migrate_saved.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jlt .L810
.L775:
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (284,%sp),%sp
	rts
.L776:
	clr.l -(%sp)
	clr.l -(%sp)
	jsr fl_io_stock_directory
	addq.l #8,%sp
	tst.l %d0
	jeq .L779
	lea (24,%sp),%a6
	move.l %d0,%a1
	move.l %a6,%a0
	lea (284,%sp),%a2
.L781:
	move.b (%a1),%d1
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d1,-1(%a0)
	jeq .L780
	cmp.l %a0,%a2
	jne .L781
	clr.b %d1
	move.b %d1,24(%sp)
.L779:
	clr.b %d0
	moveq #-63,%d1
	clr.l fl_io_loaded
	move.l %d1,fl_io_last_error
	move.b %d0,fl_io_base
	tst.l fl_io_warning
	jne .L785
	pea -63.w
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
.L785:
	tst.l %d3
	jlt .L775
	moveq #-63,%d3
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (284,%sp),%sp
	rts
.L780:
	tst.l fl_io_loaded
	jeq .L782
	move.b 24(%sp),%d0
	jeq .L829
	lea fl_io_base,%a1
	lea (24,%sp),%a0
.L787:
	mvs.b (%a1),%d1
	mvs.b %d0,%d0
	addq.l #1,%a0
	addq.l #1,%a1
	cmp.l %d0,%d1
	jne .L782
	move.b (%a0),%d0
	jne .L787
	move.b (%a1),%d0
.L784:
	tst.b %d0
	jne .L782
	tst.l %d3
	jlt .L775
.L803:
	mvz.w %d2,%d2
	move.l %d2,-(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jne .L810
	sub.l %a6,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	jsr (fl_migrate_saved.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jge .L775
.L810:
	move.l %d0,%d3
.L804:
	move.l %d3,fl_io_last_error
	tst.l fl_io_warning
	jne .L775
	move.l %d3,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (284,%sp),%sp
	rts
.L782:
	moveq #9,%d0
	cmp.l fl_io_job_kind.l,%d0
	jeq .L830
	lea fl_io_base,%a0
.L792:
	move.b (%a6),%d0
	addq.l #1,%a0
	addq.l #1,%a6
	move.b %d0,-1(%a0)
	jeq .L791
	cmp.l %a6,%a2
	jne .L792
	clr.b %d0
	move.b %d0,fl_io_base
.L791:
	mov3q.l #1,fl_io_loaded
	clr.l fl_io_protected_mask
	clr.l %d4
	clr.l %d2
	lea (path_for.part.0),%a2
	lea fl_io_fs_open,%a3
.L793:
	sub.l %a6,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	pea fl_io_path
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jeq .L831
.L795:
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jne .L807
.L833:
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L793
	move.l %d4,fl_present_mask
	jsr fl_io_irq_lock
	move.l fl_blocked_mask,%d1
	not.l %d1
	and.l fl_ready_mask,%d1
	move.l %d0,-(%sp)
	or.l %d1,fl_dirty_mask
	jsr fl_io_irq_restore
	addq.l #4,%sp
	tst.l %d3
	jlt .L804
	tst.l fl_io_loaded
	jeq .L808
	move.l #65535,-(%sp)
	jsr store_ab
	addq.l #4,%sp
	tst.l %d0
	jne .L810
	mvz.w #65535,%d2
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	jsr (fl_migrate_saved.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jge .L775
	jra .L810
.L831:
	pea 512.w
	pea fl_io_sector
	pea .LC6
	pea fl_io_path
	pea fl_io_object
	jsr (%a3)
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L832
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	or.l %d0,%d4
.L834:
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jeq .L833
.L807:
	mov3q.l #1,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	pea fl_io_path
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L795
	jra .L831
.L832:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jeq .L795
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	or.l %d0,%d4
	jra .L834
.L830:
	jsr fl_reset
	jsr fl_clip_reset
	jsr fl_seq_reset
	mvz.w #65535,%d1
	clr.l fl_present_mask
	clr.l fl_io_pool_mask
	clr.l fl_io_warning
	move.l %d1,fl_ready_mask
	clr.l fl_io_protected_mask
	clr.l fl_io_last_error
	clr.l fl_mig_pending
	clr.l fl_mig_active
	mov3q.l #1,fl_mig_pristine
	clr.l fl_mig_durable
	move.l %d1,fl_mig_known_mask
	clr.l fl_mig_capture_mask
	lea fl_io_base,%a0
	jra .L792
.L808:
	moveq #-60,%d3
	jra .L804
.L829:
	move.b fl_io_base,%d0
	jra .L784
	.size	fl_io_banks_save, .-fl_io_banks_save
	.align	2
	.globl	fl_io_card_sync
	.type	fl_io_card_sync, @function
fl_io_card_sync:
	lea (-12,%sp),%sp
	move.l 16(%sp),%d1
	move.l 20(%sp),%a0
	move.l 24(%sp),%a1
	tst.l fl_io_loaded
	jne .L845
.L836:
	move.l %a1,-(%sp)
	move.l %a0,-(%sp)
	move.l %d1,-(%sp)
	jsr fl_io_stock_card_sync
	lea (12,%sp),%sp
	tst.l %d0
	jge .L846
.L835:
	lea (12,%sp),%sp
	rts
.L845:
	move.l #65535,-(%sp)
	move.l %d1,12(%sp)
	move.l %a0,8(%sp)
	move.l %a1,4(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
	move.l 8(%sp),%d1
	move.l 4(%sp),%a0
	move.l (%sp),%a1
	tst.l %d0
	jeq .L836
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L835
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,16(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 8(%sp),%d0
	lea (12,%sp),%sp
	rts
.L846:
	clr.l 20(%sp)
	clr.l 16(%sp)
	lea (12,%sp),%sp
	jra (fl_migrate_saved.constprop.0)
	.size	fl_io_card_sync, .-fl_io_card_sync
	.align	2
	.globl	fl_io_project_store
	.type	fl_io_project_store, @function
fl_io_project_store:
	subq.l #4,%sp
	move.l %d2,-(%sp)
	move.l 20(%sp),-(%sp)
	move.l 20(%sp),-(%sp)
	move.l 20(%sp),-(%sp)
	jsr fl_io_stock_project_store
	lea (12,%sp),%sp
	move.l %d0,%d2
	tst.l %d0
	jlt .L847
	tst.l fl_io_loaded
	jeq .L853
	move.l #65535,-(%sp)
	jsr store_ab
	addq.l #4,%sp
	tst.l %d0
	jeq .L857
.L849:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L852
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,12(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
.L852:
	move.l %d0,%d2
.L847:
	move.l %d2,%d0
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L857:
	mov3q.l #1,-(%sp)
	move.l #65535,-(%sp)
	jsr (fl_migrate_saved.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jlt .L849
	move.l %d2,%d0
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L853:
	moveq #-60,%d0
	jra .L849
	.size	fl_io_project_store, .-fl_io_project_store
	.align	2
	.globl	fl_io_bank_store
	.type	fl_io_bank_store, @function
fl_io_bank_store:
	subq.l #4,%sp
	move.l %d2,-(%sp)
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	jsr fl_io_stock_bank_store
	lea (16,%sp),%sp
	move.l %d0,%d2
	tst.l %d0
	jlt .L858
	tst.l fl_io_loaded
	jeq .L864
	move.l 16(%sp),%d1
	mvz.w %d1,%d1
	move.l %d1,-(%sp)
	move.l %d1,8(%sp)
	jsr store_ab
	addq.l #4,%sp
	move.l 4(%sp),%d1
	tst.l %d0
	jeq .L868
.L860:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L863
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,12(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
.L863:
	move.l %d0,%d2
.L858:
	move.l %d2,%d0
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L868:
	mov3q.l #2,-(%sp)
	move.l %d1,-(%sp)
	jsr (fl_migrate_saved.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jlt .L860
	move.l %d2,%d0
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L864:
	moveq #-60,%d0
	jra .L860
	.size	fl_io_bank_store, .-fl_io_bank_store
	.align	2
	.globl	fl_io_project_restore
	.type	fl_io_project_restore, @function
fl_io_project_restore:
	move.l fl_blocked_mask,%d0
	subq.l #8,%sp
	move.l %a6,-(%sp)
	move.l %a2,-(%sp)
	mvz.w %d0,%d0
	move.l %d0,%a6
	tst.l %d0
	jne .L880
	lea read_bank,%a2
.L872:
	pea 12(%sp)
	mov3q.l #1,-(%sp)
	move.l %a6,-(%sp)
	pea fl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jcc .L886
	move.l %d1,fl_io_last_error
	tst.l fl_io_warning
	jne .L869
.L887:
	move.l %d1,-(%sp)
	pea fl_io_ui_warning
	move.l %d1,16(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 8(%sp),%d1
.L869:
	move.l (%sp)+,%a2
	move.l %d1,%d0
	move.l (%sp)+,%a6
	addq.l #8,%sp
	rts
.L886:
	addq.l #1,%a6
	moveq #16,%d0
	cmp.l %a6,%d0
	jne .L872
	move.l 28(%sp),-(%sp)
	move.l 28(%sp),-(%sp)
	move.l 28(%sp),-(%sp)
	jsr fl_io_stock_project_restore
	lea (12,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L869
	move.l #65535,-(%sp)
	move.l %d1,12(%sp)
	jsr restore_mask
	addq.l #4,%sp
	tst.l %d0
	jne .L876
	move.l #65535,-(%sp)
	jsr (fl_migrate_restored.constprop.0)
	addq.l #4,%sp
	move.l 8(%sp),%d1
	tst.l %d0
	jeq .L869
.L876:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L877
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,16(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 8(%sp),%d0
.L877:
	move.l (%sp)+,%a2
	move.l %d0,%d1
	move.l %d1,%d0
	move.l (%sp)+,%a6
	addq.l #8,%sp
	rts
.L880:
	moveq #-61,%d1
	move.l %d1,fl_io_last_error
	tst.l fl_io_warning
	jne .L869
	jra .L887
	.size	fl_io_project_restore, .-fl_io_project_restore
	.align	2
	.globl	fl_io_bank_restore
	.type	fl_io_bank_restore, @function
fl_io_bank_restore:
	lea (-28,%sp),%sp
	movem.l #17436,(%sp)
	move.l 36(%sp),%d3
	mvz.w %d3,%d3
	move.l %d3,%d2
	and.l fl_blocked_mask,%d2
	tst.l %d2
	jne .L901
	lea read_bank,%a2
.L891:
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	and.l %d3,%d0
	tst.l %d0
	jne .L890
.L893:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L891
	move.l 44(%sp),-(%sp)
	move.l 44(%sp),-(%sp)
	move.l 44(%sp),-(%sp)
	move.l 44(%sp),-(%sp)
	jsr fl_io_stock_bank_restore
	lea (16,%sp),%sp
	move.l %d0,%a6
	tst.l %d0
	jlt .L888
	move.l %d3,-(%sp)
	jsr restore_mask
	addq.l #4,%sp
	tst.l %d0
	jne .L897
	move.l %d3,-(%sp)
	jsr (fl_migrate_restored.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jne .L897
.L888:
	move.l %a6,%d0
	movem.l (%sp),#17436
	lea (28,%sp),%sp
	rts
.L890:
	pea 24(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	move.l %d0,%a6
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jcc .L893
	move.l %a6,fl_io_last_error
	tst.l fl_io_warning
	jne .L888
.L909:
	move.l %a6,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l %a6,%d0
	movem.l (%sp),#17436
	lea (28,%sp),%sp
	rts
.L897:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L899
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,28(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 20(%sp),%d0
.L899:
	move.l %d0,%a6
	move.l %a6,%d0
	movem.l (%sp),#17436
	lea (28,%sp),%sp
	rts
.L901:
	move.w #-61,%a6
	move.l %a6,fl_io_last_error
	tst.l fl_io_warning
	jne .L888
	jra .L909
	.size	fl_io_bank_restore, .-fl_io_bank_restore
	.align	2
	.globl	fl_io_clear
	.type	fl_io_clear, @function
fl_io_clear:
	jsr fl_io_stock_clear
	jsr fl_reset
	jsr fl_clip_reset
	jsr fl_seq_reset
	clr.b %d0
	clr.l fl_io_protected_mask
	clr.l fl_io_loaded
	clr.l fl_io_warning
	clr.l fl_io_last_error
	clr.l fl_present_mask
	clr.l fl_io_pool_mask
	move.b %d0,fl_io_base
	rts
	.size	fl_io_clear, .-fl_io_clear
	.align	2
	.globl	fl_io_delete
	.type	fl_io_delete, @function
fl_io_delete:
	lea (-284,%sp),%sp
	movem.l #19468,(%sp)
	move.l 292(%sp),-(%sp)
	move.l 292(%sp),-(%sp)
	jsr fl_io_stock_directory
	addq.l #8,%sp
	tst.l %d0
	jeq .L913
	move.l %sp,%d3
	add.l #24,%d3
	move.l %d0,%a1
	move.l %d3,%a0
	lea (284,%sp),%a6
.L915:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L925
	cmp.l %a0,%a6
	jne .L915
.L913:
	moveq #-63,%d0
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L916
	pea -63.w
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
.L916:
	moveq #-63,%d0
.L912:
	movem.l (%sp),#19468
	lea (284,%sp),%sp
	rts
.L925:
	clr.l %d2
	lea (path_for.part.0),%a2
	lea fl_io_fs_remove,%a3
.L914:
	sub.l %a6,%a6
.L921:
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	move.l %d3,-(%sp)
	pea fl_io_path
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jeq .L942
	moveq #-63,%d0
.L937:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L912
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,28(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	movem.l (%sp),#19468
	move.l 20(%sp),%d0
	lea (284,%sp),%sp
	rts
.L942:
	pea fl_io_path
	jsr (%a3)
	addq.l #4,%sp
	tst.l %d0
	jlt .L943
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jne .L927
.L944:
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L914
	move.l 292(%sp),-(%sp)
	move.l 292(%sp),-(%sp)
	jsr fl_io_stock_delete
	addq.l #8,%sp
	tst.l %d0
	jlt .L937
	movem.l (%sp),#19468
	lea (284,%sp),%sp
	rts
.L943:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jne .L937
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jeq .L944
.L927:
	mov3q.l #1,%a6
	jra .L921
	.size	fl_io_delete, .-fl_io_delete
	.align	2
	.globl	fl_io_export
	.type	fl_io_export, @function
fl_io_export:
	lea (-1084,%sp),%sp
	movem.l #19580,(%sp)
	lea (44,%sp),%a6
	lea fl_io_base,%a0
	move.l %a6,%a1
.L947:
	move.b (%a0),%d0
	addq.l #1,%a1
	addq.l #1,%a0
	move.b %d0,-1(%a1)
	jeq .L946
	cmp.l #fl_io_base+260,%a0
	jne .L947
.L948:
	moveq #-63,%d1
	move.l %d1,36(%sp)
.L945:
	movem.l (%sp),#19580
	move.l 36(%sp),%d0
	lea (1084,%sp),%sp
	rts
.L946:
	move.l 1096(%sp),-(%sp)
	move.l 1096(%sp),-(%sp)
	jsr fl_io_stock_directory
	move.l %sp,%d5
	add.l #312,%d5
	addq.l #8,%sp
	move.l %sp,%d3
	move.l %d5,%a2
	move.l %d5,%a0
	addq.l #1,%a0
	move.l %d0,%a1
	add.l #564,%d3
	move.b (%a1),%d0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L986
.L949:
	cmp.l %d3,%a0
	jeq .L948
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jne .L949
.L986:
	move.b 44(%sp),%d0
	move.l %a6,%a0
	tst.b %d0
	jeq .L987
.L950:
	mvs.b (%a2),%d1
	mvs.b %d0,%d0
	addq.l #1,%a0
	addq.l #1,%a2
	cmp.l %d1,%d0
	jne .L955
	move.b (%a0),%d0
	jne .L950
	move.b (%a2),%d0
	jeq .L948
.L955:
	move.l 1104(%sp),-(%sp)
	move.l 1104(%sp),-(%sp)
	move.l 1104(%sp),-(%sp)
	move.l 1104(%sp),-(%sp)
	move.l 1104(%sp),-(%sp)
	jsr fl_io_stock_export
	move.l %d0,56(%sp)
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L945
	move.l %sp,%d6
	clr.l %d4
	lea read_bank,%a3
	add.l #824,%d6
	lea (path_for.part.0),%a2
	clr.l %d2
.L962:
	pea 40(%sp)
	move.l %d2,-(%sp)
	move.l %d4,-(%sp)
	move.l %a6,-(%sp)
	jsr (%a3)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L957
	tst.l %d0
	jne .L981
	move.l %d2,-(%sp)
	move.l %d4,-(%sp)
	move.l %a6,-(%sp)
	move.l %d3,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L948
	move.l %d2,-(%sp)
	move.l %d4,-(%sp)
	move.l %d5,-(%sp)
	move.l %d6,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L948
	clr.l -(%sp)
	move.l %d3,-(%sp)
	move.l %d6,-(%sp)
	jsr fl_io_fs_copy
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L981
.L957:
	subq.l #1,%d2
	tst.l %d2
	jne .L966
	addq.l #1,%d4
	moveq #16,%d1
	cmp.l %d4,%d1
	jeq .L945
	clr.l %d2
	jra .L962
.L981:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L959
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,40(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 32(%sp),%d0
.L959:
	movem.l (%sp),#19580
	move.l %d0,36(%sp)
	move.l 36(%sp),%d0
	lea (1084,%sp),%sp
	rts
.L966:
	mov3q.l #1,%d2
	jra .L962
.L987:
	move.b 304(%sp),%d0
	jne .L955
	jra .L948
	.size	fl_io_export, .-fl_io_export
	.section	.rodata
	.type	fl_mig_line, @object
	.size	fl_mig_line, 20
fl_mig_line:
	.string	"#SYNTH_VC_SETUP=1\r\n"
	.local	fl_mig_capture_mask
.section .data
.balign 4
fl_mig_capture_mask:
.space 4
	.local	fl_mig_known_mask
.section .data
.balign 4
fl_mig_known_mask:
.space 4
	.local	fl_mig_durable
.section .data
.balign 4
fl_mig_durable:
.space 4
	.local	fl_mig_pristine
.section .data
.balign 4
fl_mig_pristine:
.space 4
	.local	fl_mig_active
.section .data
.balign 4
fl_mig_active:
.space 4
	.local	fl_mig_pending
.section .data
.balign 4
fl_mig_pending:
.space 4
	.local	fl_io_play_ticks
.section .data
.balign 4
fl_io_play_ticks:
.space 4
	.local	fl_io_own_work
.section .data
.balign 4
fl_io_own_work:
.space 4
	.local	fl_io_flush_pending
.section .data
.balign 4
fl_io_flush_pending:
.space 4
	.local	fl_io_flush_job
.section .data
.balign 4
fl_io_flush_job:
.space 16
	.local	fl_mig_marked
.section .data
.balign 4
fl_mig_marked:
.space 4
	.local	fl_io_full_seen
.section .data
.balign 4
fl_io_full_seen:
.space 4
	.local	fl_io_pool_free
.section .data
.balign 4
fl_io_pool_free:
.space 4
	.local	fl_io_pool_mask
.section .data
.balign 4
fl_io_pool_mask:
.space 4
	.local	fl_present_mask
.section .data
.balign 4
fl_present_mask:
.space 4
	.local	fl_io_warning
.section .data
.balign 4
fl_io_warning:
.space 4
	.local	fl_io_job_kind
.section .data
.balign 4
fl_io_job_kind:
.space 4
	.local	fl_io_loaded
.section .data
.balign 4
fl_io_loaded:
.space 4
	.globl	fl_io_protected_mask
	.section	.data
	.align	2
	.type	fl_io_protected_mask, @object
	.size	fl_io_protected_mask, 4
fl_io_protected_mask:
	.zero	4
	.globl	fl_io_last_error
	.align	2
	.type	fl_io_last_error, @object
	.size	fl_io_last_error, 4
fl_io_last_error:
	.zero	4
	.local	fl_io_object2
.section .data
.balign 4
fl_io_object2:
.space 24
	.local	fl_io_object
.section .data
.balign 4
fl_io_object:
.space 24
	.local	fl_io_sector2
.section .data
.balign 4
fl_io_sector2:
.space 512
	.local	fl_io_sector
.section .data
.balign 4
fl_io_sector:
.space 512
	.local	fl_io_file
.section .data
.balign 4
fl_io_file:
.space 18624
	.local	fl_io_path
.section .data
.balign 4
fl_io_path:
.space 260
	.local	fl_io_base
.section .data
.balign 4
fl_io_base:
.space 260
.section .text
.endif

        .section .text
        .global fl_mig_retire,fl_mig_retire_fm
| d2 = current working track. Preserve every register and the caller's SR.
| C helper changes only RAM checkpoint ownership/dirty state; no card call here.
| Only the FM entry permits an empty current-format checkpoint in state 0.
fl_mig_retire:
        lea -64(%sp),%sp
        movem.l %d0-%d7/%a0-%a6,(%sp)
        move.w %sr,%d0
        move.l %d0,60(%sp)
        moveq #0,%d0
        move.l %d0,-(%sp)
        bra fl_mig_retire_call
fl_mig_retire_fm:
        lea -64(%sp),%sp
        movem.l %d0-%d7/%a0-%a6,(%sp)
        move.w %sr,%d0
        move.l %d0,60(%sp)
        pea 1
fl_mig_retire_call:
        move.l %d2,-(%sp)
        jsr fl_mig_retire_current:l
        lea 8(%sp),%sp
        move.l 60(%sp),%d0
        move.w %d0,%sr
        movem.l (%sp),%d0-%d7/%a0-%a6
        lea 64(%sp),%sp
        rts
| (2.23) the lane store's entries for the C (locks_store.inc.s, locks_scene_store.inc.s)
fl_io_core_free:
        move.l 4(%sp),%d0
        jmp fl_bank_free:l
fl_io_core_gc:
        move.l 4(%sp),%d0
        jmp fl_lane_gc:l
fl_io_core_taken:
        move.l 4(%sp),%d0
        jsr fl_lane_page:l
        move.l %a0,%d0
        rts
| (bank, row, control, value) -> 0, or -1 when no page is free: take and store, masked as one.
fl_io_core_set:
        move.l %d2,-(%sp)
        move.w %sr,%d2
        move.w #0x2700,%sr
        move.l 8(%sp),%d0
        lsl.l #7,%d0
        move.l 12(%sp),%d1
        lsr.l #6,%d1
        add.l %d1,%d0
        jsr fl_lane_take:l
        move.l 12(%sp),%d1
        andi.l #63,%d1
        add.l %d1,%d1
        bra fl_io_core_store
| (bank, scene word, control, value) -> 0, or -1 when no page is free.
fl_io_core_scene_set:
        move.l %d2,-(%sp)
        move.w %sr,%d2
        move.w #0x2700,%sr
        move.l 8(%sp),%d0
        move.l 12(%sp),%d1
        jsr fl_scene_map:l
        jsr fl_lane_take:l
fl_io_core_store:
        cmpa.l #0,%a0
        beq fl_io_core_full
        add.l 16(%sp),%d1
        move.l 20(%sp),%d0
        move.b %d0,(%a0,%d1.l)
        moveq #0,%d0
        bra fl_io_core_set_out
fl_io_core_full:
        moveq #-1,%d0
fl_io_core_set_out:
        move.w %d2,%sr
        move.l (%sp)+,%d2
        rts
fl_io_core_validate:
        move.l %a2,-(%sp)
        move.l 8(%sp),%d0
        move.l 12(%sp),%a0
        move.l 16(%sp),%d1
        move.l 20(%sp),%a2
        bsr fl_file_validate
        move.l %d1,(%a2)
        move.l (%sp)+,%a2
        rts
fl_io_core_pack:
        move.l 4(%sp),%d0
        move.l 8(%sp),%d1
        move.l 12(%sp),%a1
        jmp fl_file_pack:l
fl_io_core_publish:
        move.l 4(%sp),%d0
        move.l 8(%sp),%d1
        move.l 12(%sp),%a0
        bra fl_bank_publish
fl_io_core_seal:
        move.l 4(%sp),%d0
        move.l 8(%sp),%d1
        move.l 12(%sp),%a1
        bra fl_file_seal
fl_io_fs_open:
        jmp 0x40016864:l
fl_io_fs_read:
        jmp 0x40016564:l
fl_io_fs_write:
        jmp 0x400166b8:l
fl_io_fs_close:
        jmp 0x4001677c:l
fl_io_fs_size:
        move.l 0x46c8241e:l,%a0
        jmp (%a0)
fl_io_fs_copy:
        jmp 0x40016388:l
fl_io_fs_remove:
        move.l 0x46c82432:l,%a0
        jmp (%a0)
fl_io_stock_directory:
        jmp 0x40025230:l
fl_io_stock_card_ready:
        jmp 0x400255ec:l
fl_io_queue_post:
        jmp 0x40000c3c:l
fl_io_post:
        jmp 0x40084110:l
fl_io_toast:
        jmp 0x4005a2b8:l
fl_io_irq_lock:
        moveq #0,%d0
        move.w %sr,%d0
        move.w #0x2700,%sr
        rts
fl_io_irq_restore:
        move.l 4(%sp),%d0
        move.w %d0,%sr
        rts
| Displaced dispatcher switch prefix; a2 remains the stable stock job.
fl_io_dispatch:
        lea -16(%sp),%sp
        movem.l %d0-%d1/%a0-%a1,(%sp)
        move.l %a2,-(%sp)
        bsr fl_io_before_job
        addq.l #4,%sp
        tst.l %d0
        bpl fl_io_dispatch_resume
        move.l %d0,-(%sp)
        move.l %a2,-(%sp)
        bsr fl_io_reject_job
        addq.l #8,%sp
        movem.l (%sp),%d0-%d1/%a0-%a1
        lea 16(%sp),%sp
        jmp 0x4008484e:l
fl_io_dispatch_resume:
        movem.l (%sp),%d0-%d1/%a0-%a1
        lea 16(%sp),%sp
        .if HAVE_SYDRUM
        jmp sl_io_dispatch:l
        .else
        mvz.b (%a2),%d0
        moveq #45,%d1
        cmp.l %d0,%d1
        jmp 0x40084864:l
        .endif
| Existing UI timer schedules stock engine job2 when FM locks alone are dirty.
| No filesystem call, core call, allocation, or new queue descriptor here.
fl_io_background_request:
        and.l %d1,%d0
        bne fl_io_background_yes
        move.l %d1,-(%sp)
        move.l fl_dirty_mask:l,%d0
        and.l fl_ready_mask:l,%d0
        move.l fl_blocked_mask:l,%d1
        or.l fl_io_protected_mask:l,%d1
        not.l %d1
        and.l %d1,%d0
        tst.l %d0
        bne fl_io_background_some
fl_io_background_some:
        move.l (%sp)+,%d1
        tst.l %d0
        beq fl_io_background_no
fl_io_background_yes:
        moveq #1,%d0
        jmp 0x40022c1c:l
fl_io_background_no:
        .if HAVE_SYDRUM
        jmp sl_io_background_request:l
        .else
        jmp 0x40022c70:l
        .endif
| The UI tick's transport test (0x4005224a; d0 = the sequencer state 0x800065b8): stopped
| (0) or 2 continue to stock's background save counter; otherwise stock clears that counter
| (0x40052278) and the lock files get their own flush (fl_io_play_tick).
fl_io_tick_hook:
        .if FL_PACKAGE || FL_POOL_LANES < FL_LANES
| (2.23) a smaller pool or a package: fl_io_ui_tick in both states (playing = neither 0 nor 2),
| then the transport test as stock makes it.
        lea -16(%sp),%sp
        movem.l %d0-%d1/%a0-%a1,(%sp)
        moveq #1,%d1
        tst.l %d0
        bne fl_io_tick_run
        moveq #0,%d1
fl_io_tick_run:
        moveq #2,%d0
        cmp.l (%sp),%d0
        bne fl_io_tick_arg
        moveq #0,%d1
fl_io_tick_arg:
        move.l %d1,-(%sp)
        bsr fl_io_ui_tick
        addq.l #4,%sp
        movem.l (%sp),%d0-%d1/%a0-%a1
        lea 16(%sp),%sp
        tst.l %d0
        beq fl_io_tick_stock
        moveq #2,%d1
        cmp.l %d0,%d1
        beq fl_io_tick_stock
        .if HAVE_SYDRUM
        jmp sl_io_tick_hook:l
        .else
        jmp 0x40052278:l
        .endif
        .endif
        tst.l %d0
        beq fl_io_tick_stock
        moveq #2,%d1
        cmp.l %d0,%d1
        beq fl_io_tick_stock
        lea -16(%sp),%sp
        movem.l %d0-%d1/%a0-%a1,(%sp)
        bsr fl_io_play_tick
        movem.l (%sp),%d0-%d1/%a0-%a1
        lea 16(%sp),%sp
        .if HAVE_SYDRUM
        jmp sl_io_tick_hook:l
        .else
        jmp 0x40052278:l
        .endif
fl_io_tick_stock:
        .if HAVE_SYDRUM
        jmp sl_io_tick_hook:l
        .else
        jmp 0x40052254:l
        .endif

fl_io_stock_banks_load:
.if HAVE_SYDRUM
jmp sl_io_banks_load:l
.else
lea -328(%sp),%sp
movem.l %d2-%d7/%a2-%a6,(%sp)
jmp 0x400905dc:l
.endif

fl_io_stock_banks_save:
.if HAVE_SYDRUM
jmp sl_io_banks_save:l
.else
link.w %a6,#-324
movem.l %d2-%d7/%a2-%a5,(%sp)
jmp 0x400917d0:l
.endif

fl_io_stock_card_sync:
.if HAVE_SYDRUM
jmp sl_io_card_sync:l
.else
lea -12(%sp),%sp
movem.l %d2-%d4,(%sp)
jmp 0x400919ec:l
.endif

fl_io_stock_project_store:
.if HAVE_SYDRUM
jmp sl_io_project_store:l
.else
link.w %a6,#-560
movem.l %d2-%d7/%a2-%a5,(%sp)
jmp 0x4008ee7c:l
.endif

fl_io_stock_project_restore:
.if HAVE_SYDRUM
jmp sl_io_project_restore:l
.else
link.w %a6,#-560
movem.l %d2-%d7/%a2-%a5,(%sp)
jmp 0x4008f188:l
.endif

fl_io_stock_bank_store:
.if HAVE_SYDRUM
jmp sl_io_bank_store:l
.else
lea -564(%sp),%sp
movem.l %d2-%d7/%a2-%a6,(%sp)
jmp 0x4008edac:l
.endif

fl_io_stock_bank_restore:
.if HAVE_SYDRUM
jmp sl_io_bank_restore:l
.else
lea -564(%sp),%sp
movem.l %d2-%d7/%a2-%a6,(%sp)
jmp 0x4008f0b8:l
.endif

fl_io_stock_export:
.if HAVE_SYDRUM
jmp sl_io_export:l
.else
lea -104(%sp),%sp
movem.l %d2-%d7/%a2-%a5,(%sp)
jmp 0x400912cc:l
.endif

fl_io_stock_clear:
.if HAVE_SYDRUM
jmp sl_io_clear:l
.else
move.l %a2,-(%sp)
clr.l -(%sp)
jsr 0x4000fd34:l
jmp 0x400909e2:l
.endif

fl_io_stock_delete:
.if HAVE_SYDRUM
jmp sl_io_delete:l
.else
lea -324(%sp),%sp
movem.l %d2-%d5/%a2-%a3,(%sp)
jmp 0x4008ec54:l
.endif

.section .text
