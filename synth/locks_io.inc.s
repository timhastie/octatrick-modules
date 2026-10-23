| GENERATED from tools/locks_io.c; do not edit.
| Run python3 synth/tools/gen_locks_io.py (m68k-elf-gcc on PATH)
| Source SHA256 (the .c and migration_io.h) 0fdd8ae25f655214933494627ec761e184ed33b0fde6a11404d19c3d715f29de
#NO_APP
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"FM LOCKS RECOVERED"
.LC1:
	.string	"FM LOCK FILE ERROR"
	.text
	.align	2
	.globl	fl_io_ui_warning
	.type	fl_io_ui_warning, @function
fl_io_ui_warning:
	mov3q.l #1,%d0
	cmp.l 4(%sp),%d0
	jeq .L6
	move.l #.LC1,%d0
	pea 48.w
	move.l %d0,-(%sp)
	jsr fl_io_toast
	addq.l #8,%sp
	rts
.L6:
	move.l #.LC0,%d0
	pea 48.w
	move.l %d0,-(%sp)
	jsr fl_io_toast
	addq.l #8,%sp
	rts
	.size	fl_io_ui_warning, .-fl_io_ui_warning
	.align	2
	.type	snapshot, @function
snapshot:
	lea (-24,%sp),%sp
	movem.l #7196,(%sp)
	move.l 28(%sp),%d2
	mov3q.l #3,%d4
	lea fl_generation,%a2
	lea fl_io_core_bank,%a4
	lea fl_io_core_pack,%a3
.L12:
	move.l (%a2,%d2.l*4),%d3
	move.l %d2,-(%sp)
	jsr (%a4)
	pea fl_io_file
	move.l %d0,-(%sp)
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L13
	subq.l #1,%d4
	cmp.l (%a2,%d2.l*4),%d3
	jeq .L19
	tst.l %d4
	jne .L12
	movem.l (%sp),#7196
	moveq #-62,%d0
	lea (24,%sp),%sp
	rts
.L13:
	movem.l (%sp),#7196
	moveq #-60,%d0
	lea (24,%sp),%sp
	rts
.L19:
	lea fl_io_file+32,%a1
	clr.l %d1
	lea fl_io_file+18464,%a0
.L10:
	move.b (%a1)+,%d0
	not.l %d0
	mvz.b %d0,%d0
	or.l %d0,%d1
	cmp.l #fl_io_file+18464,%a1
	jne .L10
	lea fl_io_file+18624,%a1
.L11:
	mvz.b (%a0)+,%d0
	or.l %d0,%d1
	cmp.l %a1,%a0
	jne .L11
	tst.l %d1
	sne %d1
	move.l 32(%sp),%a0
	clr.l %d0
	move.l %d3,(%a0)
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
	jsr fl_io_core_bank
	addq.l #4,%sp
	move.l %d0,%a0
	add.l #131072,%d0
.L21:
	move.b #-1,(%a0)+
	cmp.l %a0,%d0
	jne .L21
	mvz.w %d2,%d0
	moveq #11,%d1
	lsl.l %d1,%d0
	move.l %d0,%a0
	add.l #fl_scene_table+2048,%d0
	add.l #fl_scene_table,%a0
.L22:
	move.b #-1,(%a0)+
	cmp.l %a0,%d0
	jne .L22
	move.w %d2,%d0
	mulu.w #160,%d0
	move.l %d0,%a0
	add.l #fl_migration_table+160,%d0
	add.l #fl_migration_table,%a0
.L23:
	clr.b (%a0)+
	cmp.l %a0,%d0
	jne .L23
	jsr fl_io_irq_lock
	mov3q.l #1,%d1
	lsl.l %d2,%d1
	lea fl_generation,%a0
	clr.l (%a0,%d2.l*4)
	move.l %d0,8(%sp)
	move.l (%sp)+,%d2
	or.l %d1,fl_ready_mask
	not.l %d1
	and.l %d1,fl_dirty_mask
	and.l %d1,fl_blocked_mask
	jra fl_io_irq_restore
	.size	fresh_bank, .-fresh_bank
	.section	.rodata.str1.1
.LC2:
	.string	"fmlock"
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
	jeq .L32
.L30:
	move.b %d1,(%a2,%d0.l)
	move.l %d0,%a0
	addq.l #1,%d0
	move.b (%a1,%d0.l),%d1
	jeq .L51
	cmp.l #245,%d0
	jne .L30
.L32:
	movem.l (%sp),#3076
	moveq #-63,%d0
	lea (12,%sp),%sp
	rts
.L51:
	moveq #47,%d1
	lea 2(%a2,%a0.l),%a3
	lea .LC2,%a1
	move.b %d1,(%a2,%d0.l)
	moveq #102,%d0
.L34:
	move.b %d0,(%a3)+
	addq.l #1,%a1
	move.b (%a1),%d0
	cmp.l #.LC2+6,%a1
	jne .L34
	move.l %d2,%d0
	moveq #9,%d1
	lea 8(%a2,%a0.l),%a1
	addq.l #1,%d0
	cmp.l %d0,%d1
	jcc .L35
	moveq #49,%d1
	add.l #38,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jne .L37
.L52:
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l #.LC4,%d2
	move.l %d2,%a1
.L39:
	move.b %d0,(%a3)+
	move.b 1(%a1),%d0
	addq.l #1,%a1
	tst.b %d0
	jne .L39
	lea 10(%a1,%a0.l),%a0
	clr.l %d0
	move.l %a0,%d1
	sub.l %d2,%d1
	clr.b %d2
	move.b %d2,(%a2,%d1.l)
	movem.l (%sp),#3076
	lea (12,%sp),%sp
	rts
.L35:
	moveq #48,%d1
	move.l %d2,%d0
	add.l #49,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jeq .L52
.L37:
	move.l #.LC3,%d2
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l %d2,%a1
	jra .L39
	.size	path_for.part.0, .-path_for.part.0
	.section	.rodata.str1.1
.LC5:
	.string	"r"
.LC6:
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
	jne .L78
	pea 512.w
	pea fl_io_sector
	pea .LC5
	pea fl_io_path
	pea fl_io_object
	jsr fl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L88
	lea fl_io_object,%a0
	move.l (%a0),-(%sp)
	move.l %a0,8(%sp)
	jsr fl_io_fs_size
	addq.l #4,%sp
	move.l %d0,%d1
	move.l 4(%sp),%a0
	tst.l %d0
	jge .L89
	move.l %a0,-(%sp)
	move.l %d0,8(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l 4(%sp),%d1
.L53:
	move.l (%sp)+,%d2
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L89:
	moveq #32,%d2
	cmp.l %d0,%d2
	jcs .L90
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
	jeq .L91
.L58:
	tst.l %a0
	jlt .L92
.L82:
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
.L84:
	move.l (%sp)+,%d2
	moveq #-60,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L88:
	moveq #-12,%d0
	cmp.l %d1,%d0
	jeq .L79
	moveq #-10,%d2
	cmp.l %d1,%d2
	jeq .L84
	move.l (%sp)+,%d2
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L90:
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
	jne .L58
.L91:
	lea .LC6,%a0
	clr.l %d0
.L59:
	lea fl_io_file,%a1
	addq.l #1,%a0
	mvz.b (%a1,%d0.l),%d2
	addq.l #1,%d0
	move.l %d2,8(%sp)
	mvz.b -1(%a0),%d2
	cmp.l 8(%sp),%d2
	jne .L93
	moveq #8,%d2
	cmp.l %d0,%d2
	jne .L59
	moveq #9,%d2
	cmp.l %d1,%d2
	jcc .L82
	tst.b fl_io_file+8.l
	jne .L71
	mvz.b fl_io_file+9,%d0
	subq.l #1,%d0
	tst.l %d0
	jeq .L94
.L71:
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
.L66:
	move.l (%sp)+,%d2
	moveq #-61,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L92:
	pea fl_io_object
	move.l %a0,8(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l 4(%sp),%d1
	move.l %d1,%d0
	move.l (%sp)+,%d2
	addq.l #8,%sp
	rts
.L79:
	move.l (%sp)+,%d2
	mov3q.l #1,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L94:
	moveq #15,%d0
	cmp.l %d1,%d0
	jcc .L82
	tst.b fl_io_file+10.l
	jne .L71
	mvz.b fl_io_file+11,%d0
	moveq #32,%d2
	cmp.l %d0,%d2
	jne .L71
	move.b fl_io_file+15,%d2
	move.b fl_io_file+14,%d0
	move.w %d2,%a0
	move.l %a0,%d2
	or.l %d2,%d0
	tst.b %d0
	jne .L71
.L70:
	cmp.l #18624,%d1
	jne .L82
	pea 18592.w
	pea fl_io_file+32
	pea fl_io_object
	jsr fl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L95
	tst.l %d1
	jge .L82
	pea fl_io_object
	move.l %d1,8(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l 4(%sp),%d1
	move.l %d1,%d0
	move.l (%sp)+,%d2
	addq.l #8,%sp
	rts
.L95:
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L53
	move.l 28(%sp),-(%sp)
	pea 18624.w
	pea fl_io_file
	move.l 32(%sp),-(%sp)
	jsr fl_io_core_validate
	lea (16,%sp),%sp
	moveq #-2,%d1
	cmp.l %d0,%d1
	jeq .L66
	add.l %d0,%d0
	subx.l %d0,%d0
	moveq #-60,%d1
	move.l (%sp)+,%d2
	and.l %d0,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
.L93:
	moveq #9,%d0
	cmp.l %d1,%d0
	jcc .L82
	moveq #15,%d2
	cmp.l %d1,%d2
	jcs .L70
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	jra .L84
.L78:
	move.l (%sp)+,%d2
	moveq #-63,%d1
	move.l %d1,%d0
	addq.l #8,%sp
	rts
	.size	read_bank, .-read_bank
	.section	.rodata.str1.1
.LC7:
	.string	"/project.work"
.LC8:
	.string	"/project.strd"
	.text
	.align	2
	.type	fl_mig_path.constprop.0, @function
fl_mig_path.constprop.0:
	move.l %a2,-(%sp)
	tst.l 8(%sp)
	jeq .L105
	lea .LC8,%a1
.L97:
	lea fl_io_base,%a0
	move.b (%a0),%d1
	jeq .L115
	clr.l %d0
	lea fl_io_path,%a2
.L103:
	move.b %d1,(%a2,%d0.l)
	addq.l #1,%d0
	move.b (%a0,%d0.l),%d1
	jeq .L116
	cmp.l #245,%d0
	jne .L103
	move.l (%sp)+,%a2
	moveq #-63,%d0
	rts
.L116:
	move.b (%a1),%d1
	jeq .L100
	lea (%a2,%d0.l),%a0
	addq.l #1,%a1
.L101:
	move.b %d1,(%a0)
	move.b (%a1)+,%d1
	move.l %a0,%d0
	addq.l #1,%a0
	tst.b %d1
	jne .L101
	sub.l #fl_io_path-1,%d0
.L100:
	clr.b %d1
	move.b %d1,(%a2,%d0.l)
	clr.l %d0
	move.l (%sp)+,%a2
	rts
.L105:
	lea .LC7,%a1
	jra .L97
.L115:
	move.b (%a1),%d1
	clr.l %d0
	lea fl_io_path,%a2
	addq.l #1,%a1
	lea (%a2,%d0.l),%a0
	jra .L101
	.size	fl_mig_path.constprop.0, .-fl_mig_path.constprop.0
	.align	2
	.type	fl_mig_text_read.constprop.0, @function
fl_mig_text_read.constprop.0:
	lea (-24,%sp),%sp
	movem.l #3100,(%sp)
	move.l 32(%sp),%a2
	move.l 28(%sp),-(%sp)
	move.l 40(%sp),%a0
	clr.l (%a2)
	clr.l (%a0)
	jsr (fl_mig_path.constprop.0)
	addq.l #4,%sp
	move.l %d0,%d3
	tst.l %d0
	jne .L118
	pea 512.w
	pea fl_io_sector
	pea .LC5
	pea fl_io_path
	pea fl_io_object
	jsr fl_io_fs_open
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L152
	lea fl_io_object,%a3
	move.l (%a3),-(%sp)
	jsr fl_io_fs_size
	addq.l #4,%sp
	move.l %d0,%d2
	tst.l %d0
	jlt .L153
	cmp.l #262122,%d0
	jls .L154
	move.l %a3,-(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
.L118:
	moveq #-63,%d3
.L117:
	move.l %d3,%d0
	movem.l (%sp),#3100
	lea (24,%sp),%sp
	rts
.L153:
	move.l %a3,-(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l %d2,%d3
	move.l %d3,%d0
	movem.l (%sp),#3100
	lea (24,%sp),%sp
	rts
.L152:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jeq .L136
.L137:
	move.l %d0,%d3
	move.l %d3,%d0
	movem.l (%sp),#3100
	lea (24,%sp),%sp
	rts
.L136:
	mov3q.l #1,%d3
	move.l %d3,%d0
	movem.l (%sp),#3100
	lea (24,%sp),%sp
	rts
.L154:
	move.l %d0,-(%sp)
	pea fl_migration_text
	move.l %a3,-(%sp)
	jsr fl_io_fs_read
	lea (12,%sp),%sp
	mov3q.l #1,%d4
	cmp.l %d0,%d4
	jeq .L123
	tst.l %d0
	jlt .L124
	move.l %a3,-(%sp)
	moveq #-60,%d3
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l %d3,%d0
	movem.l (%sp),#3100
	lea (24,%sp),%sp
	rts
.L123:
	move.l %a3,-(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	tst.l %d0
	jlt .L137
	move.l %d2,(%a2)
	tst.l %d2
	jeq .L117
	moveq #35,%d1
	sub.l %a1,%a1
	lea fl_migration_text,%a2
	sub.l %a0,%a0
	lea fl_mig_line,%a3
.L129:
	move.l %a0,%d0
	add.l %a1,%d0
	mvz.b %d1,%d1
	cmp.l %d2,%d0
	jcc .L128
	mvz.b (%a2,%a0.l),%d0
	addq.l #1,%a0
	cmp.l %d0,%d1
	jne .L128
	move.b (%a3,%a0.l),%d1
	moveq #13,%d4
	mvs.b %d1,%d0
	cmp.l %d0,%d4
	jne .L129
	move.l %a0,%d0
	add.l %a1,%d0
	cmp.l %d2,%d0
	jeq .L133
	lea fl_migration_text,%a0
	moveq #13,%d1
	mvz.b (%a0,%d0.l),%d0
	cmp.l %d0,%d1
	jeq .L133
	moveq #10,%d4
	cmp.l %d0,%d4
	jeq .L133
.L128:
	addq.l #1,%a1
	cmp.l %d2,%a1
	jeq .L117
	mvz.b (%a2)+,%d0
	moveq #10,%d1
	cmp.l %d0,%d1
	jne .L128
	moveq #35,%d1
	sub.l %a0,%a0
	jra .L129
.L133:
	move.l %d3,%d0
	movem.l (%sp),#3100
	move.l 36(%sp),%a0
	mov3q.l #1,(%a0)
	lea (24,%sp),%sp
	rts
.L124:
	move.l %a3,-(%sp)
	move.l %d0,24(%sp)
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l 20(%sp),%d3
	move.l %d3,%d0
	movem.l (%sp),#3100
	lea (24,%sp),%sp
	rts
	.size	fl_mig_text_read.constprop.0, .-fl_mig_text_read.constprop.0
	.section	.rodata.str1.1
.LC9:
	.string	"w"
	.text
	.align	2
	.type	fl_mig_comment.constprop.0, @function
fl_mig_comment.constprop.0:
	link.w %fp,#-16
	pea -4(%fp)
	pea -8(%fp)
	move.l 8(%fp),-(%sp)
	jsr (fl_mig_text_read.constprop.0)
	lea (12,%sp),%sp
	move.l %d0,-16(%fp)
	tst.l %d0
	jne .L155
	tst.l -4(%fp)
	jne .L155
	move.l -8(%fp),%a0
	lea fl_migration_text,%a1
	tst.l %a0
	jeq .L161
	mvz.b -1(%a1,%a0.l),%d0
	moveq #10,%d1
	cmp.l %d0,%d1
	jeq .L161
	moveq #10,%d0
	move.b %d0,(%a1,%a0.l)
	addq.l #1,%a0
.L161:
	moveq #35,%d0
	add.l %a1,%a0
	lea fl_mig_line+1,%a1
.L162:
	move.b %d0,(%a0)
	move.b (%a1)+,%d0
	move.l %a0,%d1
	addq.l #1,%a0
	tst.b %d0
	jne .L162
	move.l 8(%fp),-(%sp)
	move.l %d1,-12(%fp)
	jsr (fl_mig_path.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jne .L166
	pea 512.w
	pea fl_io_sector
	pea .LC9
	pea fl_io_path
	pea fl_io_object
	jsr fl_io_fs_open
	lea (20,%sp),%sp
	move.l -12(%fp),%d1
	move.l %d0,-16(%fp)
	tst.l %d0
	jlt .L155
	sub.l #fl_migration_text-1,%d1
	move.l %d1,-(%sp)
	pea fl_migration_text
	pea fl_io_object
	jsr fl_io_fs_write
	lea (12,%sp),%sp
	move.l %d0,-16(%fp)
	subq.l #1,%d0
	tst.l %d0
	jeq .L173
	tst.l -16(%fp)
	jlt .L165
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	moveq #-60,%d1
	move.l %d1,-16(%fp)
.L155:
	move.l -16(%fp),%d0
	unlk %fp
	rts
.L173:
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l %d0,-16(%fp)
	tst.l %d0
	jle .L155
	clr.l -16(%fp)
	move.l -16(%fp),%d0
	unlk %fp
	rts
.L165:
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l -16(%fp),%d0
	unlk %fp
	rts
.L166:
	moveq #-63,%d1
	move.l %d1,-16(%fp)
	move.l -16(%fp),%d0
	unlk %fp
	rts
	.size	fl_mig_comment.constprop.0, .-fl_mig_comment.constprop.0
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
	jne .L179
	pea 512.w
	pea fl_io_sector
	pea .LC9
	pea fl_io_path
	pea fl_io_object
	jsr fl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L174
	pea 18624.w
	pea fl_io_file
	pea fl_io_object
	jsr fl_io_fs_write
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L182
	tst.l %d1
	jlt .L178
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	moveq #-60,%d1
.L174:
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L182:
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jle .L174
	clr.l %d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L178:
	pea fl_io_object
	move.l %d1,4(%sp)
	jsr fl_io_fs_close
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
	jne .L184
	move.l fl_ready_mask,%d0
	and.l %d4,%d0
	cmp.l %d0,%d4
	jne .L184
	move.l %sp,%d6
	move.l %sp,%d5
	add.l #44,%d6
	add.l #40,%d5
	lea snapshot,%a6
	lea fl_io_irq_lock,%a4
	lea fl_generation,%a3
	lea fl_io_irq_restore,%a2
.L185:
	mov3q.l #1,%d2
	lsl.l %d3,%d2
	move.l %d4,%d0
	and.l %d2,%d0
	tst.l %d0
	jne .L200
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L185
.L202:
	clr.l %d0
.L183:
	movem.l (%sp),#31868
	lea (48,%sp),%sp
	rts
.L200:
	move.l %d6,-(%sp)
	move.l %d5,-(%sp)
	move.l %d3,-(%sp)
	jsr (%a6)
	lea (12,%sp),%sp
	tst.l %d0
	jne .L183
	move.l %d2,%d0
	and.l fl_present_mask,%d0
	or.l 44(%sp),%d0
	jeq .L188
	clr.l -(%sp)
	move.l %d3,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jne .L183
	mov3q.l #1,-(%sp)
	move.l %d3,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jne .L183
	or.l %d2,fl_present_mask
.L188:
	move.l 40(%sp),%a5
	not.l %d2
	jsr (%a4)
	cmp.l (%a3,%d3.l*4),%a5
	jeq .L201
	move.l %d0,-(%sp)
	jsr (%a2)
	and.l %d2,fl_io_protected_mask
	addq.l #4,%sp
.L203:
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L185
	jra .L202
.L201:
	move.l %d0,-(%sp)
	and.l %d2,fl_dirty_mask
	jsr (%a2)
	and.l %d2,fl_io_protected_mask
	addq.l #4,%sp
	jra .L203
.L184:
	movem.l (%sp),#31868
	moveq #-61,%d0
	lea (48,%sp),%sp
	rts
	.size	store_ab, .-store_ab
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
.L209:
	mov3q.l #1,%d2
	lsl.l %d3,%d2
	move.l %d4,%d0
	and.l %d2,%d0
	tst.l %d0
	jne .L219
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L209
.L221:
	clr.l %d0
.L204:
	movem.l (%sp),#23804
	lea (48,%sp),%sp
	rts
.L219:
	move.l %d6,-(%sp)
	move.l %d5,-(%sp)
	move.l %d3,-(%sp)
	jsr (%a6)
	lea (12,%sp),%sp
	tst.l %d0
	jne .L204
	move.l %d2,%d0
	and.l fl_present_mask,%d0
	or.l 44(%sp),%d0
	jeq .L207
	clr.l -(%sp)
	move.l %d3,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jne .L204
	or.l %d2,fl_present_mask
.L207:
	move.l 40(%sp),%d7
	not.l %d2
	jsr (%a4)
	cmp.l (%a3,%d3.l*4),%d7
	jeq .L220
	move.l %d0,-(%sp)
	jsr (%a2)
	and.l %d2,fl_io_protected_mask
	addq.l #4,%sp
.L222:
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L209
	jra .L221
.L220:
	move.l %d0,-(%sp)
	and.l %d2,fl_dirty_mask
	jsr (%a2)
	and.l %d2,fl_io_protected_mask
	addq.l #4,%sp
	jra .L222
	.size	flush_ab.constprop.0, .-flush_ab.constprop.0
	.align	2
	.type	restore_mask, @function
restore_mask:
	lea (-36,%sp),%sp
	movem.l #19580,(%sp)
	move.l 40(%sp),%d5
	clr.l %d2
	lea read_bank,%a6
	lea (write_buffer.constprop.0),%a2
	lea fl_io_core_publish,%a3
.L229:
	mov3q.l #1,%d3
	lsl.l %d2,%d3
	move.l %d3,%d0
	and.l %d5,%d0
	tst.l %d0
	jne .L237
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L229
.L239:
	clr.l %d0
.L223:
	movem.l (%sp),#19580
	lea (36,%sp),%sp
	rts
.L237:
	pea 32(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	jsr (%a6)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L238
	tst.l %d0
	jne .L223
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr (%a2)
	addq.l #8,%sp
	tst.l %d0
	jne .L223
	or.l %d3,fl_blocked_mask
	pea fl_io_file+32
	move.l 36(%sp),-(%sp)
	move.l %d2,-(%sp)
	move.l %d3,%d6
	not.l %d6
	and.l %d6,fl_ready_mask
	jsr (%a3)
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L230
	or.l fl_present_mask,%d3
	and.l %d6,fl_io_protected_mask
	move.l %d3,fl_present_mask
.L240:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L229
	jra .L239
.L238:
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	pea fl_io_path
	jsr (path_for.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L226
	pea fl_io_path
	jsr fl_io_fs_remove
	addq.l #4,%sp
	tst.l %d0
	jge .L226
	moveq #-12,%d1
	cmp.l %d0,%d1
	jne .L223
.L226:
	move.l %d2,-(%sp)
	move.l %d3,%d6
	not.l %d6
	jsr fresh_bank
	move.l %d6,%d3
	addq.l #4,%sp
	and.l fl_present_mask,%d3
	and.l %d6,fl_io_protected_mask
	move.l %d3,fl_present_mask
	jra .L240
.L230:
	movem.l (%sp),#19580
	moveq #-60,%d0
	lea (36,%sp),%sp
	rts
	.size	restore_mask, .-restore_mask
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
.L246:
	tst.l %d6
	jne .L254
	move.l 48(%sp),%a5
	add.l %d5,%a5
	move.l %a5,%d1
	clr.l %d0
	lea (60,%a5),%a1
	add.l #1634,%d1
	lea (282,%a5),%a3
	move.l %d3,%a2
	lea (34,%a5),%a5
.L245:
	mvz.b (%a4),%d2
	btst %d0,%d2
	jne .L272
.L243:
	addq.l #1,%d0
	lea (30,%a1),%a1
	addq.l #2,%a2
	add.l #32,%d1
	lea (24,%a3),%a3
	moveq #8,%d2
	cmp.l %d0,%d2
	jne .L245
	add.l #16,%d3
	addq.l #1,%a4
	add.l #6322,%d5
	addq.l #8,%d4
	moveq #64,%d7
	cmp.l %d4,%d7
	jne .L246
	move.l #-36350,%d4
	sub.l 60(%sp),%d4
	move.l 60(%sp),%a2
	add.l #36439,%a2
	move.l 60(%sp),%d3
	add.l #621527,%d3
	move.l 60(%sp),%d5
	add.l #585088,%d5
.L253:
	move.b (%a2),%d0
	mov3q.l #3,%d2
	mvz.b %d0,%d1
	cmp.l %d1,%d2
	jcc .L273
.L247:
	add.l #36568,%a2
	cmp.l %a2,%d3
	jne .L253
	movem.l (%sp),#31996
	lea (52,%sp),%sp
	rts
.L272:
	mvz.b (%a5,%d0.l),%d2
	subq.l #1,%d2
	tst.l %d2
	jne .L243
	mvz.b (%a1),%d2
	moveq #70,%d7
	cmp.l %d2,%d7
	jne .L243
	mvz.b 1(%a1),%d2
	moveq #77,%d7
	cmp.l %d2,%d7
	jne .L243
	mvz.b 2(%a1),%d2
	subq.l #1,%d2
	tst.l %d2
	jne .L243
	move.b (%a2),420(%a1)
	move.l %d1,%d2
	move.l %d1,%a0
	add.l #4096,%d2
	move.b 1(%a2),421(%a1)
	move.b 46(%sp),2(%a3)
	move.b 47(%sp),5(%a3)
.L244:
	st %d7
	lea (256,%a0),%a0
	move.b %d7,-248(%a0)
	move.b %d7,-245(%a0)
	cmp.l %a0,%d2
	jeq .L243
	st %d7
	lea (256,%a0),%a0
	move.b %d7,-248(%a0)
	move.b %d7,-245(%a0)
	cmp.l %a0,%d2
	jne .L244
	jra .L243
.L273:
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
	jne .L274
.L248:
	addq.l #1,%d1
	lea (30,%a1),%a1
	add.l #2330,%d2
	moveq #8,%d0
	cmp.l %d1,%d0
	jeq .L247
	mvz.b (%a3),%d0
	btst %d1,%d0
	jeq .L248
.L274:
	mvz.b (%a4,%d1.l),%d0
	subq.l #1,%d0
	tst.l %d0
	jne .L248
	mvz.b (%a1),%d0
	moveq #70,%d7
	cmp.l %d0,%d7
	jne .L248
	mvz.b 1(%a1),%d0
	moveq #77,%d7
	cmp.l %d0,%d7
	jne .L248
	mvz.b 2(%a1),%d0
	subq.l #1,%d0
	tst.l %d0
	jne .L248
	btst #0,%d6
	jeq .L275
	move.l #268525902,%a0
	move.l %a0,%d0
	add.l #2048,%d0
	add.l %d2,%a0
	add.l %d2,%d0
.L251:
	st %d7
	lea (32,%a0),%a0
	move.b %d7,-24(%a0)
	move.b %d7,-21(%a0)
	cmp.l %d0,%a0
	jeq .L248
	st %d7
	lea (32,%a0),%a0
	move.b %d7,-24(%a0)
	move.b %d7,-21(%a0)
	cmp.l %d0,%a0
	jne .L251
	jra .L248
.L254:
	move.l %d5,%a5
	move.l %a5,%d1
	lea (60,%a5),%a1
	clr.l %d0
	lea (282,%a5),%a3
	add.l #1634,%d1
	move.l %d3,%a2
	lea (34,%a5),%a5
	jra .L245
.L275:
	move.l 60(%sp),%a0
	move.l %a0,%d0
	add.l #2048,%d0
	add.l %d2,%a0
	add.l %d2,%d0
	jra .L251
	.size	fl_mig_apply_to, .-fl_mig_apply_to
	.align	2
	.type	fl_mig_run, @function
fl_mig_run:
	lea (-88,%sp),%sp
	clr.l %d0
	movem.l #31996,(%sp)
	move.l 92(%sp),%d6
	move.l #1074668000,%d3
	move.l 96(%sp),%a4
	clr.l 76(%sp)
	lea fl_migration_table+3,%a2
.L295:
	mov3q.l #1,%d4
	lsl.l %d0,%d4
	move.l %d4,%d1
	and.l %d6,%d1
	tst.l %d1
	jeq .L278
	mvz.b 269161678,%d1
	cmp.l %d1,%d0
	jeq .L387
	move.l %d3,%d1
.L281:
	mvz.b (%a2),%d2
	mov3q.l #2,%d7
	cmp.l %d2,%d7
	jeq .L278
	subq.l #1,%d2
	tst.l %d2
	jeq .L291
	tst.l %a4
	jne .L388
.L278:
	addq.l #1,%d0
	add.l #635712,%d3
	lea (160,%a2),%a2
	moveq #16,%d1
	cmp.l %d0,%d1
	jne .L295
.L394:
	lea fl_scene_table,%a0
	move.l %a0,64(%sp)
	move.l #1074668000,%d1
	lea fl_migration_table,%a0
	clr.l 52(%sp)
	move.l %a0,56(%sp)
	move.l %d1,60(%sp)
.L318:
	move.l 52(%sp),%d3
	mov3q.l #1,%d2
	lsl.l %d3,%d2
	move.l %d2,%d0
	and.l 76(%sp),%d0
	move.l %d2,68(%sp)
	tst.l %d0
	jne .L389
.L296:
	mvz.w #160,%d6
	mvz.w #2048,%d7
	move.l #635712,%d3
	moveq #16,%d0
	addq.l #1,52(%sp)
	add.l %d3,60(%sp)
	add.l %d6,56(%sp)
	add.l %d7,64(%sp)
	cmp.l 52(%sp),%d0
	jne .L318
.L398:
	tst.l 76(%sp)
	jeq .L319
	tst.l fl_io_loaded
	jne .L320
.L322:
	move.l 76(%sp),%d3
	move.l #1074668000,%a2
	clr.l %d2
	move.l #635698,%a4
	lea fl_mig_apply_to,%a3
.L321:
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	and.l %d3,%d0
	tst.l %d0
	jeq .L323
	mvz.b 269161678,%d0
	cmp.l %d2,%d0
	jeq .L390
.L324:
	clr.l -(%sp)
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (12,%sp),%sp
	move.l %a2,%d5
.L326:
	mvz.b 269161678,%d0
	cmp.l %d0,%d2
	jeq .L391
.L329:
	mov3q.l #1,(%a2,%a4.l)
.L323:
	addq.l #1,%d2
	add.l #635712,%a2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L321
	move.l 76(%sp),%d2
	mov3q.l #1,fl_mig_active
	or.l %d2,fl_mig_pending
.L319:
	movem.l (%sp),#31996
	clr.l %d0
	lea (88,%sp),%sp
	rts
.L387:
	move.l 1187521622,%d1
	move.l %d1,%a0
	add.l #-1073741824,%a0
	cmp.l #134217727,%a0
	jls .L281
	move.l %d3,%d1
	jra .L281
.L388:
	move.l %d1,%d2
	add.l #585388,%d2
	move.l %d2,%a1
	move.l %d2,%a0
	move.l %d1,%a3
	add.l #629642,%a3
	lea (-266,%a1),%a1
	lea (-240,%a0),%a0
.L289:
	mvz.b (%a1),%d1
	addq.l #1,%a1
	subq.l #1,%d1
	tst.l %d1
	jeq .L392
.L287:
	lea (30,%a0),%a0
	cmp.l %a0,%d2
	jne .L289
	cmp.l %d2,%a3
	jeq .L278
	add.l #6322,%d2
	move.l %d2,%a1
	move.l %d2,%a0
	lea (-266,%a1),%a1
	lea (-240,%a0),%a0
	jra .L289
.L392:
	mvz.b (%a0),%d1
	moveq #70,%d7
	cmp.l %d1,%d7
	jne .L287
	mvz.b 1(%a0),%d1
	moveq #77,%d7
	cmp.l %d1,%d7
	jne .L287
	mvz.b 2(%a0),%d1
	subq.l #1,%d1
	tst.l %d1
	jne .L287
	cmp.l %d2,%a3
	jeq .L393
.L291:
	move.l %d4,%d1
	and.l fl_ready_mask,%d1
	tst.l %d1
	jeq .L284
	move.l %d4,%d1
	and.l fl_blocked_mask,%d1
	tst.l %d1
	jne .L284
	move.l %d4,%d1
	and.l fl_io_protected_mask,%d1
	tst.l %d1
	jne .L284
	or.l %d4,76(%sp)
	addq.l #1,%d0
	add.l #635712,%d3
	lea (160,%a2),%a2
	moveq #16,%d1
	cmp.l %d0,%d1
	jne .L295
	jra .L394
.L389:
	mvz.b 269161678,%d0
	cmp.l %d0,%d3
	jeq .L395
.L297:
	move.l 60(%sp),80(%sp)
.L299:
	move.l 52(%sp),-(%sp)
	jsr fl_io_core_bank
	move.l %d0,88(%sp)
	move.l 60(%sp),%a0
	addq.l #4,%sp
	tst.b 3(%a0)
	jne .L296
	move.l 64(%sp),%d1
	addq.l #1,%d1
	move.l %d1,48(%sp)
	move.w 54(%sp),%d1
	move.l 80(%sp),%d5
	move.l %a0,%d4
	move.l %a0,%d6
	add.l #585088,%d5
	addq.l #4,%d4
	clr.l %d0
	add.l #12,%d6
	mulu.w #160,%d1
	add.l #fl_migration_table+12,%d1
	move.l %d1,72(%sp)
.L309:
	move.l %d4,%a0
	move.l %d5,%a5
	clr.b (%a0)+
	move.l 48(%sp),%d2
	move.l %d5,%a4
	move.l %d5,%a6
	move.l %d5,%d1
	sub.l %a2,%a2
	add.l #5730,%d1
	lea (60,%a5),%a5
	lea (282,%a4),%a4
	move.l %d6,%a3
	lea (34,%a6),%a6
	move.l %a0,%d4
	move.l %d0,%a0
.L308:
	mvz.b (%a6,%a2.l),%d3
	subq.l #1,%d3
	tst.l %d3
	jeq .L396
.L302:
	addq.l #1,%a2
	add.l #32,%d1
	addq.l #2,%d2
	lea (30,%a5),%a5
	addq.l #2,%a3
	lea (24,%a4),%a4
	moveq #8,%d0
	cmp.l %a2,%d0
	jne .L308
.L399:
	mvz.w #256,%d1
	move.l %a0,%d0
	add.l #16,%d6
	add.l #6322,%d5
	add.l %d1,48(%sp)
	cmp.l 72(%sp),%d4
	jne .L309
	tst.l %a0
	jeq .L296
	move.l 80(%sp),%a5
	clr.l %d5
	moveq #89,%d4
	move.l 56(%sp),%a4
	move.l 84(%sp),%d6
	add.l #1024,%d6
	move.l 80(%sp),%a3
	add.l #36350,%a3
	move.l %d6,48(%sp)
.L317:
	mvz.b (%a3,%d4.l),%d0
	mov3q.l #3,%d2
	cmp.l %d0,%d2
	jcc .L397
.L310:
	mvz.w #8192,%d1
	add.l #36568,%d4
	addq.l #8,%d5
	add.l %d1,48(%sp)
	cmp.l #128,%d5
	jne .L317
	clr.b %d2
	moveq #1,%d0
	move.l 56(%sp),%a0
	move.l #635712,%d3
	mvz.w #160,%d6
	mvz.w #2048,%d7
	clr.b (%a0)
	move.b %d2,2(%a0)
	move.b %d2,1(%a0)
	move.b %d0,3(%a0)
	jsr fl_io_irq_lock
	move.l 52(%sp),%d2
	move.l 68(%sp),%d1
	lea fl_generation,%a0
	or.l %d1,fl_dirty_mask
	addq.l #1,(%a0,%d2.l*4)
	move.l %d0,-(%sp)
	jsr fl_io_irq_restore
	addq.l #4,%sp
	addq.l #1,52(%sp)
	add.l %d3,60(%sp)
	add.l %d6,56(%sp)
	add.l %d7,64(%sp)
	moveq #16,%d0
	cmp.l 52(%sp),%d0
	jne .L318
	jra .L398
.L396:
	mvz.b (%a5),%d3
	moveq #70,%d7
	cmp.l %d3,%d7
	jne .L302
	mvz.b 1(%a5),%d0
	moveq #77,%d3
	cmp.l %d0,%d3
	jne .L302
	move.b 2(%a5),%d3
	mov3q.l #1,%d7
	mvz.b %d3,%d0
	cmp.l %d0,%d7
	jne .L302
	move.l %d4,%a0
	move.b -1(%a0),%d7
	move.w %d7,%a1
	move.l %a2,%d7
	lsl.l %d7,%d0
	move.l %a1,%d7
	or.l %d7,%d0
	move.b %d0,-1(%a0)
	move.b 2(%a4),%d7
	move.l %d7,%d0
	subq.l #1,%d0
	mvz.b %d0,%d0
	move.l %d0,%a0
	mov3q.l #3,%d0
	cmp.l %a0,%d0
	jcc .L303
	move.b %d3,%d7
.L303:
	move.b %d7,(%a3)
	moveq #127,%d7
	move.l %d1,%a0
	move.l %d2,%a1
	lea (-4096,%a0),%a0
	move.l %d2,44(%sp)
	move.b 5(%a4),%d0
	and.l %d7,%d0
	move.b %d0,1(%a3)
.L307:
	mvz.b 8(%a0),%d0
	cmp.l #255,%d0
	jeq .L304
	move.b 8(%a0),%d0
	mov3q.l #3,%d2
	move.l %d0,%d7
	subq.l #1,%d7
	mvz.b %d7,%d7
	cmp.l %d7,%d2
	jcc .L305
	move.b %d3,%d0
.L305:
	move.b %d0,-1(%a1)
.L304:
	mvz.b 11(%a0),%d0
	cmp.l #255,%d0
	jeq .L306
	move.b 11(%a0),%d0
	moveq #127,%d7
	and.l %d7,%d0
	move.b %d0,(%a1)
.L306:
	lea (256,%a0),%a0
	lea (16,%a1),%a1
	cmp.l %a0,%d1
	jne .L307
	move.l 44(%sp),%d2
	mov3q.l #1,%a0
	addq.l #1,%a2
	add.l #32,%d1
	addq.l #2,%d2
	lea (30,%a5),%a5
	addq.l #2,%a3
	lea (24,%a4),%a4
	moveq #8,%d0
	cmp.l %a2,%d0
	jne .L308
	jra .L399
.L397:
	lea 4(%a4,%d0.l),%a2
	move.l 48(%sp),%d1
	move.l %d4,%d3
	clr.l %d2
	mvz.b (%a2),%d0
	btst %d2,%d0
	jne .L400
.L311:
	addq.l #1,%d2
	add.l #1024,%d1
	add.l #2330,%d3
	moveq #8,%d0
	cmp.l %d2,%d0
	jeq .L310
.L384:
	mvz.b (%a2),%d0
	btst %d2,%d0
	jeq .L311
.L400:
	move.l %d1,%a1
	lea (%a5,%d3.l),%a0
	lea (-1024,%a1),%a1
.L315:
	mvz.b 8(%a0),%d0
	cmp.l #255,%d0
	jeq .L312
	move.b 8(%a0),%d7
	mov3q.l #3,%d6
	move.l %d7,%d0
	subq.l #1,%d0
	mvz.b %d0,%d0
	cmp.l %d0,%d6
	jcc .L313
	moveq #1,%d7
.L313:
	move.b %d7,(%a1)
.L312:
	mvz.b 11(%a0),%d0
	cmp.l #255,%d0
	jeq .L314
	move.b 11(%a0),%d0
	moveq #127,%d7
	and.l %d7,%d0
	move.b %d0,1(%a1)
.L314:
	lea (32,%a0),%a0
	lea (16,%a1),%a1
	cmp.l %d1,%a1
	jne .L315
	addq.l #1,%d2
	add.l #1024,%d1
	add.l #2330,%d3
	moveq #8,%d0
	cmp.l %d2,%d0
	jne .L384
	jra .L310
.L395:
	move.l 1187521622,%d0
	move.l %d0,%d1
	add.l #-1073741824,%d1
	cmp.l #134217727,%d1
	jhi .L297
	move.l %d0,80(%sp)
	jra .L299
.L393:
	tst.l %a4
	jne .L291
	addq.l #1,%d0
	add.l #635712,%d3
	lea (160,%a2),%a2
	moveq #16,%d1
	cmp.l %d0,%d1
	jne .L295
	jra .L394
.L390:
	move.l 1187521622,%d0
	move.l %d0,%d5
	add.l #-1073741824,%d0
	cmp.l #134217727,%d0
	jhi .L324
	clr.l -(%sp)
	move.l %d5,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (12,%sp),%sp
	cmp.l %a2,%d5
	jeq .L326
	clr.l -(%sp)
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (12,%sp),%sp
	mvz.b 269161678,%d0
	cmp.l %d0,%d2
	jne .L329
.L391:
	mov3q.l #1,-(%sp)
	move.l %d5,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	mov3q.l #1,269452696
	lea (12,%sp),%sp
	mov3q.l #1,(%a2,%a4.l)
	jra .L323
.L320:
	move.l 76(%sp),-(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jeq .L322
	movem.l (%sp),#31996
	lea (88,%sp),%sp
	rts
.L284:
	movem.l (%sp),#31996
	moveq #-61,%d0
	lea (88,%sp),%sp
	rts
	.size	fl_mig_run, .-fl_mig_run
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
	jeq .L402
	move.l #1074668000,%d7
	lea fl_migration_table+3,%a4
	clr.l 60(%sp)
	move.l %d7,44(%sp)
	clr.l 48(%sp)
.L416:
	move.l 48(%sp),%d2
	mov3q.l #1,%d1
	lsl.l %d2,%d1
	move.l 52(%sp),%d0
	and.l %d1,%d0
	move.l %d1,56(%sp)
	tst.l %d0
	jne .L447
.L415:
	move.l #635712,%d2
	addq.l #1,48(%sp)
	lea (160,%a4),%a4
	add.l %d2,44(%sp)
	cmp.l #fl_migration_table+2563,%a4
	jne .L416
.L402:
	lea fl_migration_table+3,%a2
	clr.l %d2
	lea fl_io_irq_lock,%a5
	lea fl_generation,%a3
	lea fl_io_irq_restore,%a4
.L420:
	mov3q.l #1,%d3
	lsl.l %d2,%d3
	move.l 52(%sp),%d0
	and.l %d3,%d0
	tst.l %d0
	jeq .L418
	mvz.b (%a2),%d0
	subq.l #1,%d0
	tst.l %d0
	jeq .L448
.L418:
	addq.l #1,%d2
	lea (160,%a2),%a2
	cmp.l #fl_migration_table+2563,%a2
	jne .L420
.L452:
	tst.l 60(%sp)
	jeq .L421
	tst.l 64(%sp)
	jeq .L422
	tst.l fl_io_loaded
	jeq .L429
	move.l 60(%sp),-(%sp)
	jsr store_ab
	addq.l #4,%sp
	tst.l %d0
	jne .L401
.L421:
	move.l 52(%sp),%d0
	not.l %d0
	and.l fl_mig_pending,%d0
	move.l %d0,fl_mig_pending
	tst.l fl_mig_active
	jeq .L425
	tst.l %d0
	jeq .L426
.L425:
	clr.l %d0
.L401:
	movem.l (%sp),#31996
	lea (68,%sp),%sp
	rts
.L447:
	mvz.b 269161678,%d0
	move.l 44(%sp),%d4
	cmp.l %d2,%d0
	jeq .L449
.L405:
	tst.b (%a4)
	jne .L415
	add.l #585088,%d4
	lea (9,%a4),%a6
	clr.l %d6
	lea (1,%a4),%a2
	clr.l %d5
.L407:
	move.l %d4,%a0
	move.l %d4,%a3
	lea (481,%a0),%a0
	clr.l %d0
	move.l %a6,%a1
	lea (34,%a3),%a3
.L412:
	mvz.b (%a3,%d0.l),%d1
	subq.l #1,%d1
	tst.l %d1
	jeq .L450
.L410:
	addq.l #1,%d0
	addq.l #2,%a1
	lea (30,%a0),%a0
	moveq #8,%d3
	cmp.l %d0,%d3
	jne .L412
.L451:
	lea (16,%a6),%a6
	addq.l #1,%a2
	add.l #6322,%d4
	addq.l #8,%d6
	moveq #64,%d7
	cmp.l %d6,%d7
	jne .L407
	tst.l %d5
	jeq .L415
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
	jne .L416
	jra .L402
.L450:
	mvz.b -421(%a0),%d1
	move.l %a0,%d2
	moveq #70,%d7
	add.l #-421,%d2
	cmp.l %d1,%d7
	jne .L410
	move.l %d2,%a5
	moveq #77,%d3
	mvz.b 1(%a5),%d1
	cmp.l %d1,%d3
	jne .L410
	move.b 2(%a5),%d3
	mov3q.l #1,%d7
	mvz.b %d3,%d1
	cmp.l %d1,%d7
	jne .L410
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
	jcs .L411
	move.b %d1,%d3
.L411:
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
	jne .L412
	jra .L451
.L449:
	move.l 1187521622,%d0
	move.l %d0,%d1
	add.l #-1073741824,%d1
	cmp.l #134217727,%d1
	jhi .L405
	move.l %d0,%d4
	jra .L405
.L448:
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
	jne .L420
	jra .L452
.L426:
	clr.l -(%sp)
	jsr (fl_mig_comment.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jne .L401
	mov3q.l #1,%d1
	cmp.l 64(%sp),%d1
	jne .L401
	movem.l (%sp),#31996
	mov3q.l #1,72(%sp)
	lea (68,%sp),%sp
	jra (fl_mig_comment.constprop.0)
.L422:
	tst.l fl_io_loaded
	jeq .L421
	move.l 60(%sp),-(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jeq .L421
	jra .L401
.L429:
	movem.l (%sp),#31996
	moveq #-60,%d0
	lea (68,%sp),%sp
	rts
	.size	fl_migrate_saved.constprop.0, .-fl_migrate_saved.constprop.0
	.align	2
	.globl	fl_io_play_tick
	.type	fl_io_play_tick, @function
fl_io_play_tick:
	move.l %d2,-(%sp)
	tst.l fl_io_loaded
	jeq .L454
	move.l fl_dirty_mask,%d1
	move.l fl_ready_mask,%a0
	move.l %a0,%d2
	move.l fl_blocked_mask,%d0
	and.l %d2,%d1
	or.l fl_io_protected_mask,%d0
	not.l %d0
	and.l %d1,%d0
	tst.l %d0
	jeq .L454
	move.l fl_io_play_ticks,%d0
	moveq #59,%d1
	addq.l #1,%d0
	cmp.l %d0,%d1
	jcc .L466
	clr.l fl_io_play_ticks
	tst.l fl_io_flush_pending
	jne .L453
	tst.l 1175264744
	jne .L453
	mov3q.l #1,%d2
	cmp.l -2147483512.l,%d2
	jeq .L453
	tst.l 269452412
	jeq .L467
.L453:
	move.l (%sp)+,%d2
	rts
.L454:
	move.l (%sp)+,%d2
	clr.l fl_io_play_ticks
	rts
.L466:
	move.l (%sp)+,%d2
	move.l %d0,fl_io_play_ticks
	rts
.L467:
	jsr fl_io_stock_card_ready
	tst.l %d0
	jeq .L453
	moveq #-127,%d0
	pea fl_io_flush_job
	move.l #1175263182,-(%sp)
	mov3q.l #1,fl_io_flush_pending
	move.b %d0,fl_io_flush_job
	jsr fl_io_queue_post
	addq.l #8,%sp
	move.l (%sp)+,%d2
	rts
	.size	fl_io_play_tick, .-fl_io_play_tick
	.align	2
	.globl	fl_io_before_job
	.type	fl_io_before_job, @function
fl_io_before_job:
	subq.l #4,%sp
	move.l %d2,-(%sp)
	move.l 12(%sp),%a0
	move.b (%a0),%d1
	mvz.b %d1,%d0
	cmp.l #129,%d0
	jeq .L503
	move.l %d0,fl_io_job_kind
	mov3q.l #2,%d2
	cmp.l %d0,%d2
	jeq .L504
	clr.l fl_io_warning
	moveq #18,%d2
	cmp.l %d0,%d2
	jcs .L470
	move.l #401296,%d2
	btst %d0,%d2
	jeq .L470
	tst.l fl_io_loaded
	jne .L475
	moveq #8,%d1
	cmp.l %d0,%d1
	jeq .L500
	moveq #12,%d1
	cmp.l %d0,%d1
	jeq .L500
.L470:
	clr.l %d0
.L468:
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L504:
	tst.l fl_io_loaded
	jeq .L470
	move.l #65535,-(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
.L479:
	tst.l %d0
	jeq .L468
	move.l %d0,fl_io_last_error
	move.l fl_io_warning,%d1
	tst.l %d1
	jne .L468
.L477:
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,12(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
.L505:
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L503:
	clr.l fl_io_flush_pending
	tst.l fl_io_loaded
	jeq .L470
	move.l #65535,-(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jeq .L468
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L470
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l (%sp)+,%d2
	clr.l %d0
	addq.l #4,%sp
	rts
.L475:
	move.l #65535,-(%sp)
	move.l %d1,8(%sp)
	jsr (flush_ab.constprop.0)
	move.l 8(%sp),%d1
	addq.l #4,%sp
	and.l #251,%d1
	subq.l #8,%d1
	tst.l %d1
	jne .L479
	tst.l fl_blocked_mask
	jeq .L479
	move.l fl_io_warning,%d1
	moveq #-61,%d0
	move.l %d0,fl_io_last_error
	tst.l %d1
	jne .L468
	jra .L477
.L500:
	tst.l fl_blocked_mask
	jeq .L470
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
	jra .L505
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
	jcs .L506
	move.w .L509(%pc,%d0.l*2),%d0
	ext.l %d0
	jmp %pc@(2,%d0:l)
	.balignw 2,0x284c
	.swbeg	&21
.L509:
	.word .L506-.L509
	.word .L506-.L509
	.word .L511-.L509
	.word .L506-.L509
	.word .L514-.L509
	.word .L506-.L509
	.word .L506-.L509
	.word .L514-.L509
	.word .L514-.L509
	.word .L514-.L509
	.word .L512-.L509
	.word .L511-.L509
	.word .L510-.L509
	.word .L506-.L509
	.word .L506-.L509
	.word .L506-.L509
	.word .L506-.L509
	.word .L508-.L509
	.word .L508-.L509
	.word .L508-.L509
	.word .L508-.L509
.L506:
	move.l (%sp)+,%d2
	lea (12,%sp),%sp
	rts
.L514:
	mvz.w #270,%d0
	move.w #271,%a1
	mvz.w #269,%d1
	move.l %d0,4(%sp)
	mvz.w #268,%d0
.L513:
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
	jeq .L506
	move.l 12(%sp),24(%sp)
	move.l %d0,20(%sp)
	move.l (%sp)+,%d2
	lea (12,%sp),%sp
	jra fl_io_post
.L508:
	moveq #10,%d2
	moveq #9,%d1
	move.w #11,%a1
	move.l %d2,4(%sp)
	moveq #8,%d0
	jra .L513
.L511:
	moveq #8,%d2
	mov3q.l #7,%d1
	move.w #9,%a1
	move.l %d2,4(%sp)
	mov3q.l #6,%d0
	jra .L513
.L512:
	moveq #12,%d0
	moveq #11,%d1
	move.l %d0,4(%sp)
	moveq #10,%d0
	move.w #13,%a1
	jra .L513
.L510:
	mvz.w #528,%d1
	move.w #529,%a1
	mvz.w #526,%d0
	move.l %d1,4(%sp)
	mvz.w #527,%d1
	jra .L513
	.size	fl_io_reject_job, .-fl_io_reject_job
	.align	2
	.globl	fl_io_banks_load
	.type	fl_io_banks_load, @function
fl_io_banks_load:
	lea (-568,%sp),%sp
	movem.l #23804,(%sp)
	move.l 584(%sp),-(%sp)
	move.l 584(%sp),-(%sp)
	move.l 584(%sp),-(%sp)
	move.l 584(%sp),-(%sp)
	lea fl_io_stock_directory,%a2
	jsr fl_io_stock_banks_load
	move.l %d0,56(%sp)
	clr.l -(%sp)
	clr.l -(%sp)
	jsr (%a2)
	lea (24,%sp),%sp
	tst.l %d0
	jeq .L520
	move.l %sp,%d5
	move.l %d0,%a1
	lea (48,%sp),%a0
	add.l #308,%d5
.L523:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L522
	cmp.l %d5,%a0
	jne .L523
.L520:
	movem.l (%sp),#23804
	move.l 40(%sp),%d0
	lea (568,%sp),%sp
	rts
.L522:
	tst.l fl_io_loaded
	jeq .L524
	mov3q.l #4,%d0
	cmp.l fl_io_job_kind.l,%d0
	jeq .L524
	move.b 48(%sp),%d0
	jeq .L586
	lea fl_io_base,%a1
	lea (48,%sp),%a0
.L527:
	mvs.b (%a1),%d1
	mvs.b %d0,%d0
	addq.l #1,%a0
	addq.l #1,%a1
	cmp.l %d1,%d0
	jne .L524
	move.b (%a0),%d0
	jne .L527
	move.b (%a1),%d0
	jeq .L520
.L524:
	clr.l -(%sp)
	clr.l -(%sp)
	jsr (%a2)
	addq.l #8,%sp
	tst.l %d0
	jeq .L529
	move.l %d0,%a1
	move.l %d5,%a2
	lea (568,%sp),%a6
	move.l %d5,%a0
.L531:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L530
	cmp.l %a0,%a6
	jne .L531
.L529:
	moveq #-63,%d0
.L545:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L520
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	movem.l (%sp),#23804
	move.l 40(%sp),%d0
	lea (568,%sp),%sp
	rts
.L530:
	jsr fl_reset
	jsr fl_clip_reset
	jsr fl_seq_reset
	clr.l fl_io_protected_mask
	clr.l fl_io_loaded
	clr.l fl_io_warning
	clr.l fl_io_last_error
	lea fl_io_base,%a0
.L533:
	addq.l #1,%a0
	addq.l #1,%a2
	move.b -1(%a2),%d0
	move.b %d0,-1(%a0)
	jeq .L532
	cmp.l %a2,%a6
	jne .L533
	clr.b %d1
	move.b %d1,fl_io_base
.L532:
	clr.l %d2
	mov3q.l #1,%d3
	lsl.l %d2,%d3
	clr.l %d0
	lea (44,%sp),%a6
	move.l %a6,-(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	clr.l 60(%sp)
	lea read_bank,%a2
	lea fresh_bank,%a3
	move.l %d3,%d4
	not.l %d4
	lea fl_io_core_publish,%a4
	and.l %d4,%d0
	move.l %d0,fl_present_mask
	jsr (%a2)
	lea (16,%sp),%sp
	move.l %d0,%d7
	mov3q.l #1,%d0
	cmp.l %d7,%d0
	jeq .L534
.L589:
	or.l %d3,fl_present_mask
	tst.l %d7
	jeq .L587
	move.l %a6,-(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L551
	or.l %d3,fl_present_mask
	tst.l %d0
	jne .L551
.L553:
	or.l %d3,fl_blocked_mask
	pea fl_io_file+32
	move.l 48(%sp),-(%sp)
	move.l %d2,-(%sp)
	and.l %d4,fl_ready_mask
	jsr (%a4)
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L536
	moveq #-61,%d0
	cmp.l %d7,%d0
	jeq .L588
	or.l %d3,fl_io_protected_mask
	tst.l %d7
	jlt .L539
	moveq #-60,%d7
.L539:
	move.l %d7,fl_io_last_error
	tst.l fl_io_warning
	jne .L536
	mov3q.l #1,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
.L536:
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jeq .L541
.L591:
	mov3q.l #1,%d3
	lsl.l %d2,%d3
	move.l fl_present_mask,%d0
	move.l %a6,-(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	clr.l 60(%sp)
	move.l %d3,%d4
	not.l %d4
	and.l %d4,%d0
	move.l %d0,fl_present_mask
	jsr (%a2)
	lea (16,%sp),%sp
	move.l %d0,%d7
	mov3q.l #1,%d0
	cmp.l %d7,%d0
	jne .L589
.L534:
	move.l %a6,-(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jne .L590
	move.l %d2,-(%sp)
	jsr (%a3)
	addq.l #4,%sp
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L591
.L541:
	move.l %d5,-(%sp)
	move.l %a6,-(%sp)
	clr.l -(%sp)
	mov3q.l #1,fl_io_loaded
	jsr (fl_mig_text_read.constprop.0)
	clr.l fl_mig_pending
	clr.l fl_mig_active
	clr.l fl_mig_pristine
	lea (12,%sp),%sp
	tst.l %d0
	jne .L592
	move.l 308(%sp),%a1
	clr.l %d2
	lea fl_migration_table+3,%a0
	move.l #fl_migration_table+2563,%d1
	move.l %a1,fl_mig_active
.L546:
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
	jne .L546
	tst.l %a1
	seq %d0
	mvs.b %d0,%d0
	neg.l %d0
	move.l %d0,-(%sp)
	move.l #65535,-(%sp)
	jsr fl_mig_run
	addq.l #8,%sp
	tst.l %d0
	jne .L545
	tst.l %d2
	jne .L593
	tst.l fl_mig_active
	jne .L520
	movem.l (%sp),#23804
	move.l 40(%sp),%d0
	mov3q.l #1,fl_mig_pristine
	lea (568,%sp),%sp
	rts
.L587:
	or.l %d3,fl_blocked_mask
	pea fl_io_file+32
	move.l 48(%sp),-(%sp)
	move.l %d2,-(%sp)
	and.l %d4,fl_ready_mask
	jsr (%a4)
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L536
	move.l %a6,-(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	moveq #-61,%d1
	cmp.l %d0,%d1
	jeq .L594
	tst.l %d0
	jge .L536
.L540:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L536
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	jra .L536
.L588:
	or.l %d3,fl_blocked_mask
	and.l %d4,fl_ready_mask
	or.l %d3,fl_io_protected_mask
	jra .L539
.L594:
	or.l %d3,fl_blocked_mask
	and.l %d4,fl_ready_mask
	move.l %d1,fl_io_last_error
	tst.l fl_io_warning
	jne .L536
	pea -61.w
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	jra .L536
.L551:
	or.l %d3,fl_blocked_mask
	move.l %d7,%d0
	and.l %d4,fl_ready_mask
	jra .L540
.L592:
	tst.l %d0
	jlt .L545
	movem.l (%sp),#23804
	move.l 40(%sp),%d0
	lea (568,%sp),%sp
	rts
.L593:
	movem.l (%sp),#23804
	move.l 40(%sp),%d0
	mov3q.l #1,fl_mig_active
	lea (568,%sp),%sp
	rts
.L586:
	move.b fl_io_base,%d0
	jeq .L520
	jra .L524
.L590:
	or.l %d3,fl_present_mask
	tst.l %d0
	jeq .L553
	or.l %d3,fl_blocked_mask
	and.l %d4,fl_ready_mask
	jra .L540
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
	jcc .L596
	tst.l %d3
	jlt .L595
	move.l fl_io_loaded,%a6
	tst.l %a6
	jne .L623
	mvz.w %d2,%d2
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	jsr (fl_migrate_saved.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jlt .L630
.L595:
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (284,%sp),%sp
	rts
.L596:
	clr.l -(%sp)
	clr.l -(%sp)
	jsr fl_io_stock_directory
	addq.l #8,%sp
	tst.l %d0
	jeq .L599
	lea (24,%sp),%a6
	move.l %d0,%a1
	move.l %a6,%a0
	lea (284,%sp),%a2
.L601:
	move.b (%a1),%d1
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d1,-1(%a0)
	jeq .L600
	cmp.l %a0,%a2
	jne .L601
	clr.b %d1
	move.b %d1,24(%sp)
.L599:
	clr.b %d0
	moveq #-63,%d1
	clr.l fl_io_loaded
	move.l %d1,fl_io_last_error
	move.b %d0,fl_io_base
	tst.l fl_io_warning
	jne .L605
	pea -63.w
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
.L605:
	tst.l %d3
	jlt .L595
	moveq #-63,%d3
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (284,%sp),%sp
	rts
.L600:
	tst.l fl_io_loaded
	jeq .L602
	move.b 24(%sp),%d0
	jeq .L649
	lea fl_io_base,%a1
	lea (24,%sp),%a0
.L607:
	mvs.b (%a1),%d1
	mvs.b %d0,%d0
	addq.l #1,%a0
	addq.l #1,%a1
	cmp.l %d0,%d1
	jne .L602
	move.b (%a0),%d0
	jne .L607
	move.b (%a1),%d0
.L604:
	tst.b %d0
	jne .L602
	tst.l %d3
	jlt .L595
.L623:
	mvz.w %d2,%d2
	move.l %d2,-(%sp)
	jsr (flush_ab.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jne .L630
	sub.l %a6,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	jsr (fl_migrate_saved.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jge .L595
.L630:
	move.l %d0,%d3
.L624:
	move.l %d3,fl_io_last_error
	tst.l fl_io_warning
	jne .L595
	move.l %d3,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (284,%sp),%sp
	rts
.L602:
	moveq #9,%d0
	cmp.l fl_io_job_kind.l,%d0
	jeq .L650
	lea fl_io_base,%a0
.L612:
	move.b (%a6),%d0
	addq.l #1,%a0
	addq.l #1,%a6
	move.b %d0,-1(%a0)
	jeq .L611
	cmp.l %a6,%a2
	jne .L612
	clr.b %d0
	move.b %d0,fl_io_base
.L611:
	mov3q.l #1,fl_io_loaded
	clr.l fl_io_protected_mask
	clr.l %d4
	clr.l %d2
	lea (path_for.part.0),%a2
	lea fl_io_fs_open,%a3
.L613:
	sub.l %a6,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	pea fl_io_path
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jeq .L651
.L615:
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jne .L627
.L653:
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L613
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
	jlt .L624
	tst.l fl_io_loaded
	jeq .L628
	move.l #65535,-(%sp)
	jsr store_ab
	addq.l #4,%sp
	tst.l %d0
	jne .L630
	mvz.w #65535,%d2
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	jsr (fl_migrate_saved.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jge .L595
	jra .L630
.L651:
	pea 512.w
	pea fl_io_sector
	pea .LC5
	pea fl_io_path
	pea fl_io_object
	jsr (%a3)
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L652
	pea fl_io_object
	jsr fl_io_fs_close
	addq.l #4,%sp
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	or.l %d0,%d4
.L654:
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jeq .L653
.L627:
	mov3q.l #1,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	pea fl_io_path
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L615
	jra .L651
.L652:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jeq .L615
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	or.l %d0,%d4
	jra .L654
.L650:
	jsr fl_reset
	jsr fl_clip_reset
	jsr fl_seq_reset
	mvz.w #65535,%d1
	clr.l fl_present_mask
	clr.l fl_io_warning
	clr.l fl_mig_pending
	move.l %d1,fl_ready_mask
	clr.l fl_io_protected_mask
	clr.l fl_io_last_error
	clr.l fl_mig_active
	mov3q.l #1,fl_mig_pristine
	lea fl_io_base,%a0
	jra .L612
.L628:
	moveq #-60,%d3
	jra .L624
.L649:
	move.b fl_io_base,%d0
	jra .L604
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
	jne .L665
.L656:
	move.l %a1,-(%sp)
	move.l %a0,-(%sp)
	move.l %d1,-(%sp)
	jsr fl_io_stock_card_sync
	lea (12,%sp),%sp
	tst.l %d0
	jge .L666
.L655:
	lea (12,%sp),%sp
	rts
.L665:
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
	jeq .L656
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L655
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,16(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 8(%sp),%d0
	lea (12,%sp),%sp
	rts
.L666:
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
	jlt .L667
	tst.l fl_io_loaded
	jeq .L673
	move.l #65535,-(%sp)
	jsr store_ab
	addq.l #4,%sp
	tst.l %d0
	jeq .L677
.L669:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L672
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,12(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
.L672:
	move.l %d0,%d2
.L667:
	move.l %d2,%d0
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L677:
	mov3q.l #1,-(%sp)
	move.l #65535,-(%sp)
	jsr (fl_migrate_saved.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jlt .L669
	move.l %d2,%d0
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L673:
	moveq #-60,%d0
	jra .L669
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
	jlt .L678
	tst.l fl_io_loaded
	jeq .L684
	move.l 16(%sp),%d1
	mvz.w %d1,%d1
	move.l %d1,-(%sp)
	move.l %d1,8(%sp)
	jsr store_ab
	addq.l #4,%sp
	move.l 4(%sp),%d1
	tst.l %d0
	jeq .L688
.L680:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L683
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,12(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
.L683:
	move.l %d0,%d2
.L678:
	move.l %d2,%d0
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L688:
	mov3q.l #2,-(%sp)
	move.l %d1,-(%sp)
	jsr (fl_migrate_saved.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jlt .L680
	move.l %d2,%d0
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L684:
	moveq #-60,%d0
	jra .L680
	.size	fl_io_bank_store, .-fl_io_bank_store
	.align	2
	.globl	fl_io_project_restore
	.type	fl_io_project_restore, @function
fl_io_project_restore:
	link.w %fp,#-28
	move.l fl_blocked_mask,%d1
	movem.l #1036,(%sp)
	mvz.w %d1,%d1
	move.l %d1,-16(%fp)
	tst.l %d1
	jne .L701
	move.l %fp,%d3
	subq.l #4,%d3
	lea read_bank,%a2
.L692:
	move.l %d3,-(%sp)
	mov3q.l #1,-(%sp)
	move.l -16(%fp),-(%sp)
	pea fl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	move.l %d0,%d2
	mov3q.l #1,%d0
	cmp.l %d2,%d0
	jcc .L708
	move.l %d2,fl_io_last_error
	tst.l fl_io_warning
	jne .L689
.L710:
	move.l %d2,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
.L689:
	move.l %d2,%d0
	movem.l -28(%fp),#1036
	unlk %fp
	rts
.L708:
	addq.l #1,-16(%fp)
	moveq #16,%d1
	cmp.l -16(%fp),%d1
	jne .L692
	move.l 16(%fp),-(%sp)
	move.l 12(%fp),-(%sp)
	move.l 8(%fp),-(%sp)
	jsr fl_io_stock_project_restore
	lea (12,%sp),%sp
	move.l %d0,%d2
	tst.l %d0
	jlt .L689
	move.l #65535,-(%sp)
	jsr restore_mask
	addq.l #4,%sp
	tst.l %d0
	jne .L696
	move.l %d3,-(%sp)
	pea -8(%fp)
	mov3q.l #1,-(%sp)
	jsr (fl_mig_text_read.constprop.0)
	lea (12,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jcc .L709
.L696:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L698
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,-12(%fp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l -12(%fp),%d0
.L698:
	move.l %d0,%d2
	move.l %d2,%d0
	movem.l -28(%fp),#1036
	unlk %fp
	rts
.L709:
	tst.l -4(%fp)
	seq %d0
	move.l #-65536,%d1
	and.l %d1,fl_mig_pending
	mvs.b %d0,%d0
	neg.l %d0
	move.l %d0,-(%sp)
	move.l #65535,-(%sp)
	jsr fl_mig_run
	addq.l #8,%sp
	tst.l %d0
	jne .L696
	move.l %d2,%d0
	movem.l -28(%fp),#1036
	unlk %fp
	rts
.L701:
	moveq #-61,%d2
	move.l %d2,fl_io_last_error
	tst.l fl_io_warning
	jne .L689
	jra .L710
	.size	fl_io_project_restore, .-fl_io_project_restore
	.align	2
	.globl	fl_io_bank_restore
	.type	fl_io_bank_restore, @function
fl_io_bank_restore:
	link.w %fp,#-36
	movem.l #1084,(%sp)
	move.l 12(%fp),%d3
	mvz.w %d3,%d3
	move.l %d3,%d2
	and.l fl_blocked_mask,%d2
	tst.l %d2
	jne .L725
	move.l %fp,%d5
	subq.l #4,%d5
	lea read_bank,%a2
.L714:
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	and.l %d3,%d0
	tst.l %d0
	jne .L713
.L716:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L714
	move.l 20(%fp),-(%sp)
	move.l 16(%fp),-(%sp)
	move.l 12(%fp),-(%sp)
	move.l 8(%fp),-(%sp)
	jsr fl_io_stock_bank_restore
	lea (16,%sp),%sp
	move.l %d0,-16(%fp)
	tst.l %d0
	jlt .L711
	move.l %d3,-(%sp)
	jsr restore_mask
	addq.l #4,%sp
	tst.l %d0
	jne .L720
	pea -4(%fp)
	pea -8(%fp)
	mov3q.l #1,-(%sp)
	jsr (fl_mig_text_read.constprop.0)
	lea (12,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jcc .L734
.L720:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L723
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,-12(%fp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l -12(%fp),%d0
.L723:
	move.l %d0,-16(%fp)
.L711:
	movem.l -36(%fp),#1084
	move.l -16(%fp),%d0
	unlk %fp
	rts
.L713:
	move.l %d5,-(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea fl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	move.l %d0,-16(%fp)
	cmp.l %d0,%d1
	jcc .L716
	move.l -16(%fp),%d1
	move.l %d1,fl_io_last_error
	tst.l fl_io_warning
	jne .L711
.L735:
	move.l %d1,-(%sp)
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	movem.l -36(%fp),#1084
	move.l -16(%fp),%d0
	unlk %fp
	rts
.L734:
	tst.l -4(%fp)
	seq %d0
	move.l %d3,%d1
	not.l %d1
	and.l %d1,fl_mig_pending
	mvs.b %d0,%d0
	neg.l %d0
	move.l %d0,-(%sp)
	move.l %d3,-(%sp)
	jsr fl_mig_run
	addq.l #8,%sp
	tst.l %d0
	jne .L720
	movem.l -36(%fp),#1084
	move.l -16(%fp),%d0
	unlk %fp
	rts
.L725:
	moveq #-61,%d1
	move.l %d1,-16(%fp)
	move.l -16(%fp),%d1
	move.l %d1,fl_io_last_error
	tst.l fl_io_warning
	jne .L711
	jra .L735
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
	jeq .L739
	move.l %sp,%d3
	add.l #24,%d3
	move.l %d0,%a1
	move.l %d3,%a0
	lea (284,%sp),%a6
.L741:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L751
	cmp.l %a0,%a6
	jne .L741
.L739:
	moveq #-63,%d0
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L742
	pea -63.w
	pea fl_io_ui_warning
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
.L742:
	moveq #-63,%d0
.L738:
	movem.l (%sp),#19468
	lea (284,%sp),%sp
	rts
.L751:
	clr.l %d2
	lea (path_for.part.0),%a2
	lea fl_io_fs_remove,%a3
.L740:
	sub.l %a6,%a6
.L747:
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	move.l %d3,-(%sp)
	pea fl_io_path
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jeq .L768
	moveq #-63,%d0
.L763:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L738
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
.L768:
	pea fl_io_path
	jsr (%a3)
	addq.l #4,%sp
	tst.l %d0
	jlt .L769
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jne .L753
.L770:
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L740
	move.l 292(%sp),-(%sp)
	move.l 292(%sp),-(%sp)
	jsr fl_io_stock_delete
	addq.l #8,%sp
	tst.l %d0
	jlt .L763
	movem.l (%sp),#19468
	lea (284,%sp),%sp
	rts
.L769:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jne .L763
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jeq .L770
.L753:
	mov3q.l #1,%a6
	jra .L747
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
.L773:
	move.b (%a0),%d0
	addq.l #1,%a1
	addq.l #1,%a0
	move.b %d0,-1(%a1)
	jeq .L772
	cmp.l #fl_io_base+260,%a0
	jne .L773
.L774:
	moveq #-63,%d1
	move.l %d1,36(%sp)
.L771:
	movem.l (%sp),#19580
	move.l 36(%sp),%d0
	lea (1084,%sp),%sp
	rts
.L772:
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
	jeq .L812
.L775:
	cmp.l %d3,%a0
	jeq .L774
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jne .L775
.L812:
	move.b 44(%sp),%d0
	move.l %a6,%a0
	tst.b %d0
	jeq .L813
.L776:
	mvs.b (%a2),%d1
	mvs.b %d0,%d0
	addq.l #1,%a0
	addq.l #1,%a2
	cmp.l %d1,%d0
	jne .L781
	move.b (%a0),%d0
	jne .L776
	move.b (%a2),%d0
	jeq .L774
.L781:
	move.l 1104(%sp),-(%sp)
	move.l 1104(%sp),-(%sp)
	move.l 1104(%sp),-(%sp)
	move.l 1104(%sp),-(%sp)
	move.l 1104(%sp),-(%sp)
	jsr fl_io_stock_export
	move.l %d0,56(%sp)
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L771
	move.l %sp,%d6
	clr.l %d4
	lea read_bank,%a3
	add.l #824,%d6
	lea (path_for.part.0),%a2
	clr.l %d2
.L788:
	pea 40(%sp)
	move.l %d2,-(%sp)
	move.l %d4,-(%sp)
	move.l %a6,-(%sp)
	jsr (%a3)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L783
	tst.l %d0
	jne .L807
	move.l %d2,-(%sp)
	move.l %d4,-(%sp)
	move.l %a6,-(%sp)
	move.l %d3,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L774
	move.l %d2,-(%sp)
	move.l %d4,-(%sp)
	move.l %d5,-(%sp)
	move.l %d6,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L774
	clr.l -(%sp)
	move.l %d3,-(%sp)
	move.l %d6,-(%sp)
	jsr fl_io_fs_copy
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L807
.L783:
	subq.l #1,%d2
	tst.l %d2
	jne .L792
	addq.l #1,%d4
	moveq #16,%d1
	cmp.l %d4,%d1
	jeq .L771
	clr.l %d2
	jra .L788
.L807:
	move.l %d0,fl_io_last_error
	tst.l fl_io_warning
	jne .L785
	move.l %d0,-(%sp)
	pea fl_io_ui_warning
	move.l %d0,40(%sp)
	mov3q.l #1,fl_io_warning
	jsr fl_io_post
	addq.l #8,%sp
	move.l 32(%sp),%d0
.L785:
	movem.l (%sp),#19580
	move.l %d0,36(%sp)
	move.l 36(%sp),%d0
	lea (1084,%sp),%sp
	rts
.L792:
	mov3q.l #1,%d2
	jra .L788
.L813:
	move.b 304(%sp),%d0
	jne .L781
	jra .L774
	.size	fl_io_export, .-fl_io_export
	.section	.rodata
	.type	fl_mig_line, @object
	.size	fl_mig_line, 20
fl_mig_line:
	.string	"#SYNTH_VC_SETUP=1\r\n"
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
	.local	fl_io_object
.section .data
.balign 4
fl_io_object:
.space 24
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
fl_io_core_bank:
        move.l 4(%sp),%d0
        bsr fl_bank_ptr
        move.l %a0,%d0
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
        move.l 12(%sp),%a0
        move.l 16(%sp),%a1
        bra fl_file_pack
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
