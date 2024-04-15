# cpre281-finalproj

This is the final project for CPRE281 taught at Iowa State University. 
The project is a simple processor that can execute a subset of the MIPS instruction set.
The processor is implemented in HDLVerilog and tested using a testbench.

Name: **Conner Ohnesorge**

Date: **4/10/2024**

## Introduction

The project is a simple processor that can at a variable speed execute a subset of the MIPS instruction set displaying the current instruction on the seven segment displays present on EP4CE115F29C7 FPGA board.

The variable speed of the processor is achieved through the use of a clock divider that divides the 50MHz clock signal by the value represented in the  from the FPGA board into a slower clock signal that is used to drive the processor.

A clock divider is a circuit that allows for the dividing of a given clock signal by a constant value. Below is an an example of a clock divider that divides the frequency of the clock by 2.
$$
f_{\text {out }}=\frac{f_{\text {in }}}{N}
$$

![[Pasted image 20240415105047.png]]

As I took this class whilst also taking CPRE381, I additionally decided to compare and contrast the experience writing the same processor in both Verilog and VHDL.

A basic single-cycle MIPS processor:

![[Pasted image 20240415102706.png]]


The state machine has five states:

**Fetch**: In this state, the processor fetches the next instruction from memory.
**Decode**: In this state, the processor decodes the instruction to determine what operation to perform.
**Execute**: In this state, the processor executes the instruction.
**Memory**: In this state, the processor accesses memory to read or write data.
**Writeback**: In this state, the processor writes the results of the instruction to a register.


