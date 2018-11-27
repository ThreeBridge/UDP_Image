// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Tue May 29 16:17:03 2018
// Host        : bluewater01.localdomain running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub
//               /home/tmitsuhashi/bin/vivado_h30/rarp_20180522debug/rarp_20180522debug.srcs/sources_1/ip/CLKGEN/CLKGEN_stub.v
// Design      : CLKGEN
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tsbg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module CLKGEN(clk125, clk100, clk10, clk125_90, reset, locked, 
  SYSCLK)
/* synthesis syn_black_box black_box_pad_pin="clk125,clk100,clk10,clk125_90,reset,locked,SYSCLK" */;
  output clk125;
  output clk100;
  output clk10;
  output clk125_90;
  input reset;
  output locked;
  input SYSCLK;
endmodule
