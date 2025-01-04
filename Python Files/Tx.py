import serial
import time

ser = serial.Serial( 
    port='COM7', 
    baudrate=115200,  
    timeout=1 
)

if not ser.is_open:
    ser.open()

def transmit_raw_byte(input_data):
    byte_data = bytes([int(input_data, 2)]) 
    time.sleep(0.01)
    ser.write(byte_data)  
    print(f"Transmitted byte: {input_data}")

