module TOP_SOC_ipdiRDBv2 (
    input CLK_50MHZ,
    input PSH1,
    input PSH2,
    output D1, D2, D3, D4, D5, D6, D7, D8,
    output FTDI1_A0, // TXD FTD232HQ
    input  FTDI1_A1, // RXD FT232HQ
    inout PMOD1_1, PMOD1_2, PMOD1_3, PMOD1_4, PMOD1_7, PMOD1_8, PMOD1_9, PMOD1_10,
    inout PMOD2_1, PMOD2_2, PMOD2_3, PMOD2_4, PMOD2_7, PMOD2_8, PMOD2_9, PMOD2_10,
 
    	 // MCU
    //input   [3:0]                      addressMCU,         //GPIO[16,14,12,10]
    input BRIDGE_ADDR3,BRIDGE_ADDR2,BRIDGE_ADDR1,BRIDGE_ADDR0,
    //input                              rstMCU,             //GPIO[5]
    //input                              rdMCU,              //GPIO[7]
    //input                              wrMCU,              //GPIO[9]
    input BRIDGE_RD, BRIDGE_WR,BRIDGE_RST,
    //inout   [7:0]                      dataMCU,            //GPIO[25,23,21,19,17,15,13,11]
    //output                             intMCU              //GPIO[27]
    output BRIDGE_INT
);

wire   [3:0]                      addressMCU;         //GPIO[16,14,12,10]
wire                              rstMCU;             //GPIO[5]
wire                              rdMCU;              //GPIO[7]
wire                              wrMCU;              //GPIO[9]
wire   [7:0]                      dataMCU;            //GPIO[25,23,21,19,17,15,13,11]
wire                              intMCU;              //GPIO[27]
   
assign addressMCU = {BRIDGE_ADDR3,BRIDGE_ADDR2,BRIDGE_ADDR1,BRIDGE_ADDR0};
assign {rdMCU,wrMCU,rstMCU}={BRIDGE_RD, BRIDGE_WR,BRIDGE_RST};
assign BRIDGE_INT = intMCU;
assign {BRIDGE_DATA7,BRIDGE_DATA6,BRIDGE_DATA5,BRIDGE_DATA4,BRIDGE_DATA3,BRIDGE_DATA2,BRIDGE_DATA1,BRIDGE_DATA0} = dataMCU;

wire [15:0] GPIO;
assign {PMOD1_1, PMOD1_2, PMOD1_3, PMOD1_4, PMOD1_7, PMOD1_8, PMOD1_9, PMOD1_10} = GPIO[15:8];
assign {PMOD2_1, PMOD2_2, PMOD2_3, PMOD2_4, PMOD2_7, PMOD2_8, PMOD2_9, PMOD2_10} = GPIO[7:0];
assign GPIO_in = GPIO;

assign GPIO[0]  = GPIO_we[0]  ?  GPIO_out[0]  : 1'bz;
assign GPIO[1]  = GPIO_we[1]  ?  GPIO_out[1]  : 1'bz;
assign GPIO[2]  = GPIO_we[2]  ?  GPIO_out[2]  : 1'bz;
assign GPIO[3]  = GPIO_we[3]  ?  GPIO_out[3]  : 1'bz;
assign GPIO[4]  = GPIO_we[4]  ?  GPIO_out[4]  : 1'bz;
assign GPIO[5]  = GPIO_we[5]  ?  GPIO_out[5]  : 1'bz;
assign GPIO[6]  = GPIO_we[6]  ?  GPIO_out[6]  : 1'bz;
assign GPIO[7]  = GPIO_we[7]  ?  GPIO_out[7]  : 1'bz;
assign GPIO[8]  = GPIO_we[8]  ?  GPIO_out[8]  : 1'bz;
assign GPIO[9]  = GPIO_we[9]  ?  GPIO_out[9]  : 1'bz;
assign GPIO[10] = GPIO_we[10] ?  GPIO_out[10] : 1'bz;
assign GPIO[11] = GPIO_we[11] ?  GPIO_out[11] : 1'bz;
assign GPIO[12] = GPIO_we[12] ?  GPIO_out[12] : 1'bz;
assign GPIO[13] = GPIO_we[13] ?  GPIO_out[13] : 1'bz;
assign GPIO[14] = GPIO_we[14] ?  GPIO_out[14] : 1'bz;
assign GPIO[15] = GPIO_we[15] ?  GPIO_out[15] : 1'bz;



  builder_picosoc builder_picosoc (
	.clk           (CLK_50MHZ),
    .rst           (PSH1),
	.ena           (1'b1),
	
    .ser_tx        (FTDI1_A1), // ser_tx --> RXD FT232
	.ser_rx        (FTDI1_A0), // ser_rx --> TXD FT232

	.irq_5         (PSH2),

	.led1          (D1),
	.led2          (D2),
	.led3          (D3),
	.led4          (D4),
	.led5          (D5),

	.ledr_n        (D7),
	.ledg_n        (D8),
	
	.GPIO_in       (GPIO_in),
	.GPIO_out      (GPIO_out), 
    .GPIO_we       (GPIO_we),
	
           //-------------------------- To/From NIc --------------------------//
		  //--- AIP ---//
    .data_in       (wireDataMCUtoIP  ),
    .data_out      (wireDataIPtoMCU  ),
    .conf_dbus     (wireConf         ),
    .read          (wireReadIP       ),
    .write         (wireWriteIP      ),
    .start         (wireStartIP      ),
    .int_req       (    )

);

	ipm IPM
    (
        .clk_n_Hz				(clk),
        .ipm_RstIn			(wireReset),
        
        // MCU
        .ipmMCUDataInout   (dataMCU),
        .ipmMCUAddrsIn     (addressMCU),
        .ipmMCURdIn        (rdMCU),
        .ipmMCUWrIn        (wrMCU),
        .ipmMCUINTOut      (intMCU),
        
        // IP
        .ipmPIPDataIn      (wireDataIPtoMCU),
        .ipmPIPConfOut     (wireConf),
        .ipmPIPReadOut     (wireReadIP),
        .ipmPIPWriteOut    (wireWriteIP),
        .ipmPIPStartOut    (wireStartIP),
        .ipmPIPDataOut     (wireDataMCUtoIP),
        .ipmPIPINTIn       (wireINT)
    );

endmodule
