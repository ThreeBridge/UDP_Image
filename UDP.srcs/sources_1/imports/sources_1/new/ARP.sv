`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/04 19:12:18
// Design Name: 
// Module Name: ARP
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

module ARP(
    input clk125,
    input rst125,
    input arp_st,
    input [47:0] DstMAC,
    input [31:0] DstIP,
    
    output reg arp_tx,
    output reg [8:0] d
    );
    
    parameter Idle      =  4'h00;   // 待機
    parameter Tx_Ready  =  4'h01;   // 送信準備
    parameter Tx        =  4'h02;   // 送信中
    parameter Tx_End    =  4'h03;   // 送信終了
    
    /* ステートマシン */
    reg [3:0] st;                    //state machine
    reg [3:0] nx;                    //next;
    reg start_tx;
    reg tx_end;
    always_ff @(posedge clk125) begin
            if (rst125) st <= Idle;
            else        st <= nx;
    end
    
    always_comb begin
        nx = st;
        case(st)
            Idle : if(arp_st) nx = Tx_Ready;
            Tx_Ready : if(start_tx) nx = Tx;
            Tx : if(tx_end) nx = Tx_End;
            Tx_End : nx = Idle;
            default : begin end
        endcase
    end
    
    /* パケット準備 */
    parameter FTYPE = 16'h08_06;                               // フレームタイプ(ARP=16'h08_06)
    parameter HTYPE = 16'h00_01;                               // ハードウェアタイプ(Erthernet=1)
    parameter PTYPE = 16'h08_00;                               // プロトコルタイプ(IPv4==0800以降)
    parameter HLEN = 8'h06;                                    // ハードウェア長=6
    parameter PLEN = 8'h04;                                    // プロトコル長=4
    parameter OPER = 16'h00_02;                                // オペレーション(要求=1,返信=2)
    
    reg [7:0] TXBUF [63:0];
    integer i;
    always_ff @(posedge clk125)begin
        if(st==Tx_Ready)begin
            {TXBUF[0],TXBUF[1],TXBUF[2],TXBUF[3],TXBUF[4],TXBUF[5]} <= DstMAC;
            {TXBUF[6],TXBUF[7],TXBUF[8],TXBUF[9],TXBUF[10],TXBUF[11]} <= `my_MAC;
            {TXBUF[12],TXBUF[13]} <= FTYPE;
            {TXBUF[14],TXBUF[15]} <= HTYPE;
            {TXBUF[16],TXBUF[17]} <= PTYPE;
            {TXBUF[18],TXBUF[19]} <= {HLEN,PLEN};
            {TXBUF[20],TXBUF[21]} <= OPER;
            {TXBUF[22],TXBUF[23],TXBUF[24],TXBUF[25],TXBUF[26],TXBUF[27]} <= `my_MAC;
            {TXBUF[28],TXBUF[29],TXBUF[30],TXBUF[31]} <= `my_IP;
            {TXBUF[32],TXBUF[33],TXBUF[34],TXBUF[35],TXBUF[36],TXBUF[37]} <= DstMAC;
            {TXBUF[38],TXBUF[39],TXBUF[40],TXBUF[41]} <= DstIP;
            for(i=42;i<60;i=i+1)begin
               TXBUF[i] <= 0;
            end
            start_tx <= 1;
        end
        else if(st==Tx_End) start_tx <= 0;
        else if(st==Idle) begin
            for(i=0;i<8'd64;i=i+1) TXBUF[i] <= 0;
            start_tx <= 0;
        end
    end
    
    reg [6:0] clk_cnt;
    always_ff @(posedge clk125)begin
        if(st==Tx)begin
            clk_cnt <= clk_cnt + 1;
            if(clk_cnt==7'd63) tx_end <= 1; 
        end
        else if(st==Idle)begin
            clk_cnt <= 0;
            tx_end <= 0;
        end
    end
    
    reg [1:0] fcs_cnt;
    always_ff @(posedge clk125)begin
        if(st==Tx&&clk_cnt<7'd60)begin
            d <= {1'b1,TXBUF[clk_cnt]};
            arp_tx <= 1;
        end
        else if(st==Tx&&fcs_cnt!=2'b11)begin
            d <= {1'b0,TXBUF[clk_cnt]};
            fcs_cnt <= fcs_cnt + 1;
        end
        else if(st==Tx&&fcs_cnt==2'b11)begin
            arp_tx <= 0;
        end
        else begin
            arp_tx <= 0;
            d <= 0;
            fcs_cnt <= 0;
        end
    end
    
endmodule
