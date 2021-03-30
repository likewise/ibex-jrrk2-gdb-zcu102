# Ibex RISC-V Core SoC Example

Please see [examples](https://ibex-core.readthedocs.io/en/latest/examples.html "Ibex User Manual") for a description of this example.

## Disclaimer

This ZCU102 port is based on the Arty A7 example, but is not finished yet. There is no
MMCM/PLL clock generation, the CDC constraints could be improved, the auto generation
not verified, there is no make support yet.

What should work: Starting with the Arty design, manually replacing the top-level,
constraints and clkgen, should get the LED example to work. This was verified.

## Requirements

### Tools

  - RV32 compiler
  - srecord
  - `fusesoc` and its dependencies
  - Xilinx Vivado

### Hardware

  - Xilinx ZCU102 board

## Build

The easiest way to build and execute this example is to call the following make goals from the root directory.

```
make build-zcu102 program-zcu102
```

### Software

First the software must be built. Go into `examples/sw/led` and call:

```
make CC=/path/to/RISC-V-compiler
```

The setting of `CC` is only required if `riscv32-unknown-elf-gcc` is not available through the `PATH` environment variable.
The path to the RV32 compiler `/path/to/RISC-V-compiler` depends on the environment.
For example, it can be for example `/opt/riscv/bin/riscv-none-embed-gcc` if the whole path is required or simply the name of the executable if it is available through the `PATH` environment variable.

This should produce a `led.vmem` file which is used in the synthesis to update the SRAM storage.

### Hardware

Run the following command at the top level to build the respective hardware.

```
fusesoc --cores-root=. run --target=synth --setup --build lowrisc:ibex:top_zcu102
```

This will create a directory `build` which contains the output files, including
the bitstream.

## Program

After the board is connected to the computer it can be programmed with:

```
fusesoc --cores-root=. run --target=synth --run lowrisc:ibex:top_zcu102
```

LED1/LED3 and LED0/LED2 should alternately be on after the FPGA programming is finished.

## Debug

The following does not work yet:

Goal is to debug the RISC-V core using GDB using OpenOCD and BusBlaster v2.5 using the PL PMOD 1
connector on the ZCU102 board, later possibly re-using the BSCANE2 onboard JTAG.

  assign jtag_tck_i   = PMOD1_0;
  assign jtag_tms_i   = PMOD1_1;
  assign jtag_td_i    = PMOD1_2;
  assign jtag_td_o    = PMOD1_3;
  assign jtag_trst_ni = PMOD1_4;

https://iis-git.ee.ethz.ch/balasr/pulpissimo/-/tree/72a4aa8d66752dcbd6028d0820a4e434bc7ddf08

Bus 001 Device 012: ID 0403:6010 Future Technology Devices International, Ltd FT2232C/D/H Dual UART/FIFO IC
/usr/share/openocd/scripts/interface/ftdi/dp_busblaster.cfg

sudo /opt/riscv-openocd/bin/openocd -f examples/fpga/zcu102/openocd_pmod_busblaster.cfg

http://dangerousprototypes.com/docs/Bus_Blaster_v2_design_overview

https://www.xilinx.com/support/documentation/boards_and_kits/zcu102/ug1182-zcu102-eval-bd.pdf