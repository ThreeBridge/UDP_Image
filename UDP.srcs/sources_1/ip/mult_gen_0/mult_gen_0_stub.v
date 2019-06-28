// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Fri Jun 21 18:35:43 2019
// Host        : bluewater01.localdomain running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub
//               /home/tmitsuhashi/bin/vivado_h30/UDP_Image/UDP.srcs/sources_1/ip/mult_gen_0/mult_gen_0_stub.v
// Design      : mult_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tsbg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_14,Vivado 2018.1" *)
module mult_gen_0(CLK, A, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,A[13:0],P[28:0]" */;
  input CLK;
  input [13:0]A;
  output [28:0]P;
endmodule
