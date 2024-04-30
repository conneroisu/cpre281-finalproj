
def generate_memh_file(file_path: str, num_bytes: int) -> None:
    with open(file_path, 'w') as file:
        for addr in range(num_bytes):
            # Format each address as a two-digit hexadecimal number
            hex_value = f"{addr % 256:02X}"
            # Write to file with a comment indicating the memory address
            file.write(f"{hex_value}")

# Usage example: generate a 4KB memory initialization file
generate_memh_file("ram.memh", 4096)
