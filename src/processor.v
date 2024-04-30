`timescale 1ns / 1ps
`include "adder.v"
`include "alu.v"
`include "controller.v"
`include "data_memory.v"
`include "inst_rom.v"
`include "mux.v"
`include "register.v"
`include "signextender.v"
module processor(
  input clock,
  input reset,
  input [7:0] serial_in,
  input serial_valid_in,
  input serial_ready_in,
  output serial_rden_out,
  output [7:0] serial_out,
  output serial_wren_out,
  output [6:0] seg1,
  output [6:0] seg2,
  output [6:0] seg3,
  output [6:0] seg4,
  output [6:0] seg5
);
  reg [31:0] pc = 32'h003FFFFC;
  wire [31:0] pc_plus4;
  wire [31:0] instruction;
  wire RegDst;
  wire MemRead;
  wire MemtoReg;
  wire MemWrite;
  wire ALUSrc;
  wire RegWrite;
  wire [5:0] ALUOp;
  wire [4:0] write_register;
  wire [31:0] read_data_1;
  wire [31:0] read_data_2;
  wire [31:0] write_data;
  wire [31:0] instruction_extended;
  wire [31:0] alu_b;
  wire [31:0] alu_result;
  wire branch, jump;
  wire [31:0] read_data;
  adder pc_adder (.in(pc), .out(pc_plus4));
  always @(posedge clock) begin
    if (reset) begin
      pc <= 32'h003ffffc;
    end
    else if (instruction == 32'h00000000) begin
      $finish;
    end
    else begin
      pc <= pc_plus4;
    end
  end
  inst_rom instruction_memory (
    .clock(clock),
    .reset(reset),
    .addr_in(pc),
    .data_out(instruction)
  );
  controller control(
    .opcode(instruction[31:26]),
    .ALU_control(instruction[5:0]),
    .RegDst(RegDst),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .seg1(seg1),
    .seg2(seg2),
    .seg3(seg3),
    .seg4(seg4),
    .seg5(seg5)
  );
  register registers (
    .write_register(write_register),
    .write_data(write_data),
    .read_register_1(instruction[25:21]),
    .read_data_1(read_data_1),
    .read_register_2(instruction[20:16]),
    .read_data_2(read_data_2),
    .reg_write(RegWrite),
    .clock(clock)
  );
  signextender extend_instruction (
    .in(instruction[15:0]),
    .out(instruction_extended)
  );
  mux #(5) mux_write_register (
    .in_0(instruction[20:16]),
    .in_1(instruction[15:11]),
    .select(RegDst),
    .out(write_register)
  );
  mux #(32) mux_alu_b (
    .in_0(read_data_2),
    .in_1(instruction_extended),
    .select(ALUSrc),
    .out(alu_b)
  );
  mux #(32) mux_write_data (
    .in_0(alu_result),
    .in_1(read_data),
    .select(MemtoReg),
    .out(write_data)
  );
  alu ALU (
    .Func_in(ALUOp),
    .A_in(read_data_1),
    .B_in(alu_b),
    .O_out(alu_result),
    .Branch_out(branch),
    .Jump_out(jump)
  );
  data_memory Data_memory (
    .clock(clock),
    .reset(reset),
    .addr_in(alu_result),
    .writedata_in(read_data_2),
    .re_in(MemRead),
    .we_in(MemWrite),
    .size_in(2'b11),
    .readdata_out(read_data),
    .serial_in(serial_in),
    .serial_ready_in(serial_ready_in),
    .serial_valid_in(serial_valid_in),
    .serial_out(serial_out),
    .serial_rden_out(serial_rden_out),
    .serial_wren_out(serial_wren_out)
  );
endmodule
