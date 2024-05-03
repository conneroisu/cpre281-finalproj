`timescale 1ns / 1ps

module tb_MIPS;
    reg         clk, rst;
    wire        we_dm;
    wire [31:0] pc_current, instr, result, wd_dm, rd_dm;

    MIPS DUT ( clk, rst, 5'b0, we_dm, pc_current, instr, result, wd_dm, rd_dm);

    wire [31:0] rf_v0 = DUT.dp.rf.rf[2];
    wire [31:0] rf_a0 = DUT.dp.rf.rf[4];
    wire [31:0] rf_t0 = DUT.dp.rf.rf[8];
    wire [31:0] rf_s0 = DUT.dp.rf.rf[16];
    wire [31:0] rf_sp = DUT.dp.rf.rf[29];
    wire [31:0] rf_ra = DUT.dp.rf.rf[31];

    task tick; begin #5 clk = 1; #5 clk = 0; end endtask
    task rest; begin #5 rst = 1; #5 rst = 0; end endtask

    initial begin
        rest;
        while(pc_current != 32'h54) tick;
        $finish;
    end
endmodule
