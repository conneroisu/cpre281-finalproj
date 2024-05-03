`timescale 1ns / 1ps
module Instruction_memory (
    input             reset,         // Reset signal added
    input      [31:0] i_Addr,        // [31-0]  Address input
    output reg [ 5:0] i_Ctr,         // [31-26] Control signals
    output reg [ 5:0] i_Funcode,     // [5-0]   Function code
    output reg [31:0] i_Instruction  // [31-0]  Instruction output
);
  parameter SIZE_IM = 128;  // Size of this memory, by default 128*32
  reg [31:0] Imem[SIZE_IM-1:0];  // Instruction memory
  reg [31:0] Imem_backup[SIZE_IM-1:0];  // Backup of initial instruction memory
  integer n;
  initial begin
    for (n = 0; n < SIZE_IM; n = n + 1) begin
      Imem[n] = 32'b11111100000000000000000000000000;
      Imem_backup[n] = 32'b11111100000000000000000000000000;  // Initialize backup
    end
    $readmemb("instructions.mem", Imem);
    for (n = 0; n < SIZE_IM; n = n + 1) begin
      Imem_backup[n] = Imem[n];
    end
    i_Instruction = 32'b11111100000000000000000000000000;
  end
  always @(reset or i_Addr) begin
    if (reset) begin
      for (n = 0; n < SIZE_IM; n = n + 1) begin
        Imem[n] = Imem_backup[n];
      end
      i_Instruction = 32'b11111100000000000000000000000000;
    end else if (i_Addr == -4) begin
      i_Instruction = 32'b11111100000000000000000000000000;
    end else begin
      i_Instruction = Imem[i_Addr>>2];
    end
    i_Ctr = i_Instruction[31:26];
    i_Funcode = i_Instruction[5:0];
  end
endmodule
