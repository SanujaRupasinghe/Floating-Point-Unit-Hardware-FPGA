from Encode import float_to_ieee754_32bit
from Decode import ieee754_32bit_to_float
from  Tx import transmit_raw_byte

a = input("Enter first floating point number: ")
b = input("Enter second floating point number: ")
op = input("Enter operation (+, -, *, /): ")


if op == '+':
    x = (float(a) + float(b))
elif op == '-':
    x = (float(a) - float(b))
elif op == '*':
    x = (float(a) * float(b))
elif op == '/':
    x = (float(a) / float(b))
else:
    x = ("Invalid operation")

print(f"The output should be: {x}")

a_32 = float_to_ieee754_32bit(float(a))
b_32 = float_to_ieee754_32bit(float(b))

OpDict = {
    "+": "11110000", 
    "-": "00001111",  
    "*": "00110011",  
    "/": "11001100"  
}

op_8 = OpDict.get(op)

# Function to split binary string into 4 bytes
def split_into_bytes(binary_str):
    bytes_list = []
    for i in range(0, 32, 8):
        byte = binary_str[i:i+8]
        bytes_list.append(byte) 
    return bytes_list


a_bytes = split_into_bytes(a_32)
b_bytes = split_into_bytes(b_32)

op_byte = op_8

byte_list = a_bytes + b_bytes + [op_byte]

# print("Byte list:", byte_list)
# byte_list = ['11110000', '00001111', '01010101', '10101010', '11001100', '00110011', '10011001', '01100110', '01010101']
# byte_list = ['11111111', '00000000', '11111111', '00000000', '11111111', '00000000', '11111111', '00000000', '11111111']


for byte in byte_list:
    transmit_raw_byte(byte)

