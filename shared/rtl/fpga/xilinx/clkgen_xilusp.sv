// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Ultrascale+
module clkgen_xilusp (
    // differential clock input
    input IO_CLK_P,
    input IO_CLK_N,
    input IO_RST_N,
    output clk_sys,
    output rst_sys_n
);

  logic io_clk_buf;

  // input buffer for differential clock signal
  IBUFGDS ibufds
    (.I  (IO_CLK_P),
     .IB (IO_CLK_N),
     .O  (io_clk_buf));

  // io_clk_buf can be used as-is, or fed through a PLL to generate other clock(s)

// for ZCU102 use the input clock frequency as-is, timing closure achievable for 125 MHz
// 
`ifdef BYPASS_PLL

  logic locked_pll;
  logic clk_50_buf;
  logic clk_50_unbuf;
  logic clk_fb_buf;
  logic clk_fb_unbuf;


  PLLE4_ADV #(
    .CLKIN_PERIOD        (10.0),
    .COMPENSATION         ("AUTO"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1), // 1 to 15
    .CLKFBOUT_MULT        (10), // 1 to 19
    .CLKFBOUT_PHASE       (0.000),
    .CLKOUT0_DIVIDE       (60), // 1 to 128
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500)
  ) pll (
    .CLKFBOUT            (clk_fb_unbuf),
    .CLKOUT0             (clk_50_unbuf),
    .CLKOUT0B            (),
    .CLKOUT1             (),
    .CLKOUT1B            (),
    .CLKOUTPHYEN         (1'b0),
    .CLKOUTPHY           (),
     // Input clock control
    .CLKFBIN             (clk_fb_buf),
    .CLKIN               (io_clk_buf),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (),
    .DRDY                (),
    .DWE                 (1'b0),
    // Other control and status signals
    .LOCKED              (locked_pll),
    .PWRDWN              (1'b0),
    // Do not reset PLL on external reset, otherwise ILA disconnects at a reset
    .RST                 (1'b0));

  // output buffering
  //BUFG clk_fb_bufg (
  //  .I (clk_fb_unbuf),
  //  .O (clk_fb_buf)
  //);
  
  // https://www.xilinx.com/support/documentation/user_guides/ug572-ultrascale-clocking.pdf
  // page 75
  assign clk_fb_buf = clk_fb_unbuf;

  BUFG clk_50_bufg (
    .I (clk_50_unbuf),
    .O (clk_50_buf)
  );

  // outputs
  // clock
  assign clk_sys = clk_50_buf;
  // reset
  assign rst_sys_n = locked_pll & IO_RST_N;
`else /* BYPASS_PLL, tested on ZCU102 for 125 MHz differential clock */

  assign clk_sys = io_clk_buf;
  assign rst_sys_n = IO_RST_N;

endmodule
