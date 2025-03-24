//+++++++++++++++++++++++++++++++++++++++++++++++++
//   Package Declaration
//+++++++++++++++++++++++++++++++++++++++++++++++++

// Write this lines in the testbench file to integrate the tasks defined here
// `include "intfPkg.sv"
// import intfPkg::*;

// Example of use: intfPkg::task_name(<data>);
// intfPkg::wrST(16'h0008,16'h0000);

package intfPkg;
	bit [4:0]	conf_dbus	=  5'd0;
	bit [31:0]	data_in		= 31'd0;
	bit 		read		=  1'd0;
	bit 		write		=  1'd0;
	bit 		start		=  1'd0;
	parameter	CYCLE		=   'd20;
	
	task rdID;	//Read the IP ID
	begin
		conf_dbus	= 5'h1F;
		read		= 1'b1;
		#(CYCLE)
		read		= 1'b0;
		#(CYCLE);
	end
	endtask

	task rdST;	//Read the IP status
	begin
		conf_dbus	= 5'h1E;
		read		= 1'b1;
		#(CYCLE)
		read		= 1'b0;
		#(CYCLE);
	end
	endtask

	task wrST;	//Write the mask and clear flags for status (2 input parameters)
	input [15:0]   mask;
	input [15:0]   clear;
	begin
		conf_dbus	= 5'h1E;
		data_in		= {mask,clear};
		write		= 1'b1;
		#(CYCLE)
		write		= 1'b0;
		data_in		= 32'd0;
		#(CYCLE);
	end
	endtask

	task startP;	//Send one cycle start signal
	begin
		start	= 1'b1;
		#(CYCLE)
		start	= 1'b0;
		#(CYCLE);
	end
	endtask

	task setAddr;	//Write the memory in, memory out or config register  pointer, input parameters pointer and conf_dbus value (2 input parameter)
	input	[31:0]	num_data;
	input	[4:0]	conf_ptr;
	begin
		conf_dbus	= conf_ptr;
		data_in	= num_data;
		write	= 1'b1;
		#(CYCLE)
		write	= 1'b0;
		data_in	= 32'd0;
		#(CYCLE);
	end
	endtask

	task wrData;	//Write one data in the memory in or config register, input parameters data and conf_dbus value (2 input parameter)
	input [31:0]   data;
	input  [4:0]   conf_ptr;
	begin
		conf_dbus = conf_ptr;
		data_in	  = data;
		write	  = 1'b1;
		#(CYCLE)
		write	  = 1'b0;
		data_in	  = 32'd0;
		#(CYCLE);
	end
	endtask

	task rdData;	//Read one data from memory out or pointer value, input parameters data and conf_dbus value (2 input parameter)
	input	[31:0]	num_data;
	input	[4:0]	conf_ptr;
	begin
		conf_dbus	= conf_ptr;
		#(CYCLE)
		repeat (num_data) begin
			read	= 1'b1;
			#(CYCLE)
			read	= 1'b0;
			#(CYCLE);
		end
	end
	endtask

endpackage
