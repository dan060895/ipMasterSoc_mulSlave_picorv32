#include "firmware.h"
#include <stdbool.h>
#include <stdint.h>

#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)

#define MEM_TOTAL 0x1000 /* 128 KB */
#define AIP_IP_IPDUMMY 0x80000100

#define AIP_DATAOUT  0
#define AIP_DATAIN   1
#define AIP_CONFIG   2
#define AIP_START    3



void main() {

	volatile uint32_t *ptr_uart_clkdiv = (uint32_t *)reg_uart_clkdiv;
	volatile uint32_t *ptr_uart_data = (uint32_t *)reg_uart_data;
    
    uint32_t *ptr = (uint32_t*)AIP_IP_IPDUMMY;
    	
    reg_uart_clkdiv = 104; 

	*ptr     = 0x0000BEAF;
	*(ptr+1) = 0x000BEAF0;
	*(ptr+2) = 0x00BEAF00;
	*(ptr+3)= 0x0BEAF000;

	print_hex(*ptr_uart_clkdiv,8);
	print("\n");

	print_hex(*ptr_uart_data,8);
	print("\n");

	print_hex(*ptr,8);
	print("\n");

    while(1){
        print("dsp");
    }


}