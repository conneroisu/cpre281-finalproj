// file: MIPS_SCP.v
// author: @conneroisu
// desc: MIPS single-cycle processor

`include "datapath.v"
`include "ram.v"
`include "rom.v"
`include "control.v"


module MIPS_Processor (
    input clk,
    input reset
);
  wire [31:0] PC, Instr, ReadData, WriteData, ALUResult;
  wire RegDst, RegWrite, ALUSrc, Jump, MemtoReg, PCSrc, Zero, MemWrite;
  wire [3:0] ALUControl;
  data_path datapathcomp (
      clk,
      reset,
      RegDst,
      RegWrite,
      ALUSrc,
      Jump,
      MemtoReg,
      PCSrc,
      ALUControl,
      ReadData,
      Instr,
      PC,
      Zero,
      WriteData,
      ALUResult
  );
  control_unit controller (
      Instr[31:26],
      Instr[5:0],
      Zero,
      MemtoReg,
      MemWrite,
      ALUSrc,
      RegDst,
      RegWrite,
      Jump,
      PCSrc,
      ALUControl
  );
  ram dmem (
      clk,
      MemWrite,
      ALUResult,
      WriteData,
      ReadData
  );
  rom imem (
      PC,
      Instr
  );
endmodule
