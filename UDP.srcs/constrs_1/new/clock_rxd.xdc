# clock_rxd.xdc
##<---
##クロック信号の生成とデータの制約
##--->

## Clock Signal
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports SYSCLK]
create_clock -period 8.000 -name phyrx_ddr -waveform {0.000 4.000}
create_clock -period 8.000 -name PHY_RXCLK -waveform {2.000 6.000} [get_ports eth_rxck]

set_input_jitter [get_clocks -of_objects [get_ports eth_rxck]] 0.080

set_false_path -setup -rise_from phyrx_ddr -fall_to PHY_RXCLK
set_false_path -setup -fall_from phyrx_ddr -rise_to PHY_RXCLK
set_false_path -hold -rise_from phyrx_ddr -fall_to PHY_RXCLK
set_false_path -hold -fall_from phyrx_ddr -rise_to PHY_RXCLK

set_input_delay -clock phyrx_ddr -max 1.000 [get_ports {eth_rxd[*]}]
set_input_delay -clock phyrx_ddr -clock_fall -max -add_delay 1.000 [get_ports {eth_rxd[*]}]
set_input_delay -clock phyrx_ddr -min -1.000 [get_ports {eth_rxd[*]}]
set_input_delay -clock phyrx_ddr -clock_fall -min -add_delay -1.000 [get_ports {eth_rxd[*]}]
set_input_delay -clock phyrx_ddr -max 1.000 [get_ports eth_rxctl]
set_input_delay -clock phyrx_ddr -clock_fall -min -1.000 [get_ports eth_rxctl]