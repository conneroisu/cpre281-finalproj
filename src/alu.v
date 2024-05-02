/*
  Func_in O_out                 "Operation"
  1000 0X (A + B)               ADD
  1000 1X (A - B)               SUB
  1001 00 (A & B)               AND
  1001 01 (A | B)               OR
  1001 10 (A ^ B)               XOR
  1001 11 ~(A | B)              NOR

  101 XX0 signed(A) < signed(B) Set-Less-Than signed
  101 XX1 A < B                 Set-Less-Than unsigned

  111 000 A                     BLTZ
  111 001 A                     BGEZ
  111 010 A                     J/AL
  111 011 A                     JR/AL
  111 100 A                     BEQ
  111 101 A                     BNE
  111 110 A                     BLEZ
  111 111 A                     BGTZ
*/
module alu (
    input [5:0] Func_in,
    input [31:0] A_in,
    input [31:0] B_in,
    output reg [31:0] O_out,
    output reg Branch_out,
    output reg Jump_out
);
  // ALU Outputs
  reg [31:0] AdderInputB;
  reg AdderCarryIn;
  reg [31:0] AdderOut;
  // AND OR XOR NOR Operations
  reg [31:0] LogicOut;
  // SLT Operations
  reg [31:0] SltOut;
  // Branches
  reg [31:0] BranchOut;
  reg Sign;
  reg Zero;
  reg LTZ;
  reg LEZ;
  reg GTZ;
  reg GEZ;
  reg Eq;
  reg DoBranch, DoJump;
  always @(*) begin
    // Add and Sub Operations
    if (Func_in[1]) begin
      AdderInputB = ~B_in;
    end else begin
      AdderInputB = B_in;
    end
    AdderOut = A_in + AdderInputB + Func_in[1];
    // Logic Out
    case (Func_in[1:0])
      2'b00: LogicOut = A_in & B_in;
      2'b01: LogicOut = A_in | B_in;
      2'b10: LogicOut = A_in ^ B_in;
      2'b11: LogicOut = ~(A_in | B_in);
    endcase
    // Set Less Than Operations
    if (Func_in[0]) begin
      SltOut = A_in < B_in;
    end else begin
      SltOut = $signed(A_in) < $signed(B_in);
    end
    // Branches and Jump Operations
    BranchOut = A_in;
    Sign = A_in[31];
    Zero = A_in[31:0] == 32'b0;
    LTZ = Sign;
    LEZ = Sign || Zero;
    GTZ = ~Sign && ~Zero;
    GEZ = ~Sign;
    Eq = A_in == B_in;
    DoBranch = 1'b0;
    DoJump = 1'b0;
    case (Func_in[2:0])
      3'b000:  //BLTZ
      DoBranch = LTZ;
      3'b001:  //BGEZ
      DoBranch = GEZ;
      3'b010:  //J/JAL
      DoJump = 1'b1;
      3'b011:  //JR/JALR
      DoJump = 1'b1;
      3'b100:  //BEQ
      DoBranch = Eq;
      3'b101:  //BNE
      DoBranch = ~Eq;
      3'b110:  //BLEZ
      DoBranch = LEZ;
      3'b111:  //BGTZ
      DoBranch = GTZ;
      default: DoBranch = 1'b0;
    endcase
    // Calculate Final ALU Result
    Branch_out = 1'b0;
    Jump_out   = 1'b0;
    if (Func_in[5:2] == 4'b1000) begin
      O_out = AdderOut;
    end else if (Func_in[5:2] == 4'b1001) begin
      O_out = LogicOut;
    end else if (Func_in[5:3] == 3'b101) begin
      O_out = SltOut;
    end else if (Func_in[5:3] == 3'b111) begin
      O_out = BranchOut;
      Branch_out = DoBranch;
      Jump_out = DoJump;
    end else begin
      O_out = 32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx;
    end
    $display("ALU %h ,%h %h", A_in, B_in, O_out);
  end
endmodule
