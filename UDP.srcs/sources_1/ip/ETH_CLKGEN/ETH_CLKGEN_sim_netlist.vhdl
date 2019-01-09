-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
-- Date        : Mon Dec 24 21:25:53 2018
-- Host        : Z10PE-01 running 64-bit Ubuntu 16.04.5 LTS
-- Command     : write_vhdl -force -mode funcsim
--               /home/moikawa/proj_Mitsuhashi/UDP_20181221/UDP.srcs/sources_1/ip/ETH_CLKGEN/ETH_CLKGEN_sim_netlist.vhdl
-- Design      : ETH_CLKGEN
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a200tsbg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity ETH_CLKGEN_ETH_CLKGEN_clk_wiz is
  port (
    rxck_0deg : out STD_LOGIC;
    rxck_90deg : out STD_LOGIC;
    rxck_180deg : out STD_LOGIC;
    rxck_270deg : out STD_LOGIC;
    rxck_n90deg : out STD_LOGIC;
    resetn : in STD_LOGIC;
    locked : out STD_LOGIC;
    eth_rxck : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of ETH_CLKGEN_ETH_CLKGEN_clk_wiz : entity is "ETH_CLKGEN_clk_wiz";
end ETH_CLKGEN_ETH_CLKGEN_clk_wiz;

architecture STRUCTURE of ETH_CLKGEN_ETH_CLKGEN_clk_wiz is
  signal clkfbout_ETH_CLKGEN : STD_LOGIC;
  signal clkfbout_buf_ETH_CLKGEN : STD_LOGIC;
  signal eth_rxck_ETH_CLKGEN : STD_LOGIC;
  signal reset_high : STD_LOGIC;
  signal rxck_0deg_ETH_CLKGEN : STD_LOGIC;
  signal rxck_180deg_ETH_CLKGEN : STD_LOGIC;
  signal rxck_270deg_ETH_CLKGEN : STD_LOGIC;
  signal rxck_90deg_ETH_CLKGEN : STD_LOGIC;
  signal rxck_n90deg_ETH_CLKGEN : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_DRDY_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_PSDONE_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_DO_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of clkf_buf : label is "PRIMITIVE";
  attribute BOX_TYPE of clkin1_ibufg : label is "PRIMITIVE";
  attribute CAPACITANCE : string;
  attribute CAPACITANCE of clkin1_ibufg : label is "DONT_CARE";
  attribute IBUF_DELAY_VALUE : string;
  attribute IBUF_DELAY_VALUE of clkin1_ibufg : label is "0";
  attribute IFD_DELAY_VALUE : string;
  attribute IFD_DELAY_VALUE of clkin1_ibufg : label is "AUTO";
  attribute BOX_TYPE of clkout1_buf : label is "PRIMITIVE";
  attribute BOX_TYPE of clkout2_buf : label is "PRIMITIVE";
  attribute BOX_TYPE of clkout3_buf : label is "PRIMITIVE";
  attribute BOX_TYPE of clkout4_buf : label is "PRIMITIVE";
  attribute BOX_TYPE of clkout5_buf : label is "PRIMITIVE";
  attribute BOX_TYPE of mmcm_adv_inst : label is "PRIMITIVE";
begin
clkf_buf: unisim.vcomponents.BUFG
     port map (
      I => clkfbout_ETH_CLKGEN,
      O => clkfbout_buf_ETH_CLKGEN
    );
clkin1_ibufg: unisim.vcomponents.IBUF
    generic map(
      IOSTANDARD => "DEFAULT"
    )
        port map (
      I => eth_rxck,
      O => eth_rxck_ETH_CLKGEN
    );
clkout1_buf: unisim.vcomponents.BUFG
     port map (
      I => rxck_0deg_ETH_CLKGEN,
      O => rxck_0deg
    );
clkout2_buf: unisim.vcomponents.BUFG
     port map (
      I => rxck_90deg_ETH_CLKGEN,
      O => rxck_90deg
    );
clkout3_buf: unisim.vcomponents.BUFG
     port map (
      I => rxck_180deg_ETH_CLKGEN,
      O => rxck_180deg
    );
clkout4_buf: unisim.vcomponents.BUFG
     port map (
      I => rxck_270deg_ETH_CLKGEN,
      O => rxck_270deg
    );
clkout5_buf: unisim.vcomponents.BUFG
     port map (
      I => rxck_n90deg_ETH_CLKGEN,
      O => rxck_n90deg
    );
mmcm_adv_inst: unisim.vcomponents.MMCME2_ADV
    generic map(
      BANDWIDTH => "OPTIMIZED",
      CLKFBOUT_MULT_F => 8.000000,
      CLKFBOUT_PHASE => 0.000000,
      CLKFBOUT_USE_FINE_PS => false,
      CLKIN1_PERIOD => 8.000000,
      CLKIN2_PERIOD => 0.000000,
      CLKOUT0_DIVIDE_F => 8.000000,
      CLKOUT0_DUTY_CYCLE => 0.500000,
      CLKOUT0_PHASE => 0.000000,
      CLKOUT0_USE_FINE_PS => false,
      CLKOUT1_DIVIDE => 8,
      CLKOUT1_DUTY_CYCLE => 0.500000,
      CLKOUT1_PHASE => 90.000000,
      CLKOUT1_USE_FINE_PS => false,
      CLKOUT2_DIVIDE => 8,
      CLKOUT2_DUTY_CYCLE => 0.500000,
      CLKOUT2_PHASE => 180.000000,
      CLKOUT2_USE_FINE_PS => false,
      CLKOUT3_DIVIDE => 8,
      CLKOUT3_DUTY_CYCLE => 0.500000,
      CLKOUT3_PHASE => 270.000000,
      CLKOUT3_USE_FINE_PS => false,
      CLKOUT4_CASCADE => false,
      CLKOUT4_DIVIDE => 8,
      CLKOUT4_DUTY_CYCLE => 0.500000,
      CLKOUT4_PHASE => -90.000000,
      CLKOUT4_USE_FINE_PS => false,
      CLKOUT5_DIVIDE => 1,
      CLKOUT5_DUTY_CYCLE => 0.500000,
      CLKOUT5_PHASE => 0.000000,
      CLKOUT5_USE_FINE_PS => false,
      CLKOUT6_DIVIDE => 1,
      CLKOUT6_DUTY_CYCLE => 0.500000,
      CLKOUT6_PHASE => 0.000000,
      CLKOUT6_USE_FINE_PS => false,
      COMPENSATION => "ZHOLD",
      DIVCLK_DIVIDE => 1,
      IS_CLKINSEL_INVERTED => '0',
      IS_PSEN_INVERTED => '0',
      IS_PSINCDEC_INVERTED => '0',
      IS_PWRDWN_INVERTED => '0',
      IS_RST_INVERTED => '0',
      REF_JITTER1 => 0.010000,
      REF_JITTER2 => 0.010000,
      SS_EN => "FALSE",
      SS_MODE => "CENTER_HIGH",
      SS_MOD_PERIOD => 10000,
      STARTUP_WAIT => false
    )
        port map (
      CLKFBIN => clkfbout_buf_ETH_CLKGEN,
      CLKFBOUT => clkfbout_ETH_CLKGEN,
      CLKFBOUTB => NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED,
      CLKFBSTOPPED => NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED,
      CLKIN1 => eth_rxck_ETH_CLKGEN,
      CLKIN2 => '0',
      CLKINSEL => '1',
      CLKINSTOPPED => NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED,
      CLKOUT0 => rxck_0deg_ETH_CLKGEN,
      CLKOUT0B => NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED,
      CLKOUT1 => rxck_90deg_ETH_CLKGEN,
      CLKOUT1B => NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED,
      CLKOUT2 => rxck_180deg_ETH_CLKGEN,
      CLKOUT2B => NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED,
      CLKOUT3 => rxck_270deg_ETH_CLKGEN,
      CLKOUT3B => NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED,
      CLKOUT4 => rxck_n90deg_ETH_CLKGEN,
      CLKOUT5 => NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED,
      CLKOUT6 => NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED,
      DADDR(6 downto 0) => B"0000000",
      DCLK => '0',
      DEN => '0',
      DI(15 downto 0) => B"0000000000000000",
      DO(15 downto 0) => NLW_mmcm_adv_inst_DO_UNCONNECTED(15 downto 0),
      DRDY => NLW_mmcm_adv_inst_DRDY_UNCONNECTED,
      DWE => '0',
      LOCKED => locked,
      PSCLK => '0',
      PSDONE => NLW_mmcm_adv_inst_PSDONE_UNCONNECTED,
      PSEN => '0',
      PSINCDEC => '0',
      PWRDWN => '0',
      RST => reset_high
    );
mmcm_adv_inst_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => resetn,
      O => reset_high
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity ETH_CLKGEN is
  port (
    rxck_0deg : out STD_LOGIC;
    rxck_90deg : out STD_LOGIC;
    rxck_180deg : out STD_LOGIC;
    rxck_270deg : out STD_LOGIC;
    rxck_n90deg : out STD_LOGIC;
    resetn : in STD_LOGIC;
    locked : out STD_LOGIC;
    eth_rxck : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of ETH_CLKGEN : entity is true;
end ETH_CLKGEN;

architecture STRUCTURE of ETH_CLKGEN is
begin
inst: entity work.ETH_CLKGEN_ETH_CLKGEN_clk_wiz
     port map (
      eth_rxck => eth_rxck,
      locked => locked,
      resetn => resetn,
      rxck_0deg => rxck_0deg,
      rxck_180deg => rxck_180deg,
      rxck_270deg => rxck_270deg,
      rxck_90deg => rxck_90deg,
      rxck_n90deg => rxck_n90deg
    );
end STRUCTURE;
