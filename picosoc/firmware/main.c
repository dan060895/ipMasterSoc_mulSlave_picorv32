#include "firmware.h"
#include <stdbool.h>
#include <stdint.h>
#include "custom_ops.S"

#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)
#define reg_leds (*(volatile uint32_t*)0x03000000)

#define MEM_TOTAL 0x1000 /* 128 KB */
#define AIP_IP_IPDUMMY 0x80000100
#define AIP_IP_GPIO    0x81000100
#define AIP_IP_PWM     0x82000100
#define AIP_IP_UART    0x83000100


#define AIP_DATAOUT  0
#define AIP_DATAIN   1
#define AIP_CONFIG   2
#define AIP_START    3





void main() {

/*char *logo =

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
    "       PicoSoC with DSP Accelerators\n\n";*/
char *logo =
"                                  #                                          \n"    
"                               *####+.     ,####+                            \n"    
"                             +######&      (######+.                         \n"    
"                          ,#######*    ##/   .&#######                       \n"    
"                        &###(##&    *#######    #######+                     \n"    
"                     ,#######/    ############/    +#####+                   \n"    
"                   ########    ,######*   #######    #######+.               \n"    
"                ,#######/    (######        ,######*   .+#####(#             \n"    
"              &######+    *######*             (######    #######+           \n"    
"           ,######(/       ,######*           #######        +######+        \n"    
"         +####(#+             #######      ,######/            ########.     \n"    
"      ,+######(    (###         *######*  .#####         ####*   .######((   \n"    
"    +######+    ,########/         (######   ,        *#########    #######+ \n"    
" ,######(/    #######(######         ,######*       #######*######*    +######+ \n" 
" #####&    ,######*    ,######.  ,###   ######+  ,######/     #######    #####((\n" 
"   .(    (######          #(   (######    *#*  (######          *######*   .&   \n" 
"       ######/              ,######*        ,######/               ######(      \n" 
"   .(    #######          #######  .##*   #######   /#          *######*   .&   \n" 
" #####&    ,######*    .######/   #######  ###/   ######*     #######    #####(/\n" 
" ,#######/    #######(######        /######*        #######*######/    +######+ \n" 
"    +######+    ,########/        ./   #######        *#########    #######+    \n" 
"      ,#######/    (###.        /#####   *######*        ####*   .+#####(#      \n" 
"         +######&            .#######       #######            #######+.        \n" 
"           ,######(/       /######.           *######*       +######&           \n" 
"              &######+    *######*             (######.   (######+              \n" 
"                ,#######/    #######        .######(   .+#####(#                \n" 
"                   +######&    *######/   (######,   (######+.                  \n" 
"                     *#######/    #############    +#####(&                     \n" 
"                        &######&    *#######.   (######+                        \n" 
"                          *#######*    ##(   .&#######                          \n" 
"                             +######&      (######+.                     \n"       
"                               *####+.     ,####+                        \n"       
"                                 +                                       \n"       
"\n"       
"        ####       .(############(,                         ###(    (###.\n"       
"        ####     (###################.                      ###(    (###.\n"       
"        ####     ####             ####       ,############  ###(    (###.\n"       
"        ####     ###(             ,###*    ###############  ###(    (###.\n"       
"        ####     ###(             (###.   ####              ###(    (###.\n"       
"        ####     #### ###############*    ####              ###(    (###.\n"       
"        ####     ###( (###########/       (###/             ###(    (###.\n"       
"        ####     ####                      *###################.    (###.\n"       
"        ####     ###(                         ,(############*       /###.\n" 
"\n"  
"                       PicoSoC with DSP Accelerators\n\n";

    uint32_t *ptr      = (uint32_t*)AIP_IP_IPDUMMY;
    uint32_t *ptrGPIO  = (uint32_t*)AIP_IP_GPIO;
    uint32_t *ptrPWM   = (uint32_t*)AIP_IP_PWM;
	uint32_t *ptrUART  = (uint32_t*)AIP_IP_UART;

    reg_uart_clkdiv = 104;//5208 for 9600;//104 is 12 MHz for 115200, and 434 is 50Mhz for 115200
    reg_leds = 63;
    //print(logo);

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


	// ---------------- AIP UART ---------
	*(ptrUART + AIP_CONFIG) = 5;
	IPID = *(ptrUART + AIP_DATAOUT);
	print_hex(IPID,8);
  	/*      id0000100a_MDATAIN0 = 5'd0, first 8 bits MEMIN @0x00 is TX_BYTE Register
            id0000100a_ADATAIN0 = 5'd1,
            id0000100a_MMEMOUT0 = 5'd2, first 8 bits MEMOUT @0x00 is TX_BYTE Register
            id0000100a_AMEMOUT0 = 5'd3,
            id0000100a_CCONFREG = 5'd4, bit [16] os LOAD baudrate, [15:0] is BaudRateBits = ClockSource/BaudRate Target
            id0000100a_ACONFREG = 5'd5,*/
	*(ptrUART + AIP_CONFIG) = 5;  // ACONFREG 0b00011,1,W,We Pointer of MMEMIN
	*(ptrUART + AIP_DATAIN) = 0x0; // Set ptr CCONFREG 0,
    *(ptrUART + AIP_CONFIG) = 4;  // ACONFREG 0b00011,1,W,We Pointer of MMEMIN
	*(ptrUART + AIP_DATAIN) = 0; // Set ptr CCONFREG 0 --- MODER_Register - 0x0000_00000, standby state

	*(ptrUART + AIP_CONFIG) = 5;  // ACONFREG 0b00011,1,W,We Pointer of MMEMIN
	*(ptrUART + AIP_DATAIN) = 0x0; // Set ptr CCONFREG 0,
    *(ptrUART + AIP_CONFIG) = 4;  // ACONFREG 0b00011,1,W,We Pointer of MMEMIN
	*(ptrUART + AIP_DATAIN) = 0x00010068;//0x000101B2; // Set ptr CCONFREG 0 --- MODER_Register - 0x0001_01B2, 0x1b2 is 115200 baudrate, 0x068 is 115200 for 12MHz

	*(ptrUART + AIP_CONFIG) = 1;  // AMEMIN,0b00011,1,W,We Pointer of MMEMIN
	*(ptrUART + AIP_DATAIN) = 0x0; // Set ptr MEMIN 0, 
	*(ptrUART + AIP_CONFIG) = 0;  // MMEMIN,0b00010,1,W,We Pointer of MMEMIN
	*(ptrUART + AIP_DATAIN) = 0x00000048;//"H"; // Configuring GPIO as AF
	*(ptrUART + AIP_START)  = 1;

	*(ptrUART + AIP_CONFIG) = 1;  // AMEMIN,0b00011,1,W,We Pointer of MMEMIN
	*(ptrUART + AIP_DATAIN) = 0x0; // Set ptr MEMIN 0, 
	*(ptrUART + AIP_CONFIG) = 0;  // MMEMIN,0b00010,1,W,We Pointer of MMEMIN
	*(ptrUART + AIP_DATAIN) = 0x0000004F;//"O"; // Configuring GPIO as AF
	*(ptrUART + AIP_START)  = 1;

	*(ptrUART + AIP_CONFIG) = 1;  // AMEMIN,0b00011,1,W,We Pointer of MMEMIN
	*(ptrUART + AIP_DATAIN) = 0x0; // Set ptr MEMIN 0, 
	*(ptrUART + AIP_CONFIG) = 0;  // MMEMIN,0b00010,1,W,We Pointer of MMEMIN
	*(ptrUART + AIP_DATAIN) = 0x0000004C;//"L"; // Configuring GPIO as AF
	*(ptrUART + AIP_START)  = 1;

	*(ptrUART + AIP_CONFIG) = 1;  // AMEMIN,0b00011,1,W,We Pointer of MMEMIN
	*(ptrUART + AIP_DATAIN) = 0x0; // Set ptr MEMIN 0, 
	*(ptrUART + AIP_CONFIG) = 0;  // MMEMIN,0b00010,1,W,We Pointer of MMEMIN
	*(ptrUART + AIP_DATAIN) = 0x00000041;//"A"; // Configuring GPIO as AF
	*(ptrUART + AIP_START)  = 1;

	*(ptrUART + AIP_CONFIG) = 30;  // ACONFREG 0b00011,1,W,We Pointer of MMEMIN
	*(ptrUART + AIP_DATAIN) = 0x0; // Set ptr CCONFREG 0,
   	uint32_t status = 0;
	status = *(ptrUART + AIP_DATAOUT);
	print_hex(status,8);
    //_----------------- AIP GPIO --------
    print("Reading IPID GPIO !\n");
	*(ptrGPIO + AIP_CONFIG) = 5;
	IPID = *(ptrGPIO + AIP_DATAOUT);
	print_hex(IPID,8);
	print("\n");
	print("\n");
	
  	/*      id0000100a_MDATAIN0 = 5'd0, ODATA Register
            id0000100a_ADATAIN0 = 5'd1,
            id0000100a_MMEMOUT0 = 5'd2, IDATA Register
            id0000100a_AMEMOUT0 = 5'd3,
            id0000100a_CCONFREG = 5'd4, MODER Register
            id0000100a_ACONFREG = 5'd5,*/
    // 00 input
    // 01 output
    // 10 AF
    // 11 input
	
	print("aip_writing to IPGPIO !\n");
    *(ptrGPIO + AIP_CONFIG) = 5;  // ACONFREG 0b00011,1,W,We Pointer of MMEMIN
	*(ptrGPIO + AIP_DATAIN) = 0x0; // Set ptr CCONFREG 0,
    *(ptrGPIO + AIP_CONFIG) = 4;  // ACONFREG 0b00011,1,W,We Pointer of MMEMIN
	*(ptrGPIO + AIP_DATAIN) = 0x0000AAAA; // Set ptr CCONFREG 0 --- MODER_Register

	*(ptrGPIO + AIP_CONFIG) = 1;  // AMEMIN,0b00011,1,W,We Pointer of MMEMIN
	*(ptrGPIO + AIP_DATAIN) = 0x0; // Set ptr MEMIN 0, 
	*(ptrGPIO + AIP_CONFIG) = 0;  // MMEMIN,0b00010,1,W,We Pointer of MMEMIN
	*(ptrGPIO + AIP_DATAIN) = 0x000012AA; // Configuring GPIO as AF
	*(ptrGPIO + AIP_START)  = 1;
	
	print("aip_reading from IPGPIO !\n");
    *(ptrGPIO + AIP_CONFIG) = 3;  // ACONFREG 0b00011,1,W,We Pointer of MMEMIN
	*(ptrGPIO + AIP_DATAIN) = 0x0; // Set ptr CCONFREG 0,
    *(ptrGPIO + AIP_CONFIG) = 2;  // ACONFREG 0b00011,1,W,We Pointer of MMEMIN
	
    uint32_t IN_GPIO = 0;
	IN_GPIO = *(ptrGPIO + AIP_DATAOUT);
	print_hex(IN_GPIO,8);
	print("\n");
	print("\n");

     //_----------------- AIP PWM --------
    print("Reading IPID PWM !\n");
	*(ptrPWM + AIP_CONFIG) = 5;
	IPID = *(ptrPWM + AIP_DATAOUT);
	print_hex(IPID,8);
	print("\n");
	print("\n");
	

    uint32_t Duty0= 497;
	uint32_t Duty1 = 448;
	uint32_t Duty2= 384;
	uint32_t Duty3 = 256;
	print("configuring PWM !\n");

	*(ptrPWM + AIP_CONFIG) = 1;  // AMEMIN,0b00001,1,W,We Pointer of MMEMIN
	*(ptrPWM + AIP_DATAIN) = 0x0; // Set ptr MEMIN 0, 

	*(ptrPWM + AIP_CONFIG) = 0;  // MMEMIN,0b00000,1,W,We Pointer of MMEMIN
	*(ptrPWM + AIP_DATAIN) = 128; // load_psc
	*(ptrPWM + AIP_DATAIN) = 0; // load_pwm_mode
	*(ptrPWM + AIP_DATAIN) = 512; // load_reload
	*(ptrPWM + AIP_DATAIN) = 2; // load_run  = 32'd2;
	
	*(ptrPWM + AIP_CONFIG) = 3;  // ACONFREG,0b00010,1,W,We Pointer of CONFREG
	*(ptrPWM + AIP_DATAIN) = 0x0; // Set ptr ACONFREG 0, 
	*(ptrPWM + AIP_CONFIG) = 2;  // CONFREG
	print("configuring PWM DutyCicle !\n");
	*(ptrPWM + AIP_DATAIN) = Duty0; // comp_value0
	*(ptrPWM + AIP_DATAIN) = Duty1; // comp_value1
	*(ptrPWM + AIP_DATAIN) = Duty2; // comp_value2
	*(ptrPWM + AIP_DATAIN) = Duty3; // comp_value3

	*(ptrPWM + AIP_START)  = 1;

    while (1)
	{
 		
		if(reg_leds<128)
			reg_leds = reg_leds + 1;
		else
			reg_leds = 1;	
		for (int rep = 100000; rep > 0; rep--)
		//	for (int rep = 100000; rep > 0; rep--)
		{
			__asm__ volatile ("nop");//asm volatile("");
		}
		Duty0 = Duty0 + 50;
		Duty1 = Duty1 + 50;
		Duty2 = Duty2 + 50;
		Duty3 = Duty3 + 50;
		if (Duty0 > 512)
			Duty0 = 0;
		if (Duty1 > 512)
			Duty1 = 0;
		if (Duty2 > 512)
			Duty2 = 0;
		if (Duty3 > 512)
			Duty3 = 0;
		    // 00 input
		// 01 output
		// 10 AF
		// 11 input
		
		*(ptrPWM + AIP_CONFIG) = 3;  // ACONFREG,0b00010,1,W,We Pointer of CONFREG
		*(ptrPWM + AIP_DATAIN) = 0x0; // Set ptr ACONFREG 0, 
		*(ptrPWM + AIP_CONFIG) = 2;  // CONFREG
		*(ptrPWM + AIP_DATAIN) = Duty0; // comp_value0
		*(ptrPWM + AIP_DATAIN) = Duty1; // comp_value1
		*(ptrPWM + AIP_DATAIN) = Duty2; // comp_value2
		*(ptrPWM + AIP_DATAIN) = Duty3; // comp_value3
		}
}
