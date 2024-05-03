`timescale 1ns / 1ps
module ALU_control (
    input [1:0] ALUOp,
    input [5:0] instruction,
    output reg [3:0] ALUcontrol,
    output reg [6:0] seg_first,
    output reg [6:0] seg_second,
    output reg [6:0] seg_third,
    output reg [6:0] seg_fourth,
    output reg [6:0] seg_fifth
);
  always @(ALUOp, instruction) begin
    case (ALUOp)
      2'b00:   ALUcontrol = 4'b0010;  // LW / SW | add
      2'b01:   ALUcontrol = 4'b0110;  // Branch equal | subtract
      2'b10: begin  // R-Type
        case (instruction)
          6'b100000: begin  // add
            ALUcontrol = 4'b0010;
            // set 1: A 2: D 3: D 4: blank 5: blank
            seg_first  = 7'b0110000;  // A
            seg_second = 7'b1011110;  // D
            seg_third  = 7'b1011110;  // D
            seg_fourth = 7'b1111111;  // blank
            seg_fifth  = 7'b1111111;  // blank
          end
          6'b100010: begin  // sub
            ALUcontrol = 4'b0110;
            // set 1: S 2: U 3: B 4: blank 5: blank
            seg_first  = 7'b1101101;  // S
            seg_second = 7'b0111110;  // U
            seg_third  = 7'b1101101;  // B
            seg_fourth = 7'b1111111;  // blank
          end
          6'b100100: begin  // and
            ALUcontrol = 4'b0000;
            // set 1: A 2: N 3: D 4: blank 5: blank
            seg_first  = 7'b0110000;  // A
            seg_second = 7'b0111110;  // N
            seg_third  = 7'b1011110;  // D
            seg_fourth = 7'b1111111;  // blank
          end
          6'b100101: begin  // or
            ALUcontrol = 4'b0001;
            // set 1: O 2: R 3: blank 4: blank 5: blank
            seg_first  = 7'b0111101;  // O
            seg_second = 7'b0111110;  // R
            seg_third  = 7'b1111111;  // blank
            seg_fourth = 7'b1111111;  // blank
          end
          6'b101010: begin  // slt
            ALUcontrol = 4'b0111;
            // set 1: S 2: L 3: T 4: blank 5: blank
            seg_first  = 7'b1101101;  // S
            seg_second = 7'b1101101;  // L
            seg_third  = 7'b1101111;  // T
            seg_fourth = 7'b1111111;  // blank
          end
          default: ;
        endcase
      end
      2'b11:   ALUcontrol = 4'b0000;
      default: ;
    endcase
  end
endmodule
