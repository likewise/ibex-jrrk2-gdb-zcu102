# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Generate a baremetal application

# Name of the program $(PROGRAM).c will be added as a source file
PROGRAM = super_system_gpio
PROGRAM_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
# Any extra source files to include in the build. Use the upper case .S
# extension for assembly files
EXTRA_SRCS :=

# Tested with this toolchain release
#CC = /opt/lowrisc-toolchain-gcc-rv32imc-20210412-1/bin/riscv32-unknown-elf-gcc

include ${PROGRAM_DIR}/../common/common.mk

# (Re)build without optimizations debugging purposes
# With GCC/GDB 9.2.0 -O0 gives better debugging experience than -Og
debug-build: PROGRAM_CFLAGS := -O0
debug-build: clean all
	echo $(OBJDUMP)
	# Generate assembly listing with line numbers. This can
	# also be used by VSCode Disassembly Explorer during debug.
	$(OBJDUMP) -S -l -d ${PROGRAM}.elf > ${PROGRAM}.S

release: clean all
