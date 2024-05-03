`timescale 1ns / 1ps
module ALU_control (
    input [1:0] i_ALUOp,
    input [5:0] i_Instruction,
    output reg [3:0] o_ALUcontrol
);
  always @(i_ALUOp, i_Instruction) begin
    case (i_ALUOp)
      2'b00:   o_ALUcontrol = 4'b0010;  // LW / SW | add
      2'b01:   o_ALUcontrol = 4'b0110;  // Branch equal | subtract
      2'b10: begin  // R-Type
        case (i_Instruction)
          6'b100000: begin  // add
            o_ALUcontrol = 4'b0010;
            // set 1: A 2: D 3: D 4: blank 5: blank
          end
          6'b100010: begin  // sub
            o_ALUcontrol = 4'b0110;
            // set 1: S 2: U 3: B 4: blank 5: blank
          end
          6'b100100: begin  // and
            o_ALUcontrol = 4'b0000;
            // set 1: A 2: N 3: D 4: blank 5: blank
          end
          6'b100101: begin  // or
            o_ALUcontrol = 4'b0001;
            // set 1: O 2: R 3: blank 4: blank 5: blank
          end
          6'b101010: begin  // slt
            o_ALUcontrol = 4'b0111;
            // set 1: S 2: L 3: T 4: blank 5: blank
          end
          default: begin
            // set 1: blank 2: blank 3: blank 4: blank 5: blank
          end
        endcase
      end
      2'b11:   o_ALUcontrol = 4'b0000;
      default: ;
    endcase
  end
endmodule
