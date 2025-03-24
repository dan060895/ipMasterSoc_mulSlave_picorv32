/*
 * Author:         Jorge Sanchez (jmsanchez@gdl.cinvestav.mx)
 * Create Date:    03/23/2017
 * Module Name:    NoC_interface
 * Description:    Top for protocol interface
 * - If you're an IP-core designer, to increase the number of memories, repeat the memory entity as needed.
 * Revision:
 * Revision 0.1 - File Created
 * Additional Comments:
 *
 */

module NoC_interface
#(
    parameter   DATA_WIDTH      =   'd32,           //define data length
    parameter   ADDR_WIDTH_MEMI =   'd6,            //define Memory In depth
  parameter   ADDR_WIDTH_MEMO =   'd6,            //define Memory Out depth
  parameter   ADDR_WIDTH_CR   =   'd1,            //define Configuration Register depth
    parameter   STAT_WIDTH      =   'd16,            //define status length
    parameter   SIZE_MUX        =   'd3,
    parameter   IP_ID           = 32'h00001001    //define IP-core ID value
)
(
    input   wire                            clk,
    input   wire                            rst_a,
    input   wire                            en_s,
//-------------------------- To/From NIc --------------------------//
    input   wire    [4:0]                   conf_dbus,          //Used for protocol to determine different actions types
    input   wire                            read,               //Used for protocol to read different information types
    input   wire                            write,              //Used for protocol to write different information types
    input   wire                            start,              //Used to start the IP-core
    input   wire    [DATA_WIDTH-1:0]        data_in,            //different data in information types
    output  wire                            int_req,            //Interruption request
    output  wire    [DATA_WIDTH-1:0]        data_out,           //different data out information types
//------------------------ To/From IP-core ------------------------//
    output  wire    [DATA_WIDTH-1:0]        data_MemIn0,        //data readed for memory in 0
    input   wire    [ADDR_WIDTH_MEMI-1:0]   rd_addr_MemIn0,     //address read for memory in 0
    output  wire    [DATA_WIDTH-1:0]        data_ConfigReg,     //data readed for configuration register
    input   wire    [ADDR_WIDTH_CR-1:0]     rd_addr_ConfigReg,  //address read for configuration register
    input   wire    [DATA_WIDTH-1:0]        data_MemOut0,       //data to write for memory out 0
    input   wire                            wr_en_MemOut0,      //enable write for memory out 0
    input   wire    [ADDR_WIDTH_MEMO-1:0]   wr_addr_MemOut0,    //address write for memory out 0
    output  wire                            start_IPcore,       //Used to start the IP-core
    input   wire    [STAT_WIDTH-1:0]        status_IPcore       //data of IP-core to set the flags value
);

    wire    [ADDR_WIDTH_MEMI-1:0]   wr_addr_MemIn0;     //address write for memory in 0
    wire                            wr_en_MemIn0;       //enable write for memory in 0

  wire    [ADDR_WIDTH_CR-1:0]     wr_addr_ConfigReg;  //address write for configuration register
    wire                            wr_en_ConfigReg;    //enable write for configuration register

  wire    [DATA_WIDTH-1:0]        dataOut_MemOut0;    //data readed for memory out 0
    wire    [ADDR_WIDTH_MEMO-1:0]   rd_addr_MemOut0;    //address read for memory out 0

  wire    [SIZE_MUX-1:0]          sel_mux;            //address read for memory out 0
    wire                            en_clear;           //enable to clear the flags

  wire    [DATA_WIDTH-1:0]        data_IP_ID;         //ID IP-core value

  wire    [31:0]                  data_status;        //Status IP-core value

    assign  start_IPcore = start;                       //Start bypass
//-------------- Memories modules --------------//
    simple_dual_port_ram_single_clk
    #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH_MEMI)
    )
    MemIn0
    (
        .Write_clock__i(clk),
        .Write_enable_i(wr_en_MemIn0),      //I:enable write for memory in 0
        .Write_addres_i(wr_addr_MemIn0),    //I:address write for memory in 0
        .Read_address_i(rd_addr_MemIn0),    //I:address read for memory in 0
        .data_input___i(data_in),           //I:data to write for memory in 0
        .data_output__o(data_MemIn0)        //O:data readed for memory in 0
    );

    simple_dual_port_ram_single_clk
    #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH_MEMO)
    )
    MemOut0
    (
        .Write_clock__i(clk),
        .Write_enable_i(wr_en_MemOut0),     //I:enable write for memory out 0
        .Write_addres_i(wr_addr_MemOut0),   //I:address write for memory out 0
        .Read_address_i(rd_addr_MemOut0),   //I:address read for memory out 0
        .data_input___i(data_MemOut0),      //I:data to write for memory out 0
        .data_output__o(dataOut_MemOut0)    //O:data readed for memory out 0
    );
//------------ End memories modules ------------//

//-------------- Conf Reg modules --------------//
    configuration_register
    #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH_CR)
    )
    ConfigReg
    (
        .Write_clock__i(clk),
        .Write_enable_i(wr_en_ConfigReg),   //I:enable write for configuration register
        .Write_addres_i(wr_addr_ConfigReg), //I:address write for configuration register
        .Read_address_i(rd_addr_ConfigReg), //I:address read for configuration register
        .data_input___i(data_in),           //I:data to write for configuration register
        .data_output__o(data_ConfigReg)     //O:data readed for configuration register
    );
//------------ End Conf Reg modules ------------//

//  Control of the memories and the addresses
    ctrl_interface
    #(
        .ADDR_WIDTH_PTR  (ADDR_WIDTH_MEMI),//This value must be the bigest value of ADDR_WIDTH_MEMI or ADDR_WIDTH_MEMO
        .ADDR_WIDTH_CR   (ADDR_WIDTH_CR),
        .ADDR_WIDTH_MEMI (ADDR_WIDTH_MEMI),  //define Memory In depth
        .ADDR_WIDTH_MEMO (ADDR_WIDTH_MEMO),  //define Memory Out depth
        .SIZE_MUX        (SIZE_MUX)
    )
    ctrl_interface
    (
        .clk                (clk),
        .rst_a              (rst_a),
        .en_s               (en_s),
        .read               (read),                         //I: Used for protocol to read different information types
        .write              (write),                        //I: Used for protocol to write different information types
        .conf_dbus          (conf_dbus),                    //I: Used for protocol to determine different actions types
        .init_ptr           (data_in[ADDR_WIDTH_MEMI-1:0]), //I: Set the new pointer value for memories or configuration register
        .sel_mux            (sel_mux),                      //O: Is a data out selecter
        .wr_addr_ConfigReg  (wr_addr_ConfigReg),            //O: Address to write in Configuration Registers
        .wr_addr_MemIn0     (wr_addr_MemIn0),               //O: Address to write in Memory In 0
        .rd_addr_MemOut0    (rd_addr_MemOut0),              //O: Address to read from Memory Out 0
        .en_clear           (en_clear),                     //O: enable to clear the flags
        .wr_en_ConfigReg    (wr_en_ConfigReg),              //O: Enable the write in configuration_register
        .wr_en_MemIn0       (wr_en_MemIn0)                  //O: Enable the write in Memory In 0
    );

  muxNto1
  #(
    .DATA_WIDTH (DATA_WIDTH),
    .SEL_WIDTH (SIZE_MUX)
  )
  DATA_OUT_MUX
  (
    .data_i({
      {{(DATA_WIDTH-ADDR_WIDTH_MEMO){1'b0}},rd_addr_MemOut0}, //I:7
      {{(DATA_WIDTH-ADDR_WIDTH_MEMI){1'b0}},wr_addr_MemIn0}, //I:6
      {{(DATA_WIDTH-ADDR_WIDTH_CR){1'b0}},wr_addr_ConfigReg}, //I:5
      32'd0, //I:4
      dataOut_MemOut0, //I:3   MEMO
      32'd0, //I:2
      data_status, //I:1   Status IP-core value
      data_IP_ID //I:0   ID IP-core value
      }), // Declaracin de datos
    .sel_i (sel_mux), //Declaracin de selector
    .data_o (data_out) //salida seleccionada
    );

//  IP-core Identifier register to be sended to NIc
    ID
    #(
        .SIZE_REG   (DATA_WIDTH),
        .ID         (IP_ID)
    )
    IDreg
    (
        .clk        (clk),
        .data_IP_ID (data_IP_ID)    //O: ID value
    );

//  Status register to be sended to NIc
    status
    #(
        .SIZE_REG   (DATA_WIDTH),
        .STAT_WIDTH (STAT_WIDTH)
    )
    status_reg
    (
        .clk            (clk),
        .rst_a          (rst_a),
        .en_clear       (en_clear),                     //I: enable to clear the flags
        .clear          (data_in[STAT_WIDTH-1:0]),      //I: set in 1 all flags to clear
        .mask           (data_in[STAT_WIDTH+15:16]),    //I: set in 1 all flags can send a interruption
        .status_IPcore  (status_IPcore),                //I: data of IP-core to set the flags value
        .data_status    (data_status),                  //O: data IP-core status value
        .int_req        (int_req)                       //O: interruption request
    );

endmodule
