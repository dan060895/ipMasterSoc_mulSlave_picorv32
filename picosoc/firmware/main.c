#include "firmware.h"
#include <stdbool.h>
#include <stdint.h>
#include "custom_ops.S"

#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)
//#define reg_leds (*(volatile uint32_t*)0x03000000)

#define MEM_TOTAL 0x1000 /* 128 KB */
#define AIP_IP_IPDUMMY 0x80000100

#define AIP_DATAOUT  0
#define AIP_DATAIN   1
#define AIP_CONFIG   2
#define AIP_START    3



void main() {

    volatile uint32_t *ptr_uart_clkdiv = (volatile uint32_t*)0x02000004;
    volatile uint32_t *ptr_uart_data = (volatile uint32_t*)0x02000008;
	
    //volatile uint32_t *ptr_uart_clkdiv = (uint32_t *)reg_uart_clkdiv;
	//volatile uint32_t *ptr_uart_data = (uint32_t *)reg_uart_data;

    uint32_t *ptr = (uint32_t*)AIP_IP_IPDUMMY;

    *ptr_uart_clkdiv = 104;

    *ptr = 0x0000BEAF;
    *(ptr + 1) = 0x000BEAF0;
    *(ptr + 2) = 0x00BEAF00;
    *(ptr + 3) = 0x0BEAF000;

    //__asm__ volatile ("li	x6, 32");// 0x20 for IRQ-5 --- 0b100000
    //__asm__ volatile ("picorv32_setq_insn(q2, x6)");//asm volatile("");
    print_hex(*ptr_uart_clkdiv, 8);
    print("\n");

    print_hex(*ptr_uart_data, 8);
    print("\n");

    print_hex(*ptr, 8);
    print("\n");

    while (1)
	{
		if(reg_leds<128)
			reg_leds = reg_leds + 1;
		else
			reg_leds = 1;	
		for (int rep = 200; rep > 0; rep--)
		//	for (int rep = 100000; rep > 0; rep--)
		{
			__asm__ volatile ("nop");//asm volatile("");
		}
	}
}
