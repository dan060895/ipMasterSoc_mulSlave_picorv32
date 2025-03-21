module native_aip (
    input i_clk,
    input i_rst,

    input          i_cpu_mem_valid,
    input  [31:0]  i_cpu_mem_addr,
    input  [31:0]  i_cpu_mem_wdata,
    input  	   i_cpu_mem_wen,
        
    output reg  [31:0]  o_cpu_mem_rdata,
    output reg         o_cpu_mem_ready,
    output         o_cpu_irq,

    // aip interface
    input           i_aip_sel,
    input           i_aip_enable,
    input  [31:0]   i_aip_dataOut,
    output [31:0]   o_aip_dataIn,
    output [4:0]    o_aip_config,
    output reg 	    o_aip_read,
    output reg 	    o_aip_write,
    output 	        o_aip_start,
    input           i_aip_int,

    output          o_core_int
);


    wire [31:0] reg0; // aipDataOut
    reg [31:0] reg4; // aipDataIn
    reg [31:0] reg8; // aipConfig
    reg [31:0] reg12;
    reg start_w;
    wire busCtrl_askWrite;
    wire busCtrl_askRead;
    wire busCtrl_doWrite;
    wire busCtrl_doRead;

    assign o_aip_dataIn = reg4;
    assign o_aip_config = reg8;
    assign o_aip_start = start_w;
    assign o_core_int = i_aip_int;

    assign reg0 = i_aip_dataOut;

    always @ (*) begin
        o_cpu_mem_rdata = 32'h0;

        case(i_cpu_mem_addr[7:0])
            8'b00001100 : begin
            end
            8'b00001000 : begin
            end
            8'b00000100 : begin
            end
            8'b00000000 : begin
                o_cpu_mem_rdata = reg0;
            end
            default : begin
            end
        endcase
    end

    assign busCtrl_askWrite = ((i_aip_sel && i_aip_enable) && (i_cpu_mem_wen));
    assign busCtrl_askRead = ((i_aip_sel && i_aip_enable) && (! ((i_cpu_mem_wen))));
    assign busCtrl_doWrite = (((i_aip_sel && i_aip_enable) ) && (i_cpu_mem_wen));
    assign busCtrl_doRead = (((i_aip_sel && i_aip_enable && i_cpu_mem_valid && o_cpu_mem_ready) ) && (! ((i_cpu_mem_wen))) && (!o_aip_write));

    always @ (posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            reg4 <= 32'h0;
            reg8 <= 32'h0;
            reg12 <= 32'h0;
	    o_cpu_mem_ready <= 1'b0;
        end
        else begin
	    o_cpu_mem_ready <= i_aip_sel;

            case(i_cpu_mem_addr[7:0])
                8'b00001100 : begin
                    if(busCtrl_doWrite)begin
                        reg12 <= i_cpu_mem_wdata[31:0];
                    end
                end
                8'b00001000 : begin
                    if(busCtrl_doWrite)begin
                        reg8 <= i_cpu_mem_wdata[31:0];
                    end
                end
                8'b00000100 : begin
                    if(busCtrl_doWrite)begin
                        reg4 <= i_cpu_mem_wdata[31:0];
                    end
                end
                8'b00000000 : begin
                end
                default : begin
                end
            endcase
        end
    end

    // Buffer
    // Write and read should be filtered out
    // when no write_data, write_conf or read_data are issued
    always @(*) begin
        o_aip_read <= busCtrl_doRead && ( i_cpu_mem_addr[7:0] == 8'b00000000);
        if (busCtrl_doWrite && (i_cpu_mem_addr[7:0] == 8'b00001100)) start_w <= i_cpu_mem_wdata[0];
        else start_w <= 1'b0;
    end

    always @(posedge i_clk) begin
        o_aip_write <= busCtrl_doWrite && ( i_cpu_mem_addr[7:0] == 8'b00000100);
    end

endmodule
