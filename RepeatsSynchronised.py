import waypoints as wp
import kg_robot as kgr
import time
import serial
import numpy as np
import random
import nidaqmx as ni
from nidaqmx.constants import TerminalConfiguration

com = "COM3"  # Of probe

# LINES 39 & 40 CHANGE WHICH POINT IS BEING PROBED

timebefore = 1
timedown = 1.5
timepressed = 100
timeup = 1.5
timeafter = 50
dt = 0.05

duration = timebefore + timeafter + timedown + timeup + timepressed
samplesdown = int(timedown/dt)
samplesup = int(timeup/dt)


#zeropose = [0.191144, -0.538177, -0.00425192, 3.12038, 0.12705, -0.0570452]
zeropose = [0.175174, -0.557184, -0.00322906, -3.12655, -0.121154, 0.0856744]  # large
[0.175567, -0.552788, 0.0102927, -3.1266, -0.12114, 0.0857483]

#  Connect to UR5
urnie = kgr.kg_robot(port=30010, db_host="169.254.150.50")
urnie.set_tcp(wp.probing_tcp)

# print(urnie.getl())

# Connect to probe COM port
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

for i in range(5):  # Same location probed 1000 times

    # Repeated xy positions & depth
    #x = 0.0206 #as
    #y = 0.00625

    #x = 0.025
    #y = 0.01

    #x = 0
    #y = 0.0025

    x = 0.041  # al
    y = 0.039

    # x = 0.051  # bl
    # y = 0.02849

    # x = 0  #cl
    # y = 0.0044

    depth = 0.004
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
    np.save('rep/rawdata/response_b4l_100_s_'+str(i), data)
    np.save('rep/rawdata/poses_b4l_100_s_'+str(i), poses)
    np.save('rep/rawdata/times_b4l_100_s_'+str(i), times)
    np.save('rep/rawdata/xy_b4l_100_s_'+str(i), xy)
    np.save('rep/rawdata/temp_b4l_100_s_' + str(i), float(temp))

    print(i)

urnie.close()
