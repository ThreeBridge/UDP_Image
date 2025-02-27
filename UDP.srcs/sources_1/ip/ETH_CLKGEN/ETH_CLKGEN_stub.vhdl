-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
-- Date        : Fri Jun 28 17:55:56 2019
-- Host        : bluewater01.localdomain running 64-bit unknown
-- Command     : write_vhdl -force -mode synth_stub
--               /home/tmitsuhashi/bin/vivado_h30/UDP_Image/UDP.srcs/sources_1/ip/ETH_CLKGEN/ETH_CLKGEN_stub.vhdl
-- Design      : ETH_CLKGEN
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a200tsbg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ETH_CLKGEN is
  Port ( 
    rxck_0deg : out STD_LOGIC;
    rxck_90deg : out STD_LOGIC;
    rxck_180deg : out STD_LOGIC;
    clk200 : out STD_LOGIC;
    resetn : in STD_LOGIC;
    locked : out STD_LOGIC;
    eth_rxck : in STD_LOGIC
  );

end ETH_CLKGEN;

architecture stub of ETH_CLKGEN is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "rxck_0deg,rxck_90deg,rxck_180deg,clk200,resetn,locked,eth_rxck";
begin
end;
