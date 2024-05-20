`timescale 1 ns / 1 ps

module testbench #(
	parameter VERBOSE = 0
);
	reg clk = 1;
	reg resetn = 0;
	wire trap;
	integer index;
	always #5 clk = ~clk;

	initial begin
		repeat (100) @(posedge clk);
		resetn <= 1;
	end

	initial begin
		if ($test$plusargs("vcd")) begin
			$dumpfile("testb_aip.vcd");
			$dumpvars(0, testbench);
		end
		repeat (50000) @(posedge clk);
		$display("Simulation Finished!");
		$finish;
	end

	wire trace_valid;
	wire [35:0] trace_data;
	integer trace_file;
        wire [31:0] iData_Tx_I,iData_Tx_Q;
	initial begin
		if ($test$plusargs("trace")) begin
			trace_file = $fopen("testb_aip.trace", "w");
			repeat (10) @(posedge clk);
			while (!trap) begin
				@(posedge clk);
				if (trace_valid)
					$fwrite(trace_file, "%x\n", trace_data);
			end
			$fclose(trace_file);
			$display("Finished writing testb_aip.trace.");
		end
	end

	myPicoSOC_wrapper #(
		.VERBOSE (VERBOSE)
	) top (
		.clk(clk),
		.rst(resetn),
		.trap(trap),
		.trace_valid(trace_valid),
		.trace_data(trace_data)
	);
endmodule

module myPicoSOC_wrapper #(
	parameter VERBOSE = 0
) (
	input  clk,
	input  rst,
	output trap,
	output trace_valid,
	output [35:0] trace_data
);
	wire tests_passed;
	reg [31:0] irq = 0;
	wire mem_instr;

	reg [15:0] count_cycle = 0;
	always @(posedge clk) count_cycle <= rst ? count_cycle + 1 : 0;

	always @* begin
		irq = 0;
		irq[4] = &count_cycle[12:0];
		irq[5] = &count_cycle[15:0];
	end

	wire  mem_valid;
	wire  mem_ready, mem_readyMEM, mem_readIPCORE;
	wire  [31:0] mem_addr;
	wire  [31:0] mem_wdata;
	wire  [3:0]  mem_wstrb;
	wire  [31:0] mem_rdata, mem_rdata_mem, mem_rdata_ipcore;

	wire sel_mem, sel_ipcore, sel_aip;
 
 	wire         mem_readyAIP;
        wire [31:0]  mem_rdata_AIP;

        wire [31:0]     iPdataIn, iPdataOut;
        wire            iPwrite, iPread, iPstart;
        wire [4:0]      iPconf;
        wire [15:0]     iPINTstatus;

        assign sel_aip = (((32'h80000100  <= mem_addr) && (mem_addr <= 32'h80000200)))? 1'b1 : 1'b0;

	assign sel_mem    = mem_valid && (mem_addr <  32'h4000_0000); //128 * 1024 = 20000000
	assign sel_ipcore = mem_valid && ( (32'h80000000  < mem_addr) && (mem_addr <= 32'h80000080));
	
	assign mem_rdata = sel_ipcore?mem_rdata_ipcore:sel_aip? mem_rdata_AIP : mem_rdata_mem;
	//assign mem_rdata = sel_mem? mem_rdata_mem:sel_ipcore?mem_rdata_ipcore:32'h00000000;
	
	//assign mem_ready = sel_mem? mem_readyMEM:sel_ipcore?mem_readIPCORE:1'b0;
	assign mem_ready = sel_ipcore?mem_readIPCORE:mem_readyMEM;
	
	//always @(posedge clk)
	//	mem_ready <= mem_valid && mem_addr < 128*1024/4;
		
	picorv32 #(
		.BARREL_SHIFTER(0),
		.COMPRESSED_ISA(1),
		.ENABLE_COUNTERS(1),
		.ENABLE_MUL(1),
		.ENABLE_DIV(1),
		.ENABLE_FAST_MUL(0),
		.ENABLE_IRQ(1),
		.ENABLE_IRQ_QREGS(1),
		.ENABLE_TRACE(1)
	) cpu (
		.clk         (clk        ),
		.resetn      (rst        ),
		.mem_valid   (mem_valid  ),
		.mem_instr   (mem_instr  ),
		.mem_ready   (mem_ready  ),
		.mem_addr    (mem_addr   ),
		.mem_wdata   (mem_wdata  ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_rdata   (mem_rdata  ),
		.irq         (irq        ),
		
		.trap        (trap),
		.trace_valid (trace_valid),
		.trace_data  (trace_data)
	);
//	wire sel_mem;
	//assign sel_mem = (mem_addr < 128*1024/4)? 1'b1:1'b0;
	picosoc_mem #(
		//.WORDS(128*1024)
		.WORDS(128*1024)
	) memory (
		.clk(clk),
		.resetn      	(rst      ),
		.mem_valid   	(mem_valid),
		.mem_ready   	(mem_readyMEM),
		.wen		((mem_valid && !mem_readyMEM && sel_mem) ? mem_wstrb : 4'b0),
		//.wen		(mem_wstrb)
		.addr		(mem_addr ),
		.wdata		(mem_wdata),
		.rdata		(mem_rdata_mem)
	);
	
	Ipcore_regs  //if ( (32'h20000000  < addr) && <= 32'h20000080) begin
	IPCORE (
		.clk(clk),
		.resetn      	(rst      ),
		.mem_valid   	(mem_valid),
		.mem_ready   	(mem_readIPCORE),
		.wen		(mem_valid && !mem_readIPCORE && ((32'h80000000  < mem_addr) && (mem_addr <= 32'h80000080))? mem_wstrb : 4'b0),
		//.wen		(mem_wstrb),
		.addr		(mem_addr ),
		.wdata		(mem_wdata),
		.rdata		(mem_rdata_ipcore)
	);


	native_aip CPU_2_aip(
    		.i_clk			(clk),
    		.i_rst			(rst),

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
	    .rst 	(rst),
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
	  
	  
	reg [1023:0] firmware_file;
	initial begin
		if (!$value$plusargs("firmware=%s", firmware_file)) begin
			firmware_file = "firmware/firmware.hex";
			$display("Firmware charged!");
			end
		$readmemh(firmware_file, memory.mem);
	end
	
endmodule


module Ipcore_regs (
	input clk, mem_valid,
	input  resetn,
	input [3:0] wen,
	input [31:0] addr,
	input [31:0] wdata,
	output reg [31:0] rdata,
	output mem_ready,
	input  mem_instr
);
	reg [31:0] regs [0:31];
	reg rmem_ready;
	//128 * 1024 = 20000000
	reg  [31:0] addri;
	reg [31:0] adr_r;
	
	
	wire [31:0] raddr = addr[31:0];
	wire [31:0] raddr2 = raddr[31:0];
	
	wire [31:0] waddr = adr_r[31:2];
	wire [31:0] waddr2 = waddr[31:0];
	
	always @(posedge clk) begin
		adr_r <= addr;
		if(mem_valid)
			addri <= addr;
		if (!resetn)
		begin
			adr_r <= {32{1'b0}};
		end
	end
	
	assign mem_ready = mem_valid & rmem_ready;
	
	always @(posedge clk) begin
		rmem_ready <= 0;
		if(mem_valid && !rmem_ready) begin
			if ( (32'h80000000  < waddr2) && (waddr2 <= 32'h80000080)) begin
				rdata <= regs[raddr2];
				rmem_ready <= 1;
			end						
		end
		if (waddr2 < 128 * 1024 / 4) begin
			if (wen[0] && mem_ready) regs[waddr2][ 7: 0] <= wdata[ 7: 0];
			if (wen[1] && mem_ready) regs[waddr2][15: 8] <= wdata[15: 8];
			if (wen[2] && mem_ready) regs[waddr2][23:16] <= wdata[23:16];
			if (wen[3] && mem_ready) regs[waddr2][31:24] <= wdata[31:24];
		end

	end
	
endmodule

module picosoc_mem #(
	parameter integer WORDS = 256,
	parameter memfile = ""
) (
	input clk, mem_valid,
	input  resetn,
	input [3:0] wen,
	input [31:0] addr,
	input [31:0] wdata,
	output reg [31:0] rdata,
	output mem_ready,
	input  mem_instr
);
	reg rmem_ready;
	reg wmem_ready;
	//reg [31:0] mem [0:128*1024/4-1];
	reg [31:0] mem [0:WORDS -1];
	reg  [31:0] addri;
	reg [31:0] adr_r;
	
	//wire [31:0] raddr = addri[31:2];
	wire [31:0] raddr = addr[31:2];
	wire [$clog2(WORDS/4)-1:0] raddr2 = raddr[$clog2(WORDS/4)-1:0];
	
	wire [31:0] waddr = adr_r[31:2];
	wire [$clog2(WORDS/4)-1:0] waddr2 = waddr[$clog2(WORDS/4)-1:0];
	
	always @(posedge clk) begin
		adr_r <= addr;
		if(mem_valid)
			addri <= addr;
		if (!resetn)
		begin
			adr_r <= {32{1'b0}};
		end
	end
	
	assign mem_ready = mem_valid & rmem_ready;
	
	always @(posedge clk) begin
		rmem_ready <= 0;
		wmem_ready <= 0;
		if(mem_valid && !rmem_ready) begin
			if (raddr2 < WORDS) begin
				rdata <= mem[raddr2];
				rmem_ready <= 1;
			end						
		end
		if (waddr2 < WORDS) begin
			if (wen[0] && mem_ready) mem[waddr2][ 7: 0] <= wdata[ 7: 0];
			if (wen[1] && mem_ready) mem[waddr2][15: 8] <= wdata[15: 8];
			if (wen[2] && mem_ready) mem[waddr2][23:16] <= wdata[23:16];
			if (wen[3] && mem_ready) mem[waddr2][31:24] <= wdata[31:24];
		end
		if ((waddr2 < WORDS )&&(wen[3]|wen[2]|wen[1]|wen[0])) begin

			wmem_ready <= 1;
		end
		else
			wmem_ready <= 0;
	end
	
	wire [3:0]  mem_wstrb;	
	
	assign mem_instr = wen;
	
	/*always @(posedge clk) begin
		if (mem_valid) begin
			if (mem_instr)
				$display("ifetch 0x%08x: 0x%08x", addr, rdata);
			else if (mem_wstrb)
				$display("write  0x%08x: 0x%08x (wstrb=%b)", addr, wdata, mem_wstrb);
			else
				$display("read   0x%08x: 0x%08x", addr, rdata);
		end
	end*/
endmodule

