// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "simple_system_common.h"

#define CLK_FIXED_FREQ_HZ (50ULL * 1000 * 1000)
#define GPIO_OUT 0x80000000

/**
 * Delay loop executing within 8 cycles on ibex
 */
static void delay_loop_ibex(unsigned long loops) {
  int out; /* only to notify compiler of modifications to |loops| */
  asm volatile(
      "1: nop             \n" // 1 cycle
      "   nop             \n" // 1 cycle
      "   nop             \n" // 1 cycle
      "   nop             \n" // 1 cycle
      "   addi %1, %1, -1 \n" // 1 cycle
      "   bnez %1, 1b     \n" // 3 cycles
      : "=&r" (out)
      : "0" (loops)
  );
}

static int usleep_ibex(unsigned long usec) {
  unsigned long usec_cycles;
  usec_cycles = CLK_FIXED_FREQ_HZ * usec / 1000 / 1000 / 8;

  delay_loop_ibex(usec_cycles);
  return 0;
}

static int usleep(unsigned long usec) {
  return usleep_ibex(usec);
}

// currently broken, requires #define TIMER_BASE 0x90000000 in simple_system_regs.h
//#define USE_TIMER

int main(int argc, char **argv) {
  uint32_t leds = 0x0003;

#define USE_TIMER 1
#ifdef USE_TIMER
  timer_enable(2000);
#endif

  uint32_t counter = 0;
  while(1) {

#ifdef USE_TIMER
    // read LED0 (driven in timer interrupt handler)
    uint32_t led0 = DEV_READ(GPIO_OUT, 0) & 1;
    leds = (get_elapsed_time() >> 14 << 1) | led0;
    DEV_WRITE(GPIO_OUT, leds);
    uint32_t a = 43;
    
    a /= 5;
    // wait for interrupt
    asm volatile("wfi");
#else
    leds ^= 0xFFFFFFFFU;
    DEV_WRITE(GPIO_OUT, counter++);
    // busy loop
    usleep(1000 * 1000);
#endif    
  }
  return 0;
}
