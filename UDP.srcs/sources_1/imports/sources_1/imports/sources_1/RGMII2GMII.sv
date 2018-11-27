//                              -*- Mode: Verilog -*-
// Filename        : RGMII2GMII.sv
// Description     : 
// Author          : Minoru OIKAWA
// Created On      : Wed May 23 13:35:08 2018
// Last Modified By: 
// Last Modified On: 2018-05-23 16:33:29
// Update Count    : 0
// Status          : Unknown, Use with caution!

module RGMII2GMII (
   input [3:0]  rxd_i,
   input        rxck_i,
   input        rxctl_i,

   output reg [7:0] rxd_o,
   output       rxctl_o
   ) ;
   wire [7:0]   s_rxd;
   reg [1:0]    r_ctl_dly;
   
   // IDDR: Input Double Data Rate Input Register with Set, Reset and Clock Enable.
   // Xilinx HDL Language Template, version 2017.4, Artix-7
   IDDR #( .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED" 
           .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) iddr_d0 (
      .Q1 ( s_rxd[0] ), // 1-bit output for positive edge of clock 
      .Q2 ( s_rxd[4] ), // 1-bit output for negative edge of clock
      .C  ( rxck_i   ), // 1-bit clock input
      .CE ( 1'b1     ), // 1-bit clock enable input
      .D  ( rxd_i[0] ), // 1-bit DDR data input
      .R  ( 1'b0     ), // 1-bit reset
      .S  ( 1'b0     )  // 1-bit set
   );

   IDDR #( .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED" 
           .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) iddr_d1 (
      .Q1 ( s_rxd[1] ), // 1-bit output for positive edge of clock 
      .Q2 ( s_rxd[5] ), // 1-bit output for negative edge of clock
      .C  ( rxck_i   ),   // 1-bit clock input
      .CE ( 1'b1     ), // 1-bit clock enable input
      .D  ( rxd_i[1] ),   // 1-bit DDR data input
      .R  ( 1'b0     ),   // 1-bit reset
      .S  ( 1'b0     )    // 1-bit set
   );

   IDDR #( .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED" 
           .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) iddr_d2 (
      .Q1 ( s_rxd[2] ), // 1-bit output for positive edge of clock 
      .Q2 ( s_rxd[6] ), // 1-bit output for negative edge of clock
      .C  ( rxck_i   ),   // 1-bit clock input
      .CE ( 1'b1     ), // 1-bit clock enable input
      .D  ( rxd_i[2] ),   // 1-bit DDR data input
      .R  ( 1'b0     ),   // 1-bit reset
      .S  ( 1'b0     )    // 1-bit set
   );

   IDDR #( .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED" 
           .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) iddr_d3 (
      .Q1 ( s_rxd[3] ), // 1-bit output for positive edge of clock 
      .Q2 ( s_rxd[7] ), // 1-bit output for negative edge of clock
      .C  ( rxck_i   ),   // 1-bit clock input
      .CE ( 1'b1     ), // 1-bit clock enable input
      .D  ( rxd_i[3] ),   // 1-bit DDR data input
      .R  ( 1'b0     ),   // 1-bit reset
      .S  ( 1'b0     )    // 1-bit set
   );

   always_ff @(posedge rxck_i) begin //-- Align to rising edge.
      rxd_o <= s_rxd;
   end
   always_ff @(posedge rxck_i) begin
      r_ctl_dly <= {r_ctl_dly[0], rxctl_i};
   end
   assign rxctl_o = r_ctl_dly[1];
endmodule // RGMII2GMII

