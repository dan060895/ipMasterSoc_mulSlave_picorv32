	.file	"main.c"
	.option nopic
	.attribute arch, "rv32i2p1_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	2
.LC0:
	.string	"\n"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a5,33554432
	addi	a5,a5,4
	sw	a5,-24(s0)
	li	a5,33554432
	addi	a5,a5,8
	sw	a5,-28(s0)
	li	a5,-2147483648
	addi	a5,a5,256
	sw	a5,-32(s0)
	lw	a5,-24(s0)
	li	a4,104
	sw	a4,0(a5)
	lw	a5,-32(s0)
	li	a4,49152
	addi	a4,a4,-337
	sw	a4,0(a5)
	lw	a5,-32(s0)
	addi	a5,a5,4
	li	a4,782336
	addi	a4,a4,-1296
	sw	a4,0(a5)
	lw	a5,-32(s0)
	addi	a5,a5,8
	li	a4,12496896
	addi	a4,a4,-256
	sw	a4,0(a5)
	lw	a5,-32(s0)
	addi	a5,a5,12
	li	a4,199946240
	sw	a4,0(a5)
	lw	a5,-24(s0)
	lw	a5,0(a5)
	li	a1,8
	mv	a0,a5
	call	print_hex
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	print
	lw	a5,-28(s0)
	lw	a5,0(a5)
	li	a1,8
	mv	a0,a5
	call	print_hex
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	print
	lw	a5,-32(s0)
	lw	a5,0(a5)
	li	a1,8
	mv	a0,a5
	call	print_hex
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	print
.L6:
	li	a5,50331648
	lw	a4,0(a5)
	li	a5,127
	bgtu	a4,a5,.L2
	li	a5,50331648
	lw	a4,0(a5)
	li	a5,50331648
	addi	a4,a4,1
	sw	a4,0(a5)
	j	.L3
.L2:
	li	a5,50331648
	li	a4,1
	sw	a4,0(a5)
.L3:
	li	a5,200
	sw	a5,-20(s0)
	j	.L4
.L5:
 #APP
# 57 "firmware/main.c" 1
	nop
# 0 "" 2
 #NO_APP
	lw	a5,-20(s0)
	addi	a5,a5,-1
	sw	a5,-20(s0)
.L4:
	lw	a5,-20(s0)
	bgt	a5,zero,.L5
	j	.L6
	.size	main, .-main
	.ident	"GCC: (gdb4d81090) 14.2.1 20240902"
	.section	.note.GNU-stack,"",@progbits
