`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/26 17:43:14
// Design Name: 
// Module Name: Arbiter
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
`include "user_defines.sv"

module Arbiter(
    input [7:0]           gmii_rxd,
    input                 eth_rxck,
    input                 gmii_rxctl,
    input                 rst_rx,
    input                 rst125,
    input                 clk125,
    
    input                 rst_btn,
    input [7:0]           SW,
    
    output reg            arp_tx,
    output reg            ping_tx,
    output reg            UDP_tx,
    output reg [8:0]      arp_d,
    output reg [8:0]      ping_d,
    output reg [8:0]      UDP_d,
    output reg [7:0]      LED
    );
    
parameter  Idle        = 8'h00;
parameter  SFD_Wait    = 8'h01;
parameter  Recv_Data   = 8'h02;
parameter  Recv_End    = 8'h03;
    
    reg       pre;
    reg [7:0] RXBUF [1045:0];
    
    /* ステートマシン */
    (*dont_touch="true"*)reg [7:0] st;
    reg [7:0] nx;
    
    //<-- test by oikawa
    reg [4:0] rxend_cnt;
    always_ff @(posedge eth_rxck)begin
       if (st==Idle) rxend_cnt <= 5'h0;
       else if (st==Recv_End) rxend_cnt <= rxend_cnt + 5'h1;
    end
    //--> test by oikawa
    
    always_ff @(posedge eth_rxck)begin
        if(rst_rx)  st <= Idle;
        else        st <= nx;
    end
    
    always_comb begin
        nx = st;
        case(st)
            Idle:       if (gmii_rxctl)  nx = SFD_Wait;
            SFD_Wait:   if (pre)         nx = Recv_Data;
            Recv_Data:  if (!gmii_rxctl) nx = Recv_End;
            //Recv_End:                    nx = Idle;
            Recv_End:   if (rxend_cnt==5'h2F)  nx = Idle;
            default:begin end
        endcase
    end
    
    /*---MAC/IP addressをDIPスイッチを使って任意に決める(add 2018.12.5)---*/
    wire [3:0] sw_sel = {SW[3],SW[2],SW[1],SW[0]};
    reg  [47:0] my_MACadd;
    reg  [31:0] my_IPadd;
    always_comb begin
        my_MACadd   =  {44'h00_0A_35_02_0F_B,sw_sel};
        my_IPadd    =  {8'd172,8'd31,8'd210,4'd10,sw_sel};
    end
    
    /* DstMAC */
    wire [47:0] host_MAC = {RXBUF[0],RXBUF[1],RXBUF[2],RXBUF[3],RXBUF[4],RXBUF[5]};
    (*dont_touch="true"*)reg [47:0] DstMAC;
    (*dont_touch="true"*)reg [31:0] DstIP;
    always_ff @(posedge eth_rxck) begin
        if(st==Recv_End&&{RXBUF[12],RXBUF[13]}==`FTYPE_ARP)begin
            //if(host_MAC== `bcast_MAC || host_MAC==`my_MAC)begin
            if(host_MAC== `bcast_MAC || host_MAC==my_MACadd)begin   // add 2018.12.5
                DstMAC <= {RXBUF[6],RXBUF[7],RXBUF[8],RXBUF[9],RXBUF[10],RXBUF[11]};
                DstIP <= {RXBUF[28],RXBUF[29],RXBUF[30],RXBUF[31]};
            end
        end
        else if(st==Idle)begin
            DstMAC <= 48'b0;
            DstIP <= 32'b0;
        end
    end
    
    /* rxdとrxctlの遅延 */
    (*dont_touch="true"*)reg [7:0] q_rxd [3:0];
    reg [3:0] q_rxctl;
    always @(posedge eth_rxck)begin
       if (rst_rx) begin
          q_rxctl <= 4'b0; 
       end else begin
          q_rxd <= {q_rxd[2:0],gmii_rxd};
          q_rxctl <= {q_rxctl[2:0], gmii_rxctl};
       end
    end    
    
    /* 受信 */
    /* 受信データ数 */
    (*dont_touch="true"*) reg [10:0] rx_cnt;
    always_ff @(posedge eth_rxck)begin
        if(st==Recv_Data)       rx_cnt <= rx_cnt + 11'd1;
        else if(st==Idle)       rx_cnt <= 0;
    end
    
    /* 受信データロード */
    integer i;
    always_ff @(posedge eth_rxck)begin
        if(st==Recv_Data) RXBUF[rx_cnt] <= q_rxd[0];
        else if(st==Idle) for(i=0;i<1046;i=i+1) RXBUF[i] <= 8'h00;
    end
    
    /* SFD検出 */
    always_comb begin
        if(st==SFD_Wait&&q_rxd[0]==`SFD) pre = 1'b1;
        else pre = 1'b0;
    end
    
    /* CRC_DELAY */
    reg [1:0] delay_CRC;    // CRCのために4バイト遅らせる
    reg       CRC_flg;
    reg       reset;
    always_ff @(posedge eth_rxck or negedge gmii_rxctl)begin
        if(st==Recv_Data)begin
            if(delay_CRC==2'b10)begin
                CRC_flg<=1;
                reset<=1;
            end
            else delay_CRC <= delay_CRC + 1;
            if(!gmii_rxctl) CRC_flg <= 0;
        end
        else if(st==Idle)begin
            reset<=0;
            delay_CRC<=0;
            CRC_flg <= 0;
        end
    end
    
    reg [31:0] CRC;
    CRC_ge crc_ge(
                .d(q_rxd[3]),
                .CLK(eth_rxck),
                .reset(reset),
                .CRC(CRC),
                .flg(CRC_flg)
    );   
    
    (*dont_touch="true"*)reg [31:0] r_crc;
    always_ff @(posedge eth_rxck) begin
        if(st==Recv_Data)begin
            r_crc <= ~{CRC[24],CRC[25],CRC[26],CRC[27],CRC[28],CRC[29],CRC[30],CRC[31],
                      CRC[16],CRC[17],CRC[18],CRC[19],CRC[20],CRC[21],CRC[22],CRC[23],
                      CRC[8],CRC[9],CRC[10],CRC[11],CRC[12],CRC[13],CRC[14],CRC[15],
                      CRC[0],CRC[1],CRC[2],CRC[3],CRC[4],CRC[5],CRC[6],CRC[7]};
        end
        else r_crc <= 0;
    end
 
    (*dont_touch="true"*)reg [31:0] FCS;
    always_ff @(posedge eth_rxck) begin
        if (st==Recv_Data&&!gmii_rxctl)begin
            FCS <= {q_rxd[3],q_rxd[2],q_rxd[1],q_rxd[0]}; 
        end
        else if(st==Idle)begin
            FCS <= 0;
        end
    end
    
    reg crc_ok;
    always_ff @(posedge eth_rxck)begin
        //if(st==Recv_End)begin
        if(st==Recv_End && rxend_cnt==4'h0)begin
            if(FCS==r_crc)begin
                crc_ok <= 1;
            end
        end
        else crc_ok <= 0;
    end
     
    /*---パケットの種類振り分け---*/
    reg [3:0] arp_st;       // ARP Packet
    reg [2:0] ping_st;      // ICMP Echo Packet(ping)
    reg [2:0] UDP_st;       // UDP Packet
    reg [2:0] els_packet;   // else Packet
    always_ff @(posedge eth_rxck)begin
        if(crc_ok)begin
            //if({RXBUF[12],RXBUF[13]}==`FTYPE_ARP&&{RXBUF[20],RXBUF[21]}==`OPR_ARP) arp_st <= 1;
            //if({RXBUF[12],RXBUF[13]}==`FTYPE_ARP&&{RXBUF[38],RXBUF[39],RXBUF[40],RXBUF[41]}==`my_IP) arp_st <= 4'h7;
            if({RXBUF[12],RXBUF[13]}==`FTYPE_ARP&&{RXBUF[38],RXBUF[39],RXBUF[40],RXBUF[41]}==my_IPadd) arp_st <= 4'h7;  // add 2018.12.5
            //else if(RXBUF[23]==8'h01) ping_st <= 3'h7;
            else if(RXBUF[23]==8'h01&&{RXBUF[30],RXBUF[31],RXBUF[32],RXBUF[33]}==my_IPadd) ping_st <= 3'h7;             // add 2018.12.11
            //else if(RXBUF[23]==8'h11&&{RXBUF[30],RXBUF[31],RXBUF[32],RXBUF[33]}==`my_IP) UDP_st  <= 3'h7;
            else if(RXBUF[23]==8'h11&&{RXBUF[30],RXBUF[31],RXBUF[32],RXBUF[33]}==my_IPadd) UDP_st  <= 3'h7;             // add 2018.12.5
            else els_packet <= 3'h7;
        end
        else begin
            arp_st  <= {arp_st[2:0], 1'b0};
            ping_st <= {ping_st[1:0], 1'b0};
            UDP_st  <= {UDP_st[1:0], 1'b0};
            els_packet <= {els_packet[1:0], 1'b0};
        end
    end
    
    ARP ARP(
        /*---INPUT---*/
        .clk125(clk125),
        .rst125(rst125),
        .arp_st(arp_st[3]),
        .my_MACadd(my_MACadd),  //<---  add 2018.12.5
        .my_IPadd(my_IPadd),    //--->
        .DstMAC(DstMAC),
        .DstIP(DstIP),
        /*---OUTPUT---*/
        .arp_tx(arp_tx),
        .d(arp_d)
    );
    
    wire crc_flg_i = CRC_flg;
    //reg [9:0] b_rx_cnt [3:0] ;
    //always_ff @(posedge eth_rxck)begin
    //    b_rx_cnt <= {b_rx_cnt[2:0],rx_cnt};
    //end
    ping ping(
        .eth_rxck(eth_rxck),
        .clk125(clk125),
        .rst_rx(rst_rx),
        //.RXBUF(RXBUF[255:0]),
        .pre(pre),
        .rxd(q_rxd[0]),
    //    .rx_cnt(b_rx_cnt[3]),
        .rx_cnt(rx_cnt),
        .arp_st(arp_st[2]),
        .ping_st(ping_st[2]),
        .my_MACadd(my_MACadd),
        .my_IPadd(my_IPadd),
        //.crc_flg_i(crc_flg_i),
        //.DstMAC(DstMAC),
        //.DstIP(DstIP),
        .ping_tx(ping_tx),
        .ping_d(ping_d)
    );
    /*
    UDP_reply UDP_reply(
        .clk125(clk125),
        .rst_rx(rst_rx),
        .RXBUF(RXBUF),
        .rx_cnt(rx_cnt),
        .UDP_st(UDP_st[2]),
        .UDP_tx(UDP_tx),
        .UDP_d(UDP_d)
    );
    */
    
    wire [7:0] imdata;
    wire [9:0] addr;
    wire [8:0] addr_cnt;
    wire    recvend;
    wire    trans_err;
    //wire [7:0] image_buffer [9999:0];
    wire [47:0] DstMAC_UDP;
    wire [31:0] DstIP_UDP;
    wire [15:0] SrcPort;
    wire [15:0] DstPort;
    
    recv_image recv_image(
        /*---Input---*/
        .eth_rxck(eth_rxck),
        .clk125(clk125),
        .rst_rx(rst_rx),
        .pre(pre),
        .rxd(q_rxd[0]),
        //.RXBUF(RXBUF),
        .rx_cnt(rx_cnt),
        .arp_st(arp_st[0]),
        .ping_st(ping_st[0]),
        .UDP_st(UDP_st[0]),
        .els_packet(els_packet[0]),
        .addrb(addr),
        .addr_cnt(addr_cnt),
        .rst_btn(rst_btn),
        .trans_err(trans_err),
        .SW(SW),        // add 2018.12.5
        /*---Output---*/
        .imdata(imdata),
        .recvend(recvend),
        //.image_buffer(image_buffer),
        .DstMAC(DstMAC_UDP),
        .DstIP(DstIP_UDP),
        .SrcPort(SrcPort),
        .DstPort(DstPort)
    );
    
    trans_image trans_image(
        /*---Input---*/
        .eth_rxck(eth_rxck),
        .clk125(clk125),
        .rst_rx(rst_rx),
        .rst_btn(rst_btn),
        .imdata(imdata),
        .recvend(recvend),
        //.image_buffer(image_buffer),
        .my_MACadd(my_MACadd),
        .my_IPadd(my_IPadd),
        .DstMAC(DstMAC_UDP),
        .DstIP(DstIP_UDP),
        .SrcPort(SrcPort),
        .DstPort(DstPort),
        .SW(SW),        // add 2018.12.5
        /*---Output---*/
        .image_cnt(addr),
        .addr_cnt(addr_cnt),
        .UDP_tx(UDP_tx),
        .UDP_d(UDP_d),
        .trans_err(trans_err)
    );

//    Image_UDP Image_UDP(
//        /*---Input---*/
//        .eth_rxck(eth_rxck),
//        .clk125(clk125),
//        .rst_rx(rst_rx),
//        .pre(pre),
//        .rxd(q_rxd[0]),
//        //.RXBUF(RXBUF),
//        .rx_cnt(rx_cnt),
//        .arp_st(arp_st),
//        .ping_st(ping_st),
//        .UDP_st(UDP_st),
//        /*---Output---*/
//        .UDP_tx(UDP_tx),
//        .UDP_d(UDP_d)
//    ); 
         
endmodule
