/*
 * Author:         Jorge Sanchez (jmsanchez@gdl.cinvestav.mx)
 * Create Date:    03/23/2017 
 * Module Name:    status 
 * Description:    IP-core Status Register.
 * - If you're an IP-core designer, don't change the file.
 * Revision: 
 * Revision 0.1 - File Created
 * Additional Comments:
 *
 */

/*
-------------------------------------------------------------------------------------------------
|                                   STATUS/INTERRUPTION FLAGS                                   |
-------------------------------------------------------------------------------------------------
|     7     |     6     |     5     |     4     |     3     |     2     |     1     |     0     |
-------------------------------------------------------------------------------------------------
|     UD    |     UD    |     UD    |     UD    |     UD    |     UD    |     UD    |   Done    |
-------------------------------------------------------------------------------------------------
|     15    |     14    |     13    |     12    |     11    |     10    |     9     |     8     |
-------------------------------------------------------------------------------------------------
|     UD    |     UD    |     UD    |     UD    |     UD    |     UD    |     UD    |   Busy    |
-------------------------------------------------------------------------------------------------
UD = User Define
*/

module status
#(
    parameter SIZE_REG      = 'd32,
    parameter STAT_WIDTH    = 'd16
)
(
    input   wire                        clk,
    input   wire                        rst_a,
    input   wire                        en_clear,       //enable to clear the flags
    input   wire    [STAT_WIDTH-1:0]    clear,          //set in 1 all flags to clear
    input   wire    [STAT_WIDTH-1:0]    mask,           //set in 1 all flags can send a interruption
    input   wire    [STAT_WIDTH-1:0]    status_IPcore,  //data of IP-core to set the flags value
    output  wire    [SIZE_REG-1:0]      data_status,    //data IP-core status value
    output  wire                        int_req         //interruption request
);

    reg [STAT_WIDTH-1:0]  regStatus;
    reg [(STAT_WIDTH/2)-1:0]  maskStatus;

    assign data_status  = {maskStatus,regStatus};
    assign int_req      = ~|(regStatus[7:0] & maskStatus[7:0]); 

    genvar i;

    generate
        for ( i = 0; i < STAT_WIDTH; i = i+1 ) begin : buff
            if (i >= 8) begin       // Status flags
                always @ (posedge clk or negedge rst_a) begin
                    if(!rst_a)
                        regStatus[i] <= 1'b0;
                    else begin
                        regStatus[i] <= status_IPcore[i];
                    end
                end
            end
            else begin              // Interruption flags
                always @ (posedge clk or negedge rst_a) begin
                    if(!rst_a)
                        regStatus[i] <= 1'b0;
                    else begin
                        if (clear[i] & en_clear)
                            regStatus[i] <= 1'b0;
                        else if (status_IPcore[i])
                            regStatus[i] <= 1'b1;
                        else
                            regStatus[i] <= regStatus[i];
                    end
                end
            end
        end
    endgenerate
    
    always @(posedge clk or negedge rst_a) begin
        if(!rst_a)
            maskStatus      <=  {(STAT_WIDTH/2){1'b0}};
        else if(en_clear)
            maskStatus      <=  mask[7:0];
    end

endmodule
