`timescale 1ns / 1ps
module ALU (
    input      [31:0] data1,        // data 1
    input      [31:0] read2,        // data 2 from MUX
    input      [31:0] instruction,  // used for sign-extension
    input             ALUSrc,
    input      [ 3:0] ALUcontrol,
    output reg        zero,
    output reg [31:0] ALUresult
);
  reg [31:0] data2;
  always @(ALUSrc, read2, instruction) begin
    if (ALUSrc == 0) begin
      data2 = read2;
    end else begin
      // SignExt[instruction[15:0]]
      if (instruction[15] == 1'b0) begin
        data2 = {16'b0, instruction[15:0]};
      end else begin
        data2 = {{16{1'b1}}, instruction[15:0]};
      end
    end
  end
  always @(data1, data2, ALUcontrol) begin
    case (ALUcontrol)
      4'b0000:  // AND
      ALUresult = data1 & data2;
      4'b0001:  // OR
      ALUresult = data1 | data2;
      4'b0010:  // ADD
      ALUresult = data1 + data2;
      4'b0110:  // SUB
      ALUresult = data1 - data2;
      4'b0111:  // SLT
      ALUresult = (data1 < data2) ? 1 : 0;
      4'b1100:  // NOR
      ALUresult = data1 | ~data2;
      default: ;
    endcase
    if (ALUresult == 0) begin
      zero = 1;
    end else begin
      zero = 0;
    end
  end
endmodule
