import struct

def ieee754_32bit_to_float(binary_str):
    # Ensure that the input is exactly 32 bits
    if len(binary_str) != 32:
        raise ValueError("Input must be a 32-bit binary string.")
    
    # Convert the binary string to an integer
    int_rep = int(binary_str, 2)
    
    # Use struct to pack the integer and unpack it as a float
    packed = int_rep.to_bytes(4, byteorder='big')  # 4 bytes (32 bits)
    float_num = struct.unpack('!f', packed)[0]  # Unpack as float (32-bit)
    
    return float_num

# # Example usage:
# binary_str = '00111111000000000000000000000000'  # Example binary for 0.5
# float_num = ieee754_32bit_to_float(binary_str)
# print(f"Float representation of {binary_str}: {float_num}")

