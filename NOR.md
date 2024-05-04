#### Instruction Breakdown

The NOR instruction in the MIPS architecture performs a bitwise NOR operation on the values of two registers and stores the result in a destination register. Let's break down the NOR instruction using the code snippets provided:

1. **Instruction Fetch (IF) Stage:**
   - The instruction is fetched from the instruction memory using the program counter (PC).
   - The instruction memory module (`InstructionMemory.v`) retrieves the instruction based on the address provided by the PC.
   
   ```verilog
   // Inside the InstructionMemory module
   always @(i_Addr) begin
     if (i_Addr == -4) begin         // init
       i_Instruction = 32'b11111100000000000000000000000000;
     end else begin
       i_Instruction = Imem[i_Addr>>2];
     end
     i_Ctr = i_Instruction[31:26];
     i_Funcode = i_Instruction[5:0];
   end
   ```

2. **Instruction Decode (ID) Stage:**
   - The fetched instruction is decoded by the control unit (`ControlUnit.v`).
   - The opcode of the instruction (bits [31:26]) is used to determine the type of instruction.
   - For the NOR instruction, the opcode is 6'b100111 (binary representation of 39).
   
   ```verilog
   // Inside the ControlUnit module
   always @(i_instruction) begin
     case (i_instruction[31:26])
       // ...
       6'b100111: begin  // NOR
         o_RegDst = 1;
         o_ALUSrc = 0;
         o_MemtoReg = 0;
         o_RegWrite = 1;
         o_MemRead = 0;
         o_MemWrite = 0;
         o_Branch = 0;
         o_ALUOp = 2'b11;
         o_Jump = 0;
         // ...
       end
       // ...
     endcase
   end
   ```

3. **Execute (EX) Stage:**
   - The ALU performs the bitwise NOR operation on the values of the source registers (rs and rt).
   - The ALU control unit generates the appropriate control signal (4'b1100) for the NOR operation based on the ALUOp bits from the control unit.
   
   ```verilog
   // Inside the ALU module
   always @(i_data1, data2, i_ALUcontrol) begin
     case (i_ALUcontrol)
       // ...
       4'b1100:  // NOR
         o_ALUresult = i_data1 | ~data2;
       // ...
     endcase
     // ...
   end
   ```

4. **Memory (MEM) Stage:**
   - For the NOR instruction, no memory access is required, so this stage is a pass-through.

5. **Write Back (WB) Stage:**
   - The result of the NOR operation from the ALU is written back to the destination register (rd) in the register file.
   
   ```verilog
   // Inside the RegisterFile module
   always @(posedge i_clk) begin
     if (i_wEn == 1) begin
       RegData[i_wDst] <= i_wData;
     end
   end
   ```

Here's an example of how the NOR instruction would be encoded in MIPS assembly and its corresponding machine code:

```assembly
# MIPS Assembly
nor $t0, $s1, $s2   # Perform bitwise NOR of $s1 and $s2 and store the result in $t0
```

```
# Machine Code (in binary)
000000 10001 10010 01000 00000 100111
```

In the machine code, the bits are organized as follows:
- Bits [31:26]: Opcode (000000 for R-type instructions)
- Bits [25:21]: Source register 1 (rs)
- Bits [20:16]: Source register 2 (rt)
- Bits [15:11]: Destination register (rd)