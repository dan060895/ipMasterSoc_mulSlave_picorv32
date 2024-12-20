
module picorv32_aipCoprocessor (
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

	output ser_tx,
	input  ser_rx,

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


  wire [32-1:0] dataInAIP_uP;
  wire [32-1:0] dataOutAIP_uP;
  wire [5-1:0] configAIP_uP;
  wire readAIP_uP;
  wire writeAIP_uP;
  wire startIPcore,startIPcore_uP;

aipCoprocessor aipCoprocessor
(
	.clk				(clk),
	.rst				(resetn),
	.en					(1'b1),
  //----- net -----//
	.dataInAIP_net		(data_in),
	.dataOutAIP_net		(data_out),
	.configAIP_net		(conf_dbus),
	.readAIP_net		(read),
	.writeAIP_net		(write),
	.startAIP_net		(start),
	.intAIP_net			(int_req),
  //----- uP -----//
	.dataInAIP_uP		(dataInAIP_uP ),
	.dataOutAIP_uP		(dataOutAIP_uP),
	.configAIP_uP		(configAIP_uP ),
	.readAIP_uP			(readAIP_uP   ),
	.writeAIP_uP		(writeAIP_uP  ),
  // startAIP_uP,
  // intAIP_uP,
	.startIPcore		(startIPcore  )
);

   picorv32_AIP_IPcore picorv32_AIP_Accel (
	.clk				(clk),
	.resetn				(resetn),

	.iomem_valid		(iomem_valid),
	.iomem_ready		(iomem_ready),
	.iomem_wstrb		(iomem_wstrb),
	.iomem_addr			(iomem_addr),
	.iomem_wdata		(iomem_wdata),
	.iomem_rdata		(iomem_rdata),

	.irq_5				(irq_5),
	.irq_6				(irq_6),
	.irq_7				(startIPcore),

	.ser_tx				(ser_tx),
	.ser_rx				(ser_rx),
	
    //-------------------------- To/From NIc --------------------------//
    .configAIP_uP		(configAIP_uP ),          //Used for protocol to determine different actions types
    .readAIP_uP			(readAIP_uP   ),               //Used for protocol to read different information types
    .writeAIP_uP		(writeAIP_uP  ),              //Used for protocol to write different information types
    .startAIP			(startIPcore_uP  ),              //Used to start the IP-core
    .dataInAIP_uP		(dataInAIP_uP ),            //different data in information types
   // .int_req			(),            				//Interruption request
    .dataOutAIP_uP		(dataOutAIP_uP)           //different data out information types
);

endmodule

