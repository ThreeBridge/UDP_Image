### This file is a general .xdc for the Nexys Video Rev. A
### To use it in a project:
### - uncomment the lines corresponding to used pins
### - rename the used ports (in each line, after get_ports) according to the top level signal names in the project


### Clock Signal
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports SYSCLK]
#create_clock -period 8.000 -name phyrx_ddr -waveform {0.000 4.000}
#create_clock -period 8.000 -name PHY_RXCLK -waveform {2.000 6.000} [get_ports eth_rxck]
create_clock -period 8.000 -name PHY_RXCLK -waveform {0.000 4.000} [get_ports ETH_RXCK]
create_clock -period 8.000 -name PHY_TXCLK -waveform {0.000 4.000} [get_pins gmii2rgmii/ODDR_ck/Q]

set_input_jitter [get_clocks -of_objects [get_ports ETH_RXCK]] 0.080

#set_input_delay -clock phyrx_ddr -max 1.000 [get_ports {ETH_RXD[*]}]
#set_input_delay -clock phyrx_ddr -clock_fall -max -add_delay 1.000 [get_ports {ETH_RXD[*]}]
#set_input_delay -clock phyrx_ddr -min -1.000 [get_ports {ETH_RXD[*]}]
#set_input_delay -clock phyrx_ddr -clock_fall -min -add_delay -1.000 [get_ports {ETH_RXD[*]}]
#set_input_delay -clock phyrx_ddr -max 1.000 [get_ports ETH_RXCTL]
#set_input_delay -clock phyrx_ddr -clock_fall -min -1.000 [get_ports ETH_RXCTL]

set_input_delay -clock PHY_RXCLK -max 0.500 [get_ports {ETH_RXD[*]}]
set_input_delay -clock PHY_RXCLK -clock_fall -max -add_delay 0.500 [get_ports {ETH_RXD[*]}]
set_input_delay -clock PHY_RXCLK -min -0.500 [get_ports {ETH_RXD[*]}]
set_input_delay -clock PHY_RXCLK -clock_fall -min -add_delay -0.500 [get_ports {ETH_RXD[*]}]

set_input_delay -clock PHY_RXCLK -max 0.500 [get_ports ETH_RXCTL]
set_input_delay -clock PHY_RXCLK -clock_fall -max -add_delay 0.500 [get_ports ETH_RXCTL]
set_input_delay -clock PHY_RXCLK -min -0.500 [get_ports ETH_RXCTL]
set_input_delay -clock PHY_RXCLK -clock_fall -min -add_delay -0.500 [get_ports ETH_RXCTL]

## false_path
#set_false_path -setup -rise_from phyrx_ddr -fall_to PHY_RXCLK
#set_false_path -setup -fall_from phyrx_ddr -rise_to PHY_RXCLK
#set_false_path -hold -rise_from phyrx_ddr -fall_to PHY_RXCLK
#set_false_path -hold -fall_from phyrx_ddr -rise_to PHY_RXCLK

#set_false_path -from [get_cells R_Arbiter/ARP/tx_en_reg*] -to [get_cells R_Arbiter/ARP/tx_en_clk125_d_reg*]
#set_false_path -from [get_cells R_Arbiter/ping/tx_en_reg*] -to [get_cells R_Arbiter/ping/tx_en_clk125_d_reg*]
#set_false_path -from [get_cells R_Arbiter/trans_image/tx_en_reg*] -to [get_cells R_Arbiter/trans_image/tx_en_clk125_d_reg*]

#set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets pllsys/inst/SYSCLK_i_PLLSYS];
## FMC Transceiver clocks (Must be set to value provided by Mezzanine card, currently set to 156.25 MHz)
## Note: This clock is attached to a MGTREFCLK pin
#set_property -dict { PACKAGE_PIN E6 } [get_ports { GTP_CLK_N }];
#set_property -dict { PACKAGE_PIN F6 } [get_ports { GTP_CLK_P }];
#create_clock -add -name gtpclk0_pin -period 6.400 -waveform {0 3.200} [get_ports {GTP_CLK_P}];
#set_property -dict { PACKAGE_PIN E10 } [get_ports { FMC_MGT_CLK_N }];
#set_property -dict { PACKAGE_PIN F10 } [get_ports { FMC_MGT_CLK_P }];
#create_clock -add -name mgtclk1_pin -period 6.400 -waveform {0 3.200} [get_ports {FMC_MGT_CLK_P}];

## CLOCK
set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33} [get_ports SYSCLK]

## LEDs
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS25} [get_ports {LED[0]}]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS25} [get_ports {LED[1]}]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports {LED[2]}]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS25} [get_ports {LED[3]}]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS25} [get_ports {LED[4]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS25} [get_ports {LED[5]}]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS25} [get_ports {LED[6]}]
set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS25} [get_ports {LED[7]}]
set_false_path -to [get_ports {LED[*]}]

## Buttons
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS33} [get_ports BTN_C]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS15} [get_ports CPU_RSTN]
set_false_path -from [get_ports BTN_C]
set_false_path -from [get_ports CPU_RSTN]

## Switches
set_property -dict {PACKAGE_PIN E22 IOSTANDARD LVCMOS33} [get_ports {SW[0]}]
set_property -dict {PACKAGE_PIN F21 IOSTANDARD LVCMOS33} [get_ports {SW[1]}]
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS33} [get_ports {SW[2]}]
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS33} [get_ports {SW[3]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {SW[4]}]
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports {SW[5]}]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports {SW[6]}]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports {SW[7]}]
set_false_path -from [get_ports {SW[*]}]

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
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports {PMOD_A[0]}]
set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS33} [get_ports {PMOD_A[1]}]
set_property -dict {PACKAGE_PIN AB20 IOSTANDARD LVCMOS33} [get_ports {PMOD_A[2]}]
set_property -dict {PACKAGE_PIN AB18 IOSTANDARD LVCMOS33} [get_ports {PMOD_A[3]}]
set_property -dict {PACKAGE_PIN Y21 IOSTANDARD LVCMOS33} [get_ports {PMOD_A[4]}]
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports {PMOD_A[5]}]
set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS33} [get_ports {PMOD_A[6]}]
set_property -dict {PACKAGE_PIN AA18 IOSTANDARD LVCMOS33} [get_ports {PMOD_A[7]}]
set_false_path -to [get_ports {PMOD_A[*]}]

## Pmod header JB
set_property -dict {PACKAGE_PIN V9 IOSTANDARD LVCMOS33} [get_ports {PMOD_B[0]}]
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVCMOS33} [get_ports {PMOD_B[1]}]
set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVCMOS33} [get_ports {PMOD_B[2]}]
set_property -dict {PACKAGE_PIN W7 IOSTANDARD LVCMOS33} [get_ports {PMOD_B[3]}]
set_property -dict {PACKAGE_PIN W9 IOSTANDARD LVCMOS33} [get_ports {PMOD_B[4]}]
set_property -dict {PACKAGE_PIN Y9 IOSTANDARD LVCMOS33} [get_ports {PMOD_B[5]}]
set_property -dict {PACKAGE_PIN Y8 IOSTANDARD LVCMOS33} [get_ports {PMOD_B[6]}]
set_property -dict {PACKAGE_PIN Y7 IOSTANDARD LVCMOS33} [get_ports {PMOD_B[7]}]
set_false_path -to [get_ports {PMOD_B[*]}]

## Pmod header JC
set_property -dict {PACKAGE_PIN Y6 IOSTANDARD LVCMOS33} [get_ports {PMOD_C[0]}]
set_property -dict {PACKAGE_PIN AA6 IOSTANDARD LVCMOS33} [get_ports {PMOD_C[1]}]
set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS33} [get_ports {PMOD_C[2]}]
set_property -dict {PACKAGE_PIN AB8 IOSTANDARD LVCMOS33} [get_ports {PMOD_C[3]}]
set_property -dict {PACKAGE_PIN R6 IOSTANDARD LVCMOS33} [get_ports {PMOD_C[4]}]
set_property -dict {PACKAGE_PIN T6 IOSTANDARD LVCMOS33} [get_ports {PMOD_C[5]}]
set_property -dict {PACKAGE_PIN AB7 IOSTANDARD LVCMOS33} [get_ports {PMOD_C[6]}]
set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS33} [get_ports {PMOD_C[7]}]
set_false_path -to [get_ports {PMOD_C[*]}]

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
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS25} [get_ports eth_int_b]
set_property -dict {PACKAGE_PIN AA16 IOSTANDARD LVCMOS25} [get_ports eth_mdc]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS25} [get_ports eth_mdio]
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS25} [get_ports eth_pme_b]

set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports ETH_RST_B]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS25} [get_ports ETH_RXCK]
set_property -dict {PACKAGE_PIN W10 IOSTANDARD LVCMOS25} [get_ports ETH_RXCTL]
set_property -dict {PACKAGE_PIN AB16 IOSTANDARD LVCMOS25} [get_ports {ETH_RXD[0]}]
set_property -dict {PACKAGE_PIN AA15 IOSTANDARD LVCMOS25} [get_ports {ETH_RXD[1]}]
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS25} [get_ports {ETH_RXD[2]}]
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS25} [get_ports {ETH_RXD[3]}]
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS25} [get_ports ETH_TXCK]
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS25} [get_ports ETH_TXCTL]
set_property -dict {PACKAGE_PIN Y12 IOSTANDARD LVCMOS25} [get_ports {ETH_TXD[0]}]
set_property -dict {PACKAGE_PIN W12 IOSTANDARD LVCMOS25} [get_ports {ETH_TXD[1]}]
set_property -dict {PACKAGE_PIN W11 IOSTANDARD LVCMOS25} [get_ports {ETH_TXD[2]}]
set_property -dict {PACKAGE_PIN Y11 IOSTANDARD LVCMOS25} [get_ports {ETH_TXD[3]}]

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

#DDR3
set_property -dict {PACKAGE_PIN M2} [get_ports {ddr3_addr[0]}]
set_property -dict {PACKAGE_PIN M5} [get_ports {ddr3_addr[1]}]
set_property -dict {PACKAGE_PIN M3} [get_ports {ddr3_addr[2]}]
set_property -dict {PACKAGE_PIN M1} [get_ports {ddr3_addr[3]}]
set_property -dict {PACKAGE_PIN L6} [get_ports {ddr3_addr[4]}]
set_property -dict {PACKAGE_PIN P1} [get_ports {ddr3_addr[5]}]
set_property -dict {PACKAGE_PIN N3} [get_ports {ddr3_addr[6]}]
set_property -dict {PACKAGE_PIN N2} [get_ports {ddr3_addr[7]}]
set_property -dict {PACKAGE_PIN M6} [get_ports {ddr3_addr[8]}]
set_property -dict {PACKAGE_PIN R1} [get_ports {ddr3_addr[9]}]
set_property -dict {PACKAGE_PIN L5} [get_ports {ddr3_addr[10]}]
set_property -dict {PACKAGE_PIN N5} [get_ports {ddr3_addr[11]}]
set_property -dict {PACKAGE_PIN N4} [get_ports {ddr3_addr[12]}]
set_property -dict {PACKAGE_PIN P2} [get_ports {ddr3_addr[13]}]
set_property -dict {PACKAGE_PIN P6} [get_ports {ddr3_addr[14]}]
set_property -dict {PACKAGE_PIN L3} [get_ports {ddr3_ba[0]}]
set_property -dict {PACKAGE_PIN K6} [get_ports {ddr3_ba[1]}]
set_property -dict {PACKAGE_PIN L4} [get_ports {ddr3_ba[2]}]
set_property -dict { PACKAGE_PIN K3   } [get_ports { ddr3_cas }]; #IO_L14N_T2_SRCC_35 Sch=ddr3_cas
set_property -dict { PACKAGE_PIN J6   } [get_ports { ddr3_cke[0] }]; #IO_L17N_T2_35 Sch=ddr3_cke[0]
set_property -dict { PACKAGE_PIN P4    IOSTANDARD LVDS     } [get_ports { ddr3_clk_n[0] }]; #IO_L21N_T3_DQS_35 Sch=ddr3_clk_n[0]
set_property -dict { PACKAGE_PIN P5    IOSTANDARD LVDS     } [get_ports { ddr3_clk_p[0] }]; #IO_L21P_T3_DQS_35 Sch=ddr3_clk_p[0]
set_property -dict {PACKAGE_PIN G3} [get_ports {ddr3_dm[0]}]
set_property -dict {PACKAGE_PIN F1} [get_ports {ddr3_dm[1]}]
set_property -dict {PACKAGE_PIN G2} [get_ports {ddr3_dq[0]}]
set_property -dict {PACKAGE_PIN H4} [get_ports {ddr3_dq[1]}]
set_property -dict {PACKAGE_PIN H5} [get_ports {ddr3_dq[2]}]
set_property -dict {PACKAGE_PIN J1} [get_ports {ddr3_dq[3]}]
set_property -dict {PACKAGE_PIN K1} [get_ports {ddr3_dq[4]}]
set_property -dict {PACKAGE_PIN H3} [get_ports {ddr3_dq[5]}]
set_property -dict {PACKAGE_PIN H2} [get_ports {ddr3_dq[6]}]
set_property -dict {PACKAGE_PIN J5} [get_ports {ddr3_dq[7]}]
set_property -dict {PACKAGE_PIN E3} [get_ports {ddr3_dq[8]}]
set_property -dict {PACKAGE_PIN B2} [get_ports {ddr3_dq[9]}]
set_property -dict {PACKAGE_PIN F3} [get_ports {ddr3_dq[10]}]
set_property -dict {PACKAGE_PIN D2} [get_ports {ddr3_dq[11]}]
set_property -dict {PACKAGE_PIN C2} [get_ports {ddr3_dq[12]}]
set_property -dict {PACKAGE_PIN A1} [get_ports {ddr3_dq[13]}]
set_property -dict {PACKAGE_PIN E2} [get_ports {ddr3_dq[14]}]
set_property -dict {PACKAGE_PIN B1} [get_ports {ddr3_dq[15]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_n[0]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_n[0]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_n[0]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_n[0]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_n[0]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_n[0]}]
set_property -dict { PACKAGE_PIN J2    IOSTANDARD LVDS     } [get_ports { ddr3_dqs_n[0] }]; #IO_L9N_T1_DQS_AD7N_35 Sch=ddr3_dqs_n[0]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_p[0]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_p[0]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_p[0]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_p[0]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_p[0]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_p[0]}]
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVDS     } [get_ports { ddr3_dqs_p[0] }]; #IO_L9P_T1_DQS_AD7P_35 Sch=ddr3_dqs_p[0]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_n[1]}]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_n[1]}]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_n[1]}]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_n[1]}]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_n[1]}]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_n[1]}]
set_property -dict { PACKAGE_PIN D1    IOSTANDARD LVDS     } [get_ports { ddr3_dqs_n[1] }]; #IO_L3N_T0_DQS_AD5N_35 Sch=ddr3_dqs_n[1]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_p[1]}]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_p[1]}]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_p[1]}]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_p[1]}]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_p[1]}]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD DIFF_SSTL15} [get_ports {ddr3_dqs_p[1]}]
set_property -dict { PACKAGE_PIN E1    IOSTANDARD LVDS     } [get_ports { ddr3_dqs_p[1] }]; #IO_L3P_T0_DQS_AD5P_35 Sch=ddr3_dqs_p[1]
set_property -dict {PACKAGE_PIN K4} [get_ports ddr3_odt]
set_property -dict { PACKAGE_PIN J4   } [get_ports { ddr3_ras }]; #IO_L13N_T2_MRCC_35 Sch=ddr3_ras
set_property -dict { PACKAGE_PIN G1   } [get_ports { ddr3_reset }]; #IO_L5P_T0_AD13P_35 Sch=ddr3_reset
set_property -dict { PACKAGE_PIN L1   } [get_ports { ddr3_we }]; #IO_L15N_T2_DQS_35 Sch=ddr3_we

## Voltage Adjust
set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS25} [get_ports {SET_VADJ[0]}]
set_property -dict {PACKAGE_PIN AB17 IOSTANDARD LVCMOS25} [get_ports {SET_VADJ[1]}]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS25} [get_ports VADJ_EN]
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

#set_multicycle_path -setup -rise_from [get_cells R_Arbiter/ping/rx_cnt_reg*] -rise_to [get_cells R_Arbiter/ping/TXBUF_reg*] 2
set_false_path -from [get_cells R_Arbiter/ping/rx_cnt_reg*] -to [get_cells R_Arbiter/ping/TXBUF_reg*]



#set_multicycle_path -setup -rise_from [get_cells R_Arbiter/trans_image/st_reg*] -rise_to [get_cells R_Arbiter/trans_image/TXBUF_reg*] 2
#set_multicycle_path -hold -rise_from [get_cells R_Arbiter/trans_image/st_reg*] -rise_to [get_cells R_Arbiter/trans_image/TXBUF_reg*] 1
#set_multicycle_path -setup -rise_from [get_cells R_Arbiter/recv_image/RXBUF_reg*] -rise_to [get_cells R_Arbiter/recv_image/csum_ok_reg*] 2
#set_multicycle_path -hold -rise_from [get_cells R_Arbiter/recv_image/RXBUF_reg*] -rise_to [get_cells R_Arbiter/recv_image/csum_ok_reg*] 1


connect_debug_port u_ila_0/probe29 [get_nets [list R_Arbiter/recv_image/axi_write/fifo_sel]]

connect_debug_port u_ila_0/probe11 [get_nets [list {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[0]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[1]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[2]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[3]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[4]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[5]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[6]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[7]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[8]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[9]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[10]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[11]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[12]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[13]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[14]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[15]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[16]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[17]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[18]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[19]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[20]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[21]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[22]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[23]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[24]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[25]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[26]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[27]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[28]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[29]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[30]} {R_Arbiter/recv_image/axi_write/image_8to32_1/dout[31]}]]
connect_debug_port u_ila_0/probe12 [get_nets [list {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[0]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[1]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[2]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[3]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[4]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[5]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[6]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[7]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[8]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[9]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[10]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[11]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[12]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[13]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[14]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[15]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[16]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[17]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[18]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[19]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[20]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[21]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[22]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[23]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[24]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[25]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[26]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[27]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[28]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[29]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[30]} {R_Arbiter/recv_image/axi_write/image_8to32_0/dout[31]}]]
connect_debug_port u_ila_0/probe20 [get_nets [list {R_Arbiter/recv_image/axi_write/write_cnt_reg__0[0]} {R_Arbiter/recv_image/axi_write/write_cnt_reg__0[1]} {R_Arbiter/recv_image/axi_write/write_cnt_reg__0[2]} {R_Arbiter/recv_image/axi_write/write_cnt_reg__0[3]} {R_Arbiter/recv_image/axi_write/write_cnt_reg__0[4]} {R_Arbiter/recv_image/axi_write/write_cnt_reg__0[5]} {R_Arbiter/recv_image/axi_write/write_cnt_reg__0[6]} {R_Arbiter/recv_image/axi_write/write_cnt_reg__0[7]}]]



create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list eth_clkgen/inst/rxck_90deg]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 4 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {R_Arbiter/st[0]} {R_Arbiter/st[1]} {R_Arbiter/st[2]} {R_Arbiter/st[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {T_Arbiter/r_crc[0]} {T_Arbiter/r_crc[1]} {T_Arbiter/r_crc[2]} {T_Arbiter/r_crc[3]} {T_Arbiter/r_crc[4]} {T_Arbiter/r_crc[5]} {T_Arbiter/r_crc[6]} {T_Arbiter/r_crc[7]} {T_Arbiter/r_crc[8]} {T_Arbiter/r_crc[9]} {T_Arbiter/r_crc[10]} {T_Arbiter/r_crc[11]} {T_Arbiter/r_crc[12]} {T_Arbiter/r_crc[13]} {T_Arbiter/r_crc[14]} {T_Arbiter/r_crc[15]} {T_Arbiter/r_crc[16]} {T_Arbiter/r_crc[17]} {T_Arbiter/r_crc[18]} {T_Arbiter/r_crc[19]} {T_Arbiter/r_crc[20]} {T_Arbiter/r_crc[21]} {T_Arbiter/r_crc[22]} {T_Arbiter/r_crc[23]} {T_Arbiter/r_crc[24]} {T_Arbiter/r_crc[25]} {T_Arbiter/r_crc[26]} {T_Arbiter/r_crc[27]} {T_Arbiter/r_crc[28]} {T_Arbiter/r_crc[29]} {T_Arbiter/r_crc[30]} {T_Arbiter/r_crc[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 3 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {R_Arbiter/UDP_st[0]} {R_Arbiter/UDP_st[1]} {R_Arbiter/UDP_st[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {R_Arbiter/trans_image/st[0]} {R_Arbiter/trans_image/st[1]} {R_Arbiter/trans_image/st[2]} {R_Arbiter/trans_image/st[3]} {R_Arbiter/trans_image/st[4]} {R_Arbiter/trans_image/st[5]} {R_Arbiter/trans_image/st[6]} {R_Arbiter/trans_image/st[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 9 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {R_Arbiter/trans_image/packet_cnt_reg__0[0]} {R_Arbiter/trans_image/packet_cnt_reg__0[1]} {R_Arbiter/trans_image/packet_cnt_reg__0[2]} {R_Arbiter/trans_image/packet_cnt_reg__0[3]} {R_Arbiter/trans_image/packet_cnt_reg__0[4]} {R_Arbiter/trans_image/packet_cnt_reg__0[5]} {R_Arbiter/trans_image/packet_cnt_reg__0[6]} {R_Arbiter/trans_image/packet_cnt_reg__0[7]} {R_Arbiter/trans_image/packet_cnt_reg__0[8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 8 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {R_Arbiter/recv_image/st[0]} {R_Arbiter/recv_image/st[1]} {R_Arbiter/recv_image/st[2]} {R_Arbiter/recv_image/st[3]} {R_Arbiter/recv_image/st[4]} {R_Arbiter/recv_image/st[5]} {R_Arbiter/recv_image/st[6]} {R_Arbiter/recv_image/st[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {R_Arbiter/recv_image/data[0]} {R_Arbiter/recv_image/data[1]} {R_Arbiter/recv_image/data[2]} {R_Arbiter/recv_image/data[3]} {R_Arbiter/recv_image/data[4]} {R_Arbiter/recv_image/data[5]} {R_Arbiter/recv_image/data[6]} {R_Arbiter/recv_image/data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 16 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {R_Arbiter/recv_image/csum[0]} {R_Arbiter/recv_image/csum[1]} {R_Arbiter/recv_image/csum[2]} {R_Arbiter/recv_image/csum[3]} {R_Arbiter/recv_image/csum[4]} {R_Arbiter/recv_image/csum[5]} {R_Arbiter/recv_image/csum[6]} {R_Arbiter/recv_image/csum[7]} {R_Arbiter/recv_image/csum[8]} {R_Arbiter/recv_image/csum[9]} {R_Arbiter/recv_image/csum[10]} {R_Arbiter/recv_image/csum[11]} {R_Arbiter/recv_image/csum[12]} {R_Arbiter/recv_image/csum[13]} {R_Arbiter/recv_image/csum[14]} {R_Arbiter/recv_image/csum[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 11 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {R_Arbiter/recv_image/csum_cnt[0]} {R_Arbiter/recv_image/csum_cnt[1]} {R_Arbiter/recv_image/csum_cnt[2]} {R_Arbiter/recv_image/csum_cnt[3]} {R_Arbiter/recv_image/csum_cnt[4]} {R_Arbiter/recv_image/csum_cnt[5]} {R_Arbiter/recv_image/csum_cnt[6]} {R_Arbiter/recv_image/csum_cnt[7]} {R_Arbiter/recv_image/csum_cnt[8]} {R_Arbiter/recv_image/csum_cnt[9]} {R_Arbiter/recv_image/csum_cnt[10]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 2 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {R_Arbiter/trans_image/axi_read/st_ar[0]} {R_Arbiter/trans_image/axi_read/st_ar[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 8 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {R_Arbiter/trans_image/data[0]} {R_Arbiter/trans_image/data[1]} {R_Arbiter/trans_image/data[2]} {R_Arbiter/trans_image/data[3]} {R_Arbiter/trans_image/data[4]} {R_Arbiter/trans_image/data[5]} {R_Arbiter/trans_image/data[6]} {R_Arbiter/trans_image/data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 19 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {axi_aw[addr][0]} {axi_aw[addr][1]} {axi_aw[addr][2]} {axi_aw[addr][3]} {axi_aw[addr][4]} {axi_aw[addr][5]} {axi_aw[addr][6]} {axi_aw[addr][7]} {axi_aw[addr][8]} {axi_aw[addr][9]} {axi_aw[addr][10]} {axi_aw[addr][11]} {axi_aw[addr][12]} {axi_aw[addr][13]} {axi_aw[addr][14]} {axi_aw[addr][15]} {axi_aw[addr][16]} {axi_aw[addr][17]} {axi_aw[addr][18]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 24 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {axi_r[data][0]} {axi_r[data][1]} {axi_r[data][2]} {axi_r[data][3]} {axi_r[data][4]} {axi_r[data][5]} {axi_r[data][6]} {axi_r[data][7]} {axi_r[data][8]} {axi_r[data][9]} {axi_r[data][10]} {axi_r[data][11]} {axi_r[data][12]} {axi_r[data][13]} {axi_r[data][14]} {axi_r[data][15]} {axi_r[data][16]} {axi_r[data][17]} {axi_r[data][18]} {axi_r[data][19]} {axi_r[data][20]} {axi_r[data][21]} {axi_r[data][22]} {axi_r[data][23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 8 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {gmii_txd[0]} {gmii_txd[1]} {gmii_txd[2]} {gmii_txd[3]} {gmii_txd[4]} {gmii_txd[5]} {gmii_txd[6]} {gmii_txd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 8 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {gmii_rxd[0]} {gmii_rxd[1]} {gmii_rxd[2]} {gmii_rxd[3]} {gmii_rxd[4]} {gmii_rxd[5]} {gmii_rxd[6]} {gmii_rxd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 2 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {R_Arbiter/recv_image/axi_write/st_aw[0]} {R_Arbiter/recv_image/axi_write/st_aw[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 3 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {R_Arbiter/recv_image/axi_write/w_ch_st_reg__0[0]} {R_Arbiter/recv_image/axi_write/w_ch_st_reg__0[1]} {R_Arbiter/recv_image/axi_write/w_ch_st_reg__0[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list axi_awready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {axi_r[last]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {axi_r[valid]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {axi_w[valid]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list R_Arbiter/crc_ok]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list R_Arbiter/recv_image/csum_ok]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list gmii_rxctl]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list gmii_txctl]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list R_Arbiter/recvend]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {axi_ar[valid]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets eth_rxck]
