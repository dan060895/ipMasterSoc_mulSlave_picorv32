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

static int32_t ID00001001_clearStatus(uint8_t port);


int32_t ID00001001_init(uint8_t port)
{
    uint32_t id;

    //aip_init(port, ID00001001_csv, ID00001001_CONFIG_AMOUNT);

    aip_getID(port, &id);
    print("ID");
    print_hex(id,8);
    ID00001001_clearStatus(port);

    return 0;
}

int32_t ID00001001_enableDelay(uint8_t port, uint32_t msec)
{
    uint32_t delay = 0;

    delay = (msec << 1) | 1;

    aip_writeConfReg(port, CDELAY, &delay, 1, 0);

    //aip_enableINT(port, ID00001001_STATUS_BIT_DONE);

    return 0;
}

int32_t ID00001001_disableDelay(uint8_t port)
{
    uint32_t delay = 0;

    aip_writeConfReg(port, CDELAY, &delay, 1, 0);

    aip_disableINT(port, 0);
        
    aip_clearINT(port, 0);

    return 0;
}

int32_t ID00001001_startIP(uint8_t port)
{
    aip_start(port);

    return 0;
}

int32_t ID00001001_writeData(uint8_t port, uint32_t *data, uint32_t size, uint32_t offset)
{
    aip_writeMem(port, MDATAIN, data, size, offset);

    return 0;
}

int32_t ID00001001_readData(uint8_t port, uint32_t *data, uint32_t size, uint32_t offset)
{
    aip_readMem(port, MDATAOUT, data, size, offset);

    return 0;
}

int32_t ID00001001_getStatus(uint8_t port, uint32_t *status)
{
    aip_getStatus(port, status);

    return 0;
}

int32_t ID00001001_waitDone(uint8_t port)
{
    uint8_t statusINT = 0;

    do
    {
        aip_getINT(port, &statusINT);
    } while (!(statusINT && 0x1));

    return 0;
}

static int32_t ID00001001_clearStatus(uint8_t port)
{
    for(uint8_t i = 0; i < ID00001001_STATUS_BITS; i++)
    {
        aip_disableINT(port, i);
        
        aip_clearINT(port, i);
    }

    return 0;
}
