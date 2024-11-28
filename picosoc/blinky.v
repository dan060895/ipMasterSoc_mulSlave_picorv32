module blinky #(
    parameter DELAY = 3125000
) (
    clk,
    rst,
    led
);

  input clk;
  input rst;
  output reg [7:0] led;

  reg [31:0] cnt = 0;
  reg left;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      cnt  <= 8'h00;
      led  <= ~8'h01;
      left <= 1'b1;
    end else begin
      if (DELAY <= cnt) begin
        cnt <= 32'd0;

        if (left) begin
          led <= ~((~led) << 1);
        end else begin
          led <= ~((~led) >> 1);
        end
      end else begin
        cnt <= cnt + 8'h1;

        if (8'h7F == led) begin
          left <= 1'b0;
        end else if (8'hFE == led) begin
          left <= 1'b1;
        end
      end
    end
  end

endmodule
