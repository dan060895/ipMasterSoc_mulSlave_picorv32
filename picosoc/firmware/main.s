	.file	"main.s"
    .section .text
    .globl main



main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32

ho:	li	x28, 255
	add  x29, x28, 0  #sw  x29, 0(x28)
    addi x28, x28, -1
	add  x29, x28, 0
    addi x28, x28, -1
    add  x29, x28, 0
    addi x28, x28, -1
    add  x29, x28, 0
    addi x28, x28, -1
    add  x29, x28, 0


    j	main

