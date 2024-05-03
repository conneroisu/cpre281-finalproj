`timescale 1ns / 1ps
module ALU_control (
    input [1:0] ALUOp,
    input [5:0] instruction,
    output reg [3:0] ALUcontrol
);
  always @(ALUOp, instruction) begin
    case (ALUOp)
      2'b00:   ALUcontrol = 4'b0010;  // LW / SW | add
      2'b01:   ALUcontrol = 4'b0110;  // Branch equal | subtract
      2'b10: begin  // R-Type
        case (instruction)
          6'b100000:  // add
          ALUcontrol = 4'b0010;
          6'b100010:  // sub
          ALUcontrol = 4'b0110;
          6'b100100:  // and
          ALUcontrol = 4'b0000;
          6'b100101:  // or
          ALUcontrol = 4'b0001;
          6'b101010:  // slt
          ALUcontrol = 4'b0111;
          default: ;
        endcase
      end
      2'b11:   ALUcontrol = 4'b0000;
      default: ;
    endcase
  end
endmodule
