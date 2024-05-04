Refactor the plantuml diagram for a single cycle mips processor found below:

@startuml

scale 350 width

state ProgramCounter {

    [*] --> Fetch

    Fetch --> Decode : IncrementPC

}

state Decode {

    [*] --> ReadRegisters

    ReadRegisters --> Execution : RegisterValues

}

state Execution {

    [*] --> ALU

    ALU --> MemoryStage : ALUResult

    ALU --> WriteBack : RTypeOperation / RegDst, ALUOp, ALUSrc

}

state MemoryStage {

    [*] --> DataMemory

    DataMemory --> WriteBack : LW

    DataMemory --> ProgramCounter : SW / MemWrite

}

state WriteBack {

    [*] --> ProgramCounter : ResultToReg / MemtoReg, RegWrite

}

state ProgramCounter {

    [*] --> NextPC

    NextPC --> Fetch : UpdatePC / Jump, Branch, Bne

}

state ALU {

    state Control {

        [*] --> Compute

        Compute --> Result : SetControlSignals

    }

    Control --> UpdateFlags : ComputeOutcome

}

state DataMemory {

    [*] --> AccessMemory

    AccessMemory --> Return : MemRead, MemWrite

}

state ControlUnit {

    [*] --> ControlSignals

    ControlSignals --> Decode : SetFlags

    ControlSignals --> Execution : ControlPaths

    ControlSignals --> MemoryStage : MemoryControl

}

state NextPC {

    [*] --> EvaluateBranch

    EvaluateBranch --> UpdatePC : BranchCondition

    EvaluateBranch --> Fetch : DefaultIncrement

}

state "Instruction Flow" as IF {

    state "R-type" as Rtype {

        [*] --> Decode

        Decode --> Execution : FunctionCode

        Execution --> WriteBack : Add, Sub, And, Or, Nor

    }

    state "I-type" as Itype {

        [*] --> Decode

        Decode --> Execution : Opcode

        Execution --> MemoryStage : LW, SW, Addi, Andi, Ori

        MemoryStage --> WriteBack : MemtoReg

        MemoryStage --> ProgramCounter : Bne, Beq

    }

    state "J-type" as Jtype {

        [*] --> Decode

        Decode --> NextPC : J

    }

}

ProgramCounter --> Decode : FetchInstruction

Decode --> Execution : DecodeInstruction

Execution --> MemoryStage : ExecuteOperation

MemoryStage --> WriteBack : AccessMemory

WriteBack --> NextPC : UpdateRegisters

ControlUnit --> ProgramCounter : ControlFlow

ControlUnit --> Decode

ControlUnit --> Execution

ControlUnit --> MemoryStage

@enduml
