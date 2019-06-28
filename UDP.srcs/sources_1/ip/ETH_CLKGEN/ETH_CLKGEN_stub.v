// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Fri Jun 28 17:55:56 2019
// Host        : bluewater01.localdomain running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub
//               /home/tmitsuhashi/bin/vivado_h30/UDP_Image/UDP.srcs/sources_1/ip/ETH_CLKGEN/ETH_CLKGEN_stub.v
// Design      : ETH_CLKGEN
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tsbg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module ETH_CLKGEN(rxck_0deg, rxck_90deg, rxck_180deg, clk200, 
  resetn, locked, eth_rxck)
/* synthesis syn_black_box black_box_pad_pin="rxck_0deg,rxck_90deg,rxck_180deg,clk200,resetn,locked,eth_rxck" */;
  output rxck_0deg;
  output rxck_90deg;
  output rxck_180deg;
  output clk200;
  input resetn;
  output locked;
  input eth_rxck;
endmodule
