`timescale 1ns / 1ps
module Instruction_memory (
    input i_Rst,  // Reset signal
    input [31:0] i_Addr,
    output reg [5:0] i_Ctr,       // [31-26]
    output reg [5:0] i_Funcode,   // [5-0]
    output reg [31:0] i_Instruction  // [31-0]
);
    parameter SIZE_IM = 128;  // Size of this memory, by default 128*32
    reg [31:0] Imem[SIZE_IM-1:0];  // Instruction memory
    reg [31:0] Imem_backup[SIZE_IM-1:0];  // Backup of initial instruction memory
    integer n;
    // Initial block to set default values and backup
    initial begin
        for (n = 0; n < SIZE_IM; n = n + 1) begin
            Imem[n] = 32'b11111100000000000000000000000000;
            Imem_backup[n] = 32'b11111100000000000000000000000000; // Initialize backup
        end
        $readmemb("instructions.mem", Imem);
        // Copy initial loaded values to backup memory
        for (n = 0; n < SIZE_IM; n = n + 1) begin
            Imem_backup[n] = Imem[n];
        end
        i_Instruction = 32'b11111100000000000000000000000000;
    end
    // Always block to handle instruction fetching and resetting
    always @(posedge i_Rst or posedge i_Addr) begin
        if (i_Rst) begin
            // Restore instruction memory from backup when reset is active
            for (n = 0; n < SIZE_IM; n = n + 1) begin
                Imem[n] = Imem_backup[n];
            end
        end
        // Fetch the instruction based on address regardless of reset
        i_Instruction = Imem[i_Addr>>2];
        // Update control and function code outputs
        i_Ctr = i_Instruction[31:26];
        i_Funcode = i_Instruction[5:0];
    end
endmodule
