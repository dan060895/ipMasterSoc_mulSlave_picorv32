    .section .text
    .globl irq
	.align	2

irq:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	
    li	x30, 127
    add  x31, x30, 0 #sw  x31, 0(x30)
    addi x30, x30, -1
    add  x31, x30, 0 
    addi x30, x30, -1
    add  x31, x30, 0 
    addi x30, x30, -1
    add  x31, x30, 0 
    addi x30, x30, -1
    add  x31, x30, 0 
    addi x30, x30, -1
    add  x31, x30, 0 

	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra

