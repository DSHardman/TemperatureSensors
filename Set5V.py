import nidaqmx as ni
from nidaqmx.constants import TerminalConfiguration

#  Set positive rail to 5V
with ni.Task() as task:
    task.ao_channels.add_ao_voltage_chan("Dev1/ao0")
    task.write(5)
