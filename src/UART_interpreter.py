import serial

ser = serial.Serial('/dev/ttyTHS1', 115200)

#ser.port('/dev/ttyTHS1')

#ser.baudrate = 115200

if not ser.isOpen():
	ser.open()

#data_file = open('imu_data.txt', 'a')

while(True):
    line = ser.readline()

    print(str(line).strip('b\'\\r\\n'))

    #data_file.write(line)
