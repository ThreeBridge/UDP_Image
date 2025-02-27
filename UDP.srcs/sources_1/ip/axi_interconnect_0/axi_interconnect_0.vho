-- (c) Copyright 1995-2019 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:ip:axi_interconnect:1.7
-- IP Revision: 14

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT axi_interconnect_0
  PORT (
    INTERCONNECT_ACLK : IN STD_LOGIC;
    INTERCONNECT_ARESETN : IN STD_LOGIC;
    S00_AXI_ARESET_OUT_N : OUT STD_LOGIC;
    S00_AXI_ACLK : IN STD_LOGIC;
    S00_AXI_AWID : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    S00_AXI_AWADDR : IN STD_LOGIC_VECTOR(28 DOWNTO 0);
    S00_AXI_AWLEN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    S00_AXI_AWSIZE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S00_AXI_AWBURST : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    S00_AXI_AWLOCK : IN STD_LOGIC;
    S00_AXI_AWCACHE : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S00_AXI_AWPROT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S00_AXI_AWQOS : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S00_AXI_AWVALID : IN STD_LOGIC;
    S00_AXI_AWREADY : OUT STD_LOGIC;
    S00_AXI_WDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S00_AXI_WSTRB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S00_AXI_WLAST : IN STD_LOGIC;
    S00_AXI_WVALID : IN STD_LOGIC;
    S00_AXI_WREADY : OUT STD_LOGIC;
    S00_AXI_BID : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    S00_AXI_BRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S00_AXI_BVALID : OUT STD_LOGIC;
    S00_AXI_BREADY : IN STD_LOGIC;
    S00_AXI_ARID : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    S00_AXI_ARADDR : IN STD_LOGIC_VECTOR(28 DOWNTO 0);
    S00_AXI_ARLEN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    S00_AXI_ARSIZE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S00_AXI_ARBURST : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    S00_AXI_ARLOCK : IN STD_LOGIC;
    S00_AXI_ARCACHE : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S00_AXI_ARPROT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S00_AXI_ARQOS : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S00_AXI_ARVALID : IN STD_LOGIC;
    S00_AXI_ARREADY : OUT STD_LOGIC;
    S00_AXI_RID : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    S00_AXI_RDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    S00_AXI_RRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S00_AXI_RLAST : OUT STD_LOGIC;
    S00_AXI_RVALID : OUT STD_LOGIC;
    S00_AXI_RREADY : IN STD_LOGIC;
    S01_AXI_ARESET_OUT_N : OUT STD_LOGIC;
    S01_AXI_ACLK : IN STD_LOGIC;
    S01_AXI_AWID : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    S01_AXI_AWADDR : IN STD_LOGIC_VECTOR(28 DOWNTO 0);
    S01_AXI_AWLEN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    S01_AXI_AWSIZE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S01_AXI_AWBURST : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    S01_AXI_AWLOCK : IN STD_LOGIC;
    S01_AXI_AWCACHE : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S01_AXI_AWPROT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S01_AXI_AWQOS : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S01_AXI_AWVALID : IN STD_LOGIC;
    S01_AXI_AWREADY : OUT STD_LOGIC;
    S01_AXI_WDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S01_AXI_WSTRB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S01_AXI_WLAST : IN STD_LOGIC;
    S01_AXI_WVALID : IN STD_LOGIC;
    S01_AXI_WREADY : OUT STD_LOGIC;
    S01_AXI_BID : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    S01_AXI_BRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S01_AXI_BVALID : OUT STD_LOGIC;
    S01_AXI_BREADY : IN STD_LOGIC;
    S01_AXI_ARID : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    S01_AXI_ARADDR : IN STD_LOGIC_VECTOR(28 DOWNTO 0);
    S01_AXI_ARLEN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    S01_AXI_ARSIZE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S01_AXI_ARBURST : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    S01_AXI_ARLOCK : IN STD_LOGIC;
    S01_AXI_ARCACHE : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S01_AXI_ARPROT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S01_AXI_ARQOS : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S01_AXI_ARVALID : IN STD_LOGIC;
    S01_AXI_ARREADY : OUT STD_LOGIC;
    S01_AXI_RID : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    S01_AXI_RDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    S01_AXI_RRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S01_AXI_RLAST : OUT STD_LOGIC;
    S01_AXI_RVALID : OUT STD_LOGIC;
    S01_AXI_RREADY : IN STD_LOGIC;
    M00_AXI_ARESET_OUT_N : OUT STD_LOGIC;
    M00_AXI_ACLK : IN STD_LOGIC;
    M00_AXI_AWID : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    M00_AXI_AWADDR : OUT STD_LOGIC_VECTOR(28 DOWNTO 0);
    M00_AXI_AWLEN : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    M00_AXI_AWSIZE : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    M00_AXI_AWBURST : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    M00_AXI_AWLOCK : OUT STD_LOGIC;
    M00_AXI_AWCACHE : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    M00_AXI_AWPROT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    M00_AXI_AWQOS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    M00_AXI_AWVALID : OUT STD_LOGIC;
    M00_AXI_AWREADY : IN STD_LOGIC;
    M00_AXI_WDATA : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
    M00_AXI_WSTRB : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    M00_AXI_WLAST : OUT STD_LOGIC;
    M00_AXI_WVALID : OUT STD_LOGIC;
    M00_AXI_WREADY : IN STD_LOGIC;
    M00_AXI_BID : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    M00_AXI_BRESP : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    M00_AXI_BVALID : IN STD_LOGIC;
    M00_AXI_BREADY : OUT STD_LOGIC;
    M00_AXI_ARID : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    M00_AXI_ARADDR : OUT STD_LOGIC_VECTOR(28 DOWNTO 0);
    M00_AXI_ARLEN : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    M00_AXI_ARSIZE : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    M00_AXI_ARBURST : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    M00_AXI_ARLOCK : OUT STD_LOGIC;
    M00_AXI_ARCACHE : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    M00_AXI_ARPROT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    M00_AXI_ARQOS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    M00_AXI_ARVALID : OUT STD_LOGIC;
    M00_AXI_ARREADY : IN STD_LOGIC;
    M00_AXI_RID : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    M00_AXI_RDATA : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
    M00_AXI_RRESP : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    M00_AXI_RLAST : IN STD_LOGIC;
    M00_AXI_RVALID : IN STD_LOGIC;
    M00_AXI_RREADY : OUT STD_LOGIC
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : axi_interconnect_0
  PORT MAP (
    INTERCONNECT_ACLK => INTERCONNECT_ACLK,
    INTERCONNECT_ARESETN => INTERCONNECT_ARESETN,
    S00_AXI_ARESET_OUT_N => S00_AXI_ARESET_OUT_N,
    S00_AXI_ACLK => S00_AXI_ACLK,
    S00_AXI_AWID => S00_AXI_AWID,
    S00_AXI_AWADDR => S00_AXI_AWADDR,
    S00_AXI_AWLEN => S00_AXI_AWLEN,
    S00_AXI_AWSIZE => S00_AXI_AWSIZE,
    S00_AXI_AWBURST => S00_AXI_AWBURST,
    S00_AXI_AWLOCK => S00_AXI_AWLOCK,
    S00_AXI_AWCACHE => S00_AXI_AWCACHE,
    S00_AXI_AWPROT => S00_AXI_AWPROT,
    S00_AXI_AWQOS => S00_AXI_AWQOS,
    S00_AXI_AWVALID => S00_AXI_AWVALID,
    S00_AXI_AWREADY => S00_AXI_AWREADY,
    S00_AXI_WDATA => S00_AXI_WDATA,
    S00_AXI_WSTRB => S00_AXI_WSTRB,
    S00_AXI_WLAST => S00_AXI_WLAST,
    S00_AXI_WVALID => S00_AXI_WVALID,
    S00_AXI_WREADY => S00_AXI_WREADY,
    S00_AXI_BID => S00_AXI_BID,
    S00_AXI_BRESP => S00_AXI_BRESP,
    S00_AXI_BVALID => S00_AXI_BVALID,
    S00_AXI_BREADY => S00_AXI_BREADY,
    S00_AXI_ARID => S00_AXI_ARID,
    S00_AXI_ARADDR => S00_AXI_ARADDR,
    S00_AXI_ARLEN => S00_AXI_ARLEN,
    S00_AXI_ARSIZE => S00_AXI_ARSIZE,
    S00_AXI_ARBURST => S00_AXI_ARBURST,
    S00_AXI_ARLOCK => S00_AXI_ARLOCK,
    S00_AXI_ARCACHE => S00_AXI_ARCACHE,
    S00_AXI_ARPROT => S00_AXI_ARPROT,
    S00_AXI_ARQOS => S00_AXI_ARQOS,
    S00_AXI_ARVALID => S00_AXI_ARVALID,
    S00_AXI_ARREADY => S00_AXI_ARREADY,
    S00_AXI_RID => S00_AXI_RID,
    S00_AXI_RDATA => S00_AXI_RDATA,
    S00_AXI_RRESP => S00_AXI_RRESP,
    S00_AXI_RLAST => S00_AXI_RLAST,
    S00_AXI_RVALID => S00_AXI_RVALID,
    S00_AXI_RREADY => S00_AXI_RREADY,
    S01_AXI_ARESET_OUT_N => S01_AXI_ARESET_OUT_N,
    S01_AXI_ACLK => S01_AXI_ACLK,
    S01_AXI_AWID => S01_AXI_AWID,
    S01_AXI_AWADDR => S01_AXI_AWADDR,
    S01_AXI_AWLEN => S01_AXI_AWLEN,
    S01_AXI_AWSIZE => S01_AXI_AWSIZE,
    S01_AXI_AWBURST => S01_AXI_AWBURST,
    S01_AXI_AWLOCK => S01_AXI_AWLOCK,
    S01_AXI_AWCACHE => S01_AXI_AWCACHE,
    S01_AXI_AWPROT => S01_AXI_AWPROT,
    S01_AXI_AWQOS => S01_AXI_AWQOS,
    S01_AXI_AWVALID => S01_AXI_AWVALID,
    S01_AXI_AWREADY => S01_AXI_AWREADY,
    S01_AXI_WDATA => S01_AXI_WDATA,
    S01_AXI_WSTRB => S01_AXI_WSTRB,
    S01_AXI_WLAST => S01_AXI_WLAST,
    S01_AXI_WVALID => S01_AXI_WVALID,
    S01_AXI_WREADY => S01_AXI_WREADY,
    S01_AXI_BID => S01_AXI_BID,
    S01_AXI_BRESP => S01_AXI_BRESP,
    S01_AXI_BVALID => S01_AXI_BVALID,
    S01_AXI_BREADY => S01_AXI_BREADY,
    S01_AXI_ARID => S01_AXI_ARID,
    S01_AXI_ARADDR => S01_AXI_ARADDR,
    S01_AXI_ARLEN => S01_AXI_ARLEN,
    S01_AXI_ARSIZE => S01_AXI_ARSIZE,
    S01_AXI_ARBURST => S01_AXI_ARBURST,
    S01_AXI_ARLOCK => S01_AXI_ARLOCK,
    S01_AXI_ARCACHE => S01_AXI_ARCACHE,
    S01_AXI_ARPROT => S01_AXI_ARPROT,
    S01_AXI_ARQOS => S01_AXI_ARQOS,
    S01_AXI_ARVALID => S01_AXI_ARVALID,
    S01_AXI_ARREADY => S01_AXI_ARREADY,
    S01_AXI_RID => S01_AXI_RID,
    S01_AXI_RDATA => S01_AXI_RDATA,
    S01_AXI_RRESP => S01_AXI_RRESP,
    S01_AXI_RLAST => S01_AXI_RLAST,
    S01_AXI_RVALID => S01_AXI_RVALID,
    S01_AXI_RREADY => S01_AXI_RREADY,
    M00_AXI_ARESET_OUT_N => M00_AXI_ARESET_OUT_N,
    M00_AXI_ACLK => M00_AXI_ACLK,
    M00_AXI_AWID => M00_AXI_AWID,
    M00_AXI_AWADDR => M00_AXI_AWADDR,
    M00_AXI_AWLEN => M00_AXI_AWLEN,
    M00_AXI_AWSIZE => M00_AXI_AWSIZE,
    M00_AXI_AWBURST => M00_AXI_AWBURST,
    M00_AXI_AWLOCK => M00_AXI_AWLOCK,
    M00_AXI_AWCACHE => M00_AXI_AWCACHE,
    M00_AXI_AWPROT => M00_AXI_AWPROT,
    M00_AXI_AWQOS => M00_AXI_AWQOS,
    M00_AXI_AWVALID => M00_AXI_AWVALID,
    M00_AXI_AWREADY => M00_AXI_AWREADY,
    M00_AXI_WDATA => M00_AXI_WDATA,
    M00_AXI_WSTRB => M00_AXI_WSTRB,
    M00_AXI_WLAST => M00_AXI_WLAST,
    M00_AXI_WVALID => M00_AXI_WVALID,
    M00_AXI_WREADY => M00_AXI_WREADY,
    M00_AXI_BID => M00_AXI_BID,
    M00_AXI_BRESP => M00_AXI_BRESP,
    M00_AXI_BVALID => M00_AXI_BVALID,
    M00_AXI_BREADY => M00_AXI_BREADY,
    M00_AXI_ARID => M00_AXI_ARID,
    M00_AXI_ARADDR => M00_AXI_ARADDR,
    M00_AXI_ARLEN => M00_AXI_ARLEN,
    M00_AXI_ARSIZE => M00_AXI_ARSIZE,
    M00_AXI_ARBURST => M00_AXI_ARBURST,
    M00_AXI_ARLOCK => M00_AXI_ARLOCK,
    M00_AXI_ARCACHE => M00_AXI_ARCACHE,
    M00_AXI_ARPROT => M00_AXI_ARPROT,
    M00_AXI_ARQOS => M00_AXI_ARQOS,
    M00_AXI_ARVALID => M00_AXI_ARVALID,
    M00_AXI_ARREADY => M00_AXI_ARREADY,
    M00_AXI_RID => M00_AXI_RID,
    M00_AXI_RDATA => M00_AXI_RDATA,
    M00_AXI_RRESP => M00_AXI_RRESP,
    M00_AXI_RLAST => M00_AXI_RLAST,
    M00_AXI_RVALID => M00_AXI_RVALID,
    M00_AXI_RREADY => M00_AXI_RREADY
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file axi_interconnect_0.vhd when simulating
-- the core, axi_interconnect_0. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.

