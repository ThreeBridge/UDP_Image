// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Mon Dec 17 18:05:58 2018
// Host        : bluewater01.localdomain running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub
//               /home/tmitsuhashi/bin/vivado_h30/UDP_Image/UDP.srcs/sources_1/ip/queue/queue_stub.v
// Design      : queue
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tsbg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_2,Vivado 2018.1" *)
module queue(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  overflow, empty, valid, underflow, rd_data_count, wr_data_count, wr_rst_busy, rd_rst_busy)
/* synthesis syn_black_box black_box_pad_pin="rst,wr_clk,rd_clk,din[8:0],wr_en,rd_en,dout[8:0],full,overflow,empty,valid,underflow,rd_data_count[10:0],wr_data_count[10:0],wr_rst_busy,rd_rst_busy" */;
  input rst;
  input wr_clk;
  input rd_clk;
  input [8:0]din;
  input wr_en;
  input rd_en;
  output [8:0]dout;
  output full;
  output overflow;
  output empty;
  output valid;
  output underflow;
  output [10:0]rd_data_count;
  output [10:0]wr_data_count;
  output wr_rst_busy;
  output rd_rst_busy;
endmodule
