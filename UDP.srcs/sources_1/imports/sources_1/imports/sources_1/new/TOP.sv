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
    input [3:0]      eth_rxd,     // 受信フレームデータ
    input            eth_rxck,    // 受信クロック
    input            eth_rxctl,   // 受信フレーム検知で'1'
    
    input            BTN_C,       // 任意のタイミングでのリセット   
            
    output reg [3:0] eth_txd,    //-- Ether RGMII Tx data.
    output wire      eth_txck,
    output reg       eth_txctl,
    output reg       eth_rst_b,  //-- Ether PHY reset(active low)

    input            SYSCLK,     // その他用クロック
    input            CPU_RSTN,   //
    input            reset_i,
    
    input  [7:0]     SW,
    output [7:0]     LED
    );
    
    wire [7:0]       gmii_txd;
    wire             gmii_txctl;
     
    (*dont_touch="true"*) wire [7:0] gmii_rxd;
    (*dont_touch="true"*) wire  gmii_rxctl;
     
    //**------------------------------------------------------------
    //** RGMII to GMII translator. (add by moikawa)
    //**
    RGMII2GMII rgmii2gmii (
          .rxd_i    ( eth_rxd    ), //<-- INPUT[3:0]
          .rxck_i   ( eth_rxck   ), //<-- INPUT, Rx clock 125 MHz.
          .rxctl_i  ( eth_rxctl  ), //--
          .rxd_o    ( gmii_rxd   ), //--[7:0]
          .rxctl_o  ( gmii_rxctl )
    ) ;
    //**------------------------------------------------------------
    //** GMII to RGMII translator. (add by moikawa)
    //**
    wire clk10;
    wire clk100;
    wire clk125,    rst125;
    wire clk125_90;
    wire locked;
    GMII2RGMII gmii2rgmii (
          .txck_o   ( eth_txck   ),
          .txd_o    ( eth_txd    ), //--> OUTPUT
          .txctl_o  ( eth_txctl  ), //--> OUTPUT
          .txck_i   ( clk125     ), //- Tx clock 125MHz.
          .txck_90_i( clk125_90  ),
          .txd_i    ( gmii_txd   ), //-- [7:0]
          .txctl_i  ( gmii_txctl )  //--
    );
    //**------------------------------------------------------------
    //** Clock generator. (add by moikawa)
    //**
    CLKGEN clkgen (
          .clk125_90( clk125_90  ), //- 125 MHz
          .clk125   ( clk125     ), //- 125 MHz
          .clk100   ( clk100     ), //- 100 MHz
          .clk10    ( clk10      ), //- 10 MHz
          .reset    ( !CPU_RSTN  ),
          .locked   ( locked     ),
          .SYSCLK   ( SYSCLK     )
    );
    //**------------------------------------------------------------
    //** Reset generator. (add by moikawa)
    //**
    RSTGEN rstgen125 (
         .reset_o  ( rst125 ),
         .reset_i  ( 1'b0   ),
         .locked_i ( locked ),
         .clk      ( clk125 )
    );
    RSTGEN rstgen_rx (
         .reset_o  ( rst_rx ),
         .reset_i  ( 1'b0   ),
         .locked_i ( locked ),
         .clk      ( eth_rxck )
    );
    
    wire rst_btn = BTN_C;
    wire arp_tx_en;
    wire ping_tx_en;
    wire UDP_tx_en;
    wire arp_tx;
    wire ping_tx;
    wire UDP_btn_tx;        // ボタン入力によるUDP送信
    wire UDP_tx;            // UDPの送受信
    wire [8:0] arp_d;   
    wire [8:0] ping_d;  
    wire [8:0] UDP_btn_d;   // ボタン入力によるUDP送信
    wire [8:0] UDP_d;       // UDPの送受信
    
    Arbiter R_Arbiter (
        /*---INPUT---*/
        .gmii_rxd(gmii_rxd),
        .gmii_rxctl(gmii_rxctl),
        .eth_rxck(eth_rxck),
        .rst_rx(rst_rx),
        .rst125(rst125),
        .clk125(clk125),
        .rst_btn(rst_btn),
        .SW(SW),
        /*---OUTPUT---*/
        .arp_tx_en(arp_tx_en),
        .ping_tx_en(ping_tx_en),
        .UDP_tx_en(UDP_tx_en),
        .arp_tx(arp_tx),
        .ping_tx(ping_tx),
        .UDP_tx(UDP_tx),
        .arp_d(arp_d),
        .ping_d(ping_d),
        .UDP_d(UDP_d)
        //.LED(LED_rx)
    );

    T_Arbiter T_Arbiter(
        .arp_d(arp_d),
        .ping_d(ping_d),
        .UDP_btn_d(UDP_btn_d),
        .UDP_d(UDP_d),
        .arp_tx_en(arp_tx_en),
        .ping_tx_en(ping_tx_en),
        .UDP_tx_en(UDP_tx_en),
        .arp_tx(arp_tx),
        .ping_tx(ping_tx),
        .UDP_btn_tx(UDP_btn_tx),
        .UDP_tx(UDP_tx),
        .eth_rxck(eth_rxck),
        .clk125(clk125),
        //.clk125_90(clk125_90),
        .rst125(rst125),
        .txd(gmii_txd),
        .gmii_txctl(gmii_txctl),
        .LED(LED)
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
    
  
    always @(posedge SYSCLK) begin //-- EtherPHY reset output.
        eth_rst_b <= CPU_RSTN;
    end
    
endmodule
