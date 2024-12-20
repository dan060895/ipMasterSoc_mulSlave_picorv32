`timescale 1 ns / 1 ps

module testbench_Picorv32_aipCoprocessor;
            //----------------------------------------------------------
            //.......MANDATORY TB PARAMETERS............................
            //----------------------------------------------------------
localparam  CYCLE		  = 'd20, // Define the clock work cycle in ns (user)
            DATAWIDTH     = 'd32, // AIP BITWIDTH
            MAX_SIZE_MEM  = 'd256,  // MAX MEMORY SIZE AMONG ALL AIP MEMORIES (Defined by the user)
            //------------------------------------------------------------
            //..................CONFIG VALUES.............................
            //------------------------------------------------------------           
            STATUS        = 5'd30,//Mandatory config
            IP_ID         = 5'd31,//Mandatory config
            MMEMIN0       = 5'd0, // Config values defined in the CSV file
            AMEMIN0       = 5'd1,
            MMEMIN1       = 5'd2, // Config values defined in the CSV file
            AMEMIN1       = 5'd3,
            MMEMOUT0      = 5'd4, // Config values defined in the CSV file
            AMEMOUT0      = 5'd5,
            MMEMOUT1      = 5'd6, // Config values defined in the CSV file
            AMEMOUT1      = 5'd7,
            CCONFREG      = 5'd8,
            ACONFREG      = 5'd9,
            //------------------------------------------------------------
            //..................PARAMETERS DEFINED BY THE USER............
            //------------------------------------------------------------
            SIZE_MEM0    = 'd32, //Size of the memory0 of the aipCoprocessor
            SIZE_MEM1    = 'd64, //Size of the memory0 of the aipCoprocessor
            INT_BIT_DONE = 'd0; //Bit corresponding to the Int Done flag.

    reg clk, rst, en_s;
    wire rst_a;
    reg 			 iStartIPcore;
    reg [31:0] count_cycle = 0;
    reg irq;
    //Clock source procedural block
    always #(CYCLE/2) clk = !clk;
	//always #5 clk = (clk === 1'b0);

	localparam ser_half_period = 53;
	event ser_sample;

	initial begin
		$dumpfile("testbench.vcd");
        $dumpvars(0, testbench_Picorv32_aipCoprocessor);
       /* for (integer idx = 0; idx < 1024; idx++) begin
            $dumpvars(1, testbench_Picorv32_aipCoprocessor.uut.picorv32_AIP_Accel.interface_PICORV32.memory.mem[idx]);
        end*/

		repeat (6) begin
			repeat (100000) @(posedge clk);
			$display("+50000 cycles");
		end
        $dumpall;
		$finish;
	end
    
    integer i;
    reg [DATAWIDTH-1:0] 	        tb_data;
    reg [DATAWIDTH-1:0] 		    dataSet [SIZE_MEM0-1:0];
    reg [(DATAWIDTH*SIZE_MEM0)-1:0] dataSet_packed;

	integer cycle_cnt = 0;

    always @(posedge clk) count_cycle <= rst ? count_cycle + 1 : 0;

	always @* begin
	
		//irq = count_cycle==32'd6095? 1'b1:1'b0;
        irq = &count_cycle[17-1:0];
	end

	always @(posedge clk) begin
		cycle_cnt <= cycle_cnt + 1;
	end
        
 
    assign rst_a = ((cycle_cnt > 50) || (cycle_cnt <  5) )? 1'b1 : 1'b0;
    
    //AIP Interface signals
    reg			        readAIP;
    reg			        writeAIP;
    reg			        startAIP;
    reg	[ 4:0] 	        configAIP;
    reg	[DATAWIDTH-1:0] dataInAIP;

    wire		    	     intAIP;
    wire	[DATAWIDTH-1:0]  dataOutAIP;

	wire ser_rx;
	wire ser_tx;


    reg [1023:0] firmware_file;
	reg [31:0] mem [0:2048-1];

	initial begin
        if (!$value$plusargs("firmware=%s", firmware_file)) begin
			firmware_file = "../picosoc/firmware/altera_out.txt";
			$display("Firmware charged!");
			end
		$readmemh(firmware_file, mem);
		//$readmemh("altera_out.txt", mem);
	end
    
    wire [6:0] leds;

    always @(leds) begin
		#1 $display("%b", leds);
	end

	wire        iomem_valid;
	reg         iomem_ready;
	wire [3:0]  iomem_wstrb;
	wire [31:0] iomem_addr;
	wire [31:0] iomem_wdata;
	reg  [31:0] iomem_rdata;

	reg [31:0] gpio;
	assign leds = gpio;

	always @(posedge clk) begin
		if (!rst_a) begin
			gpio <= 0;
		end else begin
			iomem_ready <= 0;
			if (iomem_valid && !iomem_ready && iomem_addr[31:24] == 8'h 03) begin
				iomem_ready <= 1;
				iomem_rdata <= gpio;
				if (iomem_wstrb[0]) gpio[ 7: 0] <= iomem_wdata[ 7: 0];
				if (iomem_wstrb[1]) gpio[15: 8] <= iomem_wdata[15: 8];
				if (iomem_wstrb[2]) gpio[23:16] <= iomem_wdata[23:16];
				if (iomem_wstrb[3]) gpio[31:24] <= iomem_wdata[31:24];
			end
		end
	end

	picorv32_aipCoprocessor 
    uut (
	
    .clk                (clk        ),
	.resetn             (rst_a      ), 

	.iomem_valid		(iomem_valid),
	.iomem_ready		(iomem_ready),
	.iomem_wstrb		(iomem_wstrb),
	.iomem_addr			(iomem_addr),
	.iomem_wdata		(iomem_wdata),
	.iomem_rdata		(iomem_rdata),

	.irq_5				(1'b0),
	.irq_6				(1'b0),

	.ser_tx				(ser_tx),
	.ser_rx				(ser_rx),
			  //--- AIP ---//
    .data_in            (dataInAIP  ),
    .data_out           (dataOutAIP ),
    .conf_dbus          (configAIP  ),
    .read               (readAIP    ),
    .write              (writeAIP   ),
    .start              (startAIP   ),
    .int_req            (intAIP     )
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
	if(!rst_a)
	   cont = 0;
	else
		cont <= cont + 1'b1;
	end
	assign clk_12Mhz = clk;//(cont== 2'b11)? 1'b1: 1'b0;

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



initial 
begin
	clk		        = 1'b1;
	en_s		    = 1'b1;
	readAIP	        = 1'b0;
	writeAIP	    = 1'b0;
	startAIP	    = 1'b0;
	configAIP   	= 5'd0;
	dataInAIP   	= 32'd0;
    i               = 'd0;
    iStartIPcore 	= 1'b1;
	rst		        = 1'b0;	// reset is active

	#(CYCLE) rst	= 1'b1;	// at time #n release reset
    writeConfReg(CCONFREG, 1, 1,0);  // Reset CPU -- .resetn(resetn  & (!(rdDataConfigReg[0]))   ),
	#(500*CYCLE)
     // READ IP_ID
    getID(tb_data);
    $display ("%7T Read ID %h", $time, tb_data);
     
    // READ STATUS
    getStatus(tb_data);
    $display ("%7T Read STATUS %h", $time, tb_data);
     
    //(INTERRUPTIONS) 
    //FOR ENABLING INTERRUPTIONS
    enableINT(INT_BIT_DONE);
     
    writeConfReg(CCONFREG, 1, 1,0);  // Reset CPU -- .resetn(resetn  & (!(rdDataConfigReg[0]))   ),
    //****CONVERTION TO A SINGLE ARRAY
    for (i = 0; i < (128) ; i=i+1) begin 
        dataSet_packed[DATAWIDTH*i+:DATAWIDTH] = mem[i]; 
        $display("%7T PROGRAM  addr%h: word %h", $time,i,mem[i]);
    end        
    
    $display("%7T writing PROGRAM to MEMIN0", $time);
    writeMem(MMEMIN0, dataSet_packed, SIZE_MEM0,0);
    //SET POINTER
    single_write(AMEMIN0, 0);
    writeMem(MMEMIN1, dataSet_packed, SIZE_MEM1,0);
    //SET POINTER
    single_write(AMEMIN1, 0);

    
	#(50*CYCLE)
    writeConfReg(CCONFREG, 15, 1,0);  // Reset CPU -- .resetn(resetn  & (!(rdDataConfigReg[0]))   ),
    writeConfReg(CCONFREG, 11, 1,1);  // Reset CPU -- .resetn(resetn  & (!(rdDataConfigReg[0]))   ),
    writeConfReg(CCONFREG, 12, 1,2);  // Reset CPU -- .resetn(resetn  & (!(rdDataConfigReg[0]))   ),
    writeConfReg(CCONFREG, 13, 1,3);  // Reset CPU -- .resetn(resetn  & (!(rdDataConfigReg[0]))   ),
     // START PROCESS
    #(50000*CYCLE)
    $display("%7T Sending start", $time);
    start();
    // START PROCESS
    $display("%7T Sending start", $time);
    #(10000*CYCLE);
	$display($time, " << finishing Simulation >>");
end


//*******************************************************************
//*********************TASKS DEFINITION******************************
//*******************************************************************

task getID;
   output [DATAWIDTH-1:0] read_ID;
      
      begin
         single_read(IP_ID,read_ID);
      end
endtask

task getStatus;
   output [DATAWIDTH-1:0] read_status;
      
      begin
         single_read(STATUS,read_status);
      end
endtask

task writeMem;
        input [                         4:0] config_value;
        input [(DATAWIDTH*MAX_SIZE_MEM)-1:0] write_data;
        input [               DATAWIDTH-1:0] length;
        input [               DATAWIDTH-1:0] offset;
        
        begin        
            //SET POINTER
            single_write(config_value+1, offset);
            
            //WRITE MEMORY
            configAIP = config_value;
            #(CYCLE)
            for(i=0; i < length ; i= i+1) begin
               dataInAIP = mem[i];//write_data[(i*DATAWIDTH)+:DATAWIDTH];
               #(CYCLE);
               writeAIP = 1'b1;
               #(CYCLE);
               writeAIP = 1'b0;
            end
            writeAIP = 1'b0;
            #(CYCLE);
        end
endtask

task writeConfReg;
        input [                         4:0] config_value;
        input [(DATAWIDTH*MAX_SIZE_MEM)-1:0] write_data;
        input [               DATAWIDTH-1:0] length;
        input [               DATAWIDTH-1:0] offset;
        
        begin        
            //SET POINTER
            single_write(config_value+1, offset);
            
            //WRITE MEMORY
            configAIP = config_value;
            #(CYCLE)
            for(i=0; i < length ; i= i+1) begin
               dataInAIP = write_data[(i*DATAWIDTH)+:DATAWIDTH];
               #(CYCLE);
               writeAIP = 1'b1;
               #(CYCLE);
            end
            writeAIP = 1'b0;
            #(CYCLE);
        end
endtask



task readMem;
        input [                         4:0] config_value;   
        output[(DATAWIDTH*MAX_SIZE_MEM)-1:0] read_data;     
        input [               DATAWIDTH-1:0] length;
        input [               DATAWIDTH-1:0] offset;        
        
        begin
            //SET POINTER
            single_write(config_value+1, offset);
        
            configAIP = config_value;
            #(CYCLE)
            for(i=0; i < length ; i= i+1) begin               
               readAIP = 1'b1;
               #(CYCLE);
               read_data[(i*DATAWIDTH)+:DATAWIDTH]=dataOutAIP;
            end
            readAIP = 1'b0;
            #(CYCLE);
        end
endtask

task enableINT;
      input [3:0] idxInt;   
      
       reg [DATAWIDTH-1:0] read_status;
       reg [7:0] mask;
       
  begin

       getStatus(read_status);
       
       mask = read_status[23:16]; //previous stored mask
       mask[idxInt] = 1'b1; //enabling INT bit

       single_write(STATUS, {8'd0,mask,16'd0});//write status reg
  end
endtask

task disableINT;
      input [3:0] idxInt;   
      
       reg [DATAWIDTH-1:0] read_status;
       reg [7:0] mask;
  begin
   
       getStatus(read_status);
       
       mask = read_status[23:16]; //previous stored mask
       mask[idxInt] = 1'b0; //disabling INT bit

       single_write(STATUS, {8'd0,mask,16'd0});//write status reg
  end
endtask

task clearINT;
      input [3:0] idxInt;   
      
       reg [DATAWIDTH-1:0] read_status;
       reg [7:0] clear_value;
       reg [7:0] mask;
    
  begin
    
       getStatus(read_status);
       
       mask = read_status[23:16]; //previous stored mask
       clear_value = 7'd1 <<  idxInt;

       single_write(STATUS, {8'd0,mask,8'd0,clear_value});//write status reg
  end
endtask

task start;
  begin
      startAIP = 1'b1;
      #(CYCLE);
      startAIP = 1'b0;
      #(CYCLE);
  end
endtask

task single_write;
        input [          4:0] config_value;
        input [DATAWIDTH-1:0] write_data;
        begin
            configAIP = config_value;
            dataInAIP = write_data;
            #(CYCLE)
            writeAIP = 1'b1;
            #(CYCLE)
            writeAIP = 1'b0;
            #(CYCLE);
        end
endtask

task single_read;
  input  [          4:0] config_value;
  output [DATAWIDTH-1:0] read_data;
  begin
      configAIP = config_value;
      #(CYCLE);
      readAIP = 1'b1;
      #(CYCLE);
      read_data = dataOutAIP;
      readAIP = 1'b0;
      #(CYCLE);
  end
endtask	

endmodule
