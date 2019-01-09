// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Mon Dec 24 21:25:53 2018
// Host        : Z10PE-01 running 64-bit Ubuntu 16.04.5 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/moikawa/proj_Mitsuhashi/UDP_20181221/UDP.srcs/sources_1/ip/ETH_CLKGEN/ETH_CLKGEN_sim_netlist.v
// Design      : ETH_CLKGEN
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tsbg484-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* NotValidForBitStream *)
module ETH_CLKGEN
   (rxck_0deg,
    rxck_90deg,
    rxck_180deg,
    rxck_270deg,
    rxck_n90deg,
    resetn,
    locked,
    eth_rxck);
  output rxck_0deg;
  output rxck_90deg;
  output rxck_180deg;
  output rxck_270deg;
  output rxck_n90deg;
  input resetn;
  output locked;
  input eth_rxck;

  (* IBUF_LOW_PWR *) wire eth_rxck;
  wire locked;
  wire resetn;
  wire rxck_0deg;
  wire rxck_180deg;
  wire rxck_270deg;
  wire rxck_90deg;
  wire rxck_n90deg;

  ETH_CLKGEN_ETH_CLKGEN_clk_wiz inst
       (.eth_rxck(eth_rxck),
        .locked(locked),
        .resetn(resetn),
        .rxck_0deg(rxck_0deg),
        .rxck_180deg(rxck_180deg),
        .rxck_270deg(rxck_270deg),
        .rxck_90deg(rxck_90deg),
        .rxck_n90deg(rxck_n90deg));
endmodule

(* ORIG_REF_NAME = "ETH_CLKGEN_clk_wiz" *) 
module ETH_CLKGEN_ETH_CLKGEN_clk_wiz
   (rxck_0deg,
    rxck_90deg,
    rxck_180deg,
    rxck_270deg,
    rxck_n90deg,
    resetn,
    locked,
    eth_rxck);
  output rxck_0deg;
  output rxck_90deg;
  output rxck_180deg;
  output rxck_270deg;
  output rxck_n90deg;
  input resetn;
  output locked;
  input eth_rxck;

  wire clkfbout_ETH_CLKGEN;
  wire clkfbout_buf_ETH_CLKGEN;
  wire eth_rxck;
  wire eth_rxck_ETH_CLKGEN;
  wire locked;
  wire reset_high;
  wire resetn;
  wire rxck_0deg;
  wire rxck_0deg_ETH_CLKGEN;
  wire rxck_180deg;
  wire rxck_180deg_ETH_CLKGEN;
  wire rxck_270deg;
  wire rxck_270deg_ETH_CLKGEN;
  wire rxck_90deg;
  wire rxck_90deg_ETH_CLKGEN;
  wire rxck_n90deg;
  wire rxck_n90deg_ETH_CLKGEN;
  wire NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED;
  wire NLW_mmcm_adv_inst_DRDY_UNCONNECTED;
  wire NLW_mmcm_adv_inst_PSDONE_UNCONNECTED;
  wire [15:0]NLW_mmcm_adv_inst_DO_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkf_buf
       (.I(clkfbout_ETH_CLKGEN),
        .O(clkfbout_buf_ETH_CLKGEN));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* CAPACITANCE = "DONT_CARE" *) 
  (* IBUF_DELAY_VALUE = "0" *) 
  (* IFD_DELAY_VALUE = "AUTO" *) 
  IBUF #(
    .IOSTANDARD("DEFAULT")) 
    clkin1_ibufg
       (.I(eth_rxck),
        .O(eth_rxck_ETH_CLKGEN));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkout1_buf
       (.I(rxck_0deg_ETH_CLKGEN),
        .O(rxck_0deg));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkout2_buf
       (.I(rxck_90deg_ETH_CLKGEN),
        .O(rxck_90deg));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkout3_buf
       (.I(rxck_180deg_ETH_CLKGEN),
        .O(rxck_180deg));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkout4_buf
       (.I(rxck_270deg_ETH_CLKGEN),
        .O(rxck_270deg));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkout5_buf
       (.I(rxck_n90deg_ETH_CLKGEN),
        .O(rxck_n90deg));
  (* BOX_TYPE = "PRIMITIVE" *) 
  MMCME2_ADV #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKFBOUT_MULT_F(8.000000),
    .CLKFBOUT_PHASE(0.000000),
    .CLKFBOUT_USE_FINE_PS("FALSE"),
    .CLKIN1_PERIOD(8.000000),
    .CLKIN2_PERIOD(0.000000),
    .CLKOUT0_DIVIDE_F(8.000000),
    .CLKOUT0_DUTY_CYCLE(0.500000),
    .CLKOUT0_PHASE(0.000000),
    .CLKOUT0_USE_FINE_PS("FALSE"),
    .CLKOUT1_DIVIDE(8),
    .CLKOUT1_DUTY_CYCLE(0.500000),
    .CLKOUT1_PHASE(90.000000),
    .CLKOUT1_USE_FINE_PS("FALSE"),
    .CLKOUT2_DIVIDE(8),
    .CLKOUT2_DUTY_CYCLE(0.500000),
    .CLKOUT2_PHASE(180.000000),
    .CLKOUT2_USE_FINE_PS("FALSE"),
    .CLKOUT3_DIVIDE(8),
    .CLKOUT3_DUTY_CYCLE(0.500000),
    .CLKOUT3_PHASE(270.000000),
    .CLKOUT3_USE_FINE_PS("FALSE"),
    .CLKOUT4_CASCADE("FALSE"),
    .CLKOUT4_DIVIDE(8),
    .CLKOUT4_DUTY_CYCLE(0.500000),
    .CLKOUT4_PHASE(-90.000000),
    .CLKOUT4_USE_FINE_PS("FALSE"),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT5_DUTY_CYCLE(0.500000),
    .CLKOUT5_PHASE(0.000000),
    .CLKOUT5_USE_FINE_PS("FALSE"),
    .CLKOUT6_DIVIDE(1),
    .CLKOUT6_DUTY_CYCLE(0.500000),
    .CLKOUT6_PHASE(0.000000),
    .CLKOUT6_USE_FINE_PS("FALSE"),
    .COMPENSATION("ZHOLD"),
    .DIVCLK_DIVIDE(1),
    .IS_CLKINSEL_INVERTED(1'b0),
    .IS_PSEN_INVERTED(1'b0),
    .IS_PSINCDEC_INVERTED(1'b0),
    .IS_PWRDWN_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .REF_JITTER1(0.010000),
    .REF_JITTER2(0.010000),
    .SS_EN("FALSE"),
    .SS_MODE("CENTER_HIGH"),
    .SS_MOD_PERIOD(10000),
    .STARTUP_WAIT("FALSE")) 
    mmcm_adv_inst
       (.CLKFBIN(clkfbout_buf_ETH_CLKGEN),
        .CLKFBOUT(clkfbout_ETH_CLKGEN),
        .CLKFBOUTB(NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED),
        .CLKFBSTOPPED(NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED),
        .CLKIN1(eth_rxck_ETH_CLKGEN),
        .CLKIN2(1'b0),
        .CLKINSEL(1'b1),
        .CLKINSTOPPED(NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED),
        .CLKOUT0(rxck_0deg_ETH_CLKGEN),
        .CLKOUT0B(NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED),
        .CLKOUT1(rxck_90deg_ETH_CLKGEN),
        .CLKOUT1B(NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED),
        .CLKOUT2(rxck_180deg_ETH_CLKGEN),
        .CLKOUT2B(NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED),
        .CLKOUT3(rxck_270deg_ETH_CLKGEN),
        .CLKOUT3B(NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED),
        .CLKOUT4(rxck_n90deg_ETH_CLKGEN),
        .CLKOUT5(NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED),
        .CLKOUT6(NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED),
        .DADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DCLK(1'b0),
        .DEN(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DO(NLW_mmcm_adv_inst_DO_UNCONNECTED[15:0]),
        .DRDY(NLW_mmcm_adv_inst_DRDY_UNCONNECTED),
        .DWE(1'b0),
        .LOCKED(locked),
        .PSCLK(1'b0),
        .PSDONE(NLW_mmcm_adv_inst_PSDONE_UNCONNECTED),
        .PSEN(1'b0),
        .PSINCDEC(1'b0),
        .PWRDWN(1'b0),
        .RST(reset_high));
  LUT1 #(
    .INIT(2'h1)) 
    mmcm_adv_inst_i_1
       (.I0(resetn),
        .O(reset_high));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
