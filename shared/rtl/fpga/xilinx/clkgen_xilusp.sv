// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Ultrascale+
module clkgen_xilusp (
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

  assign clk_sys = io_clk_buf;
  assign rst_sys_n = IO_RST_N;

endmodule
