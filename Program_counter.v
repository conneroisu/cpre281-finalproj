`timescale 1ns / 1ps

module Program_counter (
    input clk,
    input [31:0] next,  // the input address
    output reg [31:0] out  // the output address
);

  initial begin
    out = -4;  // NEVER REACHED ADDRESS
  end

  always @(posedge clk) begin
    out = next;
  end

endmodule

