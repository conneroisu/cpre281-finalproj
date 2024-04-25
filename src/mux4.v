// file: mux4.v
// author: @conneroisu
// desc: 4-to-1 multiplexer
module mux4 (
    d0,  // Data input 0
    d1,  // Data input 1
    d2,  // Data input 2
    d3,  // Data input 3
    s,   // Select input
    y    // Data output
);
  parameter n = 32;
  input [n-1:0] d0, d1, d2, d3;
  input [1:0] s;
  output reg [n-1:0] y;
  always @* begin
    case (s)
      2'b00: y <= d0;
      2'b01: y <= d1;
      2'b10: y <= d2;
      2'b11: y <= d3;
    endcase
  end
endmodule
