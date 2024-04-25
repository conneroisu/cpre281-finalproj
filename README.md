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
SLT SLTI SLTU SLTIU SLL SRL
SRA SLLV SRLV SRAV LW SW BEQ
BNE J LUI
