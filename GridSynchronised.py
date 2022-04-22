import waypoints as wp
import kg_robot as kgr
import time
import serial
import numpy as np
import random
import nidaqmx as ni
from nidaqmx.constants import TerminalConfiguration

com = "COM3"  # Of probe

timebefore = 1
timedown = 1.5
timepressed = 10
timeup = 1.5
timeafter = 5
# depthlower = 0.001
# depthupper = 0.003
depth = 0
dt = 0.05

duration = timebefore + timeafter + timedown + timeup + timepressed
samplesdown = int(timedown/dt)
samplesup = int(timeup/dt)

zeropose = [0.181232, -0.553783, -0.00687646, 3.0947, 0.420936, -0.0594446]

#  Connect to UR5
urnie = kgr.kg_robot(port=30010, db_host="169.254.150.50")
urnie.set_tcp(wp.probing_tcp)


# # Connect to probe COM port
if 'ser' in globals() and not ser.isOpen():
    ser = serial.Serial(port=com, baudrate=9600)
elif 'ser' in globals() and ser.isOpen():
    ser.flushInput()
    ser.flushOutput()
else:
    ser = serial.Serial(port=com, baudrate=9600)


#  Set positive rail to 5V
with ni.Task() as task:
    task.ao_channels.add_ao_voltage_chan("Dev1/ao0")
    task.write(5)

for i in range(0, 36, 3):  # Probe each mm of grid
    for l in range(0, 36, 3):

        x = i * 0.001
        y = l * 0.001
        #depth = random.choice([0.0005, 0.001, 0.0015])
        # depth = random.random()*(depthupper - depthlower) + depthlower
        xy = [x, y, depth]
    
        # Control press using defined variables
        startingpose = np.add(zeropose, [x, y, 0.01, 0, 0, 0])
        urnie.movel(startingpose, acc=0.02, vel=0.02)

        poses = 0
        poses = np.ones((int(duration/dt), 1))*startingpose

        for j in range(int(timebefore/dt), int(timebefore/dt) + samplesdown):
            poses[j] = np.add(poses[j], [0, 0, -(depth+0.01)*(j - int(timebefore/dt))/samplesdown, 0, 0, 0])

        for j in range(int(timebefore/dt) + samplesdown, int((timebefore+timedown+timepressed)/dt)):
            poses[j] = np.add(poses[j], [0, 0, -(depth+0.01), 0, 0, 0])

        for j in range(int((timebefore+timedown+timepressed)/dt), int((timebefore+timedown+timepressed)/dt) + samplesup):
            poses[j] = np.add(poses[j], [0, 0, -(depth+0.01) + ((depth+0.01)*(j - int((timebefore+timedown+timepressed)/dt))/samplesup),
                                         0, 0, 0])

        urnie.movel(poses[0], acc=0.02, vel=0.02)

        # Measure and record sensor data
        with ni.Task() as task:
            task.ai_channels.add_ai_voltage_chan("Dev1/ai0:15", terminal_config=TerminalConfiguration.RSE)

            urnie.movel(poses[0], acc=0.02, vel=0.02)
            data = np.zeros((int(duration/dt), 1))*[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            times = np.zeros((int(duration/dt), 1))
            t0 = time.time()
            temp = ser.readline()
            for k in range(0, int(duration/dt)):
                urnie.servoj(poses[k], control_time=dt, lookahead_time=0.2)
                data[k] = task.read()
                times[k] = time.time() - t0
                while time.time() - t0 < dt*(k+1):
                    continue

        urnie.movel(startingpose, acc=0.02, vel=0.02)

        # Save data
        np.save('grid/rawdata/response100'+'_'+str(i)+'_'+str(l), data)
        np.save('grid/rawdata/poses100'+'_'+str(i)+'_'+str(l), poses)
        np.save('grid/rawdata/times100'+'_'+str(i)+'_'+str(l), times)
        np.save('grid/rawdata/xy100'+'_'+str(i)+'_'+str(l), xy)
        np.save('grid/rawdata/temp100'+'_'+str(i)+'_'+str(l), float(temp))

        print(i)
        print(l)

urnie.close()
