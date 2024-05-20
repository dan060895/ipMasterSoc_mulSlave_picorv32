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

module testbench;
	reg clk;
	always #5 clk = (clk === 1'b0);

	localparam ser_half_period = 53;
	event ser_sample;

	initial begin
		$dumpfile("testbench.vcd");
		$dumpvars(0, testbench);

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
        assign rst = (cycle_cnt > 50 )? 1'b1 : 1'b0;
        
	wire led1, led2, led3, led4, led5;
	wire ledr_n, ledg_n;

	wire [6:0] leds = {!ledg_n, !ledr_n, led5, led4, led3, led2, led1};
       //-------------------------- To/From NIc --------------------------//
    reg    [4:0]                   conf_dbus;          //Used for protocol to determine different actions types
    reg                            read;               //Used for protocol to read different information types
    reg                            write;              //Used for protocol to write different information types
    reg                            start;              //Used to start the IP-core
    reg    [DATA_WIDTH-1:0]        data_in;            //different data in information types
    wire                           int_req;            //Interruption request
    wire    [DATA_WIDTH-1:0]       data_out;           //different data out information types

	wire ser_rx;
	wire ser_tx;


	wire rom_mem_valid;
	wire mem_valid;
	wire rom_ready;
	wire ram_ready;
	wire iomem_valid;
	
	wire [15:0] rom_debug;


	always @(leds) begin
		#1 $display("%b", leds);
	end

	max10_picosoc #(
		// We limit the amount of memory in simulation
		// in order to avoid reduce simulation time
		// required for intialization of RAM
		//.MEM_WORDS(256)
	) uut (
		.clk           (clk      ),
		.rst           (rst      ), 
		.ena	       (1'b1     ),
		.led1          (led1     ),
		.led2          (led2     ),
		.led3          (led3     ),
		.led4          (led4     ),
		.led5          (led5     ),
		.ledr_n        (ledr_n   ),
		.ledg_n        (ledg_n   ),
		.ser_rx        (ser_rx   ),
		.ser_tx        (ser_tx   ),
		.rom_mem_valid (rom_mem_valid),
		.mem_valid     (mem_valid),
		.rom_ready     (rom_ready),
		.ram_ready     (ram_ready),
		.iomem_valid   (iomem_valid),
		.rom_debug     (rom_debug),
		  //--- AIP ---//
        .dataInAIP      (data_in    ),
        .dataOutAIP     (data_out   ),
        .configAIP      (conf_dbus  ),
        .readAIP        (read       ),
        .writeAIP       (write      ),
        .startAIP       (start      ),
        .intAIP         (int_req    )
	);



endmodule
