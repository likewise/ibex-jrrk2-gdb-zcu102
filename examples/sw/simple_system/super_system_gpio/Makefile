# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Generate a baremetal application and demonstrate debugging.

# Name of the program $(PROGRAM).c will be added as a source file
PROGRAM = super_system_gpio
PROGRAM_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
# Any extra source files to include in the build. Use the upper case .S
# extension for assembly files
EXTRA_SRCS :=

# Tested with this toolchain release
 # make CC=/opt/lowrisc-toolchain-gcc-rv32imc-20210412-1/bin/riscv32-unknown-elf-gcc

include ${PROGRAM_DIR}/../common/common.mk

# First make target rebuilds without optimizations for debugging.
# With GCC/GDB 9.2.0 -O0 gives better debugging experience than -Og
debug-build: PROGRAM_CFLAGS += -O0
debug-build: clean all
	# Generate assembly listing with line numbers. This can
	# also be used by VSCode Disassembly Explorer during debug.
	$(OBJDUMP) -S -l -d ${PROGRAM}.elf > ${PROGRAM}.S

# Debug the program using GDB, which starts OpenOCD (0.11.0+ required) with GDB pipe
debug: debug-build
	$(GDB) \
	-ex "target extended-remote | /opt/openocd/bin/openocd -c \"gdb_port pipe; log_output openocd.log\" -f ../../../fpga/zcu102/openocd_zynqmp_bscane2.cfg" \
	-ex "set remote hardware-breakpoint-limit 2" \
	-ex "set pagination off" \
	-ex "layout split" \
	-ex "load" \
	-ex "echo \\n" \
	-ex "echo >>> GDB will break at main. Type 'next' <enter> to proceed to the next C line. <<<\\n" \
	-ex "echo \\n" \
	-ex "break main" \
	-ex "cont" \
	-ex "next" \
	$(PROGRAM).elf

release-build: clean all

