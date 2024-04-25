// file: mux2.v
// author: @conneroisu
// desc: 2-to-1 multiplexer
module mux2 (
    d0,
    d1,
    s,
    y
);
  parameter n = 32;
  input [n-1:0] d0;
  input [n-1:0] d1;
  input s;
  output [n-1:0] y;
  assign y = s ? d1 : d0;
endmodule
