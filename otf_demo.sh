#!/bin/bash

x-terminal-emulator -e "bash -c 'roscore;exec $SHELL'"
x-terminal-emulator -e "bash -c 'rosrun urg_node urg_node _ip_address:=192.168.2.15;exec $SHELL'"
x-terminal-emulator -e "bash -c 'rosrun urg_node urg_node _ip_address:=192.168.3.15 __name:=back_urg_node /scan:=/back_scan;exec $SHELL'"
x-terminal-emulator -e "bash -c 'rosrun final_project broadcaster_imu;exec $SHELL'"
x-terminal-emulator -e "bash -c 'roslaunch final_project matcher.launch;exec $SHELL'"

x-terminal-emulator -e "bash -c 'roslaunch line_detecter line_detecter_new.launch;exec $SHELL'"
x-terminal-emulator -e "bash -c 'python3 $HOME/OTF/PretrainedMDNController.py;exec $SHELL'"
x-terminal-emulator -e "bash -c 'python3 $HOME/InputModule/InputModule.py;exec $SHELL'"

x-terminal-emulator -e "bash -c 'rosrun rosserial_python serial_node.py /dev/ttyACM0;exec $SHELL'"
x-terminal-emulator -e "bash -c 'rosrun otf talker.py;exec $SHELL'"
x-terminal-emulator -e "bash -c 'rosrun otf controller.py;exec $SHELL'"
