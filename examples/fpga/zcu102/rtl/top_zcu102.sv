// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module top_zcu102 (
   input wire  CPU_RESET,
   input wire  CLK_125_P,
   input wire  CLK_125_N,
   output wire GPIO_LED_0,
   output wire GPIO_LED_1,
   output wire GPIO_LED_2,
   output wire GPIO_LED_3,
   output wire GPIO_LED_4,
   output wire GPIO_LED_5,
   output wire GPIO_LED_6,
   output wire GPIO_LED_7
);

  parameter SRAMInitFile = "";

  logic clk_sys, rst_sys_n;

  ibex_super_system #(
    .GpoWidth(8),
    .SRAMInitFile(SRAMInitFile)
  ) u_ibex_super_system (
    .clk_sys_i(clk_sys),
    .rst_sys_ni(rst_sys_n),

    .gp_o({GPIO_LED_0, GPIO_LED_1, GPIO_LED_2, GPIO_LED_3, GPIO_LED_4, GPIO_LED_5, GPIO_LED_6, GPIO_LED_7 })
  );
  
  clkgen_xilusp
    clkgen(
      .IO_CLK_P(CLK_125_P),
      .IO_CLK_N(CLK_125_N),
      .IO_RST_N(!CPU_RESET),
      .clk_sys,
      .rst_sys_n
    );

endmodule
