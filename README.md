# cpre281-finalproj

This is the final project for CPRE281 taught at Iowa State University. 
The project is a simple processor that can execute a subset of the MIPS instruction set.
The processor is implemented in HDLVerilog and tested using a testbench.

Name: **Conner Ohnesorge**

Date: **4/10/2024**

## Table of Contents

## Proposal

A MIPS processor that can execute a subset of the MIPS instruction set with additional features such as a clock divider, displaying the current instruction on the seven segment displays present on the FPGA board, and the ability to change the frequency of execution of the processor.

More specifically, the processor will be able to execute the following instructions: add, addi, sub, subi, and, andi, or, ori, lw, sw, beq, j, and jr. 

The frequency of execution for the processor will be variable and will be controlled by a clock divider that divides the 50MHz clock signal by a value set by the divider that will be used to divide the clock signal.

The current instruction being executed will be displayed on the seven segment displays present on the FPGA board.

The processor will be implemented in Verilog and tested using a test-bench.

## Introduction

The project is a simple MIPS processor that can at a variable speed execute a subset of the MIPS instruction set displaying the current instruction on the seven segment displays present on EP4CE115F29C7 FPGA board.

The variable speed of the processor is achieved through the use of a clock divider connected to a GPIO connected potentiometer that divides the 50MHz clock signal by the value represented in the from the FPGA board into a slower clock signal that is used to drive the processor.

A clock divider is a circuit that allows for the dividing of a given clock signal by a constant value. Below is an an example of a clock divider that divides the frequency of the clock by 2.

$$
f_{\text {out }}=\frac{f_{\text {in }}}{N}
$$

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

Supported Instructions:

ADD ADDU ADDI ADDIU SUB SUBU
AND ANDI OR ORI XOR XORI NOR
SLT SLTU SLL
SRA SRAV LW SW BEQ
BNE J LUI

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

Another example of this is the sign extender module that is used to extend the sign of a 16 bit number to a 32 bit number.

```verilog
module signextender (
  input [15:0] in,
  output [31:0] out
);
  assign out = {{16{in[15]}}, {in}};
endmodule
```

Additionally, the fact that in Verilog you do not need to preemptively define components before using them allows for a more flexible design and faster development.

Another nice feature of Verilog (specifically VerilogHDL) is the ability to print out the values of signals in the waveform viewer. This is a feature that is not present in VHDL and is very useful for debugging and understanding the behavior of the processor.

While you can do this in VHDL, it is not as easy as it is in Verilog because in VHDL you must deal with the typings of the signals and the fact that you must declare the signals before you can use them.

## Breaking down decoding a signal to 7-segment displays

As the signal representing the instruction is 5 bits long inside of the `controller.v` file, we need to decode this signal to display the current instruction on the 7-segment displays.

This means that we need to decode a 5-bit signal to a 35-bit signal that will be used to display the current instruction on the 7-segment displays.

5 bits = signal
7 bits needed per 7-segment display
longest word = 5 characters
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




The following is the wave diagram for my testbench of my processor without the addded seven segment displays.

![[Pasted image 20240503061843.png]]


below is the waveform with the seven segment ports included:
![[Pasted image 20240503065359.png]]


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

Waveform:

![[Pasted image 20240503131222.png]]


## Tooling 

First, as learned in CPRE381, I enjoy having test-benches for my code.

I used a test-bench to test my processor and ensure that it was working correctly.

The following is the main test-bench that I used to test my processor.

```verilog title="mips_tb.v"
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
