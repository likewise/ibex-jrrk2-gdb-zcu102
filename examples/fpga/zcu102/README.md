# Ibex RISC-V Core SoC Example

Please see [examples](https://ibex-core.readthedocs.io/en/latest/examples.html "Ibex User Manual") for a description of this example.

## Maintainer

Leon Woestenberg <leon@sidebranch.com>

## Disclaimer

This ZCU102 port is based on the Arty A7 example. There is no MMCM/PLL in the clock generation; a 125 MHz clock input is used.

## Requirements

### Tools

  - RV32 compiler
  - srecord
  - `fusesoc` and its dependencies
  - Xilinx Vivado
  - OpenOCD
   
  Tested with lowrisc-toolchain-gcc-rv32imc-20210412-1, Vivado 2020.2, OpenOCD 0.11.0.
  (Older versions of OpenOCD will not work.)

   srecord, fusesoc, vivado tools must be in the current PATH 

   https://github.com/lowRISC/lowrisc-toolchains/releases/download/20210412-1/lowrisc-toolchain-gcc-rv32imc-20210412-1.tar.xz

   Currently some paths are hard-coded as follows in the Makefile and .vscode/*

   /opt/lowrisc-toolchain-gcc-rv32imc-20210412-1/bin/riscv32-unknown-elf-gcc
   /opt/openocd/bin/openocd

### Hardware

  - Xilinx ZCU102 board

## Build

The easiest way to build and execute this example is to call the following make goals from the root directory.

```
make build-zcu102 program-zcu102
```

### Software

First the software must be built. Go into `examples/sw/simple_system/super_system_gpio` and call:

```
make CC=/opt/lowrisc-toolchain-gcc-rv32imc-20210412-1/bin/riscv32-unknown-elf-gcc
```

The setting of `CC` is only required if `riscv32-unknown-elf-gcc` is not available through the `PATH` environment variable.
CC may be a differently named GCC compiler (CC=riscv32-my-elf-gcc), and/or prefixed with a file path (CC=/mypath/riscv32-my-elf-gcc).

This should produce a `super_system_gpio.vmem` file which is used in the synthesis to update the SRAM storage.

### Hardware

Run the following command at the top level to build the respective hardware.

```
fusesoc --cores-root=. run --target=synth --setup --build lowrisc:ibex:top_zcu102
```

This will create a directory `build` which contains the output files, including
the bitstream.

## Program FPGA

After the board is connected to the computer it can be programmed with:

```
fusesoc --cores-root=. run --target=synth --run lowrisc:ibex:top_zcu102
```

PL LEDs 0,1,4,5 and LEDs 3,4,6,7 blink alternately after the FPGA programming is finished.

## Debug

### Verify OpenOCD connection

First, verify that OpenOCD is version 0.11.0 and can connect to the Ibex debug module:

openocd -f ./examples/fpga/zcu102/openocd_zynqmp_bscane2.cfg Open On-Chip Debugger 0.11.0
Licensed under GNU GPL v2
For bug reports, read
        http://openocd.org/doc/doxygen/bugs.html
force hard breakpoints
none separate

Info : Listening on port 6666 for tcl connections
Info : Listening on port 4444 for telnet connections
Info : clock speed 5000 kHz
Info : JTAG tap: uscale.tap tap/device found: 0x5ba00477 (mfg: 0x23b (ARM Ltd), part: 0xba00, ver: 0x5)
Info : JTAG tap: uscale.ps tap/device found: 0x24738093 (mfg: 0x049 (Xilinx), part: 0x4738, ver: 0x2)
Info : JTAG tap: uscale.tap tap/device found: 0x5ba00477 (mfg: 0x23b (ARM Ltd), part: 0xba00, ver: 0x5)
Info : JTAG tap: uscale.ps tap/device found: 0x24738093 (mfg: 0x049 (Xilinx), part: 0x4738, ver: 0x2)
Info : datacount=2 progbufsize=8
Info : Examined RISC-V core; found 1 harts
Info :  hart 0: XLEN=32, misa=0x40101104
Info : starting gdb server for uscale.ps on 3333
Info : Listening on port 3333 for gdb connections

Press CTRL-C to stop OpenOCD.

### Debug with GDB (textual interface)

If the above works, you can continue to debug. A "debug" Makefile target is available as an
example textual GDB interface:

make -C examples/sw/simple_system/super_system_gpio debug

Optionally, you can provide the cross-compiler and OpenOCD 0.11 executable as follows:
make -C examples/sw/simple_system/super_system_gpio debug CC=/opt/lowrisc-toolchain-gcc-rv32imc-20210412-1/bin/riscv32-unknown-elf-gcc OPENOCD=/opt/openocd/bin/openocd

The expected output should end with:

=====
>>> GDB will break at main. Type 'next' <enter> to proceed to the next C line. <<<

Breakpoint 1 at 0x100618: file super_system_gpio.c, line 40.
Continuing.

Breakpoint 1, main (argc=0, argv=0x0) at super_system_gpio.c:40
(gdb)
=====

Type 'next' <enter> to proceed to the next line, or type 'cont' <enter> to continue.

### Debug with VSCode GDB

Upcoming. Working quite nicely already.
