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

  Tools must be in the current PATH (riscv32-unknown-elf-gcc, srecord, fusesoc, vivado).
  Tested with lowrisc-toolchain-gcc-rv32imc-20210412-1, Vivado 2020.2.

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
make CC=/path/to/RISC-V-compiler
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

Debug support is work-in-progress (with good results already).
