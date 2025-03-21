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


module picorv32_AIP (
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
	
    //-------------------------- To/From NIc --------------------------//
    input   wire    [4:0]                   conf_dbus,          //Used for protocol to determine different actions types
    input   wire                            read,               //Used for protocol to read different information types
    input   wire                            write,              //Used for protocol to write different information types
    input   wire                            start,              //Used to start the IP-core
    input   wire    [32-1:0]                data_in,            //different data in information types
    output  wire                            int_req,            //Interruption request
    output  wire    [32-1:0]                data_out,           //different data out information types
    // -------- 

//-------------------------- AIPCores --------------------------//
// IP_Module0
   	output wire [31:0]     oPdataIn0, 
	input  wire [31:0]     iPdataOut0,
   	output wire            oPwrite0, 
	output wire		       oPread0,
	output wire            oPstart0,
   	output wire [4:0]      oPconf0,
   	input  wire [15:0]     iPINTstatus0,

// IP_Module1
    output wire [31:0]     oPdataIn1, 
	input  wire [31:0]     iPdataOut1,
   	output wire            oPwrite1, 
	output wire		       oPread1,
	output wire            oPstart1,
   	output wire [4:0]      oPconf1,
   	input  wire [15:0]     iPINTstatus1,

// IP_Module2
   	output wire [31:0]     oPdataIn2, 
	input  wire [31:0]     iPdataOut2,
   	output wire            oPwrite2, 
	output wire		       oPread2,
	output wire            oPstart2,
   	output wire [4:0]      oPconf2,
   	input  wire [15:0]     iPINTstatus2,

// IP_Module3
   	output wire [31:0]     oPdataIn3, 
	input  wire [31:0]     iPdataOut3,
   	output wire            oPwrite3, 
	output wire		       oPread3,
	output wire            oPstart3,
   	output wire [4:0]      oPconf3,
   	input  wire [15:0]     iPINTstatus3
);

    // aip interface
	/*
    	.i_aip_sel			(sel_aip0),
    	.i_aip_enable		(1'b1),
    	.i_aip_dataOut		(iPdataOut0),
    	.o_aip_dataIn		(iPdataIn0),
    	.o_aip_config		(iPconf0),
    	.o_aip_read			(iPread0),
    	.o_aip_write		(iPwrite0),
    	.o_aip_start		(iPstart0),
    	.i_aip_int			(iPINTstatus0),
    	.o_core_int			()
	);*/

    parameter [ 0:0] ENABLE_COUNTERS = 1;
	parameter [ 0:0] ENABLE_COUNTERS64 = 1;
	parameter [ 0:0] ENABLE_REGS_16_31 = 1;
	parameter [ 0:0] ENABLE_REGS_DUALPORT = 1;
	parameter [ 0:0] TWO_STAGE_SHIFT = 1;
	parameter [ 0:0] BARREL_SHIFTER = 1;
	parameter [ 0:0] TWO_CYCLE_COMPARE = 0;
	parameter [ 0:0] TWO_CYCLE_ALU = 0;
	parameter [ 0:0] COMPRESSED_ISA = 1;
	parameter [ 0:0] CATCH_MISALIGN = 1;
	parameter [ 0:0] CATCH_ILLINSN = 1;
	parameter [ 0:0] ENABLE_PCPI = 0;
	parameter [ 0:0] ENABLE_MUL = 1;
	parameter [ 0:0] ENABLE_FAST_MUL = 1;
	parameter [ 0:0] ENABLE_DIV = 0;
	parameter [ 0:0] ENABLE_IRQ = 1;
	parameter [ 0:0] ENABLE_IRQ_QREGS = 1;
	parameter [ 0:0] ENABLE_IRQ_TIMER = 1;
	parameter [ 0:0] ENABLE_TRACE = 1;
	parameter [ 0:0] REGS_INIT_ZERO = 0;
	parameter [31:0] MASKED_IRQ = 32'h 0000_0000;
	parameter [31:0] LATCHED_IRQ = 32'h ffff_ffff;
	//parameter [31:0] PROGADDR_RESET = 32'h 0000_0000;
	//parameter [31:0] PROGADDR_IRQ = 32'h 0000_0010;
	//parameter [31:0] STACKADDR = 32'h ffff_ffff;

	parameter [0:0] ENABLE_COMPRESSED = 1;
	

	//parameter integer MEM_WORDS = 256;
	parameter integer MEM_WORDS = 16384;
	parameter [31:0] STACKADDR = (4*MEM_WORDS/2);       // end of RAM memory
	parameter [31:0] PROGADDR_RESET = 32'h 0010_0000; // 1 MB into flash
	parameter [31:0] PROGADDR_IRQ = 32'h 0010_0010;

	reg [31:0] irq;
	wire irq_stall = 0;
	wire irq_uart = 0;

	always @* begin
		irq = 0;
		irq[3] = irq_stall;
		irq[4] = irq_uart;
		irq[5] = irq_5;
		irq[6] = irq_6;
		irq[7] = irq_7;
	end

	wire mem_valid;
	wire mem_instr;
	wire  mem_ready, mem_readyMEM, mem_readIPCORE;
	wire  [31:0] mem_addr;
	wire  [31:0] mem_wdata;
	wire  [3:0]  mem_wstrb;
	wire  [31:0] mem_rdata, mem_rdata_mem, mem_rdata_ipcore;
	
   	reg rom_ready;
	wire rom_mem_valid;
	wire [31:0] rom_mem_rdata;
	
	reg ram_ready;
	wire [31:0] ram_rdata;
	
	wire sel_mem;
 
 // IP_Module0
    localparam IP0_BASE_ADDR = 32'h80000100;
    localparam IP0_RANGE     = IP0_BASE_ADDR + 32'h00000100;
       
 	wire         	sel_aip0, mem_readyAIP0;
   	wire [31:0]  	mem_rdata_AIP0;

//   	wire [31:0]     iPdataIn0, iPdataOut0;
//   	wire            iPwrite0, iPread0, iPstart0;
//   	wire [4:0]      iPconf0;
//   	wire [15:0]     iPINTstatus0;

// IP_Module1
    localparam IP1_BASE_ADDR = 32'h81000100;
    localparam IP1_RANGE     = IP1_BASE_ADDR + 32'h00000100;
       
 	wire         	sel_aip1, mem_readyAIP1;
   	wire [31:0]  	mem_rdata_AIP1;

//   	wire [31:0]     iPdataIn1, iPdataOut1;
//   	wire            iPwrite1, iPread1, iPstart1;
//   	wire [4:0]      iPconf1;
//   	wire [15:0]     iPINTstatus1;

// IP_Module2
    localparam IP2_BASE_ADDR = 32'h82000100;
    localparam IP2_RANGE     = IP2_BASE_ADDR + 32'h00000100;
       
 	wire         	sel_aip2, mem_readyAIP2;
   	wire [31:0]  	mem_rdata_AIP2;

   	//wire [31:0]     iPdataIn2, iPdataOut2;
   	//wire            iPwrite2, iPread2, iPstart2;
   	//wire [4:0]      iPconf2;
   	//wire [15:0]     iPINTstatus2;

// IP_Module3
    localparam IP3_BASE_ADDR = 32'h83000100;
    localparam IP3_RANGE     = IP3_BASE_ADDR + 32'h00000100;
       
 	wire         	sel_aip3, mem_readyAIP3;
   	wire [31:0]  	mem_rdata_AIP3;

   	//wire [31:0]     iPdataIn3, iPdataOut3;
   	//wire            iPwrite3, iPread3, iPstart3;
   	//wire [4:0]      iPconf3;
   	//wire [15:0]     iPINTstatus3;

   	assign sel_aip0 = (((IP0_BASE_ADDR <= mem_addr) && (mem_addr <= (IP0_RANGE))))? 1'b1 : 1'b0;
   	assign sel_aip1 = (((IP1_BASE_ADDR <= mem_addr) && (mem_addr <= (IP1_RANGE))))? 1'b1 : 1'b0;
   	assign sel_aip2 = (((IP2_BASE_ADDR <= mem_addr) && (mem_addr <= (IP2_RANGE))))? 1'b1 : 1'b0;
	assign sel_aip3 = (((IP3_BASE_ADDR <= mem_addr) && (mem_addr <= (IP3_RANGE))))? 1'b1 : 1'b0;

	assign iomem_valid    = mem_valid && (mem_addr[31:24] > 8'h 01);
	assign rom_mem_valid  = mem_valid && (mem_addr >= 4*MEM_WORDS && mem_addr < 32'h 0200_0000); 
	assign iomem_wstrb    = mem_wstrb;
	assign iomem_addr     = mem_addr;
	assign iomem_wdata    = mem_wdata;

	wire        simpleuart_reg_div_sel = mem_valid && (mem_addr == 32'h 0200_0004);
	wire [31:0] simpleuart_reg_div_do;

	wire        simpleuart_reg_dat_sel = mem_valid && (mem_addr == 32'h 0200_0008);
	wire [31:0] simpleuart_reg_dat_do;
	wire        simpleuart_reg_dat_wait;

	assign mem_ready = (iomem_valid && iomem_ready) || rom_ready || ram_ready ||
			simpleuart_reg_div_sel || (simpleuart_reg_dat_sel && !simpleuart_reg_dat_wait) || (sel_aip0 && mem_readyAIP0) || (sel_aip1 && mem_readyAIP1) || (sel_aip2 && mem_readyAIP2) || (sel_aip3 && mem_readyAIP3) ;

	assign mem_rdata = (iomem_valid && iomem_ready) ? iomem_rdata :rom_ready ? rom_mem_rdata : ram_ready ? ram_rdata : simpleuart_reg_div_sel ? simpleuart_reg_div_do :
			simpleuart_reg_dat_sel ? simpleuart_reg_dat_do : sel_aip0? mem_rdata_AIP0 : sel_aip1? mem_rdata_AIP1 : sel_aip2? mem_rdata_AIP2 : sel_aip3? mem_rdata_AIP3 :32'h 0000_0000;
			
			
				
    wire [(4*32)-1:0] rdDataConfigReg;

	always @(posedge clk) begin
		ram_ready <= mem_valid && !mem_ready && mem_addr < 4*MEM_WORDS;
		rom_ready <= mem_valid && !mem_ready && (mem_addr >= 4*MEM_WORDS && mem_addr < 32'h 0200_0000);
	end

	picorv32 #(
		.ENABLE_COUNTERS     (ENABLE_COUNTERS     ),
		.ENABLE_COUNTERS64   (ENABLE_COUNTERS64   ),
		.ENABLE_REGS_16_31   (ENABLE_REGS_16_31   ),
		.ENABLE_REGS_DUALPORT(ENABLE_REGS_DUALPORT),
		.TWO_STAGE_SHIFT     (TWO_STAGE_SHIFT     ),
		.BARREL_SHIFTER      (BARREL_SHIFTER      ),
		.TWO_CYCLE_COMPARE   (TWO_CYCLE_COMPARE   ),
		.TWO_CYCLE_ALU       (TWO_CYCLE_ALU       ),
		.COMPRESSED_ISA      (COMPRESSED_ISA      ),
		.CATCH_MISALIGN      (CATCH_MISALIGN      ),
		.CATCH_ILLINSN       (CATCH_ILLINSN       ),
		.ENABLE_PCPI         (ENABLE_PCPI         ),
		.ENABLE_MUL          (ENABLE_MUL          ),
		.ENABLE_FAST_MUL     (ENABLE_FAST_MUL     ),
		.ENABLE_DIV          (ENABLE_DIV          ),
		.ENABLE_IRQ          (ENABLE_IRQ          ),
		.ENABLE_IRQ_QREGS    (ENABLE_IRQ_QREGS    ),
		.ENABLE_IRQ_TIMER    (ENABLE_IRQ_TIMER    ),
		.ENABLE_TRACE        (ENABLE_TRACE        ),
		.REGS_INIT_ZERO      (REGS_INIT_ZERO      ),
		.MASKED_IRQ          (MASKED_IRQ          ),
		.LATCHED_IRQ         (LATCHED_IRQ         ),
		.PROGADDR_RESET      (PROGADDR_RESET      ),
		.PROGADDR_IRQ        (PROGADDR_IRQ        ),
		.STACKADDR           (STACKADDR           )
	) cpu (
		.clk         (clk        ),
		.resetn      (resetn  & (!(rdDataConfigReg[0]))   ),
		.mem_valid   (mem_valid  ),
		.mem_instr   (mem_instr  ),
		.mem_ready   (mem_ready  ),
		.mem_addr    (mem_addr   ),
		.mem_wdata   (mem_wdata  ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_rdata   (mem_rdata  ),
		.irq         (irq        )
	);
	
	picosoc_mem #(
		.WORDS(MEM_WORDS/2)
	) memory (
		.clk(clk),
		.wen((mem_valid && !mem_ready && mem_addr < 4*MEM_WORDS) ? mem_wstrb : 4'b0),
		.addr(mem_addr[13:2]),
		.wdata(mem_wdata),
		.rdata(ram_rdata)
	);

    ID0000200F_aip #(
		.WORDS(MEM_WORDS)
	)
    interface_PICORV32
    (
        .clk            		(clk        ),
        .rst            		(resetn      ),
        .en             		(1'b1       ),
  //--- AIP ---//
        .dataInAIP      		(data_in    ),
        .dataOutAIP     		(data_out   ),
        .configAIP      		(conf_dbus  ),
        .readAIP        		(read       ),
        .writeAIP       		(write      ),
        .startAIP       		(start      ),
        .intAIP         		(int_req    ),

  //--- IP-core ---//
        .rdDataMemIn_0          (rom_mem_rdata   ),
        .rdAddrMemIn_0          ({5'd0,mem_addr[$clog2(MEM_WORDS)-1 + 2 :2]}),//({8'b0,addrA}    ),
        .wrDataMemOut_0         (          ),
        .wrAddrMemOut_0         (   ),
        .wrEnMemOut_0           (          ),
        .rdDataConfigReg        (rdDataConfigReg),
        .statusIPcore_Busy      (),
        .statusIPcore_readMEM   (),
        .statusIPcore_writeMEM  (),
        .statusIPcore_Trap      (),
        .intIPCore_Done         (),
        .startIPcore            (startIPcore)
);

	native_aip CPU_to_aip0(
    	.i_clk				(clk),
    	.i_rst				(resetn),

		.i_cpu_mem_valid	(mem_valid),
		.i_cpu_mem_addr		(mem_addr),
		.i_cpu_mem_wdata	(mem_wdata),
		.i_cpu_mem_wen		(mem_valid && !mem_readyAIP0 &&((sel_aip0)? |(mem_wstrb) : 1'b0)),

		.o_cpu_mem_rdata	(mem_rdata_AIP0),
		.o_cpu_mem_ready	(mem_readyAIP0),
		.o_cpu_irq			(),

    // aip interface
    	.i_aip_sel			(sel_aip0),
    	.i_aip_enable		(1'b1),
    	.i_aip_dataOut		(iPdataOut0),
    	.o_aip_dataIn		(oPdataIn0),
    	.o_aip_config		(oPconf0),
    	.o_aip_read			(oPread0),
    	.o_aip_write		(oPwrite0),
    	.o_aip_start		(oPstart0),
    	.i_aip_int			(iPINTstatus0[0]),
    	.o_core_int			()
	);
/*   	output wire [31:0]     oPdataIn0, 
	input  wire [31:0]     iPdataOut0,
   	output wire            oPwrite0, 
	output wire		       oPread0,
	output wire            oPstart0,
   	output wire [4:0]      oPconf0,
   	input  wire [15:0]     iPINTstatus0,
*/	
	native_aip CPU_to_aip1(
    	.i_clk				(clk),
    	.i_rst				(resetn),

		.i_cpu_mem_valid	(mem_valid),
		.i_cpu_mem_addr		(mem_addr),
		.i_cpu_mem_wdata	(mem_wdata),
		.i_cpu_mem_wen		(mem_valid && !mem_readyAIP1 &&((sel_aip1)? |(mem_wstrb) : 1'b0)),

		.o_cpu_mem_rdata	(mem_rdata_AIP1),
		.o_cpu_mem_ready	(mem_readyAIP1),
		.o_cpu_irq			(),

    // aip interface
    	.i_aip_sel			(sel_aip1),
    	.i_aip_enable		(1'b1),
    	.i_aip_dataOut		(iPdataOut1),
    	.o_aip_dataIn		(oPdataIn1),
    	.o_aip_config		(oPconf1),
    	.o_aip_read			(oPread1),
    	.o_aip_write		(oPwrite1),
    	.o_aip_start		(oPstart1),
    	.i_aip_int			(iPINTstatus1[0]),
    	.o_core_int			()
	);

  
	native_aip CPU_to_aip2(
    	.i_clk				(clk),
    	.i_rst				(resetn),

		.i_cpu_mem_valid	(mem_valid),
		.i_cpu_mem_addr		(mem_addr),
		.i_cpu_mem_wdata	(mem_wdata),
		.i_cpu_mem_wen		(mem_valid && !mem_readyAIP2 &&((sel_aip2)? |(mem_wstrb) : 1'b0)),

		.o_cpu_mem_rdata	(mem_rdata_AIP2),
		.o_cpu_mem_ready	(mem_readyAIP2),
		.o_cpu_irq			(),

    // aip interface
    	.i_aip_sel			(sel_aip2),
    	.i_aip_enable		(1'b1),
    	.i_aip_dataOut		(iPdataOut2),
    	.o_aip_dataIn		(oPdataIn2),
    	.o_aip_config		(oPconf2),
    	.o_aip_read			(oPread2),
    	.o_aip_write		(oPwrite2),
    	.o_aip_start		(oPstart2),
    	.i_aip_int			(iPINTstatus2[0]),
    	.o_core_int			()
	);

 	native_aip CPU_to_aip3(
    	.i_clk				(clk),
    	.i_rst				(resetn),

		.i_cpu_mem_valid	(mem_valid),
		.i_cpu_mem_addr		(mem_addr),
		.i_cpu_mem_wdata	(mem_wdata),
		.i_cpu_mem_wen		(mem_valid && !mem_readyAIP3 &&((sel_aip3)? |(mem_wstrb) : 1'b0)),

		.o_cpu_mem_rdata	(mem_rdata_AIP3),
		.o_cpu_mem_ready	(mem_readyAIP3),
		.o_cpu_irq			(),

    // aip interface
    	.i_aip_sel			(sel_aip3),
    	.i_aip_enable		(1'b1),
    	.i_aip_dataOut		(iPdataOut3),
    	.o_aip_dataIn		(oPdataIn3),
    	.o_aip_config		(oPconf3),
    	.o_aip_read			(oPread3),
    	.o_aip_write		(oPwrite3),
    	.o_aip_start		(oPstart3),
    	.i_aip_int			(iPINTstatus3[0]),
    	.o_core_int			()
	);
 
	simpleuart simpleuart (
		.clk         (clk         ),
		.resetn      (resetn      ),

		.ser_tx      (ser_tx      ),
		.ser_rx      (ser_rx      ),

		.reg_div_we  (simpleuart_reg_div_sel ? mem_wstrb : 4'b 0000),
		.reg_div_di  (mem_wdata),
		.reg_div_do  (simpleuart_reg_div_do),

		.reg_dat_we  (simpleuart_reg_dat_sel ? mem_wstrb[0] : 1'b 0),
		.reg_dat_re  (simpleuart_reg_dat_sel && !mem_wstrb),
		.reg_dat_di  (mem_wdata),
		.reg_dat_do  (simpleuart_reg_dat_do),
		.reg_dat_wait(simpleuart_reg_dat_wait)
	);
  

endmodule


/*
module picosoc_mem #(
        parameter integer WORDS = 256
) (
        input clk,
        input [3:0] wen,
        input [11:0] addr,
        input [31:0] wdata,
        output reg [31:0] rdata
);
        reg [31:0] mem [0:WORDS-1];
	
	integer i;
	
	initial begin
		for(i=0; i<WORDS; i = i + 1)begin
			mem[i] <= 0;
		end
	end
	
        always @(posedge clk) begin
                rdata <= mem[addr];
                if (wen[0]) mem[addr][ 7: 0] <= wdata[ 7: 0];
                if (wen[1]) mem[addr][15: 8] <= wdata[15: 8];
                if (wen[2]) mem[addr][23:16] <= wdata[23:16];
                if (wen[3]) mem[addr][31:24] <= wdata[31:24];
        end

endmodule
*/
module picosoc_mem #(
	    parameter integer WORDS = 256
) (
        input         clk,
        input   [3:0] wen,
        input   [(CeilLog2(WORDS)-1):0]  addr,
        input   [31:0] wdata,
        output  [31:0] rdata
);
    reg [7:0] mem0 [0:WORDS-1];
	reg [7:0] mem1 [0:WORDS-1];
	reg [7:0] mem2 [0:WORDS-1];
	reg [7:0] mem3 [0:WORDS-1];
		  
	reg  [(CeilLog2(WORDS)-1):0]  addr_reg0;
    reg  [(CeilLog2(WORDS)-1):0]  addr_reg1;
	reg  [(CeilLog2(WORDS)-1):0]  addr_reg2;
	reg  [(CeilLog2(WORDS)-1):0]  addr_reg3;
		  
	always @(posedge clk) begin
             addr_reg0 <= addr;   
                if (wen[0]) 
			mem0[addr] <= wdata[ 7: 0];
        end
		
	always @(posedge clk) begin
             addr_reg1 <= addr;   
                if (wen[1]) 
			mem1[addr] <= wdata[15: 8];
        end
		  
	always @(posedge clk) begin
             addr_reg2 <= addr;   
                if (wen[2]) 
			mem2[addr] <= wdata[23:16];
        end
		  
	always @(posedge clk) begin
             addr_reg3 <= addr;   
                if (wen[3]) 
			mem3[addr] <= wdata[31:24];
        end
		  
	assign rdata = {mem3[addr_reg3],mem2[addr_reg2],mem1[addr_reg1],mem0[addr_reg0]};


	function integer CeilLog2;
  input integer data;
  integer i, result;
  	  begin
	  result = 1; 
		  for (i = 0; 2**i < data; i = i + 1)
			result = i + 1; 
			CeilLog2 = result;
	  end 
  endfunction

endmodule