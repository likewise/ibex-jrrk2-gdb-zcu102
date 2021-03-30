## Clock signal
create_clock -period 8.000 -name sys_clk_pin -add [get_nets clk_sys]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clkgen/ibufds/O]

# accept sub-optimal placement
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_ports jtag_tck_i]
#create_clock -period 100.000 -name jtag_clk_pin -waveform {0.000 50.000} -add [get_nets jtag_tck_i]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets jtag_tck_i]
create_clock -period 100.000 -name tck -waveform {0.000 50.000} -add [get_ports PMOD1_0]
set_input_jitter tck 1.000

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets jtag_tck_i_IBUF_inst/O]
#assign jtag_tck_i   = PMOD1_0;
#assign jtag_tms_i   = PMOD1_1;
#assign jtag_td_i    = PMOD1_2;
#assign jtag_td_o    = PMOD1_3;
#assign jtag_trst_ni = PMOD1_4;

# minimize routing delay
set_input_delay -clock tck -clock_fall 5.000 [get_ports PMOD1_4]
set_input_delay -clock tck -clock_fall 5.000 [get_ports PMOD1_2]
set_input_delay -clock tck -clock_fall 5.000 [get_ports PMOD1_1]
set_output_delay -clock tck 5.000 [get_ports PMOD1_3]

set_max_delay -to [get_ports PMOD1_3] 20.000
set_max_delay -from [get_ports PMOD1_0] 20.000
set_max_delay -from [get_ports PMOD1_1] 20.000
set_max_delay -from [get_ports PMOD1_2] 20.000
set_max_delay -from [get_ports PMOD1_4] 20.000

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets PMOD1_0]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {PMOD1_0_IBUF_inst/O}]

set_false_path -from [get_ports CPU_RESET]

set_false_path -from [get_clocks sys_clk_pin] -to [get_clocks tck]
set_false_path -from [get_clocks tck] -to [get_clocks sys_clk_pin]

#set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins i_pulpissimo/pad_jtag_tck]] -group [get_clocks -of_objects [get_pins i_pulpissimo/soc_domain_i/pulp_soc_i/i_clk_rst_gen/clk_soc_o]]

#https://forums.xilinx.com/t5/Versal-and-UltraScale/set-property-CLOCK-DEDICATED-ROUTE-ANY-CMT-COLUMN-get-nets-temp/td-p/1007812

# An I/O of the top-level block is called port
# I/Os of the subblocks is called pin.
# other I/O is a net

