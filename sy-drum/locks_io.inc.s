| GENERATED from tools/locks_io.c (with tools/scenes_io.h, tools/gjlocks_io.h); do not edit.
| Run python3 sy-drum/tools/gen_locks_io.py (m68k-elf-gcc on PATH)
| Source SHA256 (the .c, scenes_io.h, gjlocks_io.h) 9eab6acb80c410f4db0af41b914c26ac8256a3c4226a1fa6ccd7de4ce583bb1e
#NO_APP
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"LOCKS RECOVERED; SAVE TO REPAIR"
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
	jeq .L36
.L34:
	move.b %d1,(%a2,%d0.l)
	move.l %d0,%a0
	addq.l #1,%d0
	move.b (%a1,%d0.l),%d1
	jeq .L55
	cmp.l #245,%d0
	jne .L34
.L36:
	movem.l (%sp),#3076
	moveq #-63,%d0
	lea (12,%sp),%sp
	rts
.L55:
	moveq #47,%d1
	lea 2(%a2,%a0.l),%a3
	lea .LC2,%a1
	move.b %d1,(%a2,%d0.l)
	moveq #115,%d0
.L38:
	move.b %d0,(%a3)+
	addq.l #1,%a1
	move.b (%a1),%d0
	cmp.l #.LC2+6,%a1
	jne .L38
	move.l %d2,%d0
	moveq #9,%d1
	lea 8(%a2,%a0.l),%a1
	addq.l #1,%d0
	cmp.l %d0,%d1
	jcc .L39
	moveq #49,%d1
	add.l #38,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jne .L41
.L56:
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l #.LC4,%d2
	move.l %d2,%a1
.L43:
	move.b %d0,(%a3)+
	move.b 1(%a1),%d0
	addq.l #1,%a1
	tst.b %d0
	jne .L43
	lea 10(%a1,%a0.l),%a0
	clr.l %d0
	move.l %a0,%d1
	sub.l %d2,%d1
	clr.b %d2
	move.b %d2,(%a2,%d1.l)
	movem.l (%sp),#3076
	lea (12,%sp),%sp
	rts
.L39:
	moveq #48,%d1
	move.l %d2,%d0
	add.l #49,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jeq .L56
.L41:
	move.l #.LC3,%d2
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l %d2,%a1
	jra .L43
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
	jne .L83
	pea 512.w
	pea sl_io_sector
	pea .LC5
	pea sl_io_path
	pea sl_io_object
	jsr sl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L99
	lea sl_io_object,%a0
	move.l (%a0),-(%sp)
	move.l %a0,12(%sp)
	jsr sl_io_fs_size
	addq.l #4,%sp
	move.l 8(%sp),%a0
	tst.l %d0
	jge .L100
	move.l %a0,-(%sp)
	move.l %d0,12(%sp)
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l 8(%sp),%d1
.L57:
	move.l (%sp)+,%d2
	move.l %d1,%d0
	move.l (%sp)+,%a2
	addq.l #8,%sp
	rts
.L100:
	move.l %d0,12(%sp)
	moveq #32,%d2
	cmp.l %d0,%d2
	jcs .L101
	move.l %d0,-(%sp)
	pea sl_io_file
	pea sl_io_object
	jsr sl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L102
.L76:
	tst.l %d1
	jlt .L103
.L64:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
.L75:
	move.l (%sp)+,%d2
	moveq #-60,%d1
	move.l %d1,%d0
	move.l (%sp)+,%a2
	addq.l #8,%sp
	rts
.L99:
	moveq #-12,%d0
	cmp.l %d1,%d0
	jeq .L84
	moveq #-10,%d2
	cmp.l %d1,%d2
	jeq .L75
	move.l (%sp)+,%d2
	move.l %d1,%d0
	move.l (%sp)+,%a2
	addq.l #8,%sp
	rts
.L101:
	moveq #32,%d0
	move.l %d0,-(%sp)
	pea sl_io_file
	pea sl_io_object
	jsr sl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jne .L76
.L102:
	lea .LC6,%a0
	clr.l %d0
.L63:
	lea sl_io_file,%a2
	addq.l #1,%a0
	mvz.b (%a2,%d0.l),%d2
	mvz.b -1(%a0),%d1
	addq.l #1,%d0
	cmp.l %d2,%d1
	jne .L104
	moveq #8,%d1
	cmp.l %d0,%d1
	jne .L63
	moveq #9,%d0
	cmp.l 12(%sp),%d0
	jcc .L64
	tst.b sl_io_file+8.l
	jne .L73
	move.b sl_io_file+9,%d0
	mov3q.l #1,%d2
	move.l %d0,%d1
	subq.l #1,%d1
	mvz.b %d1,%d1
	cmp.l %d1,%d2
	jcc .L105
.L73:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
.L69:
	move.l (%sp)+,%d2
	moveq #-61,%d1
	move.l %d1,%d0
	move.l (%sp)+,%a2
	addq.l #8,%sp
	rts
.L103:
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
.L84:
	move.l (%sp)+,%d2
	mov3q.l #1,%d1
	move.l %d1,%d0
	move.l (%sp)+,%a2
	addq.l #8,%sp
	rts
.L105:
	moveq #15,%d1
	cmp.l 12(%sp),%d1
	jcc .L64
	tst.b sl_io_file+10.l
	jne .L73
	mvz.b sl_io_file+11,%d1
	moveq #32,%d2
	cmp.l %d1,%d2
	jne .L73
	move.b sl_io_file+15,%d2
	move.b sl_io_file+14,%d1
	move.w %d2,%a0
	move.l %a0,%d2
	or.l %d2,%d1
	tst.b %d1
	jne .L73
	mvz.b %d0,%d0
	subq.l #1,%d0
	tst.l %d0
	jeq .L86
	mvz.w #49184,%d0
.L72:
	cmp.l 12(%sp),%d0
	jne .L64
	move.l 12(%sp),%a0
	pea -32(%a0)
	pea sl_io_file+32
	pea sl_io_object
	jsr sl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jne .L76
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L57
	move.l 32(%sp),-(%sp)
	move.l 16(%sp),-(%sp)
	pea sl_io_file
	move.l 36(%sp),-(%sp)
	jsr sl_io_core_validate
	lea (16,%sp),%sp
	moveq #-2,%d1
	cmp.l %d0,%d1
	jeq .L69
	tst.l %d0
	jlt .L75
	move.l 12(%sp),%a0
	cmp.l #32800,%a0
	jeq .L106
	move.l (%sp)+,%d2
	clr.l %d1
	move.l %d1,%d0
	move.l (%sp)+,%a2
	addq.l #8,%sp
	rts
.L86:
	mvz.w #32800,%d0
	jra .L72
.L106:
	lea sl_io_file+49178,%a0
	lea sl_io_file+32796,%a1
.L80:
	moveq #-1,%d0
	subq.l #4,%a1
	move.w %d0,4(%a0)
	move.b 7(%a1),3(%a0)
	move.b 6(%a1),2(%a0)
	move.b 5(%a1),1(%a0)
	move.b 4(%a1),(%a0)
	subq.l #6,%a0
	cmp.l #sl_io_file+26,%a0
	jne .L80
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
.L104:
	moveq #9,%d1
	cmp.l 12(%sp),%d1
	jcc .L64
	moveq #15,%d2
	cmp.l 12(%sp),%d2
	jcc .L64
	mvz.w #49184,%d0
	jra .L72
.L83:
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
	jeq .L110
.L108:
	move.b %d1,(%a2,%d0.l)
	move.l %d0,%a0
	addq.l #1,%d0
	move.b (%a1,%d0.l),%d1
	jeq .L129
	cmp.l #245,%d0
	jne .L108
.L110:
	movem.l (%sp),#3076
	moveq #-63,%d0
	lea (12,%sp),%sp
	rts
.L129:
	moveq #47,%d1
	lea 2(%a2,%a0.l),%a3
	lea .LC7,%a1
	move.b %d1,(%a2,%d0.l)
	moveq #115,%d0
.L112:
	move.b %d0,(%a3)+
	addq.l #1,%a1
	move.b (%a1),%d0
	cmp.l #.LC7+6,%a1
	jne .L112
	move.l %d2,%d0
	moveq #9,%d1
	lea 8(%a2,%a0.l),%a1
	addq.l #1,%d0
	cmp.l %d0,%d1
	jcc .L113
	moveq #49,%d1
	add.l #38,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jne .L115
.L130:
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l #.LC4,%d2
	move.l %d2,%a1
.L117:
	move.b %d0,(%a3)+
	move.b 1(%a1),%d0
	addq.l #1,%a1
	tst.b %d0
	jne .L117
	lea 10(%a1,%a0.l),%a0
	clr.l %d0
	move.l %a0,%d1
	sub.l %d2,%d1
	clr.b %d2
	move.b %d2,(%a2,%d1.l)
	movem.l (%sp),#3076
	lea (12,%sp),%sp
	rts
.L113:
	moveq #48,%d1
	move.l %d2,%d0
	add.l #49,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jeq .L130
.L115:
	move.l #.LC3,%d2
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l %d2,%a1
	jra .L117
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
	jeq .L134
.L132:
	move.b %d1,(%a2,%d0.l)
	move.l %d0,%a0
	addq.l #1,%d0
	move.b (%a1,%d0.l),%d1
	jeq .L153
	cmp.l #245,%d0
	jne .L132
.L134:
	movem.l (%sp),#3076
	moveq #-63,%d0
	lea (12,%sp),%sp
	rts
.L153:
	moveq #47,%d1
	lea 2(%a2,%a0.l),%a3
	lea .LC8,%a1
	move.b %d1,(%a2,%d0.l)
	moveq #115,%d0
.L136:
	move.b %d0,(%a3)+
	addq.l #1,%a1
	move.b (%a1),%d0
	cmp.l #.LC8+6,%a1
	jne .L136
	move.l %d2,%d0
	moveq #9,%d1
	lea 8(%a2,%a0.l),%a1
	addq.l #1,%d0
	cmp.l %d0,%d1
	jcc .L137
	moveq #49,%d1
	add.l #38,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jne .L139
.L154:
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l #.LC4,%d2
	move.l %d2,%a1
.L141:
	move.b %d0,(%a3)+
	move.b 1(%a1),%d0
	addq.l #1,%a1
	tst.b %d0
	jne .L141
	lea 10(%a1,%a0.l),%a0
	clr.l %d0
	move.l %a0,%d1
	sub.l %d2,%d1
	clr.b %d2
	move.b %d2,(%a2,%d1.l)
	movem.l (%sp),#3076
	lea (12,%sp),%sp
	rts
.L137:
	moveq #48,%d1
	move.l %d2,%d0
	add.l #49,%d0
	move.b %d1,(%a1)
	move.b %d0,9(%a2,%a0.l)
	tst.l 28(%sp)
	jeq .L154
.L139:
	move.l #.LC3,%d2
	lea 10(%a2,%a0.l),%a3
	moveq #46,%d0
	move.l %d2,%a1
	jra .L141
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
	jne .L160
	pea 512.w
	pea sl_io_sector
	pea .LC9
	pea sl_io_path
	pea sl_io_object
	jsr sl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L155
	move.l #32800,-(%sp)
	pea sl_io_file
	pea sl_io_object
	jsr sl_io_fs_write
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L163
	tst.l %d1
	jlt .L159
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	moveq #-60,%d1
.L155:
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L163:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jle .L155
	clr.l %d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L159:
	pea sl_io_object
	move.l %d1,4(%sp)
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l (%sp),%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L160:
	moveq #-63,%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
	.size	sg_write_file.constprop.0, .-sg_write_file.constprop.0
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
	jne .L169
	pea 512.w
	pea sl_io_sector
	pea .LC9
	pea sl_io_path
	pea sl_io_object
	jsr sl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L164
	move.l #49184,-(%sp)
	pea sl_io_file
	pea sl_io_object
	jsr sl_io_fs_write
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L172
	tst.l %d1
	jlt .L168
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	moveq #-60,%d1
.L164:
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L172:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jle .L164
	clr.l %d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L168:
	pea sl_io_object
	move.l %d1,4(%sp)
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l (%sp),%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L169:
	moveq #-63,%d1
	move.l %d1,%d0
	addq.l #4,%sp
	rts
	.size	write_buffer.constprop.0, .-write_buffer.constprop.0
	.section	.rodata.str1.1
.LC10:
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
.L180:
	move.l (%a2,%d3.l*4),%d4
	lea (6,%a4),%a0
	clr.l %d0
	lea sl_io_file,%a3
	lea sl_io_file+32,%a1
.L174:
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
	jne .L174
	cmp.l (%a2,%d3.l*4),%d4
	jeq .L188
	subq.l #1,%d2
	tst.l %d2
	jne .L180
	movem.l (%sp),#7420
	moveq #-62,%d0
	lea (36,%sp),%sp
	rts
.L188:
	lea .LC10,%a0
.L176:
	move.b (%a0)+,(%a3)+
	cmp.l #.LC10+8,%a0
	jne .L176
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
.L177:
	mvz.b (%a0)+,%d1
	move.l %d2,%d3
	lsr.l #8,%d3
	eor.l %d2,%d1
	mvz.b %d1,%d1
	move.l (%a1,%d1.l*4),%d2
	eor.l %d3,%d2
	cmp.l #sl_io_file+32800,%a0
	jne .L177
	not.l %d2
	move.l %d2,sl_io_file+24
	mov3q.l #-1,%d2
	lea sl_io_file,%a0
.L178:
	mvz.b (%a0)+,%d1
	move.l %d2,%d3
	lsr.l #8,%d3
	eor.l %d2,%d1
	mvz.b %d1,%d1
	move.l (%a1,%d1.l*4),%d2
	eor.l %d3,%d2
	cmp.l #sl_io_file+28,%a0
	jne .L178
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
	move.l 56(%sp),%d7
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
	and.l %d7,%d4
.L194:
	mov3q.l #1,%d2
	lsl.l %d3,%d2
	move.l %d4,%d0
	and.l %d2,%d0
	tst.l %d0
	jne .L221
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L194
.L224:
	sub.l %a6,%a6
.L191:
	move.l sg_dirty_mask,%d1
	move.l %sp,%d5
	move.l sl_ready_mask,%d3
	move.l %sp,%d4
	move.l sl_blocked_mask,%d6
	not.l %d6
	move.l sg_blocked_mask,%d0
	not.l %d0
	and.l %d3,%d1
	move.l sg_protected_mask,%d3
	not.l %d3
	clr.l %d2
	add.l #48,%d5
	add.l #44,%d4
	lea sg_snapshot,%a2
	lea sl_io_irq_lock,%a5
	lea sg_generation,%a4
	lea sl_io_irq_restore,%a3
	and.l %d1,%d6
	and.l %d0,%d6
	and.l %d3,%d6
	and.l %d7,%d6
.L199:
	mov3q.l #1,%d3
	lsl.l %d2,%d3
	move.l %d6,%d0
	and.l %d3,%d0
	tst.l %d0
	jne .L222
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L199
.L227:
	clr.l %d0
.L196:
	tst.l %a6
	jeq .L189
	move.l %a6,%d0
.L189:
	movem.l (%sp),#31996
	lea (52,%sp),%sp
	rts
.L221:
	move.l %d6,-(%sp)
	move.l %d5,-(%sp)
	move.l %d3,-(%sp)
	jsr (%a2)
	lea (12,%sp),%sp
	move.l %d0,%a6
	tst.l %d0
	jne .L191
	move.l %d2,%d0
	and.l sl_present_mask,%d0
	or.l 48(%sp),%d0
	jeq .L192
	clr.l -(%sp)
	move.l %d3,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	move.l %d0,%a6
	tst.l %d0
	jne .L191
	or.l %d2,sl_present_mask
.L192:
	move.l 44(%sp),%a6
	not.l %d2
	jsr (%a5)
	cmp.l (%a4,%d3.l*4),%a6
	jeq .L223
	move.l %d0,-(%sp)
	jsr (%a3)
	and.l %d2,sl_io_protected_mask
	addq.l #4,%sp
.L225:
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L194
	jra .L224
.L223:
	move.l %d0,-(%sp)
	and.l %d2,sl_dirty_mask
	jsr (%a3)
	and.l %d2,sl_io_protected_mask
	addq.l #4,%sp
	jra .L225
.L222:
	move.l %d5,-(%sp)
	move.l %d4,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a2)
	lea (12,%sp),%sp
	tst.l %d0
	jne .L201
	move.l %d3,%d0
	and.l sg_present_mask,%d0
	or.l 48(%sp),%d0
	jeq .L197
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr (sg_write_file.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jne .L196
	or.l %d3,sg_present_mask
.L197:
	move.l 44(%sp),%d7
	jsr (%a5)
	cmp.l (%a4,%d2.l*4),%d7
	jeq .L226
	move.l %d0,-(%sp)
	jsr (%a3)
	addq.l #4,%sp
.L228:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L199
	jra .L227
.L226:
	not.l %d3
	move.l %d0,-(%sp)
	and.l %d3,sg_dirty_mask
	jsr (%a3)
	addq.l #4,%sp
	jra .L228
.L201:
	moveq #-62,%d0
	jra .L196
	.size	flush.part.0.constprop.0, .-flush.part.0.constprop.0
	.align	2
	.type	store_mask, @function
store_mask:
	lea (-52,%sp),%sp
	movem.l #31996,(%sp)
	move.l 56(%sp),%d4
	tst.l sl_io_loaded
	jeq .L242
	move.l %d4,%d3
	and.l sl_blocked_mask,%d3
	tst.l %d3
	jne .L231
	move.l %d4,%d0
	and.l sl_ready_mask,%d0
	cmp.l %d4,%d0
	jne .L231
	move.l %sp,%d6
	move.l %sp,%d5
	add.l #48,%d6
	add.l #44,%d5
	lea snapshot,%a2
	lea sl_io_irq_lock,%a5
	lea sl_generation,%a4
	lea sl_io_irq_restore,%a3
.L232:
	mov3q.l #1,%d2
	lsl.l %d3,%d2
	move.l %d4,%d0
	and.l %d2,%d0
	tst.l %d0
	jne .L264
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L232
.L267:
	sub.l %a6,%a6
.L233:
	move.l sl_ready_mask,%d0
	move.l %sp,%d6
	move.l sl_blocked_mask,%d3
	move.l %sp,%d5
	clr.l %d7
	add.l #48,%d6
	or.l sg_blocked_mask,%d3
	add.l #44,%d5
	lea sg_snapshot,%a2
	lea sl_io_irq_lock,%a5
	lea sg_generation,%a4
	lea sl_io_irq_restore,%a3
	not.l %d3
	and.l %d0,%d3
	and.l %d4,%d3
.L241:
	mov3q.l #1,%d2
	lsl.l %d7,%d2
	move.l %d3,%d0
	and.l %d2,%d0
	tst.l %d0
	jne .L265
	addq.l #1,%d7
	moveq #16,%d0
	cmp.l %d7,%d0
	jne .L241
.L270:
	clr.l %d0
.L238:
	tst.l %a6
	jeq .L229
.L272:
	move.l %a6,%d0
.L229:
	movem.l (%sp),#31996
	lea (52,%sp),%sp
	rts
.L264:
	move.l %d6,-(%sp)
	move.l %d5,-(%sp)
	move.l %d3,-(%sp)
	jsr (%a2)
	lea (12,%sp),%sp
	move.l %d0,%a6
	tst.l %d0
	jne .L233
	move.l %d2,%d0
	and.l sl_present_mask,%d0
	or.l 48(%sp),%d0
	jeq .L235
	clr.l -(%sp)
	move.l %d3,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	move.l %d0,%a6
	tst.l %d0
	jne .L233
	mov3q.l #1,-(%sp)
	move.l %d3,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	move.l %d0,%a6
	tst.l %d0
	jne .L233
	or.l %d2,sl_present_mask
.L235:
	move.l 44(%sp),%d7
	not.l %d2
	jsr (%a5)
	cmp.l (%a4,%d3.l*4),%d7
	jeq .L266
	move.l %d0,-(%sp)
	jsr (%a3)
	and.l %d2,sl_io_protected_mask
	addq.l #4,%sp
.L268:
	addq.l #1,%d3
	moveq #16,%d0
	cmp.l %d3,%d0
	jne .L232
	jra .L267
.L266:
	move.l %d0,-(%sp)
	and.l %d2,sl_dirty_mask
	jsr (%a3)
	and.l %d2,sl_io_protected_mask
	addq.l #4,%sp
	jra .L268
.L265:
	move.l %d6,-(%sp)
	move.l %d5,-(%sp)
	move.l %d7,-(%sp)
	jsr (%a2)
	lea (12,%sp),%sp
	tst.l %d0
	jne .L243
	move.l %d2,%d0
	and.l sg_present_mask,%d0
	or.l 48(%sp),%d0
	jeq .L239
	clr.l -(%sp)
	move.l %d7,-(%sp)
	jsr (sg_write_file.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jne .L238
	mov3q.l #1,-(%sp)
	move.l %d7,-(%sp)
	jsr (sg_write_file.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jne .L238
	or.l %d2,sg_present_mask
.L239:
	move.l 44(%sp),%d4
	not.l %d2
	jsr (%a5)
	cmp.l (%a4,%d7.l*4),%d4
	jeq .L269
	move.l %d0,-(%sp)
	jsr (%a3)
	and.l %d2,sg_protected_mask
	addq.l #4,%sp
.L271:
	addq.l #1,%d7
	moveq #16,%d0
	cmp.l %d7,%d0
	jne .L241
	jra .L270
.L269:
	move.l %d0,-(%sp)
	and.l %d2,sg_dirty_mask
	jsr (%a3)
	and.l %d2,sg_protected_mask
	addq.l #4,%sp
	jra .L271
.L243:
	moveq #-62,%d0
	tst.l %a6
	jeq .L229
	jra .L272
.L231:
	move.l sl_ready_mask,%d0
	move.l %sp,%d6
	move.l sl_blocked_mask,%d3
	move.l %sp,%d5
	move.w #-61,%a6
	clr.l %d7
	or.l sg_blocked_mask,%d3
	add.l #48,%d6
	add.l #44,%d5
	lea sg_snapshot,%a2
	lea sl_io_irq_lock,%a5
	lea sg_generation,%a4
	lea sl_io_irq_restore,%a3
	not.l %d3
	and.l %d0,%d3
	and.l %d4,%d3
	jra .L241
.L242:
	movem.l (%sp),#31996
	moveq #-60,%d0
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
	jne .L293
	pea 512.w
	pea sl_io_sector
	pea .LC5
	pea sl_io_path
	pea sl_io_object
	jsr sl_io_fs_open
	lea (20,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L302
	lea sl_io_object,%a2
	move.l (%a2),-(%sp)
	jsr sl_io_fs_size
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jge .L303
	move.l %a2,-(%sp)
	move.l %d0,16(%sp)
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l 12(%sp),%d1
.L273:
	movem.l (%sp),#1036
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L303:
	moveq #32,%d3
	cmp.l %d0,%d3
	jcs .L304
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
	jeq .L305
.L278:
	tst.l %d2
	jlt .L306
.L286:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
.L281:
	movem.l (%sp),#1036
	moveq #-60,%d1
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L302:
	moveq #-12,%d0
	cmp.l %d1,%d0
	jeq .L294
	moveq #-10,%d2
	cmp.l %d1,%d2
	jeq .L281
	movem.l (%sp),#1036
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L304:
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
	jne .L278
.L305:
	lea .LC10,%a0
	clr.l %d0
	lea sl_io_file,%a2
.L279:
	mvz.b (%a2,%d0.l),%d3
	mvz.b (%a0),%d2
	addq.l #1,%a0
	addq.l #1,%d0
	cmp.l %d3,%d2
	jne .L286
	moveq #8,%d2
	cmp.l %d0,%d2
	jne .L279
	moveq #9,%d3
	cmp.l %d1,%d3
	jcc .L286
	tst.b sl_io_file+8.l
	jne .L285
	mvz.b sl_io_file+9,%d0
	subq.l #1,%d0
	tst.l %d0
	jeq .L307
.L285:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	movem.l (%sp),#1036
	moveq #-61,%d1
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L306:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l %d2,%d1
	move.l %d1,%d0
	movem.l (%sp),#1036
	lea (16,%sp),%sp
	rts
.L294:
	movem.l (%sp),#1036
	mov3q.l #1,%d1
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L307:
	moveq #15,%d3
	cmp.l %d1,%d3
	jcc .L286
	mvz.b sl_io_file+11,%d0
	moveq #32,%d2
	cmp.l %d0,%d2
	jne .L285
	move.b sl_io_file+14,%d3
	move.b sl_io_file+10,%d0
	move.b sl_io_file+15,%d2
	move.w %d3,%a0
	move.l %a0,%d3
	or.l %d3,%d0
	or.l %d2,%d0
	tst.b %d0
	jne .L285
	cmp.l #32800,%d1
	jne .L286
	move.l #32768,-(%sp)
	pea sl_io_file+32
	pea sl_io_object
	jsr sl_io_fs_read
	lea (12,%sp),%sp
	move.l %d0,%d1
	mov3q.l #1,%d0
	cmp.l %d1,%d0
	jeq .L308
	tst.l %d1
	jge .L286
	pea sl_io_object
	move.l %d1,16(%sp)
	jsr sl_io_fs_close
	addq.l #4,%sp
	movem.l (%sp),#1036
	move.l 12(%sp),%d1
	move.l %d1,%d0
	lea (16,%sp),%sp
	rts
.L308:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L273
	tst.b sl_io_file+12.l
	jne .L281
	mvz.b sl_io_file+13,%d0
	cmp.l 24(%sp),%d0
	jne .L281
	mvz.w #32768,%d1
	cmp.l sl_io_file+16.l,%d1
	jne .L281
	mov3q.l #-1,%d1
	lea sl_io_file,%a0
	lea sl_crc_table,%a2
.L289:
	mvz.b (%a0)+,%d0
	move.l %d1,%d2
	lsr.l #8,%d2
	eor.l %d1,%d0
	mvz.b %d0,%d0
	move.l (%a2,%d0.l*4),%d1
	eor.l %d2,%d1
	cmp.l #sl_io_file+28,%a0
	jne .L289
	not.l %d1
	cmp.l sl_io_file+28.l,%d1
	jne .L281
	mov3q.l #-1,%d1
	lea sl_io_file+32,%a1
.L290:
	mvz.b (%a1)+,%d0
	move.l %d1,%d2
	lsr.l #8,%d2
	eor.l %d1,%d0
	mvz.b %d0,%d0
	move.l (%a2,%d0.l*4),%d1
	eor.l %d2,%d1
	cmp.l #sl_io_file+32800,%a1
	jne .L290
	not.l %d1
	cmp.l sl_io_file+24.l,%d1
	jne .L281
	lea sl_io_file+32,%a0
.L291:
	move.b (%a0),%d0
	addq.l #1,%a0
	moveq #126,%d2
	add.l #-128,%d0
	mvz.b %d0,%d0
	cmp.l %d0,%d2
	jcc .L281
	cmp.l %a1,%a0
	jne .L291
	movem.l (%sp),#1036
	move.l 32(%sp),%a0
	clr.l %d1
	move.l %d1,%d0
	move.l sl_io_file+20,(%a0)
	lea (16,%sp),%sp
	rts
.L293:
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
.L311:
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	and.l %d3,%d0
	tst.l %d0
	jne .L310
.L313:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L311
	move.l %sp,%d5
	clr.l %d2
	add.l #24,%d5
	lea sg_read,%a6
.L312:
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	and.l %d3,%d0
	tst.l %d0
	jne .L315
.L317:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L312
	movem.l (%sp),#16444
	clr.l %d0
	lea (28,%sp),%sp
	rts
.L310:
	pea 20(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	jsr (%a6)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jcc .L313
	movem.l (%sp),#16444
	lea (28,%sp),%sp
	rts
.L315:
	move.l %d5,-(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	jsr (%a6)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jcc .L317
	moveq #-61,%d1
	cmp.l %d0,%d1
	jeq .L317
	movem.l (%sp),#16444
	lea (28,%sp),%sp
	rts
	.size	restore_preflight.part.0, .-restore_preflight.part.0
	.align	2
	.type	restore_mask, @function
restore_mask:
	link.w %fp,#-52
	movem.l #15612,(%sp)
	move.l 8(%fp),%d6
	move.l %fp,%d5
	clr.l %d4
	subq.l #4,%d5
	lea sg_publish,%a3
	lea sl_io_irq_lock,%a4
.L340:
	mov3q.l #1,%d3
	lsl.l %d4,%d3
	move.l %d3,%d0
	and.l %d6,%d0
	tst.l %d0
	jne .L357
.L327:
	addq.l #1,%d4
	moveq #16,%d1
	cmp.l %d4,%d1
	jne .L340
	clr.l %d0
.L326:
	movem.l -52(%fp),#15612
	unlk %fp
	rts
.L357:
	pea -8(%fp)
	mov3q.l #1,-(%sp)
	move.l %d4,-(%sp)
	pea sl_io_base
	jsr read_bank
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L358
	tst.l %d0
	jne .L326
	clr.l -(%sp)
	move.l %d4,-(%sp)
	jsr (write_buffer.constprop.0)
	addq.l #8,%sp
	tst.l %d0
	jne .L326
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
	jlt .L341
	move.l %d3,%d0
	or.l sl_present_mask,%d0
	and.l %d2,sl_io_protected_mask
	clr.l %d2
	lea sg_read,%a2
	lea (sg_write_file.constprop.0),%a5
	move.l %d0,sl_present_mask
.L339:
	mov3q.l #1,%d7
	lsl.l %d2,%d7
	move.l %d3,%d0
	and.l %d7,%d0
	tst.l %d0
	jne .L359
.L332:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jeq .L327
.L356:
	mov3q.l #1,%d7
	lsl.l %d2,%d7
	move.l %d3,%d0
	and.l %d7,%d0
	tst.l %d0
	jeq .L332
.L359:
	move.l %d5,-(%sp)
	mov3q.l #1,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	move.l %d0,-12(%fp)
	tst.l %d0
	jeq .L360
	mov3q.l #1,%d1
	cmp.l -12(%fp),%d1
	jeq .L361
	moveq #-61,%d0
	cmp.l -12(%fp),%d0
	jeq .L353
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
	jne .L332
	move.l %d1,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L356
	jra .L327
.L360:
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
	jeq .L332
	move.l -12(%fp),%d0
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L332
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L356
	jra .L327
.L353:
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
	jne .L356
	jra .L327
.L361:
	move.l %d7,%d0
	and.l sg_blocked_mask,%d0
	tst.l %d0
	jne .L353
	move.l %d5,-(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	moveq #-61,%d1
	cmp.l %d0,%d1
	jeq .L353
	clr.l -(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	pea sl_io_path
	jsr (sg_path.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jeq .L362
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	not.l %d7
	lea (12,%sp),%sp
	and.l %d7,sg_present_mask
.L363:
	addq.l #1,%d2
	moveq #16,%d0
	cmp.l %d2,%d0
	jne .L356
	jra .L327
.L358:
	clr.l -(%sp)
	move.l %d4,-(%sp)
	pea sl_io_base
	pea sl_io_path
	jsr (path_for.part.0)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L329
	pea sl_io_path
	jsr sl_io_fs_remove
	addq.l #4,%sp
	tst.l %d0
	jge .L329
	moveq #-12,%d1
	cmp.l %d0,%d1
	jne .L326
.L329:
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
	jra .L339
.L362:
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
	jra .L363
.L341:
	movem.l -52(%fp),#15612
	moveq #-60,%d0
	unlk %fp
	rts
	.size	restore_mask, .-restore_mask
	.align	2
	.globl	sl_io_before_job
	.type	sl_io_before_job, @function
sl_io_before_job:
	subq.l #4,%sp
	move.l %d2,-(%sp)
	move.l 12(%sp),%a0
	mov3q.l #2,%d2
	move.b (%a0),%d1
	mvz.b %d1,%d0
	move.l %d0,sl_io_job_kind
	cmp.l %d0,%d2
	jeq .L392
	clr.l sl_io_warning
	moveq #18,%d2
	cmp.l %d0,%d2
	jcs .L366
	move.l #401296,%d2
	btst %d0,%d2
	jeq .L366
	tst.l sl_io_loaded
	jne .L368
	moveq #8,%d1
	cmp.l %d0,%d1
	jeq .L393
	moveq #12,%d1
	cmp.l %d0,%d1
	jeq .L394
.L366:
	clr.l %d0
.L364:
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L392:
	tst.l sl_io_loaded
	jeq .L366
	move.l #65535,-(%sp)
	jsr (flush.part.0.constprop.0)
	addq.l #4,%sp
.L374:
	tst.l %d0
	jeq .L364
	move.l %d0,sl_io_last_error
	move.l sl_io_warning,%d1
	tst.l %d1
	jne .L364
.L372:
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,12(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
.L395:
	move.l (%sp)+,%d2
	addq.l #4,%sp
	rts
.L368:
	move.l #65535,-(%sp)
	move.l %d1,8(%sp)
	jsr (flush.part.0.constprop.0)
	move.l 8(%sp),%d1
	addq.l #4,%sp
	and.l #251,%d1
	subq.l #8,%d1
	tst.l %d1
	jne .L374
	tst.l sl_blocked_mask
	jeq .L374
	move.l sl_io_warning,%d1
	moveq #-61,%d0
	move.l %d0,sl_io_last_error
	tst.l %d1
	jne .L364
	jra .L372
.L393:
	tst.l sl_blocked_mask
	jeq .L366
	moveq #-61,%d2
	moveq #-61,%d0
	move.l %d2,sl_io_last_error
.L396:
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,12(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
	jra .L395
.L394:
	tst.l sl_blocked_mask
	jeq .L366
	moveq #-61,%d2
	moveq #-61,%d0
	move.l %d2,sl_io_last_error
	jra .L396
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
	jcs .L397
	move.w .L400(%pc,%d0.l*2),%d0
	ext.l %d0
	jmp %pc@(2,%d0:l)
	.balignw 2,0x284c
	.swbeg	&21
.L400:
	.word .L397-.L400
	.word .L397-.L400
	.word .L402-.L400
	.word .L397-.L400
	.word .L405-.L400
	.word .L397-.L400
	.word .L397-.L400
	.word .L405-.L400
	.word .L405-.L400
	.word .L405-.L400
	.word .L403-.L400
	.word .L402-.L400
	.word .L401-.L400
	.word .L397-.L400
	.word .L397-.L400
	.word .L397-.L400
	.word .L397-.L400
	.word .L399-.L400
	.word .L399-.L400
	.word .L399-.L400
	.word .L399-.L400
.L397:
	move.l (%sp)+,%d2
	lea (12,%sp),%sp
	rts
.L405:
	mvz.w #270,%d0
	move.w #271,%a1
	mvz.w #269,%d1
	move.l %d0,4(%sp)
	mvz.w #268,%d0
.L404:
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
	jeq .L397
	move.l 12(%sp),24(%sp)
	move.l %d0,20(%sp)
	move.l (%sp)+,%d2
	lea (12,%sp),%sp
	jra sl_io_post
.L399:
	moveq #10,%d2
	moveq #9,%d1
	move.w #11,%a1
	move.l %d2,4(%sp)
	moveq #8,%d0
	jra .L404
.L402:
	moveq #8,%d2
	mov3q.l #7,%d1
	move.w #9,%a1
	move.l %d2,4(%sp)
	mov3q.l #6,%d0
	jra .L404
.L403:
	moveq #12,%d0
	moveq #11,%d1
	move.l %d0,4(%sp)
	moveq #10,%d0
	move.w #13,%a1
	jra .L404
.L401:
	mvz.w #528,%d1
	move.w #529,%a1
	mvz.w #526,%d0
	move.l %d1,4(%sp)
	mvz.w #527,%d1
	jra .L404
	.size	sl_io_reject_job, .-sl_io_reject_job
	.align	2
	.globl	sl_io_banks_load
	.type	sl_io_banks_load, @function
sl_io_banks_load:
	lea (-560,%sp),%sp
	movem.l #23676,(%sp)
	move.l 576(%sp),-(%sp)
	move.l 576(%sp),-(%sp)
	move.l 576(%sp),-(%sp)
	move.l 576(%sp),-(%sp)
	jsr sl_io_stock_banks_load
	lea (16,%sp),%sp
	move.l %d0,%d4
	tst.l %d0
	jge .L479
.L411:
	move.l %d4,%d0
	movem.l (%sp),#23676
	lea (560,%sp),%sp
	rts
.L479:
	clr.l -(%sp)
	clr.l -(%sp)
	lea sl_io_stock_directory,%a3
	jsr (%a3)
	addq.l #8,%sp
	tst.l %d0
	jeq .L411
	move.l %d0,%a1
	addq.l #1,%a1
	move.b -1(%a1),%d0
	lea (40,%sp),%a0
	addq.l #1,%a0
	lea (300,%sp),%a2
	move.b %d0,-1(%a0)
	jeq .L413
.L480:
	cmp.l %a0,%a2
	jeq .L411
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jne .L480
.L413:
	tst.l sl_io_loaded
	jeq .L415
	mov3q.l #4,%d0
	cmp.l sl_io_job_kind.l,%d0
	jeq .L415
	move.b 40(%sp),%d0
	jeq .L481
	lea sl_io_base,%a1
	lea (40,%sp),%a0
.L418:
	mvs.b (%a1),%d1
	mvs.b %d0,%d0
	addq.l #1,%a0
	addq.l #1,%a1
	cmp.l %d1,%d0
	jne .L415
	move.b (%a0),%d0
	jne .L418
	move.b (%a1),%d0
	jeq .L411
.L415:
	clr.l -(%sp)
	clr.l -(%sp)
	jsr (%a3)
	addq.l #8,%sp
	tst.l %d0
	jeq .L420
	move.l %d0,%a1
	move.l %a2,%a0
	lea (560,%sp),%a6
.L422:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L421
	cmp.l %a0,%a6
	jne .L422
.L420:
	moveq #-63,%d0
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L411
	pea -63.w
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l %d4,%d0
	movem.l (%sp),#23676
	lea (560,%sp),%sp
	rts
.L421:
	jsr sl_reset
	jsr sl_clip_reset
	jsr sl_seq_reset
	clr.l sl_io_protected_mask
	clr.l sl_io_loaded
	clr.l sl_io_warning
	clr.l sl_io_last_error
	lea sl_io_base,%a0
.L424:
	addq.l #1,%a0
	addq.l #1,%a2
	move.b -1(%a2),%d0
	move.b %d0,-1(%a0)
	jeq .L423
	cmp.l %a2,%a6
	jne .L424
	clr.b %d1
	move.b %d1,sl_io_base
.L423:
	sub.l %a6,%a6
	move.l %a6,%d1
	mov3q.l #1,%d2
	lsl.l %d1,%d2
	clr.l %d0
	pea 36(%sp)
	clr.l -(%sp)
	move.l %a6,-(%sp)
	pea sl_io_base
	clr.l 52(%sp)
	lea read_bank,%a2
	lea sg_read,%a3
	lea sg_publish,%a4
	move.l %d2,%d3
	not.l %d3
	and.l %d3,%d0
	move.l %d0,sl_present_mask
	jsr (%a2)
	lea (16,%sp),%sp
	move.l %d0,%d6
	mov3q.l #1,%d0
	cmp.l %d6,%d0
	jeq .L425
.L487:
	or.l %d2,sl_present_mask
	tst.l %d6
	jeq .L482
	pea 36(%sp)
	mov3q.l #1,-(%sp)
	move.l %a6,-(%sp)
	pea sl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L443
	or.l %d2,sl_present_mask
	tst.l %d0
	jne .L443
.L444:
	or.l %d2,sl_blocked_mask
	pea sl_io_file+32
	move.l 40(%sp),-(%sp)
	move.l %a6,-(%sp)
	and.l %d3,sl_ready_mask
	jsr sl_io_core_publish
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L427
	moveq #-61,%d0
	cmp.l %d6,%d0
	jeq .L483
	or.l %d2,sl_io_protected_mask
	tst.l %d6
	jlt .L430
	moveq #-60,%d6
.L430:
	move.l %d6,sl_io_last_error
	tst.l sl_io_warning
	jne .L427
	mov3q.l #1,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
.L427:
	pea 36(%sp)
	clr.l -(%sp)
	move.l %a6,-(%sp)
	pea sl_io_base
	clr.l 52(%sp)
	and.l %d3,sg_present_mask
	jsr (%a3)
	lea (16,%sp),%sp
	move.l %d0,%d3
	tst.l %d0
	jeq .L484
.L432:
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L485
	pea 36(%sp)
	mov3q.l #1,-(%sp)
	move.l %a6,-(%sp)
	pea sl_io_base
	jsr (%a3)
	lea (16,%sp),%sp
	moveq #-61,%d1
	cmp.l %d3,%d1
	jeq .L435
	cmp.l %d0,%d1
	jeq .L435
	tst.l %d0
	jeq .L486
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %a6,-(%sp)
	jsr (%a4)
	jsr sl_io_irq_lock
	move.l %d0,-(%sp)
	or.l %d2,sg_blocked_mask
	jsr sl_io_irq_restore
	or.l %d2,sg_present_mask
	move.l %d3,sl_io_last_error
	lea (16,%sp),%sp
	tst.l sl_io_warning
	jne .L433
	move.l %d3,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
.L433:
	addq.l #1,%a6
	moveq #16,%d1
	cmp.l %a6,%d1
	jeq .L438
.L489:
	move.l %a6,%d1
	mov3q.l #1,%d2
	lsl.l %d1,%d2
	move.l sl_present_mask,%d0
	pea 36(%sp)
	clr.l -(%sp)
	move.l %a6,-(%sp)
	pea sl_io_base
	clr.l 52(%sp)
	move.l %d2,%d3
	not.l %d3
	and.l %d3,%d0
	move.l %d0,sl_present_mask
	jsr (%a2)
	lea (16,%sp),%sp
	move.l %d0,%d6
	mov3q.l #1,%d0
	cmp.l %d6,%d0
	jne .L487
.L425:
	pea 36(%sp)
	mov3q.l #1,-(%sp)
	move.l %a6,-(%sp)
	pea sl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jne .L488
	move.l %a6,-(%sp)
	jsr fresh_bank
	addq.l #4,%sp
	pea 36(%sp)
	clr.l -(%sp)
	move.l %a6,-(%sp)
	pea sl_io_base
	clr.l 52(%sp)
	and.l %d3,sg_present_mask
	jsr (%a3)
	lea (16,%sp),%sp
	move.l %d0,%d3
	tst.l %d0
	jne .L432
.L484:
	pea sl_io_file+32
	move.l 40(%sp),-(%sp)
	move.l %a6,-(%sp)
	jsr (%a4)
	lea (12,%sp),%sp
	addq.l #1,%a6
	or.l %d2,sg_present_mask
	moveq #16,%d1
	cmp.l %a6,%d1
	jne .L489
.L438:
	move.l %d4,%d0
	movem.l (%sp),#23676
	mov3q.l #1,sl_io_loaded
	lea (560,%sp),%sp
	rts
.L443:
	or.l %d2,sl_blocked_mask
	move.l %d6,%d0
	and.l %d3,sl_ready_mask
.L431:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L427
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	jra .L427
.L482:
	or.l %d2,sl_blocked_mask
	pea sl_io_file+32
	move.l 40(%sp),-(%sp)
	move.l %a6,-(%sp)
	and.l %d3,sl_ready_mask
	jsr sl_io_core_publish
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L427
	pea 36(%sp)
	mov3q.l #1,-(%sp)
	move.l %a6,-(%sp)
	pea sl_io_base
	jsr (%a2)
	lea (16,%sp),%sp
	moveq #-61,%d1
	cmp.l %d0,%d1
	jeq .L490
	tst.l %d0
	jge .L427
	jra .L431
.L435:
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %a6,-(%sp)
	jsr (%a4)
	jsr sl_io_irq_lock
	move.l %d0,-(%sp)
	or.l %d2,sg_blocked_mask
	jsr sl_io_irq_restore
	lea (16,%sp),%sp
	or.l %d2,sg_present_mask
	moveq #-61,%d0
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L433
	pea -61.w
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	jra .L433
.L485:
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %a6,-(%sp)
	jsr (%a4)
	lea (12,%sp),%sp
	jra .L433
.L486:
	pea sl_io_file+32
	move.l 40(%sp),-(%sp)
	move.l %a6,-(%sp)
	jsr (%a4)
	lea (12,%sp),%sp
	or.l %d2,sg_protected_mask
	or.l %d2,sg_present_mask
	move.l %d3,sl_io_last_error
	tst.l sl_io_warning
	jne .L433
	mov3q.l #1,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	jra .L433
.L483:
	or.l %d2,sl_blocked_mask
	and.l %d3,sl_ready_mask
	or.l %d2,sl_io_protected_mask
	jra .L430
.L490:
	or.l %d2,sl_blocked_mask
	and.l %d3,sl_ready_mask
	move.l %d1,sl_io_last_error
	tst.l sl_io_warning
	jne .L427
	pea -61.w
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	jra .L427
.L481:
	move.b sl_io_base,%d0
	jeq .L411
	jra .L415
.L488:
	or.l %d2,sl_present_mask
	tst.l %d0
	jeq .L444
	or.l %d2,sl_blocked_mask
	and.l %d3,sl_ready_mask
	jra .L431
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
	jcc .L492
	tst.l %d3
	jlt .L491
	tst.l sl_io_loaded
	jne .L519
.L491:
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (288,%sp),%sp
	rts
.L496:
	tst.l sl_io_loaded
	jeq .L498
	move.b 28(%sp),%d0
	jeq .L539
	lea sl_io_base,%a1
	lea (28,%sp),%a0
.L503:
	mvs.b (%a1),%d1
	mvs.b %d0,%d0
	addq.l #1,%a0
	addq.l #1,%a1
	cmp.l %d0,%d1
	jne .L498
	move.b (%a0),%d0
	jne .L503
	move.b (%a1),%d0
.L500:
	tst.b %d0
	jne .L498
	tst.l %d3
	jlt .L491
.L519:
	move.w 298(%sp),-(%sp)
	clr.w -(%sp)
	jsr (flush.part.0.constprop.0)
	addq.l #4,%sp
	tst.l %d0
	jeq .L491
.L543:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L522
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,32(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l 24(%sp),%d0
.L522:
	move.l %d0,%d3
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (288,%sp),%sp
	rts
.L492:
	clr.l -(%sp)
	clr.l -(%sp)
	jsr sl_io_stock_directory
	addq.l #8,%sp
	tst.l %d0
	jeq .L495
	lea (28,%sp),%a6
	move.l %sp,%d2
	move.l %d0,%a1
	add.l #288,%d2
	move.l %a6,%a0
.L497:
	move.b (%a1),%d1
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d1,-1(%a0)
	jeq .L496
	cmp.l %a0,%d2
	jne .L497
	clr.b %d1
	move.b %d1,28(%sp)
.L495:
	clr.b %d0
	moveq #-63,%d1
	clr.l sl_io_loaded
	move.l %d1,sl_io_last_error
	move.b %d0,sl_io_base
	tst.l sl_io_warning
	jne .L501
	pea -63.w
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
.L501:
	tst.l %d3
	jlt .L491
	moveq #-63,%d3
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (288,%sp),%sp
	rts
.L498:
	moveq #9,%d0
	cmp.l sl_io_job_kind.l,%d0
	jeq .L540
	lea sl_io_base,%a0
.L508:
	move.b (%a6),%d0
	addq.l #1,%a0
	addq.l #1,%a6
	move.b %d0,-1(%a0)
	jeq .L507
	cmp.l %a6,%d2
	jne .L508
	clr.b %d0
	move.b %d0,sl_io_base
.L507:
	clr.l sl_io_protected_mask
	mov3q.l #1,sl_io_loaded
	clr.l sg_present_mask
	clr.l sg_protected_mask
	clr.l %d4
	clr.l %d2
	lea (path_for.part.0),%a2
	lea sl_io_fs_open,%a3
.L509:
	sub.l %a6,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	pea sl_io_path
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jeq .L541
.L511:
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jne .L523
.L545:
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L509
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
	jlt .L542
	move.l #65535,-(%sp)
	jsr store_mask
	addq.l #4,%sp
	tst.l %d0
	jeq .L491
	jra .L543
.L541:
	pea 512.w
	pea sl_io_sector
	pea .LC5
	pea sl_io_path
	pea sl_io_object
	jsr (%a3)
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L544
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	or.l %d0,%d4
.L546:
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jeq .L545
.L523:
	mov3q.l #1,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_base
	pea sl_io_path
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L511
	jra .L541
.L544:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jeq .L511
	mov3q.l #1,%d0
	lsl.l %d2,%d0
	or.l %d0,%d4
	jra .L546
.L542:
	move.l %d3,sl_io_last_error
	tst.l sl_io_warning
	jne .L491
	move.l %d3,-(%sp)
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l %d3,%d0
	movem.l (%sp),#19484
	lea (288,%sp),%sp
	rts
.L540:
	jsr sl_reset
	jsr sl_clip_reset
	jsr sl_seq_reset
	mvz.w #65535,%d1
	clr.l sl_present_mask
	clr.l sl_io_warning
	lea sl_io_base,%a0
	move.l %d1,sl_ready_mask
	clr.l sl_io_protected_mask
	clr.l sg_protected_mask
	clr.l sl_io_last_error
	jra .L508
.L539:
	move.b sl_io_base,%d0
	jra .L500
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
	jne .L557
.L548:
	move.l %a1,24(%sp)
	move.l %a0,20(%sp)
	move.l %d1,16(%sp)
	lea (12,%sp),%sp
	jra sl_io_stock_card_sync
.L557:
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
	jeq .L548
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L547
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,16(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l 8(%sp),%d0
.L547:
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
	jlt .L558
	move.l #65535,-(%sp)
	move.l %d0,4(%sp)
	jsr store_mask
	addq.l #4,%sp
	move.l (%sp),%d1
	tst.l %d0
	jne .L566
.L558:
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L566:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L563
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,8(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l (%sp),%d0
.L563:
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
	jlt .L567
	move.w 14(%sp),-(%sp)
	clr.w -(%sp)
	move.l %d0,4(%sp)
	jsr store_mask
	addq.l #4,%sp
	move.l (%sp),%d1
	tst.l %d0
	jne .L575
.L567:
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L575:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L572
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,8(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l (%sp),%d0
.L572:
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
	jne .L586
	move.l #65535,-(%sp)
	jsr (restore_preflight.part.0)
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jne .L577
	move.l 16(%sp),-(%sp)
	move.l 16(%sp),-(%sp)
	move.l 16(%sp),-(%sp)
	jsr sl_io_stock_project_restore
	lea (12,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L576
	move.l #65535,-(%sp)
	move.l %d0,4(%sp)
	jsr restore_mask
	addq.l #4,%sp
	move.l (%sp),%d1
	tst.l %d0
	jne .L589
.L576:
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L586:
	moveq #-61,%d1
.L577:
	move.l %d1,sl_io_last_error
	tst.l sl_io_warning
	jne .L576
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
.L589:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L585
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,8(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l (%sp),%d0
.L585:
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
	jne .L599
	move.l %d2,-(%sp)
	jsr (restore_preflight.part.0)
	addq.l #4,%sp
	move.l %d0,%d1
	tst.l %d0
	jne .L591
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	move.l 24(%sp),-(%sp)
	jsr sl_io_stock_bank_restore
	lea (16,%sp),%sp
	move.l %d0,%d1
	tst.l %d0
	jlt .L590
	move.l %d2,-(%sp)
	move.l %d0,8(%sp)
	jsr restore_mask
	addq.l #4,%sp
	move.l 4(%sp),%d1
	tst.l %d0
	jne .L605
.L590:
	move.l (%sp)+,%d2
	move.l %d1,%d0
	addq.l #4,%sp
	rts
.L599:
	moveq #-61,%d1
.L591:
	move.l %d1,sl_io_last_error
	tst.l sl_io_warning
	jne .L590
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
.L605:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L598
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,12(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l 4(%sp),%d0
.L598:
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
	jeq .L609
	move.l %sp,%d3
	add.l #24,%d3
	move.l %d0,%a1
	move.l %d3,%a0
	lea (284,%sp),%a6
.L611:
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jeq .L633
	cmp.l %a0,%a6
	jne .L611
.L609:
	moveq #-63,%d0
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L612
	pea -63.w
	pea sl_io_ui_warning
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
.L612:
	moveq #-63,%d0
.L608:
	movem.l (%sp),#19468
	lea (284,%sp),%sp
	rts
.L633:
	clr.l %d2
	lea (path_for.part.0),%a3
	lea sl_io_fs_remove,%a2
.L610:
	sub.l %a6,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	move.l %d3,-(%sp)
	pea sl_io_path
	jsr (%a3)
	lea (16,%sp),%sp
	tst.l %d0
	jeq .L656
.L637:
	moveq #-63,%d0
.L619:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L608
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
.L656:
	pea sl_io_path
	jsr (%a2)
	addq.l #4,%sp
	tst.l %d0
	jlt .L657
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jne .L635
.L660:
	addq.l #1,%d2
	moveq #16,%d1
	cmp.l %d2,%d1
	jne .L610
	sub.l %a6,%a6
	lea (sc_path.part.0),%a3
.L618:
	clr.l %d2
.L621:
	move.l %d2,-(%sp)
	move.l %a6,-(%sp)
	move.l %d3,-(%sp)
	pea sl_io_path
	jsr (%a3)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L637
	pea sl_io_path
	jsr (%a2)
	addq.l #4,%sp
	tst.l %d0
	jlt .L658
	subq.l #1,%d2
	tst.l %d2
	jne .L638
.L661:
	addq.l #1,%a6
	moveq #16,%d1
	cmp.l %a6,%d1
	jne .L618
	sub.l %a3,%a3
	lea (sg_path.part.0),%a6
.L622:
	clr.l %d2
.L625:
	move.l %d2,-(%sp)
	move.l %a3,-(%sp)
	move.l %d3,-(%sp)
	pea sl_io_path
	jsr (%a6)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L637
	pea sl_io_path
	jsr (%a2)
	addq.l #4,%sp
	tst.l %d0
	jlt .L659
	subq.l #1,%d2
	tst.l %d2
	jne .L641
.L662:
	addq.l #1,%a3
	moveq #16,%d1
	cmp.l %a3,%d1
	jne .L622
	move.l 292(%sp),-(%sp)
	move.l 292(%sp),-(%sp)
	jsr sl_io_stock_delete
	addq.l #8,%sp
	tst.l %d0
	jlt .L619
	movem.l (%sp),#19468
	lea (284,%sp),%sp
	rts
.L657:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jne .L619
	mov3q.l #1,%d0
	cmp.l %a6,%d0
	jeq .L660
.L635:
	mov3q.l #1,%a6
	move.l %a6,-(%sp)
	move.l %d2,-(%sp)
	move.l %d3,-(%sp)
	pea sl_io_path
	jsr (%a3)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L637
	jra .L656
.L658:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jne .L619
	subq.l #1,%d2
	tst.l %d2
	jeq .L661
.L638:
	mov3q.l #1,%d2
	jra .L621
.L659:
	moveq #-12,%d1
	cmp.l %d0,%d1
	jne .L619
	subq.l #1,%d2
	tst.l %d2
	jeq .L662
.L641:
	mov3q.l #1,%d2
	jra .L625
	.size	sl_io_delete, .-sl_io_delete
	.section	.rodata.str1.1
.LC11:
	.string	"SYSCENE"
	.text
	.align	2
	.globl	sl_io_export
	.type	sl_io_export, @function
sl_io_export:
	lea (-1096,%sp),%sp
	movem.l #19708,(%sp)
	move.l %sp,%d2
	add.l #56,%d2
	lea sl_io_base,%a0
	move.l %d2,%a1
	move.l #sl_io_base+260,%d1
.L665:
	move.b (%a0),%d0
	addq.l #1,%a1
	addq.l #1,%a0
	move.b %d0,-1(%a1)
	jeq .L664
	cmp.l %d1,%a0
	jne .L665
.L666:
	moveq #-63,%d1
	move.l %d1,40(%sp)
.L663:
	movem.l (%sp),#19708
	move.l 40(%sp),%d0
	lea (1096,%sp),%sp
	rts
.L664:
	move.l 1108(%sp),-(%sp)
	move.l 1108(%sp),-(%sp)
	jsr sl_io_stock_directory
	move.l %sp,%d3
	add.l #324,%d3
	addq.l #8,%sp
	move.l %d3,%a2
	move.l %d3,%a0
	addq.l #1,%a0
	move.l %d0,%a1
	addq.l #1,%a1
	move.b -1(%a1),%d0
	lea (576,%sp),%a6
	move.b %d0,-1(%a0)
	jeq .L737
.L667:
	cmp.l %a6,%a0
	jeq .L666
	move.b (%a1),%d0
	addq.l #1,%a0
	addq.l #1,%a1
	move.b %d0,-1(%a0)
	jne .L667
.L737:
	move.b 56(%sp),%d0
	move.l %d2,%a0
	tst.b %d0
	jeq .L738
.L668:
	mvs.b (%a2),%d1
	mvs.b %d0,%d0
	addq.l #1,%a0
	addq.l #1,%a2
	cmp.l %d0,%d1
	jne .L673
	move.b (%a0),%d0
	jne .L668
	move.b (%a2),%d0
	jeq .L666
.L673:
	move.l 1116(%sp),-(%sp)
	move.l 1116(%sp),-(%sp)
	move.l 1116(%sp),-(%sp)
	move.l 1116(%sp),-(%sp)
	move.l 1116(%sp),-(%sp)
	jsr sl_io_stock_export
	move.l %d0,60(%sp)
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L663
	move.l %sp,%d6
	clr.l %d5
	lea read_bank,%a3
	add.l #836,%d6
	lea (path_for.part.0),%a2
.L674:
	clr.l %d4
.L679:
	pea 48(%sp)
	move.l %d4,-(%sp)
	move.l %d5,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (16,%sp),%sp
	mov3q.l #1,%d7
	cmp.l %d0,%d7
	jeq .L675
	tst.l %d0
	jne .L695
	move.l %d4,-(%sp)
	move.l %d5,-(%sp)
	move.l %d2,-(%sp)
	move.l %a6,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L666
	move.l %d4,-(%sp)
	move.l %d5,-(%sp)
	move.l %d3,-(%sp)
	move.l %d6,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L666
	clr.l -(%sp)
	move.l %a6,-(%sp)
	move.l %d6,-(%sp)
	jsr sl_io_fs_copy
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L695
.L675:
	subq.l #1,%d4
	tst.l %d4
	jne .L707
	addq.l #1,%d5
	moveq #16,%d1
	cmp.l %d5,%d1
	jne .L674
	move.l %sp,%d6
	clr.l %d5
	lea (sc_path.part.0),%a3
	add.l #836,%d6
	lea sl_io_fs_open,%a2
.L680:
	clr.l %d4
.L691:
	move.l %d4,-(%sp)
	move.l %d5,-(%sp)
	move.l %d2,-(%sp)
	pea sl_io_path
	jsr (%a3)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L681
	pea 512.w
	pea sl_io_sector
	pea .LC5
	pea sl_io_path
	pea sl_io_object
	jsr (%a2)
	lea (20,%sp),%sp
	tst.l %d0
	jlt .L739
	lea sl_io_object,%a0
	move.l (%a0),-(%sp)
	jsr sl_io_fs_size
	move.l %d0,48(%sp)
	addq.l #4,%sp
	tst.l %d0
	jge .L740
.L731:
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
.L681:
	move.l %d4,-(%sp)
	move.l %d5,-(%sp)
	move.l %d2,-(%sp)
	move.l %a6,-(%sp)
	jsr (%a3)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L696
	move.l %d4,-(%sp)
	move.l %d5,-(%sp)
	move.l %d3,-(%sp)
	move.l %d6,-(%sp)
	jsr (%a3)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L696
	clr.l -(%sp)
	move.l %a6,-(%sp)
	move.l %d6,-(%sp)
	jsr sl_io_fs_copy
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L695
.L683:
	subq.l #1,%d4
	tst.l %d4
	jne .L709
	addq.l #1,%d5
	moveq #16,%d0
	cmp.l %d5,%d0
	jne .L680
	move.l %sp,%d6
	clr.l %d5
	lea sg_read,%a3
	add.l #836,%d6
	lea (sg_path.part.0),%a2
	clr.l %d4
.L697:
	pea 52(%sp)
	move.l %d4,-(%sp)
	move.l %d5,-(%sp)
	move.l %d2,-(%sp)
	jsr (%a3)
	lea (16,%sp),%sp
	mov3q.l #1,%d1
	cmp.l %d0,%d1
	jeq .L693
	tst.l %d0
	jeq .L694
	moveq #-61,%d7
	cmp.l %d0,%d7
	jne .L695
.L694:
	move.l %d4,-(%sp)
	move.l %d5,-(%sp)
	move.l %d2,-(%sp)
	move.l %a6,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L696
	move.l %d4,-(%sp)
	move.l %d5,-(%sp)
	move.l %d3,-(%sp)
	move.l %d6,-(%sp)
	jsr (%a2)
	lea (16,%sp),%sp
	tst.l %d0
	jne .L696
	clr.l -(%sp)
	move.l %a6,-(%sp)
	move.l %d6,-(%sp)
	jsr sl_io_fs_copy
	lea (12,%sp),%sp
	tst.l %d0
	jlt .L695
.L693:
	subq.l #1,%d4
	tst.l %d4
	jne .L711
	addq.l #1,%d5
	moveq #16,%d1
	cmp.l %d5,%d1
	jeq .L663
	clr.l %d4
	jra .L697
.L740:
	moveq #32,%d1
	cmp.l %d0,%d1
	jcc .L685
	moveq #32,%d0
.L685:
	move.l %d0,-(%sp)
	pea sl_io_file
	pea sl_io_object
	jsr sl_io_fs_read
	lea (12,%sp),%sp
	subq.l #1,%d0
	tst.l %d0
	jne .L731
	lea .LC11,%a0
	clr.l %d0
.L686:
	lea sl_io_file,%a1
	addq.l #1,%a0
	mvz.b (%a1,%d0.l),%d1
	mvz.b -1(%a0),%d7
	addq.l #1,%d0
	cmp.l %d1,%d7
	jne .L731
	moveq #8,%d1
	cmp.l %d0,%d1
	jne .L686
	move.l 44(%sp),%d7
	cmp.l #4128,%d7
	jne .L731
	mvz.b sl_io_file+9,%d0
	subq.l #1,%d0
	tst.l %d0
	jne .L731
	mvz.b sl_io_file+11,%d0
	moveq #32,%d7
	cmp.l %d0,%d7
	jne .L731
	move.b sl_io_file+10,%d1
	move.b sl_io_file+14,%d7
	move.b sl_io_file+8,%d0
	move.w %d1,%a0
	move.w %d7,%a1
	move.b sl_io_file+15,%d1
	move.l %a0,%d7
	or.l %d7,%d0
	move.l %a1,%d7
	or.l %d7,%d0
	or.l %d1,%d0
	tst.b %d0
	jne .L731
	pea 4096.w
	pea sl_io_file+32
	pea sl_io_object
	jsr sl_io_fs_read
	lea (12,%sp),%sp
	pea sl_io_object
	jsr sl_io_fs_close
	addq.l #4,%sp
	jra .L681
.L696:
	moveq #-63,%d0
.L695:
	move.l %d0,sl_io_last_error
	tst.l sl_io_warning
	jne .L699
	move.l %d0,-(%sp)
	pea sl_io_ui_warning
	move.l %d0,44(%sp)
	mov3q.l #1,sl_io_warning
	jsr sl_io_post
	addq.l #8,%sp
	move.l 36(%sp),%d0
.L699:
	movem.l (%sp),#19708
	move.l %d0,40(%sp)
	move.l 40(%sp),%d0
	lea (1096,%sp),%sp
	rts
.L707:
	mov3q.l #1,%d4
	jra .L679
.L709:
	mov3q.l #1,%d4
	jra .L691
.L739:
	moveq #-12,%d7
	cmp.l %d0,%d7
	jne .L681
	jra .L683
.L738:
	move.b 316(%sp),%d0
	jne .L673
	jra .L666
.L711:
	mov3q.l #1,%d4
	jra .L697
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
sl_io_background_some:
        move.l (%sp)+,%d1
        tst.l %d0
        beq sl_io_background_no
sl_io_background_yes:
        moveq #1,%d0
        jmp 0x40022c1c:l
sl_io_background_no:
        jmp 0x40022c70:l

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
