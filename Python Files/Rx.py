import serial
from Decode import ieee754_32bit_to_float

EXPECTED_BYTES = 4

ser = serial.Serial(
    port='COM7',  
    baudrate=115200,  
    timeout=1 
)

binary_data_str = ""

def receive_uart_data():
    received_bytes = 0
    global binary_data_str
    try:
        while True:
            byte = ser.read(1)

            if byte:
                byte_value = int.from_bytes(byte, byteorder='big')
                binary_string = f'{byte_value:08b}'
                binary_data_str += binary_string
                print(f'Received byte: {binary_string}')
                received_bytes += 1

                if received_bytes == EXPECTED_BYTES:
                    break

    finally:
        ser.close()


receive_uart_data()
print(binary_data_str)
output_32 = binary_data_str[:32]

float_num = ieee754_32bit_to_float(output_32)

print(f"Float representation is : {float_num}")