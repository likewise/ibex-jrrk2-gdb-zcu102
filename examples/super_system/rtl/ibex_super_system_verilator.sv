module ibex_super_system_verilator (
  input IO_CLK,
  input IO_RST_N
);
  logic clk_sys, rst_sys_n;

  assign clk_sys = IO_CLK;
  assign rst_sys_n = IO_RST_N;

  logic [15:0] unused_gp_o;

  ibex_super_system #(
    .GpoWidth(16)
  ) u_super_system (
    .clk_sys_i (clk_sys),
    .rst_sys_ni(rst_sys_n),

    .gp_o(unused_gp_o)
  );
endmodule
