// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Fri Jun 14 16:50:41 2019
// Host        : bluewater01.localdomain running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub
//               /home/tmitsuhashi/bin/vivado_h30/UDP_Image/UDP.srcs/sources_1/ip/image_8to32/image_8to32_stub.v
// Design      : image_8to32
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tsbg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_2,Vivado 2018.1" *)
module image_8to32(clk, srst, din, wr_en, rd_en, dout, full, overflow, 
  empty, valid, underflow)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[31:0],wr_en,rd_en,dout[31:0],full,overflow,empty,valid,underflow" */;
  input clk;
  input srst;
  input [31:0]din;
  input wr_en;
  input rd_en;
  output [31:0]dout;
  output full;
  output overflow;
  output empty;
  output valid;
  output underflow;
endmodule
