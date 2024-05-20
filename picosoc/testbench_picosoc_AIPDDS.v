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

`timescale 1 ns / 1 ps

module testbench_picosoc_AIPDDS;
	reg clk;
	always #5 clk = (clk === 1'b0);

	localparam ser_half_period = 53;
	event ser_sample;

	initial begin
		$dumpfile("testbench.vcd");
		$dumpvars(0, testbench_picosoc_AIPDDS);

		repeat (6) begin
			repeat (50000) @(posedge clk);
			$display("+50000 cycles");
		end
		$finish;
	end

	integer cycle_cnt = 0;

	always @(posedge clk) begin
		cycle_cnt <= cycle_cnt + 1;
	end
        
        wire rst;
        assign rst = ((cycle_cnt > 50) || (cycle_cnt <  5) )? 1'b1 : 1'b0;
        
	wire [11:0]oData_Tx_I;
	wire [11:0]oData_Tx_Q;
	
	wire led1, led2, led3, led4, led5;
	wire ledr_n, ledg_n;

	wire [6:0] leds = {!ledg_n, !ledr_n, led5, led4, led3, led2, led1};

	wire ser_rx;
	wire ser_tx;


  always @(leds) begin
		#1 $display("%b", leds);
	end

	picosoc_AIP_DDS 
		// We limit the amount of memory in simulation
		// in order to avoid reduce simulation time
		// required for intialization of RAM
		//.MEM_WORDS(256)
	 uut (
		.clk           (clk      ),
		.rst           (rst      ), 
		.ena	         (1'b1     ),
		.led1          (led1     ),
		.led2          (led2     ),
		.led3          (led3     ),
		.led4          (led4     ),
		.led5          (led5     ),
		.ledr_n        (ledr_n   ),
		.ledg_n        (ledg_n   ),
		.ser_rx        (ser_rx   ),
		.ser_tx        (ser_tx   ),
		.oData_Tx_I   (oData_Tx_I),
		.oData_Tx_Q   (oData_Tx_Q)
	);

wire clk_12Mhz;
reg [1:0] cont;
wire locked;

/*pll_CLK_12Mhz (
	.areset(rst),
	.inclk0(clk),
	.c0(clk_12Mhz),
	.locked(locked)
	);*/
	always@(posedge clk)begin
	if(!rst)
	   cont = 0;
	else
		cont <= cont + 1'b1;
	end
	assign clk_12Mhz = (cont== 2'b11)? 1'b1: 1'b0;

	reg [7:0] buffer;

	always begin
		@(negedge ser_tx);

		repeat (ser_half_period) @(posedge clk_12Mhz);
		-> ser_sample; // start bit

		repeat (8) begin
			repeat (ser_half_period) @(posedge clk_12Mhz);
			repeat (ser_half_period) @(posedge clk_12Mhz);
			buffer = {ser_tx, buffer[7:1]};
			-> ser_sample; // data bit
		end

		repeat (ser_half_period) @(posedge clk_12Mhz);
		repeat (ser_half_period) @(posedge clk_12Mhz);
		-> ser_sample; // stop bit

		if (buffer < 32 || buffer >= 127)
			$display("Serial data: %d", buffer);
		else
			$display("Serial data: '%c'", buffer);
	end

endmodule