`timescale 1ns / 1ps
module mips (
    input i_Clk,  // clock signal for PC and RD
    input i_Rst,
    output [6:0] o_Seg_first,
    output [6:0] o_Seg_second,
    output [6:0] o_Seg_third,
    output [6:0] o_Seg_fourth,
    output [6:0] o_Seg_fifth
);
  wire [31:0] pc_in, pc_out;
  wire [ 5:0] im_ctr;
  wire [ 5:0] im_funcode;
  wire [31:0] im_instruction;
  wire [31:0] r_wbdata, r_read1, r_read2;
  wire c_RegDst, c_Jump, c_Branch, c_Bne, c_MemRead, c_MemtoReg, c_MemWrite, c_ALUSrc, c_RegWrite;
  wire [1:0] c_ALUOp;
  wire [3:0] c_ALUcontrol;
  wire c_zero;
  wire [31:0] alu_result;
  Program_counter u_Program_counter (
      .i_Clk (i_Clk),
      .i_Next(pc_in),
      .o_Out (pc_out)
  );
  Instruction_memory u_Instruction_memory (
      .i_Clk        (i_Clk),
      .i_Rst        (i_Rst),
      .i_Addr       (pc_out),
      .i_Ctr        (im_ctr),
      .i_Funcode    (im_funcode),
      .i_Instruction(im_instruction)
  );
  Register u_Register (
      .i_Clk        (i_Clk),
      .i_Instruction(im_instruction),
      .i_RegWrite   (c_RegWrite),
      .i_RegDst     (c_RegDst),
      .i_WriteData  (r_wbdata),
      .o_ReadData1  (r_read1),
      .o_ReadData2  (r_read2)
  );
  ALU u_ALU (
      .i_data1      (r_read1),
      .i_read2      (r_read2),
      .i_Instruction(im_instruction),
      .i_ALUSrc     (c_ALUSrc),
      .i_ALUcontrol (c_ALUcontrol),
      .o_Zero       (c_zero),
      .o_ALUresult  (alu_result)
  );
  ALU_control u_ALU_control (
      .i_ALUOp      (c_ALUOp),
      .i_Instruction(im_funcode),
      .o_ALUcontrol (c_ALUcontrol)
  );
  Control u_Control (
      .i_instruction(im_instruction),
      .o_RegDst     (c_RegDst),
      .o_Jump       (c_Jump),
      .o_Branch     (c_Branch),
      .o_Bne        (c_Bne),
      .o_MemRead    (c_MemRead),
      .o_MemtoReg   (c_MemtoReg),
      .o_ALUOp      (c_ALUOp),
      .o_MemWrite   (c_MemWrite),
      .o_ALUSrc     (c_ALUSrc),
      .o_RegWrite   (c_RegWrite),
      .o_seg_first  (o_Seg_first),
      .o_seg_second (o_Seg_second),
      .o_seg_third  (o_Seg_third),
      .o_seg_fourth (o_Seg_fourth),
      .o_seg_fifth  (o_Seg_fifth)
  );
  Data_memory u_Data_memory (
      .i_clk      (i_Clk),
      .i_addr     (alu_result),  // im_instruction
      .i_wData    (r_read2),
      .i_ALUresult(alu_result),
      .i_MemWrite (c_MemWrite),
      .i_MemRead  (c_MemRead),
      .i_MemtoReg (c_MemtoReg),
      .o_rData    (r_wbdata)
  );
  Next_pc u_Next_pc (
      .i_Old        (pc_out),
      .i_Instruction(im_instruction),
      .i_Jump       (c_Jump),
      .i_Branch     (c_Branch),
      .i_Bne        (c_Bne),
      .i_Zero       (c_zero),
      .o_Next       (pc_in)
  );

endmodule
