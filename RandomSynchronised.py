import waypoints as wp
import kg_robot as kgr
import time
import numpy as np
import random
import nidaqmx as ni
from nidaqmx.constants import TerminalConfiguration

timebefore = 1
timedown = 1.5
timepressed = 5
timeup = 1.5
timeafter = 1
# depth = 0.001
dt = 0.05

upperbound = 34.5 * 0.001  # Only probes a square of side length 34.5mm

duration = timebefore + timeafter + timedown + timeup + timepressed
samplesdown = int(timedown/dt)
samplesup = int(timeup/dt)

# NEW ZEROPOSE REQUIRED AT BOTTOM LEFT CORNER
#zeropose = [-0.0718167, -0.443351, 0.0075692, -1.45804, 2.77907, 0.00753163]

#  Connect to UR5
urnie = kgr.kg_robot(port=30010, db_host="169.254.150.50")
urnie.set_tcp(wp.probing_tcp)


#  Set positive rail to 5V
with ni.Task() as task:
    task.ao_channels.add_ao_voltage_chan("Dev1/ao0")
    task.write(5)

for i in range(5000):  # Record 5000 probes

    # Random xy positions & depth
    x = random.random()*upperbound
    y = random.random()*upperbound
    depth = random.choice([0.0005, 0.001, 0.0015])
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
        task.ai_channels.add_ai_voltage_chan("Dev1/ai0:7", terminal_config=TerminalConfiguration.RSE)

        urnie.movel(poses[0], acc=0.02, vel=0.02)
        data = np.zeros((int(duration/dt), 1))*[0, 0, 0, 0, 0, 0, 0, 0]
        times = np.zeros((int(duration/dt), 1))
        t0 = time.time()
        for k in range(0, int(duration/dt)):
            urnie.servoj(poses[k], control_time=dt, lookahead_time=0.2)
            data[k] = task.read()
            times[k] = time.time() - t0
            while time.time() - t0 < dt*(k+1):
                continue

    urnie.movel(startingpose, acc=0.02, vel=0.02)

    # Save data
    np.save('rand/rawdata/response'+str(i), data)
    np.save('rand/rawdata/poses'+str(i), poses)
    np.save('rand/rawdata/times'+str(i), times)
    np.save('rand/rawdata/xy'+str(i), xy)

    print(i)

urnie.close()