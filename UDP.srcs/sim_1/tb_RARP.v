`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/15 18:55:08
// Design Name: 
// Module Name: tb_RARP
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

module tb_rarp(
    );
     reg P_RXDV;
     reg P_RXCLK;
     reg [3:0] P_RXD;
     wire P_TXEN;
     wire P_TXCLK;
     wire [3:0] P_TXD;
     reg SYSCLK;
     reg CPU_RSTN;
     reg reset;
     reg tx_flg;
     reg BTN;
     reg [7:0] SW;
     
     // Input
     wire [15:0]   dq;
     wire [1:0]    dqs_n;
     wire [1:0]    dqs;
     // Outputs
     wire [14:0]   a;
     wire [2:0]    ba;
     wire          ras_n;
     wire          cas_n;
     wire          we_n;
     wire          rst_n;
     wire          ck;
     wire          ck_n;
     wire          cke;
     wire [1:0]    dm;
     wire          odt;
     wire [1:0]    tdqs_n;

   TOP top_i(
        .ETH_RXCTL(P_RXDV),
        .ETH_RXCK(P_RXCLK),
        .ETH_RXD(P_RXD),
        .ETH_TXCTL(P_TXEN),
        .ETH_TXCK(P_TXCLK),
        .ETH_TXD(P_TXD),
        .SYSCLK(SYSCLK),
        .CPU_RSTN(CPU_RSTN),
        .reset_i(reset),
        .BTN_C(BTN),
        .SW(SW),
        // Inouts
        .ddr3_dq        (dq),
        .ddr3_dqs_n     (dqs_n),
        .ddr3_dqs_p     (dqs),
        // Outputs
        .ddr3_addr      (a),
        .ddr3_ba        (ba),
        .ddr3_ras_n     (ras_n),
        .ddr3_cas_n     (cas_n),
        .ddr3_we_n      (we_n),
        .ddr3_reset_n   (rst_n),
        .ddr3_ck_p      (ck),
        .ddr3_ck_n      (ck_n),
        .ddr3_cke       (cke),
        .ddr3_dm        (dm),
        .ddr3_odt       (odt)
    );
    
    ddr3_den4096Mb ddr3_den4096Mb (
        .rst_n(rst_n),
        .ck(ck), 
        .ck_n(ck_n),
        .cke(cke), 
        .cs_n(1'b0),       // コントロールしない
        .ras_n(ras_n), 
        .cas_n(cas_n), 
        .we_n(we_n), 
        .dm_tdqs(dm), 
        .ba(ba), 
        .addr(a), 
        .dq(dq), 
        .dqs(dqs),
        .dqs_n(dqs_n),
        .tdqs_n(tdqs_n),     // 未使用
        .odt(odt)
    );
    
   /*---R_Arbiter---*/
   parameter Idle       =  8'h00;   // 待機状態
   parameter SFD_Wait   =  8'h01;   // プリアンブル検知中
   parameter Recv_Data  =  8'h02;   // データ処理
   parameter Recv_End   =  8'h03;   // 処理終了
   
   /*---T_Arbiter---*/
   parameter Stby      =  4'h1;
   parameter Tx_Pre    =  4'h2;   // プリアンブル送信
   parameter Tx_Data   =  4'h3;   // データ送信
   parameter Tx_End    =  4'h4;   // 送信終了
   
   /*---ARP---*/
   parameter Idle_A      =  4'h0;   // 待機
   parameter Tx_Ready_A  =  4'h1;   // 送信準備
   parameter Tx_A        =  4'h2;   // 送信中
   parameter Tx_End_A    =  4'h3;   // 送信終了   
   
   /*---ping---*/
   parameter   Idle_p    =   4'h0;
   parameter   Stby_p    =   4'hD;
   parameter   Presv_p   =   4'h1;
   parameter   Hcsum_p   =   4'h2;
   parameter   Hc_End_p  =   4'h3;
   parameter   Icsum_p   =   4'h4;
   parameter   Ic_End_p  =   4'h5;
   parameter   Ready_p   =   4'h6;
   parameter   Tx_Hc_p   =   4'h7;
   parameter   Tx_HEnd_p =   4'h8;
   parameter   Tx_Ic_p   =   4'h9;
   parameter   Tx_IEnd_p =   4'hA;
   parameter   Tx_En_p   =   4'hB;
   parameter   Tx_End_p  =   4'hC; 
      
   /*---recv_image---*/
   parameter   Idle_im     =   8'h00;
   parameter   Stby_im     =   8'h09;
   parameter   Presv       =   8'h01;
   parameter   Hcsum_im    =   8'h02;
   parameter   Hc_End_im   =   8'h03;
   parameter   Ucsum       =   8'h04;
   parameter   Uc_End      =   8'h05;
   parameter   Select      =   8'h06;
   parameter   Recv_End_im =   8'h07;
   parameter   ERROR       =   8'h08;
   
   /*---trans_image---*/
   parameter   IDLE     =   8'h00;
   parameter   Presv_t  =   8'h01;
   parameter   READY    =   8'h02;
   parameter   Hcsum_t  =   8'h03;
   parameter   Hc_End_t =   8'h04;
   parameter   Ucsum_t  =   8'h05;
   parameter   Uc_End_t =   8'h06;
   parameter   Tx_En_t  =   8'h07;
   parameter   Select_t =   8'h08;
   parameter   Tx_End_t =   8'h09;
   
   /*---axi_write---*/
   parameter   AWCH    =   4'h1;
   parameter   AW_OK   =   4'h2;
   
   parameter   STBY    =   4'h3;
   parameter   WCH     =   4'h4;
   parameter   WEND    =   4'h5;
   
   /*---axi_read---*/
   parameter   ARCH    =   4'h1;
   parameter   AR_OK   =   4'h2;
   
   parameter   READ    =   4'h4;
   parameter   REND    =   4'h5;   
   
   reg [79:0] str_st_rx;
   reg [79:0] str_st_tx;
   reg [79:0] str_st_arp;
   reg [79:0] str_st_ping;
   reg [79:0] str_st_udp_image;
   reg [79:0] str_st_trans_image;
   reg [79:0] str_st_axi_aw;
   reg [79:0] str_st_axi_w;
   reg [79:0] str_st_axi_ar;
   reg [79:0] str_st_axi_r;   
   always_comb begin
      case (top_i.R_Arbiter.st)
         Idle: str_st_rx = "idle";   
         SFD_Wait: str_st_rx = "sfd_wait";
         Recv_Data: str_st_rx = "recv_data";
         Recv_End: str_st_rx = "recv_end";
      endcase
   end
   
   always_comb begin
      case (top_i.T_Arbiter.st)
         Idle: str_st_tx = "idle";
         Stby : str_st_tx = "stby";
         Tx_Pre: str_st_tx = "tx_pre";
         Tx_Data: str_st_tx = "tx_data";
         Tx_End: str_st_tx = "tx_end";
      endcase
   end
   
   always_comb begin
      case (top_i.R_Arbiter.arp.st)
         Idle_A : str_st_arp = "idle";
         Tx_Ready_A : str_st_arp = "tx_ready";
         Tx_A : str_st_arp = "tx";
         Tx_End_A : str_st_arp = "tx_end";
      endcase
   end
   
   always_comb begin
      case (top_i.R_Arbiter.ping.st)
         Idle_p : str_st_ping = "idle";
         Stby_p : str_st_ping = "stby";
         Presv_p : str_st_ping = "presv";
         Hcsum_p : str_st_ping = "hcsum";
         Hc_End_p : str_st_ping = "hc_end";
         Icsum_p : str_st_ping = "icsum";
         Ic_End_p : str_st_ping = "ic_end";
         Ready_p : str_st_ping = "ready";
         Tx_Hc_p : str_st_ping = "tx_hc";
         Tx_HEnd_p : str_st_ping = "tx_hend";
         Tx_Ic_p : str_st_ping = "tx_ic";
         Tx_IEnd_p : str_st_ping = "tx_iend";
         Tx_En_p : str_st_ping = "tx_en";
         Tx_End_p: str_st_ping = "tx_end";
      endcase
   end
   
//   always_comb begin
//    case (top_i.UDP.st)
//        Idle : str_st_udp = "idle";
//        IP_cs : str_st_udp = "ip_cs";
//        IP_End : str_st_udp = "ip_end";
//        UDP_cs : str_st_udp = "udp_cs";
//        UDP_End : str_st_udp = "udp_end";
//        Ready : str_st_udp = "ready";
//        TX_En : str_st_udp = "tx_en";
//        TX_End : str_st_udp = "tx_end";
//    endcase
//   end
   
//   always_comb begin
//         case (top_i.R_Arbiter.UDP_reply.st)
//            Idle: str_st_udp2 = "idle";   
//            Hcsum: str_st_udp2 = "hcsum";
//            Hc_End: str_st_udp2 = "hc_end";
//            Icsum: str_st_udp2 = "ucsum";
//            Ic_End: str_st_udp2 = "uc_end";
//            Ready: str_st_udp2 = "ready";
//            Tx_Hc: str_st_udp2 = "tx_hc";
//            Tx_HEnd: str_st_udp2 = "tx_hend";
//            Tx_Ic: str_st_udp2 = "tx_uc";
//            Tx_IEnd: str_st_udp2 = "tx_uend";
//            Tx_En: str_st_udp2 = "tx_en";
//            Tx_End_p: str_st_udp2 = "tx_end";
//         endcase
//      end

    /*---recv_image---*/
    always_comb begin
        case (top_i.R_Arbiter.recv_image.st)
            Idle_im : str_st_udp_image = "idle";
            Stby_im : str_st_udp_image = "stby";
            Presv : str_st_udp_image = "presv";
            Hcsum_im : str_st_udp_image = "hcsum";
            Hc_End_im : str_st_udp_image = "hc_end";
            Ucsum : str_st_udp_image = "ucsum";
            Uc_End : str_st_udp_image = "uc_end";
            Select : str_st_udp_image = "select";
            Recv_End_im : str_st_udp_image = "recv_end";
            ERROR : str_st_udp_image = "ERROR";
        endcase
    end

    /*---trans_image---*/
    always_comb begin
        case (top_i.R_Arbiter.trans_image.st)
            IDLE : str_st_trans_image = "idle";
            Presv_t : str_st_trans_image = "presv";
            READY : str_st_trans_image = "ready";
            Hcsum_t : str_st_trans_image = "hcsum";
            Hc_End_t : str_st_trans_image = "hc_end";
            Ucsum_t : str_st_trans_image = "ucsum";
            Uc_End_t : str_st_trans_image = "uc_end";
            Tx_En_t : str_st_trans_image = "tx_en";
            Select_t : str_st_trans_image = "select";
            Tx_End_t : str_st_trans_image = "tx_end";
        endcase
    end
    
    always_comb begin
        case (top_i.R_Arbiter.recv_image.axi_write.st_aw)
            IDLE : str_st_axi_aw = "idle";
            AWCH : str_st_axi_aw = "awch";
            AW_OK : str_st_axi_aw = "aw_ok";
        endcase
    end
    
    always_comb begin
        case (top_i.R_Arbiter.recv_image.axi_write.st_w)
            IDLE : str_st_axi_w = "idle";
            STBY : str_st_axi_w = "stby";
            WCH : str_st_axi_w = "wch";
            WEND : str_st_axi_w = "wend";
        endcase    
    end
    
    always_comb begin
        case (top_i.R_Arbiter.trans_image.axi_read.st_ar)
            IDLE : str_st_axi_ar = "idle";
            ARCH : str_st_axi_ar = "arch";
            AR_OK : str_st_axi_ar = "ar_ok";
        endcase
    end
    
    always_comb begin
        case (top_i.R_Arbiter.trans_image.axi_read.st_r)
            IDLE : str_st_axi_r = "idle";
            STBY : str_st_axi_r = "stby";
            READ : str_st_axi_r = "read";
            REND : str_st_axi_r = "rend";
        endcase    
    end    

      
   initial begin
      P_RXDV = 0;
      reset = 0;
      CPU_RSTN = 1;
      SW = 8'd0;    // add 2018.12.5
      #18.5;
      reset = 1;
      #18.5;
   end
        
   initial begin
      forever begin
         #5 SYSCLK = 0;
         #5 SYSCLK = 1;
      end
   end
        
   initial begin
      #7;    //-- phase trimm
      forever begin
         #4 P_RXCLK = 1'b0; //- 125 MHz
         #4 P_RXCLK = 1'b1;
      end
   end
        
   integer i;
   initial begin
      #100;
      rstCPU();
      #4000;
      #120000;  // wait ddr3 calib
      
      /*---Select MAC/IP address---*/
      SW = 8'd1;
      #16
      SW = 8'd2;
      #16
      SW = 8'd3;
      #16
      SW = 8'd4;
      #16
      SW[3:0] = 4'd0;
      SW[7:4] = 4'd10;
      #16
      
      #5000
      // プリアンブル
      repeat(7) recvByte(8'h55);
      recvByte(8'hd5);
      // 宛先MAC
      recvMac(48'hFF_FF_FF_FF_FF_FF);
      // 送信元MAC
      recvMac(48'hF8_32_E4_BA_0D_57);
      //フレームタイプ
      recvByte(8'h08);
      recvByte(8'h06);
        /*
        parameter HTYPE = 16'h00_01;                // ハードウェアタイプ(イーサネット=1)
        parameter PTYPE = 16'h08_00;                // プロトコルタイプ(IPv4==0800以降)
        parameter HLEN = 8'h06;                     // ハードウェア長=6
        parameter PLEN = 8'h04;                     // プロトコル長=4
        parameter OPER = 16'h00_01;                 // オペレーション(要求=1,返信=2)
        */
        // ハードウェアタイプ
        recvByte(8'h00);
        recvByte(8'h01);

        // プロトコルタイプ
        recvByte(8'h08);
        recvByte(8'h00);
        
        // ハードウェア長
        recvByte(8'h06);
        
        // プロトコル長
        recvByte(8'h04);
        
        // オペレーション
        recvByte(8'h00);
        recvByte(8'h01);
        
        // SrcMAC
        recvMac(48'hF8_32_E4_BA_0D_57);
        
        // SrcIP 172.31.203.41
        recvIp({8'd172, 8'd31, 8'd210, 8'd129});
        // DstMAC
        recvMac(48'h00_00_00_00_00_00);
        // DstIP 172.31.203.236
        recvIp({8'd172, 8'd31, 8'd210, 8'd160});
        /* パディング */
        for(i=0;i<18;i=i+1)begin
            recvByte(8'h00);
        end
        
        /* CRC */
        recvByte(8'h9B);
        recvByte(8'h89);
        recvByte(8'h30);
        recvByte(8'hC8);
        //P_RXDV = 0;
        recv_end();
        
        //P_RXCLK = 0;
        @(posedge P_RXCLK)
        P_RXD = 4'h0;
        @(posedge P_RXCLK)
         tx_flg = 1;
        

       
        
         /*---ping---*/ 
         #2000;
         // プリアンブル
         repeat(7) recvByte(8'h55);
         recvByte(8'hd5);
         // 宛先MAC
         recvMac(48'h00_0A_35_02_0F_B0);
         // 送信元MAC
         recvMac(48'hF8_32_E4_BA_0D_57);
         //フレームタイプ
         recvByte(8'h08);
         recvByte(8'h00);
         
         // Varsion / IHL
         recvByte(8'h45);
 
         // ToS
         recvByte(8'h00);
         
         // Total Length
         recvByte(8'h00);
         recvByte(8'h54);
         
         // Identification
         recvByte(8'hFA);
         recvByte(8'hA9);
         
         // Flags[15:13]/Flagment Offset[12:0]
         recvByte(8'h40);
         recvByte(8'h00);
           
         // Time To Live
         recvByte(8'h40);
         
         // Protocol
         recvByte(8'h01);
         
         // Header Checksum
         recvByte(8'h42);
         recvByte(8'h9E);
         
         // SrcIP 172.31.210.129
         recvIp({8'd172, 8'd31, 8'd210, 8'd129});
         
         // DstIP 172.31.210.130
         recvIp({8'd172, 8'd31, 8'd210, 8'd160});
         /*--ICMP--*/
         // Type
         recvByte(8'h08);
         
         // Code
         recvByte(8'h00);
         
         // Checksum
         recvByte(8'hB5);
         recvByte(8'h88);
         
         // Identifier
         recvByte(8'h15);
         recvByte(8'h18);
         
         // Sequence number
         recvByte(8'h00);
         recvByte(8'h18);
         
         // Data
         recvByte(8'hF9);
         recvByte(8'h30);
         recvByte(8'h1B);
         recvByte(8'h5C);
         recvByte(8'h00);
         recvByte(8'h00);
         recvByte(8'h00);
         recvByte(8'h00);
         recvByte(8'h59);
         recvByte(8'hE7);
         recvByte(8'h00);
         recvByte(8'h00);
         recvByte(8'h00);
         recvByte(8'h00);
         recvByte(8'h00);
         recvByte(8'h00);
         recvByte(8'h10);
         recvByte(8'h11);
         recvByte(8'h12);
         recvByte(8'h13);
         recvByte(8'h14);
         recvByte(8'h15);
         recvByte(8'h16);
         recvByte(8'h17);
         recvByte(8'h18);
         recvByte(8'h19);
         recvByte(8'h1A);
         recvByte(8'h1B);
         recvByte(8'h1C);
         recvByte(8'h1D);
         recvByte(8'h1E);
         recvByte(8'h1F);
         recvByte(8'h20);
         recvByte(8'h21);
         recvByte(8'h22);
         recvByte(8'h23);
         recvByte(8'h24);
         recvByte(8'h25);
         recvByte(8'h26);
         recvByte(8'h27);
         recvByte(8'h28);
         recvByte(8'h29);
         recvByte(8'h2A);
         recvByte(8'h2B);
         recvByte(8'h2C);
         recvByte(8'h2D);
         recvByte(8'h2E);
         recvByte(8'h2F);
         recvByte(8'h30);
         recvByte(8'h31);
         recvByte(8'h32);
         recvByte(8'h33);
         recvByte(8'h34);
         recvByte(8'h35);
         recvByte(8'h36);
         recvByte(8'h37);
         
         /* CRC */
         recvByte(8'h66);
         recvByte(8'hBC);
         recvByte(8'h4A);
         recvByte(8'h53);
         
         recv_end();
         
         /*---UDP_btn---*/
         #3000;
         BTN <= 0;
         #10;
         BTN <= 1;
         #10;
         BTN <= 0;
         
         /*---UDP---*/
         #2500;
//         // プリアンブル
//         repeat(7) recvByte(8'h55);
//         recvByte(8'hd5);
//         // 宛先MAC
//         recvMac(48'h00_0A_35_02_0F_B9);
//         // 送信元MAC
//         recvMac(48'hF8_32_E4_BA_0D_57);
//         //フレームタイプ
//         recvByte(8'h08);
//         recvByte(8'h00);
         
//         // Varsion / IHL
//         recvByte(8'h45);
 
//         // ToS
//         recvByte(8'h00);
         
//         // Total Length
//         recvByte(8'h00);
//         recvByte(8'd52);
         
//         // Identification
//         recvByte(8'hAB);
//         recvByte(8'hCD);
         
//         // Flags[15:13]/Flagment Offset[12:0]
//         recvByte(8'h40);
//         recvByte(8'h00);
           
//         // Time To Live
//         recvByte(8'd255);
         
//         // Protocol
//         recvByte(8'h11);
         
//         // Header Checksum
//         recvByte(8'hD2);
//         recvByte(8'hA7);
         
//         // SrcIP 172.31.210.129
//         recvIp({8'd172, 8'd31, 8'd210, 8'd129});
         
//         // DstIP 172.31.210.130
//         recvIp({8'd172, 8'd31, 8'd210, 8'd130});         
         
//         /*---UDPヘッダ---*/
//         // SrcPort
//         recvByte(8'hEA);
//         recvByte(8'h60);
//         // DstPort
//         recvByte(8'hEA);
//         recvByte(8'h60);
//         // UDP Len
//         recvByte(8'h00);
//         recvByte(8'h20);
//         // UDP_Checksum
//         recvByte(8'hA9);
//         recvByte(8'h18);
//         /*---UDPデータ---*/
//         recvByte(8'h00);
//         recvByte(8'h01);
//         recvByte(8'h02);
//         recvByte(8'h03);
//         recvByte(8'h04);
//         recvByte(8'h05);
//         recvByte(8'h06);
//         recvByte(8'h07);
//         recvByte(8'h08);
//         recvByte(8'h09);
//         recvByte(8'h0A);
//         recvByte(8'h0B);
//         recvByte(8'h0C);
//         recvByte(8'h0D);
//         recvByte(8'h0E);
//         recvByte(8'h0F);
//         recvByte(8'h10);
//         recvByte(8'h11);
//         recvByte(8'h12);
//         recvByte(8'h13);
//         recvByte(8'h14);
//         recvByte(8'h15);
//         recvByte(8'h16);
//         recvByte(8'h17);
         
//         //CRC
//         recvByte(8'h0C);
//         recvByte(8'h5E);
//         recvByte(8'h2F);
//         recvByte(8'h99);
//         P_RXDV = 0;
         
         /*---UDP_image---*/
         #2500;
         SW[7:4] = 4'h2;
         #2500;
         UDP_COLOR();
         #96;
         UDP_COLOR();
         #96;
         
         #100000;
         
         SW[7:4] = 4'hB;
         #2500;
         COLOL_640();
         
         
//         SW[7:4] = 4'hA;
//         #2500;
//         UDP_image(0);
//         #96;
//         UDP_image(1);
//         #96;
//         UDP_image(0);
//         #96;
//         UDP_image(1);
//         #96;
//         UDP_image(0);
//         #96;
//         UDP_image(1);
//         #96;
//         UDP_image(0);
//         #96;
//         UDP_image(1);
//         #96;
//         UDP_image(0);
//         #96;
//         UDP_image(1);                
//         #10000;
         
         #100000;
         SW[7:4] = 4'hA;
         #2500;
         UDP10000();
         
         #150000;
//         /*--1パケット目--*/
//         UDP_image();
//         /*--2パケット目--*/
//         #10000;
//         UDP_image();
//         /*--3パケット目--*/
//         #10000;
//         UDP_image();
//         /*--4パケット目--*/
//         #10000;
//         UDP_image();
//         /*--5パケット目--*/
//         #10000;
//         UDP_image();
//         /*--6パケット目--*/
//         #10000;
//         UDP_image();
//         /*--7パケット目--*/
//         #10000;
//         UDP_image();
//         /*--8パケット目--*/
//         #10000;
//         UDP_image();  
//         /*--9パケット目--*/
//         #10000;
//         UDP_image();
//         /*--10パケット目--*/
//         #10000;
//         UDP_image();
         
         #15000
//         /*--1パケット目--*/
//         UDP_image();
//         /*--2パケット目--*/
//         #10000;
//         UDP_image();
//         /*--3パケット目--*/
//         #10000;
//         UDP_image();
//         /*--4パケット目--*/
//         #10000;
//         UDP_image();
//         /*--5パケット目--*/
//         #10000;
//         UDP_image();
//         /*--6パケット目--*/
//         #10000;
//         UDP_image();
//         /*--7パケット目--*/
//         #10000;
//         UDP_image();
//         /*--8パケット目--*/
//         #10000;
//         UDP_image();  
//         /*--9パケット目--*/
//         #10000;
//         UDP_image();
//         /*--10パケット目--*/
//         #10000;
//         UDP_image();
         
         /*---160パケット---*/
         SW[7:4] = 4'hF;
         #15000;
         UDP_160();
         
         /*ARP2--f8_32...->00_0A*/
         
//         #2500;
//            // プリアンブル
//         repeat(7) recvByte(8'h55);
//         recvByte(8'hd5);
//         // 宛先MAC
//         recvMac(48'h00_0A_35_02_0F_B9);
//         // 送信元MAC
//         recvMac(48'hF8_32_E4_BA_0D_57);
//         //フレームタイプ
//         recvByte(8'h08);
//         recvByte(8'h06);
//           /*
//           parameter HTYPE = 16'h00_01;                // ハードウェアタイプ(イーサネット=1)
//           parameter PTYPE = 16'h08_00;                // プロトコルタイプ(IPv4==0800以降)
//           parameter HLEN = 8'h06;                     // ハードウェア長=6
//           parameter PLEN = 8'h04;                     // プロトコル長=4
//           parameter OPER = 16'h00_01;                 // オペレーション(要求=1,返信=2)
//           */
//           // ハードウェアタイプ
//           recvByte(8'h00);
//           recvByte(8'h01);
   
//           // プロトコルタイプ
//           recvByte(8'h08);
//           recvByte(8'h00);
           
//           // ハードウェア長
//           recvByte(8'h06);
           
//           // プロトコル長
//           recvByte(8'h04);
           
//           // オペレーション
//           recvByte(8'h00);
//           recvByte(8'h01);
           
//           // SrcMAC
//           recvMac(48'hF8_32_E4_BA_0D_57);
           
//           // SrcIP 172.31.203.41
//           recvIp({8'd172, 8'd31, 8'd210, 8'd129});
//           // DstMAC
//           recvMac(48'h00_00_00_00_00_00);
//           // DstIP 172.31.203.236
//           recvIp({8'd172, 8'd31, 8'd210, 8'd130});
//           /* パディング */
//           for(i=0;i<18;i=i+1)begin
//               recvByte(8'h00);
//           end
           
//           /* CRC */
//           recvByte(8'hDF);
//           recvByte(8'h3A);
//           recvByte(8'hCA);
//           recvByte(8'h63);
//           P_RXDV = 0;
           
//           //P_RXCLK = 0;
//           @(posedge P_RXCLK)
//           P_RXD = 4'h0;         
         
         
     end

   //**
   //** receive 1 Byte via RGMII.
   //**
   task recvByte(input [7:0] c);
      begin
         @(posedge P_RXCLK) ;
         P_RXD = c[3:0];
         P_RXDV = 1'b1;
         @(negedge P_RXCLK) ;
         P_RXD = c[7:4];
      end
   endtask //
   task recvMac(input [47:0] addr);
      begin
         recvByte(addr[47:40]);
         recvByte(addr[39:32]);
         recvByte(addr[31:24]);
         recvByte(addr[23:16]);
         recvByte(addr[15:8]);
         recvByte(addr[7:0]);
      end
   endtask
   task recvIp(input [31:0] addr);
      begin
         recvByte(addr[31:24]);
         recvByte(addr[23:16]);
         recvByte(addr[15:8]);
         recvByte(addr[7:0]);
      end
   endtask
   task rstCPU();
      begin
         CPU_RSTN = 0;
         #1000;
         CPU_RSTN = 1;
      end
   endtask
   task UDP_image(input [1:0] n);
        begin
         // プリアンブル
        repeat(7) recvByte(8'h55);
        recvByte(8'hd5);
        // 宛先MAC
        recvMac(48'h00_0A_35_02_0F_B0);
        // 送信元MAC
        recvMac(48'hF8_32_E4_BA_0D_57);
        //フレームタイプ
        recvByte(8'h08);
        recvByte(8'h00);
        
        /*--IP header--*/
        // Varsion / IHL
        recvByte(8'h45);

        // ToS
        recvByte(8'h00);
        
        // Total Length
        recvByte(8'h04);
        recvByte(8'd04);
        
        // Identification
        recvByte(8'hAB);
        recvByte(8'hCD);
        
        // Flags[15:13]/Flagment Offset[12:0]
        recvByte(8'h40);
        recvByte(8'h00);
          
        // Time To Live
        recvByte(8'd255);
        
        // Protocol
        recvByte(8'h11);
        
        // Header Checksum
        recvByte(8'hCE);
        recvByte(8'hB9);
        
        // SrcIP 172.31.210.129
        recvIp({8'd172, 8'd31, 8'd210, 8'd129});
        
        // DstIP 172.31.210.130
        recvIp({8'd172, 8'd31, 8'd210, 8'd160});         
        
        /*--UDPHeader--*/
        // SrcPort
        recvByte(8'hAF);
        recvByte(8'hDB);
        // DstPort
        recvByte(8'hEA);
        recvByte(8'h60);
        // UDP Len
        recvByte(8'h03);
        recvByte(8'hF0);
        // UDP_Checksum
        recvByte(8'h60);
        recvByte(8'h70); 
        /*--UDP Data--*/
        if(n==0)begin
            recvByte(8'hAA);                // dummy 1byte
        end
        else if(n==1)begin
            recvByte(8'hBB);                // dummy 1byte
        end
        repeat(99)  recvByte(8'h00);    // 100
        repeat(100) recvByte(8'hFF);    // 200
        repeat(100) recvByte(8'h00);    // 300
        repeat(100) recvByte(8'hFF);    // 400
        repeat(100) recvByte(8'h00);    // 500
        repeat(100) recvByte(8'hFF);    // 600
        repeat(100) recvByte(8'h00);    // 700
        repeat(100) recvByte(8'hFF);    // 800
        repeat(100) recvByte(8'h00);    // 900
        repeat(100) recvByte(8'hFF);    // 1000
        
        // CRC
        if(n==0)begin
            recvByte(8'hD9);
            recvByte(8'h56);
            recvByte(8'h23);
            recvByte(8'hAB);
        end
        else if(n==1)begin
            recvByte(8'h00);
            recvByte(8'h83);
            recvByte(8'hD5);
            recvByte(8'h43);
        end
        recv_end();
        
        //P_RXCLK = 0;
        @(posedge P_RXCLK)
        P_RXD = 4'h0;            
        end
   endtask
   
   /*---Color_Image---*/
   /*--640x480--*/
   integer color;
   task COLOL_640();
    for(color=0;color<640;color=color+1)begin
        UDP_COLOR();
        #96;
    end
   endtask
   /*--1PIXEL--*/
   task recvPixel(input [7:0] blue, input [7:0] green, input [7:0] red);
        begin
            recvByte(blue);
            recvByte(green);
            recvByte(red);
        end
   endtask
   /*--送信--*/
   task UDP_COLOR();
    begin
        // プリアンブル
        repeat(7) recvByte(8'h55);
        recvByte(8'hd5);
        // 宛先MAC
        recvMac(48'h00_0A_35_02_0F_B0);
        // 送信元MAC
        recvMac(48'hF8_32_E4_BA_0D_57);
        //フレームタイプ
        recvByte(8'h08);
        recvByte(8'h00);
   
        /*--IP header--*/
        // Varsion / IHL
        recvByte(8'h45);

        // ToS
        recvByte(8'h00);
   
        // Total Length = 1,486 - 18 = 1468 = 16'h05_BC
        recvByte(8'h05);
        recvByte(8'hBC);
   
        // Identification
        recvByte(8'hAB);
        recvByte(8'hCD);
   
        // Flags[15:13]/Flagment Offset[12:0]
        recvByte(8'h40);
        recvByte(8'h00);
     
        // Time To Live
        recvByte(8'd255);
   
        // Protocol
        recvByte(8'h11);
   
        // Header Checksum
        recvByte(8'hCD);
        recvByte(8'h01);
   
        // SrcIP 172.31.210.129
        recvIp({8'd172, 8'd31, 8'd210, 8'd129});
   
        // DstIP 172.31.210.130
        recvIp({8'd172, 8'd31, 8'd210, 8'd160});         
   
        /*--UDPHeader--*/
        // SrcPort
        recvByte(8'hAF);
        recvByte(8'hDB);
        // DstPort
        recvByte(8'hEA);
        recvByte(8'h60);
        // UDP Len  1,440+8 = 1448 = 16'h05_A8
        recvByte(8'h05);
        recvByte(8'hA8);
        // UDP_Checksum
        recvByte(8'h00);
        recvByte(8'h00); 
        /*--UDP Data--*/    // 480[px]
        repeat(60) recvPixel(8'hAA,8'hBB,8'hCC);
        repeat(60) recvPixel(8'h00,8'hFF,8'h00);
        repeat(60) recvPixel(8'h00,8'h00,8'hFF);
        repeat(60) recvPixel(8'hBB,8'h00,8'h00);
        repeat(60) recvPixel(8'h00,8'hBB,8'h00);
        repeat(60) recvPixel(8'h00,8'h00,8'hBB);
        repeat(60) recvPixel(8'hFF,8'hAA,8'hBB);
        repeat(59) recvPixel(8'hCC,8'hDD,8'hEE);
        recvPixel(8'hAA,8'hBB,8'hCC);
           
        // CRC
       recvByte(8'h39);
       recvByte(8'hCE);
       recvByte(8'hA7);
       recvByte(8'h40);
        recv_end();
   
        //P_RXCLK = 0;
        @(posedge P_RXCLK)
        P_RXD = 4'h0;            
        end   
    endtask
   
   task UDP10000();
       begin
       /*--1パケット目--*/
       UDP_image(0);
       /*--2パケット目--*/
       #10000;
       UDP_image(0);
       /*--3パケット目--*/
       #10000;
       UDP_image(0);
       /*--4パケット目--*/
       #10000;
       UDP_image(0);
       /*--5パケット目--*/
       #10000;
       UDP_image(0);
       /*--6パケット目--*/
       #10000;
       UDP_image(0);
       /*--7パケット目--*/
       #10000;
       UDP_image(0);
       /*--8パケット目--*/
       #10000;
       UDP_image(0);  
       /*--9パケット目--*/
       #10000;
       UDP_image(0);
       /*--10パケット目--*/
       #10000;
       UDP_image(0);
       end
   endtask
   
   task recv_end();
       @(posedge P_RXCLK);
       P_RXDV = 0;
   endtask
   
   task TX_UDP();
       #10000;
       UDP_image(0);
   endtask
   
   task UDP_160();
       repeat(160) TX_UDP();
   endtask
   
endmodule
