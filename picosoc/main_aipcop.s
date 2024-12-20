	.file	"main_aipcop.c"
	.option nopic
	.attribute arch, "rv32i2p1_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	logo
	.section	.rodata
	.align	2
.LC0:
	.ascii	"              vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv\n            "
	.ascii	"      vvvvvvvvvvvvvvvvvvvvvvvvvvvv\nrrrrrrrrrrrrr       vvvv"
	.ascii	"vvvvvvvvvvvvvvvvvvvvvv\nrrrrrrrrrrrrrrrr      vvvvvvvvvvvvvv"
	.ascii	"vvvvvvvvvv\nrrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv\n"
	.ascii	"rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv\nrrrrrrrrrrrr"
	.ascii	"rrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv\nrrrrrrrrrrrrrrrr      vv"
	.ascii	"vvvvvvvvvvvvvvvvvvvv  \nrrrrrrrrrrrrr       vvvvvvvvvvvvvvvv"
	.ascii	"vvvvvv    \nrr                vvvvvvvvvvvvvvvvvvvvvv      \n"
	.ascii	"rr            vvvvvvvvvvvvvvvvvvvvvvvv      rr\nrrrr      vv"
	.ascii	"vvvvvvvvvvvvvvvvvvvvvvvv      rrrr\nrrrrrr      vvvvvvvvvvvv"
	.ascii	"vvvvvvvvvv      rrrrrr\nrrrrrrrr      vvvvvvvvvvvvvvvvvv    "
	.ascii	"  rrrrrrrr\nrrrrrrrrrr      vvvvvvvvvvvvvv      rrrrrrrrrr\n"
	.ascii	"rrrrrrrrrrrr      vvvvvvvvvv      rrrrrrrrrrrr\nrrrrrrrrrrrr"
	.ascii	"rr    "
	.string	"  vvvvvv      rrrrrrrrrrrrrr\nrrrrrrrrrrrrrrrr      vv      rrrrrrrrrrrrrrrr\nrrrrrrrrrrrrrrrrrr          rrrrrrrrrrrrrrrrrr\nrrrrrrrrrrrrrrrrrrrr      rrrrrrrrrrrrrrrrrrrr\nrrrrrrrrrrrrrrrrrrrrrr  rrrrrrrrrrrrrrrrrrrrrr\n\n       PicoSoC with DSP Accelerators\n\n"
	.section	.sdata,"aw"
	.align	2
	.type	logo, @object
	.size	logo, 4
logo:
	.word	.LC0
	.section	.rodata
	.align	2
.LC1:
	.string	"Lets Configure the IPDUMMY Module!\n"
	.align	2
.LC2:
	.string	"Reading IPID !\n"
	.align	2
.LC3:
	.string	"\n"
	.align	2
.LC4:
	.string	"aip_writing to Interface MEMIN0 !\n"
	.align	2
.LC5:
	.string	"aip_writing to Interface MEMIN1 !\n"
	.align	2
.LC6:
	.string	"aip reading to CONFIGREG Interface !\n"
	.align	2
.LC7:
	.string	"aip writing to MEMOUT0 Interface !\n"
	.align	2
.LC8:
	.string	"aip writing to MEMOUT1 Interface !\n"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-80
	sw	ra,76(sp)
	sw	s0,72(sp)
	addi	s0,sp,80
	li	a5,33554432
	addi	a5,a5,4
	li	a4,104
	sw	a4,0(a5)
	li	a5,50331648
	li	a4,63
	sw	a4,0(a5)
	li	a5,50331648
	li	a4,127
	sw	a4,0(a5)
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1)
	call	print
	sw	zero,-20(s0)
	sw	zero,-68(s0)
	sw	zero,-64(s0)
	sw	zero,-60(s0)
	sw	zero,-56(s0)
	sw	zero,-52(s0)
	sw	zero,-48(s0)
	sw	zero,-44(s0)
	sw	zero,-40(s0)
	li	a5,-2147483648
	addi	a5,a5,256
	sw	a5,-28(s0)
	sw	zero,-32(s0)
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	print
	lw	a5,-28(s0)
	addi	a5,a5,8
	li	a4,5
	sw	a4,0(a5)
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-32(s0)
	li	a1,8
	lw	a0,-32(s0)
	call	print_hex
	lui	a5,%hi(.LC3)
	addi	a0,a5,%lo(.LC3)
	call	print
	lui	a5,%hi(.LC3)
	addi	a0,a5,%lo(.LC3)
	call	print
	sw	zero,-36(s0)
	lui	a5,%hi(.LC4)
	addi	a0,a5,%lo(.LC4)
	call	print
	lw	a5,-28(s0)
	addi	a5,a5,8
	li	a4,1
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,8
	sw	zero,0(a5)
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lui	a5,%hi(.LC5)
	addi	a0,a5,%lo(.LC5)
	call	print
	lw	a5,-28(s0)
	addi	a5,a5,8
	li	a4,3
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,8
	li	a4,2
	sw	a4,0(a5)
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	addi	a5,a5,12
	li	a4,1
	sw	a4,0(a5)
	lui	a5,%hi(.LC6)
	addi	a0,a5,%lo(.LC6)
	call	print
	lw	a5,-28(s0)
	addi	a5,a5,8
	li	a4,9
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,8
	li	a4,8
	sw	a4,0(a5)
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lw	a5,-28(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	li	a1,8
	lw	a0,-36(s0)
	call	print_hex
	lui	a5,%hi(.LC7)
	addi	a0,a5,%lo(.LC7)
	call	print
	lw	a5,-28(s0)
	addi	a5,a5,8
	li	a4,5
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,8
	li	a4,4
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,10
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,11
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,12
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,13
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,14
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,13
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,8
	li	a4,5
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,3
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,8
	li	a4,4
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,49152
	addi	a4,a4,-337
	sw	a4,0(a5)
	lui	a5,%hi(.LC8)
	addi	a0,a5,%lo(.LC8)
	call	print
	lw	a5,-28(s0)
	addi	a5,a5,8
	li	a4,7
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,8
	li	a4,6
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,10
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,11
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,12
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,13
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,14
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,13
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,8
	li	a4,5
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,8
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,8
	li	a4,4
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,4
	li	a4,49152
	addi	a4,a4,-337
	sw	a4,0(a5)
	sw	zero,-20(s0)
	j	.L2
.L3:
 #APP
# 192 "firmware/main_aipcop.c" 1
	nop
# 0 "" 2
 #NO_APP
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L2:
	lw	a4,-20(s0)
	li	a5,99
	bleu	a4,a5,.L3
	li	a5,50331648
	li	a4,31
	sw	a4,0(a5)
	li	a5,50331648
	li	a4,1
	sw	a4,0(a5)
	lui	a5,%hi(.LC3)
	addi	a0,a5,%lo(.LC3)
	call	print
.L8:
	li	a5,50331648
	lw	a4,0(a5)
	li	a5,127
	bgtu	a4,a5,.L4
	li	a5,50331648
	lw	a4,0(a5)
	li	a5,50331648
	addi	a4,a4,1
	sw	a4,0(a5)
	j	.L5
.L4:
	li	a5,50331648
	li	a4,1
	sw	a4,0(a5)
.L5:
	li	a5,200
	sw	a5,-24(s0)
	j	.L6
.L7:
 #APP
# 207 "firmware/main_aipcop.c" 1
	nop
# 0 "" 2
 #NO_APP
	lw	a5,-24(s0)
	addi	a5,a5,-1
	sw	a5,-24(s0)
.L6:
	lw	a5,-24(s0)
	bgt	a5,zero,.L7
	j	.L8
	.size	main, .-main
	.align	1
	.globl	aip_writeData
	.type	aip_writeData, @function
aip_writeData:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	mv	a5,a1
	sw	a2,-44(s0)
	sw	a3,-48(s0)
	sb	a5,-37(s0)
	lw	a5,-48(s0)
	bne	a5,zero,.L10
	li	a5,1
	j	.L11
.L10:
	lbu	a4,-37(s0)
	lw	a5,-36(s0)
	sw	a4,8(a5)
	sw	zero,-20(s0)
	j	.L12
.L13:
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-44(s0)
	add	a5,a4,a5
	lw	a4,0(a5)
	lw	a5,-36(s0)
	sw	a4,4(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L12:
	lw	a4,-20(s0)
	lw	a5,-48(s0)
	bltu	a4,a5,.L13
	li	a5,0
.L11:
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	aip_writeData, .-aip_writeData
	.align	1
	.globl	aip_readData
	.type	aip_readData, @function
aip_readData:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	mv	a5,a1
	sw	a2,-44(s0)
	sw	a3,-48(s0)
	sb	a5,-37(s0)
	lw	a5,-48(s0)
	bne	a5,zero,.L15
	li	a5,1
	j	.L16
.L15:
	lbu	a4,-37(s0)
	lw	a5,-36(s0)
	sw	a4,8(a5)
	sw	zero,-20(s0)
	j	.L17
.L18:
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-44(s0)
	add	a5,a4,a5
	lw	a4,-36(s0)
	lw	a4,0(a4)
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L17:
	lw	a4,-20(s0)
	lw	a5,-48(s0)
	bltu	a4,a5,.L18
	li	a5,0
.L16:
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	aip_readData, .-aip_readData
	.align	1
	.globl	aip_start
	.type	aip_start, @function
aip_start:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a5,-20(s0)
	li	a4,1
	sw	a4,12(a5)
 #APP
# 247 "firmware/main_aipcop.c" 1
	nop
# 0 "" 2
 #NO_APP
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	aip_start, .-aip_start
	.ident	"GCC: (gdb4d81090) 14.2.1 20240902"
	.section	.note.GNU-stack,"",@progbits
