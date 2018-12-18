### This file is a general .xdc for the Nexys Video Rev. A
### To use it in a project:
### - uncomment the lines corresponding to used pins
### - rename the used ports (in each line, after get_ports) according to the top level signal names in the project


## Clock Signal
set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33} [get_ports SYSCLK]

create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports SYSCLK]

create_clock -period 8.000 -name phyrx_ddr -waveform {0.000 4.000}
create_clock -period 8.000 -name PHY_RXCLK -waveform {2.000 6.000} [get_ports eth_rxck]

#set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets pllsys/inst/SYSCLK_i_PLLSYS];
## FMC Transceiver clocks (Must be set to value provided by Mezzanine card, currently set to 156.25 MHz)
## Note: This clock is attached to a MGTREFCLK pin
#set_property -dict { PACKAGE_PIN E6 } [get_ports { GTP_CLK_N }];
#set_property -dict { PACKAGE_PIN F6 } [get_ports { GTP_CLK_P }];
#create_clock -add -name gtpclk0_pin -period 6.400 -waveform {0 3.200} [get_ports {GTP_CLK_P}];
#set_property -dict { PACKAGE_PIN E10 } [get_ports { FMC_MGT_CLK_N }];
#set_property -dict { PACKAGE_PIN F10 } [get_ports { FMC_MGT_CLK_P }];
#create_clock -add -name mgtclk1_pin -period 6.400 -waveform {0 3.200} [get_ports {FMC_MGT_CLK_P}];


## LEDs
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS25} [get_ports {LED[0]}]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS25} [get_ports {LED[1]}]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports {LED[2]}]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS25} [get_ports {LED[3]}]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS25} [get_ports {LED[4]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS25} [get_ports {LED[5]}]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS25} [get_ports {LED[6]}]
set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS25} [get_ports {LED[7]}]


## Buttons
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS33} [get_ports BTN_C]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS15} [get_ports CPU_RSTN]

## Switches
set_property -dict {PACKAGE_PIN E22 IOSTANDARD LVCMOS33} [get_ports {SW[0]}]
set_property -dict {PACKAGE_PIN F21 IOSTANDARD LVCMOS33} [get_ports {SW[1]}]
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS33} [get_ports {SW[2]}]
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS33} [get_ports {SW[3]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {SW[4]}]
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports {SW[5]}]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports {SW[6]}]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports {SW[7]}]


## OLED Display
#set_property -dict { PACKAGE_PIN W22   IOSTANDARD LVCMOS33 } [get_ports { oled_dc }]; #IO_L7N_T1_D10_14 Sch=oled_dc
#set_property -dict { PACKAGE_PIN U21   IOSTANDARD LVCMOS33 } [get_ports { oled_res }]; #IO_L4N_T0_D05_14 Sch=oled_res
#set_property -dict { PACKAGE_PIN W21   IOSTANDARD LVCMOS33 } [get_ports { oled_sclk }]; #IO_L7P_T1_D09_14 Sch=oled_sclk
#set_property -dict { PACKAGE_PIN Y22   IOSTANDARD LVCMOS33 } [get_ports { oled_sdin }]; #IO_L9N_T1_DQS_D13_14 Sch=oled_sdin
#set_property -dict { PACKAGE_PIN P20   IOSTANDARD LVCMOS33 } [get_ports { oled_vbat }]; #IO_0_14 Sch=oled_vbat
#set_property -dict { PACKAGE_PIN V22   IOSTANDARD LVCMOS33 } [get_ports { oled_vdd }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=oled_vdd


## HDMI in
#set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets dvi2rgb_i0/U0/TMDS_ClockingX/CLK_IN_hdmi_clk];


## HDMI out
#set_property -dict { PACKAGE_PIN AA4   IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_cec }]; #IO_L11N_T1_SRCC_34 Sch=hdmi_tx_cec
#set_property -dict { PACKAGE_PIN AB13  IOSTANDARD LVCMOS25 } [get_ports { hdmi_tx_hpd }]; #IO_L3N_T0_DQS_13 Sch=hdmi_tx_hpd
#set_property -dict { PACKAGE_PIN U3    IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_rscl }]; #IO_L6P_T0_34 Sch=hdmi_tx_rscl
#set_property -dict { PACKAGE_PIN V3    IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_rsda }]; #IO_L6N_T0_VREF_34 Sch=hdmi_tx_rsda
#create_clock -period 6.250 [get_ports rgb2dvi/PixelClk]

## Display Port
#set_property -dict { PACKAGE_PIN AB10  IOSTANDARD TMDS_33  } [get_ports { dp_tx_aux_n }]; #IO_L8N_T1_13 Sch=dp_tx_aux_n
#set_property -dict { PACKAGE_PIN AA11  IOSTANDARD TMDS_33  } [get_ports { dp_tx_aux_n }]; #IO_L9N_T1_DQS_13 Sch=dp_tx_aux_n
#set_property -dict { PACKAGE_PIN AA9   IOSTANDARD TMDS_33  } [get_ports { dp_tx_aux_p }]; #IO_L8P_T1_13 Sch=dp_tx_aux_p
#set_property -dict { PACKAGE_PIN AA10  IOSTANDARD TMDS_33  } [get_ports { dp_tx_aux_p }]; #IO_L9P_T1_DQS_13 Sch=dp_tx_aux_p
#set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { dp_tx_hpd }]; #IO_25_14 Sch=dp_tx_hpd


## Audio Codec
#set_property -dict { PACKAGE_PIN T4    IOSTANDARD LVCMOS33 } [get_ports { ac_adc_sdata }]; #IO_L13N_T2_MRCC_34 Sch=ac_adc_sdata
#set_property -dict { PACKAGE_PIN T5    IOSTANDARD LVCMOS33 } [get_ports { ac_bclk }]; #IO_L14P_T2_SRCC_34 Sch=ac_bclk
#set_property -dict { PACKAGE_PIN W6    IOSTANDARD LVCMOS33 } [get_ports { ac_dac_sdata }]; #IO_L15P_T2_DQS_34 Sch=ac_dac_sdata
#set_property -dict { PACKAGE_PIN U5    IOSTANDARD LVCMOS33 } [get_ports { ac_lrclk }]; #IO_L14N_T2_SRCC_34 Sch=ac_lrclk
#set_property -dict { PACKAGE_PIN U6    IOSTANDARD LVCMOS33 } [get_ports { ac_mclk }]; #IO_L16P_T2_34 Sch=ac_mclk


## Pmod header JA

## Pmod header JB


## Pmod header JC


## XADC Header
#set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { xa_p[0] }]; #IO_L3P_T0_DQS_AD1P_15 Sch=xa_p[1]
#set_property -dict { PACKAGE_PIN H13   IOSTANDARD LVCMOS33 } [get_ports { xa_p[1] }]; #IO_L1P_T0_AD0P_15 Sch=xa_p[2]
#set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { xa_n[1] }]; #IO_L1N_T0_AD0N_15 Sch=xa_n[2]
#set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { xa_p[2] }]; #IO_L2P_T0_AD8P_15 Sch=xa_p[3]
#set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports { xa_n[2] }]; #IO_L2N_T0_AD8N_15 Sch=xa_n[3]
#set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { xa_p[3] }]; #IO_L5P_T0_AD9P_15 Sch=xa_p[4]
#set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { xa_n[3] }]; #IO_L5N_T0_AD9N_15 Sch=xa_n[4]


## UART


## Ethernet
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports eth_rst_b]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS25} [get_ports eth_rxck]
set_property -dict {PACKAGE_PIN W10 IOSTANDARD LVCMOS25} [get_ports eth_rxctl]
set_property -dict {PACKAGE_PIN AB16 IOSTANDARD LVCMOS25} [get_ports {eth_rxd[0]}]
set_property -dict {PACKAGE_PIN AA15 IOSTANDARD LVCMOS25} [get_ports {eth_rxd[1]}]
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS25} [get_ports {eth_rxd[2]}]
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS25} [get_ports {eth_rxd[3]}]
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS25} [get_ports eth_txck]
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS25} [get_ports eth_txctl]
set_property -dict {PACKAGE_PIN Y12 IOSTANDARD LVCMOS25} [get_ports {eth_txd[0]}]
set_property -dict {PACKAGE_PIN W12 IOSTANDARD LVCMOS25} [get_ports {eth_txd[1]}]
set_property -dict {PACKAGE_PIN W11 IOSTANDARD LVCMOS25} [get_ports {eth_txd[2]}]
set_property -dict {PACKAGE_PIN Y11 IOSTANDARD LVCMOS25} [get_ports {eth_txd[3]}]

## <-- moikawa add 2018.10.30


## --> moikawa add 2018.10.30

## Fan PWM
#set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS25 } [get_ports { fan_pwm }]; #IO_L14P_T2_SRCC_13 Sch=fan_pwm


## DPTI/DSPI
#set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { prog_clko }]; #IO_L13P_T2_MRCC_14 Sch=prog_clko
#set_property -dict { PACKAGE_PIN U20   IOSTANDARD LVCMOS33 } [get_ports { prog_d[0]}]; #IO_L11P_T1_SRCC_14 Sch=prog_d0/sck
#set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { prog_d[1] }]; #IO_L19P_T3_A10_D26_14 Sch=prog_d1/mosi
#set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { prog_d[2] }]; #IO_L22P_T3_A05_D21_14 Sch=prog_d2/miso
#set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { prog_d[3]}]; #IO_L18P_T2_A12_D28_14 Sch=prog_d3/ss
#set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { prog_d[4] }]; #IO_L24N_T3_A00_D16_14 Sch=prog_d[4]
#set_property -dict { PACKAGE_PIN P16   IOSTANDARD LVCMOS33 } [get_ports { prog_d[5] }]; #IO_L24P_T3_A01_D17_14 Sch=prog_d[5]
#set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { prog_d[6] }]; #IO_L20P_T3_A08_D24_14 Sch=prog_d[6]
#set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { prog_d[7] }]; #IO_L23N_T3_A02_D18_14 Sch=prog_d[7]
#set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { prog_oen }]; #IO_L16P_T2_CSI_B_14 Sch=prog_oen
#set_property -dict { PACKAGE_PIN P19   IOSTANDARD LVCMOS33 } [get_ports { prog_rdn }]; #IO_L5P_T0_D06_14 Sch=prog_rdn
#set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { prog_rxen }]; #IO_L21P_T3_DQS_14 Sch=prog_rxen
#set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { prog_siwun }]; #IO_L21N_T3_DQS_A06_D22_14 Sch=prog_siwun
#set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { prog_spien }]; #IO_L19N_T3_A09_D25_VREF_14 Sch=prog_spien
#set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { prog_txen }]; #IO_L13N_T2_MRCC_14 Sch=prog_txen
#set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports { prog_wrn }]; #IO_L5N_T0_D07_14 Sch=prog_wrn


## HID port
#set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33   PULLUP true } [get_ports { ps2_clk }]; #IO_L16N_T2_A15_D31_14 Sch=ps2_clk
#set_property -dict { PACKAGE_PIN N13   IOSTANDARD LVCMOS33   PULLUP true } [get_ports { ps2_data }]; #IO_L23P_T3_A03_D19_14 Sch=ps2_data


## QSPI
#set_property -dict { PACKAGE_PIN T19   IOSTANDARD LVCMOS33 } [get_ports { qspi_cs }]; #IO_L6P_T0_FCS_B_14 Sch=qspi_cs
#set_property -dict { PACKAGE_PIN P22   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[0] }]; #IO_L1P_T0_D00_MOSI_14 Sch=qspi_dq[0]
#set_property -dict { PACKAGE_PIN R22   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[1] }]; #IO_L1N_T0_D01_DIN_14 Sch=qspi_dq[1]
#set_property -dict { PACKAGE_PIN P21   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[2] }]; #IO_L2P_T0_D02_14 Sch=qspi_dq[2]
#set_property -dict { PACKAGE_PIN R21   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[3] }]; #IO_L2N_T0_D03_14 Sch=qspi_dq[3]


## SD card
#set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports { sd_cclk }]; #IO_L12P_T1_MRCC_14 Sch=sd_cclk
#set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { sd_cd }]; #IO_L20N_T3_A07_D23_14 Sch=sd_cd
#set_property -dict { PACKAGE_PIN W20   IOSTANDARD LVCMOS33 } [get_ports { sd_cmd }]; #IO_L12N_T1_MRCC_14 Sch=sd_cmd
#set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports { sd_d[0] }]; #IO_L14N_T2_SRCC_14 Sch=sd_d[0]
#set_property -dict { PACKAGE_PIN T21   IOSTANDARD LVCMOS33 } [get_ports { sd_d[1] }]; #IO_L4P_T0_D04_14 Sch=sd_d[1]
#set_property -dict { PACKAGE_PIN T20   IOSTANDARD LVCMOS33 } [get_ports { sd_d[2] }]; #IO_L6N_T0_D08_VREF_14 Sch=sd_d[2]
#set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { sd_d[3] }]; #IO_L18N_T2_A11_D27_14 Sch=sd_d[3]
#set_property -dict { PACKAGE_PIN V20   IOSTANDARD LVCMOS33 } [get_ports { sd_reset }]; #IO_L11N_T1_SRCC_14 Sch=sd_reset


## I2C
#set_property -dict { PACKAGE_PIN W5    IOSTANDARD LVCMOS33 } [get_ports { scl }]; #IO_L15N_T2_DQS_34 Sch=scl
#set_property -dict { PACKAGE_PIN V5    IOSTANDARD LVCMOS33 } [get_ports { sda }]; #IO_L16N_T2_34 Sch=sda


## Voltage Adjust

##################
##  <--- FMC    ##
##################
#set_property -dict { PACKAGE_PIN H19   IOSTANDARD LVCMOS12 } [get_ports { fmc_clk0_m2c_n }]; #IO_L12N_T1_MRCC_15 Sch=fmc_clk0_m2c_n, "open"
#set_property -dict { PACKAGE_PIN J19   IOSTANDARD LVCMOS12 } [get_ports { fmc_clk0_m2c_p }]; #IO_L12P_T1_MRCC_15 Sch=fmc_clk0_m2c_p, "open"
#set_property -dict { PACKAGE_PIN C19   IOSTANDARD LVCMOS12 } [get_ports { fmc_clk1_m2c_n }]; #IO_L13N_T2_MRCC_16 Sch=fmc_clk1_m2c_n, "open"
#set_property -dict { PACKAGE_PIN C18   IOSTANDARD LVCMOS12 } [get_ports { fmc_clk1_m2c_p }]; #IO_L13P_T2_MRCC_16 Sch=fmc_clk1_m2c_p, "open"
#set_property -dict { PACKAGE_PIN B16   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[24] }]; #IO_L7N_T1_16 Sch=fmc_la_n[24], "open"
#set_property -dict { PACKAGE_PIN B15   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[24] }]; #IO_L7P_T1_16 Sch=fmc_la_p[24], "open"
#set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[26] }]; #IO_L15N_T2_DQS_16 Sch=fmc_la_n[26], "open"
#set_property -dict { PACKAGE_PIN F18   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[26] }]; #IO_L15P_T2_DQS_16 Sch=fmc_la_p[26], "open"
#set_property -dict { PACKAGE_PIN A20   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[27] }]; #IO_L16N_T2_16 Sch=fmc_la_n[27], "open"
#set_property -dict { PACKAGE_PIN B20   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[27] }]; #IO_L16P_T2_16 Sch=fmc_la_p[27], "open"
#set_property -dict { PACKAGE_PIN B13   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[28] }]; #IO_L8N_T1_16 Sch=fmc_la_n[28], "open"
#set_property -dict { PACKAGE_PIN C13   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[28] }]; #IO_L8P_T1_16 Sch=fmc_la_p[28], "open"
#set_property -dict { PACKAGE_PIN C15   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[29] }]; #IO_L3N_T0_DQS_16 Sch=fmc_la_n[29], "open"
#set_property -dict { PACKAGE_PIN C14   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[29] }]; #IO_L3P_T0_DQS_16 Sch=fmc_la_p[29], "open"
#set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[30] }]; #IO_L10N_T1_16 Sch=fmc_la_n[30], "open"
#set_property -dict { PACKAGE_PIN A13   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[30] }]; #IO_L10P_T1_16 Sch=fmc_la_p[30], "open"
#set_property -dict { PACKAGE_PIN E14   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[31] }]; #IO_L4N_T0_16 Sch=fmc_la_n[31], "open"
#set_property -dict { PACKAGE_PIN E13   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[31] }]; #IO_L4P_T0_16 Sch=fmc_la_p[31], "open"
#set_property -dict { PACKAGE_PIN A16   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[32] }]; #IO_L9N_T1_DQS_16 Sch=fmc_la_n[32], "open"
#set_property -dict { PACKAGE_PIN A15   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[32] }]; #IO_L9P_T1_DQS_16 Sch=fmc_la_p[32], "open"
#set_property -dict { PACKAGE_PIN F14   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[33] }]; #IO_L1N_T0_16 Sch=fmc_la_n[33], "open"
#set_property -dict { PACKAGE_PIN F13   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[33] }]; #IO_L1P_T0_16 Sch=fmc_la_p[33], "open"

## ---> FMC

#set_property BEL MMCME2_ADV [get_cells dvi2rgb_i2/U0/TMDS_ClockingX/DVI_ClkGenerator]
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets clk200]












































set_input_delay -clock phyrx_ddr -max 1.000 [get_ports {eth_rxd[*]}]
set_input_delay -clock phyrx_ddr -clock_fall -max -add_delay 1.000 [get_ports {eth_rxd[*]}]
set_input_delay -clock phyrx_ddr -min -1.000 [get_ports {eth_rxd[*]}]
set_input_delay -clock phyrx_ddr -clock_fall -min -add_delay -1.000 [get_ports {eth_rxd[*]}]
set_false_path -setup -rise_from phyrx_ddr -fall_to PHY_RXCLK
set_false_path -setup -fall_from phyrx_ddr -rise_to PHY_RXCLK
set_false_path -hold -rise_from phyrx_ddr -fall_to PHY_RXCLK
set_false_path -hold -fall_from phyrx_ddr -rise_to PHY_RXCLK
set_input_delay -clock phyrx_ddr -max 1.000 [get_ports eth_rxctl]
set_input_delay -clock phyrx_ddr -clock_fall -min -1.000 [get_ports eth_rxctl]

set_false_path -from [get_ports CPU_RSTN]

#set_false_path -rise_from [get_pins {R_Arbiter/ping/csum_extend_reg[*]/C}] -rise_to [get_pins {R_Arbiter/ping/TXBUF_reg[*][*]/D}]
#set_false_path -rise_from [get_pins {R_Arbiter/ping/DstMAC_reg[*]/C}] -rise_to [get_pins {R_Arbiter/ping/TXBUF_reg[*][*]/D}]
#set_false_path -rise_from [get_pins {R_Arbiter/ping/rx_cnt_i_reg[*]/C}] -rise_to [get_pins {R_Arbiter/ping/tx_cnt_reg[*]*/D}]
#set_false_path -rise_from [get_pins {R_Arbiter/trans_image/DstMAC_i_reg[*]/C}] -rise_to [get_pins {R_Arbiter/trans_image/TXBUF_reg[*][*]/D}]
#set_false_path -rise_from [get_pins {R_Arbiter/trans_image/DstIP_i_reg[*]/C}] -rise_to [get_pins {R_Arbiter/trans_image/TXBUF_reg[*][*]/D}]
#set_false_path -rise_from [get_pins {R_Arbiter/trans_image/DstPort_i_reg[*]/C}] -rise_to [get_pins {R_Arbiter/trans_image/TXBUF_reg[*][*]/D}]
#set_false_path -rise_from [get_pins {R_Arbiter/trans_image/SrcPort_i_reg[*]/C}] -rise_to [get_pins {R_Arbiter/trans_image/TXBUF_reg[*][*]/D}]
#set_false_path -rise_from [get_pins {R_Arbiter/ping/DstIP_reg[*]/C}] -rise_to [get_pins {R_Arbiter/ping/TXBUF_reg[*][*]/D}]

#set_false_path -rise_from [get_pins {R_Arbiter/ping/DstIP_reg[10]/C}] -rise_to [get_pins {R_Arbiter/ping/TXBUF_reg[32][2]/D}]

#set_false_path -from [get_pins {R_Arbiter/ping/DstIP_reg[10]/C}] -to [get_pins {R_Arbiter/ping/TXBUF_reg[32][2]/D}]

#<-- add by manual
#set_false_path -from [get_cells R_Arbiter/ping/DstIP_reg*] -to [get_cells R_Arbiter/ping/TXBUF_reg*]
#set_false_path -from [get_cells R_Arbiter/ping/DstMAC_reg*] -to [get_cells R_Arbiter/ping/TXBUF_reg*]
#set_false_path -from [get_cells R_Arbiter/ping/SeqNum_reg*] -to [get_cells R_Arbiter/ping/TXBUF_reg*]
#set_false_path -from [get_cells R_Arbiter/ping/csum_extend_reg*] -to [get_cells R_Arbiter/ping/TXBUF_reg*]
#set_false_path -from [get_cells R_Arbiter/ping/Ident_reg*] -to [get_cells R_Arbiter/ping/TXBUF_reg*]
#set_false_path -from [get_cells R_Arbiter/ping/ToLen_reg*] -to [get_cells R_Arbiter/ping/TXBUF_reg*]
#set_false_path -from [get_cells R_Arbiter/ping/rx_cnt_i_reg*] -to [get_cells R_Arbiter/ping/tx_cnt_reg*]
#set_false_path -from [get_cells R_Arbiter/DstMAC_reg*] -to [get_cells R_Arbiter/ARP/TXBUF_reg*]
#set_false_path -from [get_cells R_Arbiter/DstIP_reg*] -to [get_cells R_Arbiter/ARP/TXBUF_reg*]
#set_false_path -from [get_cells R_Arbiter/arp_st_reg*] -to [get_cells R_Arbiter/ARP/FSM_sequential_st_reg*]
#set_false_path -from [get_cells R_Arbiter/ping/tx_iend_rxck_reg*] -to [get_cells R_Arbiter/ping/tx_iend_clk125_d_reg*]
#set_false_path -from [get_cells R_Arbiter/ping/tx_hend_rxck_reg*] -to [get_cells R_Arbiter/ping/tx_hend_clk125_d_reg*]
#set_false_path -from [get_cells R_Arbiter/ping/ready_rxck_reg*] -to [get_cells R_Arbiter/ping/ready_clk125_d_reg*]
set_false_path -from [get_cells R_Arbiter/ARP/tx_en_reg*] -to [get_cells R_Arbiter/ARP/tx_en_clk125_d_reg*]
set_false_path -from [get_cells R_Arbiter/ping/tx_en_reg*] -to [get_cells R_Arbiter/ping/tx_en_clk125_d_reg*]
set_false_path -from [get_cells R_Arbiter/trans_image/tx_en_reg*] -to [get_cells R_Arbiter/trans_image/tx_en_clk125_d_reg*]

#set_false_path -from [get_cells R_Arbiter/trans_image/DstMAC_i_reg*] -to [get_cells R_Arbiter/trans_image/TXBUF_reg*]
#set_false_path -from [get_cells R_Arbiter/trans_image/DstIP_i_reg*] -to [get_cells R_Arbiter/trans_image/TXBUF_reg*]
#set_false_path -from [get_cells R_Arbiter/trans_image/DstPort_i_reg*] -to [get_cells R_Arbiter/trans_image/TXBUF_reg*]
#set_false_path -from [get_cells R_Arbiter/trans_image/SrcPort_i_reg*] -to [get_cells R_Arbiter/trans_image/TXBUF_reg*]
#set_false_path -from [get_cells R_Arbiter/trans_image/image_buffer_reg*] -to [get_cells R_Arbiter/trans_image/TXBUF_reg*]
#set_false_path -from [get_cells R_Arbiter/trans_image/csum_extend_reg*] -to [get_cells R_Arbiter/trans_image/TXBUF_reg*]
#set_false_path -from [get_cells R_Arbiter/trans_image/hcend_rxck_reg*] -to [get_cells R_Arbiter/trans_image/hcend_clk125_d_reg*]
#set_false_path -from [get_cells R_Arbiter/trans_image/tx_en_reg*] -to [get_cells R_Arbiter/trans_image/tx_en_clk125_d_reg*]
#set_false_path -from [get_cells R_Arbiter/trans_image/ucend_rxck_reg*] -to [get_cells R_Arbiter/trans_image/ucend_clk125_d_reg*]
#set_false_path -from [get_cells R_Arbiter/trans_image/ready_rxck_reg*] -to [get_cells R_Arbiter/trans_image/ready_clk125_d_reg*]
#set_false_path -from [get_cells R_Arbiter/trans_image/TXBUF_reg*] -to [get_cells R_Arbiter/trans_image/data_pipe_reg*]
#set_false_path -from [get_cells R_Arbiter/trans_image/image_bufferA_reg*] -to [get_cells R_Arbiter/trans_image/TXBUF_reg*]
#set_false_path -from [get_cells R_Arbiter/trans_image/image_bufferB_reg*] -to [get_cells R_Arbiter/trans_image/TXBUF_reg*]
#--> add by manual

#create_debug_core u_ila_0 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
#set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
#set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
#set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
#set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
#set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
#set_property port_width 1 [get_debug_ports u_ila_0/clk]
#connect_debug_port u_ila_0/clk [get_nets [list eth_rxck_IBUF_BUFG]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
#set_property port_width 32 [get_debug_ports u_ila_0/probe0]
#connect_debug_port u_ila_0/probe0 [get_nets [list {R_Arbiter/DstIP[0]} {R_Arbiter/DstIP[1]} {R_Arbiter/DstIP[2]} {R_Arbiter/DstIP[3]} {R_Arbiter/DstIP[4]} {R_Arbiter/DstIP[5]} {R_Arbiter/DstIP[6]} {R_Arbiter/DstIP[7]} {R_Arbiter/DstIP[8]} {R_Arbiter/DstIP[9]} {R_Arbiter/DstIP[10]} {R_Arbiter/DstIP[11]} {R_Arbiter/DstIP[12]} {R_Arbiter/DstIP[13]} {R_Arbiter/DstIP[14]} {R_Arbiter/DstIP[15]} {R_Arbiter/DstIP[16]} {R_Arbiter/DstIP[17]} {R_Arbiter/DstIP[18]} {R_Arbiter/DstIP[19]} {R_Arbiter/DstIP[20]} {R_Arbiter/DstIP[21]} {R_Arbiter/DstIP[22]} {R_Arbiter/DstIP[23]} {R_Arbiter/DstIP[24]} {R_Arbiter/DstIP[25]} {R_Arbiter/DstIP[26]} {R_Arbiter/DstIP[27]} {R_Arbiter/DstIP[28]} {R_Arbiter/DstIP[29]} {R_Arbiter/DstIP[30]} {R_Arbiter/DstIP[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
#set_property port_width 48 [get_debug_ports u_ila_0/probe1]
#connect_debug_port u_ila_0/probe1 [get_nets [list {R_Arbiter/DstMAC[0]} {R_Arbiter/DstMAC[1]} {R_Arbiter/DstMAC[2]} {R_Arbiter/DstMAC[3]} {R_Arbiter/DstMAC[4]} {R_Arbiter/DstMAC[5]} {R_Arbiter/DstMAC[6]} {R_Arbiter/DstMAC[7]} {R_Arbiter/DstMAC[8]} {R_Arbiter/DstMAC[9]} {R_Arbiter/DstMAC[10]} {R_Arbiter/DstMAC[11]} {R_Arbiter/DstMAC[12]} {R_Arbiter/DstMAC[13]} {R_Arbiter/DstMAC[14]} {R_Arbiter/DstMAC[15]} {R_Arbiter/DstMAC[16]} {R_Arbiter/DstMAC[17]} {R_Arbiter/DstMAC[18]} {R_Arbiter/DstMAC[19]} {R_Arbiter/DstMAC[20]} {R_Arbiter/DstMAC[21]} {R_Arbiter/DstMAC[22]} {R_Arbiter/DstMAC[23]} {R_Arbiter/DstMAC[24]} {R_Arbiter/DstMAC[25]} {R_Arbiter/DstMAC[26]} {R_Arbiter/DstMAC[27]} {R_Arbiter/DstMAC[28]} {R_Arbiter/DstMAC[29]} {R_Arbiter/DstMAC[30]} {R_Arbiter/DstMAC[31]} {R_Arbiter/DstMAC[32]} {R_Arbiter/DstMAC[33]} {R_Arbiter/DstMAC[34]} {R_Arbiter/DstMAC[35]} {R_Arbiter/DstMAC[36]} {R_Arbiter/DstMAC[37]} {R_Arbiter/DstMAC[38]} {R_Arbiter/DstMAC[39]} {R_Arbiter/DstMAC[40]} {R_Arbiter/DstMAC[41]} {R_Arbiter/DstMAC[42]} {R_Arbiter/DstMAC[43]} {R_Arbiter/DstMAC[44]} {R_Arbiter/DstMAC[45]} {R_Arbiter/DstMAC[46]} {R_Arbiter/DstMAC[47]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
#set_property port_width 48 [get_debug_ports u_ila_0/probe2]
#connect_debug_port u_ila_0/probe2 [get_nets [list {R_Arbiter/host_MAC[0]} {R_Arbiter/host_MAC[1]} {R_Arbiter/host_MAC[2]} {R_Arbiter/host_MAC[3]} {R_Arbiter/host_MAC[4]} {R_Arbiter/host_MAC[5]} {R_Arbiter/host_MAC[6]} {R_Arbiter/host_MAC[7]} {R_Arbiter/host_MAC[8]} {R_Arbiter/host_MAC[9]} {R_Arbiter/host_MAC[10]} {R_Arbiter/host_MAC[11]} {R_Arbiter/host_MAC[12]} {R_Arbiter/host_MAC[13]} {R_Arbiter/host_MAC[14]} {R_Arbiter/host_MAC[15]} {R_Arbiter/host_MAC[16]} {R_Arbiter/host_MAC[17]} {R_Arbiter/host_MAC[18]} {R_Arbiter/host_MAC[19]} {R_Arbiter/host_MAC[20]} {R_Arbiter/host_MAC[21]} {R_Arbiter/host_MAC[22]} {R_Arbiter/host_MAC[23]} {R_Arbiter/host_MAC[24]} {R_Arbiter/host_MAC[25]} {R_Arbiter/host_MAC[26]} {R_Arbiter/host_MAC[27]} {R_Arbiter/host_MAC[28]} {R_Arbiter/host_MAC[29]} {R_Arbiter/host_MAC[30]} {R_Arbiter/host_MAC[31]} {R_Arbiter/host_MAC[32]} {R_Arbiter/host_MAC[33]} {R_Arbiter/host_MAC[34]} {R_Arbiter/host_MAC[35]} {R_Arbiter/host_MAC[36]} {R_Arbiter/host_MAC[37]} {R_Arbiter/host_MAC[38]} {R_Arbiter/host_MAC[39]} {R_Arbiter/host_MAC[40]} {R_Arbiter/host_MAC[41]} {R_Arbiter/host_MAC[42]} {R_Arbiter/host_MAC[43]} {R_Arbiter/host_MAC[44]} {R_Arbiter/host_MAC[45]} {R_Arbiter/host_MAC[46]} {R_Arbiter/host_MAC[47]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
#set_property port_width 32 [get_debug_ports u_ila_0/probe3]
#connect_debug_port u_ila_0/probe3 [get_nets [list {R_Arbiter/r_crc[0]} {R_Arbiter/r_crc[1]} {R_Arbiter/r_crc[2]} {R_Arbiter/r_crc[3]} {R_Arbiter/r_crc[4]} {R_Arbiter/r_crc[5]} {R_Arbiter/r_crc[6]} {R_Arbiter/r_crc[7]} {R_Arbiter/r_crc[8]} {R_Arbiter/r_crc[9]} {R_Arbiter/r_crc[10]} {R_Arbiter/r_crc[11]} {R_Arbiter/r_crc[12]} {R_Arbiter/r_crc[13]} {R_Arbiter/r_crc[14]} {R_Arbiter/r_crc[15]} {R_Arbiter/r_crc[16]} {R_Arbiter/r_crc[17]} {R_Arbiter/r_crc[18]} {R_Arbiter/r_crc[19]} {R_Arbiter/r_crc[20]} {R_Arbiter/r_crc[21]} {R_Arbiter/r_crc[22]} {R_Arbiter/r_crc[23]} {R_Arbiter/r_crc[24]} {R_Arbiter/r_crc[25]} {R_Arbiter/r_crc[26]} {R_Arbiter/r_crc[27]} {R_Arbiter/r_crc[28]} {R_Arbiter/r_crc[29]} {R_Arbiter/r_crc[30]} {R_Arbiter/r_crc[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
#set_property port_width 10 [get_debug_ports u_ila_0/probe4]
#connect_debug_port u_ila_0/probe4 [get_nets [list {R_Arbiter/rx_cnt[0]} {R_Arbiter/rx_cnt[1]} {R_Arbiter/rx_cnt[2]} {R_Arbiter/rx_cnt[3]} {R_Arbiter/rx_cnt[4]} {R_Arbiter/rx_cnt[5]} {R_Arbiter/rx_cnt[6]} {R_Arbiter/rx_cnt[7]} {R_Arbiter/rx_cnt[8]} {R_Arbiter/rx_cnt[9]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
#set_property port_width 8 [get_debug_ports u_ila_0/probe5]
#connect_debug_port u_ila_0/probe5 [get_nets [list {R_Arbiter/st[0]} {R_Arbiter/st[1]} {R_Arbiter/st[2]} {R_Arbiter/st[3]} {R_Arbiter/st[4]} {R_Arbiter/st[5]} {R_Arbiter/st[6]} {R_Arbiter/st[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
#set_property port_width 8 [get_debug_ports u_ila_0/probe6]
#connect_debug_port u_ila_0/probe6 [get_nets [list {R_Arbiter/trans_image/data[0]} {R_Arbiter/trans_image/data[1]} {R_Arbiter/trans_image/data[2]} {R_Arbiter/trans_image/data[3]} {R_Arbiter/trans_image/data[4]} {R_Arbiter/trans_image/data[5]} {R_Arbiter/trans_image/data[6]} {R_Arbiter/trans_image/data[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
#set_property port_width 8 [get_debug_ports u_ila_0/probe7]
#connect_debug_port u_ila_0/probe7 [get_nets [list {R_Arbiter/trans_image/st[0]} {R_Arbiter/trans_image/st[1]} {R_Arbiter/trans_image/st[2]} {R_Arbiter/trans_image/st[3]} {R_Arbiter/trans_image/st[4]} {R_Arbiter/trans_image/st[5]} {R_Arbiter/trans_image/st[6]} {R_Arbiter/trans_image/st[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
#set_property port_width 16 [get_debug_ports u_ila_0/probe8]
#connect_debug_port u_ila_0/probe8 [get_nets [list {R_Arbiter/recv_image/csum[0]} {R_Arbiter/recv_image/csum[1]} {R_Arbiter/recv_image/csum[2]} {R_Arbiter/recv_image/csum[3]} {R_Arbiter/recv_image/csum[4]} {R_Arbiter/recv_image/csum[5]} {R_Arbiter/recv_image/csum[6]} {R_Arbiter/recv_image/csum[7]} {R_Arbiter/recv_image/csum[8]} {R_Arbiter/recv_image/csum[9]} {R_Arbiter/recv_image/csum[10]} {R_Arbiter/recv_image/csum[11]} {R_Arbiter/recv_image/csum[12]} {R_Arbiter/recv_image/csum[13]} {R_Arbiter/recv_image/csum[14]} {R_Arbiter/recv_image/csum[15]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
#set_property port_width 11 [get_debug_ports u_ila_0/probe9]
#connect_debug_port u_ila_0/probe9 [get_nets [list {R_Arbiter/recv_image/csum_cnt[0]} {R_Arbiter/recv_image/csum_cnt[1]} {R_Arbiter/recv_image/csum_cnt[2]} {R_Arbiter/recv_image/csum_cnt[3]} {R_Arbiter/recv_image/csum_cnt[4]} {R_Arbiter/recv_image/csum_cnt[5]} {R_Arbiter/recv_image/csum_cnt[6]} {R_Arbiter/recv_image/csum_cnt[7]} {R_Arbiter/recv_image/csum_cnt[8]} {R_Arbiter/recv_image/csum_cnt[9]} {R_Arbiter/recv_image/csum_cnt[10]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
#set_property port_width 8 [get_debug_ports u_ila_0/probe10]
#connect_debug_port u_ila_0/probe10 [get_nets [list {R_Arbiter/recv_image/data[0]} {R_Arbiter/recv_image/data[1]} {R_Arbiter/recv_image/data[2]} {R_Arbiter/recv_image/data[3]} {R_Arbiter/recv_image/data[4]} {R_Arbiter/recv_image/data[5]} {R_Arbiter/recv_image/data[6]} {R_Arbiter/recv_image/data[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
#set_property port_width 5 [get_debug_ports u_ila_0/probe11]
#connect_debug_port u_ila_0/probe11 [get_nets [list {R_Arbiter/recv_image/packet_cnt_reg__0[0]} {R_Arbiter/recv_image/packet_cnt_reg__0[1]} {R_Arbiter/recv_image/packet_cnt_reg__0[2]} {R_Arbiter/recv_image/packet_cnt_reg__0[3]} {R_Arbiter/recv_image/packet_cnt_reg__0[4]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
#set_property port_width 8 [get_debug_ports u_ila_0/probe12]
#connect_debug_port u_ila_0/probe12 [get_nets [list {R_Arbiter/recv_image/st[0]} {R_Arbiter/recv_image/st[1]} {R_Arbiter/recv_image/st[2]} {R_Arbiter/recv_image/st[3]} {R_Arbiter/recv_image/st[4]} {R_Arbiter/recv_image/st[5]} {R_Arbiter/recv_image/st[6]} {R_Arbiter/recv_image/st[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
#set_property port_width 8 [get_debug_ports u_ila_0/probe13]
#connect_debug_port u_ila_0/probe13 [get_nets [list {gmii_rxd[0]} {gmii_rxd[1]} {gmii_rxd[2]} {gmii_rxd[3]} {gmii_rxd[4]} {gmii_rxd[5]} {gmii_rxd[6]} {gmii_rxd[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
#set_property port_width 1 [get_debug_ports u_ila_0/probe14]
#connect_debug_port u_ila_0/probe14 [get_nets [list {R_Arbiter/arp_st_reg_n_0_[0]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
#set_property port_width 1 [get_debug_ports u_ila_0/probe15]
#connect_debug_port u_ila_0/probe15 [get_nets [list R_Arbiter/crc_ok_reg_n_0]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
#set_property port_width 1 [get_debug_ports u_ila_0/probe16]
#connect_debug_port u_ila_0/probe16 [get_nets [list gmii_rxctl]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
#set_property port_width 1 [get_debug_ports u_ila_0/probe17]
#connect_debug_port u_ila_0/probe17 [get_nets [list R_Arbiter/recvend]]
#create_debug_core u_ila_1 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
#set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
#set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
#set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_1]
#set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
#set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
#set_property port_width 1 [get_debug_ports u_ila_1/clk]
#connect_debug_port u_ila_1/clk [get_nets [list clk125]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
#set_property port_width 17 [get_debug_ports u_ila_1/probe0]
#connect_debug_port u_ila_1/probe0 [get_nets [list {UDP/udp_checksum/sum_17[0]} {UDP/udp_checksum/sum_17[1]} {UDP/udp_checksum/sum_17[2]} {UDP/udp_checksum/sum_17[3]} {UDP/udp_checksum/sum_17[4]} {UDP/udp_checksum/sum_17[5]} {UDP/udp_checksum/sum_17[6]} {UDP/udp_checksum/sum_17[7]} {UDP/udp_checksum/sum_17[8]} {UDP/udp_checksum/sum_17[9]} {UDP/udp_checksum/sum_17[10]} {UDP/udp_checksum/sum_17[11]} {UDP/udp_checksum/sum_17[12]} {UDP/udp_checksum/sum_17[13]} {UDP/udp_checksum/sum_17[14]} {UDP/udp_checksum/sum_17[15]} {UDP/udp_checksum/sum_17[16]}]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
#set_property port_width 8 [get_debug_ports u_ila_1/probe1]
#connect_debug_port u_ila_1/probe1 [get_nets [list {gmii_txd[0]} {gmii_txd[1]} {gmii_txd[2]} {gmii_txd[3]} {gmii_txd[4]} {gmii_txd[5]} {gmii_txd[6]} {gmii_txd[7]}]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
#set_property port_width 1 [get_debug_ports u_ila_1/probe2]
#connect_debug_port u_ila_1/probe2 [get_nets [list gmii_txctl]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
#set_property port_width 1 [get_debug_ports u_ila_1/probe3]
#connect_debug_port u_ila_1/probe3 [get_nets [list R_Arbiter/ARP/start_tx_reg_n_0]]
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets clk125]

connect_debug_port u_ila_0/probe3 [get_nets [list {R_Arbiter/recv_image/addra[0]} {R_Arbiter/recv_image/addra[1]} {R_Arbiter/recv_image/addra[2]} {R_Arbiter/recv_image/addra[3]} {R_Arbiter/recv_image/addra[4]} {R_Arbiter/recv_image/addra[5]} {R_Arbiter/recv_image/addra[6]} {R_Arbiter/recv_image/addra[7]} {R_Arbiter/recv_image/addra[8]} {R_Arbiter/recv_image/addra[9]} {R_Arbiter/recv_image/addra[10]} {R_Arbiter/recv_image/addra[11]} {R_Arbiter/recv_image/addra[12]} {R_Arbiter/recv_image/addra[13]}]]
connect_debug_port u_ila_1/probe1 [get_nets [list {R_Arbiter/trans_image/clk_cnt_reg__0[0]} {R_Arbiter/trans_image/clk_cnt_reg__0[1]} {R_Arbiter/trans_image/clk_cnt_reg__0[2]} {R_Arbiter/trans_image/clk_cnt_reg__0[3]} {R_Arbiter/trans_image/clk_cnt_reg__0[4]} {R_Arbiter/trans_image/clk_cnt_reg__0[5]}]]
connect_debug_port u_ila_1/probe2 [get_nets [list {R_Arbiter/trans_image/clk_cnt_reg__0__0[6]} {R_Arbiter/trans_image/clk_cnt_reg__0__0[7]} {R_Arbiter/trans_image/clk_cnt_reg__0__0[8]} {R_Arbiter/trans_image/clk_cnt_reg__0__0[9]} {R_Arbiter/trans_image/clk_cnt_reg__0__0[10]}]]


connect_debug_port u_ila_0/probe2 [get_nets [list {R_Arbiter/recv_image/addra[0]} {R_Arbiter/recv_image/addra[1]} {R_Arbiter/recv_image/addra[2]} {R_Arbiter/recv_image/addra[3]} {R_Arbiter/recv_image/addra[4]} {R_Arbiter/recv_image/addra[5]} {R_Arbiter/recv_image/addra[6]} {R_Arbiter/recv_image/addra[7]} {R_Arbiter/recv_image/addra[8]} {R_Arbiter/recv_image/addra[9]} {R_Arbiter/recv_image/addra[10]} {R_Arbiter/recv_image/addra[11]} {R_Arbiter/recv_image/addra[12]} {R_Arbiter/recv_image/addra[13]}]]


connect_debug_port u_ila_0/probe5 [get_nets [list R_Arbiter/trans_image/tx_end]]



connect_debug_port u_ila_0/probe17 [get_nets [list {R_Arbiter/UDP_st_reg_n_0_[2]}]]

connect_debug_port u_ila_1/probe3 [get_nets [list R_Arbiter/trans_image/hcend_clk125]]
connect_debug_port u_ila_1/probe36 [get_nets [list R_Arbiter/trans_image/ready_clk125]]
connect_debug_port u_ila_1/probe37 [get_nets [list R_Arbiter/trans_image/ucend_clk125]]




create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list eth_rxck_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 2 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {R_Arbiter/ARP/st[0]} {R_Arbiter/ARP/st[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 3 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {R_Arbiter/UDP_st[0]} {R_Arbiter/UDP_st[1]} {R_Arbiter/UDP_st[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 3 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {R_Arbiter/arp_st[0]} {R_Arbiter/arp_st[1]} {R_Arbiter/arp_st[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 3 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {R_Arbiter/els_packet[0]} {R_Arbiter/els_packet[1]} {R_Arbiter/els_packet[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {R_Arbiter/my_IPadd[0]} {R_Arbiter/my_IPadd[1]} {R_Arbiter/my_IPadd[2]} {R_Arbiter/my_IPadd[3]} {R_Arbiter/my_IPadd[4]} {R_Arbiter/my_IPadd[5]} {R_Arbiter/my_IPadd[6]} {R_Arbiter/my_IPadd[7]} {R_Arbiter/my_IPadd[8]} {R_Arbiter/my_IPadd[9]} {R_Arbiter/my_IPadd[10]} {R_Arbiter/my_IPadd[11]} {R_Arbiter/my_IPadd[12]} {R_Arbiter/my_IPadd[13]} {R_Arbiter/my_IPadd[14]} {R_Arbiter/my_IPadd[15]} {R_Arbiter/my_IPadd[16]} {R_Arbiter/my_IPadd[17]} {R_Arbiter/my_IPadd[18]} {R_Arbiter/my_IPadd[19]} {R_Arbiter/my_IPadd[20]} {R_Arbiter/my_IPadd[21]} {R_Arbiter/my_IPadd[22]} {R_Arbiter/my_IPadd[23]} {R_Arbiter/my_IPadd[24]} {R_Arbiter/my_IPadd[25]} {R_Arbiter/my_IPadd[26]} {R_Arbiter/my_IPadd[27]} {R_Arbiter/my_IPadd[28]} {R_Arbiter/my_IPadd[29]} {R_Arbiter/my_IPadd[30]} {R_Arbiter/my_IPadd[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 48 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {R_Arbiter/my_MACadd[0]} {R_Arbiter/my_MACadd[1]} {R_Arbiter/my_MACadd[2]} {R_Arbiter/my_MACadd[3]} {R_Arbiter/my_MACadd[4]} {R_Arbiter/my_MACadd[5]} {R_Arbiter/my_MACadd[6]} {R_Arbiter/my_MACadd[7]} {R_Arbiter/my_MACadd[8]} {R_Arbiter/my_MACadd[9]} {R_Arbiter/my_MACadd[10]} {R_Arbiter/my_MACadd[11]} {R_Arbiter/my_MACadd[12]} {R_Arbiter/my_MACadd[13]} {R_Arbiter/my_MACadd[14]} {R_Arbiter/my_MACadd[15]} {R_Arbiter/my_MACadd[16]} {R_Arbiter/my_MACadd[17]} {R_Arbiter/my_MACadd[18]} {R_Arbiter/my_MACadd[19]} {R_Arbiter/my_MACadd[20]} {R_Arbiter/my_MACadd[21]} {R_Arbiter/my_MACadd[22]} {R_Arbiter/my_MACadd[23]} {R_Arbiter/my_MACadd[24]} {R_Arbiter/my_MACadd[25]} {R_Arbiter/my_MACadd[26]} {R_Arbiter/my_MACadd[27]} {R_Arbiter/my_MACadd[28]} {R_Arbiter/my_MACadd[29]} {R_Arbiter/my_MACadd[30]} {R_Arbiter/my_MACadd[31]} {R_Arbiter/my_MACadd[32]} {R_Arbiter/my_MACadd[33]} {R_Arbiter/my_MACadd[34]} {R_Arbiter/my_MACadd[35]} {R_Arbiter/my_MACadd[36]} {R_Arbiter/my_MACadd[37]} {R_Arbiter/my_MACadd[38]} {R_Arbiter/my_MACadd[39]} {R_Arbiter/my_MACadd[40]} {R_Arbiter/my_MACadd[41]} {R_Arbiter/my_MACadd[42]} {R_Arbiter/my_MACadd[43]} {R_Arbiter/my_MACadd[44]} {R_Arbiter/my_MACadd[45]} {R_Arbiter/my_MACadd[46]} {R_Arbiter/my_MACadd[47]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 3 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {R_Arbiter/ping_st[0]} {R_Arbiter/ping_st[1]} {R_Arbiter/ping_st[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 9 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {T_Arbiter/q_din[0]} {T_Arbiter/q_din[1]} {T_Arbiter/q_din[2]} {T_Arbiter/q_din[3]} {T_Arbiter/q_din[4]} {T_Arbiter/q_din[5]} {T_Arbiter/q_din[6]} {T_Arbiter/q_din[7]} {T_Arbiter/q_din[8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 9 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {UDP_d[0]} {UDP_d[1]} {UDP_d[2]} {UDP_d[3]} {UDP_d[4]} {UDP_d[5]} {UDP_d[6]} {UDP_d[7]} {UDP_d[8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 9 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {arp_d[0]} {arp_d[1]} {arp_d[2]} {arp_d[3]} {arp_d[4]} {arp_d[5]} {arp_d[6]} {arp_d[7]} {arp_d[8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 8 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {gmii_rxd[0]} {gmii_rxd[1]} {gmii_rxd[2]} {gmii_rxd[3]} {gmii_rxd[4]} {gmii_rxd[5]} {gmii_rxd[6]} {gmii_rxd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 9 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {ping_d[0]} {ping_d[1]} {ping_d[2]} {ping_d[3]} {ping_d[4]} {ping_d[5]} {ping_d[6]} {ping_d[7]} {ping_d[8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list arp_tx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list R_Arbiter/crc_ok_reg_n_0]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list ping_tx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list UDP_tx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list T_Arbiter/wr_en]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list clkgen/inst/clk125]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 32 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {T_Arbiter/CRC[0]} {T_Arbiter/CRC[1]} {T_Arbiter/CRC[2]} {T_Arbiter/CRC[3]} {T_Arbiter/CRC[4]} {T_Arbiter/CRC[5]} {T_Arbiter/CRC[6]} {T_Arbiter/CRC[7]} {T_Arbiter/CRC[8]} {T_Arbiter/CRC[9]} {T_Arbiter/CRC[10]} {T_Arbiter/CRC[11]} {T_Arbiter/CRC[12]} {T_Arbiter/CRC[13]} {T_Arbiter/CRC[14]} {T_Arbiter/CRC[15]} {T_Arbiter/CRC[16]} {T_Arbiter/CRC[17]} {T_Arbiter/CRC[18]} {T_Arbiter/CRC[19]} {T_Arbiter/CRC[20]} {T_Arbiter/CRC[21]} {T_Arbiter/CRC[22]} {T_Arbiter/CRC[23]} {T_Arbiter/CRC[24]} {T_Arbiter/CRC[25]} {T_Arbiter/CRC[26]} {T_Arbiter/CRC[27]} {T_Arbiter/CRC[28]} {T_Arbiter/CRC[29]} {T_Arbiter/CRC[30]} {T_Arbiter/CRC[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 9 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list {T_Arbiter/q_dout[0]} {T_Arbiter/q_dout[1]} {T_Arbiter/q_dout[2]} {T_Arbiter/q_dout[3]} {T_Arbiter/q_dout[4]} {T_Arbiter/q_dout[5]} {T_Arbiter/q_dout[6]} {T_Arbiter/q_dout[7]} {T_Arbiter/q_dout[8]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 32 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list {T_Arbiter/r_crc[0]} {T_Arbiter/r_crc[1]} {T_Arbiter/r_crc[2]} {T_Arbiter/r_crc[3]} {T_Arbiter/r_crc[4]} {T_Arbiter/r_crc[5]} {T_Arbiter/r_crc[6]} {T_Arbiter/r_crc[7]} {T_Arbiter/r_crc[8]} {T_Arbiter/r_crc[9]} {T_Arbiter/r_crc[10]} {T_Arbiter/r_crc[11]} {T_Arbiter/r_crc[12]} {T_Arbiter/r_crc[13]} {T_Arbiter/r_crc[14]} {T_Arbiter/r_crc[15]} {T_Arbiter/r_crc[16]} {T_Arbiter/r_crc[17]} {T_Arbiter/r_crc[18]} {T_Arbiter/r_crc[19]} {T_Arbiter/r_crc[20]} {T_Arbiter/r_crc[21]} {T_Arbiter/r_crc[22]} {T_Arbiter/r_crc[23]} {T_Arbiter/r_crc[24]} {T_Arbiter/r_crc[25]} {T_Arbiter/r_crc[26]} {T_Arbiter/r_crc[27]} {T_Arbiter/r_crc[28]} {T_Arbiter/r_crc[29]} {T_Arbiter/r_crc[30]} {T_Arbiter/r_crc[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 2 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list {T_Arbiter/st[0]} {T_Arbiter/st[1]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 8 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list {gmii_txd[0]} {gmii_txd[1]} {gmii_txd[2]} {gmii_txd[3]} {gmii_txd[4]} {gmii_txd[5]} {gmii_txd[6]} {gmii_txd[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe5]
set_property port_width 1 [get_debug_ports u_ila_1/probe5]
connect_debug_port u_ila_1/probe5 [get_nets [list arp_tx_en]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe6]
set_property port_width 1 [get_debug_ports u_ila_1/probe6]
connect_debug_port u_ila_1/probe6 [get_nets [list gmii_txctl]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe7]
set_property port_width 1 [get_debug_ports u_ila_1/probe7]
connect_debug_port u_ila_1/probe7 [get_nets [list ping_tx_en]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe8]
set_property port_width 1 [get_debug_ports u_ila_1/probe8]
connect_debug_port u_ila_1/probe8 [get_nets [list T_Arbiter/rd_en]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe9]
set_property port_width 1 [get_debug_ports u_ila_1/probe9]
connect_debug_port u_ila_1/probe9 [get_nets [list UDP_tx_en]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk125]
