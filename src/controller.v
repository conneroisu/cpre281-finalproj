module controller (
    input      [5:0] opcode,
    input      [5:0] ALU_control,
    output reg       RegDst,
    output reg       MemRead,
    output reg       MemtoReg,
    output reg       MemWrite,
    output reg       ALUSrc,
    output reg       RegWrite,
    output reg [5:0] ALUOp,
    output reg [6:0] seg1,
    output reg [6:0] seg2,
    output reg [6:0] seg3,
    output reg [6:0] seg4,
    output reg [6:0] seg5
);

  localparam R_DEFAULT = 6'b000000;
  localparam LW = 6'b100011;
  localparam SW = 6'b101011;
  localparam ADDI = 6'b001000;
  localparam ANDI = 6'b001100;
  localparam ORI = 6'b001101;
  localparam XORI = 6'b001110;
  localparam SLTI = 6'b001010;
  localparam SLTIU = 6'b001001;
  localparam ADD = 6'b100000;
  localparam SUB = 6'b100010;
  localparam AND = 6'b100100;
  localparam OR = 6'b100101;
  localparam XOR = 6'b100110;
  localparam SLT = 6'b101010;
  localparam SLTU = 6'b101001;

  always @(*) begin
    case (opcode)
      R_DEFAULT: begin
        RegDst   = 1'b1;
        ALUSrc   = 1'b0;
        MemtoReg = 1'b0;
        RegWrite = 1'b1;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        ALUOp    = ALU_control;
      end
      LW: begin
        RegDst   = 1'b0;
        ALUSrc   = 1'b1;
        MemtoReg = 1'b1;
        RegWrite = 1'b1;
        MemRead  = 1'b1;
        MemWrite = 1'b0;
        ALUOp    = ADD;
      end
      SW: begin
        RegDst   = 1'bx;
        ALUSrc   = 1'b1;
        MemtoReg = 1'bx;
        RegWrite = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b1;
        ALUOp    = ADD;
      end
      // Immediate Function
      default: begin
        RegDst   = 1'b0;
        ALUSrc   = 1'b1;
        MemtoReg = 1'b0;
        RegWrite = 1'b1;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        case (opcode)
          ADDI: ALUOp = ADD;
          ANDI: ALUOp = AND;
          ORI: ALUOp = OR;
          XORI: ALUOp = XOR;
          SLTI: ALUOp = SLT;
          SLTIU: ALUOp = SLTU;
          default: ALUOp = R_DEFAULT;
        endcase
      end
    endcase

    // Output the Current Instruction to the Seven Segment Display
    case (ALUOp)
      ADD: begin
        seg1 = 7'b0001000;  // A
        seg2 = 7'b1000010;  // d
        seg3 = 7'b1000010;  // d
        seg4 = 7'b1111110;  // Nothing
        seg5 = 7'b1111110;  // Nothing
      end
      SUB: begin
        seg1 = 7'b0100100;  // 5
        seg2 = 7'b1100000;  // b
        seg3 = 7'b1111110;  // Nothing
        seg4 = 7'b1111110;  // Nothing
        seg5 = 7'b1111110;  // Nothing
      end
      AND: begin
        seg1 = 7'b0001000;  // A
        seg2 = 7'b0101011;  // n
        seg3 = 7'b1000010;  // d
        seg4 = 7'b1111110;  // Nothing
        seg5 = 7'b1111110;  // Nothing
      end
      OR: begin
        seg1 = 7'b1111110;  // Nothing
        seg2 = 7'b1000000;  // O
        seg3 = 7'b1010000;  // r
        seg4 = 7'b1111110;  // Nothing
        seg5 = 7'b1111110;  // Nothing
      end
      XOR: begin
        seg1 = 7'b0001001;  // H
        seg2 = 7'b1000000;  // O
        seg3 = 7'b1010000;  // r
        seg4 = 7'b1111110;  // Nothing
        seg5 = 7'b1111110;  // Nothing
      end
      SLT: begin
        seg1 = 7'b0100100;  // 5
        seg2 = 7'b0001000;  // L
        seg3 = 7'b0000111;  // t
        seg4 = 7'b1111110;  // Nothing
        seg5 = 7'b1111110;  // Nothing
      end
      SLTU: begin
        seg1 = 7'b0100100;  // 5
        seg2 = 7'b0001000;  // L
        seg3 = 7'b0000111;  // t
        seg4 = 7'b1100000;  // U
        seg5 = 7'b1111110;  // Nothing
      end
      default: begin
        seg1 = 7'b1111111;  // Blank
        seg2 = 7'b1111111;  // Blank
        seg3 = 7'b1111111;  // Blank
        seg4 = 7'b1111111;  // Blank
        seg5 = 7'b1111111;  // Blank
      end
    endcase
  end
endmodule
