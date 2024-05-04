# cpre281-finalproj

This is the final project for CPRE281 taught at Iowa State University By Conner Ohnesorge.

The project is a simple processor that can execute a subset of the MIPS instruction set.

The processor is implemented in VerilogHDL, tested using a test-bench, and tested on an FPGA board.

Name: **Conner Ohnesorge**

Date: **4/10/2024**

![a.drawio (1).png](a.drawio%20(1).png)

## Table of Contents

## Proposal

A MIPS processor that can execute a subset of the MIPS instruction set with additional features such as a clock divider, displaying the current instruction on the seven segment displays present on the FPGA board, and the ability to change the frequency of execution of the processor.

More specifically, the processor will be able to execute the following instructions: LW SW J ADD ADDI BEQ ADDU SUBU AND ANDI OR ORI SUB NOR BNE SLT

The frequency of execution for the processor will be controlled by a clock divider. The current instruction being executed will be displayed on the seven segment displays present on the FPGA board. The processor will be implemented in Verilog and tested using a test-bench.

## Introduction

The project is a simple MIPS processor that can at a variable speed execute a subset of the MIPS instruction set displaying the current instruction on the seven segment displays present on **EP4CE115F29C7** FPGA board.

As a result of this desired function (and it's actualation into reality), the processor can technically be used to do **all** the other projects from other students in the class. As I took this class whilst also taking CPRE381, I additionally decided to compare and contrast the experience writing the same processor in both Verilog and VHDL.

While the overall state machine will be broken down below, the main processor state machine has **five** states:

**Fetch**: In this state, the processor fetches the next instruction from memory.
**Decode**: In this state, the processor decodes the instruction to determine what operation to perform.
**Execute**: In this state, the processor executes the instruction.
**Memory**: In this state, the processor accesses memory to read or write data.
**Write-back**: In this state, the processor writes the results of the instruction to a register.

Supported Instructions: LW SW J ADD ADDI BEQ ADDU SUBU AND ANDI OR ORI SUB NOR BNE




## State Machines

### Single Cycle MIPS Processor Staging
<!-- ```plantuml -->
<!-- @startuml -->
<!-- scale 450 width -->
<!--  -->
<!-- ' Define the main stages of the MIPS pipeline -->
<!-- state Fetch { -->
<!--     [*] --> InstructionFetch -->
<!--     InstructionFetch: Fetch instruction from\nmemory using PC -->
<!--     InstructionFetch --> PCUpdate : Increment PC -->
<!--     PCUpdate: Update PC to point to the next instruction -->
<!-- } -->
<!--  -->
<!-- state Decode { -->
<!--     [*] --> RegisterRead -->
<!--     RegisterRead: Read registers and decode the\ninstruction to determine the operation -->
<!--     RegisterRead --> SendToExecution -->
<!-- } -->
<!--  -->
<!-- state Execution { -->
<!--     [*] --> ALUOperation -->
<!--     ALUOperation: Perform arithmetic or logic operation\nbased on the function code or opcode -->
<!--     ALUOperation --> DecideNextStage -->
<!--     DecideNextStage: Decide whether to go to Memory\nor Write Back stage -->
<!-- } -->
<!--  -->
<!-- state Memory { -->
<!--     [*] --> MemoryAccess -->
<!--     MemoryAccess: Access memory if required (load or store) -->
<!--     MemoryAccess --> SendToWriteBack -->
<!--     MemoryAccess --> UpdatePC : If branch or jump -->
<!-- } -->
<!--  -->
<!-- state WriteBack { -->
<!--     [*] --> RegisterWrite -->
<!--     RegisterWrite: Write results back to register file -->
<!--     RegisterWrite --> NextInstruction : Update PC and get next instruction -->
<!-- } -->
<!--  -->
<!-- ' Define transitions between the main stages -->
<!-- Fetch --> Decode : Fetch complete -->
<!-- Decode --> Execution : Decode complete -->
<!-- Execution --> Memory : Execution complete -->
<!-- Execution --> WriteBack : For R-type instructions -->
<!-- Memory --> WriteBack : Memory read/write complete -->
<!-- WriteBack --> Fetch : Start next cycle -->
<!--  -->
<!-- ' Control Unit affecting all stages -->
<!-- state ControlUnit { -->
<!--     [*] --> GenerateSignals -->
<!--     GenerateSignals: Generate control signals based on\ninstruction type and operation -->
<!--     GenerateSignals --> AffectStages -->
<!--     AffectStages: Send signals to appropriate stages -->
<!-- } -->
<!--  -->
<!-- ' Connections from Control Unit to other stages -->
<!-- ControlUnit --> Fetch : Control fetch stage -->
<!-- ControlUnit --> Decode : Control decode stage -->
<!-- ControlUnit --> Execution : Control execution stage -->
<!-- ControlUnit --> Memory : Control memory stage -->
<!-- ControlUnit --> WriteBack : Control write back stage -->
<!-- @enduml -->
<!-- ``` -->

<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" contentStyleType="text/css" height="793.8794px" preserveAspectRatio="none" style="width:450px;height:793px;background:#1B1B1B;" version="1.1" viewBox="0 0 450 793" width="450.405px" zoomAndPan="magnify"><defs/><g><rect fill="#1B1B1B" height="793.8794" style="stroke:none;stroke-width:0.40504050405040504;" width="450.405" x="0" y="0"/><path d="M7.8983,136.8227 L120.9046,136.8227 A5.063,5.063 0 0 1 125.9676,141.8857 L125.9676,147.474 L2.8353,147.474 L2.8353,141.8857 A5.063,5.063 0 0 1 7.8983,136.8227 " fill="#313139" style="stroke:#313139;stroke-width:0.40504050405040504;"/><rect fill="none" height="110.087" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="123.1323" x="2.8353" y="136.8227"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="2.8353" x2="125.9676" y1="147.474" y2="147.474"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="15.7966" x="56.5032" y="144.1114">Fetch</text><ellipse cx="65.009" cy="155.9798" fill="#222222" rx="4.0504" ry="4.0504" style="stroke:#222222;stroke-width:0.40504050405040504;"/><g id="Fetch.InstructionFetch"><rect fill="#313139" height="26.0175" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="63.9964" x="33.0108" y="175.0167"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="33.0108" x2="97.0072" y1="185.668" y2="185.668"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="45.3645" x="42.3267" y="182.3055">InstructionFetch</text><text fill="#FFFFFF" font-family="sans-serif" font-size="4.8605" lengthAdjust="spacing" textLength="55.8956" x="35.036" y="192.2049">Fetch instruction from</text><text fill="#FFFFFF" font-family="sans-serif" font-size="4.8605" lengthAdjust="spacing" textLength="43.3393" x="35.036" y="197.8628">memory using PC</text></g><g id="Fetch.PCUpdate"><rect fill="#313139" height="20.3596" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="114.6265" x="7.6958" y="222.4996"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="7.6958" x2="122.3222" y1="233.1509" y2="233.1509"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="27.9478" x="51.0351" y="229.7884">PCUpdate</text><text fill="#FFFFFF" font-family="sans-serif" font-size="4.8605" lengthAdjust="spacing" textLength="106.5257" x="9.721" y="239.6877">Update PC to point to the next instruction</text></g><!--link *start*Fetch to InstructionFetch--><g id="link_*start*Fetch_InstructionFetch"><path d="M65.009,160.2166 C65.009,163.866 65.009,167.1346 65.009,172.3961 " fill="none" id="*start*Fetch-to-InstructionFetch" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="65.009,174.8264,66.6292,171.181,65.009,172.8012,63.3888,171.181,65.009,174.8264" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/></g><!--link InstructionFetch to PCUpdate--><g id="link_InstructionFetch_PCUpdate"><path d="M65.009,201.231 C65.009,207.9546 65.009,213.6414 65.009,219.8871 " fill="none" id="InstructionFetch-to-PCUpdate" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="65.009,222.3174,66.6292,218.672,65.009,220.2922,63.3888,218.672,65.009,222.3174" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.2655" lengthAdjust="spacing" textLength="34.8335" x="65.414" y="213.6158">Increment PC</text></g><path d="M100.8551,278.0968 L205.3555,278.0968 A5.063,5.063 0 0 1 210.4185,283.1598 L210.4185,288.7481 L95.7921,288.7481 L95.7921,283.1598 A5.063,5.063 0 0 1 100.8551,278.0968 " fill="#313139" style="stroke:#313139;stroke-width:0.40504050405040504;"/><rect fill="none" height="102.6887" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="114.6265" x="95.7921" y="278.0968"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="95.7921" x2="210.4185" y1="288.7481" y2="288.7481"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="22.2772" x="141.9667" y="285.3855">Decode</text><ellipse cx="153.7129" cy="297.2539" fill="#222222" rx="4.0504" ry="4.0504" style="stroke:#222222;stroke-width:0.40504050405040504;"/><g id="Decode.RegisterRead"><rect fill="#313139" height="26.0175" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="106.1206" x="100.6526" y="315.8858"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="100.6526" x2="206.7732" y1="326.5371" y2="326.5371"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="38.0738" x="134.676" y="323.1745">RegisterRead</text><text fill="#FFFFFF" font-family="sans-serif" font-size="4.8605" lengthAdjust="spacing" textLength="79.3879" x="102.6778" y="333.0739">Read registers and decode the</text><text fill="#FFFFFF" font-family="sans-serif" font-size="4.8605" lengthAdjust="spacing" textLength="98.0198" x="102.6778" y="338.7318">instruction to determine the operation</text></g><g id="Decode.SendToExecution"><rect fill="#313139" height="20.252" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="57.5158" x="124.955" y="356.483"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="124.955" x2="182.4707" y1="367.1343" y2="367.1343"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="49.4149" x="129.0054" y="363.7717">SendToExecution</text></g><!--link *start*Decode to RegisterRead--><g id="link_*start*Decode_RegisterRead"><path d="M153.7129,301.438 C153.7129,305.0064 153.7129,308.1373 153.7129,313.2895 " fill="none" id="*start*Decode-to-RegisterRead" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="153.7129,315.7197,155.333,312.0743,153.7129,313.6945,152.0927,312.0743,153.7129,315.7197" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/></g><!--link RegisterRead to SendToExecution--><g id="link_RegisterRead_SendToExecution"><path d="M153.7129,342.104 C153.7129,346.7661 153.7129,349.5325 153.7129,353.9029 " fill="none" id="RegisterRead-to-SendToExecution" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="153.7129,356.3331,155.333,352.6878,153.7129,354.3079,152.0927,352.6878,153.7129,356.3331" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/></g><path d="M154.7255,411.9707 L259.2259,411.9707 A5.063,5.063 0 0 1 264.2889,417.0338 L264.2889,422.622 L149.6625,422.622 L149.6625,417.0338 A5.063,5.063 0 0 1 154.7255,411.9707 " fill="#313139" style="stroke:#313139;stroke-width:0.40504050405040504;"/><rect fill="none" height="108.4582" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="114.6265" x="149.6625" y="411.9707"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="149.6625" x2="264.2889" y1="422.622" y2="422.622"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="27.5428" x="193.2043" y="419.2595">Execution</text><ellipse cx="207.5833" cy="431.1279" fill="#222222" rx="4.0504" ry="4.0504" style="stroke:#222222;stroke-width:0.40504050405040504;"/><g id="Execution.ALUOperation"><rect fill="#313139" height="26.0175" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="106.1206" x="154.523" y="449.7598"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="154.523" x2="260.6436" y1="460.4111" y2="460.4111"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="38.0738" x="188.5464" y="457.0485">ALUOperation</text><text fill="#FFFFFF" font-family="sans-serif" font-size="4.8605" lengthAdjust="spacing" textLength="93.5644" x="156.5482" y="466.9479">Perform arithmetic or logic operation</text><text fill="#FFFFFF" font-family="sans-serif" font-size="4.8605" lengthAdjust="spacing" textLength="98.0198" x="156.5482" y="472.6058">based on the function code or opcode</text></g><g id="Execution.DecideNextStage"><rect fill="#313139" height="26.0175" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="90.7291" x="162.2187" y="490.361"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="162.2187" x2="252.9478" y1="501.0123" y2="501.0123"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="48.6049" x="183.2808" y="497.6498">DecideNextStage</text><text fill="#FFFFFF" font-family="sans-serif" font-size="4.8605" lengthAdjust="spacing" textLength="82.6283" x="164.2439" y="507.5491">Decide whether to go to Memory</text><text fill="#FFFFFF" font-family="sans-serif" font-size="4.8605" lengthAdjust="spacing" textLength="49.82" x="164.2439" y="513.207">or Write Back stage</text></g><!--link *start*Execution to ALUOperation--><g id="link_*start*Execution_ALUOperation"><path d="M207.5833,435.312 C207.5833,438.8844 207.5833,442.0113 207.5833,447.1675 " fill="none" id="*start*Execution-to-ALUOperation" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="207.5833,449.5977,209.2034,445.9524,207.5833,447.5725,205.9631,445.9524,207.5833,449.5977" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/></g><!--link ALUOperation to DecideNextStage--><g id="link_ALUOperation_DecideNextStage"><path d="M207.5833,475.8727 C207.5833,480.4659 207.5833,483.2242 207.5833,487.8174 " fill="none" id="ALUOperation-to-DecideNextStage" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="207.5833,490.2476,209.2034,486.6022,207.5833,488.2224,205.9631,486.6022,207.5833,490.2476" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/></g><path d="M243.2268,551.6206 L357.8533,551.6206 A5.063,5.063 0 0 1 362.9163,556.6836 L362.9163,562.2719 L238.1638,562.2719 L238.1638,556.6836 A5.063,5.063 0 0 1 243.2268,551.6206 " fill="#313139" style="stroke:#313139;stroke-width:0.40504050405040504;"/><rect fill="none" height="104.325" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="124.7525" x="238.1638" y="551.6206"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="238.1638" x2="362.9163" y1="562.2719" y2="562.2719"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="22.2772" x="289.4014" y="558.9094">Memory</text><ellipse cx="299.73" cy="570.7778" fill="#222222" rx="4.0504" ry="4.0504" style="stroke:#222222;stroke-width:0.40504050405040504;"/><g id="Memory.MemoryAccess"><rect fill="#313139" height="20.3596" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="113.4113" x="243.0243" y="589.8147"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="243.0243" x2="356.4356" y1="600.466" y2="600.466"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="42.5293" x="278.4653" y="597.1034">MemoryAccess</text><text fill="#FFFFFF" font-family="sans-serif" font-size="4.8605" lengthAdjust="spacing" textLength="105.3105" x="245.0495" y="607.0028">Access memory if required (load or store)</text></g><g id="Memory.SendToWriteBack"><rect fill="#313139" height="20.252" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="57.9208" x="243.6319" y="631.6432"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="243.6319" x2="301.5527" y1="642.2945" y2="642.2945"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="49.82" x="247.6823" y="638.932">SendToWriteBack</text></g><g id="Memory.UpdatePC"><rect fill="#313139" height="20.252" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="36.0486" x="308.8434" y="631.6432"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="308.8434" x2="344.892" y1="642.2945" y2="642.2945"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="27.9478" x="312.8938" y="638.932">UpdatePC</text></g><!--link *start*Memory to MemoryAccess--><g id="link_*start*Memory_MemoryAccess"><path d="M299.73,575.0145 C299.73,578.7733 299.73,582.2242 299.73,587.2913 " fill="none" id="*start*Memory-to-MemoryAccess" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="299.73,589.7215,301.3501,586.0761,299.73,587.6963,298.1098,586.0761,299.73,589.7215" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/></g><!--link MemoryAccess to SendToWriteBack--><g id="link_MemoryAccess_SendToWriteBack"><path d="M293.1602,610.3178 C288.8951,616.758 284.6963,623.092 280.4434,629.5119 " fill="none" id="MemoryAccess-to-SendToWriteBack" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="279.1013,631.5379,282.4652,629.3936,280.2197,629.8495,279.7638,627.6041,279.1013,631.5379" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/></g><!--link MemoryAccess to UpdatePC--><g id="link_MemoryAccess_UpdatePC"><path d="M306.2997,610.3178 C310.5648,616.758 314.7636,623.092 319.0165,629.5119 " fill="none" id="MemoryAccess-to-UpdatePC" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="320.3587,631.5379,319.6961,627.6041,319.2402,629.8495,316.9948,629.3936,320.3587,631.5379" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.2655" lengthAdjust="spacing" textLength="43.7444" x="315.1215" y="622.7594">If branch or jump</text></g><path d="M164.7502,687.131 L300.2363,687.131 A5.063,5.063 0 0 1 305.2993,692.194 L305.2993,697.7823 L159.6872,697.7823 L159.6872,692.194 A5.063,5.063 0 0 1 164.7502,687.131 " fill="#313139" style="stroke:#313139;stroke-width:0.40504050405040504;"/><rect fill="none" height="104.325" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="145.6121" x="159.6872" y="687.131"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="159.6872" x2="305.2993" y1="697.7823" y2="697.7823"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="27.9478" x="218.5194" y="694.4197">WriteBack</text><ellipse cx="210.1148" cy="706.2881" fill="#222222" rx="4.0504" ry="4.0504" style="stroke:#222222;stroke-width:0.40504050405040504;"/><g id="WriteBack.RegisterWrite"><rect fill="#313139" height="20.3596" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="91.1341" x="164.5477" y="725.325"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="164.5477" x2="255.6818" y1="735.9763" y2="735.9763"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="37.6688" x="191.2804" y="732.6138">RegisterWrite</text><text fill="#FFFFFF" font-family="sans-serif" font-size="4.8605" lengthAdjust="spacing" textLength="83.0333" x="166.5729" y="742.5131">Write results back to register file</text></g><g id="WriteBack.NextInstruction"><rect fill="#313139" height="20.252" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="50.225" x="185.0023" y="767.1535"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="185.0023" x2="235.2273" y1="777.8048" y2="777.8048"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="42.1242" x="189.0527" y="774.4423">NextInstruction</text></g><!--link *start*WriteBack to RegisterWrite--><g id="link_*start*WriteBack_RegisterWrite"><path d="M210.1148,710.5248 C210.1148,714.2836 210.1148,717.7346 210.1148,722.8016 " fill="none" id="*start*WriteBack-to-RegisterWrite" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="210.1148,725.2319,211.7349,721.5865,210.1148,723.2067,208.4946,721.5865,210.1148,725.2319" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/></g><!--link RegisterWrite to NextInstruction--><g id="link_RegisterWrite_NextInstruction"><path d="M210.1148,745.8282 C210.1148,752.2683 210.1148,758.1981 210.1148,764.618 " fill="none" id="RegisterWrite-to-NextInstruction" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="210.1148,767.0482,211.7349,763.4029,210.1148,765.023,208.4946,763.4029,210.1148,767.0482" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.2655" lengthAdjust="spacing" textLength="90.7291" x="210.5198" y="758.2698">Update PC and get next instruction</text></g><path d="M183.8884,2.8353 L280.288,2.8353 A5.063,5.063 0 0 1 285.351,7.8983 L285.351,13.4866 L178.8254,13.4866 L178.8254,7.8983 A5.063,5.063 0 0 1 183.8884,2.8353 " fill="#313139" style="stroke:#313139;stroke-width:0.40504050405040504;"/><rect fill="none" height="102.7962" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="106.5257" x="178.8254" y="2.8353"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="178.8254" x2="285.351" y1="13.4866" y2="13.4866"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="31.1881" x="216.4941" y="10.124">ControlUnit</text><ellipse cx="232.6958" cy="21.9924" fill="#222222" rx="4.0504" ry="4.0504" style="stroke:#222222;stroke-width:0.40504050405040504;"/><g id="ControlUnit.GenerateSignals"><rect fill="#313139" height="26.0175" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="96.3996" x="184.4959" y="40.6243"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="184.4959" x2="280.8956" y1="51.2756" y2="51.2756"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="46.1746" x="209.6085" y="47.913">GenerateSignals</text><text fill="#FFFFFF" font-family="sans-serif" font-size="4.8605" lengthAdjust="spacing" textLength="88.2988" x="186.5212" y="57.8124">Generate control signals based on</text><text fill="#FFFFFF" font-family="sans-serif" font-size="4.8605" lengthAdjust="spacing" textLength="77.3627" x="186.5212" y="63.4703">instruction type and operation</text></g><g id="ControlUnit.AffectStages"><rect fill="#313139" height="20.3596" rx="5.063" ry="5.063" style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" width="98.0198" x="183.6859" y="81.2215"/><line style="stroke:#E7E7E7;stroke-width:0.20252025202520252;" x1="183.6859" x2="281.7057" y1="91.8728" y2="91.8728"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.6706" lengthAdjust="spacing" textLength="35.2385" x="215.0765" y="88.5103">AffectStages</text><text fill="#FFFFFF" font-family="sans-serif" font-size="4.8605" lengthAdjust="spacing" textLength="89.919" x="185.7111" y="98.4096">Send signals to appropriate stages</text></g><!--link *start*ControlUnit to GenerateSignals--><g id="link_*start*ControlUnit_GenerateSignals"><path d="M232.6958,26.1765 C232.6958,29.749 232.6958,32.8759 232.6958,38.028 " fill="none" id="*start*ControlUnit-to-GenerateSignals" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="232.6958,40.4582,234.3159,36.8129,232.6958,38.433,231.0756,36.8129,232.6958,40.4582" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/></g><!--link GenerateSignals to AffectStages--><g id="link_GenerateSignals_AffectStages"><path d="M232.6958,66.7575 C232.6958,71.4357 232.6958,74.2305 232.6958,78.6252 " fill="none" id="GenerateSignals-to-AffectStages" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="232.6958,81.0554,234.3159,77.4101,232.6958,79.0302,231.0756,77.4101,232.6958,81.0554" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/></g><!--link Fetch to Decode--><g id="link_Fetch_Decode"><path d="M91.5149,247.0585 C95.1562,253.5311 98.9838,259.959 102.8803,265.9455 C105.4766,269.9352 106.8458,272.0064 109.7377,276.0163 " fill="none" id="Fetch-to-Decode" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="111.1593,277.9874,110.341,274.083,109.9747,276.3448,107.7129,275.9785,111.1593,277.9874" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.2655" lengthAdjust="spacing" textLength="40.099" x="103.2853" y="264.3525">Fetch complete</text></g><!--link Decode to Execution--><g id="link_Decode_Execution"><path d="M168.1202,380.9851 C170.279,387.3807 172.5878,393.7885 174.9775,399.8195 C176.5491,403.7849 177.2772,405.6182 179.0593,409.6767 " fill="none" id="Decode-to-Execution" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="180.0365,411.9019,180.0542,407.9127,179.2222,410.0476,177.0873,409.2156,180.0365,411.9019" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.2655" lengthAdjust="spacing" textLength="45.7696" x="175.3825" y="398.2265">Decode complete</text></g><!--link Execution to Memory--><g id="link_Execution_Memory"><path d="M230.1683,520.5702 C233.6436,527.1076 237.4104,533.5558 241.4041,539.4694 C244.1098,543.4752 245.5645,545.5706 248.6631,549.5117 " fill="none" id="Execution-to-Memory" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="250.1652,551.4221,249.1857,547.5551,248.9134,549.8301,246.6384,549.5578,250.1652,551.4221" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.2655" lengthAdjust="spacing" textLength="51.0351" x="241.8092" y="537.8763">Execution complete</text></g><!--link Execution to WriteBack--><g id="link_Execution_WriteBack"><path d="M181.2111,520.6269 C177.4523,530.7165 174.1674,541.3285 172.1422,551.6206 C163.1827,597.1107 157.7997,611.8501 172.1422,655.9428 C175.6418,666.6967 179.8048,675.1747 186.0626,684.92 " fill="none" id="Execution-to-WriteBack" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="187.3758,686.9649,186.7694,683.0221,186.2815,685.2608,184.0428,684.7729,187.3758,686.9649" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.2655" lengthAdjust="spacing" textLength="57.9208" x="172.5473" y="605.6315">For R-type instructions</text></g><!--link Memory to WriteBack--><g id="link_Memory_WriteBack"><path d="M274.3299,656.0725 C269.198,666.2268 264.9146,674.706 259.7868,684.8604 " fill="none" id="Memory-to-WriteBack" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="258.6913,687.0297,261.7807,684.506,259.6042,685.2219,258.8883,683.0454,258.6913,687.0297" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.2655" lengthAdjust="spacing" textLength="74.1224" x="266.9217" y="673.3867">Memory read/write complete</text></g><!--link WriteBack to Fetch--><g id="link_WriteBack_Fetch"><path d="M159.59,711.32 C116.0968,689.626 69.2619,654.5698 69.2619,604.1868 C69.2619,329.0347 69.2619,329.0347 69.2619,329.0347 C69.2619,302.0104 68.4054,274.4249 67.3402,249.4177 " fill="none" id="WriteBack-to-Fetch" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="67.2367,246.9896,65.7732,250.7007,67.3229,249.013,69.0106,250.5628,67.2367,246.9896" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.2655" lengthAdjust="spacing" textLength="40.5041" x="69.667" y="468.0514">Start next cycle</text></g><!--link ControlUnit to Fetch--><g id="link_ControlUnit_Fetch"><path d="M178.7808,68.3344 C150.2862,78.0351 116.4613,93.694 93.5644,117.7858 C88.3515,123.27 85.1535,127.6383 81.5851,134.5119 " fill="none" id="ControlUnit-to-Fetch" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="80.4653,136.6688,83.5829,134.1799,81.3985,134.8713,80.707,132.6869,80.4653,136.6688" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.2655" lengthAdjust="spacing" textLength="49.4149" x="93.9694" y="123.0784">Control fetch stage</text></g><!--link ControlUnit to Decode--><g id="link_ControlUnit_Decode"><path d="M182.6854,105.829 C175.7187,115.4932 169.4932,125.9878 165.2565,136.8227 C147.5158,182.167 145.9025,235.6921 147.9156,275.5157 " fill="none" id="ControlUnit-to-Decode" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="148.0383,277.9428,149.4723,274.2203,147.936,275.9202,146.2361,274.3839,148.0383,277.9428" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.2655" lengthAdjust="spacing" textLength="55.4905" x="165.6616" y="193.7134">Control decode stage</text></g><!--link ControlUnit to Execution--><g id="link_ControlUnit_Execution"><path d="M232.1166,105.7237 C231.9302,187.5945 230.5815,344.6004 223.1773,399.8195 C222.6508,403.7363 222.4354,405.3699 221.678,409.4001 " fill="none" id="ControlUnit-to-Execution" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="221.2291,411.7885,223.4947,408.5051,221.6031,409.7981,220.3101,407.9066,221.2291,411.7885" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.2655" lengthAdjust="spacing" textLength="61.5662" x="230.8731" y="264.3525">Control execution stage</text></g><!--link ControlUnit to Memory--><g id="link_ControlUnit_Memory"><path d="M273.5846,105.6913 C289.4379,130.1436 303.7804,160.7525 303.7804,191.4586 C303.7804,191.4586 303.7804,191.4586 303.7804,466.6067 C303.7804,494.6355 303.1623,523.4511 302.4211,548.997 " fill="none" id="ControlUnit-to-Memory" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="302.3506,551.4262,304.0758,547.8294,302.4093,549.4018,300.8368,547.7354,302.3506,551.4262" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.2655" lengthAdjust="spacing" textLength="58.3258" x="304.1854" y="331.2895">Control memory stage</text></g><!--link ControlUnit to WriteBack--><g id="link_ControlUnit_WriteBack"><path d="M285.4604,76.4757 C329.3587,98.3924 384.3834,136.766 384.3834,191.4586 C384.3834,191.4586 384.3834,191.4586 384.3834,604.1868 C384.3834,628.0356 383.6463,636.2417 370.207,655.9428 C354.3213,679.2327 331.6759,695.901 307.4829,708.9473 " fill="none" id="ControlUnit-to-WriteBack" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><polygon fill="#E7E7E7" points="305.3438,710.1008,309.3214,709.7966,307.1264,709.1396,307.7834,706.9445,305.3438,710.1008" style="stroke:#E7E7E7;stroke-width:0.40504050405040504;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="5.2655" lengthAdjust="spacing" textLength="62.3762" x="384.7885" y="398.2265">Control write back stage</text></g><!--SRC=[TLHBZzCm4BxdLyoDXxI20rnoG5gwW5PYeMgfE6mvkCuaDIHsi1rrAxJ_dV4hSRFP7jfqvflNbs_6SDOYl7l_5awYiiUYU04tM0k9O8y87HCIZ6KD6b2rDztThhVGYnvR0XNaimYVqV8Z_2k0FlUlVy7LrGUubSRgWLkXf7TxvznOnb0nsQ7MgjlB3Zkbpp0O8HjOhnQZVPtrQjTNhecI_5nZXzAcWEGh8MBMAx0AUYK8Gmzk7eaFDgzVF1PngXlagiBPM1jiXB6eDyWgxyWD9RXlqD5aWCaAgf26QkrbFYVLhv1GNI9RzQYPRs6UrrVUegn-g4yFo8VBFaVJhDNhhxll5obpGmbhrBNI7J0jxB53ApWe3Qrgt4E2xUM16Qp0zKijreCCpVkH2Avwz_GakwzF_8aAln6_MwSW3vhPocY0qn4fltQaDCfzt_dtlvTKuoSrYF2HyJz1YjFa0JGREnYlEKTZl2Ctb11-8UfBrFIs_Wv2qumlMqLKKq5ZbSPNJsApj-1RSXqjWuBQI6oaoHeEcaaIAoN-FNJzrFsOv1c9UV-55hobZ8HeD4Dh3HnS1c8igGvgqIw4-TIE-6oB85yCfzK6xU92J4U1PZ72cQamsXEYd1-AOjhDk45foxdg-fOaNqIxWqpYBHDyX4s-wRqIR38_Wvo8fSf4- -RAddlCPp95p3Q7HxEcfNjpyhIDDIQO2meJbK0orf4pVkP4F76rKj9grS9E2Wkihf5gqXLZRPie2WA8E0-xbC0Nb6wJS2iQoTeWuvcj70tKOgXdWWVIoixkZUF0lUJBEpDB6ow7xtaRUlMxdHbAlmDZCL8UwtkjUYrSBt70nyY3nC2tl-gNn52WyZiVGt8sSePJKEt_Xmimnuv2I-1uT9VHkUPI08wsvPXHVIaW7f1bT2wf513aT1ZFs7y0]--></g></svg>
 
### Instructions

<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" contentStyleType="text/css" height="1156px" preserveAspectRatio="none" style="width:1047px;height:1156px;background:#1B1B1B;" version="1.1" viewBox="0 0 1047 1156" width="1047px" zoomAndPan="magnify"><defs/><g><rect fill="#1B1B1B" height="1156" style="stroke:none;stroke-width:1.0;" width="1047" x="0" y="0"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" font-weight="bold" lengthAdjust="spacing" textLength="446" x="293.875" y="22.9951">MIPS Processor Architecture with Assembly Instructions</text><!--cluster IF--><g id="cluster_IF"><path d="M209.25,220.5969 L368.25,220.5969 A12.5,12.5 0 0 1 380.75,233.0969 L380.75,241.8938 L196.75,241.8938 L196.75,233.0969 A12.5,12.5 0 0 1 209.25,220.5969 " fill="#313139" style="stroke:#313139;stroke-width:1.0;"/><rect fill="none" height="101" rx="12.5" ry="12.5" style="stroke:#E7E7E7;stroke-width:0.5;" width="184" x="196.75" y="220.5969"/><line style="stroke:#E7E7E7;stroke-width:0.5;" x1="196.75" x2="380.75" y1="241.8938" y2="241.8938"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="116" x="230.75" y="237.592">Instruction Fetch</text></g><!--cluster DC--><g id="cluster_DC"><path d="M239.25,385.5969 L487.25,385.5969 A12.5,12.5 0 0 1 499.75,398.0969 L499.75,406.8938 L226.75,406.8938 L226.75,398.0969 A12.5,12.5 0 0 1 239.25,385.5969 " fill="#313139" style="stroke:#313139;stroke-width:1.0;"/><rect fill="none" height="101" rx="12.5" ry="12.5" style="stroke:#E7E7E7;stroke-width:0.5;" width="273" x="226.75" y="385.5969"/><line style="stroke:#E7E7E7;stroke-width:0.5;" x1="226.75" x2="499.75" y1="406.8938" y2="406.8938"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="110" x="308.25" y="402.592">Decode/Control</text></g><!--cluster EX--><g id="cluster_EX"><path d="M449.25,558.8669 L646.25,558.8669 A12.5,12.5 0 0 1 658.75,571.3669 L658.75,580.1638 L436.75,580.1638 L436.75,571.3669 A12.5,12.5 0 0 1 449.25,558.8669 " fill="#313139" style="stroke:#313139;stroke-width:1.0;"/><rect fill="none" height="260.83" rx="12.5" ry="12.5" style="stroke:#E7E7E7;stroke-width:0.5;" width="222" x="436.75" y="558.8669"/><line style="stroke:#E7E7E7;stroke-width:0.5;" x1="436.75" x2="658.75" y1="580.1638" y2="580.1638"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="68" x="513.75" y="575.862">Execution</text></g><!--cluster MEM--><g id="cluster_MEM"><path d="M497.25,899.5269 L616.25,899.5269 A12.5,12.5 0 0 1 628.75,912.0269 L628.75,920.8238 L484.75,920.8238 L484.75,912.0269 A12.5,12.5 0 0 1 497.25,899.5269 " fill="#313139" style="stroke:#313139;stroke-width:1.0;"/><rect fill="none" height="101" rx="12.5" ry="12.5" style="stroke:#E7E7E7;stroke-width:0.5;" width="144" x="484.75" y="899.5269"/><line style="stroke:#E7E7E7;stroke-width:0.5;" x1="484.75" x2="628.75" y1="920.8238" y2="920.8238"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="109" x="502.25" y="916.522">Memory Access</text></g><!--cluster WB--><g id="cluster_WB"><path d="M702.25,1049.5269 L849.25,1049.5269 A12.5,12.5 0 0 1 861.75,1062.0269 L861.75,1070.8238 L689.75,1070.8238 L689.75,1062.0269 A12.5,12.5 0 0 1 702.25,1049.5269 " fill="#313139" style="stroke:#313139;stroke-width:1.0;"/><rect fill="none" height="101" rx="12.5" ry="12.5" style="stroke:#E7E7E7;stroke-width:0.5;" width="172" x="689.75" y="1049.5269"/><line style="stroke:#E7E7E7;stroke-width:0.5;" x1="689.75" x2="861.75" y1="1070.8238" y2="1070.8238"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="73" x="739.25" y="1066.522">Write Back</text></g><g id="IF.IM"><rect fill="#313139" height="50" rx="12.5" ry="12.5" style="stroke:#E7E7E7;stroke-width:0.5;" width="152" x="212.75" y="255.5969"/><line style="stroke:#E7E7E7;stroke-width:0.5;" x1="212.75" x2="364.75" y1="281.8938" y2="281.8938"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="132" x="222.75" y="273.592">Instruction Memory</text></g><g id="DC.RF"><rect fill="#313139" height="50" rx="12.5" ry="12.5" style="stroke:#E7E7E7;stroke-width:0.5;" width="105" x="379.25" y="420.5969"/><line style="stroke:#E7E7E7;stroke-width:0.5;" x1="379.25" x2="484.25" y1="446.8938" y2="446.8938"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="85" x="389.25" y="438.592">Register File</text></g><g id="DC.CU"><rect fill="#313139" height="50" rx="12.5" ry="12.5" style="stroke:#E7E7E7;stroke-width:0.5;" width="101" x="243.25" y="420.5969"/><line style="stroke:#E7E7E7;stroke-width:0.5;" x1="243.25" x2="344.25" y1="446.8938" y2="446.8938"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="81" x="253.25" y="438.592">Control Unit</text></g><g id="EX.ALUC"><rect fill="#313139" height="50" rx="12.5" ry="12.5" style="stroke:#E7E7E7;stroke-width:0.5;" width="100" x="542.75" y="593.8669"/><line style="stroke:#E7E7E7;stroke-width:0.5;" x1="542.75" x2="642.75" y1="620.1638" y2="620.1638"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="80" x="552.75" y="611.862">ALU Control</text></g><g id="EX.ALU"><rect fill="#313139" height="50" rx="12.5" ry="12.5" style="stroke:#E7E7E7;stroke-width:0.5;" width="50" x="462.75" y="753.6969"/><line style="stroke:#E7E7E7;stroke-width:0.5;" x1="462.75" x2="512.75" y1="779.9938" y2="779.9938"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="26" x="474.75" y="771.692">ALU</text></g><g id="MEM.DM"><rect fill="#313139" height="50" rx="12.5" ry="12.5" style="stroke:#E7E7E7;stroke-width:0.5;" width="111" x="501.25" y="934.5269"/><line style="stroke:#E7E7E7;stroke-width:0.5;" x1="501.25" x2="612.25" y1="960.8238" y2="960.8238"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="91" x="511.25" y="952.522">Data Memory</text></g><g id="WB.UR"><rect fill="#313139" height="50" rx="12.5" ry="12.5" style="stroke:#E7E7E7;stroke-width:0.5;" width="140" x="705.75" y="1084.5269"/><line style="stroke:#E7E7E7;stroke-width:0.5;" x1="705.75" x2="845.75" y1="1110.8238" y2="1110.8238"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="120" x="715.75" y="1102.522">Update Registers</text></g><path d="M19.5,44.2969 L202,44.2969 A12.5,12.5 0 0 1 214.5,56.7969 L214.5,70.5938 L7,70.5938 L7,56.7969 A12.5,12.5 0 0 1 19.5,44.2969 " fill="#313139" style="stroke:#313139;stroke-width:1.0;"/><rect fill="none" height="98.2969" rx="12.5" ry="12.5" style="stroke:#E7E7E7;stroke-width:0.5;" width="207.5" x="7" y="44.2969"/><line style="stroke:#E7E7E7;stroke-width:0.5;" x1="7" x2="214.5" y1="70.5938" y2="70.5938"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="118" x="51.75" y="62.292">Program Counter</text><g id="PC.PC_Current"><rect fill="#313139" height="50" rx="12.5" ry="12.5" style="stroke:#E7E7E7;stroke-width:0.5;" width="95" x="19" y="82.5938"/><line style="stroke:#E7E7E7;stroke-width:0.5;" x1="19" x2="114" y1="108.8906" y2="108.8906"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="75" x="29" y="100.5889">Current PC</text></g><g id="PC.PC_Next"><rect fill="#313139" height="50" rx="12.5" ry="12.5" style="stroke:#E7E7E7;stroke-width:0.5;" width="74" x="131.5" y="82.5938"/><line style="stroke:#E7E7E7;stroke-width:0.5;" x1="131.5" x2="205.5" y1="108.8906" y2="108.8906"/><text fill="#FFFFFF" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="54" x="141.5" y="100.5889">Next PC</text></g><g id="elem_GMN29"><path d="M518.75,410.3269 L518.75,480.8581 L744.75,480.8581 L744.75,420.3269 L734.75,410.3269 L518.75,410.3269 " fill="#714137" style="stroke:#E7E7E7;stroke-width:0.5;"/><path d="M734.75,410.3269 L734.75,420.3269 L744.75,420.3269 L734.75,410.3269 " fill="#714137" style="stroke:#E7E7E7;stroke-width:1.0;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="149" x="524.75" y="427.3938">Control Signals Include:</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="148" x="524.75" y="442.5266">- RegDst, Jump, Branch</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="205" x="524.75" y="457.6594">- MemRead, MemtoReg, ALUSrc</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="170" x="524.75" y="472.7922">- RegWrite, MemWrite, Bne</text></g><g id="elem_GMN32"><path d="M675.25,735.8669 L675.25,774.6969 L513,778.6969 L675.25,782.6969 L675.25,821.5309 A0,0 0 0 0 675.25,821.5309 L856.25,821.5309 A0,0 0 0 0 856.25,821.5309 L856.25,745.8669 L846.25,735.8669 L675.25,735.8669 A0,0 0 0 0 675.25,735.8669 " fill="#714137" style="stroke:#E7E7E7;stroke-width:0.5;"/><path d="M846.25,735.8669 L846.25,745.8669 L856.25,745.8669 L846.25,735.8669 " fill="#714137" style="stroke:#E7E7E7;stroke-width:0.5;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="134" x="681.25" y="752.9338">Supports operations:</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="160" x="681.25" y="768.0666">- ADD, ADDI, SUB, SUBU</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="133" x="681.25" y="783.1994">- AND, ANDI, OR, ORI</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="138" x="681.25" y="798.3322">- NOR, SLT, BEQ, BNE</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="66" x="681.25" y="813.465">- LW, SW, J</text></g><g id="elem_GMN35"><path d="M249.25,65.7469 L249.25,89.4469 L214.95,93.4469 L249.25,97.4469 L249.25,121.1453 A0,0 0 0 0 249.25,121.1453 L404.25,121.1453 A0,0 0 0 0 404.25,121.1453 L404.25,75.7469 L394.25,65.7469 L249.25,65.7469 A0,0 0 0 0 249.25,65.7469 " fill="#714137" style="stroke:#E7E7E7;stroke-width:0.5;"/><path d="M394.25,65.7469 L394.25,75.7469 L404.25,75.7469 L394.25,65.7469 " fill="#714137" style="stroke:#E7E7E7;stroke-width:0.5;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="134" x="255.25" y="82.8138">Sequentially updates</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="106" x="255.25" y="97.9466">to fetch the next</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="126" x="255.25" y="113.0794">instruction address.</text></g><!--link PC to IM--><g id="link_PC_IM"><path d="M157.52,143.0969 C192.23,179.1969 233.942,222.5913 261.242,250.9913 " fill="none" id="PC-to-IM" style="stroke:#E7E7E7;stroke-width:1.0;"/><polygon fill="#E7E7E7" points="265.4,255.3169,262.0467,246.0565,261.935,251.7122,256.2792,251.6005,265.4,255.3169" style="stroke:#E7E7E7;stroke-width:1.0;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="111" x="216.75" y="185.6638">"Fetch Instruction</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="88" x="228.25" y="200.7966">(PC Address)"</text></g><!--link IM to RF--><g id="link_IM_RF"><path d="M351.52,305.9669 C366.59,314.1869 381.55,324.6469 392.75,337.5969 C413.32,361.3769 422.211,391.0019 426.881,414.5119 " fill="none" id="IM-to-RF" style="stroke:#E7E7E7;stroke-width:1.0;"/><polygon fill="#E7E7E7" points="428.05,420.3969,430.2199,410.79,427.0758,415.4927,422.3732,412.3487,428.05,420.3969" style="stroke:#E7E7E7;stroke-width:1.0;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="109" x="429.75" y="350.6638">"Send Instruction</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="141" x="413.75" y="365.7966">(OPCode, Addresses)"</text></g><!--link IM to CU--><g id="link_IM_CU"><path d="M287.17,305.8469 C286.6,315.6869 286.03,327.1869 285.75,337.5969 C285.37,351.8169 284.99,355.3969 285.75,369.5969 C286.65,386.5969 287.9688,399.7116 289.7688,414.3716 " fill="none" id="IM-to-CU" style="stroke:#E7E7E7;stroke-width:1.0;"/><polygon fill="#E7E7E7" points="290.5,420.3269,293.3734,410.9065,289.8907,415.3641,285.433,411.8814,290.5,420.3269" style="stroke:#E7E7E7;stroke-width:1.0;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="101" x="286.75" y="350.6638">"Control Signals</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="66" x="304.25" y="365.7966">(OPCode)"</text></g><!--link RF to ALU--><g id="link_RF_ALU"><path d="M417.24,470.8569 C405.87,491.3669 390.97,521.9369 384.75,550.8669 C376.06,591.2769 371.44,604.7369 384.75,643.8669 C400.05,688.8269 432.9256,726.2969 458.1756,750.8169 " fill="none" id="RF-to-ALU" style="stroke:#E7E7E7;stroke-width:1.0;"/><polygon fill="#E7E7E7" points="462.48,754.9969,458.81,745.8573,458.893,751.5136,453.2367,751.5965,462.48,754.9969" style="stroke:#E7E7E7;stroke-width:1.0;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="131" x="389.25" y="615.9338">"Data for Operations</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="138" x="385.75" y="631.0666">(Read Register Data)"</text></g><!--link CU to ALUC--><g id="link_CU_ALUC"><path d="M324.47,470.8769 C335.77,479.0969 348.95,487.8969 361.75,494.5969 C426.3,528.4069 452.99,513.8269 515.75,550.8669 C535.59,562.5669 550.8322,575.4904 565.2622,589.4804 " fill="none" id="CU-to-ALUC" style="stroke:#E7E7E7;stroke-width:1.0;"/><polygon fill="#E7E7E7" points="569.57,593.6569,565.8926,584.5203,565.9802,590.1765,560.324,590.2641,569.57,593.6569" style="stroke:#E7E7E7;stroke-width:1.0;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="140" x="498.75" y="523.9338">"Determine Operation</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="59" x="539.25" y="539.0666">(ALUOp)"</text></g><!--link ALUC to ALU--><g id="link_ALUC_ALU"><path d="M576.57,644.1769 C556.84,673.8369 527.0028,718.681 507.2628,748.361 " fill="none" id="ALUC-to-ALU" style="stroke:#E7E7E7;stroke-width:1.0;"/><polygon fill="#E7E7E7" points="503.94,753.3569,512.2548,748.0782,506.709,749.1936,505.5935,743.6478,503.94,753.3569" style="stroke:#E7E7E7;stroke-width:1.0;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="153" x="556.75" y="686.9338">"Execute ALU Operation</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="91" x="587.75" y="702.0666">(ALU Control)"</text></g><!--link ALU to DM--><g id="link_ALU_DM"><path d="M497.2,804.1869 C510.38,838.3369 531.9711,894.2987 545.1411,928.4487 " fill="none" id="ALU-to-DM" style="stroke:#E7E7E7;stroke-width:1.0;"/><polygon fill="#E7E7E7" points="547.3,934.0469,547.7937,924.2104,545.5009,929.3818,540.3295,927.089,547.3,934.0469" style="stroke:#E7E7E7;stroke-width:1.0;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="117" x="526.75" y="864.5938">"Address / Data to</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="92" x="539.25" y="879.7266">Data Memory"</text></g><!--reverse link PC to ALU--><g id="link_PC_ALU"><path d="M97.6842,148.7218 C89.6642,185.8818 81.75,232.7469 81.75,279.5969 C81.75,279.5969 81.75,279.5969 81.75,619.8669 C81.75,701.9169 373.47,758.2669 462.35,773.5369 " fill="none" id="PC-backto-ALU" style="stroke:#E7E7E7;stroke-width:1.0;"/><polygon fill="#E7E7E7" points="98.95,142.8569,93.1413,150.8105,97.8952,147.7443,100.9613,152.4982,98.95,142.8569" style="stroke:#E7E7E7;stroke-width:1.0;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="87" x="101.25" y="442.6638">"Zero Flag for</text><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="124" x="82.75" y="457.7966">Branch Operations"</text></g><!--link DM to UR--><g id="link_DM_UR"><path d="M592.91,984.9669 C633.49,1012.3869 693.9583,1053.2579 734.5583,1080.6879 " fill="none" id="DM-to-UR" style="stroke:#E7E7E7;stroke-width:1.0;"/><polygon fill="#E7E7E7" points="739.53,1084.0469,734.3118,1075.694,735.3869,1081.2478,729.8332,1082.3229,739.53,1084.0469" style="stroke:#E7E7E7;stroke-width:1.0;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="139" x="659.75" y="1029.5938">"Data to Register File"</text></g><!--reverse link RF to UR--><g id="link_RF_UR"><path d="M466.8857,474.3814 C478.4857,482.8014 487.31,488.1969 500.75,494.5969 C678.68,579.3969 926.75,420.7669 926.75,617.8669 C926.75,617.8669 926.75,617.8669 926.75,960.5269 C926.75,1017.4269 871.39,1059.6769 827.72,1084.1669 " fill="none" id="RF-backto-UR" style="stroke:#E7E7E7;stroke-width:1.0;"/><polygon fill="#E7E7E7" points="462.03,470.8569,466.9638,479.3808,466.0764,473.794,471.6632,472.9066,462.03,470.8569" style="stroke:#E7E7E7;stroke-width:1.0;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="112" x="927.75" y="783.2638">"Write Back Data"</text></g><!--link CU to GMN29--><g id="link_CU_GMN29"><path d="M308.71,420.2369 C323.46,397.9769 348.27,367.0969 379.25,353.5969 C421.22,335.3069 438.2,341.1269 482.25,353.5969 C521.25,364.6369 560.08,389.0369 588.39,409.9369 " fill="none" id="CU-GMN29" style="stroke:#E7E7E7;stroke-width:1.0;stroke-dasharray:7.0,7.0;"/></g><!--SRC=[TLHTQzim57tthxZafHiuwtiV1ecTG4hpCNkcOmI6QjyaeexaIJ9f6VllkrUAKoMmW1rBvvpxBJdfMeJbObF2nkWQhTK69gO-I8Urwmt2IRe3JAp5uqlx3WjbdUbh9xMoIN87EUwaGd07XAEG2bvQNR_Qn3hX44PaSc_44JBTAuTc1CB29eC_2T3lpCbwOr0vsZ_3lyuxCMc5Rp63bydVP70J1GLpTFN1ynRpQqSnQub7RTu3RHbPoh7M3TvdMZcZMu_dD_4Mk9UMae6vRD4pYlbLFa4BbPBEmraLEPYzOTrp21wQ_RYsFNcg8FPDw-m67_OZco4PcDJSFeylPyjhmxbm8auwZvD-DjHic8hwrMFFqsjjrJNyF-GTF5G56xZZQ1KDIk3QC2p267sou3JOWpv1mxvthJubrFhn-2jL71vWv1iLpzDMVIB2f6aCfV5vb12DsSMSsIMgveQytcJKgtHGOAJ9AjOCdIZbNedMNYJ48wFCute_dAkpey5VTsY4dsqY5oYQIzR071AIvN6ZJog8Cwz6mezy2YvoKXEwxaZWMP6lC03ebpVyeVL1vKMvBzKvGxZtKL1XjofkQ63t7V4tFgAVQ3JCMx7dfBPgQeIYKdyaDqhoKAUgkAHFtRgUx8J0O3Hqu6DAV1GZxZu51afpuqbUjyB8tRk_2oWB1Bq35EJOtma9yy38_S4nG8S2uAP1rD-wxHjy86ZCqUJMfV3O7xiKGWuUeAovDIb_E4sqb8jPcdgG-KWzVFwQAanuVZY4v2OGFae0PTzrsZWB-bAa4CKaprD-BL8egwb_LG5OCR1YO5tmi_3RArwKJz_9wUmRlLOpl_tqJBlqFFutZWqVz19_ztJpIT7ILTlxSsTfcugxywU5IwluxWEGqMqcmdnykHZ_1m00]--></g></svg>

### Execution diagram for each instruction:

<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" contentStyleType="text/css" height="215.2875px" preserveAspectRatio="none" style="width:350px;height:215px;background:#1B1B1B;" version="1.1" viewBox="0 0 350 215" width="350.0522px" zoomAndPan="magnify"><defs/><g><rect fill="#1B1B1B" height="215.2875" style="stroke:none;stroke-width:0.12000418300295039;" width="350.0522" x="0" y="0"/><!--cluster ProgramCounter--><g id="cluster_ProgramCounter"><path d="M66.6101,17.2806 L333.3794,17.2806 A1.5001,1.5001 0 0 1 334.8795,18.7807 L334.8795,19.8363 L65.1101,19.8363 L65.1101,18.7807 A1.5001,1.5001 0 0 1 66.6101,17.2806 " fill="#313139" style="stroke:#313139;stroke-width:0.12000418300295039;"/><rect fill="none" height="197.3937" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="269.7694" x="65.1101" y="17.2806"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="65.1101" x2="334.8795" y1="19.8363" y2="19.8363"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="13.6805" x="193.1545" y="19.3201">ProgramCounter</text></g><!--cluster Decode--><g id="cluster_Decode"><path d="M140.8927,24.3608 L315.7388,24.3608 A1.5001,1.5001 0 0 1 317.2389,25.8609 L317.2389,26.9166 L139.3927,26.9166 L139.3927,25.8609 A1.5001,1.5001 0 0 1 140.8927,24.3608 " fill="#313139" style="stroke:#313139;stroke-width:0.12000418300295039;"/><rect fill="none" height="185.5133" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="177.8462" x="139.3927" y="24.3608"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="139.3927" x2="317.2389" y1="26.9166" y2="26.9166"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="6.6002" x="225.0156" y="26.4003">Decode</text></g><!--cluster Execution--><g id="cluster_Execution"><path d="M184.0942,46.6816 L295.3381,46.6816 A1.5001,1.5001 0 0 1 296.8381,48.1817 L296.8381,49.2373 L182.5942,49.2373 L182.5942,48.1817 A1.5001,1.5001 0 0 1 184.0942,46.6816 " fill="#313139" style="stroke:#313139;stroke-width:0.12000418300295039;"/><rect fill="none" height="158.3923" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="114.244" x="182.5942" y="46.6816"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="182.5942" x2="296.8381" y1="49.2373" y2="49.2373"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="8.1603" x="235.636" y="48.7211">Execution</text></g><!--cluster MemoryStage--><g id="cluster_MemoryStage"><path d="M222.8556,125.1152 L253.2166,125.1152 A1.5001,1.5001 0 0 1 254.7167,126.6152 L254.7167,127.6709 L221.3555,127.6709 L221.3555,126.6152 A1.5001,1.5001 0 0 1 222.8556,125.1152 " fill="#313139" style="stroke:#313139;stroke-width:0.12000418300295039;"/><rect fill="none" height="54.6379" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="33.3612" x="221.3555" y="125.1152"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="221.3555" x2="254.7167" y1="127.6709" y2="127.6709"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="11.4004" x="232.3359" y="127.1546">MemoryStage</text></g><!--cluster WriteBack--><g id="cluster_WriteBack"><path d="M191.4145,187.5533 L198.8547,187.5533 A1.5001,1.5001 0 0 1 200.3548,189.0534 L200.3548,190.1091 L189.9144,190.1091 L189.9144,189.0534 A1.5001,1.5001 0 0 1 191.4145,187.5533 " fill="#313139" style="stroke:#313139;stroke-width:0.12000418300295039;"/><rect fill="none" height="12.7204" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="10.4404" x="189.9144" y="187.5533"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="189.9144" x2="200.3548" y1="190.1091" y2="190.1091"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="8.2803" x="190.9945" y="189.5928">WriteBack</text></g><!--cluster NextPC--><g id="cluster_NextPC"><path d="M86.6508,83.4377 L107.4115,83.4377 A1.5001,1.5001 0 0 1 108.9116,84.9378 L108.9116,85.9934 L85.1508,85.9934 L85.1508,84.9378 A1.5001,1.5001 0 0 1 86.6508,83.4377 " fill="#313139" style="stroke:#313139;stroke-width:0.12000418300295039;"/><rect fill="none" height="83.8769" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="23.7608" x="85.1508" y="83.4377"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="85.1508" x2="108.9116" y1="85.9934" y2="85.9934"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="6.0002" x="94.0311" y="85.4772">NextPC</text></g><!--cluster ControlUnit--><g id="cluster_ControlUnit"><path d="M6.008,0.84 L24.1286,0.84 A1.5001,1.5001 0 0 1 25.6287,2.3401 L25.6287,3.3957 L4.508,3.3957 L4.508,2.3401 A1.5001,1.5001 0 0 1 6.008,0.84 " fill="#313139" style="stroke:#313139;stroke-width:0.12000418300295039;"/><rect fill="none" height="38.0413" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="21.1207" x="4.508" y="0.84"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="4.508" x2="25.6287" y1="3.3957" y2="3.3957"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="9.2403" x="10.4482" y="2.8795">ControlUnit</text></g><!--cluster IF--><g id="cluster_IF"><path d="M30.9689,20.1607 L59.7699,20.1607 A1.5001,1.5001 0 0 1 61.2699,21.6608 L61.2699,22.7164 L29.4688,22.7164 L29.4688,21.6608 A1.5001,1.5001 0 0 1 30.9689,20.1607 " fill="#313139" style="stroke:#313139;stroke-width:0.12000418300295039;"/><rect fill="none" height="18.8407" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="31.8011" x="29.4688" y="20.1607"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="29.4688" x2="61.2699" y1="22.7164" y2="22.7164"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="12.9605" x="38.8892" y="22.2002">Instruction Flow</text></g><!--cluster Rtype--><g id="cluster_Rtype"><path d="M43.2093,25.3209 L47.5295,25.3209 A1.5001,1.5001 0 0 1 49.0295,26.8209 L49.0295,27.8766 L41.7093,27.8766 L41.7093,26.8209 A1.5001,1.5001 0 0 1 43.2093,25.3209 " fill="#313139" style="stroke:#313139;stroke-width:0.12000418300295039;"/><rect fill="none" height="10.8004" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="7.3203" x="41.7093" y="25.3209"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="41.7093" x2="49.0295" y1="27.8766" y2="27.8766"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="5.4002" x="42.6693" y="27.3604">R-type</text></g><!--cluster Itype--><g id="cluster_Itype"><path d="M53.4097,25.3209 L56.8898,25.3209 A1.5001,1.5001 0 0 1 58.3898,26.8209 L58.3898,27.8766 L51.9096,27.8766 L51.9096,26.8209 A1.5001,1.5001 0 0 1 53.4097,25.3209 " fill="#313139" style="stroke:#313139;stroke-width:0.12000418300295039;"/><rect fill="none" height="10.8004" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="6.4802" x="51.9096" y="25.3209"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="51.9096" x2="58.3898" y1="27.8766" y2="27.8766"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="4.5602" x="52.8696" y="27.3604">I-type</text></g><!--cluster Jtype--><g id="cluster_Jtype"><path d="M33.849,25.3209 L37.3291,25.3209 A1.5001,1.5001 0 0 1 38.8292,26.8209 L38.8292,27.8766 L32.3489,27.8766 L32.3489,26.8209 A1.5001,1.5001 0 0 1 33.849,25.3209 " fill="#313139" style="stroke:#313139;stroke-width:0.12000418300295039;"/><rect fill="none" height="10.8004" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="6.4802" x="32.3489" y="25.3209"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="32.3489" x2="38.8292" y1="27.8766" y2="27.8766"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="4.5602" x="33.309" y="27.3604">J-type</text></g><ellipse cx="125.1122" cy="55.3219" fill="#222222" rx="1.2" ry="1.2" style="stroke:#222222;stroke-width:0.12000418300295039;"/><g id="ProgramCounter.Fetch"><rect fill="#313139" height="6.0002" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="7.0802" x="125.6522" y="130.7554"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="125.6522" x2="132.7324" y1="133.9111" y2="133.9111"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="4.6802" x="126.8522" y="132.9148">Fetch</text></g><ellipse cx="307.0385" cy="33.0012" fill="#222222" rx="1.2" ry="1.2" style="stroke:#222222;stroke-width:0.12000418300295039;"/><g id="ProgramCounter.Decode.ReadRegisters"><rect fill="#313139" height="6.0002" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="14.6405" x="299.7182" y="52.3218"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="299.7182" x2="314.3588" y1="55.4776" y2="55.4776"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="12.2404" x="300.9183" y="54.4813">ReadRegisters</text></g><ellipse cx="254.5967" cy="55.3219" fill="#222222" rx="1.2" ry="1.2" style="stroke:#222222;stroke-width:0.12000418300295039;"/><path d="M242.2662,67.5624 L266.9271,67.5624 A1.5001,1.5001 0 0 1 268.4272,69.0624 L268.4272,70.7181 L240.7662,70.7181 L240.7662,69.0624 A1.5001,1.5001 0 0 1 242.2662,67.5624 " fill="#313139" style="stroke:#313139;stroke-width:0.12000418300295039;"/><rect fill="none" height="49.0333" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="27.661" x="240.7662" y="67.5624"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="240.7662" x2="268.4272" y1="70.7181" y2="70.7181"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="3.1201" x="253.0366" y="69.7218">ALU</text><path d="M243.7063,72.1581 L262.1869,72.1581 A1.5001,1.5001 0 0 1 263.687,73.6582 L263.687,75.3139 L242.2062,75.3139 L242.2062,73.6582 A1.5001,1.5001 0 0 1 243.7063,72.1581 " fill="#313139" style="stroke:#313139;stroke-width:0.12000418300295039;"/><rect fill="none" height="30.8767" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="21.4807" x="242.2062" y="72.1581"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="242.2062" x2="263.687" y1="75.3139" y2="75.3139"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="6.0002" x="249.9465" y="74.3176">Control</text><ellipse cx="248.6865" cy="77.834" fill="#222222" rx="1.2" ry="1.2" style="stroke:#222222;stroke-width:0.12000418300295039;"/><g id="ProgramCounter.Decode.Execution.ALU.Control.Compute"><rect fill="#313139" height="6.0002" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="10.0804" x="243.6463" y="83.4742"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="243.6463" x2="253.7266" y1="86.6299" y2="86.6299"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="7.6803" x="244.8463" y="85.6336">Compute</text></g><g id="ProgramCounter.Decode.Execution.ALU.Control.Result"><rect fill="#313139" height="6.0002" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="7.6803" x="244.8463" y="95.8346"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="244.8463" x2="252.5266" y1="98.9903" y2="98.9903"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="5.2802" x="246.0464" y="97.9941">Result</text></g><!--link *start*Control to Compute--><g id="link_*start*Control_Compute"><path d="M248.6865,79.0868 C248.6865,80.198 248.6865,81.2169 248.6865,82.7157 " fill="none" id="*start*Control-to-Compute" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="248.6865,83.4358,249.1665,82.3557,248.6865,82.8357,248.2065,82.3557,248.6865,83.4358" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/></g><!--link Compute to Result--><g id="link_Compute_Result"><path d="M248.6865,89.5284 C248.6865,91.434 248.6865,93.1873 248.6865,95.0882 " fill="none" id="Compute-to-Result" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="248.6865,95.8082,249.1665,94.7282,248.6865,95.2082,248.2065,94.7282,248.6865,95.8082" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="13.6805" x="248.8065" y="93.2025">SetControlSignals</text></g><g id="ProgramCounter.Decode.Execution.ALU.UpdateFlags"><rect fill="#313139" height="6.0002" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="12.7204" x="246.5864" y="109.3954"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="246.5864" x2="259.3068" y1="112.5512" y2="112.5512"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="10.3204" x="247.7864" y="111.5549">UpdateFlags</text></g><!--link Control to UpdateFlags--><g id="link_Control_UpdateFlags"><path d="M252.9466,103.0604 C252.9466,105.4653 252.9466,106.9822 252.9466,108.6502 " fill="none" id="Control-to-UpdateFlags" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="252.9466,109.3702,253.4266,108.2902,252.9466,108.7702,252.4666,108.2902,252.9466,109.3702" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="14.1605" x="253.0666" y="106.7634">ComputeOutcome</text></g><ellipse cx="238.5161" cy="133.7555" fill="#222222" rx="1.2" ry="1.2" style="stroke:#222222;stroke-width:0.12000418300295039;"/><path d="M226.7257,145.9959 L250.3065,145.9959 A1.5001,1.5001 0 0 1 251.8066,147.4959 L251.8066,149.1516 L225.2257,149.1516 L225.2257,147.4959 A1.5001,1.5001 0 0 1 226.7257,145.9959 " fill="#313139" style="stroke:#313139;stroke-width:0.12000418300295039;"/><rect fill="none" height="30.8767" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="26.5809" x="225.2257" y="145.9959"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="225.2257" x2="251.8066" y1="149.1516" y2="149.1516"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="10.4404" x="233.2959" y="148.1554">DataMemory</text><ellipse cx="234.166" cy="151.6717" fill="#222222" rx="1.2" ry="1.2" style="stroke:#222222;stroke-width:0.12000418300295039;"/><g id="ProgramCounter.Decode.Execution.MemoryStage.DataMemory.AccessMemory"><rect fill="#313139" height="6.0002" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="15.0005" x="226.6657" y="157.3119"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="226.6657" x2="241.6662" y1="160.4676" y2="160.4676"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="12.6004" x="227.8657" y="159.4714">AccessMemory</text></g><g id="ProgramCounter.Decode.Execution.MemoryStage.DataMemory.Return"><rect fill="#313139" height="6.0002" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="8.0403" x="230.1458" y="169.6723"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="230.1458" x2="238.1861" y1="172.8281" y2="172.8281"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="5.6402" x="231.3459" y="171.8318">Return</text></g><!--link *start*DataMemory to AccessMemory--><g id="link_*start*DataMemory_AccessMemory"><path d="M234.166,152.9246 C234.166,154.0358 234.166,155.0546 234.166,156.5535 " fill="none" id="*start*DataMemory-to-AccessMemory" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="234.166,157.2735,234.646,156.1935,234.166,156.6735,233.6859,156.1935,234.166,157.2735" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/></g><!--link AccessMemory to Return--><g id="link_AccessMemory_Return"><path d="M234.166,163.3661 C234.166,165.2718 234.166,167.025 234.166,168.9259 " fill="none" id="AccessMemory-to-Return" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="234.166,169.6459,234.646,168.5659,234.166,169.0459,233.6859,168.5659,234.166,169.6459" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="16.3206" x="234.286" y="167.0403">MemRead, MemWrite</text></g><ellipse cx="193.9946" cy="196.1936" fill="#222222" rx="1.2" ry="1.2" style="stroke:#222222;stroke-width:0.12000418300295039;"/><ellipse cx="96.5512" cy="92.078" fill="#222222" rx="1.2" ry="1.2" style="stroke:#222222;stroke-width:0.12000418300295039;"/><g id="ProgramCounter.NextPC.EvaluateBranch"><rect fill="#313139" height="6.0002" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="15.2405" x="88.9309" y="130.7554"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="88.9309" x2="104.1714" y1="133.9111" y2="133.9111"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="12.8404" x="90.1309" y="132.9148">EvaluateBranch</text></g><g id="ProgramCounter.NextPC.UpdatePC"><rect fill="#313139" height="6.0002" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="10.6804" x="87.9709" y="158.4343"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="87.9709" x2="98.6512" y1="161.5901" y2="161.5901"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="8.2803" x="89.1709" y="160.5938">UpdatePC</text></g><ellipse cx="14.5883" cy="9.4803" fill="#222222" rx="1.2" ry="1.2" style="stroke:#222222;stroke-width:0.12000418300295039;"/><g id="ControlUnit.ControlSignals"><rect fill="#313139" height="6.0002" rx="1.5001" ry="1.5001" style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" width="14.2805" x="7.4481" y="30.001"/><line style="stroke:#E7E7E7;stroke-width:0.060002091501475195;" x1="7.4481" x2="21.7286" y1="33.1568" y2="33.1568"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.6801" lengthAdjust="spacing" textLength="11.8804" x="8.6481" y="32.1605">ControlSignals</text></g><ellipse cx="45.9094" cy="33.0012" fill="#222222" rx="1.2" ry="1.2" style="stroke:#222222;stroke-width:0.12000418300295039;"/><ellipse cx="55.2697" cy="33.0012" fill="#222222" rx="1.2" ry="1.2" style="stroke:#222222;stroke-width:0.12000418300295039;"/><ellipse cx="35.709" cy="33.0012" fill="#222222" rx="1.2" ry="1.2" style="stroke:#222222;stroke-width:0.12000418300295039;"/><!--link *start*ProgramCounter to Fetch--><g id="link_*start*ProgramCounter_Fetch"><path d="M125.363,56.5412 C126.767,62.7586 133.6577,94.1337 135.7925,120.195 C135.8669,121.0986 136.0277,121.3602 135.7925,122.2351 C134.9501,125.372 133.4276,127.9493 131.8688,130.1454 " fill="none" id="*start*ProgramCounter-to-Fetch" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="131.452,130.7326,132.4686,130.1297,131.7993,130.2433,131.6857,129.574,131.452,130.7326" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/></g><!--link Fetch to Decode--><g id="link_Fetch_Decode"><path d="M131.8036,130.7326 C133.5845,128.5617 135.8057,125.4272 136.8726,122.2351 C138.0408,118.7384 138.7864,113.5846 139.3332,106.7314 " fill="none" id="Fetch-to-Decode" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="139.3904,106.0137,138.826,107.0521,139.3427,106.6118,139.783,107.1285,139.3904,106.0137" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="9.8403" x="140.5927" y="92.6261">IncrementPC</text></g><!--link *start*Decode to ReadRegisters--><g id="link_*start*Decode_ReadRegisters"><path d="M307.0385,34.2456 C307.0385,37.5589 307.0385,46.6348 307.0385,51.5706 " fill="none" id="*start*Decode-to-ReadRegisters" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="307.0385,52.2906,307.5185,51.2106,307.0385,51.6906,306.5585,51.2106,307.0385,52.2906" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/></g><!--link ReadRegisters to Execution--><g id="link_ReadRegisters_Execution"><path d="M304.6612,58.352 C302.8492,60.3333 300.1647,62.8006 297.1982,63.9622 C297.1083,63.9974 297.6952,63.8628 297.5596,63.8954 " fill="none" id="ReadRegisters-to-Execution" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="296.8595,64.0639,298.0219,64.2779,297.4429,63.9235,297.7973,63.3445,296.8595,64.0639" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="11.4004" x="300.6783" y="63.4902">RegisterValues</text></g><!--link *start*Execution to ALU--><g id="link_*start*Execution_ALU"><path d="M254.5967,56.5748 C254.5967,58.5008 254.5967,61.9582 254.5967,66.7919 " fill="none" id="*start*Execution-to-ALU" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="254.5967,67.512,255.0767,66.4319,254.5967,66.9119,254.1167,66.4319,254.5967,67.512" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/></g><!--link ALU to MemoryStage--><g id="link_ALU_MemoryStage"><path d="M247.9616,116.6417 C246.5396,118.8005 244.8127,120.7326 242.7163,122.2351 C240.9582,123.4951 224.8368,121.6986 223.2756,123.1951 C223.0686,123.3936 222.898,123.7012 222.758,124.0883 C222.688,124.2818 222.6256,124.4952 222.5702,124.7247 C222.5424,124.8394 222.6571,124.252 222.6327,124.3743 " fill="none" id="ALU-to-MemoryStage" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="222.4921,125.0805,223.1738,124.1149,222.6093,124.492,222.2322,123.9275,222.4921,125.0805" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="7.8003" x="244.7563" y="121.7631">ALUResult</text></g><!--link ALU to WriteBack--><g id="link_ALU_WriteBack"><path d="M257.7732,116.6537 C260.1901,139.7773 261.8773,172.2924 253.7566,181.6731 C248.0348,188.283 243.0223,183.8836 234.316,184.6732 C232.4091,184.846 201.2404,184.2916 199.8748,185.6333 C199.4669,186.0338 199.1521,186.4938 198.9137,186.9926 C198.8541,187.1174 198.7993,187.2445 198.749,187.3737 C198.7364,187.406 198.7241,187.4385 198.7121,187.471 C198.7061,187.4873 198.9435,186.826 198.9377,186.8423 " fill="none" id="ALU-to-WriteBack" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="198.6943,187.52,199.5111,186.6658,198.8971,186.9553,198.6076,186.3413,198.6943,187.52" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="31.9211" x="259.6369" y="141.9238">RTypeOperation / RegDst, ALUOp, ALUSrc</text></g><!--link *start*MemoryStage to DataMemory--><g id="link_*start*MemoryStage_DataMemory"><path d="M238.5161,134.9855 C238.5161,136.9656 238.5161,140.6161 238.5161,145.2375 " fill="none" id="*start*MemoryStage-to-DataMemory" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="238.5161,145.9575,238.9961,144.8775,238.5161,145.3575,238.0361,144.8775,238.5161,145.9575" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/></g><!--link DataMemory to WriteBack--><g id="link_DataMemory_WriteBack"><path d="M235.0888,176.921 C233.7039,179.9535 231.7611,182.7796 229.0358,184.6732 C226.3729,186.5237 202.1824,183.3556 199.8748,185.6333 C199.468,186.0348 199.154,186.4957 198.9162,186.9951 C198.8567,187.1199 198.8021,187.2472 198.7519,187.3765 C198.7393,187.4089 198.727,187.4413 198.7151,187.4739 C198.7091,187.4902 198.9458,186.8287 198.94,186.845 " fill="none" id="DataMemory-to-WriteBack" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="198.6973,187.5229,199.5132,186.6679,198.8995,186.958,198.6094,186.3443,198.6973,187.5229" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="2.1601" x="231.0759" y="184.2012">LW</text></g><!--link DataMemory to ProgramCounter--><g id="link_DataMemory_ProgramCounter"><path d="M247.0916,176.9018 C248.6325,178.7198 250.3761,180.3831 252.3166,181.6731 C265.3899,190.3626 320.4418,195.9127 321.3118,196.0003 " fill="none" id="DataMemory-to-ProgramCounter" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="322.0282,196.0724,321.0017,195.4866,321.4312,196.0123,320.9055,196.4418,322.0282,196.0724" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="11.5204" x="257.4768" y="184.2012">SW / MemWrite</text></g><!--link *start*WriteBack to ProgramCounter--><g id="link_*start*WriteBack_ProgramCounter"><path d="M193.8842,194.9408 C193.7618,192.8395 193.7894,188.5482 195.6746,185.6333 C196.7307,184 197.4711,183.79 199.3347,183.2332 C202.2088,182.3752 223.3428,183.0316 226.3357,183.2332 C268.1571,186.0521 318.8582,195.5919 321.2451,196.0431 " fill="none" id="*start*WriteBack-to-ProgramCounter" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="321.9526,196.1768,320.9805,195.5046,321.363,196.0654,320.8022,196.4479,321.9526,196.1768" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="26.7609" x="199.4548" y="184.2012">ResultToReg / MemtoReg, RegWrite</text></g><!--link *start*ProgramCounter to NextPC--><g id="link_*start*ProgramCounter_NextPC"><path d="M123.9817,55.8463 C120.8208,57.0476 111.8937,60.9297 108.4316,67.5624 C107.1967,69.9282 107.0611,75.875 107.2419,81.3048 C107.2645,81.9835 107.292,82.6541 107.323,83.3087 C107.3249,83.3496 107.2923,82.6713 107.2942,82.712 " fill="none" id="*start*ProgramCounter-to-NextPC" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="107.3288,83.4312,107.7564,82.3294,107.3,82.8319,106.7975,82.3755,107.3288,83.4312" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/></g><!--link NextPC to Fetch--><g id="link_NextPC_Fetch"><path d="M108.9147,118.0022 C108.927,118.0327 108.9394,118.0633 108.9519,118.0938 C109.1516,118.5817 109.3768,119.0579 109.6245,119.5225 C110.1199,120.4515 110.7057,121.3339 111.3594,122.1698 C112.6668,123.8417 114.2459,125.3276 115.9173,126.6298 C119.2602,129.234 122.312,130.8161 124.9593,131.9651 " fill="none" id="NextPC-to-Fetch" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="125.6198,132.2518,124.8202,131.3815,125.0694,132.0129,124.4379,132.2621,125.6198,132.2518" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="23.2808" x="111.4317" y="121.7631">UpdatePC / Jump, Branch, Bne</text></g><!--link *start*ControlUnit to ControlSignals--><g id="link_*start*ControlUnit_ControlSignals"><path d="M14.5883,10.7224 C14.5883,14.1833 14.5883,24.0428 14.5883,29.2306 " fill="none" id="*start*ControlUnit-to-ControlSignals" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="14.5883,29.9506,15.0683,28.8706,14.5883,29.3506,14.1083,28.8706,14.5883,29.9506" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/></g><!--link ControlSignals to Decode--><g id="link_ControlSignals_Decode"><path d="M20.0053,36.0589 C23.4902,37.7893 28.1764,39.8246 32.5889,40.8014 C38.9972,42.2199 55.7377,40.1858 62.11,41.7615 C64.1248,42.2595 64.2904,43.3227 66.3101,43.8015 C67.3043,44.0367 85.3278,43.9212 103.2863,43.9247 C112.2655,43.9264 121.2285,43.9579 128.0385,44.0778 C131.4435,44.1377 134.3102,44.2198 136.3716,44.3313 C137.4023,44.3871 138.2317,44.4502 138.8263,44.5216 C138.975,44.5395 139.109,44.5578 139.2278,44.5767 C139.2575,44.5814 138.5767,44.4639 138.6045,44.4687 " fill="none" id="ControlSignals-to-Decode" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="139.314,44.591,138.3312,43.9345,138.7227,44.489,138.1681,44.8805,139.314,44.591" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="6.6002" x="66.4301" y="43.3295">SetFlags</text></g><!--link ControlSignals to Execution--><g id="link_ControlSignals_Execution"><path d="M20.1385,36.0577 C23.615,37.7533 28.246,39.7502 32.5889,40.8014 C35.499,41.5046 43.4769,40.1954 46.0294,41.7615 C53.3497,46.252 48.6755,53.8183 55.9898,58.322 C84.6816,75.9878 97.9828,61.5669 131.5924,63.9622 C134.5385,64.1716 146.7801,64.0024 158.7946,64.3155 C164.8019,64.472 170.7524,64.7491 175.4558,65.2544 C177.8074,65.507 179.8474,65.8167 181.4267,66.1969 C181.8215,66.2919 181.5,66.1777 181.8349,66.2818 " fill="none" id="ControlSignals-to-Execution" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="182.5225,66.4954,181.6335,65.7166,181.9495,66.3174,181.3487,66.6334,182.5225,66.4954" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="9.8403" x="56.1098" y="55.87">ControlPaths</text></g><!--link ControlSignals to MemoryStage--><g id="link_ControlSignals_MemoryStage"><path d="M15.1883,36.0505 C18.0336,49.0973 31.5065,102.144 66.0701,122.2351 C67.941,123.3223 220.2755,121.6962 221.8355,123.1951 C222.0416,123.3931 222.2043,123.7005 222.331,124.0873 C222.3944,124.2807 222.4488,124.4939 222.4952,124.7233 C222.5184,124.838 222.4273,124.2455 222.4466,124.3678 " fill="none" id="ControlSignals-to-MemoryStage" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="222.5589,125.079,222.8647,123.9374,222.4654,124.4863,221.9164,124.087,222.5589,125.079" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="11.7604" x="23.4686" y="63.4902">MemoryControl</text></g><!--link *start*NextPC to EvaluateBranch--><g id="link_*start*NextPC_EvaluateBranch"><path d="M96.5512,93.3069 C96.5512,98.713 96.5512,121.6674 96.5512,130.0005 " fill="none" id="*start*NextPC-to-EvaluateBranch" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="96.5512,130.7206,97.0312,129.6405,96.5512,130.1205,96.0711,129.6405,96.5512,130.7206" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/></g><!--link EvaluateBranch to UpdatePC--><g id="link_EvaluateBranch_UpdatePC"><path d="M96.2044,136.812 C95.5803,142.0934 94.3615,152.4187 93.7399,157.6845 " fill="none" id="EvaluateBranch-to-UpdatePC" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="93.6555,158.3995,94.2588,157.3832,93.7258,157.8036,93.3054,157.2707,93.6555,158.3995" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="12.6004" x="95.8311" y="141.9238">BranchCondition</text></g><!--link EvaluateBranch to Fetch--><g id="link_EvaluateBranch_Fetch"><path d="M104.2038,133.7555 C110.9493,133.7555 119.7588,133.7555 124.8806,133.7555 " fill="none" id="EvaluateBranch-to-Fetch" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="125.6006,133.7555,124.5205,133.2754,125.0006,133.7555,124.5205,134.2355,125.6006,133.7555" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="13.3205" x="108.2516" y="132.9235">DefaultIncrement</text></g><!--link *start*Rtype to Decode--><g id="link_*start*Rtype_Decode"><path d="M46.3846,34.1532 C47.2486,35.8945 49.2587,39.3614 52.1496,40.8014 C54.8365,42.1395 76.2093,41.1578 79.1506,41.7615 C81.6154,42.2655 81.9611,43.3191 84.4307,43.8015 C85.1868,43.9491 98.7709,43.9206 112.3043,43.9895 C119.0709,44.0239 125.8249,44.0827 130.9562,44.2 C133.5219,44.2586 135.6819,44.3319 137.2351,44.4241 C138.0117,44.4701 138.6365,44.521 139.0845,44.577 C139.1965,44.591 138.5869,44.4888 138.6764,44.5035 " fill="none" id="*start*Rtype-to-Decode" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="139.3869,44.6201,138.3989,43.9715,138.7948,44.5229,138.2434,44.9189,139.3869,44.6201" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/></g><!--link Decode to Execution--><g id="link_Decode_Execution"><path d="M140.3599,55.4443 C140.6779,55.5403 150.9059,58.67 158.8333,61.9222 C160.7978,62.7274 161.1266,63.3274 163.1535,63.9622 C167.7718,65.4089 171.5604,64.477 174.9851,64.0995 C176.6975,63.9107 178.319,63.8605 179.9077,64.3154 C180.7021,64.5429 181.4883,64.8967 182.2737,65.4226 C182.3718,65.4883 181.8872,65.1339 181.9853,65.2051 " fill="none" id="Decode-to-Execution" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="182.5681,65.6279,181.9758,64.6052,182.0824,65.2756,181.412,65.3823,182.5681,65.6279" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="10.4404" x="163.2735" y="63.4902">FunctionCode</text></g><!--link Decode to Execution--><g id="link_Decode_Execution"><path d="M140.3671,55.4419 C140.9611,55.4827 160.0754,56.8148 174.3139,61.9222 C175.5439,62.3632 177.7853,63.2143 179.8885,64.2346 C180.4143,64.4897 180.9315,64.7554 181.4221,65.0279 C181.6674,65.1641 181.906,65.302 182.1357,65.4412 C182.2506,65.5108 182.3633,65.5807 182.4734,65.6508 C182.5009,65.6684 181.9233,65.2955 181.9506,65.313 " fill="none" id="Decode-to-Execution-1" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="182.5555,65.7035,181.9084,64.7145,182.0514,65.3781,181.3878,65.5211,182.5555,65.7035" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="5.8802" x="179.234" y="63.4902">Opcode</text></g><!--link Decode to Execution--><g id="link_Decode_Execution"><path d="M140.3527,55.4587 C140.3623,55.8187 140.5531,61.6017 143.7128,63.9622 C147.3699,66.6929 156.0423,65.9252 164.5794,65.3087 C168.848,65.0004 173.0827,64.73 176.6398,64.9535 C178.4183,65.0653 180.0274,65.3005 181.3867,65.7163 C181.7265,65.8203 182.0507,65.9355 182.358,66.0629 C182.4348,66.0948 181.8532,65.8336 181.9279,65.867 " fill="none" id="Decode-to-Execution-2" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="182.5853,66.1608,181.7951,65.2818,182.0375,65.916,181.4034,66.1583,182.5853,66.1608" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="13.9205" x="143.8328" y="63.4902">DecodeInstruction</text></g><!--link Execution to WriteBack--><g id="link_Execution_WriteBack"><path d="M185.1131,92.2088 C185.0891,92.6252 184.315,106.0597 186.0743,116.5949 C186.3491,118.2425 186.9119,118.5425 187.1543,120.195 C188.2236,127.478 187.3847,129.3993 187.1543,136.7556 C186.4859,158.0803 169.7609,169.0343 184.2742,184.6732 C186.2207,186.7709 194.9546,183.7564 197.1147,185.6333 C197.5558,186.0165 197.923,186.4635 198.2276,186.9528 C198.3037,187.0751 198.376,187.2001 198.4445,187.3274 C198.4788,187.391 198.1897,186.8114 198.2221,186.8761 " fill="none" id="Execution-to-WriteBack" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="198.5445,187.52,198.4901,186.3393,198.2758,186.9834,197.6317,186.7692,198.5445,187.52" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="17.4006" x="186.9143" y="141.9238">Add, Sub, And, Or, Nor</text></g><!--link *start*Itype to Decode--><g id="link_*start*Itype_Decode"><path d="M56.4374,33.4344 C60.3771,34.4988 73.5296,38.1157 84.1907,41.7615 C86.5716,42.5751 87.0024,43.3167 89.4709,43.8015 C90.1579,43.9359 102.5076,43.9317 114.8109,44.016 C120.9625,44.0582 127.1025,44.1225 131.7674,44.2373 C134.0998,44.2947 136.0634,44.3647 137.4753,44.4509 C138.1812,44.494 138.7492,44.5411 139.1564,44.5928 C139.2073,44.5992 139.2557,44.6057 139.3015,44.6123 C139.3244,44.6156 138.6351,44.5093 138.6567,44.5126 " fill="none" id="*start*Itype-to-Decode" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="139.3683,44.6223,138.374,43.9834,138.7753,44.5309,138.2278,44.9322,139.3683,44.6223" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/></g><!--link Execution to MemoryStage--><g id="link_Execution_MemoryStage"><path d="M185.1131,92.2148 C185.0879,92.8928 184.2766,114.6208 186.0743,116.5949 C190.1316,121.0518 207.0858,118.8245 212.9552,120.195 C213.4616,120.3138 221.5223,122.7799 221.8355,123.1951 C222.1739,123.6445 222.4374,124.1382 222.6392,124.6588 C222.6896,124.7889 222.7362,124.9208 222.7791,125.054 C222.7845,125.0707 222.5738,124.4005 222.579,124.4172 " fill="none" id="Execution-to-MemoryStage" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="222.795,125.1041,222.9289,123.9298,222.615,124.5317,222.0131,124.2178,222.795,125.1041" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="17.2806" x="219.4354" y="121.7631">LW, SW, Addi, Andi, Ori</text></g><!--link Execution to MemoryStage--><g id="link_Execution_MemoryStage"><path d="M185.1143,92.2148 C185.0975,92.8856 184.5982,114.37 186.0743,116.5949 C189.33,121.5078 192.3505,120.8358 198.0747,122.2351 C199.3575,122.5495 220.8983,122.2639 221.8355,123.1951 C222.0382,123.3967 222.1982,123.7068 222.3231,124.0956 C222.3856,124.29 222.4392,124.5041 222.485,124.7341 C222.5078,124.8491 222.4181,124.2567 222.4371,124.3792 " fill="none" id="Execution-to-MemoryStage-1" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="222.5478,125.0907,222.8561,123.9497,222.4556,124.4978,221.9075,124.0973,222.5478,125.0907" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="13.6805" x="198.1947" y="121.7631">ExecuteOperation</text></g><!--link MemoryStage to WriteBack--><g id="link_MemoryStage_WriteBack"><path d="M221.3303,137.7786 C221.2952,137.8412 221.2598,137.9027 221.2243,137.9632 C221.1531,138.0842 221.0809,138.2011 221.0078,138.3143 C220.7156,138.767 220.4088,139.1596 220.0935,139.5126 C219.4629,140.2186 218.798,140.766 218.1456,141.3181 C216.8407,142.4225 215.5857,143.546 214.7553,145.9959 C209.6635,161.0132 203.9777,170.0423 214.7553,181.6731 C216.6634,183.7324 225.4465,180.5739 227.3557,182.6332 C227.9713,183.298 227.9857,184.0204 227.3557,184.6732 C225.2329,186.8705 202.0468,183.4852 199.8748,185.6333 C199.4684,186.0351 199.1548,186.4962 198.9172,186.9957 C198.8578,187.1206 198.8032,187.2479 198.7531,187.3773 C198.7405,187.4097 198.7283,187.4422 198.7163,187.4748 C198.7103,187.4911 198.9468,186.8294 198.941,186.8458 " fill="none" id="MemoryStage-to-WriteBack" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="198.6985,187.5237,199.5142,186.6684,198.9006,186.9588,198.6102,186.3452,198.6985,187.5237" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="8.2803" x="214.8753" y="161.9825">MemtoReg</text></g><!--link MemoryStage to WriteBack--><g id="link_MemoryStage_WriteBack"><path d="M221.3368,137.0038 C221.3216,137.0101 221.3061,137.0164 221.2903,137.0229 C221.2269,137.0489 221.1584,137.0764 221.085,137.1053 C220.9382,137.1633 220.7719,137.2271 220.5874,137.2963 C219.8495,137.5734 218.8219,137.9376 217.6014,138.36 C215.1604,139.2049 211.9475,140.2825 208.7362,141.3613 C202.3136,143.519 195.8972,145.6815 195.6746,145.9959 C186.5183,158.9419 184.6378,170.2883 195.6746,181.6731 C198.0603,184.1344 224.1288,180.1719 226.5157,182.6332 C227.1469,183.2848 227.1445,184.0204 226.5157,184.6732 C224.4588,186.8045 201.9796,183.5488 199.8748,185.6333 C199.4686,186.0354 199.155,186.4967 198.9176,186.9964 C198.8582,187.1214 198.8036,187.2487 198.7535,187.3781 C198.7409,187.4105 198.7287,187.443 198.7167,187.4756 C198.7107,187.4919 198.9471,186.8302 198.9413,186.8466 " fill="none" id="MemoryStage-to-WriteBack-1" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="198.699,187.5246,199.5144,186.6691,198.9009,186.9596,198.6104,186.346,198.699,187.5246" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="11.6404" x="195.7946" y="161.9825">AccessMemory</text></g><!--link MemoryStage to ProgramCounter--><g id="link_MemoryStage_ProgramCounter"><path d="M254.9175,139.1807 C255.0331,139.1697 255.1487,139.1587 255.2644,139.1477 C255.7272,139.1035 256.1907,139.0586 256.6548,139.0133 C257.5831,138.9228 258.5135,138.8304 259.4441,138.7379 C274.3338,137.2569 289.2677,135.7151 295.8781,140.3557 C312.1687,151.7933 304.0672,163.9665 313.1587,181.6731 C316.5392,188.2578 321.4521,195.2451 321.6189,195.4803 " fill="none" id="MemoryStage-to-ProgramCounter" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="322.0354,196.0676,321.8022,194.909,321.6883,195.5782,321.0191,195.4643,322.0354,196.0676" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="6.9602" x="313.2787" y="161.9825">Bne, Beq</text></g><!--link *start*Jtype to Decode--><g id="link_*start*Jtype_Decode"><path d="M36.2527,34.104 C37.2727,35.832 39.6548,39.3698 42.7893,40.8014 C45.9562,42.2475 70.6975,41.0702 74.1104,41.7615 C76.5765,42.2595 76.9209,43.3203 79.3906,43.8015 C80.215,43.9617 95.034,43.9092 109.7977,43.9629 C117.1795,43.9898 124.5475,44.0432 130.1454,44.163 C132.9444,44.2229 135.3008,44.2994 136.9952,44.3975 C137.8424,44.4466 138.5241,44.501 139.0128,44.5615 C139.135,44.5766 138.5344,44.4765 138.632,44.4924 " fill="none" id="*start*Jtype-to-Decode" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="139.3427,44.608,138.3538,43.9608,138.7505,44.5117,138.1996,44.9084,139.3427,44.608" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/></g><!--link Decode to NextPC--><g id="link_Decode_NextPC"><path d="M139.389,59.0946 C139.3573,59.1427 139.3258,59.1901 139.2944,59.2369 C139.2316,59.3304 139.1692,59.4214 139.1071,59.51 C138.8586,59.8643 138.6148,60.1794 138.3698,60.4636 C137.8798,61.0319 137.385,61.476 136.8381,61.8604 C135.7442,62.629 134.4419,63.1582 132.5524,63.9622 C127.565,66.0839 112.0101,63.4918 108.4316,67.5624 C107.5501,68.5644 107.4199,74.4899 107.515,80.2496 C107.5269,80.9696 107.5423,81.687 107.5602,82.3918 C107.5647,82.5681 107.5694,82.7435 107.5741,82.918 C107.5765,83.0052 107.5789,83.0922 107.5814,83.179 C107.5826,83.2224 107.5632,82.546 107.5644,82.5892 " fill="none" id="Decode-to-NextPC" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="107.5851,83.3089,108.0339,82.2156,107.5679,82.7092,107.0742,82.2431,107.5851,83.3089" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="0.36" x="136.7526" y="63.4902">J</text></g><!--link ProgramCounter to Decode--><g id="link_ProgramCounter_Decode"><path d="M322.045,196.0568 C322.3288,195.344 331.4927,172.1376 335.2828,143.9458 C337.1779,129.8499 337.7296,114.5076 335.1562,100.1075 C333.8695,92.9074 331.8015,85.9429 328.7295,79.4875 C327.1935,76.2598 325.4065,73.1594 323.3407,70.2204 C322.3077,68.7509 321.2051,67.3218 320.0293,65.9374 C319.4414,65.2451 318.8352,64.5641 318.2103,63.8947 C317.8978,63.56 318.0844,63.7427 317.7625,63.4139 " fill="none" id="ProgramCounter-to-Decode" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="317.2588,62.8994,317.6713,64.007,317.6785,63.3282,318.3573,63.3354,317.2588,62.8994" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="12.2404" x="336.9195" y="134.3035">FetchInstruction</text></g><!--link WriteBack to NextPC--><g id="link_WriteBack_NextPC"><path d="M198.5898,187.5435 C198.5817,187.5274 198.5736,187.5112 198.5654,187.4952 C198.5326,187.4309 198.4989,187.3671 198.4642,187.304 C198.3948,187.1777 198.3217,187.0539 198.2445,186.9327 C197.9358,186.4483 197.5632,186.0078 197.1147,185.6333 C195.9302,184.6444 87.3444,182.5996 86.1108,181.6731 C82.4759,178.9454 60.6471,133.6835 72.7903,120.195 C74.0687,118.775 76.5189,118.1887 79.5569,118.0209 C81.0759,117.9369 82.7417,117.9576 84.4815,118.0309 C84.699,118.0401 84.1985,118.015 84.4181,118.0257 " fill="none" id="WriteBack-to-NextPC" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="85.1373,118.0608,84.0819,117.5287,84.538,118.0315,84.0351,118.4876,85.1373,118.0608" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="12.7204" x="70.1502" y="141.9238">UpdateRegisters</text></g><!--link ControlUnit to ProgramCounter--><g id="link_ControlUnit_ProgramCounter"><path d="M4.4835,16.4064 C4.181,16.7487 3.9034,17.085 3.6489,17.417 C3.1398,18.081 2.7227,18.7274 2.3816,19.3682 C1.6995,20.6498 1.3217,21.909 1.1211,23.2415 C0.72,25.9065 1.0278,28.8646 1.0278,32.8811 C1.0278,32.8811 1.0278,32.8811 1.0278,161.5544 C1.0278,180.9831 12.6703,184.7218 29.127,184.2489 C37.3553,184.0124 46.7871,182.723 56.5689,181.8154 C59.0144,181.5885 61.4817,181.3855 63.9576,181.2288 C64.2671,181.2092 63.8579,181.2323 64.1676,181.2142 " fill="none" id="ControlUnit-to-ProgramCounter" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="64.8864,181.1722,63.7802,180.756,64.2874,181.2072,63.8362,181.7144,64.8864,181.1722" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><text fill="#FFFFFF" font-family="sans-serif" font-size="1.5601" lengthAdjust="spacing" textLength="8.7603" x="1.1478" y="92.6261">ControlFlow</text></g><!--link ControlUnit to Decode--><g id="link_ControlUnit_Decode"><path d="M25.6481,9.7031 C25.6662,9.7051 25.6845,9.707 25.7031,9.7091 C26.2969,9.7736 27.1297,9.8669 28.1581,9.9892 C30.2147,10.2338 33.0533,10.5942 36.326,11.072 C42.8715,12.0277 51.1536,13.4531 58.3898,15.3605 C77.0037,20.2669 91.6634,19.8697 104.5251,22.1196 C110.956,23.2446 116.9374,25.0313 122.7388,28.4737 C125.6395,30.1949 128.4952,32.33 131.3397,35.0032 C132.7619,36.3398 134.1812,37.811 135.602,39.4322 C136.3124,40.2428 137.0231,41.0909 137.7347,41.9785 C138.0905,42.4223 138.4465,42.876 138.8028,43.3397 C138.981,43.5716 138.7263,43.2307 138.9046,43.4676 " fill="none" id="ControlUnit-to-Decode" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="139.3375,44.043,139.0717,42.8913,138.9768,43.5635,138.3046,43.4686,139.3375,44.043" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/></g><!--link ControlUnit to Execution--><g id="link_ControlUnit_Execution"><path d="M25.6973,9.6005 C26.2993,9.6007 27.1592,9.601 28.2598,9.6017 C30.4611,9.6031 33.6253,9.6059 37.6161,9.6115 C45.5975,9.6227 56.8846,9.6451 70.3845,9.69 C97.3842,9.7798 133.2349,9.9596 169.1928,10.3195 C241.1088,11.0392 313.4539,12.4792 316.2788,15.3605 C323.8403,23.072 323.8091,56.2196 316.2788,63.9622 C315.0174,65.2589 312.1978,66.1286 308.209,66.6779 C306.2146,66.9525 303.928,67.1469 301.3977,67.2746 C300.1325,67.3384 298.8065,67.3855 297.4256,67.4175 C297.253,67.4216 297.7994,67.4107 297.6251,67.4142 " fill="none" id="ControlUnit-to-Execution" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="296.9052,67.4289,297.9948,67.8869,297.5051,67.4167,297.9753,66.927,296.9052,67.4289" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/></g><!--link ControlUnit to MemoryStage--><g id="link_ControlUnit_MemoryStage"><path d="M25.6743,9.597 C25.7405,9.5968 25.8099,9.5966 25.8825,9.5964 C26.0277,9.596 26.1856,9.5955 26.356,9.595 C26.6968,9.594 27.0876,9.5929 27.527,9.5917 C29.2846,9.587 31.8193,9.5809 35.0376,9.5753 C41.4741,9.5641 50.6449,9.5546 61.8007,9.5604 C84.1124,9.5721 114.3644,9.6452 146.5644,9.8892 C210.9644,10.3774 283.1559,11.5492 315.1988,14.2805 C318.3177,14.5457 319.7061,13.4153 322.159,15.3605 C328.7401,20.5783 329.2393,24.4821 329.2393,32.8811 C329.2393,32.8811 329.2393,32.8811 329.2393,92.198 C329.2393,112.1499 314.4572,114.9628 295.8781,122.2351 C294,122.9707 224.7564,121.8258 223.2756,123.1951 C223.0651,123.3898 222.8919,123.6947 222.75,124.0796 C222.679,124.2721 222.6159,124.4846 222.5598,124.7134 C222.5318,124.8278 222.5055,124.9463 222.4809,125.0683 C222.4778,125.0836 222.6137,124.3924 222.6107,124.4078 " fill="none" id="ControlUnit-to-MemoryStage" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/><polygon fill="#E7E7E7" points="222.4718,125.1143,223.1512,124.1471,222.5876,124.5255,222.2092,123.9619,222.4718,125.1143" style="stroke:#E7E7E7;stroke-width:0.12000418300295039;"/></g><!--SRC=[fLLRQzim57xthn1z70aTZBtaOT0c3IHaJKYQvM7iGPFF4ZDRyYHvRHdzxpkwE9BiE31MA9REvJlVkIcAqHB8Xu_loNEHwrEMAKqra8qKHqchgMYu1ad-P0J_lhxxHiRZJsGEcfsin9wiR0PCv40cPC6PX0gutaopjnREQrEOBT1y2yT2OGHbDOd4sZoy06jq8JWYjvelj6n01V1Wa-BVhVRsZbzx_moLaAyxJO-69qgte9fI9pO7MMYuf-odYVVqMiEw1aaj-AqXC5DwP8pNjVti90iyOloKoOngwhHM7AwzcAl39OjEDoPaTq0wQ61T0uE0bCRl-RlCdmHcv82qEOvCXXt8guFm22-cpKRaZc4yCCY-pX41XRTasLHOi7j9EJlXbqS1JEKTghjF1TTIb5uMHvkAgcwGMoltTpzB9Y5J6T0UOLSSEItTOBrbpi516mT7RbxIeq8l3xLkD1DLH2xgGsUs60Ebefx60iz8DzACBShCN8ykzCiJslD2T_0lv92AqgN3h6qgGuRn6ddrXkhJe7swAkxcpG9xt_AK-CDlt4xKkbvRLIgAge_E4pyK29uNXk2GHpjKC_X1iTFdLoRGkLbmfMN3R9hpKZpV4Ah8OfvCryrsh76hhMfhJXVcp5NrBFP5xfPntd0RQXhR1eFkOj_bE06xvZi-6nnFQpaYZq96mzac4VWj_elVkcR3pDB-hWv83V-HOs7v5OPWSVQDhRjvjM_7e77lxS7jnoS0VlLpNuRSb_-Skv_62LbwO1oCJknaPUn0HIEJ3TJHYMF3QwLqkl2haLshNVA814MIZTkKy3CPFnaNo-iDp0BqZ7trkk9pGZrDnFul]--></g></svg>

### ADD (R-type instruction)

Name (format, op, function): `add (R,0,32)`

Syntax: `add rd,rs,rt`

Operation: `reg(rd) := reg(rs) + reg(rt);`

#### Instruction Overview:

The following is an overview of the operation of the `add` instruction in a MIPS processor, focusing on the key stages of the processor pipeline.

- **IF:** The instruction is fetched from memory using the program counter (PC).
- **ID:** The instruction bits are decoded to determine it is an ADD operation. Registers specified by the source register fields (`rs` and `rt`) are read.
- **EX:** The ALU performs the addition of the two register values.
- **MEM:** No action (not used by ADD).
- **WB:** The result from the ALU is written back to the destination register (`rd`).

#### Operation Breakdown:

The following provides a detailed breakdown of the operation of the `add` instruction in a MIPS processor, focusing on the key stages of the processor pipeline.

##### Stages of the `add` Instruction:

1. **Instruction Fetch (IF):**
   - The instruction is fetched from memory using the Program Counter (PC).
   - This stage corresponds to reading the instruction code from the instruction memory. The address comes from the PC which points to the location of the next instruction to execute.
   ```verilog
   i_Instruction = Imem[i_Addr>>2];
   ```

2. **Instruction Decode (ID):**
   - The fetched instruction is decoded to determine it is a `add` operation.
   - The opcode part of the instruction (which is `000000` for R-type instructions) is identified, and the source register identifiers (`rs` and `rt`) are used to read the respective registers.
   ```verilog
   rs = i_instruction[25:21];
   rt = i_instruction[20:16];
   ```

3. **Execute (EX):**
   - The ALU (Arithmetic Logic Unit) performs the addition of the values in the source registers (`rs` and `rt`).
   - The values from these registers are fed into the ALU where the addition is performed based on the control signal (`ALUOp`) from the control unit.
   ```verilog
   o_ALUresult = i_data1 + i_data2;
   ```

4. **Memory Access (MEM):**
   - For the `add` instruction, this stage is not utilized as no memory access is required (i.e., no data is read from or written to the memory).
   ```verilog
   // No memory operation required for 'add'
   ```

5. **Write Back (WB):**
   - The result from the ALU is written back into the destination register (`rd`).
   - This is where the output of the ALU operation is stored back into the register file, specifically into the register indicated by the `rd` field of the instruction.
   ```verilog
   Reg[rd] = o_ALUresult;
   ```

##### Example Code Snippet:

Here is a simplified Verilog snippet that captures the essence of the `add` instruction's operation in a MIPS processor, focusing on the key stages of the mips architecture (IF, ID, EX, MEM, WB).

```verilog
module MIPS_Processor(input clk, input reset, ...);
    // Registers and other declarations here
    reg [31:0] PC, ALUResult, Reg[31:0];
    reg [31:0] InstructionRegister, ReadData1, ReadData2;
    integer rd, rs, rt;
    always @(posedge clk) begin
        if (reset) begin
            PC <= 0;  // Reset PC
        end else begin
            // Fetch Instruction
            InstructionRegister <= Imem[PC>>2];
            PC <= PC + 4;
            // Decode Instruction
            rs = InstructionRegister[25:21]; // Extract source register indices
            rt = InstructionRegister[20:16]; // Extract target register indices
            rd = InstructionRegister[15:11]; // Extract destination register index
            ReadData1 <= Reg[rs];
            ReadData2 <= Reg[rt];
            // Execute
            ALUResult <= ReadData1 + ReadData2;
            // Write Back
            Reg[rd] <= ALUResult;
        end
    end
endmodule
```

The `add` instruction demonstrates the typical use of the R-type format in MIPS instruction set architecture, involving fetching the instruction, decoding it, executing the operation in the ALU, skipping memory access, and finally writing back the result to the register file.

### ADDI (I-type instruction)

Name (format, op, function): `add immediate (I,8,na)`

Syntax: `addi rt,rs,imm`

Operation: `reg(rt) := reg(rs) + signext(imm);`

#### Instruction Overview:

- **IF:** Fetch the instruction from memory.
- **ID:** Decode the instruction; read the source register (`rs`).
- **EX:** ALU adds the value in the source register to the immediate value (which is sign-extended).
- **MEM:** No action.
- **WB:** The result is written back to the target register (`rt`).

#### Operation Breakdown:

The following further breaks down the operation of the `ADDI` instruction in a MIPS processor across the various stages of the processor pipeline.

##### Stages of the `ADDI` Instruction

1. **Instruction Fetch (IF):**
   - The processor retrieves the `ADDI` instruction from memory based on the current Program Counter (PC) value.
   - The instruction is then forwarded to the next stage for decoding.

2. **Instruction Decode (ID):**
   - The instruction is decoded to identify that it is a `ADDI` operation.
   - The source register (`rs`) is read to obtain its value. The immediate value (`imm`) is also extracted from the instruction during this phase.

3. **Execute (EX):**
   - The Arithmetic Logic Unit (ALU) performs the addition operation. It adds the value retrieved from the source register (`reg(rs)`) to the sign-extended immediate value (`signext(imm)`).
   - This computation involves extending the immediate value to match the register size (typically 32 bits in MIPS), preserving its sign to handle negative numbers correctly.

4. **Memory Access (MEM):**
   - The `ADDI` instruction does not involve any memory access, so this stage is effectively a no-op (no operation) for this instruction.

5. **Write Back (WB):**
   - The result of the addition from the ALU is written back to the destination register (`reg(rt)`).
   - This step updates the target register with the computed value, completing the execution of the instruction.

##### Explanation of the Code Implementation

The operation of `ADDI` can be modeled in a simulated or actual MIPS processor using the following Verilog-like pseudocode:

```verilog
module addi_instruction(rs, rt, imm, output rt_value);
    input [4:0] rs, rt;       // Source and target register indices (5 bits each)
    input [15:0] imm;         // 16-bit immediate value
    output [31:0] rt_value;   // Output to target register
    wire [31:0] rs_value;     // Value from source register
    wire [31:0] extended_imm; // Sign-extended immediate value
    assign extended_imm = {
      {16{imm[15]}}, imm      // Sign-extend the immediate value
    };
    assign rt_value = rs_value + extended_imm;
endmodule
```

- `rs` and `rt` are inputs representing the source and destination register indices.
- `imm` is the 16-bit immediate value input.
- The immediate value is sign-extended to 32 bits using Verilog's bit replication and concatenation (`{{16{imm[15]}}, imm}`), where `imm[15]` is the most significant bit (MSB) of the immediate value, replicated 16 times to fill the upper half of a 32-bit word.
- The sum of the sign-extended immediate and the source register value is computed and assigned to `rt_value`, which would be written back to the register file in the actual processor hardware.

###  LW (Load Word)

Name (format, op, function): `load word (I,35,na)`

Syntax: `lw rt,imm(rs)`

Operation: `reg(rt) := mem[reg(rs) + signext(imm)];`

#### Instruction Overview:

- **IF:** Fetch the instruction.
- **ID:** Decode the instruction; read the base address register (`rs`).
- **EX:** Calculate the memory address by adding the immediate value (offset) to the base register.
- **MEM:** Access the memory at the computed address and read the word.
- **WB:** Write the loaded word into the target register (`rt`).

#### Operation Breakdown:

The following provides a detailed breakdown of the operation of the `lw` instruction in a MIPS processor, focusing on the key stages of the processor pipeline.

##### Breakdown of `lw` Instruction Execution

1. **Instruction Fetch (IF)**:
   - The processor fetches the `lw` instruction from instruction memory using the program counter (PC).
   - Code snippet showing fetching the instruction from memory:
     ```verilog
     i_Instruction = Imem[i_Addr>>2];
     ```

2. **Instruction Decode (ID)**:
   - The fetched instruction is decoded to extract the opcode, source register (`rs`), target register (`rt`), and the immediate value.
   - The base address (content of `rs`) is read from the register file during this phase.
   - Code snippet showing the decoding and reading of the base address:
     ```verilog
     read_data1 = RegData[i_rs];  // Assume i_rs is the source register index
     ```

3. **Execute (EX)**:
   - The effective memory address is calculated by adding the sign-extended immediate value to the base address read from `rs`.
   - This calculation typically happens in the ALU.
   - Code snippet that could represent the address calculation in ALU (not specifically shown in your snippets):
     ```verilog
     address = read_data1 + sign_extend(imm);  // Conceptual code
     ```

4. **Memory Access (MEM)**:
   - The processor accesses the memory location computed in the Execute stage.
   - The word at this memory address is read.
   - Code snippet showing memory access to read data:
     ```verilog
     if (i_MemRead == 1) {
       o_rData = Dmem[i_addr];  // Read memory at calculated address
     }
     ```

5. **Write Back (WB)**:
   - The data retrieved from memory is written into the target register (`rt`).
   - Code snippet showing the write-back to the register:
     ```verilog
     RegData[i_rt] <= i_wData;  // Assume i_rt is the target register index and i_wData is data read from memory
     ```

#### SW (Store Word)

Name (format, op, function): store word (I,43,na)

Syntax: `sw rt,imm(rs)`

Operation: `mem[reg(rs) + signext(imm)] := reg(rt);`

#### Instruction Overview:

- **IF:** Fetch the instruction.
- **ID:** Decode the instruction; read the base address register (`rs`) and the register to be stored (`rt`).
- **EX:** Calculate the memory address by adding the immediate value (offset) to the base register.
- **MEM:** Write the value from `rt` into the calculated memory address.
- **WB:** No write-back step for store instructions.

#### Operation Breakdown:

The `SW` instruction in the MIPS architecture is used to store a 32-bit word from a register into memory. Here's an in-depth breakdown of how the `SW` instruction is executed across the various stages in a MIPS processor.

#### Instruction Stages:

1. **IF (Instruction Fetch):**
   - The instruction is fetched from the instruction memory using the current Program Counter (PC).

2. **ID (Instruction Decode):**
   - The instruction is decoded to identify it as a `SW` instruction.
   - The base address register (`rs`) and the register containing data to be stored (`rt`) are identified and read.

3. **EX (Execute):**
   - The effective memory address is calculated by adding the sign-extended immediate (offset) to the value in the base register (`rs`).

4. **MEM (Memory Access):**
   - The data in register `rt` is written to the calculated memory address.

5. **WB (Write Back):**
   - No write-back is performed for the `SW` instruction, as this instruction does not modify any register contents.

##### Verilog Implementation:

**Data Memory Module (`DataMemory.v`):**

Below is a simplified Verilog module for a data memory component that can be used to store and retrieve data in a MIPS processor. This module includes logic for both read and write operations.

```verilog
module DataMemory (
    input clk,
    input memWrite,
    input [31:0] address,
    input [31:0] writeData,
    output reg [31:0] readData
);
    reg [31:0] memory [0:1023];
    always @(posedge clk) begin
        if (memWrite) begin
            memory[address >> 2] <= writeData;  // Write operation
        end else begin
            readData <= memory[address >> 2];   // Read operation
        end
    end
endmodule
```

**Processor Control Logic (`ProcessorControl.v`):**

Below is an extract from the ProcessorControl module that controls the behavior of the processor based on the opcode of the instruction being executed. This snippet shows how the control signals are set for the `SW` instruction.

```verilog
module ProcessorControl (
    input [5:0] opcode,
    output reg memWrite,
    output reg aluSrc,
    output reg regDst,
    output reg memToReg,
    output reg regWrite
);
    always @(*) begin
        case (opcode)
            6'b101011: begin  // Opcode for SW
                memWrite = 1'b1;
                aluSrc = 1'b1;
                regDst = 1'b0;
                memToReg = 1'b0;
                regWrite = 1'b0;
            end
            default: begin
                memWrite = 1'b0;
                aluSrc = 1'b0;
                regDst = 1'b0;
                memToReg = 1'b0;
                regWrite = 1'b0;
            end
        endcase
    end
endmodule
```

**Simplified Top-Level MIPS Module:**
```verilog
module MIPSProcessor (
    input clk,
    input reset,
    output [31:0] pc,
    input [31:0] instruction,
    output [31:0] aluResult,
    output [31:0] writeData,
    output [31:0] readData
);
    wire [5:0] opcode = instruction[31:26];
    wire [4:0] rs = instruction[25:21];
    wire [4:0] rt = instruction[20:16];
    wire [15:0] imm = instruction[15:0];
    wire [31:0] signExtImm = {{16{imm[15]}}, imm};
    wire [31:0] regDataRs, regDataRt;
    wire memWrite, aluSrc, regDst, memToReg, regWrite;
    // Instantiate control logic
    ProcessorControl control(opcode, memWrite, aluSrc, regDst, memToReg, regWrite);
    // ALU operation (assuming already instantiated and connected)
    // Data memory operation
    DataMemory dataMem(clk, memWrite, aluResult, regDataRt, readData);
    // Register file operations and other connections would be defined here
endmodule
```

### BEQ (Branch if Equal)

Name (format, op, function): `branch on equal (I,4,na)`

Syntax: `beq rs,rt,label`

Operation: if reg(rs) == reg(rt) then PC = BTA else NOP;

#### Instruction Overview:

- **IF:** Fetch the instruction.
- **ID:** Decode the instruction; read the two registers (`rs` and `rt`) and compare them.
- **EX:** Calculate the branch target address if the comparison is equal (by adding the sign-extended, shifted immediate to the PC).
- **MEM:** No memory access.
- **WB:** No write-back; update the PC to the branch address if the condition is met, otherwise increment the PC as usual.

#### Operation Breakdown:

The following provides a detailed breakdown of the operation of the `BEQ` instruction in a MIPS processor, focusing on the key stages of the processor pipeline.

The `BEQ` (Branch if Equal) instruction in the MIPS architecture follows a specific flow through the processor stages. Here's a step-by-step walkthrough of each stage using Verilog code examples to illustrate how each part of the instruction's lifecycle is handled in hardware.

##### Instruction Stages for `BEQ`

1. **IF (Instruction Fetch) Stage**:
   - The instruction is fetched from the instruction memory using the current Program Counter (PC).
   - The PC is incremented to point to the next instruction (PC = PC + 4).

   ```verilog
   module InstructionFetch(
       input clk,
       input reset,
       input [31:0] next_pc,
       output reg [31:0] instr,
       output reg [31:0] pc
   );
       always @(posedge clk or posedge reset) begin
           if (reset) begin
               pc <= 32'h00000000; // Reset PC to start
           end else begin
               pc <= next_pc; // Update PC to next PC
               instr <= instruction_memory[pc >> 2]; // Fetch instruction from memory
           end
       end
   endmodule
   ```

2. **ID (Instruction Decode) Stage**:
   - Decode the fetched instruction to identify it as `BEQ`.
   - Read the two source registers (`rs` and `rt`) based on the instruction fields.
   - Set up the control signals for the ALU to perform a subtraction (`rs - rt`).

   ```verilog
   module InstructionDecode(
       input [31:0] instr,
       output reg [4:0] rs,
       output reg [4:0] rt,
       output reg [15:0] immediate
   );
       always @(*) begin
           rs = instr[25:21];
           rt = instr[20:16];
           immediate = instr[15:0]; // For branch offset
       end
   endmodule
   ```

3. **EX (Execute) Stage**:
   - Compute the target address for branching by sign-extending the immediate field and shifting left by 2 bits (since it's word-aligned), then adding this to the PC + 4 (already incremented PC from IF stage).
   - ALU checks if `rs` and `rt` are equal by subtracting and checking if the result is zero.

   ```verilog
   module ALU(
       input [31:0] rs_val,
       input [31:0] rt_val,
       input [31:0] sign_ext_imm,
       input [2:0] alu_control,
       output reg zero,
       output reg [31:0] alu_result
   );
       wire [31:0] branch_target = (sign_ext_imm << 2) + pc_plus_4;
       always @(*) begin
           case(alu_control)
               3'b010: begin // Subtract for BEQ
                   alu_result = rs_val - rt_val;
                   zero = (alu_result == 0) ? 1'b1 : 1'b0;
               end
           endcase
       end
   endmodule
   ```

4. **MEM (Memory Access) Stage**:
   - For `BEQ`, there is no memory access or data memory operation.

5. **WB (Write-Back) Stage**:
   - Update the PC to the branch target if `rs` == `rt` (if zero flag from ALU is true).
   - If `rs` != `rt`, increment the PC to the next instruction (already done in IF).

   ```verilog
   always @(posedge clk) begin
       if (branch_taken) begin
           pc <= branch_target; // Update PC if branch is taken
       end
   endmodule
   ```

##### Example Verilog for Complete BEQ Control

Here's how a simpler control unit might orchestrate these stages just for the `BEQ` instruction in a MIPS processor:

```verilog
module ControlUnit(
    input [5:0] opcode,
    output reg branch,
    output reg alu_src,
    output reg [2:0] alu_control
);
    always @(*) begin
        case(opcode)
            6'b000100: begin // BEQ
                branch = 1'b1;
                alu_src = 1'b0; // Use rs, rt directly
                alu_control = 3'b010; // Set ALU to subtract
            end
            default: begin
                branch = 1'b0;
                alu_src = 1'b0;
                alu_control = 3'b000;
            end
        endcase
    end
endmodule
```

### J (Jump)

Name (format, op, function): `jump (J,2,na)`

Syntax: `j`

Operation: `PC := JTA;`

#### Instruction Overview:

- **IF:** Fetch the instruction.
- **ID:** Decode the instruction.
- **EX:** Calculate the jump target address from the address field of the instruction.
- **MEM:** No memory access.
- **WB:** Update the PC to the jump address.

#### Operation Breakdown:

The following provides a detailed breakdown of the operation of the `J` instruction in a MIPS processor, focusing on the key stages of the processor pipeline.
The J instruction in MIPS is a jump instruction that allows the program to continue execution from a specified address. It is used to alter the flow of control unconditionally.

##### Instruction Format and Operation:

- **Name (format, op, function):** `jump (J,2,na)`
- **Syntax:** `j target`
- **Operation:** `PC := JTA;` where JTA (Jump Target Address) is calculated from the instruction itself.

##### Stages of J Instruction Execution

Here's a breakdown of how the J instruction progresses through each stage of the MIPS pipeline:

1. **IF (Instruction Fetch):**
   - The instruction is fetched from the instruction memory at the current program counter (PC) address.
   - The PC is then incremented by 4 to point to the next sequential instruction (though this increment will be overridden by the jump).

2. **ID (Instruction Decode):**
   - The opcode of the instruction is decoded to identify it as a jump instruction.
   - No registers are read in this stage because the jump instruction does not involve any registers.

3. **EX (Execute):**
   - The jump target address (JTA) is calculated from the address field of the instruction.
   - JTA is formed by taking the upper 4 bits of the PC (from the incremented value that points to the next instruction) and concatenating them with the 26-bit address field from the instruction, shifted left by 2 bits (to word-align the address).

4. **MEM (Memory Access):**
   - There is no memory access for the jump instruction.

5. **WB (Write Back):**
   - The PC is updated to the new address calculated in the Execute stage. This is the jump target address where the program will continue executing.

Verilog Module for Program Counter with just Jump:

```verilog
module ProgramCounter(
    input clk,
    input reset,
    input [31:0] jump_address,  // Jump target address input
    input jump,                // Control signal to indicate a jump
    output reg [31:0] pc       // Program counter output
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'b0;  // Reset the PC to 0 on reset
        end else if (jump) begin
            pc <= jump_address;  // Update PC to the jump address if jump is asserted
        end else begin
            pc <= pc + 4;  // Increment PC by 4 on each clock cycle otherwise
        end
    end
endmodule
```

##### Verilog Module for Jump Address Calculation:

While in this project, this function is done by `NextProgramCounter` module, here is a simplified version of a module that calculates the jump address in a MIPS processor to further illustrate the concept of jump address calculation:

```verilog
module JumpAddressCalculator(
    input [25:0] address_field,  // Address field from the jump instruction
    input [31:0] pc_plus_4,      // PC + 4 (the incremented PC pointing to the next instruction)
    output [31:0] jump_address   // Calculated jump target address
);
    assign jump_address = {pc_plus_4[31:28], address_field << 2};
endmodule
```

- The `ProgramCounter` module handles updating the PC based on whether a jump is taken. If a jump is taken, it sets the PC to the jump address; otherwise, it simply increments the PC.
- The `JumpAddressCalculator` module calculates the full 32-bit jump address by concatenating the upper 4 bits of the incremented PC (PC+4) with the left-shifted 26-bit address from the jump instruction.

These modules collectively illustrate how the J instruction's effect on the program counter can be implemented in hardware using Verilog.

### ADDU (Add Unsigned)

name (format, op, function): `add unsigned (R,0,33)`

Syntax: `addu rd,rs,rt`

Operation: `reg(rd) := reg(rs) + reg(rt);`

#### Instruction Overview:

- **IF (Instruction Fetch):** The instruction is fetched from memory using the program counter (PC).
- **ID (Instruction Decode):** The opcode is decoded; registers rs and rt are read.
- **EX (Execute):** The arithmetic logic unit (ALU) adds the values from registers rs and rt.
- **MEM (Memory Access):** No action needed (pass-through).
- **WB (Write Back):** The result from the ALU is written back to the destination register rd.

#### Operation Breakdown:

The following provides a detailed breakdown of the operation of the `ADDU` instruction in a MIPS processor, focusing on the key stages of the processor pipeline.

The `ADDU` instruction in MIPS is an unsigned addition operation that does not raise exceptions on overflow. Here's a detailed breakdown of how the `ADDU` instruction is executed across the various stages of the processor pipeline.

##### IF (Instruction Fetch)

In this stage, the instruction is fetched from the instruction memory based on the current value of the Program Counter (PC). Here's how you might see this operation in Verilog:

```verilog
// Instruction Fetch module
module InstructionFetch(
    input [31:0] i_PC,            // Program Counter
    output [31:0] o_Instruction   // Fetched instruction
);
    reg [31:0] instruction_memory[255:0]; // Memory array

    // Fetch the instruction
    assign o_Instruction = instruction_memory[i_PC >> 2]; // Word aligned access
endmodule
```

##### ID (Instruction Decode)

During this stage, the opcode of the fetched instruction is decoded, and the register file is accessed to read the contents of registers `rs` and `rt`.

```verilog
// Instruction Decode module
module InstructionDecode(
    input [31:0] i_Instruction,   // Input from IF stage
    output [4:0] o_rs, o_rt, o_rd // Register specifiers
);
    // Decode the instruction
    assign o_rs = i_Instruction[25:21];
    assign o_rt = i_Instruction[20:16];
    assign o_rd = i_Instruction[15:11];
endmodule
```

##### EX (Execute)

The ALU adds the values from registers `rs` and `rt`. Here's a snippet of the ALU performing this addition:

```verilog
// Arithmetic Logic Unit (ALU) module
module ALU(
    input [31:0] i_data1, i_data2,    // Data from registers rs and rt
    input [3:0] i_ALUControl,         // Control signals
    output reg [31:0] o_result        // Result of the ALU operation
);
    always @(i_data1, i_data2, i_ALUControl) begin
        case (i_ALUControl)
            4'b0010: o_result = i_data1 + i_data2; // ADDU operation
            // Other ALU operations...
        endcase
    end
endmodule
```

#### MEM (Memory Access)

This stage is a pass-through for the ADDU instruction since it does not involve memory access.

```verilog
// Memory Access Stage - No action needed for ADDU
module MemoryAccess(
    input [31:0] i_ALUResult,
    output [31:0] o_MemOut
);
    assign o_MemOut = i_ALUResult;  // Direct pass-through
endmodule
```

#### WB (Write Back)

The result from the ALU is written back to the destination register `rd`.

```verilog
// Write Back stage
module WriteBack(
    input [31:0] i_ALUResult,       // Result from ALU
    input [4:0] i_rd,               // Destination register
    output reg [31:0] o_WriteData   // Data to write back
);
    // Write the data back to the register file
    always @(i_ALUResult) begin
        o_WriteData = i_ALUResult;
    end
endmodule
```

### SUB (Subtract)

Name (format, op, function): `subtract (R,0,34)`

Syntax: `sub rd,rs,rt`

Operation: `reg(rd) := reg(rs) [ reg(rt);`

#### Instruction Overview:

- **IF:** Fetch the instruction using the PC.
- **ID:** Decode the instruction; read registers rs and rt.
- **EX:** The ALU subtracts the value in rt from rs.
- **MEM:** No action needed (pass-through).
- **WB:** The ALU result is written back to register rd.

#### Operation Breakdown:

The following provides a detailed breakdown of the operation of the `SUB` instruction in a MIPS processor, focusing on the key stages of the processor pipeline.

1. **Instruction Fetch (IF) Stage:**
   In this stage, the processor fetches the instruction from instruction memory using the Program Counter (PC).

```verilog
// Instruction Fetch (IF) stage
module InstructionFetch(
    input [31:0] i_pc,
    output reg [31:0] o_instruction
);
    // Assume IMem is an array storing instructions
    reg [31:0] IMem[0:1023];

    // Fetch instruction
    always @(i_pc) begin
        o_instruction = IMem[i_pc >> 2]; // Word aligned fetch
    end
endmodule
```

2. **Instruction Decode (ID) Stage:**
   Here, the instruction is decoded, and the relevant registers are read. The operation is identified, and signals are prepared for the execution stage.

```verilog
// Instruction Decode (ID) stage
module InstructionDecode(
    input [31:0] i_instruction,
    output reg [4:0] o_rs, o_rt, o_rd,
    output reg [5:0] o_opcode, o_funct
);
    always @(i_instruction) begin
        o_opcode = i_instruction[31:26];
        o_rs = i_instruction[25:21];
        o_rt = i_instruction[20:16];
        o_rd = i_instruction[15:11];
        o_funct = i_instruction[5:0];
    end
endmodule
```

3. **Execution (EX) Stage:**
   The ALU performs the subtraction based on the decoded instruction. The operands are taken from the registers identified in the ID stage.

```verilog
// Execution (EX) stage - ALU for SUB operation
module ALU(
    input [31:0] i_data1, i_data2,
    input [3:0] i_ALUcontrol,
    output reg [31:0] o_result
);
    always @(*) begin
        case(i_ALUcontrol)
            4'b0110: o_result = i_data1 - i_data2; // SUB operation
            // Additional cases for other ALU operations
        endcase
    end
endmodule
```

4. **Memory (MEM) Stage:**
   For the `SUB` instruction, there is no memory operation needed. This stage can be passed through or handled with a control signal that disables memory operations.

```verilog
// Memory (MEM) stage pass-through for SUB
module MemoryStage(
    input i_MemRead, i_MemWrite,
    input [31:0] i_address, i_writeData,
    output reg [31:0] o_readData
);
    // Memory array
    reg [31:0] DMem[0:1023];

    always @(*) begin
        if (i_MemWrite) DMem[i_address >> 2] = i_writeData;
        if (i_MemRead) o_readData = DMem[i_address >> 2];
    end
endmodule
```

5. **Write Back (WB) Stage:**
   The result of the ALU operation is written back to the register file, particularly in the register specified by `rd`.

```verilog
// Write Back (WB) stage
module WriteBack(
    input [31:0] i_ALUresult,
    input [4:0] i_rd,
    input i_RegWrite,
    output reg [31:0] o_writeData
);
    always @(i_ALUresult) begin
        if (i_RegWrite) begin
            o_writeData = i_ALUresult;
        end
    end
endmodule
```

### SUBU (Subtract Unsigned)

Name (format, op, function): `subtract unsigned (R,0,35)`

Syntax: `subu rd,rs,rt`

Operation: `reg(rd) := reg(rs) [ reg(rt);`

#### Instruction Overview:

- **IF:** Fetch the instruction using the PC.
- **ID:** Decode the instruction; read registers rs and rt.
- **EX:** The ALU subtracts the value in rt from rs.
- **MEM:** No action needed (pass-through).
- **WB:** The ALU result is written back to register rd.

#### Operation Breakdown:

1. **Instruction Fetch (IF)**
   - The instruction is fetched from the instruction memory using the Program Counter (PC).
   - Verilog snippet:
     ```verilog
     // IF Stage
     always @(posedge clk) begin
         if (reset)
             pc <= 0;
         else if (pc_src)
             pc <= pc_next;
         else
             pc <= pc + 4;
     end
     ```

2. **Instruction Decode (ID)**
   - The fetched instruction is decoded to identify the operation as `SUBU` and the source (`rs`, `rt`) and destination (`rd`) registers are identified.
   - Verilog snippet:
     ```verilog
     // ID Stage
     reg [31:0] instruction;
     wire [4:0] rs, rt, rd;
     assign rs = instruction[25:21];
     assign rt = instruction[20:16];
     assign rd = instruction[15:11];
     ```

3. **Execution (EX)**
   - The actual subtraction of the contents of the registers `rs` and `rt` is performed. The result does not account for overflow because it is unsigned.
   - Verilog snippet:
     ```verilog
     // EX Stage
     reg [31:0] reg_data[31:0];  // Register file
     wire [31:0] rs_value, rt_value, result;
     assign rs_value = reg_data[rs];
     assign rt_value = reg_data[rt];
     assign result = rs_value - rt_value;
     ```

4. **Memory Access (MEM)**
   - `SUBU` does not require a memory operation, so this stage can be considered a pass-through.
   - No action required for SUBU

5. **Write Back (WB)**
   - The result of the subtraction is written back to the destination register `rd`.
   - Verilog snippet:
     ```verilog
     // WB Stage
     always @(posedge clk) begin
         if (reg_write)
             reg_data[rd] <= result;
     end
     ```

```verilog
module MIPS_Processor(input clk, input reset, output [31:0] pc);
    reg [31:0] pc, next_pc;
    reg [31:0] reg_file[31:0];  // Register file

    // Instruction Fetch
    always @(posedge clk) begin
        if (reset)
            pc <= 0;
        else
            pc <= next_pc;
    end

    // Instruction Decode
    reg [31:0] instruction;
    wire [4:0] rs, rt, rd;
    wire [5:0] opcode;
    assign opcode = instruction[31:26];
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
    // Execute
    wire [31:0] rs_value, rt_value, alu_result;
    assign rs_value = reg_file[rs];
    assign rt_value = reg_file[rt];
    assign alu_result = (opcode == 6'b000000) ? (rs_value - rt_value) : 32'b0;  // SUBU Opcode assumed
    // Memory Access
    // No memory access for SUBU
    // Write Back
    always @(posedge clk) begin
        if (opcode == 6'b100011)  // SUBU Opcode
            reg_file[rd] <= alu_result;
    end
    // Program Counter Update
    always @(*) begin
        next_pc = pc + 4;  // Simple sequential execution
    end
endmodule
```
In this example, `opcode == 6'b100011'` is the actual opcode for `SUBU`.

### AND

- **IF:** Instruction is fetched.
- **ID:** Instruction is decoded. For AND, rs and rt are read; for ANDI, rs is read, and the immediate value is zero-extended.
- **EX:** The ALU performs an AND operation between operands.
- **MEM:** No action needed.
- **WB:** Result is written back to rd (AND) or rt (ANDI).

#### Instruction Breakdown

The AND instruction performs a bitwise AND operation between two operands and stores the result in a destination register.

1. **Instruction Fetch (IF) stage:**
   - The Program Counter (PC) contains the address of the AND instruction.
   - The Instruction Memory module (`InstructionMemory.v`) fetches the instruction from the memory location pointed to by the PC.
   - The fetched instruction is passed to the next stage.

2. **Instruction Decode (ID) stage:**
   - The Control Unit module (`ControlUnit.v`) decodes the opcode of the AND instruction.
   - Based on the opcode, the Control Unit generates the appropriate control signals for the data-path components.
   - The Register File module reads the values of the source registers specified in the AND instruction.

3. **Execution (EX) stage:**
   - The ALU module (`ALU.v`) performs the bitwise AND operation between the values of the source registers.
   - The ALU control signal generated by the Control Unit determines the specific operation to be performed (AND in this case).

4. **Memory Access (MEM) stage:**
   - The AND instruction does not require any memory access, so this stage is a pass-through.

5. **Write Back (WB) stage:**
   - The result of the AND operation from the ALU is written back to the destination register specified in the AND instruction.
   - The RegWrite control signal generated by the Control Unit enables the writing of the result to the Register File.

Within the control unit, the AND instruction is identified by its opcode, and the appropriate control signals are set to execute the AND operation.

The ALU module performs the bitwise AND operation between the source register values, and the result is written back to the destination register.

Here's an example of how the AND instruction flows through the different stages of the single-cycle MIPS processor starting within the control unit.

```verilog
// Control Unit
always @(i_instruction) begin
  case (i_instruction[31:26])
    // ...
    6'b001100: begin   // andi
      o_RegDst = 0;    // Destination register is rt
      o_ALUSrc = 1;    // Second operand is immediate value
      o_MemtoReg = 0;  // ALU result is written to register
      o_RegWrite = 1;  // Write to register file
      o_MemRead = 0;   // No memory read
      o_MemWrite = 0;  // No memory write
      o_Branch = 0;    // No branch
      o_Bne = 0;       // No branch if not equal
      o_ALUOp = 2'b11; // ALU operation is AND
      o_Jump = 0;      // No jump
      // ...
    end
    // ...
  endcase
end

// ALU
always @(i_data1, data2, i_ALUcontrol) begin
  case (i_ALUcontrol)
    // ...
    4'b0000:  // AND
      o_ALUresult = i_data1 & data2;
    // ...
  endcase
  // ...
end
```

In the Control Unit module, when the opcode of the instruction matches the AND opcode (`6'b001100` in this case), the appropriate control signals are set.

The `ALUSrc` signal is set to 1 to select the immediate value as the second operand, and the `ALUOp` signal is set to indicate an AND operation.

In the ALU module, when the `ALUcontrol` signal matches the AND operation (4'b0000), the bitwise AND operation is performed between the two input operands (i_data1 and data2), and the result is assigned to `o_ALUresult`.

### ANDI (AND Immediate)

`and immediate (I,12,na)`

`andi rt,rs,imm`

`reg(rt) := reg(rs) & zeroext(imm);`

#### Instruction Overview:

- **IF:** Instruction is fetched.
- **ID:** Opcode decoded. Registers rs and rt are read for AND; rs and immediate for ANDI.
- **EX:** ALU performs an AND operation.
- **MEM:** No memory access.
- **WB:** Result written to rd (AND) or rt (ANDI).

#### Instruction Breakdown

The ANDI (AND Immediate) instruction performs a bitwise AND operation between a register value and an immediate value.

Here's an explanation of how the ANDI instruction goes through each stage of the MIPS processor pipeline:

1. **Instruction Fetch (IF):**
   - The Program Counter (PC) contains the address of the ANDI instruction in the Instruction Memory.
   - The instruction is fetched from the Instruction Memory using the PC value.
   - Example code in the Instruction Memory module (`InstructionMemory.v`):
     ```verilog
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

2. **Instruction Decode (ID):**
   - The fetched instruction is decoded to determine the operation to be performed.
   - The Control Unit generates the necessary control signals based on the opcode and function code of the instruction.
   - The register to be read (rs) is determined from the instruction, and the immediate value is sign-extended.
   - Example code in the Control Unit module (`ControlUnit.v`):
     ```verilog
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
       // ...
     end
     ```

3. **Execute (EX):**
   - The ALU performs the bitwise AND operation between the value of register rs and the sign-extended immediate value.
   - The result of the AND operation is stored in a temporary register.
   - Example code in the ALU module (`ALU.v`):
     ```verilog
     always @(i_data1, data2, i_ALUcontrol) begin
       case (i_ALUcontrol)
         // ...
         4'b0000:  // AND
           o_ALUresult = i_data1 & data2; // bitwise AND
         // ...
       endcase
       // ...
     end
     ```

4. **Memory Access (MEM):**
   - The ANDI instruction does not involve memory access, so no action is needed in this stage.
   - The result from the Execute stage is simply passed through to the next stage.

5. **Write Back (WB):**
   - The result of the AND operation, stored in the temporary register, is written back to the destination register (rt) in the Register File.
   - Example code in the Register File module (`RegisterFile.v`):
     ```verilog
     always @(posedge i_Clk or posedge i_Rst) begin
       if (i_Rst) begin
         // Reset all registers to zero
         for (j = 0; j < 32; j = j + 1) begin
           RegData[j] = 32'b0;
         end
       end else if (i_RegWrite) begin
         // Write data to the specified register
         RegData[i_wReg] = i_wData;
       end
     end
     ```

Here's an example of how the ANDI instruction would look in machine code:
```
001100 01000 01010 0000000000001111
```

In this example:
- `001100` is the opcode for the ANDI instruction.
- `01000` represents the source register (rs), which is $8 in this case.
- `01010` represents the destination register (rt), which is $10 in this case.
- `0000000000001111` is the immediate value, which is 15 in decimal.

### OR

- **IF:** Instruction is fetched.
- **ID:** Opcode decoded. Registers rs and rt are read for OR; rs and immediate for ORI.
- **EX:** ALU performs an OR operation.
- **MEM:** No action needed.
- **WB:** Result written to rd (OR) or rt (ORI).

#### Instruction Breakdown

The `OR` instruction in the MIPS architecture performs a bitwise OR operation on two register values and stores the result in a destination register.

1. **Instruction Fetch (IF) Stage:**
   - The Program Counter (PC) holds the address of the `OR` instruction to be fetched.
   - The Instruction Memory module (`InstructionMemory.v`) retrieves the instruction from the memory based on the PC value.
   - The fetched instruction is passed to the next stage.

   Example code from `InstructionMemory.v`:
   ```verilog
   always @(i_Addr) begin
     if (i_Addr == -4) begin
       i_Instruction = 32'b11111100000000000000000000000000;
     end else begin
       i_Instruction = Imem[i_Addr>>2];
     end
     i_Ctr = i_Instruction[31:26];
     i_Funcode = i_Instruction[5:0];
   end
   ```

2. **Instruction Decode (ID) Stage:**
   - The fetched instruction is decoded to identify the opcode and register operands.
   - The Control Unit module (`ControlUnit.v`) sets the appropriate control signals based on the opcode.
   - For the `OR` instruction, the `ALUOp` control signal is set to indicate an OR operation.
   - The register operands (`rs` and `rt`) are read from the Register File.

   Example code from `ControlUnit.v`:
   ```verilog
   always @(i_instruction) begin
     case (i_instruction[31:26])
       // ...
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
         // ...
       end
       // ...
     endcase
   end
   ```

3. **Execute (EX) Stage:**
   - The ALU module (`ALU.v`) performs the bitwise OR operation on the values of `rs` and `rt` based on the `ALUOp` control signal.
   - The result of the OR operation is stored in a temporary register.

   Example code from `ALU.v`:
   ```verilog
   always @(i_data1, data2, i_ALUcontrol) begin
     case (i_ALUcontrol)
       // ...
       4'b0001:  // OR
         o_ALUresult = i_data1 | data2; // bitwise OR
       // ...
     endcase
     // ...
   end
   ```

4. **Memory Access (MEM) Stage:**
   - For the `OR` instruction, no memory access is needed, so this stage is a pass-through.

5. **Write Back (WB) Stage:**
   - The ALU result, which is the result of the OR operation, is written back to the destination register (`rd`) in the Register File.

   Example code for writing back to the Register File:
   ```verilog
   always @(posedge i_clk) begin
     if (i_RegWrite) begin
       RegData[i_wReg] = i_wData;
     end
   end
   ```

Throughout the execution of the `OR` instruction, the control signals generated by the Control Unit module (`ControlUnit.v`) orchestrate the flow of data and the operations performed in each stage.

The ALU Control module (`ALUControl.v`) decodes the `ALUOp` signal and the function code of the instruction to generate the appropriate `ALUControl` signal for the ALU module (`ALU.v`) to perform the OR operation.

### ORI (OR Immediate)

- **IF:** Instruction is fetched.
- **ID:** Opcode is decoded. Registers rs and rt are read for OR; rs and immediate for ORI.
- **EX:** ALU performs an OR operation.
- **MEM:** No action needed.
- **WB:** Result is written to rd (OR) or rt (ORI).

#### Instruction Breakdown

The `ORI` (OR Immediate) instruction in MIPS is an I-type instruction that performs a bitwise OR operation between a register and a zero-extended immediate value.

Instruction Format:
```
ORI rt, rs, immediate
```
- `rt`: The destination register where the result will be stored.
- `rs`: The source register containing one of the operands.
- `immediate`: A 16-bit immediate value that will be zero-extended to 32 bits.

Instruction Encoding:
```
| opcode (6 bits) | rs (5 bits) | rt (5 bits) | immediate (16 bits) |
```

Processor Stages:
1. Instruction Fetch (IF):
   - The instruction is fetched from the instruction memory using the PC (Program Counter).
   - The PC is incremented by 4 to point to the next instruction.

2. Instruction Decode (ID):
   - The instruction is decoded by the control unit.
   - The register file is accessed to read the values of the source register `rs` and the destination register `rt`.
   - The 16-bit immediate value is zero-extended to 32 bits.

Verilog code for the instruction decode stage:
```verilog
// Control Unit
always @(i_instruction) begin
  case (i_instruction[31:26])
    // ...
    6'b001101: begin  // ORI
      o_RegDst = 0;
      o_ALUSrc = 1;
      o_MemtoReg = 0;
      o_RegWrite = 1;
      o_MemRead = 0;
      o_MemWrite = 0;
      o_Branch = 0;
      o_ALUOp = 2'b11;  // ALU control for OR operation
      o_Jump = 0;
    end
    // ...
  endcase
end
```

3. Execute (EX):
   - The ALU performs the bitwise OR operation between the value in the source register `rs` and the zero-extended immediate value.
   - The ALU control unit generates the appropriate control signal for the OR operation based on the `ALUOp` signal from the control unit.

Verilog code for the ALU control unit:
```verilog
// ALU Control
always @(i_ALUOp or i_Funcode) begin
  case (i_ALUOp)
    // ...
    2'b11: begin  // ORI
      o_ALUcontrol = 4'b0001;  // ALU control for OR operation
    end
    // ...
  endcase
end
```

4. Memory (MEM):
   - No memory access is needed for the `ORI` instruction, so this stage is a pass-through.

5. Write Back (WB):
   - The ALU result is written back to the destination register `rt` in the register file.

Verilog code for the write-back stage:
```verilog
// Register File
always @(posedge i_clk) begin
  if (i_RegWrite) begin
    RegData[i_writeReg] <= i_writeData;
  end
end
```

Here's an example of how the `ORI` instruction would be processed in the single-cycle MIPS processor:
```assembly
ORI $t0, $s0, 0xFFFF
```
This instruction performs a bitwise OR operation between the value in register `$s0` and the immediate value `0xFFFF` (16 bits), and stores the result in register `$t0`.

In the IF stage, the instruction is fetched from the instruction memory using the PC.

In the ID stage, the instruction is decoded, and the values of `$s0` and `$t0` are read from the register file. The immediate value `0xFFFF` is zero-extended to 32 bits.

In the EX stage, the ALU performs the bitwise OR operation between the value in `$s0` and the zero-extended immediate value. The ALU control unit generates the appropriate control signal for the OR operation based on the `ALUOp` signal from the control unit.

### NOR

#### Intruction Overview

- **IF:** Fetch instruction.
- **ID:** Decode opcode; read rs and rt.
- **EX:** ALU performs NOR operation on rs and rt.
- **MEM:** No action needed.
- **WB:** Result is written back to rd.

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
 BNE (Branch Not Equal)

- **IF:** Fetch instruction.
- **ID:** Decode instruction; read registers rs and rt.
- **EX:** Compare values of rs and rt.
- **MEM:** No action needed.
- **WB:** If rs != rt, PC is updated to branch address (PC + offset); otherwise, move to next sequential instruction.

#### Instruction Breakdown

The BNE (Branch Not Equal) instruction is a conditional branch instruction in the MIPS architecture.

It compares the values of two registers and transfers control to a target address if the values are not equal.

1. **Instruction Fetch (IF) Stage:**
In the IF stage, the instruction is fetched from the Instruction Memory using the Program Counter (PC).

```verilog
// Fetch the instruction from the Instruction Memory
i_Instruction = Imem[i_Addr>>2];
```

2. **Instruction Decode (ID) Stage:**
In the ID stage, the instruction is decoded, and the registers rs and rt are read from the Register File.

```verilog
// Decode the instruction
i_Ctr = i_Instruction[31:26];
i_Funcode = i_Instruction[5:0];

// Read registers rs and rt from the Register File
wire [4:0] rs = i_Instruction[25:21];
wire [4:0] rt = i_Instruction[20:16];
wire [31:0] rs_data = RegData[rs];
wire [31:0] rt_data = RegData[rt];
```

3. **Execution (EX) Stage:**
In the EX stage, the values of rs and rt are compared using the ALU.

```verilog
// Compare the values of rs and rt using the ALU
wire ALU_zero;
ALU alu (
    .i_data1(rs_data),
    .i_read2(rt_data),
    .i_ALUcontrol(ALU_control),
    .o_Zero(ALU_zero),
    .o_ALUresult(ALU_result)
);
```

4. **Memory Access (MEM) Stage:**
The BNE instruction does not require any memory access, so this stage is a pass-through.

5. **Write Back (WB) Stage:**
In the WB stage, if the values of rs and rt are not equal (ALU_zero is 0), the Program Counter (PC) is updated to the branch target address (PC + offset). Otherwise, the PC moves to the next sequential instruction.

```verilog
// Update the PC based on the branch condition
wire [31:0] branch_target = PC + {{14{i_Instruction[15]}}, i_Instruction[15:0], 2'b00};
wire branch_taken = i_Branch & ~ALU_zero;
assign PC_next = branch_taken ? branch_target : PC + 4;
```

Here's an example of how the BNE instruction can be represented in Verilog:

```verilog
module BNE_example (
    input [31:0] rs_data,
    input [31:0] rt_data,
    input [15:0] offset,
    input [31:0] PC,
    output reg [31:0] PC_next
);
    wire ALU_zero;
    wire [31:0] branch_target = PC + {{14{offset[15]}}, offset, 2'b00};
    // Compare rs and rt using ALU
    assign ALU_zero = (rs_data == rt_data) ? 1 : 0;
    // Update PC based on branch condition
    always @(*) begin
        if (~ALU_zero)
            PC_next = branch_target;
        else
            PC_next = PC + 4;
    end
endmodule
```

In this example, the `BNE_example` module takes the values of rs and rt (`rs_data` and `rt_data`), the branch offset (`offset`), and the current Program Counter (`PC`) as inputs.

It compares rs and rt using the ALU and updates the `PC_next` output based on the branch condition.

If rs and rt are not equal (`ALU_zero` is 0), `PC_next` is set to the branch target address (`branch_target`).

Otherwise, `PC_next` is set to the next sequential instruction address (`PC + 4`).

# Comparing Verilog vs VHDL

The following section will compare the experience of developing a single-cycle processor in Verilog vs VHDL.

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

## Interesting notes about VHDL

While you can do this "print debugging" in VHDL, it is not as easy as it is in Verilog because in VHDL you must deal with the typings of the signals and the fact that you must declare the signals before you can use them.

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
      // ...
END behavior;
```

## Conclusion

I think that VHDL actually provides more flexibility within the development of the processor.

While the language is more verbose because you must reinstantiate a component within another component to use it, it is more type-safe, and allows for more control over the design of the processor.

Verilog is more concise and easier to read, but I think that VHDL is more powerful and allows for more control over the design of the processor because of it's type-safety.

To support this, I present the result of the actual lines of code that were written for the processor in VHDL and Verilog.

VHDL Single Cycle MIPS Processor:
```
Language                         files          blank        comment           code
-----------------------------------------------------------------------------------
VHDL                                65            694           1085           4677
```

Verilog Single Cycle MIPS Processor:
```
Language                         files          blank        comment           code
-----------------------------------------------------------------------------------
Verilog-SystemVerilog               10              0              9            555
```

As you can see, the VHDL processor has almost **10** times the amount of code as the Verilog processor.

Furthermore, I think that the fact that the name of a file in verilog must match the module name is a limitation that VHDL does not have (atleast in our Quartus simulator).

To summarize, I think that VHDL is more suited for larger projects and more complex designs where the type-safety and , while Verilog is more suited for smaller projects and simpler designs.

# Breaking down decoding a signal to 7-segment displays

As the signal representing the instruction is 5 bits long inside the `controller.v` file, we need to decode this signal to display the current instruction on the 7-segment displays.

This means that we need to decode a 5-bit signal to a 35-bit signal that will be used to display the current instruction on the 7-segment displays.

If 5-bits are used to represent the instruction, and 7-bits are needed to represent a character on a 7-segment display, then 35-bits are needed to represent the current instruction on 5 7-segment displays as 7 * 5 = 35.

Furthermore, the longest word that can be displayed on the 7-segment displays is 5 characters long, so 5 * 7 = 35 bits are needed to represent the current instruction on the 7-segment displays.

| Func_in | O_out          | Operation                             | Description                               |
| :---:   | :---:          | :---:                                 | :---:                                     |
| 1000    | ox             | $(A+B)$                               | ADD                                       |
| 1000    | $1 \mathrm{X}$ | $(\mathrm{A}-\mathrm{B})$             | SuB                                       |
| 1001    | 00             | $(A \& B)$                            | AND                                       |
| 1001    | 01             | $(A \mid B)$                          | OR                                        |
| 1001    | $\pi$          | $\sim(\mathrm{A} \mid \mathrm{B})$    | NOR                                       |
| 101     | $\mathrm{xx0}$ | signed $(A)<\operatorname{signed}(B)$ | Set-Less-Than signed                      |
| 101     | $x x 1$        | $A<B$                                 | Set-Less-Than unsigned                    |
| 111     | 000            | A                                     | BLTZ (Branch if Less Than Zero)           |
| 111     | 001            | A                                     | BGEZ (Branch if Greater or Equal to Zero) |
| 111     | 010            | A                                     | J/AL (Jump and Link)                      |
| 111     | 011            | A                                     | JR/AL (Jump Register and Link)            |
| 111     | 100            | A                                     | $\mathrm{BEQ}($ (Branch if Equal)         |
| 111     | 101            | A                                     | BNE (Branch if Not Equal)                 |

The following is the wave-diagram from modelsim/questasim for my test-bench of my processor without the added seven segment displays.

![[Pasted image 20240503061843.png]]

Below is the captured wave-diagram from modelsim/questasim with the seven segment ports included:

![[Pasted image 20240503065359.png]]

The wave-forms show the output of the following test-bench:

```verilog title="mips_tb.v"
`timescale 1ns / 1ps
`define CYCLE_TIME 20
module mips_tb;
  reg clk;
  reg rst;
  // segments for the 7-segment displays
  wire [6:0] seg_first, seg_second, seg_third, seg_fourth, seg_fifth;
  integer i;
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

The given Verilog code represents my test-bench module that was used for testing the single-cycle MIPS processor, `mips.v`.

1. The test-bench module is named `mips_tb` (titled `mips_tb.v`), and it operates on a timescale of 1ns/1ps.

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

The following section will include the schematics for the various components of the MIPS processor as written in verilog.

### Control Unit Schematic

The following is the schematic for the control unit of the MIPS processor.

![[Pasted image 20240503123506.png]]

### Register File

The following is the schematic for the register file of the MIPS processor.

![[Pasted image 20240503124247.png]]

### Data Memory

The following is the schematic for the data memory of the MIPS processor.

![[Pasted image 20240503124336.png]]

### ALU Control

The following is the schematic for the ALU control of the MIPS processor.

![[Pasted image 20240503124621.png]]

### Program Counter Control

The following is the schematic for the program counter control of the MIPS processor.

![[Pasted image 20240503124717.png]]

### ALU

The following is the schematic for the ALU of the MIPS processor.

![[Pasted image 20240503124838.png]]

### Instruction Memory

The following is the schematic for the instruction memory of the MIPS processor.

![[Pasted image 20240503124956.png]]

### Program Counter

The following is the schematic for the program counter of the MIPS processor.
![[Pasted image 20240503125021.png]]

### Waveform

The following is the wave form of the Processor from modelsim/questasim:

![[Pasted image 20240503131222.png]]

# Tooling

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
  integer i;
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

In addition to the tooling already mentioned, I used modelsim/questasim to simulate my processor and test-bench.

Furthermore, I used the Quartus Prime software to compile my code and program my FPGA board.

Even further, I used tools like [ git ](https://git-scm.com/), [ GitHub ](https://github.com), and [ markdown ](https://www.markdownguide.org/) to manage my code, version control, and documentation.

For editor tooling, I used [ NeoVim ](https://neovim.io/) with a combination of popular language servers that are used for VerilogHDL.

These language servers that I used for development include [ verible ](https://github.com/chipsalliance/verible), [ Tree-Sitter ](https://tree-sitter.github.io/tree-sitter/), [ veridian ](https://github.com/vivekmalneedi/veridian), and more to provide completion, syntax highlighting, code actions, linting, and more.

I think that using these language servers and tools in combination with NeoVim (my personal open-sourced config has a startup time of <80ms) allowed me to develop my processor more efficiently and effectively.

## Components and Explanations

The following section explains the components of the MIPS processor and their functionalities.

This is done by providing the Verilog code for each component and explaining its role in the processor.

#### ALU

The following is the code for the ALU module of the MIPS processor called `ALU.v`. (It can be found in the `./proj/` directory)

```verilog title="ALU.v"
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
      o_ALUresult = i_data1 & data2; // bitwise AND
      4'b0001:  // OR
      o_ALUresult = i_data1 | data2; // bitwise OR
      4'b0010:  // ADD
      o_ALUresult = i_data1 + data2; // addition
      4'b0110:  // SUB
      o_ALUresult = i_data1 - data2; // subtraction
      4'b0111:  // SLT
      o_ALUresult = (i_data1 < data2) ? 1 : 0; // set-on-less-than
      4'b1100:  // NOR
      o_ALUresult = i_data1 | ~data2; // bitwise NOR
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

Overall, the ALU module performs the necessary arithmetic and logical operations in the MIPS processor based on the instruction being executed. 

The ALU allows the processor to execute instructions and produce the desired results.

#### Control Unit

The following is the code for the control unit of the MIPS processor called `ControlUnit.v`. (It can be found in the `./proj/` directory)

As named, the `ControlUnit` is responsible for decoding the instruction and generating the control signals for the various components of the processor.

```verilog title="ControlUnit.v"
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

##### IO

The Control Unit, `ControlUnit.v`, has the following inputs and outputs:

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

###### Processor Context:

The following is the context (the purpose and functionality) of the Control Unit in the single-cycle MIPS processor:

1. The Control Unit initializes all control signals to default values in the `initial` block.

2. The `always` block is triggered whenever the `i_instruction` changes. It uses a case statement to determine the type of instruction based on the opcode (bits 31 to 26 of the instruction).

3. Depending on the instruction type, the Control Unit sets the appropriate control signals:
   - For R-type instructions (arithmetic), it sets `RegDst` to 1, enables `RegWrite`, sets `ALUOp` to 2'b10, and displays "ARITH" on the 7-segment displays.
   - For I-type instructions (addi, andi, lw, sw), it sets `ALUSrc` to 1, enables `RegWrite` (except for sw), sets `ALUOp` based on the instruction, and displays the instruction type on the 7-segment displays.
   - For branch instructions (beq, bne), it sets `Branch` to 1, sets `ALUOp` to 2'b01, and displays the instruction type on the 7-segment displays.
   - For the jump instruction, it sets `Jump` to 1, sets `ALUOp` to 2'b01, and displays "J" on the 7-segment displays.

4. If the instruction does not match any of the defined cases, the Control Unit sets all control signals to their default values and displays blank on the 7-segment displays.

The Control Unit is critial to correctly orchestrating the operation of the single-cycle MIPS processor.

It interprets the instruction and generates the necessary control signals to control the data-path components, such as the ALU, Register File, and Data Memory.

The control signals determine the flow of data and the operations performed in each stage of the processor pipeline.

- The Control Unit receives the instruction from the Instruction Memory.
- It sends control signals to various components, such as the ALU, Register File, and Data Memory, to control their behavior based on the instruction being executed.
- The control signals generated by the Control Unit are used by the data-path components to perform the required operations and route the data accordingly.

#### Data Memory

The following is the code for the Data Memory module in the MIPS processor called `DataMemory.v`. (It can be found in the `./proj/` directory)

```verilog title="DataMemory.v"
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
  parameter SIZE_DM = 128;       // size of this memory, by default 128*32
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

The following are the detailed input and output ports of the Data Memory module, `DataMemory.v`:
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

Simply put, the Data Memory module allows storing and retrieving data in the MIPS processor.

It responds to memory read and write requests based on the provided address and control signals, and it interacts with other components such as the ALU, Control Unit, and Register File to facilitate data storage and retrieval operations.

#### Instruction Memory

The following is the code for the Instruction Memory module in the MIPS processor called `InstructionMemory.v`. (It can be found in the `./proj/` directory)

```verilog title="InstructionMemory.v"
`timescale 1ns / 1ps
module InstructionMemory (
    input [31:0] i_Addr,
    output reg [5:0] i_Ctr,          // [31-26]
    output reg [5:0] i_Funcode,      // [5-0]
    output reg [31:0] i_Instruction  // [31-0]
);
  parameter SIZE_IM = 128;           // size of this memory, by default 128*32
  reg [31:0] Imem[SIZE_IM-1:0];      // instruction memory
  integer n;
  initial begin
    for (n = 0; n < SIZE_IM; n = n + 1) begin
      Imem[n] = 32'b11111100000000000000000000000000;
    end
    $readmemb("instructions.mem", Imem);
    i_Instruction = 32'b11111100000000000000000000000000;
  end
  always @(i_Addr) begin
    if (i_Addr == -4) begin         // init
      i_Instruction = 32'b11111100000000000000000000000000;
    end else begin
      i_Instruction = Imem[i_Addr>>2];
    end
    i_Ctr = i_Instruction[31:26];
    i_Funcode = i_Instruction[5:0];
  end
endmodule
```
The provided code represents "the Instruction Memory module `InstructionMemory.v` for the single-cycle MIPS processor."

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

##### Processor Context

The following is the context of the Instruction Memory module, `InstructionMemory.v` in the single-cycle MIPS processor, `mips.v`:

- The Program Counter (`PC`) module provides the memory address (`i_Addr`) to the Instruction Memory module to fetch the instruction at that address.
- The fetched instruction (`i_Instruction`) is then passed to other components of the processor, such as the Control Unit and the Register File, for further processing and execution.
- The control bits (`i_Ctr`) and function code (`i_Funcode`) are used by the Control Unit to generate appropriate control signals for the processor's data-path.

##### Significance

The Instruction Memory module is a crucial component of the MIPS processor as it holds the program instructions that the processor executes.

It provides the instructions to the processor's data-path, enabling the processor to perform the desired operations and execute the program stored in the memory.

##### Summary

Essentially, the Instruction Memory module in the single-cycle MIPS processor acts as a read-only memory that stores the program instructions. It fetches instructions based on the provided memory address and outputs the complete instruction along with its control bits and function code for further processing by other components of the processor.

## Verbose Components Code

The following section shows detailed, commented code files for each of the components of the processor.

It includes detailed code comments to better explain the functionality and purpose of each component within the actual verilog code.

### Data Memory

The following is the commented code for the Data Memory module in the MIPS processor called `DataMemory.v`:

```verilog
// File: DataMemory.v
// Description: This file contains the data memory module for the MIPS processor.
// Purpose: The data memory stores data values and provides read and write access to the processor.
//          It is responsible for handling memory read and write operations based on the control signals
//          received from the control unit.
`timescale 1ns / 1ps
module DataMemory (
    input i_clk,                    // Clock input
    input [31:0] i_addr,            // Address input for memory access
    input [31:0] i_wData,           // Write data input
    input [31:0] i_ALUresult,       // ALU result input (used for memory address calculation)
    input i_MemWrite,               // Control signal for memory write operation
    input i_MemRead,                // Control signal for memory read operation
    input i_MemtoReg,               // Control signal for selecting memory or ALU result as the output
    output reg [31:0] o_rData       // Read data output
);
  parameter SIZE_DM = 128;           // Size of the data memory (default: 128 * 32 bits)
  reg [31:0] Dmem[SIZE_DM-1:0];      // Data memory array
  integer i;
  // Initialize the data memory
  initial begin
    // Fill the data memory with zeros
    for (i = 0; i < SIZE_DM; i = i + 1) begin
      Dmem[i] = 32'b0;
    end
  end
  // Memory read operation
  always @(i_addr or i_MemRead or i_MemtoReg or i_ALUresult) begin
    if (i_MemRead == 1) begin                  // If memory read is enabled
      if (i_MemtoReg == 1) begin               // If MemtoReg is 1, select memory data as output
        o_rData = Dmem[i_addr];                // Read data from the memory array
      end else begin
        o_rData = i_ALUresult;                 // If MemtoReg is 0, select ALU result as output
      end
    end else begin
      o_rData = i_ALUresult;                   // If memory read is not enabled, select ALU result as output
    end
  end
  // Memory write operation
  always @(posedge i_clk) begin                // Triggered on the positive edge of the clock
    if (i_MemWrite == 1) begin                 // If memory write is enabled
      Dmem[i_addr] = i_wData;                  // Write data to the memory array
    end
  end
endmodule
```

Interactions with other components:
- The `DataMemory` module receives the address (`i_addr`), write data (`i_wData`), and control signals (`i_MemWrite`, `i_MemRead`, `i_MemtoReg`) from the `ControlUnit` and `ALU` modules.
- It provides the read data (`o_rData`) to the `RegisterFile` module for store instructions or to the `ALU` for load instructions.
- The `i_ALUresult` input is used as the memory address for read and write operations.
- The `i_MemWrite` control signal determines whether a memory write operation should be performed.
- The `i_MemRead` control signal determines whether a memory read operation should be performed.
- The `i_MemtoReg` control signal selects whether the memory data or the ALU result should be output as the read data.

The `DataMemory` module is critical for providing data storage and handling memory read and write operations.

It interacts with the control unit, ALU, and register file to facilitate data movement and manipulation in the processor.

### Instruction Memory

Here the `ProgramCounter.v` file with detailed code comments explaining its purpose, functionality, and interactions with other components in the MIPS processor:

```verilog
// File: ProgramCounter.v
// Description: This file contains the program counter module for the MIPS processor.
// Purpose: The program counter keeps track of the current instruction address and updates it
//          to the next instruction address on each clock cycle. It is responsible for providing
//          the address of the instruction to be fetched from the instruction memory.
`timescale 1ns / 1ps
module ProgramCounter (
    input i_Clk,                // Input clock signal
    input [31:0] i_Next,        // Input next instruction address
    output reg [31:0] o_Out     // Output current instruction address
);
  // Initialize the program counter
  initial begin
    o_Out = -4;                 // Set the initial address to -4 (used for reset or initialization)
  end
  // Update the program counter on the positive edge of the clock
  always @(posedge i_Clk) begin
    o_Out = i_Next;             // Update the current address with the next address
  end
endmodule
```

Interactions with other components:
- The `ProgramCounter` module receives the next instruction address (`i_Next`) from the `NextProgramCounter` module.
- It provides the current instruction address (`o_Out`) to the `InstructionMemory` module to fetch the corresponding instruction.
- The `ProgramCounter` is updated on the positive edge of the clock signal (`i_Clk`), which is typically connected to the global clock signal of the processor.

The `ProgramCounter` module is a critical component in the MIPS processor pipeline. It keeps track of the current instruction address and updates it on each clock cycle to fetch the next instruction. The program counter ensures the sequential execution of instructions and enables the processor to navigate through the program.

### Program Counter

Here the `ProgramCounter.v` file with detailed code comments explaining its purpose, functionality, and interactions with other components in the MIPS processor:

```verilog
// File: ProgramCounter.v
// Description: This file contains the program counter module for the MIPS processor.
// Purpose: The program counter keeps track of the current instruction address and updates it to the next address.
//          It is responsible for providing the current instruction address to the instruction memory and updating
//          the address based on the next address input.
`timescale 1ns / 1ps
module ProgramCounter (
    input i_Clk,                   // Input clock signal
    input [31:0] i_Next,           // Input next instruction address
    output reg [31:0] o_Out        // Output current instruction address
);
  // Initialize the program counter
  initial begin
    o_Out = -4;                    // Set the initial instruction address to -4
  end
  // Update the program counter on the positive edge of the clock
  always @(posedge i_Clk) begin
    o_Out = i_Next;                // Update the current instruction address with the next address
  end
endmodule
```

Purpose and Functionality:
- The `ProgramCounter` module keeps track of the current instruction address in the MIPS processor.
- It is responsible for providing the current instruction address to the instruction memory (`InstructionMemory`) for fetching the corresponding instruction.
- The program counter is updated on the positive edge of the clock signal (`i_Clk`).
- The next instruction address (`i_Next`) is provided as an input to the module, which is used to update the current instruction address (`o_Out`) on each clock cycle.
- The initial value of the program counter is set to -4, which represents the initial state before the first instruction is fetched.

Interactions with other components:
- The `ProgramCounter` module receives the next instruction address (`i_Next`) from the `NextProgramCounter` module, which calculates the next address based on the current instruction and control signals.
- It provides the current instruction address (`o_Out`) to the `InstructionMemory` module to fetch the corresponding instruction.
- The `ProgramCounter` is updated on the positive edge of the clock signal (`i_Clk`), which is typically connected to the main processor clock.

The `ProgramCounter` module is to manage the flow of execution by keeping track of the current instruction address.

It ensures that instructions are fetched and executed in the correct order by updating the address on each clock cycle based on the next address input provided by the `NextProgramCounter` module.

### ALU

Here the `ALU.v` file with detailed code comments explaining its purpose, functionality, and interactions with other components in the MIPS processor:

```verilog
// File: ALU.v
// Description: This file contains the Arithmetic Logic Unit (ALU) module for the MIPS processor.
// Purpose: The ALU performs arithmetic and logic operations based on the ALU control signals.
//          It takes two input operands (i_data1 and i_read2/immediate value) and performs the specified operation.
//          The ALU also generates a zero flag (o_Zero) to indicate if the result is zero.

`timescale 1ns / 1ps

module ALU (
    input      [31:0] i_data1,        // Input operand 1 (from RegisterFile)
    input      [31:0] i_read2,        // Input operand 2 (from RegisterFile or immediate value)
    input      [31:0] i_Instruction,  // Input instruction (used for sign-extension of immediate value)
    input             i_ALUSrc,       // Control signal to select between i_read2 or immediate value
    input      [ 3:0] i_ALUcontrol,   // Control signal to specify the ALU operation
    output reg        o_Zero,         // Output zero flag (1 if the ALU result is zero, 0 otherwise)
    output reg [31:0] o_ALUresult     // Output ALU result
);
  reg [31:0] data2;
  // Determine the second operand based on the ALUSrc control signal
  always @(i_ALUSrc, i_read2, i_Instruction) begin
    if (i_ALUSrc == 0) begin
      data2 = i_read2;                 // Use i_read2 as the second operand
    end else begin
      // Sign-extend the immediate value
      if (i_Instruction[15] == 1'b0) begin
        data2 = {16'b0, i_Instruction[15:0]};  // Zero-extend if the immediate value is positive
      end else begin
        data2 = {{16{1'b1}}, i_Instruction[15:0]};  // Sign-extend if the immediate value is negative
      end
    end
  end
  // Perform the ALU operation based on the ALUcontrol signal
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
      4'b0111:  // SLT (Set Less Than)
        o_ALUresult = (i_data1 < data2) ? 1 : 0;
      4'b1100:  // NOR
        o_ALUresult = ~(i_data1 | data2);
      default: ;
    endcase
    // Set the zero flag if the ALU result is zero
    o_Zero = (o_ALUresult == 0) ? 1 : 0;
  end

endmodule
```

Interactions with other components:
- The `ALU` module receives input operands (`i_data1` and `i_read2`) from the `RegisterFile` module.
- The `i_ALUSrc` control signal from the `ControlUnit` determines whether the second operand is `i_read2` or an immediate value from the instruction (`i_Instruction`).
- The `i_ALUcontrol` signal from the `ALUControl` module specifies the ALU operation to be performed.
- The `ALU` module outputs the result (`o_ALUresult`) to the `DataMemory` and `RegisterFile` modules for memory access and register writeback.
- The zero flag (`o_Zero`) is used by

### Control Unit

Certainly! Here's a detailed explanation of the Verilog module provided for a Control Unit in a single cycle MIPS processor. Each line of the module is annotated to explain its function and relevance.

```verilog
`timescale 1ns / 1ps
// Defines the time unit as 1 nanosecond and the simulation time precision as 1 picosecond.
module ControlUnit (
    input [31:0] i_instruction,     // 32-bit input for the instruction.
    output reg o_RegDst,            // Determines if rd (1) or rt (0) should be the destination register.
    output reg o_Jump,              // Control signal for jumping to an instruction address.
    output reg o_Branch,            // Control signal for branching (beq).
    output reg o_Bne,               // Control signal for branching not equal (bne).
    output reg o_MemRead,           // Enables reading from memory (used by lw).
    output reg o_MemtoReg,          // Determines if the value should come from memory (1) or ALU (0).
    output reg [1:0] o_ALUOp,       // Control signal for ALU operation type.
    output reg o_MemWrite,          // Enables writing to memory (used by sw).
    output reg o_ALUSrc,            // Determines if the second ALU operand is an immediate (1) or register (0).
    output reg o_RegWrite,          // Enables writing to the register file.
    output reg [6:0] o_seg_first,   // Segment display outputs to visually represent instruction types or states.
    output reg [6:0] o_seg_second,  // Each segment holds a 7-segment representation.
    output reg [6:0] o_seg_third,
    output reg [6:0] o_seg_fourth,
    output reg [6:0] o_seg_fifth
);
initial begin
    // Initialize all control signals and display outputs to their default (usually disabled) states.
    o_RegDst = 0;
    o_Jump = 0;
    o_Branch = 0;
    o_MemRead = 0;
    o_MemtoReg = 0;
    o_ALUOp = 2'b00; // Default ALU operation, no operation specified.
    o_MemWrite = 0;
    o_ALUSrc = 0;
    o_RegWrite = 0;
    o_seg_first = 7'b1111111;  // All segments off (blank).
    o_seg_second = 7'b1111111;
    o_seg_third = 7'b1111111;
    o_seg_fourth = 7'b1111111;
    o_seg_fifth = 7'b1111111;
end
always @(i_instruction) begin
    // Control logic triggered by any change in the instruction input.
    case (i_instruction[31:26]) // Decode the opcode part of the instruction.
      6'b000000: begin  // ARITHMETIC (R-type instructions)
        o_RegDst = 1;
        o_ALUSrc = 0;
        o_MemtoReg = 0;
        o_RegWrite = 1;
        o_MemRead = 0;
        o_MemWrite = 0;
        o_Branch = 0;
        o_Bne = 0;
        o_ALUOp = 2'b10; // Specific ALU operation for arithmetic.
        o_Jump = 0;
        // Display setup for ARITHMETIC.
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
        o_seg_second = 7'b1000010; // d
        o_seg_third = 7'b1000010;  // d
        o_seg_fourth = 7'b1001111; // i
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
        o_seg_second = 7'b0101011; // n
        o_seg_third = 7'b0110000;  // e
        o_seg_fourth = 7'b1111111; // Blank
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
        o_seg_second = 7'b1111111; // Blank
        o_seg_third = 7'b1111111;  // Blank
        o_seg_fourth = 7'b1111111; // Blank
        o_seg_fifth = 7'b1111111;  // Blank
      end
      default: begin
        // Default case sets all outputs to zero or disables them, providing a safe default state.
        o_RegDst = 0;
        o_ALUSrc = 0;
        o_MemtoReg = 0;
        o_RegWrite = 0;
        o_MemRead = 0;
        o_MemWrite = 0;
        o_Branch = 0;
        o_Bne = 0;
        o_ALUOp = 2'b00;
        o_Jump = 0;
        // Display all segments off for undefined instructions.
        o_seg_first = 7'b1111111;  // Blank
        o_seg_second = 7'b1111111; // Blank
        o_seg_third = 7'b1111111;  // Blank
        o_seg_fourth = 7'b1111111; // Blank
        o_seg_fifth = 7'b1111111;  // Blank
      end
    endcase
end

endmodule
```

This code serves as the control logic for a single cycle MIPS processor, managing the routing and operations of data based on the instruction being executed. It adjusts the path and operation of the data in various parts of the processor according to the opcode of the instruction, with added visual output for debugging or educational purposes through a 7-segment display configuration.

### Testbench

Here is the `mips_tb.v` file with detailed code comments explaining its purpose, functionality, and interactions with other components in the MIPS processor:
```verilog
// File: mips_tb.v
// Description: This file contains the testbench for the MIPS processor.
// Purpose: The testbench is used to simulate and verify the functionality of the MIPS processor.
//          It instantiates the MIPS processor module, provides clock and reset signals, and
//          initializes the data memory and register file. It also displays the output on 7-segment displays.
`timescale 1ns / 1ps
`define CYCLE_TIME 20
module mips_tb;
  reg clk;                 // Clock signal
  reg rst;                 // Reset signal
  // Segments for the 7-segment displays
  wire [6:0] seg_first, seg_second, seg_third, seg_fourth, seg_fifth;
  integer i;               // Loop variable
  // Generate clock signal
  always #(`CYCLE_TIME / 2) clk = ~clk;
  // Instantiate the MIPS processor module
  mips uut (
      .i_Clk(clk),
      .i_Rst(rst),
      .o_Seg_first(seg_first),
      .o_Seg_second(seg_second),
      .o_Seg_third(seg_third),
      .o_Seg_fourth(seg_fourth),
      .o_Seg_fifth(seg_fifth)
  );
  // Initialize data memory and register file
  initial begin
    // Initialize data memory
    for (i = 0; i < 32; i = i + 1) begin
      uut.inst_DataMemory.Dmem[i] = 32'b0;
    end
    // Initialize register file
    for (i = 0; i < 32; i = i + 1) begin
      uut.inst_RegisterFile.RegData[i] = 32'b0;
    end
    clk = 0;                // Initialize clock signal
  end
  initial begin
    #1800 $finish;
  end
endmodule
```

Interactions with other components:

- The `mips_tb` module instantiates the `mips` module, which represents the MIPS processor.
- It provides the clock signal (`clk`) to the `mips` module for synchronization.
- The reset signal (`rst`) is not used in this testbench but can be used to reset the processor if needed.
- The testbench initializes the data memory (`inst_DataMemory.Dmem`) and register file (`inst_RegisterFile.RegData`) of the `mips` module to zero.
- The 7-segment display outputs (`seg_first`, `seg_second`, `seg_third`, `seg_fourth`, `seg_fifth`) from the `mips` module are connected to the testbench for monitoring purposes.

The `mips_tb` module serves as a testbench to simulate and verify the functionality of the MIPS processor.

It provides the necessary inputs (clock and reset) and initializes the memory and registers. The testbench can be modified to apply different test cases through loading different binary converted assembly files and allows one to monitor the processor's behavior through the 7-segment display outputs.

## Conclusion

### Conclusion

Each instruction type (R-type, I-type, J-type) generally follows a similar flow with variations primarily in the Execute and Memory Access stages depending on whether the instruction involves arithmetic, memory access, or control flow.

This model provides a consistent framework for understanding how different instructions are processed in the single-cycle MIPS architecture.
