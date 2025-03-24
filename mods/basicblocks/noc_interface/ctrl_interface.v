/*
 * Author:         Jorge Sanchez (jmsanchez@gdl.cinvestav.mx)
 * Create Date:    03/23/2017 
 * Module Name:    ctrl_interface 
 * Description:    Interface Control for protocol
 * - If you're an IP-core designer, to change the number of memories check the pdf file.
 * Revision: 
 * Revision 0.1 - File Created
 * Additional Comments:
 *
 */

module ctrl_interface
#(
    parameter ADDR_WIDTH_PTR  = 'd6,    //This value must be the bigest value of ADDR_WIDTH_MEMI or ADDR_WIDTH_MEMO
	parameter ADDR_WIDTH_MEMI = 'd6,
	parameter ADDR_WIDTH_MEMO = 'd6,
	parameter ADDR_WIDTH_CR   = 'd1,
    parameter SIZE_MUX        = 'd3
)
(   
    input   wire                            clk,
    input   wire                            rst_a,
    input   wire                            en_s,
    input   wire                            read,               //Used for protocol to read different information types
    input   wire                            write,              //Used for protocol to write different information types
    input   wire    [4:0]                   conf_dbus,          //Used for protocol to determine different actions types
    input   wire    [ADDR_WIDTH_PTR-1:0]    init_ptr,           //Set the new pointer value for memories or configuration register
    output  wire    [SIZE_MUX-1:0]          sel_mux,            //Data out selecter
    output  reg     [ADDR_WIDTH_CR-1:0]     wr_addr_ConfigReg,  //Address to write in Configuration Registers
    output  reg     [ADDR_WIDTH_MEMI-1:0]   wr_addr_MemIn0,     //Address to write in Memory In 0
    output  reg     [ADDR_WIDTH_MEMO-1:0]   rd_addr_MemOut0,    //Address to read from Memory Out 0
    output  wire                            en_clear,           //enable to clear the flags
    output  wire                            wr_en_ConfigReg,    //Enable the write in configuration_register
    output  wire                            wr_en_MemIn0        //Enable the write in Memory In 0
);

    reg wr_en;
    reg wr_en_cr;

// Config definition
    localparam  CONF_REG    = 5'b00000,
                MEM_IN      = 5'b00001,
                MEM_OUT     = 5'b00010,
                CR_WR_PTR   = 5'b00011,
                MI_WR_PTR   = 5'b00100,
                MO_RD_PTR   = 5'b00101,
                STAT_REG    = 5'b11110,
                ID_REG      = 5'b11111;
            
// Mux out definition.
    localparam  MUX_ID          = 3'b000,
                MUX_STAT        = 3'b001,
                MUX_PARM        = 3'b010,
                MUX_DATAo       = 3'b011,
                MUX_DATAi       = 3'b100,
                MUX_PTR_WRcr    = 3'b101,
                MUX_PTR_WRi     = 3'b110,
                MUX_PTR_RDo     = 3'b111;

// Write and read controlled by config. Add more signals for every memory in
    assign  en_clear        =   write & (conf_dbus == STAT_REG);
    assign  wr_en_MemIn0    =   write & (conf_dbus == MEM_IN);  // this signal is for memory in
    assign  wr_en_ConfigReg =   write & (conf_dbus == CONF_REG);

// Data out controlled by config. To increase number of data outs, you should also change the mux4g.v file.
    assign  sel_mux  =  (conf_dbus == CONF_REG)    ?   MUX_PARM    : 
                        (conf_dbus == MEM_OUT)     ?   MUX_DATAo   :
                        (conf_dbus == MEM_IN)      ?   MUX_DATAi   :
                        (conf_dbus == STAT_REG)    ?   MUX_STAT    :
                        (conf_dbus == CR_WR_PTR)   ?   MUX_PTR_WRcr:
                        (conf_dbus == MI_WR_PTR)   ?   MUX_PTR_WRi :
                        (conf_dbus == MO_RD_PTR)   ?   MUX_PTR_RDo : MUX_ID;

// Control of address memory. Add more signals for every memory in, memory out or configuration register
    always @(posedge clk) begin
        wr_en      <= (write && conf_dbus == MEM_IN);
        wr_en_cr   <= (write && conf_dbus == CONF_REG);
    end

    always @(posedge clk or negedge rst_a) begin
        if (!rst_a) begin
            wr_addr_ConfigReg   <= 'd0;
            wr_addr_MemIn0      <= 'd0;
            rd_addr_MemOut0     <= 'd0;
        end
        else begin
            if (en_s) begin
                if (write && conf_dbus == CR_WR_PTR)
                    wr_addr_ConfigReg   <= init_ptr[ADDR_WIDTH_CR-1:0];
                else if (wr_en_cr)
                    wr_addr_ConfigReg   <= wr_addr_ConfigReg + 1'b1;
                else if (write && conf_dbus == MI_WR_PTR)
                    wr_addr_MemIn0      <= init_ptr[ADDR_WIDTH_MEMI-1:0];
                else if (wr_en)
                    wr_addr_MemIn0      <= wr_addr_MemIn0 + 1'b1;
                else if (write && conf_dbus == MO_RD_PTR)
                    rd_addr_MemOut0     <= init_ptr[ADDR_WIDTH_MEMO-1:0];
                else if (read && conf_dbus == MEM_OUT)
                    rd_addr_MemOut0     <= rd_addr_MemOut0 + 1'b1;
            end
        end
    end

endmodule
