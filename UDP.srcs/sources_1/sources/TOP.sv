`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/31 19:16:30
// Design Name: 
// Module Name: ARP_reply
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module TOP(
    input [3:0]     ETH_RXD,     // 受信フレームデータ
    input           ETH_RXCK,    // 受信クロック
    input           ETH_RXCTL,   // 受信フレーム検知で'1'
    
    input           BTN_C,       // 任意のタイミングでのリセット   
            
    output [3:0]    ETH_TXD,    //-- Ether RGMII Tx data.
    output          ETH_TXCK,
    output          ETH_TXCTL,
    inout           ETH_RST_B,  //-- Ether PHY reset(active low)
    input 	        eth_int_b,
    input           eth_pme_b,
    output          eth_mdc,
    inout           eth_mdio,

    input           SYSCLK,     // その他用クロック
    input           CPU_RSTN,   //
    input           reset_i,
    
    input  [7:0]    SW,
    output [7:0]    LED,
    output [7:0]    PMOD_A,
    output [7:0]    PMOD_B,
    output [7:0]    PMOD_C,
    
    output [1:0] SET_VADJ,
    output VADJ_EN,
    
    /*---SDRAM---*/
    // Inouts
    inout [15:0]    ddr3_dq,
    inout [1:0]     ddr3_dqs_n,
    inout [1:0]     ddr3_dqs_p,
    // Outputs
    output [14:0]   ddr3_addr,
    output [2:0]    ddr3_ba,
    output          ddr3_ras_n,
    output          ddr3_cas_n,
    output          ddr3_we_n,
    output          ddr3_reset_n,
    output          ddr3_ck_p,
    output          ddr3_ck_n,
    output          ddr3_cke,
    output [1:0]    ddr3_dm,
    output          ddr3_odt    
    );
 
    /*---STRUCT---*/
    typedef struct packed{
        logic           id;
        logic [28:0]    addr;
        logic [7:0]     len;
        logic [2:0]     size;
        logic [1:0]     burst;
        logic           lock;
        logic [3:0]     cache;
        logic [2:0]     prot;
        logic [3:0]     qos;
        logic           valid;    
    }AXI_AW;
    
    typedef struct packed{
        logic [31:0]    data;
        logic [3:0]     strb;
        logic           last;
        logic           valid;  
    }AXI_W;

    typedef struct packed{
        logic           id;
        logic [28:0]    addr;
        logic [7:0]     len;
        logic [2:0]     size;
        logic [1:0]     burst;
        logic           lock;
        logic [3:0]     cache;
        logic [2:0]     prot;
        logic [3:0]     qos;
        logic           valid;    
    }AXI_AR;
    
    typedef struct packed{
        logic [31:0]    data;
        logic [3:0]     strb;
        logic           last;
        logic           valid;
        logic [1:0]     resp;
    }AXI_R;
    
    
    AXI_AW          axi_aw;
    AXI_W           axi_w;
    AXI_AR          axi_ar;
    AXI_R           axi_r;
    
    wire [7:0]       gmii_txd;
    wire             gmii_txctl;
     
    (*dont_touch="true"*) wire [7:0] gmii_rxd;
    (*dont_touch="true"*) wire  gmii_rxctl;
    
    wire eth_rxck;
    wire eth_rxck_90;
    wire eth_clkgen_locked;
    wire rst_rx;
    wire clk200;
    ETH_CLKGEN eth_clkgen (
          .eth_rxck     (ETH_RXCK),
          .rxck_90deg   (eth_rxck),
          .rxck_180deg  (eth_rxck_90),
          .clk200       (clk200),
          .locked       (eth_clkgen_locked),
          .resetn       (CPU_RSTN)
    );
    
    //**------------------------------------------------------------
    //** RGMII to GMII translator. (add by moikawa)
    //**
    wire  gmii_rxctl_hi, gmii_rxctl_lo;
    RGMII2GMII rgmii2gmii (
           .rxd_i      ( ETH_RXD       ), //<-- INPUT[3:0]
           .rxck_i     ( eth_rxck      ), //<-- INPUT, Rx clock 125 MHz.
           .rxctl_i    ( ETH_RXCTL     ), //--
           .rxd_o      ( gmii_rxd      ), //--[7:0]
           .rxctl_hi_o ( gmii_rxctl_hi ),
           .rxctl_lo_o ( gmii_rxctl_lo ),
           .rxctl_o    ( gmii_rxctl    )
     ) ;
    //**------------------------------------------------------------
    //** GMII to RGMII translator. (add by moikawa)
    //**
    wire clk10;
    wire clk100;
    wire clk125,    rst125;
    wire clk125_90;
    wire sys_clkgen_locked;
    GMII2RGMII gmii2rgmii (
          .txck_o   ( ETH_TXCK    ),
          .txd_o    ( ETH_TXD     ), //--> OUTPUT
          .txctl_o  ( ETH_TXCTL   ), //--> OUTPUT
          .txck_i   ( eth_rxck    ), //- Tx clock 125MHz.
          .txck_90_i( eth_rxck_90 ),
          .txd_i    ( gmii_txd    ), //-- [7:0]
          .txctl_i  ( gmii_txctl  )  //--
    );

    //**------------------------------------------------------------
    //** Reset generator. (add by moikawa)
    //**
    RSTGEN rstgen125 (
         .reset_o  ( rst_rx ),
         .reset_i  ( 1'b0   ),
         .locked_i ( eth_clkgen_locked ),
         .clk      ( eth_rxck )
    );
    
    //**------------------------------------------------------------
    //** Reset generator.
    //**
    logic aresetn;
    logic mmcm_locked;
    logic ui_clk;
    RSTGEN2 rstgen100 (
         .reset_o  ( aresetn ),
         .locked_i ( mmcm_locked ),
         .clk      ( ui_clk )
    );
    
    wire rst_btn = BTN_C;
    //wire arp_tx_en;
    //wire ping_tx_en;
    //wire UDP_tx_en;
    //wire arp_tx;
    //wire ping_tx;
    wire UDP_btn_tx;        // ボタン入力によるUDP送信
    wire axi_awready;
    wire axi_wready;
    wire axi_bresp;
    wire axi_bvalid;
    wire axi_bready;
    wire axi_arready;
    wire axi_rready;
    //wire UDP_tx;            // UDPの送受信
    wire [8:0] rarp_o;   
    wire [8:0] ping_o;  
    wire [8:0] UDP_btn_d;   // ボタン入力によるUDP送信
    wire [8:0] UDP_o;       // UDPの送受信
    
    Arbiter R_Arbiter (
        /*---INPUT---*/
        .gmii_rxd     (gmii_rxd),   //<-- "rgmii2gmii"
        .gmii_rxctl   (gmii_rxctl), //<-- "rgmii2gmii"
        .eth_rxck     (eth_rxck),   //<-- "eth_clkgen"
        .rst_rx       (rst_rx),
        .rst125       (rst125),
        .clk125       (clk125),
        .rst_btn      (rst_btn),
        .SW           (SW),
        .axi_awready  (axi_awready),
        .axi_wready   (axi_wready),
        .axi_bresp    (axi_bresp),
        .axi_bvalid   (axi_bvalid),
        .axi_arready  (axi_arready),
        .axi_r        (axi_r),
        /*---OUTPUT---*/
        .rarp_o       (rarp_o),
        .ping_o       (ping_o),
        .UDP_o        (UDP_o),
        .axi_aw       (axi_aw),
        .axi_w        (axi_w),
        .axi_bready   (axi_bready),
        .axi_ar       (axi_ar),
        .axi_rready   (axi_rready)
    );

    wire [7:0] tx_led;
    T_Arbiter T_Arbiter(
        /*---INPUT---*/
        .rarp_i       (rarp_o),
        .ping_i       (ping_o),
        .UDP_btn_d(UDP_btn_d),
        .UDP_i        (UDP_o),
        .UDP_btn_tx(UDP_btn_tx),
        .eth_rxck(eth_rxck),
        .rst       (rst_rx),
        /*---OUTPUT---*/
        .txd_o        (gmii_txd),
        .gmii_txctl_o (gmii_txctl)
        //.LED          (tx_led)
    );


    /*---SDRAM---*/
    //logic           sys_clk_i;(=SYSCLK)
    
    logic           clk_ref_i;
    
    //logic           ui_clk;
    logic           ui_clk_sync_rst;
    //logic           mmcm_locked;
    logic           app_sr_req=1'b0;
    logic           app_ref_req=1'b0;
    logic           app_zq_req=1'b0;
    logic           app_sr_active;
    logic           app_ref_ack;
    logic           app_zq_ack;
    
    logic [1:0]     s_axi_awid;
    logic [28:0]    s_axi_awaddr;
    logic [7:0]     s_axi_awlen;
    logic [2:0]     s_axi_awsize;
    logic [1:0]     s_axi_awburst;
    logic [0:0]     s_axi_awlock;
    logic [3:0]     s_axi_awcache;
    logic [2:0]     s_axi_awprot;
    logic [3:0]     s_axi_awqos;
    logic           s_axi_awvalid;
    logic           s_axi_awready;
    
    logic [127:0]   s_axi_wdata;
    logic [15:0]    s_axi_wstrb;
    logic           s_axi_wlast;
    logic           s_axi_wvalid;
    logic           s_axi_wready;
    
    logic           s_axi_bready;
    logic [1:0]     s_axi_bid;
    logic [1:0]     s_axi_bresp;
    logic           s_axi_bvalid;
    
    logic [1:0]     s_axi_arid;
    logic [28:0]    s_axi_araddr;
    logic [7:0]     s_axi_arlen;
    logic [2:0]     s_axi_arsize;
    logic [1:0]     s_axi_arburst;
    logic [0:0]     s_axi_arlock;
    logic [3:0]     s_axi_arcache;
    logic [2:0]     s_axi_arprot;
    logic [3:0]     s_axi_arqos;
    logic           s_axi_arvalid;
    logic           s_axi_arready;
    
    logic s_axi_rready;
    logic [1:0]     s_axi_rid;
    logic [127:0]   s_axi_rdata;
    logic [1:0]     s_axi_rresp;
    logic           s_axi_rlast;
    logic           s_axi_rvalid;
    logic           init_calib_complete;
    logic [11:0]    device_temp;
    
    `ifdef SKIP_CALIB
        logic       calib_tap_req;
        logic       calib_tap_load;
        logic [6:0] calib_tap_addr;
        logic [7:0] calib_tap_val;
        logic       calib_tap_load_done;
    `endif
    
    //logic sys_rst;
    
    mig_7series_0 mig_7series_0(
        // Inouts
        .ddr3_dq        (ddr3_dq),
        .ddr3_dqs_n     (ddr3_dqs_n),
        .ddr3_dqs_p     (ddr3_dqs_p),
        // Outputs
        .ddr3_addr      (ddr3_addr),
        .ddr3_ba        (ddr3_ba),
        .ddr3_ras_n     (ddr3_ras_n),
        .ddr3_cas_n     (ddr3_cas_n),
        .ddr3_we_n      (ddr3_we_n),
        .ddr3_reset_n   (ddr3_reset_n),
        .ddr3_ck_p      (ddr3_ck_p),
        .ddr3_ck_n      (ddr3_ck_n),
        .ddr3_cke       (ddr3_cke),
        .ddr3_dm        (ddr3_dm),
        .ddr3_odt       (ddr3_odt),
        // Inputs
        // Single-ended system clock
        .sys_clk_i      (SYSCLK),
        // Single-ended iodelayctrl clk (reference clock)
        .clk_ref_i      (clk200),
        // user interface signals
        .ui_clk         (ui_clk),       //(-->master_clk)
        .ui_clk_sync_rst(ui_clk_sync_rst),
        .mmcm_locked    (mmcm_locked),
        .aresetn        (aresetn),
        .app_sr_req     (app_sr_req),
        .app_ref_req    (app_ref_req),
        .app_zq_req     (app_zq_req),
        .app_sr_active  (app_sr_active),
        .app_ref_ack    (app_ref_ack),
        .app_zq_ack     (app_zq_ack),
        // Slave Interface Write Address Ports
        .s_axi_awid     (s_axi_awid),
        .s_axi_awaddr   (s_axi_awaddr),
        .s_axi_awlen    (s_axi_awlen),
        .s_axi_awsize   (s_axi_awsize),
        .s_axi_awburst  (s_axi_awburst),
        .s_axi_awlock   (s_axi_awlock),
        .s_axi_awcache  (s_axi_awcache),
        .s_axi_awprot   (s_axi_awprot),
        .s_axi_awqos    (s_axi_awqos),
        .s_axi_awvalid  (s_axi_awvalid),
        .s_axi_awready  (s_axi_awready),
        // Slave Interface Write Data Ports
        .s_axi_wdata    (s_axi_wdata),
        .s_axi_wstrb    (s_axi_wstrb),
        .s_axi_wlast    (s_axi_wlast),
        .s_axi_wvalid   (s_axi_wvalid),
        .s_axi_wready   (s_axi_wready),
        // Slave Interface Write Response Ports
        .s_axi_bready   (s_axi_bready),
        .s_axi_bid      (s_axi_bid),
        .s_axi_bresp    (s_axi_bresp),
        .s_axi_bvalid   (s_axi_bvalid),
        // Slave Interface Read Address Ports
        .s_axi_arid     (s_axi_arid),
        .s_axi_araddr   (s_axi_araddr),
        .s_axi_arlen    (s_axi_arlen),
        .s_axi_arsize   (s_axi_arsize),
        .s_axi_arburst  (s_axi_arburst),
        .s_axi_arlock   (s_axi_arlock),
        .s_axi_arcache  (s_axi_arcache),
        .s_axi_arprot   (s_axi_arprot),
        .s_axi_arqos    (s_axi_arqos),
        .s_axi_arvalid  (s_axi_arvalid),
        .s_axi_arready  (s_axi_arready),
        // Slave Interface Read Data Ports
        .s_axi_rready   (s_axi_rready),
        .s_axi_rid      (s_axi_rid),
        .s_axi_rdata    (s_axi_rdata),
        .s_axi_rresp    (s_axi_rresp),
        .s_axi_rlast    (s_axi_rlast),
        .s_axi_rvalid   (s_axi_rvalid),
        .init_calib_complete(init_calib_complete),
        .device_temp    (device_temp),
        `ifdef SKIP_CALIB
          .calib_tap_req    (calib_tap_req),
          .calib_tap_load   (calib_tap_load),
          .calib_tap_addr   (calib_tap_addr),
          .calib_tap_val    (calib_tap_val),
          .calib_tap_load_done(calib_tap_load_done),
        `endif
        
        .sys_rst        (!CPU_RSTN)   //-- Active high!
    );
    
    axi_interconnect_0 axi_interconnect_0(
        .INTERCONNECT_ACLK      (eth_rxck),
        .INTERCONNECT_ARESETN   (!rst_rx),
        .S00_AXI_ARESET_OUT_N   (),
        .S00_AXI_ACLK           (eth_rxck),
        .S00_AXI_AWID           (axi_aw.id),
        .S00_AXI_AWADDR         (axi_aw.addr),
        .S00_AXI_AWLEN          (axi_aw.len),
        .S00_AXI_AWSIZE         (axi_aw.size),
        .S00_AXI_AWBURST        (axi_aw.burst),
        .S00_AXI_AWLOCK         (axi_aw.lock),
        .S00_AXI_AWCACHE        (axi_aw.cache),
        .S00_AXI_AWPROT         (axi_aw.prot),
        .S00_AXI_AWQOS          (axi_aw.qos),
        .S00_AXI_AWVALID        (axi_aw.valid),
        .S00_AXI_AWREADY        (axi_awready),
        .S00_AXI_WDATA          (axi_w.data),
        .S00_AXI_WSTRB          (axi_w.strb),
        .S00_AXI_WLAST          (axi_w.last),
        .S00_AXI_WVALID         (axi_w.valid),
        .S00_AXI_WREADY         (axi_wready),
        .S00_AXI_BID            (),
        .S00_AXI_BRESP          (axi_bresp),
        .S00_AXI_BVALID         (axi_bvalid),
        .S00_AXI_BREADY         (axi_bready),
        .S00_AXI_ARID           (axi_ar.id),
        .S00_AXI_ARADDR         (axi_ar.addr),
        .S00_AXI_ARLEN          (axi_ar.len),
        .S00_AXI_ARSIZE         (axi_ar.size),
        .S00_AXI_ARBURST        (axi_ar.burst),
        .S00_AXI_ARLOCK         (axi_ar.lock),
        .S00_AXI_ARCACHE        (axi_ar.cache),
        .S00_AXI_ARPROT         (axi_ar.prot),
        .S00_AXI_ARQOS          (axi_ar.qos),
        .S00_AXI_ARVALID        (axi_ar.valid),
        .S00_AXI_ARREADY        (axi_arready),
        .S00_AXI_RID            (),
        .S00_AXI_RDATA          (axi_r.data),
        .S00_AXI_RRESP          (axi_r.resp),
        .S00_AXI_RLAST          (axi_r.last),
        .S00_AXI_RVALID         (axi_r.valid),
        .S00_AXI_RREADY         (axi_rready),
        .M00_AXI_ARESET_OUT_N   (),
        .M00_AXI_ACLK           (ui_clk),
        .M00_AXI_AWID           (s_axi_awid),
        .M00_AXI_AWADDR         (s_axi_awaddr),
        .M00_AXI_AWLEN          (s_axi_awlen),
        .M00_AXI_AWSIZE         (s_axi_awsize),
        .M00_AXI_AWBURST        (s_axi_awburst),
        .M00_AXI_AWLOCK         (s_axi_awlock),
        .M00_AXI_AWCACHE        (s_axi_awcache),
        .M00_AXI_AWPROT         (s_axi_awprot),
        .M00_AXI_AWQOS          (s_axi_awqos),
        .M00_AXI_AWVALID        (s_axi_awvalid),
        .M00_AXI_AWREADY        (s_axi_awready),
        .M00_AXI_WDATA          (s_axi_wdata),
        .M00_AXI_WSTRB          (s_axi_wstrb),
        .M00_AXI_WLAST          (s_axi_wlast),
        .M00_AXI_WVALID         (s_axi_wvalid),
        .M00_AXI_WREADY         (s_axi_wready),
        .M00_AXI_BID            (s_axi_bid),
        .M00_AXI_BRESP          (s_axi_bresp),
        .M00_AXI_BVALID         (s_axi_bvalid),
        .M00_AXI_BREADY         (s_axi_bready),
        .M00_AXI_ARID           (s_axi_arid),
        .M00_AXI_ARADDR         (s_axi_araddr),
        .M00_AXI_ARLEN          (s_axi_arlen),
        .M00_AXI_ARSIZE         (s_axi_arsize),
        .M00_AXI_ARBURST        (s_axi_arburst),
        .M00_AXI_ARLOCK         (s_axi_arlock),
        .M00_AXI_ARCACHE        (s_axi_arcache),
        .M00_AXI_ARPROT         (s_axi_arprot),
        .M00_AXI_ARQOS          (s_axi_arqos),
        .M00_AXI_ARVALID        (s_axi_arvalid),
        .M00_AXI_ARREADY        (s_axi_arready),
        .M00_AXI_RID            (s_axi_rid),
        .M00_AXI_RDATA          (s_axi_rdata),
        .M00_AXI_RRESP          (s_axi_rresp),
        .M00_AXI_RLAST          (s_axi_rlast),
        .M00_AXI_RVALID         (s_axi_rvalid),
        .M00_AXI_RREADY         (s_axi_rready)
    );
    
    
    
//    always_comb begin
//        if(SW[0]) LED = LED_rx;
//        else if(SW[1]) LED = LED_tx;
//    end
    
    
//    reg [17:0]  clk125_cnt;
//    reg         BTN;
    /*
    always_ff @(posedge clk125)begin
        if(BTN_C)begin
            clk125_cnt <= clk125_cnt + 1;
            if(clk125_cnt==18'd262143)begin
                BTN <= 1;
            end
            else BTN <= 0;
        end
        else BTN <= 0;
    end
    */
//    always_comb begin
//        BTN = BTN_C;
//    end
    
//    UDP UDP(
//        .clk125(clk125),
//        .rst_rx(rst125),
//        .BTN_C(BTN),
//        .UDP_d(UDP_btn_d),
//        .UDP_tx(UDP_btn_tx)
//    );
    
    assign ETH_RST_B = 1'bz;
    assign eth_mdio  = 1'bz;
    assign eth_mdc   = 1'b1;
    
    assign LED[0] = init_calib_complete;
    //assign LED[3:0] = tx_led[3:0];
    assign LED[8] = sys_clkgen_locked;
    assign LED[7] = eth_clkgen_locked;

    assign PMOD_A[0] = CPU_RSTN;
    assign PMOD_A[1] = sys_clkgen_locked;
    assign PMOD_A[2] = eth_clkgen_locked;
    assign PMOD_A[3] = ETH_RST_B;
    assign PMOD_A[4] = eth_mdc;
    assign PMOD_A[5] = 1'b0; //eth_mdio_o;
    assign PMOD_A[6] = 1'b0; //eth_mdio_oe;

    assign SET_VADJ = 2'b11;  //-- 3.3V
    assign VADJ_EN  = 1'b1;   //-- On
    
endmodule
