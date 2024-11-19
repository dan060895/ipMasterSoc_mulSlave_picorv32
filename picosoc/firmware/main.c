#include "firmware.h"
#include <stdbool.h>
#include <stdint.h>
#include "custom_ops.S"

#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)
#define reg_leds (*(volatile uint32_t*)0x03000000)

#define MEM_TOTAL 0x1000 /* 128 KB */
#define AIP_IP_IPDUMMY 0x80000100
#define AIP_IP_GPIO    0x81000100
#define AIP_IP_PWM     0x82000100


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
    uint32_t *ptrGPIO = (uint32_t*)AIP_IP_GPIO;
    uint32_t *ptrPWM  = (uint32_t*)AIP_IP_PWM;

    *ptr_uart_clkdiv = 104;
    reg_leds = 63;

    *ptr = 0x0000BEAF;
    *(ptr + 1) = 0x000BEAF0;
    *(ptr + 2) = 0x00BEAF00;
    *(ptr + 3) = 0x0BEAF000;

    print("Reading IPID !\n");
	uint32_t IPID = 0;
	*(ptr + AIP_CONFIG) = 5;
	IPID = *(ptr + AIP_DATAOUT);
	print_hex(IPID,8);
	print("\n");
	print("\n");
	
	print("aip_writing to IPDUMMY - initialized to zero !\n");
	*(ptr + AIP_CONFIG) = 3;  // AMEMIN_DDSParam,0b00011,1,W,We Pointer of MMEMIN_DDSParam
	*(ptr + AIP_DATAIN) = 0x7; // Set ptr MEMIN_DDSParam 7, 
	*(ptr + AIP_CONFIG) = 2;  // MMEMIN,0b00010,1,W,We Pointer of MMEMIN_DDSParam
	*(ptr + AIP_DATAIN) = 0; // Clean  [self.__opCode], 1, 7, self.__addrs)
	*(ptr + AIP_START)  = 1;
	
	print("Configuring IPDummy !\n");
	*(ptr + AIP_CONFIG) = 3;  // AMEMIN_DDSParam,0b00011,1,W,We Pointer of MMEMIN_DDSParam
	*(ptr + AIP_DATAIN) = 0; // Ste ptr to 0
	*(ptr + AIP_CONFIG) = 2;  // CFG,MMEMIN_DDSParam,0b00010,8,W,DDS parameters
	print("Configuring IPDummy  !\n");
	*(ptr + AIP_DATAIN) = 0x03AFFFFF; // 

	*(ptr + AIP_DATAIN) = 0x002FFFFF; // 
	*(ptr + AIP_DATAIN) = 0x00000400; // 
	*(ptr + AIP_DATAIN) = 0x00000400; // 
	*(ptr + AIP_DATAIN) = 0x0000000a; // 
	*(ptr + AIP_DATAIN) = 0x00000020; // 
	*(ptr + AIP_DATAIN) = 0x00000008; // 
	

	*(ptr + AIP_DATAIN) = 0x00000010; // 
	*(ptr + AIP_CONFIG) = 6; // writing CCONFREG just for testing


    //_----------------- AIP GPIO --------
    print("Reading IPID GPIO !\n");
	*(ptrGPIO + AIP_CONFIG) = 5;
	IPID = *(ptrGPIO + AIP_DATAOUT);
	print_hex(IPID,8);
	print("\n");
	print("\n");
	
    // 00 input
    // 01 output
    // 10 AF
    // 11 input
	print("aip_writing to IPGPIO !\n");
    *(ptrGPIO + AIP_CONFIG) = 5;  // ACONFREG 0b00011,1,W,We Pointer of MMEMIN
	*(ptrGPIO + AIP_DATAIN) = 0x0; // Set ptr CCONFREG 0,
    *(ptrGPIO + AIP_CONFIG) = 4;  // ACONFREG 0b00011,1,W,We Pointer of MMEMIN
	*(ptrGPIO + AIP_DATAIN) = 0x0000AAAA; // Set ptr CCONFREG 0 --- MODER_Register

	*(ptrGPIO + AIP_CONFIG) = 1;  // AMEMIN,0b00011,1,W,We Pointer of MMEMIN
	*(ptrGPIO + AIP_DATAIN) = 0x0; // Set ptr MEMIN 0, 
	*(ptrGPIO + AIP_CONFIG) = 0;  // MMEMIN,0b00010,1,W,We Pointer of MMEMIN
	*(ptrGPIO + AIP_DATAIN) = 0x000012AA; // Configuring GPIO as AF
	*(ptrGPIO + AIP_START)  = 1;
	
	
     //_----------------- AIP PWM --------
    print("Reading IPID PWM !\n");
	*(ptrPWM + AIP_CONFIG) = 5;
	IPID = *(ptrPWM + AIP_DATAOUT);
	print_hex(IPID,8);
	print("\n");
	print("\n");
	
    // 00 input
    // 01 output
    // 10 AF
    // 11 input
	print("aip_writing to IPGPIO !\n");
	*(ptrPWM + AIP_CONFIG) = 1;  // AMEMIN,0b00011,1,W,We Pointer of MMEMIN
	*(ptrPWM + AIP_DATAIN) = 0x0; // Set ptr MEMIN 0, 

	*(ptrPWM + AIP_CONFIG) = 0;  // MMEMIN,0b00010,1,W,We Pointer of MMEMIN
	*(ptrPWM + AIP_DATAIN) = 15; // load_psc
	*(ptrPWM + AIP_DATAIN) = 0; // load_pwm_mode
	*(ptrPWM + AIP_DATAIN) = 63; // load_reload
	*(ptrPWM + AIP_DATAIN) = 15; // load_comp_value0
	*(ptrPWM + AIP_DATAIN) = 45; // load_comp_value1
	*(ptrPWM + AIP_DATAIN) = 35; // load_comp_value2
	*(ptrPWM + AIP_DATAIN) = 55; // load_comp_value3
	*(ptrPWM + AIP_DATAIN) = 2; // load_run  = 32'd2;

	*(ptrPWM + AIP_START)  = 1;

    print("aip_reading from IPGPIO !\n");
    *(ptrGPIO + AIP_CONFIG) = 3;  // ACONFREG 0b00011,1,W,We Pointer of MMEMIN
	*(ptrGPIO + AIP_DATAIN) = 0x0; // Set ptr CCONFREG 0,
    *(ptrGPIO + AIP_CONFIG) = 2;  // ACONFREG 0b00011,1,W,We Pointer of MMEMIN
	
    uint32_t IN_GPIO = 0;
	IN_GPIO = *(ptrGPIO + AIP_DATAOUT);
	print_hex(IN_GPIO,8);
	print("\n");
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
