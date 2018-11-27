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

   TOP top_i(
        .eth_rxctl(P_RXDV),
        .eth_rxck(P_RXCLK),
        .eth_rxd(P_RXD),
        .eth_txctl(P_TXEN),
        .eth_txck(P_TXCLK),
        .eth_txd(P_TXD),
        .SYSCLK(SYSCLK),
        .CPU_RSTN(CPU_RSTN),
        .reset_i(reset)
    );
    
   parameter Idle       =  8'h00;   // 待機状態
   parameter SFD_Wait   =  8'h01;   // プリアンブル検知中
   parameter Recv_Data  =  8'h02;   // データ処理
   parameter Recv_End   =  8'h03;   // 処理終了
   parameter Tx_Pre     =  8'h01;   // プリアンブル送信
   parameter Tx_Data    =  8'h02;   // データ送信
   parameter Tx_End     =  8'h03;   // 送信終了
   parameter Hcsum      =  8'h01;
   parameter Hc_End     =  8'h02;
   parameter Icsum      =  8'h03;
   parameter Ic_End     =  8'h04;
   parameter Ready      =  8'h05;
   parameter Tx_Hc      =  8'h06;
   parameter Tx_HEnd    =  8'h07;
   parameter Tx_Ic      =  8'h08;
   parameter Tx_IEnd    =  8'h09;
   parameter Tx_En      =  8'h0A;
   parameter Tx_End_p   =  8'h0B;            
   
   reg [79:0] str_st_rx;
   reg [79:0] str_st_tx;
   reg [79:0] str_st_ping;
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
         Tx_Pre: str_st_tx = "tx_pre";
         Tx_Data: str_st_tx = "tx_data";
         Tx_End: str_st_tx = "tx_end";
      endcase
   end
   
   always_comb begin
      case (top_i.R_Arbiter.ping.st)
         Idle: str_st_ping = "idle";   
         Hcsum: str_st_ping = "hcsum";
         Hc_End: str_st_ping = "hc_end";
         Icsum: str_st_ping = "icsum";
         Ic_End: str_st_ping = "ic_end";
         Ready: str_st_ping = "ready";
         Tx_Hc: str_st_ping = "tx_hc";
         Tx_HEnd: str_st_ping = "tx_hend";
         Tx_Ic: str_st_ping = "tx_ic";
         Tx_IEnd: str_st_ping = "tx_iend";
         Tx_En: str_st_ping = "tx_en";
         Tx_End_p: str_st_ping = "tx_end";
      endcase
   end
      
   initial begin
      P_RXDV = 0;
      reset = 0;
      CPU_RSTN = 1;
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
      #4;    //-- phase trimm
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
        recvIp({8'd172, 8'd31, 8'd210, 8'd130});
        /* パディング */
        for(i=0;i<18;i=i+1)begin
            recvByte(8'h00);
        end
        
        /* CRC */
        recvByte(8'h7E);
        recvByte(8'hF9);
        recvByte(8'h00);
        recvByte(8'h9A);
        P_RXDV = 0;
        
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
         recvMac(48'h00_0A_35_02_0F_B9);
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
         recvByte(8'hD0);
         recvByte(8'hA7);
         
         // Flags[15:13]/Flagment Offset[12:0]
         recvByte(8'h40);
         recvByte(8'h00);
           
         // Time To Live
         recvByte(8'h40);
         
         // Protocol
         recvByte(8'h01);
         
         // Header Checksum
         recvByte(8'h6C);
         recvByte(8'hBE);
         
         // SrcIP 172.31.210.129
         recvIp({8'd172, 8'd31, 8'd210, 8'd129});
         
         // DstIP 172.31.210.130
         recvIp({8'd172, 8'd31, 8'd210, 8'd130});
         /*--ICMP--*/
         // Type
         recvByte(8'h08);
         
         // Code
         recvByte(8'h00);
         
         // Checksum
         recvByte(8'h5B);
         recvByte(8'h02);
         
         // Identifier
         recvByte(8'h10);
         recvByte(8'h0B);
         
         // Sequence number
         recvByte(8'h00);
         recvByte(8'h18);
         
         // Data
         recvByte(8'h6E);
         recvByte(8'h9C);
         recvByte(8'h34);
         recvByte(8'h5B);
         recvByte(8'h00);
         recvByte(8'h00);
         recvByte(8'h00);
         recvByte(8'h00);
         recvByte(8'h2A);
         recvByte(8'h10);
         recvByte(8'h01);
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
         recvByte(8'h13);
         recvByte(8'h22);
         recvByte(8'h81);
         recvByte(8'hEB);
         P_RXDV = 0;
           
         //P_RXCLK = 0;
         @(posedge P_RXCLK)
         P_RXD = 4'h0;
     end

   //**
   //** receive 1 Byte via RGMII.
   //**
   task recvByte(input [7:0] c);
      begin
         @(negedge P_RXCLK) #2;
         P_RXD = c[3:0];
         P_RXDV = 1'b1;
         @(posedge P_RXCLK) #2;
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
endmodule
