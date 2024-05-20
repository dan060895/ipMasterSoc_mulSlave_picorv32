
package aipTask;
  task automatic aipRead;
    ref reg [31:0] aipRead_dataOutAIP;
    ref reg [4:0] aipRead_confAIP;
    ref reg aipRead_readAIP;
    output reg [31:0] aipRead_data;
    input reg [4:0] aipRead_config;
    begin
      aipRead_confAIP = aipRead_config;
      #2;
      aipRead_readAIP = 1'b1;
      #1;
      aipRead_data = aipRead_dataOutAIP;
      #1;
      aipRead_readAIP = 1'b0;
      #4;
    end
  endtask

  task automatic aipWrite;
    ref reg [31:0] aipWrite_dataInAIP;
    ref reg [4:0] aipWrite_confAIP;
    ref reg aipWrite_writeAIP;
    input reg [31:0] aipWrite_data;
    input reg [4:0] aipWrite_config;
    begin
      aipWrite_confAIP = aipWrite_config;
      aipWrite_dataInAIP = aipWrite_data;
      #2;
      aipWrite_writeAIP = 1'b1;
      #2;
      aipWrite_writeAIP = 1'b0;
      #4;
    end
  endtask

  task automatic aipStart;
    ref reg aipStart_startAIP;
    begin
      #2;
      aipStart_startAIP = 1'b1;
      #2;
      aipStart_startAIP = 1'b0;
      #4;
    end
  endtask

endpackage
