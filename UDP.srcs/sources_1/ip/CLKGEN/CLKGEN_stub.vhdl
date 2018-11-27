-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
-- Date        : Tue May 29 16:17:03 2018
-- Host        : bluewater01.localdomain running 64-bit unknown
-- Command     : write_vhdl -force -mode synth_stub
--               /home/tmitsuhashi/bin/vivado_h30/rarp_20180522debug/rarp_20180522debug.srcs/sources_1/ip/CLKGEN/CLKGEN_stub.vhdl
-- Design      : CLKGEN
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a200tsbg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLKGEN is
  Port ( 
    clk125 : out STD_LOGIC;
    clk100 : out STD_LOGIC;
    clk10 : out STD_LOGIC;
    clk125_90 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    SYSCLK : in STD_LOGIC
  );

end CLKGEN;

architecture stub of CLKGEN is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk125,clk100,clk10,clk125_90,reset,locked,SYSCLK";
begin
end;
