import pyserial 
import serial


def bruteforce(ser):
	start = 0
	stop  = 10000

	for i in ragen(start,stop):
		ser.read_until(b'\0')
		ser.write("%05.0i" % i)
		resp = ser.read_until(b'\0')
		print('pin',i,'response',resp)
		ser.write('R');


ser = serial.Serial('/dev/ttyUSB0',115200)  # open serial port
print(ser.name)         # check which port was really used

bruteforce(ser)

ser.close()
