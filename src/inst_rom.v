`timescale 1ns / 1ps
module inst_rom (
    input clock,
    input reset,
    input [31:0] addr_in,
    output [31:0] data_out
);
  parameter ADDR_WIDTH = 8;
  parameter INIT_PROGRAM = "test/inst_rom.memh";
  reg [31:0] rom [0:2**ADDR_WIDTH-1];
  reg [31:0] out;
  assign data_out = {out[7:0], out[15:8], out[23:16], out[31:24]};  //flip bytes
  initial begin
    $readmemh(INIT_PROGRAM, rom);
  end
  always @(addr_in) begin
    if (reset) begin
      out = 32'h00000000;
    end else begin
      out = rom[addr_in[ADDR_WIDTH+1:2]];
    end
  end
endmodule
