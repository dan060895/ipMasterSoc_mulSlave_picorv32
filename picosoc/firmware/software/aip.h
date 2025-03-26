/*
 * aip.h
 *
 *  Created on: Feb 2, 2024
 *      Author: Daniel Abisaid Hernandez
 */

#ifndef AIP_H_
#define AIP_H_

#include <stdint.h>
#include "syscfg.h"

#define AIP_PORT_1 1
#define AIP_PORT_2 2
#define AIP_PORT_3 3

#define MNEMONIC_MAX_LEN 16

typedef struct aip_config
{
    char mnemonic[MNEMONIC_MAX_LEN];
    uint8_t config;
    uint8_t mode;
    uint8_t size;
} aip_config_t;

typedef struct aip_regs
{
    uint32_t aip_dataOut;
    uint32_t aip_dataIn;
    uint32_t aip_config;
    uint32_t aip_start;
} aip_regs_t;

int8_t aip_init (void *aipBaseAddr, aip_config_t *aip_configs, uint32_t configAmount);

int8_t aip_readMem (void *aipBaseAddr, uint32_t configMem, uint32_t* dataRead, uint32_t amountData, uint32_t offset);

int8_t aip_writeMem (void *aipBaseAddr, uint32_t configMem, uint32_t* dataWrite, uint32_t amountData, uint32_t offset);

int8_t aip_writeConfReg (void *aipBaseAddr, uint32_t configConfReg, uint32_t* dataWrite, uint32_t amountData, uint32_t offset);

int8_t aip_start (void *aipBaseAddr);

//int8_t aip_getID (void *aipBaseAddr, uint32_t *id);
int8_t aip_getID (void *aipBaseAddr, uint32_t *id);


int8_t aip_getStatus (void *aipBaseAddr, uint32_t* status);

int8_t aip_enableINT (void *aipBaseAddr, uint32_t idxInt);
//int8_t aip_enableINT (void *aipBaseAddr, uint32_t idxInt, void (*callback)());

int8_t aip_disableINT (void *aipBaseAddr, uint32_t idxInt);

int8_t aip_clearINT (void *aipBaseAddr, uint32_t idxInt);

int8_t aip_getINT (void *aipBaseAddr, uint32_t* intVector);

int8_t aip_getNotifications(void *aipBaseAddr, uint32_t* notificationsVector);

#endif /* AIP_H_ */
