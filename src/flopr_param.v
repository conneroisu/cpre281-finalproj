// file: flopr_param.v
// author: @conneroisu
// desc: A parameterized flop with a reset
module flopr_param (
    clk,
    rst,
    q,
    d
);
  parameter n = 32;
  input clk, rst;
  input [n-1:0] d;
  output reg [n-1:0] q;
  always @(posedge clk)
    if (!rst) q <= d;
    else q <= 0;
endmodule
