// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.


#include "firmware.h"
#include <stdbool.h>
#include <stdint.h>
//#include <string.h>

#define reg_spictrl (*(volatile uint32_t*)0x02000000)
#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)
#define reg_leds (*(volatile uint32_t*)0x03000000)


#define MEM_TOTAL 0x1000 /* 128 KB */
#define AIP_IP_IPDUMMY 0x80000100

#define AIP_DATAOUT  0
#define AIP_DATAIN   1
#define AIP_CONFIG   2
#define AIP_START    3

#define MAX_DATA 8

typedef struct
{
    uint32_t aip_dataOut;
    uint32_t aip_dataIn;
    uint32_t aip_config;
    uint32_t aip_start;
} aip_regs;


uint8_t aip_writeData (aip_regs * port, uint8_t config, uint32_t * data, uint32_t size);
uint8_t aip_readData (aip_regs * port, uint8_t config, uint32_t * data, uint32_t size);
uint8_t aip_start (aip_regs * port);

char *logo =

    "              vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv\n"
    "                  vvvvvvvvvvvvvvvvvvvvvvvvvvvv\n"
    "rrrrrrrrrrrrr       vvvvvvvvvvvvvvvvvvvvvvvvvv\n"
    "rrrrrrrrrrrrrrrr      vvvvvvvvvvvvvvvvvvvvvvvv\n"
    "rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv\n"
    "rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv\n"
    "rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv\n"
    "rrrrrrrrrrrrrrrr      vvvvvvvvvvvvvvvvvvvvvv  \n"
    "rrrrrrrrrrrrr       vvvvvvvvvvvvvvvvvvvvvv    \n"
    "rr                vvvvvvvvvvvvvvvvvvvvvv      \n"
    "rr            vvvvvvvvvvvvvvvvvvvvvvvv      rr\n"
    "rrrr      vvvvvvvvvvvvvvvvvvvvvvvvvv      rrrr\n"
    "rrrrrr      vvvvvvvvvvvvvvvvvvvvvv      rrrrrr\n"
    "rrrrrrrr      vvvvvvvvvvvvvvvvvv      rrrrrrrr\n"
    "rrrrrrrrrr      vvvvvvvvvvvvvv      rrrrrrrrrr\n"
    "rrrrrrrrrrrr      vvvvvvvvvv      rrrrrrrrrrrr\n"
    "rrrrrrrrrrrrrr      vvvvvv      rrrrrrrrrrrrrr\n"
    "rrrrrrrrrrrrrrrr      vv      rrrrrrrrrrrrrrrr\n"
    "rrrrrrrrrrrrrrrrrr          rrrrrrrrrrrrrrrrrr\n"
    "rrrrrrrrrrrrrrrrrrrr      rrrrrrrrrrrrrrrrrrrr\n"
    "rrrrrrrrrrrrrrrrrrrrrr  rrrrrrrrrrrrrrrrrrrrrr\n"
    "\n"
    "       PicoSoC with DSP Accelerators\n\n";

void main(void)
{
	reg_uart_clkdiv = 104; //12 MHz/ 115200 Baud
	//reg_uart_clkdiv = 434; //50 MHz/ 115200 Baud
	//print("Booting..\n");

	reg_leds = 63;
	//set_flash_qspi_flag();

	reg_leds = 127;
	
	print("Lets Configure the IPDUMMY Module!\n");
		
	uint32_t i = 0;
    	//uint32_t data [MAX_DATA] ;
	uint32_t data_read[MAX_DATA];

	data_read[0] = 0;
        data_read[1] = 0;
        data_read[2] = 0;
	data_read[3] = 0;
	data_read[4] = 0;
	data_read[5] = 0;
	data_read[6] = 0;
	data_read[7] = 0;

    	//aip_regs * aipTest = (aip_regs *)AIP_IPDUMMY;
    	uint32_t *ptr = (uint32_t*)AIP_IP_IPDUMMY;
    	
	*ptr     = 0x0000BEAF;
	*(ptr+1) = 0x000BEAF0;
	*(ptr+2) = 0x00BEAF00;
	*(ptr+3)= 0x0BEAF000;


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

    	for (i = 0; i < MAX_DATA; i++){
        	//x = (char*)data[i];
		print("\n");
		//print_uint32(i);
		//ptr = &data[i];
		//*ptr = i;
		//*(ptr + AIP_CONFIG) = 0; // CFG,DATAIN,0b00000,64,W,Mem Data In
		*(ptr + AIP_DATAIN) = (uint32_t) (0x10 + i);

    	}
    	*(ptr + AIP_START)  = 1;
	print("aip_writeData!\n");

	//for (i = 0; i < 100; i++){
	for (i = 0; i < 100000; i++){
		__asm__ volatile ("nop");//asm volatile("");    	        
	}
        


    	reg_leds = 31;
	

	reg_leds = 1;
	print("\n");

	while (1)
	{
		if(reg_leds<128)
			reg_leds = reg_leds + 1;
		else
			reg_leds = 1;	
		//for (int rep = 200; rep > 0; rep--)
			for (int rep = 100000; rep > 0; rep--)
		{
			__asm__ volatile ("nop");//asm volatile("");
		}
	}

}


// --------------------------------------------------------
uint8_t aip_writeData (aip_regs * port, uint8_t config, uint32_t * data, uint32_t size)
{
    if(!size) return 1;

    port->aip_config = config;
    
    for (uint32_t i = 0; i < size; i++)
    {
        port->aip_dataIn = *(data+i);
    }
    
    return 0;
}

uint8_t aip_readData (aip_regs * port, uint8_t config, uint32_t * data, uint32_t size)
{
    if(!size) return 1;

    port->aip_config = config;
    
    for (uint32_t i = 0; i < size; i++)
    {
        *(data+i) = port->aip_dataOut;
    }
    
    return 0;
}

uint8_t aip_start (aip_regs * port)
{
    port->aip_start = 0x1;

    __asm__ volatile ("nop");//asm volatile("");

    //port->aip_start = 3;
        
    return 0;
}

