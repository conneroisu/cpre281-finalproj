`timescale 1ns / 1ps

`define CYCLE_TIME 20

module top_tb;

  reg clk;
  // segments for the 7-segment displays
  wire [6:0] seg_first, seg_second, seg_third, seg_fourth, seg_fifth;
  integer i;  // integer  counter

  always #(`CYCLE_TIME / 2) clk = ~clk;

  top uut (
    .clk(clk),
    .seg_first(seg_first),
    .seg_second(seg_second),
    .seg_third(seg_third),
    .seg_fourth(seg_fourth),
    .seg_fifth(seg_fifth)
  );

  initial begin
    // Initialize data memory
    for (i = 0; i < 32; i = i + 1) begin
      uut.u_Data_memory.Dmem[i] = 32'b0;
    end

    // initialize Register File
    for (i = 0; i < 32; i = i + 1) begin
      uut.u_Register.RegData[i] = 32'b0;
    end

    clk = 0;
  end

  always @(posedge clk) begin

    $display($time,, "PC = ", uut.pc_in);
    $display($time,, "IM = %b", uut.im_instruction);
    $display($time,, "ALU_control = %b", uut.c_ALUcontrol);
    $display($time,, "ALU_Result = 0x%H", uut.alu_result);
    $display($time,, "ALUOp = %b", uut.c_ALUOp);
    $display($time,, "ALU_In1 = 0x%H", uut.r_read1);
    $display($time,, "Alu_In2 = 0x%H", uut.r_read2);
    $display($time,, "WB = 0x%H", uut.r_wbdata);
    $display($time,, "MemRead = ", uut.c_MemRead);
    $display($time,, "MemWrite = ", uut.c_MemWrite);

    $display(
        "========================================================================================================");

    ////////////////////////////////////////////////
    $display($time,, "R0(r0) = 0x%H, R8 (t0) = 0x%H, R16(s0) = 0x%H, R24(t8) = 0x%H",
             uut.u_Register.RegData[0], uut.u_Register.RegData[8], uut.u_Register.RegData[16],
             uut.u_Register.RegData[24]);
    $display($time,, "R1(at) = 0x%H, R9 (t1) = 0x%H, R17(s1) = 0x%H, R25(t9) = 0x%H",
             uut.u_Register.RegData[1], uut.u_Register.RegData[9], uut.u_Register.RegData[17],
             uut.u_Register.RegData[25]);
    $display($time,, "R2(v0) = 0x%H, R10(t2) = 0x%H, R18(s2) = 0x%H, R26(k0) = 0x%H",
             uut.u_Register.RegData[2], uut.u_Register.RegData[10], uut.u_Register.RegData[18],
             uut.u_Register.RegData[26]);
    $display($time,, "R3(v1) = 0x%H, R11(t3) = 0x%H, R19(s3) = 0x%H, R27(k1) = 0x%H",
             uut.u_Register.RegData[3], uut.u_Register.RegData[11], uut.u_Register.RegData[19],
             uut.u_Register.RegData[27]);
    $display($time,, "R4(a0) = 0x%H, R12(t4) = 0x%H, R20(s4) = 0x%H, R28(gp) = 0x%H",
             uut.u_Register.RegData[4], uut.u_Register.RegData[12], uut.u_Register.RegData[20],
             uut.u_Register.RegData[28]);
    $display($time,, "R5(a1) = 0x%H, R13(t5) = 0x%H, R21(s5) = 0x%H, R29(sp) = 0x%H",
             uut.u_Register.RegData[5], uut.u_Register.RegData[13], uut.u_Register.RegData[21],
             uut.u_Register.RegData[29]);
    $display($time,, "R6(a2) = 0x%H, R14(t6) = 0x%H, R22(s6) = 0x%H, R30(s8) = 0x%H",
             uut.u_Register.RegData[6], uut.u_Register.RegData[14], uut.u_Register.RegData[22],
             uut.u_Register.RegData[30]);
    $display($time,, "R7(a3) = 0x%H, R15(t7) = 0x%H, R23(s7) = 0x%H, R31(ra) = 0x%H",
             uut.u_Register.RegData[7], uut.u_Register.RegData[15], uut.u_Register.RegData[23],
             uut.u_Register.RegData[31]);

    $display(
        "---------------------------------------------------------------------------------------------------------");

    // print Data_memory
    $display($time,, "Data_memory: 0x00 = %x", {
             uut.u_Data_memory.Dmem[3], uut.u_Data_memory.Dmem[2], uut.u_Data_memory.Dmem[1],
             uut.u_Data_memory.Dmem[0]});
    $display($time,, "Data_memory: 0x04 = %x", {
             uut.u_Data_memory.Dmem[7], uut.u_Data_memory.Dmem[6], uut.u_Data_memory.Dmem[5],
             uut.u_Data_memory.Dmem[4]});
    $display($time,, "Data_memory: 0x08 = %x", {
             uut.u_Data_memory.Dmem[11], uut.u_Data_memory.Dmem[10], uut.u_Data_memory.Dmem[9],
             uut.u_Data_memory.Dmem[8]});
    $display($time,, "Data_memory: 0x0c = %x", {
             uut.u_Data_memory.Dmem[15], uut.u_Data_memory.Dmem[14], uut.u_Data_memory.Dmem[13],
             uut.u_Data_memory.Dmem[12]});
    $display($time,, "Data_memory: 0x10 = %x", {
             uut.u_Data_memory.Dmem[19], uut.u_Data_memory.Dmem[18], uut.u_Data_memory.Dmem[17],
             uut.u_Data_memory.Dmem[16]});
    $display($time,, "Data_memory: 0x14 = %x", {
             uut.u_Data_memory.Dmem[23], uut.u_Data_memory.Dmem[22], uut.u_Data_memory.Dmem[21],
             uut.u_Data_memory.Dmem[20]});
    $display($time,, "Data_memory: 0x18 = %x", {
             uut.u_Data_memory.Dmem[27], uut.u_Data_memory.Dmem[26], uut.u_Data_memory.Dmem[25],
             uut.u_Data_memory.Dmem[24]});
    $display($time,, "Data_memory: 0x1c = %x", {
             uut.u_Data_memory.Dmem[31], uut.u_Data_memory.Dmem[30], uut.u_Data_memory.Dmem[29],
             uut.u_Data_memory.Dmem[28]});

    $display(
        "========================================================================================================");
  end

  initial begin
    #1800;
    $display("%0dth fibonacci number = %0d\n", uut.u_Register.RegData[16],
             uut.u_Register.RegData[17]);
  end

  initial begin
    #1800 $finish;
  end


endmodule

