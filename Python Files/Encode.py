import struct

def float_to_ieee754_32bit(num):
    # Use the struct package to pack the float as IEEE 754 binary format
    packed = struct.pack('!f', num)  # Pack as float (32-bit) in big-endian format
    # Convert the packed bytes into an integer
    int_rep = int.from_bytes(packed, byteorder='big')
    
    # Format the integer as a 32-bit binary string
    binary_rep = f'{int_rep:032b}'
    
    return binary_rep  # Return the binary string, not a tuple
    

# # Example usage:
# num = 0.5
# ieee754_rep = float_to_ieee754_32bit(num)
# print(f"IEEE 754 32-bit representation of {num}:")
# print(f"Binary: {ieee754_rep}")