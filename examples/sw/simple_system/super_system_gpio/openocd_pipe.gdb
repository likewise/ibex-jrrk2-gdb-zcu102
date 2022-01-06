target extended-remote | /opt/openocd/bin/openocd -c "gdb_port pipe; log_output openocd.log" -f zynqmp_bscane2_ibex.cfg
quit

set pagination off
layout split
load
break main
#echo \n
#echo GDB will break at main. Type "next" <enter> to proceed to the next C line.
#echo \n
cont


