`timescale 1ns / 1ps

module Instruction_memory (
    input i_Rst,  // Reset signal added
    // input clk,  // Uncomment if clock is needed for synchronous reset
    input [31:0] i_Addr,
    output reg [5:0] i_Ctr,       // [31-26]
    output reg [5:0] i_Funcode,   // [5-0]
    output reg [31:0] i_Instruction  // [31-0]
);

    parameter SIZE_IM = 128;  // Size of this memory, by default 128*32
    reg [31:0] Imem[SIZE_IM-1:0];  // Instruction memory
    integer n;

    // Initial block to set default values
    initial begin
        for (n = 0; n < SIZE_IM; n = n + 1) begin
            Imem[n] = 32'b11111100000000000000000000000000;
        end
        $readmemb("instructions.mem", Imem);
        i_Instruction = 32'b11111100000000000000000000000000;
    end

    // Always block to handle instruction fetching and resetting
    always @(i_Rst or i_Addr) begin
        if (i_Rst) begin
            // Reload initial memory contents when reset is active
            $readmemb("instructions.mem", Imem);
            i_Instruction = 32'b11111100000000000000000000000000;
        end else if (i_Addr == -4) begin  // Special case initialization
            i_Instruction = 32'b11111100000000000000000000000000;
        end else begin
            // Fetch the instruction based on address
            i_Instruction = Imem[i_Addr>>2];
        end
        // Update control and function code outputs
        i_Ctr = i_Instruction[31:26];
        i_Funcode = i_Instruction[5:0];
    end

endmodule
