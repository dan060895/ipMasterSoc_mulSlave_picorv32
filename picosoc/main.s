	.file	"main.c"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	strcmpe
	.type	strcmpe, @function
strcmpe:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	j	.L2
.L4:
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L2:
	lw	a5,-20(s0)
	lbu	a5,0(a5)
	beq	a5,zero,.L3
	lw	a5,-20(s0)
	lbu	a4,0(a5)
	lw	a5,-24(s0)
	lbu	a5,0(a5)
	beq	a4,a5,.L4
.L3:
	lw	a5,-20(s0)
	lbu	a5,0(a5)
	mv	a4,a5
	lw	a5,-24(s0)
	lbu	a5,0(a5)
	sub	a5,a4,a5
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	strcmpe, .-strcmpe
	.section	.rodata
	.align	2
.LC0:
	.string	"start.\n"
	.align	2
.LC1:
	.string	"TEST\n"
	.align	2
.LC2:
	.string	"MEMOUT \n"
	.align	2
.LC3:
	.string	"Dat["
	.align	2
.LC4:
	.string	"]:"
	.align	2
.LC5:
	.string	"\n"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-96
	sw	ra,92(sp)
	sw	s0,88(sp)
	addi	s0,sp,96
	li	a5,-2147483648
	addi	a5,a5,256
	sw	a5,-36(s0)
	li	a5,-2130706432
	addi	a5,a5,256
	sw	a5,-40(s0)
	li	a5,-2113929216
	addi	a5,a5,256
	sw	a5,-44(s0)
	li	a5,-2097152000
	addi	a5,a5,256
	sw	a5,-48(s0)
	li	a5,33554432
	addi	a5,a5,4
	li	a4,104
	sw	a4,0(a5)
	li	a5,50331648
	li	a4,63
	sw	a4,0(a5)
	sw	zero,-52(s0)
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	print
	sw	zero,-56(s0)
	li	a0,0
	call	ID00001001_init
	addi	a5,s0,-56
	mv	a1,a5
	li	a0,0
	call	ID00001001_getStatus
	sw	zero,-20(s0)
	j	.L7
.L8:
	lw	a5,-20(s0)
	li	a4,1
	sll	a5,a4,a5
	mv	a3,a5
	lw	a4,-20(s0)
	addi	a5,s0,-88
	slli	a4,a4,2
	add	a5,a4,a5
	sw	a3,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L7:
	lw	a4,-20(s0)
	li	a5,7
	bleu	a4,a5,.L8
	addi	a5,s0,-88
	li	a3,0
	li	a2,8
	mv	a1,a5
	li	a0,0
	call	ID00001001_writeData
	li	a5,4096
	addi	a1,a5,904
	li	a0,0
	call	ID00001001_enableDelay
	addi	a5,s0,-56
	mv	a1,a5
	li	a0,0
	call	ID00001001_getStatus
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1)
	call	print
	li	a0,0
	call	ID00001001_startIP
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1)
	call	print
	addi	a5,s0,-56
	mv	a1,a5
	li	a0,0
	call	ID00001001_getStatus
	li	a0,0
	call	ID00001001_waitDone
	addi	a5,s0,-56
	mv	a1,a5
	li	a0,0
	call	ID00001001_getStatus
	sw	zero,-24(s0)
	j	.L9
.L10:
	lw	a4,-24(s0)
	addi	a5,s0,-88
	slli	a4,a4,2
	add	a5,a4,a5
	sw	zero,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L9:
	lw	a4,-24(s0)
	li	a5,7
	bleu	a4,a5,.L10
	addi	a5,s0,-88
	li	a3,0
	li	a2,8
	mv	a1,a5
	li	a0,0
	call	ID00001001_readData
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	print
	sw	zero,-28(s0)
	j	.L11
.L12:
	lui	a5,%hi(.LC3)
	addi	a0,a5,%lo(.LC3)
	call	print
	lw	a0,-28(s0)
	call	print_dec
	lui	a5,%hi(.LC4)
	addi	a0,a5,%lo(.LC4)
	call	print
	lw	a4,-28(s0)
	addi	a5,s0,-88
	slli	a4,a4,2
	add	a5,a4,a5
	lw	a5,0(a5)
	li	a1,2
	mv	a0,a5
	call	print_hex
	lui	a5,%hi(.LC5)
	addi	a0,a5,%lo(.LC5)
	call	print
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
.L11:
	lw	a4,-28(s0)
	li	a5,7
	bleu	a4,a5,.L12
.L15:
	li	a5,100
	sw	a5,-32(s0)
	j	.L13
.L14:
 #APP
# 122 "firmware/software/main.c" 1
	nop
# 0 "" 2
 #NO_APP
	lw	a5,-32(s0)
	addi	a5,a5,-1
	sw	a5,-32(s0)
.L13:
	lw	a5,-32(s0)
	bgt	a5,zero,.L14
	j	.L15
	.size	main, .-main
	.ident	"GCC: (g04696df09) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
