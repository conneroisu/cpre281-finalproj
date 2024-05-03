
module MIPS(
    input         clk, rst,
    input  [4:0]  ra3,
    output [31:0] pc_current, instr, result, rd3,

    input         wem, // SoC input outputs
    input  [31:0] rd_soc,
    output        we_dm,
    output [31:0] address, rd_dm, wd_dm );

    wire zero, pc_src, jump, jal, jr, alu_src, shift, we_reg, we_hi_lo, reg_dst, dm2reg;
    wire [1:0] res2reg;
    wire [2:0] alu_ctrl;

    datapath    dp    ( clk, rst,
                        pc_src, jump, jal, jr, alu_src, shift, we_reg, we_hi_lo, reg_dst, dm2reg, res2reg, alu_ctrl,
                        ra3,
                        zero, instr, pc_current, rd3, result,
                        wem, rd_soc, address, rd_dm, wd_dm );

    control_unit cu   ( zero, instr[31:26], instr[5:0],
                        pc_src, jump, jal, jr, alu_src, shift, we_reg, we_hi_lo, we_dm, reg_dst, dm2reg, res2reg, alu_ctrl );

endmodule
