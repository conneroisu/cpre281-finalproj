# cpre281-finalproj

This is the final project for CPRE281 taught at Iowa State University By Conner Ohnesorge.

The project is a simple processor that can execute a subset of the MIPS instruction set.

The processor is implemented in VerilogHDL, tested using a test-bench, and tested on an FPGA board.

Name: **Conner Ohnesorge**

Date: **4/10/2024**

## Table of Contents

## Proposal

A MIPS processor that can execute a subset of the MIPS instruction set with additional features such as a clock divider, displaying the current instruction on the seven segment displays present on the FPGA board, and the ability to change the frequency of execution of the processor.

More specifically, the processor will be able to execute the following instructions: LW SW J ADD ADDI BEQ ADDU SUBU AND ANDI OR ORI XOR SUB XORI NOR BNE

The frequency of execution for the processor will be variable and will be controlled by a clock divider that divides the 50MHz clock signal by a value set by the divider that will be used to divide the clock signal.

The current instruction being executed will be displayed on the seven segment displays present on the FPGA board.

The processor will be implemented in Verilog and tested using a test-bench.

## Introduction

The project is a simple MIPS processor that can at a variable speed execute a subset of the MIPS instruction set displaying the current instruction on the seven segment displays present on EP4CE115F29C7 FPGA board.

As a result of this desired function (and it's actualation into reality), the processor can technically be used to do all the other projects from other students in the class.

![[Pasted image 20240415105047.png]]

As I took this class whilst also taking CPRE381, I additionally decided to compare and contrast the experience writing the same processor in both Verilog and VHDL.

A basic single-cycle MIPS processor:

![[Pasted image 20240415102706.png]]

The main processor state machine has five states:

**Fetch**: In this state, the processor fetches the next instruction from memory.
**Decode**: In this state, the processor decodes the instruction to determine what operation to perform.
**Execute**: In this state, the processor executes the instruction.
**Memory**: In this state, the processor accesses memory to read or write data.
**Write-back**: In this state, the processor writes the results of the instruction to a register.

4 bit adder

![[Pasted image 20240423092137.png]]

Supported Instructions: LW SW J ADD ADDI BEQ ADDU SUBU AND ANDI OR ORI XOR SUB XORI NOR BNE

## State sequences for each instruction

 ADD (R-type instruction)

- **IF:** The instruction is fetched from memory using the program counter (PC).
- **ID:** The instruction bits are decoded to determine it is an ADD operation. Registers specified by the source register fields (`rs` and `rt`) are read.
- **EX:** The ALU performs the addition of the two register values.
- **MEM:** No action (not used by ADD).
- **WB:** The result from the ALU is written back to the destination register (`rd`).

 ADDI (I-type instruction)

- **IF:** Fetch the instruction from memory.
- **ID:** Decode the instruction; read the source register (`rs`).
- **EX:** ALU adds the value in the source register to the immediate value (which is sign-extended).
- **MEM:** No action.
- **WB:** The result is written back to the target register (`rt`).

 LW (Load Word)

- **IF:** Fetch the instruction.
- **ID:** Decode the instruction; read the base address register (`rs`).
- **EX:** Calculate the memory address by adding the immediate value (offset) to the base register.
- **MEM:** Access the memory at the computed address and read the word.
- **WB:** Write the loaded word into the target register (`rt`).

 SW (Store Word)

- **IF:** Fetch the instruction.
- **ID:** Decode the instruction; read the base address register (`rs`) and the register to be stored (`rt`).
- **EX:** Calculate the memory address by adding the immediate value (offset) to the base register.
- **MEM:** Write the value from `rt` into the calculated memory address.
- **WB:** No write-back step for store instructions.

 BEQ (Branch if Equal)

- **IF:** Fetch the instruction.
- **ID:** Decode the instruction; read the two registers (`rs` and `rt`) and compare them.
- **EX:** Calculate the branch target address if the comparison is equal (by adding the sign-extended, shifted immediate to the PC).
- **MEM:** No memory access.
- **WB:** No write-back; update the PC to the branch address if the condition is met, otherwise increment the PC as usual.

 J (Jump)

- **IF:** Fetch the instruction.
- **ID:** Decode the instruction.
- **EX:** Calculate the jump target address from the address field of the instruction.
- **MEM:** No memory access.
- **WB:** Update the PC to the jump address.

 ADDU (Add Unsigned)

- **IF (Instruction Fetch):** The instruction is fetched from memory using the program counter (PC).
- **ID (Instruction Decode):** The opcode is decoded; registers rs and rt are read.
- **EX (Execute):** The arithmetic logic unit (ALU) adds the values from registers rs and rt.
- **MEM (Memory Access):** No action needed (pass-through).
- **WB (Write Back):** The result from the ALU is written back to the destination register rd.

 SUB, SUBU (Subtract, Subtract Unsigned)

- **IF:** Fetch the instruction using the PC.
- **ID:** Decode the instruction; read registers rs and rt.
- **EX:** The ALU subtracts the value in rt from rs.
- **MEM:** No action needed (pass-through).
- **WB:** The ALU result is written back to register rd.

 AND, ANDI (AND, AND Immediate)

- **IF:** Instruction is fetched.
- **ID:** Instruction is decoded. For AND, rs and rt are read; for ANDI, rs is read, and the immediate value is zero-extended.
- **EX:** The ALU performs an AND operation between operands.
- **MEM:** No action needed.
- **WB:** Result is written back to rd (AND) or rt (ANDI).

 OR, ORI (OR, OR Immediate)

- **IF:** Instruction is fetched.
- **ID:** Opcode is decoded. Registers rs and rt are read for OR; rs and immediate for ORI.
- **EX:** ALU performs an OR operation.
- **MEM:** No action needed.
- **WB:** Result is written to rd (OR) or rt (ORI).

 XOR, XORI (XOR, XOR Immediate)

- **IF:** Fetch the instruction.
- **ID:** Decode the opcode. Registers rs and rt read for XOR; rs and immediate for XORI.
- **EX:** ALU performs XOR operation.
- **MEM:** No action needed.
- **WB:** Write result to rd (XOR) or rt (XORI).

 NOR

- **IF:** Fetch instruction.
- **ID:** Decode opcode; read rs and rt.
- **EX:** ALU performs NOR operation on rs and rt.
- **MEM:** No action needed.
- **WB:** Result is written back to rd.

 BNE (Branch Not Equal)

- **IF:** Fetch instruction.
- **ID:** Decode instruction; read registers rs and rt.
- **EX:** Compare values of rs and rt.
- **MEM:** No action needed.
- **WB:** If rs != rt, PC is updated to branch address (PC + offset); otherwise, move to next sequential instruction.

Each instruction follows a path from fetching the opcode to potentially altering the program counter or writing back results to registers. The single-cycle processor architecture aims to complete these steps within one clock cycle for each instruction, making the process efficient but requiring a capable and fast hardware setup to manage all stages effectively in such a short time span.

### Conclusion

Each instruction type (R-type, I-type, J-type) generally follows a similar flow with variations primarily in the Execute and Memory Access stages depending on whether the instruction involves arithmetic, memory access, or control flow.

This model provides a consistent framework for understanding how different instructions are processed in the single-cycle MIPS architecture.

# Comparing Verilog vs VHDL 

I think that VHDL actually provides more flexibility within the development of the processor.

The language is more verbose, more type-safe, and allows for more control over the design of the processor.

Verilog is more concise and easier to read, but I think that VHDL is more powerful and allows for more control over the design of the processor.

Furthermore, I think that the fact that the name of a file in verilog must match the module name is a limitation that VHDL does not have (atleast in our Quartus simulator).

Additionally, I think that VHDL is more suited for larger projects and more complex designs, while Verilog is more suited for smaller projects and simpler designs.

## Interesting notes about verilog

The loose typing of Verilog can lead to some useful modules that can be defined in small amounts of code.

Additionally, in verilog, you do not have to declare your components in the component that uses them which also decreases the amount of code that is needed to be written.

For example, the following module is the mux module that is used in the processor to select between two inputs based on a control signal.

```verilog
module mux #(parameter size = 1) (
  input select,
  input [size - 1:0] in_0,
  input [size - 1:0] in_1,
  output [size - 1:0] out
);
  assign out = (select) ? in_1 : in_0;
endmodule
```

Another example of this is the sign extender module that is used to extend the sign of a 16-bit number to a 32-bit number.

```verilog
module signextender (
  input [15:0] in,
  output [31:0] out
);
  assign out = {{16{in[15]}}, {in}};
endmodule
```

Additionally, the fact that in Verilog you do not need to preemptively define components before using them allows for a more flexible design and faster development.

Another nice feature of Verilog (specifically VerilogHDL) is the ability to print out the values of signals in the waveform viewer inside modelsim/questasim.

This is a feature that is not present in VHDL and is very useful for debugging and understanding the behavior of the processor.

While you can do this in VHDL, it is not as easy as it is in Verilog because in VHDL you must deal with the typings of the signals and the fact that you must declare the signals before you can use them.

As an example, the following is the code in VHDL that prints out the values of the signals in the waveform viewer for an n-bit register which was used in a project for CPRE381.

The following test-bench shows the code that can be executed inside modelsim/questasim to print out the values of the signals in the waveform viewer.

It displays the additional hurdles that must be overcome in VHDL to print out the values of the signals in the waveform viewer because of the strict typing of the language.

```vhdl
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY tb_nbitregister IS
  GENERIC (
    gCLK_HPER : TIME := 50 ns;
    N : INTEGER := 32);
END tb_nbitregister;
ARCHITECTURE behavior OF tb_nbitregister IS

  -- Calculate the clock period as twice the half-period
  CONSTANT cCLK_PER : TIME := gCLK_HPER * 2;
  COMPONENT nbitregister
    PORT (
      i_CLK : IN STD_LOGIC; -- Clock input
      i_RST : IN STD_LOGIC; -- Reset input
      i_WE : IN STD_LOGIC; -- Write enable input
      i_D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0); -- Data value input
      o_Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0) -- Data value output
    );
  END COMPONENT;
  -- Temporary Signals to connect to the nbitregister component.
  SIGNAL s_CLK, s_RST, s_WE : STD_LOGIC;
  SIGNAL s_D, s_Q : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
BEGIN
  DUT : nbitregister
  PORT MAP(
    i_CLK => s_CLK,
    i_RST => s_RST,
    i_WE => s_WE,
    i_D => s_D,
    o_Q => s_Q
  );
  P_CLK : PROCESS
  BEGIN
    s_CLK <= '0';
    WAIT FOR gCLK_HPER;
    s_CLK <= '1';
    WAIT FOR gCLK_HPER;
  END PROCESS;
  P_TB : PROCESS
  BEGIN
    s_RST <= '1';
    s_WE <= '0';
    s_D <= "00000000000000000000000000000000";
    WAIT FOR cCLK_PER;
    -- TEST CASE 1 - STORE '1'
    -- DESCRIPTION: The register should store the new data value
    -- EXPECTED RESULT: The new data value should be stored in the register
    s_RST <= '0';
    s_WE <= '1';
    s_D <= "11111111111111111111111111111111";
    WAIT FOR cCLK_PER;
    IF (s_Q /= "11111111111111111111111111111111") THEN
      REPORT "Test 1 failed";
      REPORT "Expected: 11111111111111111111111111111111";
      REPORT "Actual:  " & STD_LOGIC_VECTOR'image(s_Q);
    ELSE
      REPORT "TEST 1 PASSED - STORE '1'";
    END IF;
...
```
    
## Breaking down decoding a signal to 7-segment displays

As the signal representing the instruction is 5 bits long inside the `controller.v` file, we need to decode this signal to display the current instruction on the 7-segment displays.

This means that we need to decode a 5-bit signal to a 35-bit signal that will be used to display the current instruction on the 7-segment displays.

5 bits = signal
7 bits needed per 7-segment display
the longest word = 5 characters
thus, 5 * 7 = 35 bits needed for 5 7-segment displays
We are decoding a 5-bit signal to 35 bits.

| Func_in | O_out | Operation | Description |
| :---: | :---: | :---: | :---: |
| 1000 | ox | $(A+B)$ | ADD |
| 1000 | $1 \mathrm{X}$ | $(\mathrm{A}-\mathrm{B})$ | SuB |
| 1001 | 00 | $(A \& B)$ | AND |
| 1001 | 01 | $(A \mid B)$ | OR |
| 1001 | 10 | $\left(A^{\wedge} B\right)$ | XOR |
| 1001 | $\pi$ | $\sim(\mathrm{A} \mid \mathrm{B})$ | NOR |
| 101 | $\mathrm{xx0}$ | signed $(A)<\operatorname{signed}(B)$ | Set-Less-Than signed |
| 101 | $x x 1$ | $A<B$ | Set-Less-Than unsigned |
| 111 | 000 | A | BLTZ (Branch if Less Than Zero) |
| 111 | 001 | A | BGEZ (Branch if Greater or Equal to Zero) |
| 111 | 010 | A | J/AL (Jump and Link) |
| 111 | 011 | A | JR/AL (Jump Register and Link) |
| 111 | 100 | A | $\mathrm{BEQ}($ (Branch if Equal) |
| 111 | 101 | A | BNE (Branch if Not Equal) |
| 111 | 110 | A | BLEZ (Branch if Less or Equal to Zero) |
| 111 | 111 | A | BGTZ (Branch if Greater Than Zero) |

The following is the wave-diagram from modelsim/questasim for my test-bench of my processor without the added seven segment displays.

![[Pasted image 20240503061843.png]]

Below is the captured wave-diagram from modelsim/questasim with the seven segment ports included:

![[Pasted image 20240503065359.png]]

The wave-forms show the output of the following test-bench:

```verilog title=mips_tb.v
`timescale 1ns / 1ps
`define CYCLE_TIME 20
module mips_tb;
  reg clk;
  reg rst;
  // segments for the 7-segment displays
  wire [6:0] seg_first, seg_second, seg_third, seg_fourth, seg_fifth;
  integer i;  // loop variable
  always #(`CYCLE_TIME / 2) clk = ~clk;
  mips uut (
      .i_Clk(clk),
      .i_Rst(rst),
      .o_Seg_first(seg_first),
      .o_Seg_second(seg_second),
      .o_Seg_third(seg_third),
      .o_Seg_fourth(seg_fourth),
      .o_Seg_fifth(seg_fifth)
  );
  initial begin
    // Initialize data memory
    for (i = 0; i < 32; i = i + 1) begin
      uut.inst_DataMemory.Dmem[i] = 32'b0;
    end
    // Initialize Register File
    for (i = 0; i < 32; i = i + 1) begin
      uut.inst_RegisterFile.RegData[i] = 32'b0;
    end
    clk = 0;
  end
  initial begin
    #1800 $finish;
  end
endmodule
```
The given Verilog code represents a test-bench module for the single-cycle MIPS processor.

1. The test-bench module is named `mips_tb`, and it operates on a timescale of 1ns/1ps.

2. The module declares two reg variables:
   - `clk`: Represents the clock signal for the processor.
   - `rst`: Represents the reset signal for the processor.

3. It also declares five wire variables (`seg_first`, `seg_second`, `seg_third`, `seg_fourth`, `seg_fifth`) to represent the segments for the 7-segment displays. These wires are used to display the current instruction being executed by the processor.

4. The `integer` variable `i` is declared as a loop variable for initializing memory.

5. The `always` block generates the clock signal by toggling the `clk` variable every half of the clock cycle time (`CYCLE_TIME/2`).

6. The `mips` module (the actual MIPS processor) is instantiated as `uut` (unit under test) with the following connections:
   - `i_Clk` is connected to the `clk` signal.
   - `i_Rst` is connected to the `rst` signal.
   - The 7-segment display outputs (`o_Seg_first`, `o_Seg_second`, `o_Seg_third`, `o_Seg_fourth`, `o_Seg_fifth`) are connected to the corresponding wires in the test-bench.

7. The first `initial` block is used to initialize the data memory and the register file of the MIPS processor:
   - It uses a `for` loop to iterate over the first 32 locations of the data memory (`Dmem`) and initializes each location to zero.
   - Similarly, it initializes the first 32 registers in the register file (`RegData`) to zero.
   - Finally, it sets the `clk` variable to 0.

8. The second `initial` block is used to specify the duration of the simulation. It uses the `$finish` system task to terminate the simulation after 1800 time units.

The purpose of this test-bench is to provide a simulation environment for the MIPS processor. It initializes the necessary components (data memory and register file), generates the clock signal, and instantiates the MIPS processor module. The testbench also specifies the duration of the simulation.

The test-bench interacts with other components of the processor through the instantiated `mips` module (`uut`). It provides the clock and reset signals to the processor and observes the output signals for the 7-segment displays.

Overall, this test-bench serves as a framework to verify the functionality of the single-cycle MIPS processor by providing the necessary inputs, initializing the memory, and specifying the simulation duration.

## Schematics

Control Unit Schematic: 

![[Pasted image 20240503123506.png]]

Register File:

![[Pasted image 20240503124247.png]]

Data Memory:

![[Pasted image 20240503124336.png]]

ALU Control:

![[Pasted image 20240503124621.png]]

Program Counter Control:

![[Pasted image 20240503124717.png]]

ALU:

![[Pasted image 20240503124838.png]]

Instruction Memory:

![[Pasted image 20240503124956.png]]

Program Counter:

![[Pasted image 20240503125021.png]]

Waveform of the Processor from modelsim/questasim:

![[Pasted image 20240503131222.png]]

## Tooling 

First, as learned in CPRE381, I enjoy having test-benches for my code.

Test-benches allow for faster debugging and more efficient development by allowing you to test your code without having to run it on the FPGA board, directly seeing the signals, how they interact with one another, and allows for testing to make sure that progress is being made.

I used a test-bench to test my processor and ensure that it was working correctly.

The following is the main test-bench that I used to test my processor.

```verilog title="mips_tb.v"
`timescale 1ns / 1ps
`define CYCLE_TIME 20
module mips_tb;
  reg clk;
  reg rst;
  wire [6:0] seg_first, seg_second, seg_third, seg_fourth, seg_fifth;
  integer i;  // loop variable
  always #(`CYCLE_TIME / 2) clk = ~clk;
  mips uut (
      .i_Clk(clk),
      .i_Rst(rst),
      .o_Seg_first(seg_first),
      .o_Seg_second(seg_second),
      .o_Seg_third(seg_third),
      .o_Seg_fourth(seg_fourth),
      .o_Seg_fifth(seg_fifth)
  );
  initial begin
    // Initialize data memory
    for (i = 0; i < 32; i = i + 1) begin
      uut.inst_DataMemory.Dmem[i] = 32'b0;
    end
    // Initialize Register File
    for (i = 0; i < 32; i = i + 1) begin
      uut.inst_RegisterFile.RegData[i] = 32'b0;
    end
    clk = 0;
  end
  initial begin
    #1800 $finish;
  end
endmodule
```

I used do files to more easily compile and run my code.

The following is the main `.do` file that I used to compile and run my code.

```do title="run.do"
set target "mips_tb"
set file "proj/${target}.v"
if { [file exists "work"] } {
	vdel -all
}
vlog *.v
vsim -voptargs=+acc -debugDB $target
force -freeze sim:/$target/clk 1 0, 0 {5 ps} -r 10
# force -freeze sim:/$target/rst 0 0, 1 {80 ps} -r 100
add wave -position insertpoint \ ../$target/*
run 1200
```

## Components 

#### ALU

```verilog title=ALU.v
`timescale 1ns / 1ps
module ALU (
    input      [31:0] i_data1,        // data 1
    input      [31:0] i_read2,        // data 2 from MUX
    input      [31:0] i_Instruction,  // used for sign-extension
    input             i_ALUSrc,
    input      [ 3:0] i_ALUcontrol,
    output reg        o_Zero,
    output reg [31:0] o_ALUresult
);
  reg [31:0] data2;
  always @(i_ALUSrc, i_read2, i_Instruction) begin
    if (i_ALUSrc == 0) begin
      data2 = i_read2;
    end else begin
      if (i_Instruction[15] == 1'b0) begin
        data2 = {16'b0, i_Instruction[15:0]};
      end else begin
        data2 = {{16{1'b1}}, i_Instruction[15:0]};
      end
    end
  end
  always @(i_data1, data2, i_ALUcontrol) begin
    case (i_ALUcontrol)
      4'b0000:  // AND
      o_ALUresult = i_data1 & data2;
      4'b0001:  // OR
      o_ALUresult = i_data1 | data2;
      4'b0010:  // ADD
      o_ALUresult = i_data1 + data2;
      4'b0110:  // SUB
      o_ALUresult = i_data1 - data2;
      4'b0111:  // SLT
      o_ALUresult = (i_data1 < data2) ? 1 : 0;
      4'b1100:  // NOR
      o_ALUresult = i_data1 | ~data2;
      default: ;
    endcase
    if (o_ALUresult == 0) begin
      o_Zero = 1;
    end else begin
      o_Zero = 0;
    end
  end
endmodule
```
The above code represents the ALU (Arithmetic Logic Unit) module of the single-cycle MIPS processor.

The ALU is responsible for performing arithmetic and logical operations on the input data based on the ALU control signal.

Inputs:
- `i_data1` (32-bit): The first input data for the ALU operation.
- `i_read2` (32-bit): The second input data from the MUX.
- `i_Instruction` (32-bit): The instruction used for sign-extension.
- `i_ALUSrc` (1-bit): A control signal indicating whether to use the second input data from the MUX or the sign-extended immediate value.
- `i_ALUcontrol` (4-bit): The ALU control signal that determines the specific operation to be performed.

Outputs:
- `o_Zero` (1-bit): A flag indicating whether the ALU result is zero.
- `o_ALUresult` (32-bit): The result of the ALU operation.

Functionality:
1. Data Selection:
   - The module first determines the second input data for the ALU operation based on the `i_ALUSrc` control signal.
   - If `i_ALUSrc` is 0, the second input data is taken directly from `i_read2`.
   - If `i_ALUSrc` is 1, the second input data is obtained by sign-extending the 16-bit immediate value from the `i_Instruction`.

2. ALU Operation:
   - Based on the `i_ALUcontrol` signal, the module performs the corresponding ALU operation on `i_data1` and the selected second input data (`data2`).
   - The supported ALU operations include AND, OR, ADD, SUB (subtract), SLT (set-on-less-than), and NOR.
   - The result of the ALU operation is stored in `o_ALUresult`.

3. Zero Flag:
   - After performing the ALU operation, the module checks if the result is zero.
   - If the result is zero, the `o_Zero` flag is set to 1; otherwise, it is set to 0.

Significance in the MIPS Processor:
- The ALU is a crucial component in the MIPS processor's data-path.
- It performs arithmetic and logical operations on the input data based on the instructions being executed.
- The ALU receives input data from the register file or the immediate value in the instruction, depending on the `i_ALUSrc` control signal.
- The ALU control signal (`i_ALUcontrol`) determines the specific operation to be performed, which is decoded by the ALU control module based on the instruction opcode and function code.
- The result of the ALU operation is used for various purposes, such as storing it back to the register file, using it as a memory address, or making branching decisions based on the zero flag.

Interaction with Other Components:
- The ALU receives input data from the register file (`i_data1` and `i_read2`) and the instruction (`i_Instruction`).
- The ALU control module generates the `i_ALUcontrol` signal based on the instruction opcode and function code, which determines the ALU operation to be performed.
- The ALU result (`o_ALUresult`) is used by other components, such as the data memory for memory operations or the register file for storing the result.
- The zero flag (`o_Zero`) is used by the control unit to make branching decisions based on the comparison result.

Overall, the ALU module performs the necessary arithmetic and logical operations in the MIPS processor based on the instruction being executed. It plays a crucial role in the data-path of the processor, interacting with other components to execute instructions and produce the desired results.

#### Control Unit

The following is the code for the control unit of the MIPS processor.

As named, the `ControlUnit` is responsible for decoding the instruction and generating the control signals for the various components of the processor.

```verilog title=ControlUnit.v
`timescale 1ns / 1ps
module ControlUnit (
    input [31:0] i_instruction,
    output reg o_RegDst,
    output reg o_Jump,
    output reg o_Branch,
    output reg o_Bne,
    output reg o_MemRead,
    output reg o_MemtoReg,
    output reg [1:0] o_ALUOp,
    output reg o_MemWrite,
    output reg o_ALUSrc,
    output reg o_RegWrite,
    output reg [6:0] o_seg_first,
    output reg [6:0] o_seg_second,
    output reg [6:0] o_seg_third,
    output reg [6:0] o_seg_fourth,
    output reg [6:0] o_seg_fifth
);
  initial begin
    o_RegDst = 0;
    o_Jump = 0;
    o_Branch = 0;
    o_MemRead = 0;
    o_MemtoReg = 0;
    o_ALUOp = 2'b00;
    o_MemWrite = 0;
    o_ALUSrc = 0;
    o_RegWrite = 0;
    o_seg_first = 7'b1111111;  // Blank
    o_seg_second = 7'b1111111;  // Blank
    o_seg_third = 7'b1111111;  // Blank
    o_seg_fourth = 7'b1111111;  // Blank
    o_seg_fifth = 7'b1111111;  // Blank
  end
  always @(i_instruction) begin
    case (i_instruction[31:26])
      6'b000000: begin  // ARITHMETIC
        o_RegDst = 1;
        o_ALUSrc = 0;
        o_MemtoReg = 0;
        o_RegWrite = 1;
        o_MemRead = 0;
        o_MemWrite = 0;
        o_Branch = 0;
        o_Bne = 0;
        o_ALUOp = 2'b10;
        o_Jump = 0;
        o_seg_first =  7'b0001000;  // A
        o_seg_second = 7'b1111010;  // R
        o_seg_third =  7'b1111001;  // I
        o_seg_fourth = 7'b0001111;  // T
        o_seg_fifth =  7'b0001001;  // H
      end
      6'b001000: begin  // addi
        o_RegDst = 0;
        o_ALUSrc = 1;
        o_MemtoReg = 0;
        o_RegWrite = 1;
        o_MemRead = 0;
        o_MemWrite = 0;
        o_Branch = 0;
        o_Bne = 0;
        o_ALUOp = 2'b00;
        o_Jump = 0;
        o_seg_first = 7'b0001000;  // A
        o_seg_second = 7'b1000010;  // d
        o_seg_third = 7'b1000010;  // d
        o_seg_fourth = 7'b1001111;  // i
        o_seg_fifth = 7'b1111111;  // Blank
      end
      6'b001100: begin  // andi
        o_RegDst = 0;
        o_ALUSrc = 1;
        o_MemtoReg = 0;
        o_RegWrite = 1;
        o_MemRead = 0;
        o_MemWrite = 0;
        o_Branch = 0;
        o_Bne = 0;
        o_ALUOp = 2'b11;
        o_Jump = 0;
        o_seg_first = 7'b0001000;  // A
        o_seg_second = 7'b0101011;  // n
        o_seg_third = 7'b1000010;  // d
        o_seg_fourth = 7'b1001111;  // i
        o_seg_fifth = 7'b1111111;  // Blank
      end
      6'b100011: begin  // lw
        o_RegDst = 0;
        o_ALUSrc = 1;
        o_MemtoReg = 1;
        o_RegWrite = 1;
        o_MemRead = 1;
        o_MemWrite = 0;
        o_Branch = 0;
        o_Bne = 0;
        o_ALUOp = 2'b00;
        o_Jump = 0;
        o_seg_first = 7'b1000111;  // L
        o_seg_second = 7'b1001001;  // w
        o_seg_third = 7'b1111111;  // Blank
        o_seg_fourth = 7'b1111111;  // Blank
        o_seg_fifth = 7'b1111111;  // Blank
      end
      6'b101011: begin  // sw
        o_RegDst = 0;  // X
        o_ALUSrc = 1;
        o_MemtoReg = 0;  // X
        o_RegWrite = 0;
        o_MemRead = 0;
        o_MemWrite = 1;
        o_Branch = 0;
        o_Bne = 0;
        o_ALUOp = 2'b00;
        o_Jump = 0;
        o_seg_first = 7'b0010010;  // S
        o_seg_second = 7'b1001001;  // w
        o_seg_third = 7'b1111111;  // Blank
        o_seg_fourth = 7'b1111111;  // Blank
        o_seg_fifth = 7'b1111111;  // Blank
      end
      6'b000100: begin  // beq
        o_RegDst = 0;  // X
        o_ALUSrc = 0;
        o_MemtoReg = 0;  // X
        o_RegWrite = 0;
        o_MemRead = 0;
        o_MemWrite = 0;
        o_Branch = 1;
        o_Bne = 0;
        o_ALUOp = 2'b01;
        o_Jump = 0;
        o_seg_first = 7'b1100000;  // b
        o_seg_second = 7'b0110000;  // e
        o_seg_third = 7'b0001100;  // q
        o_seg_fourth = 7'b1111111;  // Blank
        o_seg_fifth = 7'b1111111;  // Blank
      end
      6'b000101: begin  // bne
        o_RegDst = 0;  // X
        o_ALUSrc = 0;
        o_MemtoReg = 0;  // X
        o_RegWrite = 0;
        o_MemRead = 0;
        o_MemWrite = 0;
        o_Branch = 1;
        o_Bne = 1;
        o_ALUOp = 2'b01;
        o_Jump = 0;
        o_seg_first = 7'b1100000;  // b
        o_seg_second = 7'b0101011;  // n
        o_seg_third = 7'b0110000;  // e
        o_seg_fourth = 7'b1111111;  // Blank
        o_seg_fifth = 7'b1111111;  // Blank
      end
      6'b000010: begin  // j
        o_RegDst = 0;  // X
        o_ALUSrc = 0;
        o_MemtoReg = 0;  // X
        o_RegWrite = 0;
        o_MemRead = 0;
        o_MemWrite = 0;
        o_Branch = 0;
        o_Bne = 0;
        o_ALUOp = 2'b01;
        o_Jump = 1;
        o_seg_first = 7'b1100001;  // J
        o_seg_second = 7'b1111111;  // Blank
        o_seg_third = 7'b1111111;  // Blank
        o_seg_fourth = 7'b1111111;  // Blank
        o_seg_fifth = 7'b1111111;  // Blank
      end
      default: begin
        o_RegDst = 0;  // X
        o_ALUSrc = 0;
        o_MemtoReg = 0;  // X
        o_RegWrite = 0;
        o_MemRead = 0;
        o_MemWrite = 0;
        o_Branch = 0;
        o_Bne = 0;
        o_ALUOp = 2'b00;
        o_Jump = 0;
        o_seg_first = 7'b1111111;  // Blank
        o_seg_second = 7'b1111111;  // Blank
        o_seg_third = 7'b1111111;  // Blank
        o_seg_fourth = 7'b1111111;  // Blank
        o_seg_fifth = 7'b1111111;  // Blank
      end
    endcase
  end
endmodule
```

The above Verilog code represents the Control Unit component of the single-cycle MIPS processor.

The Control Unit is responsible for generating control signals based on the input instruction, which determine the behavior of various components within the processor. Let's analyze the code in detail:

Inputs:
- `i_instruction`: The 32-bit instruction fetched from the Instruction Memory.

Outputs:
- Various control signals:
  - `o_RegDst`: Selects the destination register for the instruction (0 for rt, 1 for rd).
  - `o_Jump`: Indicates if the instruction is a jump instruction.
  - `o_Branch`: Indicates if the instruction is a branch instruction.
  - `o_Bne`: Indicates if the instruction is a "branch not equal" instruction.
  - `o_MemRead`: Enables reading from the Data Memory.
  - `o_MemtoReg`: Selects the source of data to be written to the register (0 for ALU result, 1 for memory data).
  - `o_ALUOp`: A 2-bit signal that specifies the ALU operation.
  - `o_MemWrite`: Enables writing to the Data Memory.
  - `o_ALUSrc`: Selects the second source for the ALU (0 for register, 1 for immediate).
  - `o_RegWrite`: Enables writing to the Register File.
- 7-segment display outputs:
  - `o_seg_first` to `o_seg_fifth`: Control signals for displaying the instruction type on 7-segment displays.

Functionality:
1. The Control Unit initializes all control signals to default values in the `initial` block.

2. The `always` block is triggered whenever the `i_instruction` changes. It uses a case statement to determine the type of instruction based on the opcode (bits 31 to 26 of the instruction).

3. Depending on the instruction type, the Control Unit sets the appropriate control signals:
   - For R-type instructions (arithmetic), it sets `RegDst` to 1, enables `RegWrite`, sets `ALUOp` to 2'b10, and displays "ARITH" on the 7-segment displays.
   - For I-type instructions (addi, andi, lw, sw), it sets `ALUSrc` to 1, enables `RegWrite` (except for sw), sets `ALUOp` based on the instruction, and displays the instruction type on the 7-segment displays.
   - For branch instructions (beq, bne), it sets `Branch` to 1, sets `ALUOp` to 2'b01, and displays the instruction type on the 7-segment displays.
   - For the jump instruction, it sets `Jump` to 1, sets `ALUOp` to 2'b01, and displays "J" on the 7-segment displays.

4. If the instruction does not match any of the defined cases, the Control Unit sets all control signals to their default values and displays blank on the 7-segment displays.

Significance in the processor:
The Control Unit plays a crucial role in orchestrating the operation of the single-cycle MIPS processor. It interprets the instruction and generates the necessary control signals to control the data-path components, such as the ALU, Register File, and Data Memory. The control signals determine the flow of data and the operations performed in each stage of the processor pipeline.

Interaction with other components:
- The Control Unit receives the instruction from the Instruction Memory.
- It sends control signals to various components, such as the ALU, Register File, and Data Memory, to control their behavior based on the instruction being executed.
- The control signals generated by the Control Unit are used by the data-path components to perform the required operations and route the data accordingly.

#### Data Memory

```verilog title=DataMemory.v
`timescale 1ns / 1ps
module DataMemory (
    input i_clk,
    input [31:0] i_addr,
    input [31:0] i_wData,
    input [31:0] i_ALUresult,
    input i_MemWrite,
    input i_MemRead,
    input i_MemtoReg,
    output reg [31:0] o_rData
);
  parameter SIZE_DM = 128;  // size of this memory, by default 128*32
  reg [31:0] Dmem[SIZE_DM-1:0];  // instruction memory
  integer i;
  initial begin
    for (i = 0; i < SIZE_DM; i = i + 1) begin
      Dmem[i] = 32'b0;
    end
  end
  always @(i_addr or i_MemRead or i_MemtoReg or i_ALUresult) begin
    if (i_MemRead == 1) begin
      if (i_MemtoReg == 1) begin
        o_rData = Dmem[i_addr];
      end else begin
        o_rData = i_ALUresult;
      end
    end else begin
      o_rData = i_ALUresult;
    end
  end
  always @(posedge i_clk) begin  // MemWrite, wData, addr
    if (i_MemWrite == 1) begin
      Dmem[i_addr] = i_wData;
    end
  end
endmodule
```
The provided code snippet is the implementation of the Data Memory module (`DataMemory.v`) in the single-cycle MIPS processor.

The Data Memory module serves as the main memory for storing and retrieving data in the processor. 

##### IO
   - `i_clk`: Input clock signal.
   - `i_addr`: Input address for reading or writing data.
   - `i_wData`: Input write data to be stored in memory.
   - `i_ALUresult`: Input ALU result, which can be used as the address or data depending on the control signals.
   - `i_MemWrite`: Input control signal indicating a memory write operation.
   - `i_MemRead`: Input control signal indicating a memory read operation.
   - `i_MemtoReg`: Input control signal indicating whether to pass the memory read data or ALU result to the output.
   - `o_rData`: Output read data from the memory.

##### Functionality

Memory Initialization:
   - The module defines a parameter `SIZE_DM` representing the size of the data memory (default is 128 words).
   - It declares a register array `Dmem` of size `SIZE_DM` to store the memory contents.
   - In the initial block, all memory locations are initialized to zero using a loop.

Memory Read Operation:
   - The first always block is triggered whenever the input signals `i_addr`, `i_MemRead`, `i_MemtoReg`, or `i_ALUresult` change.
   - If `i_MemRead` is asserted (equals 1), it indicates a memory read operation.
     - If `i_MemtoReg` is also asserted, the data at memory location `i_addr` is assigned to the output `o_rData`.
     - Otherwise, the ALU result `i_ALUresult` is assigned to `o_rData`.
   - If `i_MemRead` is not asserted, the ALU result `i_ALUresult` is directly assigned to `o_rData`.

Memory Write Operation:
   - The second always block is triggered on the positive edge of the clock signal `i_clk`.
   - If `i_MemWrite` is asserted (equals 1), it indicates a memory write operation.
   - The data `i_wData` is written to the memory location specified by `i_addr`.

##### Significance in the Processor

Interaction with Other Components:
   - The Data Memory module interacts with the ALU and the Control Unit in the processor.
   - The ALU provides the address (`i_ALUresult`) for memory read or write operations.
   - The Control Unit generates the control signals (`i_MemWrite`, `i_MemRead`, `i_MemtoReg`) to control the behavior of the Data Memory module.
   - The Register File provides the data to be written to memory (`i_wData`) during a memory write operation.
   - The output read data (`o_rData`) is passed back to the Register File or used as needed in subsequent stages of the processor pipeline.

Simply put, the Data Memory module plays a crucial role in storing and retrieving data in the MIPS processor.

It responds to memory read and write requests based on the provided address and control signals, and it interacts with other components such as the ALU, Control Unit, and Register File to facilitate data storage and retrieval operations.

#### Instruction Memory

```verilog title=Instruction_memory.v
`timescale 1ns / 1ps
module InstructionMemory (
    input [31:0] i_Addr,
    output reg [5:0] i_Ctr,  // [31-26]
    output reg [5:0] i_Funcode,  // [5-0]
    output reg [31:0] i_Instruction  // [31-0]
);
  parameter SIZE_IM = 128;  // size of this memory, by default 128*32
  reg [31:0] Imem[SIZE_IM-1:0];  // instruction memory
  integer n;
  initial begin
    for (n = 0; n < SIZE_IM; n = n + 1) begin
      Imem[n] = 32'b11111100000000000000000000000000;
    end
    $readmemb("instructions.mem", Imem);
    i_Instruction = 32'b11111100000000000000000000000000;
  end
  always @(i_Addr) begin
    if (i_Addr == -4) begin  // init
      i_Instruction = 32'b11111100000000000000000000000000;
    end else begin
      i_Instruction = Imem[i_Addr>>2];
    end
    i_Ctr = i_Instruction[31:26];
    i_Funcode = i_Instruction[5:0];
  end
endmodule
```
The provided code represents the Instruction Memory module (Instruction_memory.v) for the single-cycle MIPS processor.

##### Purpose:

The Instruction Memory module is responsible for storing the processor's instructions and providing them to the other components of the processor.

It acts as a read-only memory (ROM) that holds the program instructions.

##### IO

Inputs and Outputs:
- `i_Addr` (input, 32-bit): Represents the memory address from which the instruction should be fetched.
- `i_Ctr` (output, 6-bit): Outputs the control bits of the fetched instruction (bits [31:26]).
- `i_Funcode` (output, 6-bit): Outputs the function code of the fetched instruction (bits [5:0]).
- `i_Instruction` (output, 32-bit): Outputs the complete 32-bit fetched instruction.

##### Functionality

1. The module defines a parameter `SIZE_IM` which represents the size of the instruction memory.

By default, it is set to 128, meaning the memory can hold 128 32-bit instructions.

2. The module declares a register array `Imem` of size `SIZE_IM` to store the instructions.

3. In the initial block:
   - The memory is initialized with a default instruction (32'b11111100000000000000000000000000) using a loop.
   - The instructions are then loaded from a file named "instructions.mem" using the `$readmemb` system task. This file contains the binary representation of the instructions.
   - The `i_Instruction` output is initialized with the default instruction.

4. The module has an "always" block that is triggered whenever the `i_Addr` input changes:
   - If `i_Addr` is equal to -4 (used for initialization), the `i_Instruction` output is set to the default instruction.
   - Otherwise, the instruction is fetched from the `Imem` array using the address `i_Addr` shifted right by 2 bits (assuming word-aligned addresses).
   - The control bits (`i_Ctr`) and function code (`i_Funcode`) are extracted from the fetched instruction and assigned to the respective outputs.

Interaction with Other Components:
- The Program Counter (PC) module provides the memory address (`i_Addr`) to the Instruction Memory module to fetch the instruction at that address.
- The fetched instruction (`i_Instruction`) is then passed to other components of the processor, such as the Control Unit and the Register File, for further processing and execution.
- The control bits (`i_Ctr`) and function code (`i_Funcode`) are used by the Control Unit to generate appropriate control signals for the processor's data-path.

##### Significance

The Instruction Memory module is a crucial component of the MIPS processor as it holds the program instructions that the processor executes.

It provides the instructions to the processor's data-path, enabling the processor to perform the desired operations and execute the program stored in the memory.

##### Summary

Essentially, the Instruction Memory module in the single-cycle MIPS processor acts as a read-only memory that stores the program instructions. It fetches instructions based on the provided memory address and outputs the complete instruction along with its control bits and function code for further processing by other components of the processor.
