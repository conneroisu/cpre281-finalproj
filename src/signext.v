// file: signext.v
// author: @conneroisu
// desc: Sign extend a 16-bit number to 32 bits
`timescale 1ns / 1ns
module signext (
    input  [15:0] a,
    output [31:0] y
);
  assign y = {{16{a[15]}}, a};
endmodule
