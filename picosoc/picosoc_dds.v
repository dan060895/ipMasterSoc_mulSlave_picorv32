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

`ifndef PICORV32_REGS
`ifdef PICORV32_V
`error "picosoc.v must be read before picorv32.v!"
`endif

`define PICORV32_REGS picosoc_regs
`endif

`ifndef PICOSOC_MEM
`define PICOSOC_MEM picosoc_mem
`endif

// this macro can be used to check if the verilog files in your
// design are read in the correct order.
`define PICOSOC_V

module picosoc_dds (
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
	
	output [11:0]iData_Tx_I,
	output [11:0]iData_Tx_Q
	/*,
	
	output rom_mem_valid,
	output mem_valid,
	output reg rom_ready,
	output reg ram_ready,
	
	output [15:0] rom_debug*/
/*
	output flash_csb,
	output flash_clk,

	output flash_io0_oe,
	output flash_io1_oe,
	output flash_io2_oe,
	output flash_io3_oe,

	output flash_io0_do,
	output flash_io1_do,
	output flash_io2_do,
	output flash_io3_do,

	input  flash_io0_di,
	input  flash_io1_di,
	input  flash_io2_di,
	input  flash_io3_di
*/
);
	parameter [0:0] BARREL_SHIFTER = 1;
	parameter [0:0] ENABLE_MUL = 1;
	parameter [0:0] ENABLE_DIV = 1;
	parameter [0:0] ENABLE_FAST_MUL = 0;
	parameter [0:0] ENABLE_COMPRESSED = 1;
	parameter [0:0] ENABLE_COUNTERS = 1;
	parameter [0:0] ENABLE_IRQ_QREGS = 0;

	parameter integer MEM_WORDS = 256;
	parameter [31:0] STACKADDR = (4*MEM_WORDS/2);       // end of RAM memory
	parameter [31:0] PROGADDR_RESET = 32'h 0010_0000; // 1 MB into flash
	parameter [31:0] PROGADDR_IRQ = 32'h 0000_0000;

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
	
	wire sel_mem, sel_ipcore, sel_aip;
 
 	wire         mem_readyAIP;
   wire [31:0]  mem_rdata_AIP;

   wire [31:0]     iPdataIn, iPdataOut;
   wire            iPwrite, iPread, iPstart;
   wire [4:0]      iPconf;
   wire [15:0]     iPINTstatus;

   assign sel_aip = (((32'h80000100  <= mem_addr) && (mem_addr <= 32'h80000200)))? 1'b1 : 1'b0;

	//assign sel_mem    = mem_valid && (mem_addr <  32'h4000_0000); //128 * 1024 = 20000000
	
	//assign mem_rdata = sel_ipcore?mem_rdata_ipcore:sel_aip? mem_rdata_AIP : mem_rdata_mem;
	//assign mem_rdata = sel_mem? mem_rdata_mem:sel_ipcore?mem_rdata_ipcore:32'h00000000;
	
	//assign mem_ready = sel_mem? mem_readyMEM:sel_ipcore?mem_readIPCORE:1'b0;
	//assign mem_ready = sel_ipcore?mem_readIPCORE:mem_readyMEM;
	

	assign iomem_valid = mem_valid && (mem_addr[31:24] > 8'h 01);
	assign rom_mem_valid = mem_valid && (mem_addr >= 4*MEM_WORDS && mem_addr < 32'h 0200_0000); 
	assign iomem_wstrb = mem_wstrb;
	assign iomem_addr = mem_addr;
	assign iomem_wdata = mem_wdata;

	wire        simpleuart_reg_div_sel = mem_valid && (mem_addr == 32'h 0200_0004);
	wire [31:0] simpleuart_reg_div_do;

	wire        simpleuart_reg_dat_sel = mem_valid && (mem_addr == 32'h 0200_0008);
	wire [31:0] simpleuart_reg_dat_do;
	wire        simpleuart_reg_dat_wait;

	assign mem_ready = (iomem_valid && iomem_ready) || rom_ready || ram_ready ||
			simpleuart_reg_div_sel || (simpleuart_reg_dat_sel && !simpleuart_reg_dat_wait) || (sel_aip && mem_readyAIP) ;

	assign mem_rdata = (iomem_valid && iomem_ready) ? iomem_rdata :rom_ready ? rom_mem_rdata : ram_ready ? ram_rdata : simpleuart_reg_div_sel ? simpleuart_reg_div_do :
			simpleuart_reg_dat_sel ? simpleuart_reg_dat_do : sel_aip? mem_rdata_AIP : 32'h 0000_0000;
			
			
			
			
	picorv32 #(
		.STACKADDR(STACKADDR),
		.PROGADDR_RESET(PROGADDR_RESET),
		.PROGADDR_IRQ(PROGADDR_IRQ),
		.BARREL_SHIFTER(BARREL_SHIFTER),
		.COMPRESSED_ISA(ENABLE_COMPRESSED),
		.ENABLE_COUNTERS(ENABLE_COUNTERS),
		.ENABLE_MUL(ENABLE_MUL),
		.ENABLE_DIV(ENABLE_DIV),
		.ENABLE_FAST_MUL(ENABLE_FAST_MUL),
		.ENABLE_IRQ(1),
		.ENABLE_IRQ_QREGS(ENABLE_IRQ_QREGS)
	) cpu (
		.clk         (clk        ),
		.resetn      (resetn     ),
		.mem_valid   (mem_valid  ),
		.mem_instr   (mem_instr  ),
		.mem_ready   (mem_ready  ),
		.mem_addr    (mem_addr   ),
		.mem_wdata   (mem_wdata  ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_rdata   (mem_rdata  ),
		.irq         (irq        )
	);
	
	picosoc_mem_rom #(
                .WORDS(MEM_WORDS)
        ) memoryROM (
                .clk(clk),
                //.wen((mem_valid && mem_addr >= 4*MEM_WORDS && mem_addr < 32'h 0200_0000) ? mem_wstrb : 4'b0),
                .addr(mem_addr[$clog2(MEM_WORDS)-1 + 2 :2]),
                //.wdata(mem_wdata),
                .rdata(rom_mem_rdata)
        );

	
  always @(posedge clk) begin
		ram_ready <= mem_valid && !mem_ready && mem_addr < 4*MEM_WORDS;
		rom_ready <= mem_valid && !mem_ready && (mem_addr >= 4*MEM_WORDS && mem_addr < 32'h 0200_0000);
	end
	
	`PICOSOC_MEM #(
		.WORDS(MEM_WORDS/2)
	) memory (
		.clk(clk),
		.wen((mem_valid && !mem_ready && mem_addr < 4*MEM_WORDS) ? mem_wstrb : 4'b0),
		.addr(mem_addr[13:2]),
		.wdata(mem_wdata),
		.rdata(ram_rdata)
	);
	
	native_aip CPU_2_aip(
    		.i_clk			(clk),
    		.i_rst			(resetn),

		.i_cpu_mem_valid	(mem_valid),
		.i_cpu_mem_addr		(mem_addr),
		.i_cpu_mem_wdata	(mem_wdata),
		.i_cpu_mem_wen		(mem_valid && !mem_readyAIP &&((sel_aip)? |(mem_wstrb) : 1'b0)),

		.o_cpu_mem_rdata	(mem_rdata_AIP),
		.o_cpu_mem_ready	(mem_readyAIP),
		.o_cpu_irq		(),

    // aip interface
    		.i_aip_sel		(sel_aip),
    		.i_aip_enable		(1'b1),
    		.i_aip_dataOut		(iPdataOut),
    		.o_aip_dataIn		(iPdataIn),
    		.o_aip_config		(iPconf),
    		.o_aip_read		(iPread),
    		.o_aip_write		(iPwrite),
    		.o_aip_start		(iPstart),
    		.i_aip_int		(iPINTstatus),
    		.o_core_int		()
	);

	IP_TX_DDS #(
          .IP_ID(32'h00002001)
        )
  		DDS_module
  	(
	    .clk 	(clk),
	    .rst 	(resetn),
	    .en_s 	(1'b1),

	    .data_in	(iPdataIn),
	    .data_out	(iPdataOut),
	    .write	(iPwrite),
	    .read	(iPread),
	    .start	(iPstart),
	    .conf_dbus	(iPconf),
	    .int_req	(iPINTstatus),
	    
	    // IP signals 
           .iStartIPcore         (1'b1  ), // Pause processor signal, high active
            //--Outputs
           .I_DDS_out            (iData_Tx_I        ),  // In-phase output data
           .Q_DDS_out            (iData_Tx_Q        ),  // Quadrature output data 
           .WritEn_2FIFO_o       (     )
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


module picosoc_regs (
	input clk, wen,
	input [5:0] waddr,
	input [5:0] raddr1,
	input [5:0] raddr2,
	input [31:0] wdata,
	output [31:0] rdata1,
	output [31:0] rdata2
);
	reg [31:0] regs [0:31];

	always @(posedge clk)
		if (wen) regs[waddr[4:0]] <= wdata;

	assign rdata1 = regs[raddr1[4:0]];
	assign rdata2 = regs[raddr2[4:0]];
endmodule

module picosoc_mem #(
        parameter integer WORDS = 256
) (
        input clk,
        input [3:0] wen,
        input [11:0] addr,
        input [31:0] wdata,
        output [31:0] rdata
);
        reg [7:0] mem0 [0:WORDS-1];
		  reg [7:0] mem1 [0:WORDS-1];
		  reg [7:0] mem2 [0:WORDS-1];
		  reg [7:0] mem3 [0:WORDS-1];
		  
		  reg  [11:0] addr_reg0;
        reg  [11:0] addr_reg1;
		  reg  [11:0] addr_reg2;
		  reg  [11:0] addr_reg3;
		  
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
endmodule

module picosoc_mem_rom #(
	parameter integer WORDS = 256
) (
	input clk,
	//input [3:0] wen,
	input [$clog2(WORDS)-1:0] addr,
	//input [31:0] wdata,
	output reg [31:0] rdata
);
	reg [31:0] mem [0:WORDS-1];

	initial begin
		$readmemh("../picosoc/firmware/altera_out.txt", mem);
		//$readmemh("altera_out.txt", mem);
	end
// initial
// begin
//     $readmemb("init.txt", rom);
// end	
	always @(posedge clk) begin
		rdata <= mem[addr];
		/*if (wen[0]) mem[addr][ 7: 0] <= wdata[ 7: 0];
		if (wen[1]) mem[addr][15: 8] <= wdata[15: 8];
		if (wen[2]) mem[addr][23:16] <= wdata[23:16];
		if (wen[3]) mem[addr][31:24] <= wdata[31:24];*/
	end
endmodule