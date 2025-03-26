#include "ID00001001_dummy.h"
#include "aip.h"
#include <stdint.h>
#include "firmware.h"
//#include <stdio.h>

#define ID00001001_STATUS_BITS 8
#define ID00001001_STATUS_BIT_DONE 0
#define ID00001001_CONFIG_AMOUNT 5

#define MDATAIN    0
#define MDATAOUT   2
#define CDELAY     4
#define STATUS     30
#define IPID       31
/*
static aip_config_t ID00001001_csv [] = {
    {"MDATAIN", 0, 'W', 64},
    {"MDATAOUT", 2, 'R', 64},
    {CDELAY, 4, 'W', 1},
    {"STATUS", 30, 'B', 1},
    {"IPID", 31, 'R', 1}
};
*/

static int32_t ID00001001_clearStatus(void *aipBaseAddr);


int32_t ID00001001_init(void *aipBaseAddr)
{
    uint32_t id;

    //aip_init((void *)aipBaseAddr, ID00001001_csv, ID00001001_CONFIG_AMOUNT);

    aip_getID(aipBaseAddr, &id);
   //print("ID");
   //print_hex(id,8);
   // ID00001001_clearStatus((void *)aipBaseAddr);

    return 0;
}

int32_t ID00001001_enableDelay(void *aipBaseAddr, uint32_t msec)
{
    uint32_t delay = 0;

    delay = (msec << 1) | 1;

    aip_writeConfReg(aipBaseAddr, CDELAY, &delay, 1, 0);

    aip_enableINT(aipBaseAddr, ID00001001_STATUS_BIT_DONE);

    return 0;
}

int32_t ID00001001_disableDelay(void *aipBaseAddr)
{
    uint32_t delay = 0;

    aip_writeConfReg(aipBaseAddr, CDELAY, &delay, 1, 0);

    aip_disableINT(aipBaseAddr, 0);
        
    aip_clearINT(aipBaseAddr, 0);

    return 0;
}

int32_t ID00001001_startIP(void *aipBaseAddr)
{
	/*
	alt_u64 elapsed_time, start, end, snap_0, snap_1, snap_2, snap_3;

    IOWR_ALTERA_AVALON_TIMER_SNAP_0 (TIMER_0_BASE, 0);
    snap_0 = IORD(TIMER_0_BASE, 6) & ALTERA_AVALON_TIMER_SNAP_0_MSK;
    snap_1 = IORD(TIMER_0_BASE, 7) & ALTERA_AVALON_TIMER_SNAP_0_MSK;
    snap_2 = IORD(TIMER_0_BASE, 8) & ALTERA_AVALON_TIMER_SNAP_0_MSK;
    snap_3 = IORD(TIMER_0_BASE, 9) & ALTERA_AVALON_TIMER_SNAP_0_MSK;

    start = (0xFFFFFFFFFFFFFFFFULL - ( (snap_3 << 48) | (snap_2 << 32) | (snap_1 << 16) | (snap_0) ));
*/

    aip_start(aipBaseAddr);

/*
    IOWR_ALTERA_AVALON_TIMER_SNAP_0 (TIMER_0_BASE, 0);
    snap_0 = IORD(TIMER_0_BASE, 6) & ALTERA_AVALON_TIMER_SNAP_0_MSK;
    snap_1 = IORD(TIMER_0_BASE, 7) & ALTERA_AVALON_TIMER_SNAP_0_MSK;
    snap_2 = IORD(TIMER_0_BASE, 8) & ALTERA_AVALON_TIMER_SNAP_0_MSK;
    snap_3 = IORD(TIMER_0_BASE, 9) & ALTERA_AVALON_TIMER_SNAP_0_MSK;

    end = (0xFFFFFFFFFFFFFFFFULL - ( (snap_3 << 48) | (snap_2 << 32) | (snap_1 << 16) | (snap_0) ));
    elapsed_time = end - start;
    printf("Tiempo de ejecucion ID00001001_startIP: %llu ticks\n", elapsed_time);

*/
    return 0;
}

int32_t ID00001001_writeData(void *aipBaseAddr, uint32_t *data, uint32_t size, uint32_t offset)
{
    aip_writeMem(aipBaseAddr, MDATAIN, data, size, offset);

    return 0;
}

int32_t ID00001001_readData(void *aipBaseAddr, uint32_t *data, uint32_t size, uint32_t offset)
{
    aip_readMem(aipBaseAddr, MDATAOUT, data, size, offset);

    return 0;
}

int32_t ID00001001_getStatus(void *aipBaseAddr, uint32_t *status)
{
    aip_getStatus(aipBaseAddr, status);

    return 0;
}

int32_t ID00001001_waitDone(void *aipBaseAddr)
{
    uint32_t statusINT = 0;

    do
    {
        aip_getINT(aipBaseAddr, &statusINT);
    } while (!(statusINT && 0x1));

    return 0;
}

static int32_t ID00001001_clearStatus(void *aipBaseAddr)
{
    for(uint32_t i = 0; i < ID00001001_STATUS_BITS; i++)
    {
        aip_disableINT(aipBaseAddr, i);
        
        aip_clearINT(aipBaseAddr, i);
    }

    return 0;
}