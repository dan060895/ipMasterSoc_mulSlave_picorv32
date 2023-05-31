// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

#include "firmware.h"
#include <stdint.h>

#define OUTPORT_A 0x20000000

void hello(void)
{
	print_str("hello world\n");

	char x=0;
	char counter = 0x30;
	for (x=0;x<=9;x++){
		
		print_str(&counter);
		counter = counter +1;
	}
	uint32_t *ptr = (uint32_t*)OUTPORT_A;
	*ptr = 0x0000123F;
	print_str("dsp8bit!\n");
	
}

