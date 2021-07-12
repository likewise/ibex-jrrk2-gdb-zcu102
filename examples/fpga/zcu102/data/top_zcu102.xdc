# Clock signal is 125 MHz input clock
create_clock -period 8.000 -name sys_clk_pin -add [get_nets clk_sys]

# do not care about button input delay
set_false_path -from [get_ports CPU_RESET]
# but check_timing requires a clock and delay; choose any clock, zero delay
set_input_delay -clock [get_clocks sys_clk_pin] -min 0 [get_ports CPU_RESET]
set_input_delay -clock [get_clocks sys_clk_pin] -max 0 [get_ports CPU_RESET]

# false path, as we do not care about the FPGA to LED delay
set_false_path -to [get_ports GPIO_LED_*]
# but check_timing requires a clock and delay; choose any clock, zero delay 
set_output_delay -clock [get_clocks sys_clk_pin] 0 [get_ports GPIO_LED_*]

# for vendor/pulp_riscv_dbg/src/dmi_bscane_tap.sv
create_clock -name tck -period 50 -waveform {0 25}     [get_pins -filter { NAME =~ "*/i_tap_dtmcs/INTERNAL_TCK" } -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ *.BSCANE2 }]]
set_input_delay 15 -clock_fall -clock [get_clocks tck] [get_pins -filter { NAME =~ "*/INTERNAL_TDI" } -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ *.BSCANE2 }]]
set_input_delay 15 -clock_fall -clock [get_clocks tck] [get_pins -filter { NAME =~ "*/INTERNAL_TMS" } -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ *.BSCANE2 }]]
# CDC is in place
set_false_path -from [get_clocks sys_clk_pin] -to [get_clocks tck]
set_false_path -from [get_clocks tck] -to [get_clocks sys_clk_pin]
