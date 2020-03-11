import serial
import time

def read_until(ser, eol):
	string = b''
	while True:
		r = ser.read()
		#print('got',r)
		string = string + r
		if r == eol:
			break
	return string

def send_text(ser, text):
	for i in text:
		ser.write(i)
		time.sleep(0.001)

def bruteforce(ser):
	start = 7330
	stop  = 10000

	for i in range(start,stop):
		ser.write(b'r')
		#print('starting brute at',i)
		read_until(ser,b':') 
		text = "%04.0i" % i
		#print('sending text',text)
		send_text(ser,text)
		#print('sent')
		resp = read_until(ser,b'\n')
		print('pin',i,'response',resp)
		ser.write('r');


ser = serial.Serial('/dev/ttyUSB1',115200)  # open serial port
print(ser.name)         # check which port was really used

bruteforce(ser)

ser.close()
