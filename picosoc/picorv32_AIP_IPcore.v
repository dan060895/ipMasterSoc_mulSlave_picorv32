module picorv32_AIP_IPcore (
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
	
    //-------------------------- AIP --------------------------//
	output 	[32-1:0] 	dataInAIP_uP,
	input	[32-1:0] 	dataOutAIP_uP,
	output	[5-1:0] 	configAIP_uP,
	output				readAIP_uP,
	output				writeAIP_uP,
	output              startAIP

);

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
	parameter integer MEM_WORDS = 2048;
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
	wire [31:0] rom_mem_rdata, aip_mem_rdata;
	
	reg ram_ready;
	wire [31:0] ram_rdata;
	
	wire sel_mem;
  
  	// IP_Module0
    localparam IP0_BASE_ADDR = 32'h80000100;
    localparam IP0_RANGE     = IP0_BASE_ADDR + 32'h00000100;
       
 	wire         	sel_aip, mem_readyAIP;
   	wire [31:0]  	mem_rdata_AIP;

    assign sel_aip = (((IP0_BASE_ADDR <= mem_addr) && (mem_addr <= (IP0_RANGE))))? 1'b1 : 1'b0;

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
			simpleuart_reg_div_sel || (simpleuart_reg_dat_sel && !simpleuart_reg_dat_wait) || (sel_aip && mem_readyAIP) ;

	assign mem_rdata = (iomem_valid && iomem_ready) ? iomem_rdata :rom_ready ? rom_mem_rdata : ram_ready ? ram_rdata : simpleuart_reg_div_sel ? simpleuart_reg_div_do :
			simpleuart_reg_dat_sel ? simpleuart_reg_dat_do : sel_aip? mem_rdata_AIP :32'h 0000_0000;
			
			
				
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
		.resetn      (resetn     ),// & (!(rdDataConfigReg[0]))   ),
		.mem_valid   (mem_valid  ),
		.mem_instr   (mem_instr  ),
		.mem_ready   (mem_ready  ),
		.mem_addr    (mem_addr   ),
		.mem_wdata   (mem_wdata  ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_rdata   (mem_rdata  ),
		.irq         (irq        )
	);

	native_aip CPU_to_aip(
    	.i_clk				(clk),
    	.i_rst				(resetn),

		.i_cpu_mem_valid	(mem_valid),
		.i_cpu_mem_addr		(mem_addr),
		.i_cpu_mem_wdata	(mem_wdata),
		.i_cpu_mem_wen		(mem_valid && !mem_readyAIP &&((sel_aip)? |(mem_wstrb) : 1'b0)),

		.o_cpu_mem_rdata	(mem_rdata_AIP),
		.o_cpu_mem_ready	(mem_readyAIP),
		.o_cpu_irq			(),

    // aip interface
    	.i_aip_sel			(sel_aip),
    	.i_aip_enable		(1'b1),
    	.i_aip_dataOut		(dataOutAIP_uP),
    	.o_aip_dataIn		(dataInAIP_uP),
    	.o_aip_config		(configAIP_uP),
    	.o_aip_read			(readAIP_uP),
    	.o_aip_write		(writeAIP_uP),
    	.o_aip_start		(startAIP),
    	.i_aip_int			(),
    	.o_core_int			()
	);

//---	
	picosoc_mem_rom #(
                .WORDS(MEM_WORDS)) memoryROM (
                .clk(clk),
                //.wen((mem_valid && mem_addr >= 4*MEM_WORDS && mem_addr < 32'h 0200_0000) ? mem_wstrb : 4'b0),
                .addr(mem_addr[$clog2(MEM_WORDS)-1 + 2 :2]),
                //.wdata(mem_wdata),
                .rdata(rom_mem_rdata)
	);
//---
	picosoc_mem #(
		.WORDS(MEM_WORDS/2)
	) memory (
		.clk(clk),
		.wen((mem_valid && !mem_ready && mem_addr < 4*MEM_WORDS) ? mem_wstrb : 4'b0),
		.addr(mem_addr[$clog2(MEM_WORDS)-1 + 2 :2]),
		.wdata(mem_wdata),
		.rdata(ram_rdata)
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
		$readmemh("../picosoc/firmware/main_out.txt", mem);
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