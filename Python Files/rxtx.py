import serial
import threading
import time

# Configure your serial port (adjust the port name, baudrate, and timeout as per your setup)
serial_port = "COM3"  # On Windows, it may be something like "COM3"
baud_rate = 115200

# Initialize the serial connection
ser = serial.Serial(serial_port, baud_rate, timeout=1)

# Function for transmitting (TX) data
def transmit_data():
    while True:
        data_to_send = input("Enter data to send (TX): ")
        ser.write(data_to_send.encode())  # Send data over USB
        print(f"Data sent: {data_to_send}")
        time.sleep(1)  # Delay to avoid flooding the communication

# Function for receiving (RX) data
def receive_data():
    while True:
        if ser.in_waiting > 0:
            received_data = ser.readline().decode().strip()  # Read the incoming data
            print(f"Data received (RX): {received_data}")

# Create two threads: one for TX and one for RX
tx_thread = threading.Thread(target=transmit_data)
rx_thread = threading.Thread(target=receive_data)

# Start both threads
tx_thread.start()
rx_thread.start()

# Join threads to keep the main program running
tx_thread.join()
rx_thread.join()
