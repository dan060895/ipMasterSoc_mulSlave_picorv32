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

static uint8_t aip_aipRead (void *baseAddr, uint8_t config, uint32_t *data, uint16_t size);

static uint8_t aip_aipWrite (void *baseAddr, uint8_t config, uint32_t *data, uint16_t size);

static uint8_t aip_aipStart (void *baseAddr);

static uint8_t aip_getPortAdders (uint8_t aipPort, uint32_t *aipBaseAddr);

int8_t aip_init (uint8_t aipPort, aip_config_t *aip_configs, uint8_t configAmount)
{
    aip_portConfigs[aipPort].amount = configAmount;

    aip_portConfigs[aipPort].configs = aip_configs;

    return 0;
}

int8_t aip_readMem (uint8_t aipPort, uint8_t configMem, uint32_t* dataRead, uint16_t amountData, uint32_t offset)
{
    uint32_t aipBaseAddr = 0;

    aip_getPortAdders(aipPort, &aipBaseAddr);

    /* set addrs */
    aip_aipWrite((void *)aipBaseAddr, configMem+1, &offset, 1);

    /* write data */
    aip_aipRead((void *)aipBaseAddr, configMem, dataRead, amountData);

    return 0;
}

int8_t aip_writeMem (uint8_t aipPort, uint8_t configMem, uint32_t* dataWrite, uint16_t amountData, uint32_t offset)
{
    uint32_t aipBaseAddr = 0;

    aip_getPortAdders(aipPort, &aipBaseAddr);

    /* set addrs */
    aip_aipWrite((void *)aipBaseAddr, configMem+1, &offset, 1);

    /* write data */
    aip_aipWrite((void *)aipBaseAddr, configMem, dataWrite, amountData);

    return 0;
}

int8_t aip_writeConfReg (uint8_t aipPort, uint8_t configConfReg, uint32_t* dataWrite, uint16_t amountData, uint32_t offset)
{
    uint32_t aipBaseAddr = 0;

    aip_getPortAdders(aipPort, &aipBaseAddr);

    /* set addrs */
    aip_aipWrite((void *)aipBaseAddr, configConfReg+1, &offset, 1);

    /* write data */
    aip_aipWrite((void *)aipBaseAddr, configConfReg, dataWrite, amountData);

    return 0;
}

int8_t aip_start (uint8_t aipPort)
{
    uint32_t aipBaseAddr = 0;

    aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipStart((void *)aipBaseAddr);

    return 0;
}

int8_t aip_getID (uint8_t aipPort, uint32_t *id)
{
    uint32_t aipBaseAddr = 0;

    aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipRead((void *)aipBaseAddr, AIP_IPID, id, 1);

    return 0;
}

int8_t aip_getStatus (uint8_t aipPort, uint32_t* status)
{
    uint32_t aipBaseAddr = 0;

    aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipRead((void *)aipBaseAddr, AIP_STATUS, status, 1);

    return 0;
}

int8_t aip_enableINT (uint8_t aipPort, uint8_t idxInt)
{
    uint32_t status = 0;

    uint32_t aipBaseAddr = 0;

    aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipRead ((void *)aipBaseAddr, AIP_STATUS, &status, 1);

    status &= AIP_STATUS_MASK_MASK;

    status |= (1 << (idxInt+AIP_STATUS_SHIFT_MASK));

    aip_aipWrite((void *)aipBaseAddr, AIP_STATUS, &status, 1);

    return 0;
}

int8_t aip_disableINT (uint8_t aipPort, uint8_t idxInt)
{
    uint32_t status = 0;

    uint32_t aipBaseAddr = 0;

    aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipRead ((void *)aipBaseAddr, AIP_STATUS, &status, 1);

    status &= AIP_STATUS_MASK_MASK;

    status &= ~(uint32_t)(1 << (idxInt+AIP_STATUS_SHIFT_MASK));

    aip_aipWrite((void *)aipBaseAddr, AIP_STATUS, &status, 1);

    return 0;
}

int8_t aip_clearINT (uint8_t aipPort, uint8_t idxInt)
{
    uint32_t status = 0;

    uint32_t aipBaseAddr = 0;

    aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipRead((void *)aipBaseAddr, AIP_STATUS, &status, 1);

    status = (status & (AIP_STATUS_MASK_NU | AIP_STATUS_MASK_MASK | AIP_STATUS_MASK_NOTIFICATION)) | (uint32_t)(1 << idxInt);

    aip_aipWrite((void *)aipBaseAddr, AIP_STATUS, &status, 1);

    return 0;
}

int8_t aip_getINT (uint8_t aipPort, uint8_t* intVector)
{
    uint32_t status = 0;

    uint32_t aipBaseAddr = 0;

    aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipRead ((void *)aipBaseAddr, AIP_STATUS, &status, 1);

    *intVector = (uint8_t)(status & AIP_STATUS_MASK_INT);

    return 0;
}

int8_t aip_getNotifications(uint8_t aipPort, uint8_t* notificationsVector)
{
    uint32_t status = 0;

    uint32_t aipBaseAddr = 0;

    aip_getPortAdders(aipPort, &aipBaseAddr);

    aip_aipRead ((void *)aipBaseAddr, AIP_STATUS, &status, 1);

    *notificationsVector = (uint8_t)((status & AIP_STATUS_MASK_NOTIFICATION) >> AIP_STATUS_SHIFT_NOTIFICATION);

    return 0;
}

static uint8_t aip_aipRead (void *baseAddr, uint8_t config, uint32_t *data, uint16_t size )
{

    volatile uint32_t *reg32 = (volatile uint32_t *)baseAddr; 

    reg32[AIP_CONFIG] = config; 

    for (uint32_t i = 0; i < size; i++)
	{
		data[i] = reg32[AIP_DATAOUT];
	}

	return 0 ;
};

static uint8_t aip_aipWrite (void *baseAddr, uint8_t config, uint32_t *data, uint16_t size)
{

    volatile uint32_t *reg32 = (volatile uint32_t *)baseAddr; 

    reg32[AIP_CONFIG] = config;  
		
    for (uint32_t i = 0; i < size; i++) {
        reg32[AIP_DATAIN] = data[i];  
    }    
    
	return 0 ;
};

static uint8_t aip_aipStart (void *baseAddr)
{
    volatile uint32_t *reg32 = (volatile uint32_t *)baseAddr; 

    reg32[AIP_START] = 0x1;  

	return 0 ;
};

static uint8_t aip_getPortAdders (uint8_t aipPort, uint32_t *aipBaseAddr)
{
    *aipBaseAddr = AIP_PORT_BASE[aipPort];

    return 0;
}

