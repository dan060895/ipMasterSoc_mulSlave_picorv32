#include "firmware.h"
#include <stdbool.h>
#include <stdint.h>
#include "string.h"
#include "custom_ops.S"
#include "ID00001001_dummy.h"

#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)
#define reg_leds (*(volatile uint32_t*)0x03000000)

#define MEM_TOTAL 0x1000 /* 128 KB */
#define AIP_IP_IPDUMMY0 0x80000100
#define AIP_IP_IPDUMMY1 0x81000100
#define AIP_IP_IPDUMMY2 0x82000100
#define AIP_IP_GPIO    	0x83000100


#define AIP_DATAOUT  0
#define AIP_DATAIN   1
#define AIP_CONFIG   2
#define AIP_START    3

#define DUMMY_MEM_SIZE 16
#define DUMMY_PORT (void *)0x80000100


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

    print("start.\n");

	uint32_t dataFlit = 0;
    uint32_t dataFlits[DUMMY_MEM_SIZE];

    ID00001001_init(DUMMY_PORT);

    ID00001001_getStatus(DUMMY_PORT, &dataFlit);

    for (uint32_t i = 0; i < DUMMY_MEM_SIZE; i++)
    {
        dataFlits[i] = 1<<i;
    }

    ID00001001_writeData(DUMMY_PORT, dataFlits, DUMMY_MEM_SIZE, 0);
#define DEBUG_DELAY 0

#if DEBUG_DELAY
    ID00001001_enableDelay(DUMMY_PORT, 5000);

    ID00001001_getStatus(DUMMY_PORT, &dataFlit);
#endif 

    ID00001001_startIP(DUMMY_PORT);

    ID00001001_getStatus(DUMMY_PORT, &dataFlit);

    ID00001001_waitDone(DUMMY_PORT);

    ID00001001_getStatus(DUMMY_PORT, &dataFlit);

    for (uint32_t i = 0; i < DUMMY_MEM_SIZE; i++)
    {
        dataFlits[i] = 0;
    }

    
    ID00001001_readData(DUMMY_PORT, dataFlits, DUMMY_MEM_SIZE, 0);
	print("MEMOUT \n");

	for (uint32_t i = 0; i < DUMMY_MEM_SIZE; i++)
    {
		print("Dat[");
        print_dec(i);
		print("]:");
		print_hex(dataFlits[i],2);
		print("\n");
    }


#if DEBUG_DELAY
   // ID00001001_disableDelay(DUMMY_PORT);

   // ID00001001_getStatus(DUMMY_PORT, &dataFlit);
#endif

    while (1)
	{
 		/*
		if(reg_leds<128)
			reg_leds = reg_leds + 1;
		else
			reg_leds = 1;	
		*/
		//for (int rep = 100000; rep > 0; rep--)
		
		for (int rep = 100; rep > 0; rep--)
		{
			__asm__ volatile ("nop");//asm volatile("");
		}
	
	}
}
