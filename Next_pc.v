module Next_pc (
    input [31:0] old,  // the original program addr.
    input [31:0] instruction,  // the original instruction
    input Jump,
    input Branch,
    input Bne,
    input zero,
    output reg [31:0] next
);

  reg [31:0] sign_ext;
  reg [31:0] old_alter;  // pc+4
  reg [31:0] jump;  // jump addr.
  reg [31:0] jump_update;
  reg zero_alter;

  initial begin
    next = 32'b0;
  end

  always @(old) begin
    old_alter = old + 4;
  end

  always @(zero, Bne) begin
    zero_alter = zero;
    if (Bne == 1) begin
      zero_alter = !zero_alter;
    end
  end

  always @(instruction) begin
    // Calculate the jump address from the instruction
    jump_update = {4'b0, instruction[25:0], 2'b0};
    // sign-extension
    if (instruction[15] == 1'b0) begin
      sign_ext = {16'b0, instruction[15:0]};
    end else begin
      sign_ext = {{16{1'b1}}, instruction[15:0]};
    end
    sign_ext = {sign_ext[29:0], 2'b0};  // shift left
  end

  always @(posedge Jump or posedge old_alter) begin
    // Update the jump register based on Jump signal
    if (Jump) begin
      jump = {old_alter[31:28], jump_update[27:0]};
    end else begin
      jump = jump_update;
    end
  end

  always @(old_alter, sign_ext, jump, Branch, zero_alter, Jump) begin
    // assign next program counter value
    if (Branch == 1 && zero_alter == 1) begin
      next = old_alter + sign_ext;
    end else if (Jump == 1) begin
      next = jump;
    end else begin
      next = old_alter;
    end
  end

endmodule
