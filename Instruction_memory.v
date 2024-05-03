`timescale 1ns / 1ps

module Instruction_memory (
    // input clk,
    input [31:0] addr,
    output reg [5:0] ctr,  // [31-26]
    output reg [5:0] funcode,  // [5-0]
    output reg [31:0] instruction  // [31-0]
);

  parameter SIZE_IM = 128;  // size of this memory, by default 128*32
  reg [31:0] Imem[SIZE_IM-1:0];  // instruction memory

  integer n;
  initial begin
    for (n = 0; n < SIZE_IM; n = n + 1) begin
      Imem[n] = 32'b11111100000000000000000000000000;
    end
    $readmemb("instructions.mem", Imem);

    instruction = 32'b11111100000000000000000000000000;
  end

  always @(addr) begin
    if (addr == -4) begin  // init
      instruction = 32'b11111100000000000000000000000000;
    end else begin
      instruction = Imem[addr>>2];
    end
    ctr = instruction[31:26];
    funcode = instruction[5:0];
  end

endmodule
