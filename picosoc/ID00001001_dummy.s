	.file	"ID00001001_dummy.c"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.data
	.align	2
	.type	ID00001001_csv, @object
	.size	ID00001001_csv, 95
ID00001001_csv:
	.string	"MDATAIN"
	.zero	8
	.byte	0
	.byte	87
	.byte	64
	.string	"MDATAOUT"
	.zero	7
	.byte	2
	.byte	82
	.byte	64
	.string	"CDELAY"
	.zero	9
	.byte	4
	.byte	87
	.byte	1
	.string	"STATUS"
	.zero	9
	.byte	30
	.byte	66
	.byte	1
	.string	"IPID"
	.zero	11
	.byte	31
	.byte	82
	.byte	1
	.section	.rodata
	.align	2
.LC0:
	.string	"TTTTTEEEESSSTTT"
	.text
	.align	1
	.globl	ID00001001_init
	.type	ID00001001_init, @function
ID00001001_init:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	mv	a5,a0
	sb	a5,-33(s0)
	lbu	a4,-33(s0)
	li	a2,5
	lui	a5,%hi(ID00001001_csv)
	addi	a1,a5,%lo(ID00001001_csv)
	mv	a0,a4
	call	aip_init
	addi	a4,s0,-20
	lbu	a5,-33(s0)
	mv	a1,a4
	mv	a0,a5
	call	aip_getID
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	print
	li	a5,0
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	ID00001001_init, .-ID00001001_init
	.section	.rodata
	.align	2
.LC1:
	.string	"CDELAY"
	.text
	.align	1
	.globl	ID00001001_enableDelay
	.type	ID00001001_enableDelay, @function
ID00001001_enableDelay:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	mv	a5,a0
	sw	a1,-40(s0)
	sb	a5,-33(s0)
	sw	zero,-20(s0)
	lw	a5,-40(s0)
	slli	a5,a5,1
	ori	a5,a5,1
	sw	a5,-20(s0)
	addi	a5,s0,-20
	lbu	a0,-33(s0)
	li	a4,0
	li	a3,1
	mv	a2,a5
	lui	a5,%hi(.LC1)
	addi	a1,a5,%lo(.LC1)
	call	aip_writeConfReg
	lbu	a5,-33(s0)
	li	a1,0
	mv	a0,a5
	call	aip_enableINT
	li	a5,0
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	ID00001001_enableDelay, .-ID00001001_enableDelay
	.align	1
	.globl	ID00001001_disableDelay
	.type	ID00001001_disableDelay, @function
ID00001001_disableDelay:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	mv	a5,a0
	sb	a5,-33(s0)
	sw	zero,-20(s0)
	addi	a5,s0,-20
	lbu	a0,-33(s0)
	li	a4,0
	li	a3,1
	mv	a2,a5
	lui	a5,%hi(.LC1)
	addi	a1,a5,%lo(.LC1)
	call	aip_writeConfReg
	lbu	a5,-33(s0)
	li	a1,0
	mv	a0,a5
	call	aip_disableINT
	lbu	a5,-33(s0)
	li	a1,0
	mv	a0,a5
	call	aip_clearINT
	li	a5,0
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	ID00001001_disableDelay, .-ID00001001_disableDelay
	.align	1
	.globl	ID00001001_startIP
	.type	ID00001001_startIP, @function
ID00001001_startIP:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	mv	a5,a0
	sb	a5,-17(s0)
	lbu	a5,-17(s0)
	mv	a0,a5
	call	aip_start
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	ID00001001_startIP, .-ID00001001_startIP
	.section	.rodata
	.align	2
.LC2:
	.string	"MMEMIN"
	.text
	.align	1
	.globl	ID00001001_writeData
	.type	ID00001001_writeData, @function
ID00001001_writeData:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	mv	a5,a0
	sw	a1,-24(s0)
	sw	a2,-28(s0)
	sw	a3,-32(s0)
	sb	a5,-17(s0)
	lw	a5,-28(s0)
	slli	a5,a5,16
	srli	a5,a5,16
	lbu	a0,-17(s0)
	lw	a4,-32(s0)
	mv	a3,a5
	lw	a2,-24(s0)
	lui	a5,%hi(.LC2)
	addi	a1,a5,%lo(.LC2)
	call	aip_writeMem
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	ID00001001_writeData, .-ID00001001_writeData
	.section	.rodata
	.align	2
.LC3:
	.string	"MDATAOUT"
	.text
	.align	1
	.globl	ID00001001_readData
	.type	ID00001001_readData, @function
ID00001001_readData:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	mv	a5,a0
	sw	a1,-24(s0)
	sw	a2,-28(s0)
	sw	a3,-32(s0)
	sb	a5,-17(s0)
	lw	a5,-28(s0)
	slli	a5,a5,16
	srli	a5,a5,16
	lbu	a0,-17(s0)
	lw	a4,-32(s0)
	mv	a3,a5
	lw	a2,-24(s0)
	lui	a5,%hi(.LC3)
	addi	a1,a5,%lo(.LC3)
	call	aip_readMem
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	ID00001001_readData, .-ID00001001_readData
	.align	1
	.globl	ID00001001_getStatus
	.type	ID00001001_getStatus, @function
ID00001001_getStatus:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	mv	a5,a0
	sw	a1,-24(s0)
	sb	a5,-17(s0)
	lbu	a5,-17(s0)
	lw	a1,-24(s0)
	mv	a0,a5
	call	aip_getStatus
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	ID00001001_getStatus, .-ID00001001_getStatus
	.align	1
	.globl	ID00001001_waitDone
	.type	ID00001001_waitDone, @function
ID00001001_waitDone:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	mv	a5,a0
	sb	a5,-33(s0)
	sb	zero,-17(s0)
.L16:
	addi	a4,s0,-17
	lbu	a5,-33(s0)
	mv	a1,a4
	mv	a0,a5
	call	aip_getINT
	lbu	a5,-17(s0)
	beq	a5,zero,.L16
	li	a5,0
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	ID00001001_waitDone, .-ID00001001_waitDone
	.align	1
	.type	ID00001001_clearStatus, @function
ID00001001_clearStatus:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	mv	a5,a0
	sb	a5,-33(s0)
	sb	zero,-17(s0)
	j	.L19
.L20:
	lbu	a4,-17(s0)
	lbu	a5,-33(s0)
	mv	a1,a4
	mv	a0,a5
	call	aip_disableINT
	lbu	a4,-17(s0)
	lbu	a5,-33(s0)
	mv	a1,a4
	mv	a0,a5
	call	aip_clearINT
	lbu	a5,-17(s0)
	addi	a5,a5,1
	sb	a5,-17(s0)
.L19:
	lbu	a4,-17(s0)
	li	a5,7
	bleu	a4,a5,.L20
	li	a5,0
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	ID00001001_clearStatus, .-ID00001001_clearStatus
	.ident	"GCC: (g04696df09) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
