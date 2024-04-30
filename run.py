

def register_to_bin(reg: str) -> str:
    """Converts a register string to its binary equivalent."""
    registers = {
        "$zero": "00000",
        "$at": "00001",
        "$v0": "00010",
        "$v1": "00011",
        "$a0": "00100",
        "$a1": "00101",
        "$a2": "00110",
        "$a3": "00111",
        "$t0": "01000",
        "$t1": "01001",
        "$t2": "01010",
        "$t3": "01011",
        "$t4": "01100",
        "$t5": "01101",
        "$t6": "01110",
        "$t7": "01111",
        "$s0": "10000",
        "$s1": "10001",
        "$s2": "10010",
        "$s3": "10011",
        "$s4": "10100",
        "$s5": "10101",
        "$s6": "10110",
        "$s7": "10111",
        "$t8": "11000",
        "$t9": "11001",
        "$k0": "11010",
        "$k1": "11011",
        "$gp": "11100",
        "$sp": "11101",
        "$fp": "11110",
        "$ra": "11111",
    }
    return registers.get(reg, "00000")


def instruction_to_binary(instruction: str) -> str:  # type: ignore[return]
    """Converts an assembly instruction to its binary equivalent."""
    parts = instruction.split()
    op = parts[0]
    opcode = ""
    rs = ""
    rt = ""
    rd = ""
    shamt = "00000"
    funct = ""

    if op in ["add", "sub", "and", "or"]:
        opcode = "000000"
        immediate = "00000000000"
        rd = register_to_bin(parts[1])
        rs = register_to_bin(parts[2])
        rt = register_to_bin(parts[3])
        if op == "add":
            funct = "100000"
        elif op == "sub":
            funct = "100010"
        elif op == "and":
            funct = "100100"
        elif op == "or":
            funct = "100101"
    elif op == "addi":
        opcode = "001000"
        rt = register_to_bin(parts[1])
        rs = register_to_bin(parts[2])
        immediate = f"{int(parts[3]):016b}"
    else:
        raise ValueError(f"Invalid instruction: {instruction}")

    if op in ["add", "sub", "and", "or"]:
        return f"{opcode}{rs}{rt}{rd}{shamt}{funct}"
    elif op == "addi":
        return f"{opcode}{rs}{rt}{immediate}"


def binary_to_little_endian(binary: str) -> str:
    """Converts a binary string to little endian hex format."""
    hex_value = f"{int(binary, 2):08x}"
    little_endian = "".join(
        reversed([hex_value[i: i + 2] for i in range(0, len(hex_value), 2)])
    )
    return little_endian


def convert_instructions(instructions: list[str]) -> list[str]:
    """Converts a list of MIPS assembly instructions to little endian hex."""
    binaries = [instruction_to_binary(instr) for instr in instructions]
    little_endian_hexes = [binary_to_little_endian(
        binary) for binary in binaries]
    return little_endian_hexes


# Example usage:
instructions = [
    "add $t0 $t1 $t2",
    "sub $s1 $s2 $s3",
    "and $a0 $a1 $a2",
    "or $v0 $v1 $v2",
    "addi $t0 $t1 16",
    "addi $s1 $s2 32",
    "addi $a0 $a1 64",
    "add $t0 $t1 $t2",
    "sub $s1 $s2 $s3",
    "and $a0 $a1 $a2",
    "or $v0 $v1 $v2",
    "addi $t0 $t1 16",
    "addi $s1 $s2 32",
    "addi $a0 $a1 64",
]

converted = convert_instructions(instructions)
for instr, hex_value in zip(instructions, converted):
    print(f"{instr} -> {hex_value}")
