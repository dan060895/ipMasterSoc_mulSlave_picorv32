	.file	"main.c"
	.option nopic
	.attribute arch, "rv32i2p1_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	2
.LC0:
	.ascii	"                                  #                         "
	.ascii	"                 \n                               *####+.   "
	.ascii	"  ,####+                            \n                      "
	.ascii	"       +######&      (######+.                         \n   "
	.ascii	"                       ,#######*    ##/   .&#######         "
	.ascii	"              \n                        &###(##&    *#######"
	.ascii	"    #######+                     \n                     ,###"
	.ascii	"####/    ############/    +#####+                   \n      "
	.ascii	"             ########    ,######*   #######    #######+.    "
	.ascii	"           \n                ,#######/    (######        ,##"
	.ascii	"####*   .+#####(#             \n              &######+    *#"
	.ascii	"#####*             (######    #######+           \n         "
	.ascii	"  ,######(/       ,######*           #######        +######+"
	.ascii	"        \n         +####(#+             #######      ,######"
	.ascii	"/            ########.     \n      ,+######(    (###        "
	.ascii	" *######*  .#####         ####*   .######((   \n    +######+"
	.ascii	"    ,########/         (######   ,        *#########    ####"
	.ascii	"###+ \n ,######(/    #######(######         ,######*       #"
	.ascii	"######*######*    +######+ \n #####&    ,######*    ,######."
	.ascii	"  ,###   ######+  ,######/     #######    #####((\n   .(    "
	.ascii	"(######          #(   (######    *#*  (######          *####"
	.ascii	"##*   .&   \n       ######/              ,######*        ,##"
	.ascii	"####/               ######(      \n   .(    #######         "
	.ascii	" #######  .##*   #######   /#          *######*   .&   \n ##"
	.ascii	"###&    ,######*    .######/   #######  ###/   ######*     #"
	.ascii	"######    #####(/\n ,#######/    #######(######        /####"
	.ascii	"##*        #######*######/    +######+ \n    +######+    ,##"
	.ascii	"######/        ./   #######        *#########    #######+   "
	.ascii	" \n      ,#######/    (###.        /#####   *######*        "
	.ascii	"####*   .+#####(#      \n         +######&            .#####"
	.ascii	"##       #######            #######+.        \n           ,#"
	.ascii	"#####(/       /######.           *######*       +######&    "
	.ascii	"       \n              &######+    *######*             (###"
	.ascii	"###.   (######+              \n              "
	.ascii	"  ,#######/    #######        .######(   .+#####(#          "
	.ascii	"      \n                   +######&    *######/   (######,  "
	.ascii	" (######+.                  \n                     *#######/"
	.ascii	"    #############    +#####(&                     \n        "
	.ascii	"                &######&    *#######.   (######+            "
	.ascii	"            \n                          *#######*    ##(   ."
	.ascii	"&#######                          \n                        "
	.ascii	"     +######&      (######+.                     \n         "
	.ascii	"                      *####+.     ,####+                    "
	.ascii	"    \n                                 +                    "
	.ascii	"                   \n\n        ####       .(############(,  "
	.ascii	"                       ###(    (###.\n        ####     (####"
	.ascii	"###############.                      ###(    (###.\n       "
	.ascii	" ####     ####             ####       ,############  ###(   "
	.ascii	" (###.\n        ####     ###(             ,###*    #########"
	.ascii	"######  ###(    (###.\n        ####     ###(             (##"
	.ascii	"#.   ####              ###(    (###.\n        ####     #### "
	.ascii	"###############*    ####              ###(    (###.\n       "
	.ascii	" ####     ###("
	.string	" (###########/       (###/             ###(    (###.\n        ####     ####                      *###################.    (###.\n        ####     ###(                         ,(############*       /###.\n\n                       PicoSoC with DSP Accelerators\n\n"
	.align	2
.LC1:
	.string	"Reading IPID !\n"
	.align	2
.LC2:
	.string	"\n"
	.align	2
.LC3:
	.string	"aip_writing to IPDUMMY - initialized to zero !\n"
	.align	2
.LC4:
	.string	"Configuring IPDummy !\n"
	.align	2
.LC5:
	.string	"Configuring IPDummy  !\n"
	.align	2
.LC6:
	.string	"Configuring UART !\n"
	.align	2
.LC7:
	.string	"Waiting TX_UART !\n"
	.align	2
.LC8:
	.string	"Done TX_UART !\n"
	.align	2
.LC9:
	.string	"Reading IPID GPIO !\n"
	.align	2
.LC10:
	.string	"aip_writing to IPGPIO !\n"
	.align	2
.LC11:
	.string	"aip_reading from IPGPIO !\n"
	.align	2
.LC12:
	.string	"Reading IPID PWM !\n"
	.align	2
.LC13:
	.string	"configuring PWM !\n"
	.align	2
.LC14:
	.string	"configuring PWM DutyCicle !\n"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-80
	sw	ra,76(sp)
	sw	s0,72(sp)
	addi	s0,sp,80
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	sw	a5,-40(s0)
	li	a5,-2147483648
	addi	a5,a5,256
	sw	a5,-44(s0)
	li	a5,-2130706432
	addi	a5,a5,256
	sw	a5,-48(s0)
	li	a5,-2113929216
	addi	a5,a5,256
	sw	a5,-52(s0)
	li	a5,-2097152000
	addi	a5,a5,256
	sw	a5,-56(s0)
	li	a5,33554432
	addi	a5,a5,4
	li	a4,434
	sw	a4,0(a5)
	li	a5,50331648
	li	a4,63
	sw	a4,0(a5)
	sw	zero,-60(s0)
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1)
	call	print
	lw	a5,-44(s0)
	addi	a5,a5,8
	li	a4,5
	sw	a4,0(a5)
	lw	a5,-44(s0)
	lw	a5,0(a5)
	sw	a5,-60(s0)
	li	a1,8
	lw	a0,-60(s0)
	call	print_hex
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	print
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	print
	lui	a5,%hi(.LC3)
	addi	a0,a5,%lo(.LC3)
	call	print
	lw	a5,-44(s0)
	addi	a5,a5,8
	li	a4,3
	sw	a4,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,4
	li	a4,7
	sw	a4,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,8
	li	a4,2
	sw	a4,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,12
	li	a4,1
	sw	a4,0(a5)
	lui	a5,%hi(.LC4)
	addi	a0,a5,%lo(.LC4)
	call	print
	lw	a5,-44(s0)
	addi	a5,a5,8
	li	a4,3
	sw	a4,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,8
	li	a4,2
	sw	a4,0(a5)
	lui	a5,%hi(.LC5)
	addi	a0,a5,%lo(.LC5)
	call	print
	lw	a5,-44(s0)
	addi	a5,a5,4
	li	a4,61865984
	addi	a4,a4,-1
	sw	a4,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,4
	li	a4,3145728
	addi	a4,a4,-1
	sw	a4,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,4
	li	a4,1024
	sw	a4,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,4
	li	a4,1024
	sw	a4,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,4
	li	a4,10
	sw	a4,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,4
	li	a4,32
	sw	a4,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,4
	li	a4,8
	sw	a4,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,4
	li	a4,16
	sw	a4,0(a5)
	lw	a5,-44(s0)
	addi	a5,a5,8
	li	a4,6
	sw	a4,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,8
	li	a4,5
	sw	a4,0(a5)
	lw	a5,-56(s0)
	lw	a5,0(a5)
	sw	a5,-60(s0)
	li	a1,8
	lw	a0,-60(s0)
	call	print_hex
	lw	a5,-56(s0)
	addi	a5,a5,8
	li	a4,5
	sw	a4,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,8
	li	a4,4
	sw	a4,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,8
	li	a4,5
	sw	a4,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,8
	li	a4,4
	sw	a4,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,4
	li	a4,65536
	addi	a4,a4,434
	sw	a4,0(a5)
	lui	a5,%hi(.LC6)
	addi	a0,a5,%lo(.LC6)
	call	print
	lw	a5,-56(s0)
	addi	a5,a5,8
	li	a4,1
	sw	a4,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,8
	sw	zero,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,4
	li	a4,72
	sw	a4,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,12
	li	a4,1
	sw	a4,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,8
	li	a4,30
	sw	a4,0(a5)
	sw	zero,-64(s0)
	lui	a5,%hi(.LC7)
	addi	a0,a5,%lo(.LC7)
	call	print
	sw	zero,-64(s0)
	lui	a5,%hi(.LC8)
	addi	a0,a5,%lo(.LC8)
	call	print
	lui	a5,%hi(.LC6)
	addi	a0,a5,%lo(.LC6)
	call	print
	lw	a5,-56(s0)
	addi	a5,a5,8
	li	a4,1
	sw	a4,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,8
	sw	zero,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,4
	li	a4,74
	sw	a4,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,12
	li	a4,1
	sw	a4,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,8
	li	a4,30
	sw	a4,0(a5)
	lui	a5,%hi(.LC7)
	addi	a0,a5,%lo(.LC7)
	call	print
	sw	zero,-64(s0)
	lui	a5,%hi(.LC8)
	addi	a0,a5,%lo(.LC8)
	call	print
	lui	a5,%hi(.LC6)
	addi	a0,a5,%lo(.LC6)
	call	print
	lw	a5,-56(s0)
	addi	a5,a5,8
	li	a4,1
	sw	a4,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,8
	sw	zero,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,4
	li	a4,67
	sw	a4,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,12
	li	a4,1
	sw	a4,0(a5)
	lw	a5,-56(s0)
	addi	a5,a5,8
	li	a4,30
	sw	a4,0(a5)
	lui	a5,%hi(.LC7)
	addi	a0,a5,%lo(.LC7)
	call	print
	sw	zero,-64(s0)
	lui	a5,%hi(.LC8)
	addi	a0,a5,%lo(.LC8)
	call	print
	lui	a5,%hi(.LC9)
	addi	a0,a5,%lo(.LC9)
	call	print
	lw	a5,-48(s0)
	addi	a5,a5,8
	li	a4,5
	sw	a4,0(a5)
	lw	a5,-48(s0)
	lw	a5,0(a5)
	sw	a5,-60(s0)
	li	a1,8
	lw	a0,-60(s0)
	call	print_hex
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	print
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	print
	lui	a5,%hi(.LC10)
	addi	a0,a5,%lo(.LC10)
	call	print
	lw	a5,-48(s0)
	addi	a5,a5,8
	li	a4,5
	sw	a4,0(a5)
	lw	a5,-48(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-48(s0)
	addi	a5,a5,8
	li	a4,4
	sw	a4,0(a5)
	lw	a5,-48(s0)
	addi	a5,a5,4
	li	a4,45056
	addi	a4,a4,-1366
	sw	a4,0(a5)
	lw	a5,-48(s0)
	addi	a5,a5,8
	li	a4,1
	sw	a4,0(a5)
	lw	a5,-48(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-48(s0)
	addi	a5,a5,8
	sw	zero,0(a5)
	lw	a5,-48(s0)
	addi	a5,a5,4
	li	a4,4096
	addi	a4,a4,682
	sw	a4,0(a5)
	lw	a5,-48(s0)
	addi	a5,a5,12
	li	a4,1
	sw	a4,0(a5)
	lui	a5,%hi(.LC11)
	addi	a0,a5,%lo(.LC11)
	call	print
	lw	a5,-48(s0)
	addi	a5,a5,8
	li	a4,3
	sw	a4,0(a5)
	lw	a5,-48(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-48(s0)
	addi	a5,a5,8
	li	a4,2
	sw	a4,0(a5)
	sw	zero,-68(s0)
	lw	a5,-48(s0)
	lw	a5,0(a5)
	sw	a5,-68(s0)
	li	a1,8
	lw	a0,-68(s0)
	call	print_hex
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	print
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	print
	lui	a5,%hi(.LC12)
	addi	a0,a5,%lo(.LC12)
	call	print
	lw	a5,-52(s0)
	addi	a5,a5,8
	li	a4,5
	sw	a4,0(a5)
	lw	a5,-52(s0)
	lw	a5,0(a5)
	sw	a5,-60(s0)
	li	a1,8
	lw	a0,-60(s0)
	call	print_hex
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	print
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	print
	li	a5,497
	sw	a5,-20(s0)
	li	a5,448
	sw	a5,-24(s0)
	li	a5,384
	sw	a5,-28(s0)
	li	a5,256
	sw	a5,-32(s0)
	lui	a5,%hi(.LC13)
	addi	a0,a5,%lo(.LC13)
	call	print
	lw	a5,-52(s0)
	addi	a5,a5,8
	li	a4,1
	sw	a4,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,8
	sw	zero,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,4
	li	a4,128
	sw	a4,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,4
	li	a4,512
	sw	a4,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,4
	li	a4,2
	sw	a4,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,8
	li	a4,3
	sw	a4,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,8
	li	a4,2
	sw	a4,0(a5)
	lui	a5,%hi(.LC14)
	addi	a0,a5,%lo(.LC14)
	call	print
	lw	a5,-52(s0)
	addi	a5,a5,4
	lw	a4,-20(s0)
	sw	a4,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,4
	lw	a4,-24(s0)
	sw	a4,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,4
	lw	a4,-28(s0)
	sw	a4,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,4
	lw	a4,-32(s0)
	sw	a4,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,12
	li	a4,1
	sw	a4,0(a5)
.L10:
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
	li	a5,98304
	addi	a5,a5,1696
	sw	a5,-36(s0)
	j	.L4
.L5:
 #APP
# 294 "firmware/main.c" 1
	nop
# 0 "" 2
 #NO_APP
	lw	a5,-36(s0)
	addi	a5,a5,-1
	sw	a5,-36(s0)
.L4:
	lw	a5,-36(s0)
	bgt	a5,zero,.L5
	lw	a5,-20(s0)
	addi	a5,a5,50
	sw	a5,-20(s0)
	lw	a5,-24(s0)
	addi	a5,a5,50
	sw	a5,-24(s0)
	lw	a5,-28(s0)
	addi	a5,a5,50
	sw	a5,-28(s0)
	lw	a5,-32(s0)
	addi	a5,a5,50
	sw	a5,-32(s0)
	lw	a4,-20(s0)
	li	a5,512
	bleu	a4,a5,.L6
	sw	zero,-20(s0)
.L6:
	lw	a4,-24(s0)
	li	a5,512
	bleu	a4,a5,.L7
	sw	zero,-24(s0)
.L7:
	lw	a4,-28(s0)
	li	a5,512
	bleu	a4,a5,.L8
	sw	zero,-28(s0)
.L8:
	lw	a4,-32(s0)
	li	a5,512
	bleu	a4,a5,.L9
	sw	zero,-32(s0)
.L9:
	lw	a5,-52(s0)
	addi	a5,a5,8
	li	a4,3
	sw	a4,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,4
	sw	zero,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,8
	li	a4,2
	sw	a4,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,4
	lw	a4,-20(s0)
	sw	a4,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,4
	lw	a4,-24(s0)
	sw	a4,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,4
	lw	a4,-28(s0)
	sw	a4,0(a5)
	lw	a5,-52(s0)
	addi	a5,a5,4
	lw	a4,-32(s0)
	sw	a4,0(a5)
	j	.L10
	.size	main, .-main
	.ident	"GCC: (gdb4d81090) 14.2.1 20240902"
	.section	.note.GNU-stack,"",@progbits
