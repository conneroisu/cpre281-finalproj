
module control_unit (
    input zero,
    input [5:0] opcode, funct,
    output pc_src, jump, jal, jr, alu_src, shift, we_reg, we_hi_lo, we_dm, reg_dst, dm2reg, [1:0] res2reg, [2:0] alu_ctrl );

    wire [1:0] alu_op;
    assign pc_src = branch & zero;

    maindec md (opcode, funct, branch, jump, jal, jr, alu_src, shift, we_reg, we_hi_lo, we_dm, reg_dst, dm2reg, res2reg, alu_op);
    auxdec  ad (alu_op, funct, alu_ctrl);

endmodule
