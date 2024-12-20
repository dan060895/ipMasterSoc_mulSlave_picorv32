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

#define AIP_IP_INTERACE 0x80000100
// 	.irq_6				(startIPcore),

#define MEM_TOTAL 0x1000 /* 128 KB */

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

    uint32_t *ptrAIP      = (uint32_t*)AIP_IP_INTERACE;
	uint32_t IPID = 0;
	// ---------------- AIP Interface ---------
    print("Reading IPID !\n");
	*(ptrAIP + AIP_CONFIG) = 5;
	IPID = *(ptrAIP + AIP_DATAOUT);
	print_hex(IPID,8);
	print("\n");
	print("\n");
	
	uint32_t value = 0;
	print("aip_writing to Interface MEMIN0 !\n");
	*(ptrAIP + AIP_CONFIG) = 1;  // AMEMIN,0b00011,1,W,We Pointer of MMEMIN
	*(ptrAIP + AIP_DATAIN) = 0x0; // Set ptr MEMIN 7, 
	*(ptrAIP + AIP_CONFIG) = 0;  // MMEMIN,0b00010,1,W,We Pointer of MMEMIN
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);

	print("aip_writing to Interface MEMIN1 !\n");
	*(ptrAIP + AIP_CONFIG) = 3;  // AMEMIN,0b00011,1,W,We Pointer of MMEMIN
	*(ptrAIP + AIP_DATAIN) = 0x0; // Set ptr MEMIN 7, 
	*(ptrAIP + AIP_CONFIG) = 2;  // MMEMIN,0b00010,1,W,We Pointer of MMEMIN
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	*(ptrAIP + AIP_START)  = 1;
	
    print("aip reading to CONFIGREG Interface !\n");
	*(ptrAIP + AIP_CONFIG) = 9;  // AMEMOUT,0b00011,1,W,We Pointer of MMEMOUT
	*(ptrAIP + AIP_DATAIN) = 0; // Ste ptr to 0
	*(ptrAIP + AIP_CONFIG) = 8;  // CFG,MMEMOUT,0b00010,8,W
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);
	value = *(ptrAIP + AIP_DATAOUT);
	print_hex(value,8);

	print("aip writing to MEMOUT0 Interface !\n");
	*(ptrAIP + AIP_CONFIG) = 5;  // AMEMOUT,0b00011,1,W,We Pointer of MMEMOUT
	*(ptrAIP + AIP_DATAIN) = 0; // Ste ptr to 0
	*(ptrAIP + AIP_CONFIG) = 4;  // CFG,MMEMOUT,0b00010,8,W
    *(ptrAIP + AIP_DATAIN) = 0xA;
	*(ptrAIP + AIP_DATAIN) = 0xB;
	*(ptrAIP + AIP_DATAIN) = 0xC;
	*(ptrAIP + AIP_DATAIN) = 0xD;
	*(ptrAIP + AIP_DATAIN) = 0xE;
	*(ptrAIP + AIP_DATAIN) = 0xD;
	*(ptrAIP + AIP_CONFIG) = 5;  // AMEMOUT,0b00011,1,W,We Pointer of MMEMOUT
	*(ptrAIP + AIP_DATAIN) = 3; // Ste ptr to 0
	*(ptrAIP + AIP_CONFIG) = 4;  // CFG,MMEMOUT,0b00010,8,W
	*(ptrAIP + AIP_DATAIN) = 0xBEAF;

	print("aip writing to MEMOUT1 Interface !\n");
	*(ptrAIP + AIP_CONFIG) = 7;  // AMEMOUT,0b00011,1,W,We Pointer of MMEMOUT
	*(ptrAIP + AIP_DATAIN) = 0; // Ste ptr to 0
	*(ptrAIP + AIP_CONFIG) = 6;  // CFG,MMEMOUT,0b00010,8,W
    *(ptrAIP + AIP_DATAIN) = 0xA;
	*(ptrAIP + AIP_DATAIN) = 0xB;
	*(ptrAIP + AIP_DATAIN) = 0xC;
	*(ptrAIP + AIP_DATAIN) = 0xD;
	*(ptrAIP + AIP_DATAIN) = 0xE;
	*(ptrAIP + AIP_DATAIN) = 0xD;
	*(ptrAIP + AIP_CONFIG) = 5;  // AMEMOUT,0b00011,1,W,We Pointer of MMEMOUT
	*(ptrAIP + AIP_DATAIN) = 8; // Ste ptr to 0
	*(ptrAIP + AIP_CONFIG) = 4;  // CFG,MMEMOUT,0b00010,8,W
	*(ptrAIP + AIP_DATAIN) = 0xBEAF;

	for (i = 0; i < 100; i++){
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
		for (int rep = 200; rep > 0; rep--)
		//	for (int rep = 100000; rep > 0; rep--)
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

