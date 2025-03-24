/*
 * Author:         Jorge Sanchez (jmsanchez@gdl.cinvestav.mx)
 * Create Date:    03/23/2017 
 * Module Name:    ID 
 * Description:    IP-core ID value
 * - If you're an IP-core designer, don't change the file.
 * Revision: 
 * Revision 0.1 - File Created
 * Additional Comments:
 *
 */

module ID
#(
   parameter SIZE_REG   =   'd32,
   parameter ID         = 32'h00001000
)
(
    input wire                  clk,
    output reg [SIZE_REG-1:0]   data_IP_ID  //ID value
);

always @(posedge clk)
    data_IP_ID <= ID;

endmodule
