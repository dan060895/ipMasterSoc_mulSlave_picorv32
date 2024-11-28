/*
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  Copyright (C) 2017  Claire Xenia Wolf <claire@yosyshq.com>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */


module picosoc_ipdi (
	input clk,
	input resetn,

	output        iomem_valid,
	input         iomem_ready,
	output [ 3:0] iomem_wstrb,
	output [31:0] iomem_addr,
	output [31:0] iomem_wdata,
	input  [31:0] iomem_rdata,

	input  irq_5,
	input  irq_6,
	input  irq_7,

	output ser_tx,
	input  ser_rx,

	input 	uart_rx_in,
    output  uart_tx_out,   
	
	input  [15:0] GPIO_in,
	output [15:0] GPIO_out, GPIO_we,
    //-------------------------- To/From NIc --------------------------//
    input   wire    [4:0]                   conf_dbus,          //Used for protocol to determine different actions types
    input   wire                            read,               //Used for protocol to read different information types
    input   wire                            write,              //Used for protocol to write different information types
    input   wire                            start,              //Used to start the IP-core
    input   wire    [32-1:0]                data_in,            //different data in information types
    output  wire                            int_req,            //Interruption request
    output  wire    [32-1:0]                data_out           //different data out information types
    // -------- 

);
/*
	wire        iomem_valid;
	wire        iomem_ready;
	wire [ 3:0] iomem_wstrb;
	wire [31:0] iomem_addr;
	wire [31:0] iomem_wdata;
	wire [31:0] iomem_rdata;
*/

// IP_Module0   
   	wire [31:0]     oPdataIn0; 
	wire [31:0]     iPdataOut0;
   	wire            oPwrite0; 
	wire		    oPread0;
	wire            oPstart0;
   	wire [4:0]      oPconf0;
   	wire [15:0]     iPINTstatus0;

// IP_Module1
    wire [31:0]     oPdataIn1; 
	wire [31:0]     iPdataOut1;
   	wire            oPwrite1; 
	wire		    oPread1;
	wire            oPstart1;
   	wire [4:0]      oPconf1;
   	wire [15:0]     iPINTstatus1;

// IP_Module2
   	wire [31:0]     oPdataIn2; 
	wire [31:0]     iPdataOut2;
   	wire            oPwrite2; 
	wire		    oPread2;
	wire            oPstart2;
   	wire [4:0]      oPconf2;
   	wire [15:0]     iPINTstatus2;

// IP_Module3
   	wire [31:0]     oPdataIn3; 
	wire [31:0]     iPdataOut3;
   	wire            oPwrite3; 
	wire		    oPread3;
	wire            oPstart3;
   	wire [4:0]      oPconf3;
   	wire [15:0]     iPINTstatus3;

   picorv32_AIP picorv32_AIP (
	.clk			(clk),
	.resetn			(resetn),

	.iomem_valid	(iomem_valid),
	.iomem_ready	(iomem_ready),
	.iomem_wstrb	(iomem_wstrb),
	.iomem_addr		(iomem_addr),
	.iomem_wdata	(iomem_wdata),
	.iomem_rdata	(iomem_rdata),

	.irq_5			(irq_5),
	.irq_6			(irq_6),
	.irq_7			(irq_7),

	.ser_tx			(ser_tx),
	.ser_rx			(ser_rx),
	
    //-------------------------- To/From NIc --------------------------//
    .conf_dbus		(conf_dbus),          //Used for protocol to determine different actions types
    .read			(read),               //Used for protocol to read different information types
    .write			(write),              //Used for protocol to write different information types
    .start			(start),              //Used to start the IP-core
    .data_in		(data_in),            //different data in information types
    .int_req		(int_req),            //Interruption request
    .data_out		(data_out),           //different data out information types
    // -------- 

//-------------------------- AIPCores --------------------------//
// IP_Module0
   	.oPdataIn0		(oPdataIn0), 
	.iPdataOut0		(iPdataOut0),
   	.oPwrite0		(oPwrite0), 
	.oPread0		(oPread0),
	.oPstart0		(oPstart0),
   	.oPconf0		(oPconf0),
   	.iPINTstatus0	({iPINTstatus0}),

// IP_Module1
    .oPdataIn1		(oPdataIn1), 
	.iPdataOut1		(iPdataOut1),
   	.oPwrite1		(oPwrite1), 
	.oPread1		(oPread1),
	.oPstart1		(oPstart1),
   	.oPconf1		(oPconf1),
   	.iPINTstatus1	(iPINTstatus1),

// IP_Module2
   	.oPdataIn2		(oPdataIn2), 
	.iPdataOut2		(iPdataOut2),
   	.oPwrite2		(oPwrite2), 
	.oPread2		(oPread2),
	.oPstart2		(oPstart2),
   	.oPconf2		(oPconf2),
   	.iPINTstatus2	(iPINTstatus2),

// IP_Module3
   	.oPdataIn3		(oPdataIn3), 
	.iPdataOut3		(iPdataOut3),
   	.oPwrite3		(oPwrite3), 
	.oPread3		(oPread3),
	.oPstart3		(oPstart3),
   	.oPconf3		(oPconf3),
   	.iPINTstatus3	(iPINTstatus3)
);

ID00001001_dummy
	DUMMY0
	(
	    .clk 		(clk),
	    .rst_a 		(resetn),
	    .en_s 		(1'b1),

	    .data_in	(oPdataIn0),
	    .data_out	(iPdataOut0),
	    .write		(oPwrite0),
	    .read		(oPread0),
	    .start		(oPstart0),
	    .conf_dbus	(oPconf0),
	    .int_req	(iPINTstatus0[0])
	);
wire pwm_out3, pwm_out2, pwm_out1, pwm_out0;

gpio_module AIP_GPIO_Module(
    .clk_in         (clk),     	// Clock
    .rst_in         (resetn),     // reset low active
    .enable         (1'b1),
    //-------------------------- To/From NIc --------------------------//
    .configAIP      (oPconf1),      //Used for protocol to determine different actions types
    .readAIP        (oPread1),      //Used for protocol to read different information types
    .writeAIP       (oPwrite1),     //Used for protocol to write different information types
    .startAIP       (oPstart1),     //Used to start the IP-core
    .dataInAIP      (oPdataIn1),    //different data in information types
    .intAIP         (iPINTstatus1[0]),            			  //Interruption request
    .dataOutAIP     (iPdataOut1),   //different data out information types

    // IP signals 
    .AF_in          ({12'h000,pwm_out3, pwm_out2, pwm_out1, pwm_out0}),	
	.GPIO_in        (GPIO_in),
	.GPIO_out       (GPIO_out),
	.GPIO_we        (GPIO_we)
    );

	pwm_module AIP_PWM_Module(
    .clk_in         (clk),     	// Clock
    .rst_in         (resetn),     // reset low active
    .enable         (1'b1),
    //-------------------------- To/From NIc --------------------------//
    .configAIP      (oPconf2),      //Used for protocol to determine different actions types
    .readAIP        (oPread2),      //Used for protocol to read different information types
    .writeAIP       (oPwrite2),     //Used for protocol to write different information types
    .startAIP       (oPstart2),     //Used to start the IP-core
    .dataInAIP      (oPdataIn2),    //different data in information types
    .intAIP         (iPINTstatus2[0]),            			  //Interruption request
    .dataOutAIP     (iPdataOut2),   //different data out information types

    // IP signals 
    	// --------- outputs --------
	.pwm_out0       (pwm_out0),
	.pwm_out1       (pwm_out1),
	.pwm_out2       (pwm_out2),
	.pwm_out3       (pwm_out3)
    );

ID0000100B_UART UART_Module
(
    .clk			(clk),
    .rst_a			(resetn),
    .en_s			(1'b1),
    .data_in		(oPdataIn3), //different data in information types
    .data_out		(iPdataOut3), //different data out information types
    .write			(oPwrite3), //Used for protocol to write different information types
    .read			(oPread3), //Used for protocol to read different information types
    .start			(oPstart3), //Used to start the IP-core
    .conf_dbus		(oPconf3), //Used for protocol to determine different actions types
    .int_req		(iPINTstatus3[0]), //Interruption request 
  
    .uart_rx_in		(uart_rx_in),
    .uart_tx_out	(uart_tx_out)      

       
);

endmodule

