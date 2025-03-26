#include "aip.h"

#define AIP_CONFIG_STATUS             30
#define AIP_CONFIG_ID                 31
#define AIP_STATUS_MASK_NU            0xff000000
#define AIP_STATUS_MASK_MASK          0x00ff0000
#define AIP_STATUS_MASK_NOTIFICATION  0x0000ff00
#define AIP_STATUS_MASK_INT           0x000000ff
#define AIP_STATUS_SHIFT_NU           24
#define AIP_STATUS_SHIFT_MASK         16
#define AIP_STATUS_SHIFT_NOTIFICATION 80
#define AIP_STATUS_SHIFT_INT          0

#define AIP_DATAOUT  0
#define AIP_DATAIN   1
#define AIP_CONFIG   2
#define AIP_START    3
#define AIP_STATUS   30
#define AIP_IPID     31


typedef struct aip_portConfig
{
    uint8_t amount;
    aip_config_t *configs;
} aip_portConfig_t;


static const uint32_t AIP_PORT_BASE[] =
{
    AIP0,
	AIP1,
};

static aip_portConfig_t aip_portConfigs [AIP_PORTS];

static uint8_t aip_aipRead (void *baseAddr, uint32_t config, uint32_t *data, uint32_t size);

static uint8_t aip_aipWrite (void *baseAddr, uint32_t config, uint32_t *data, uint32_t size);

static uint8_t aip_aipStart (void *baseAddr);

//static uint32_t  aip_getPortAdders (void *aipBaseAddr, uint32_t *aipBaseAddr);
/*
int8_t aip_init (void *aipBaseAddr, aip_config_t *aip_configs, uint32_t configAmount)
{
    aip_portConfigs[aipPort].amount = configAmount;

    aip_portConfigs[aipPort].configs = aip_configs;

    return 0;
}
*/
int8_t aip_readMem (void *aipBaseAddr, uint32_t configMem, uint32_t* dataRead, uint32_t amountData, uint32_t offset)
{
    //uint32_t aipBaseAddr = 0;

    // aip_getPortAdders(aipPort, &aipBaseAddr);

    /* set addrs */
    aip_aipWrite(aipBaseAddr, configMem+1, &offset, 1);

    /* write data */
    aip_aipRead(aipBaseAddr, configMem, dataRead, amountData);

    return 0;
}

int8_t aip_writeMem (void *aipBaseAddr, uint32_t configMem, uint32_t* dataWrite, uint32_t amountData, uint32_t offset)
{
    //uint32_t aipBaseAddr = 0;

    // aip_getPortAdders(aipPort, &aipBaseAddr);

    /* set addrs */
    aip_aipWrite(aipBaseAddr, configMem+1, &offset, 1);

    /* write data */
    aip_aipWrite(aipBaseAddr, configMem, dataWrite, amountData);

    return 0;
}

int8_t aip_writeConfReg (void *aipBaseAddr, uint32_t configConfReg, uint32_t* dataWrite, uint32_t amountData, uint32_t offset)
{
    //uint32_t aipBaseAddr = 0;

    // aip_getPortAdders(aipPort, &aipBaseAddr);

    /* set addrs */
    aip_aipWrite(aipBaseAddr, configConfReg+1, &offset, 1);

    /* write data */
    aip_aipWrite(aipBaseAddr, configConfReg, dataWrite, amountData);

    return 0;
}

int8_t aip_start (void *aipBaseAddr)
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
    //uint32_t aipBaseAddr = 0;

    // aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipStart(aipBaseAddr);

    /*
        IOWR_ALTERA_AVALON_TIMER_SNAP_0 (TIMER_0_BASE, 0);
        snap_0 = IORD(TIMER_0_BASE, 6) & ALTERA_AVALON_TIMER_SNAP_0_MSK;
        snap_1 = IORD(TIMER_0_BASE, 7) & ALTERA_AVALON_TIMER_SNAP_0_MSK;
        snap_2 = IORD(TIMER_0_BASE, 8) & ALTERA_AVALON_TIMER_SNAP_0_MSK;
        snap_3 = IORD(TIMER_0_BASE, 9) & ALTERA_AVALON_TIMER_SNAP_0_MSK;

        end = (0xFFFFFFFFFFFFFFFFULL - ( (snap_3 << 48) | (snap_2 << 32) | (snap_1 << 16) | (snap_0) ));
        elapsed_time = end - start;
        printf("Tiempo de ejecucion aip_start: %llu ticks\n", elapsed_time);
    */

    return 0;
}

int8_t aip_getID (void *aipBaseAddr, uint32_t *id)
{
    ////uint32_t aipBaseAddr = 0;

    //// aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipRead(aipBaseAddr, AIP_IPID, id, 1);

    return 0;
}

int8_t aip_getStatus (void *aipBaseAddr, uint32_t* status)
{
    //uint32_t aipBaseAddr = 0;

    // aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipRead(aipBaseAddr, AIP_STATUS, status, 1);

    return 0;
}

int8_t aip_enableINT (void *aipBaseAddr, uint32_t idxInt)
{
    uint32_t status = 0;

    //uint32_t aipBaseAddr = 0;

    // aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipRead (aipBaseAddr, AIP_STATUS, &status, 1);

    status &= AIP_STATUS_MASK_MASK;

    status |= (1 << (idxInt+AIP_STATUS_SHIFT_MASK));

    aip_aipWrite(aipBaseAddr, AIP_STATUS, &status, 1);

    return 0;
}

int8_t aip_disableINT (void *aipBaseAddr, uint32_t idxInt)
{
    uint32_t status = 0;

    //uint32_t aipBaseAddr = 0;

    // aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipRead (aipBaseAddr, AIP_STATUS, &status, 1);

    status &= AIP_STATUS_MASK_MASK;

    status &= ~(uint32_t)(1 << (idxInt+AIP_STATUS_SHIFT_MASK));

    aip_aipWrite(aipBaseAddr, AIP_STATUS, &status, 1);

    return 0;
}

int8_t aip_clearINT (void *aipBaseAddr, uint32_t idxInt)
{
    uint32_t status = 0;

    //uint32_t aipBaseAddr = 0;

    // aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipRead(aipBaseAddr, AIP_STATUS, &status, 1);

    status = (status & (AIP_STATUS_MASK_NU | AIP_STATUS_MASK_MASK | AIP_STATUS_MASK_NOTIFICATION)) | (uint32_t)(1 << idxInt);

    aip_aipWrite(aipBaseAddr, AIP_STATUS, &status, 1);

    return 0;
}

int8_t aip_getINT (void *aipBaseAddr, uint32_t* intVector)
{
    uint32_t status = 0;

    //uint32_t aipBaseAddr = 0;

    // aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipRead (aipBaseAddr, AIP_STATUS, &status, 1);

    *intVector = (uint32_t)(status & AIP_STATUS_MASK_INT);

    return 0;
}

int8_t aip_getNotifications(void *aipBaseAddr, uint32_t* notificationsVector)
{
    uint32_t status = 0;

    //uint32_t aipBaseAddr = 0;

    // aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipRead (aipBaseAddr, AIP_STATUS, &status, 1);

    *notificationsVector = (uint32_t)((status & AIP_STATUS_MASK_NOTIFICATION) >> AIP_STATUS_SHIFT_NOTIFICATION);

    return 0;
}



static uint8_t aip_aipRead (void *aipBaseAddr, uint32_t config, uint32_t *data, uint32_t size )
{

    volatile uint32_t *reg32 = (volatile uint32_t *)aipBaseAddr; 

    reg32[AIP_CONFIG] = config; 

    for (uint32_t i = 0; i < size; i++)
	{
		data[i] = reg32[AIP_DATAOUT];
	}

	return 0 ;
};

static uint8_t aip_aipWrite (void *aipBaseAddr, uint32_t config, uint32_t *data, uint32_t size)
{

    volatile uint32_t *reg32 = (volatile uint32_t *)aipBaseAddr; 

    reg32[AIP_CONFIG] = config;  
		
    for (uint32_t i = 0; i < size; i++) {
        reg32[AIP_DATAIN] = data[i];  
    }    
    
	return 0 ;
};

static uint8_t aip_aipStart (void *aipBaseAddr)
{
    volatile uint32_t *reg32 = (volatile uint32_t *)aipBaseAddr; 

    reg32[AIP_START] = 0x1;  
	return 0 ;
};