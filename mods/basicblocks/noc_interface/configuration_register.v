/*
 * Author:         Abisai
 * Create Date:    03/23/2017 
 * Module Name:    configuration_register 
 * Description: 
 * - Register
 * - With WR enable
 * - Sync in/out data ports
 * - Single clock
 * Revision: 
 * Revision 0.1 - File Created
 * Revision 0.2 - Check the operation duplicity (TODO).
 * Additional Comments:
 * TODO: Hay que revisar los limites entre la memoria ram y este archivo para inferir registros o memoria del FPGA
 *
 */

module configuration_register
#(
    parameter DATA_WIDTH    =   12,     // Datawidth of data
    parameter ADDR_WIDTH    =   6       // Address bits
)(
    input                       Write_clock__i, 
    input                       Write_enable_i,
    input   [(ADDR_WIDTH-1):0]  Write_addres_i,
    input   [(ADDR_WIDTH-1):0]  Read_address_i, 
    input   [(DATA_WIDTH-1):0]  data_input___i,
    output  [(DATA_WIDTH-1):0]  data_output__o
);

    reg [(DATA_WIDTH-1):0] reg_Structure [2**ADDR_WIDTH-1:0];
    
    assign  data_output__o = reg_Structure[Read_address_i];
     
    always @(posedge Write_clock__i) begin
        if (Write_enable_i) begin
            reg_Structure[Write_addres_i] = data_input___i;
        end
    end
    
endmodule
