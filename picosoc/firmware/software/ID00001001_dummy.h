#ifndef ID00001001_DUMMY_H_
#define ID00001001_DUMMY_H_

#include <stdint.h>

int32_t ID00001001_init(void *aipBaseAddr);

int32_t ID00001001_enableDelay(void *aipBaseAddr, uint32_t msec);

int32_t ID00001001_disableDelay(void *aipBaseAddr);

int32_t ID00001001_startIP(void *aipBaseAddr);

int32_t ID00001001_writeData(void *aipBaseAddr, uint32_t *data, uint32_t size, uint32_t offset);

int32_t ID00001001_readData(void *aipBaseAddr, uint32_t *data, uint32_t size, uint32_t offset);

int32_t ID00001001_getStatus(void *aipBaseAddr, uint32_t *status);

int32_t ID00001001_waitDone(void *aipBaseAddr);

#endif //ID00001001_DUMMY_H_
