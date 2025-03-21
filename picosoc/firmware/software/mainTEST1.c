#include "firmware.h"
#include <stdbool.h>
#include <stdint.h>
#include <string.h>
#include "custom_ops.S"
#include "aip.h"
#include "ID00001001_dummy.h"

#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)
#define reg_leds (*(volatile uint32_t*)0x03000000)

#define MEM_TOTAL 0x10000 /* 128 KB */
#define AIP_IP_IPDUMMY0 0x80000100
#define AIP_IP_IPDUMMY1 0x81000100
#define AIP_IP_IPDUMMY2 0x82000100
#define AIP_IP_GPIO    	0x83000100


#define AIP_DATAOUT  0
#define AIP_DATAIN   1
#define AIP_CONFIG   2
#define AIP_START    3


int strcmpe(const char *s1, const char *s2) ;
int strcmpe(const char *s1, const char *s2) {
    while (*s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return *(unsigned char *)s1 - *(unsigned char *)s2;
}


void main() {

    uint32_t *ptrDUMMY0  = (uint32_t*)AIP_IP_IPDUMMY0;
	uint32_t *ptrDUMMY1  = (uint32_t*)AIP_IP_IPDUMMY1;
	uint32_t *ptrDUMMY2  = (uint32_t*)AIP_IP_IPDUMMY2;
    uint32_t *ptrGPIO    = (uint32_t*)AIP_IP_GPIO;



    //reg_uart_clkdiv = 434;//5208 for 9600;//104 is 12 MHz for 115200, and 434 is 50Mhz for 115200
    reg_uart_clkdiv = 104;//for simulation only - 5208 for 9600;//104 is 12 MHz for 115200, and 434 is 50Mhz for 115200
    
	reg_leds = 63;
    //print(logo);
	uint32_t IPID = 0;

	char str1[] = "Hola";
    char str2[] = "Hola";
    char str3[] = "Mundo";
	print("starting program.\n");
    print("str1: "); print(str1); print("\n");
    print("str2: "); print(str2); print("\n");
    print("str3: "); print(str3); print("\n");


	if (strcmp(str1, str2) == 0) {
        print("str1 y str2 son iguales.\n");
    } else {
        print("str1 y str2 son diferentes.\n");
    }

    if (strcmp(str1, str3) == 0) {
        print("str1  y str3 son iguales.\n");
    } else {
        print("str1 y str3 son completamente diferentes.\n");
    }

	//print("str1 y str3 son diferentes.\n");

	ID00001001_init(0);
	// ---------------- AIP Dummy ---------
    print("Reeading IPID !\n");
	*(ptrDUMMY0 + AIP_CONFIG) = 5;
	IPID = *(ptrDUMMY0 + AIP_DATAOUT);
	print_hex(IPID,8);
	print("\n");
	print("\n");
	
	print("aip_writing to IPDUMMY0 - initialized to zero !\n");
	*(ptrDUMMY0 + AIP_CONFIG) = 3;  // AMEMIN_DDSParam,0b00011,1,W,We Pointer of MMEMIN_DDSParam
	*(ptrDUMMY0 + AIP_DATAIN) = 0x7; // Set ptr MEMIN_DDSParam 7, 
	*(ptrDUMMY0 + AIP_CONFIG) = 2;  // MMEMIN,0b00010,1,W,We Pointer of MMEMIN_DDSParam
	*(ptrDUMMY0 + AIP_DATAIN) = 0; // Clean  [self.__opCode], 1, 7, self.__addrs)
	*(ptrDUMMY0 + AIP_START)  = 1;
	
	
	print("Configuring IPDummy0 !\n");
	*(ptrDUMMY0 + AIP_CONFIG) = 3;  // AMEMIN_DDSParam,0b00011,1,W,We Pointer of MMEMIN_DDSParam
	*(ptrDUMMY0 + AIP_DATAIN) = 0; // Ste ptr to 0
	*(ptrDUMMY0 + AIP_CONFIG) = 2;  // CFG,MMEMIN_DDSParam,0b00010,8,W,DDS parameters
	print("Configuring IPDummy0  !\n");
	*(ptrDUMMY0 + AIP_DATAIN) = 0x03AFFFFF; // 

	*(ptrDUMMY0 + AIP_DATAIN) = 0x002FFFFF; // 
	*(ptrDUMMY0 + AIP_DATAIN) = 0x00000400; // 
	*(ptrDUMMY0 + AIP_DATAIN) = 0x00000400; // 
	*(ptrDUMMY0 + AIP_DATAIN) = 0x0000000a; // 
	*(ptrDUMMY0 + AIP_DATAIN) = 0x00000020; // 
	*(ptrDUMMY0 + AIP_DATAIN) = 0x00000008; // 
	

	*(ptrDUMMY0 + AIP_DATAIN) = 0x00000010; // 
	*(ptrDUMMY0 + AIP_CONFIG) = 6; // writing CCONFREG just for testing

    //_----------------- AIP GPIO --------
    print("Reading IPID GPIO !\n");
	*(ptrGPIO + AIP_CONFIG) = 5;
	IPID = *(ptrGPIO + AIP_DATAOUT);
	print_hex(IPID,8);
	print("\n");
	print("\n");
	
  	/*      id0000100a_MDATAIN0 = 5'd0, ODATA Register
            id0000100a_ADATAIN0 = 5'd1,
            id0000100a_MMEMOUT0 = 5'd2, IDATA Register
            id0000100a_AMEMOUT0 = 5'd3,
            id0000100a_CCONFREG = 5'd4, MODER Register
            id0000100a_ACONFREG = 5'd5,*/
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
		//for (int rep = 100000; rep > 0; rep--)
		for (int rep = 100; rep > 0; rep--)
		{
			__asm__ volatile ("nop");//asm volatile("");
		}
	
	}
}
