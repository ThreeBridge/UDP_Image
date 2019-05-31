`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/14 16:20:12
// Design Name: 
// Module Name: UDP
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


module UDP(
    /*---Input---*/
    clk125,     // 125MHz
    rst_rx,
    BTN_C,      // UDPパケット送信のため
    /*---Output---*/
    UDP_d,
    UDP_tx
    );
    
    /*---I/O Declare---*/
    input           clk125;
    input           rst_rx;
    input           BTN_C;
    
    output reg [8:0]    UDP_d;
    output reg          UDP_tx;
    
    /*---parameter---*/
    parameter   Idle    =   8'h00;
    parameter   IP_cs   =   8'h01;
    parameter   IP_End  =   8'h02;
    parameter   UDP_cs  =   8'h03;
    parameter   UDP_End =   8'h04;
    parameter   Ready   =   8'h05;
    parameter   TX_En   =   8'h06;
    parameter   TX_End  =   8'h07;
    
    parameter   DstMAC  =   48'hF8_32_E4_BA_0D_57;
    parameter   DstIP   =   {8'd172,8'd31,8'd210,8'd129};
    parameter   FTYPE   =   16'h08_00;
    parameter   TTL     =   8'd255;
    
    parameter   eth_hd  =   4'd14;
    
    /*---register---*/
    /*-送信用バッファ-*/
    reg [7:0]   TXBUF [69:0];
    reg [7:0]   VBUF  [43:0];
    
    /*-チェックサム用-*/
    reg [9:0]   csum_cnt;
    reg         rst;
    reg [7:0]   data;
    reg [15:0]  csum;
    reg         data_en;
    reg [1:0]   err_cnt;
    
    /*---ステートマシン---*/
    reg [3:0] st;                    //state machine
    reg [3:0] nx;                    //next;
    reg tx_ready;
    reg tx_end;
    always_ff @(posedge clk125) begin
            if (rst_rx) st <= Idle;
            else        st <= nx;
    end
    
    always_comb begin
        nx = st;
        case(st)
            Idle : begin
                if(tx_ready) nx = IP_cs;
            end
            IP_cs : begin
                if(csum_cnt==10'd20) nx = IP_End;
            end
            IP_End : begin
                if(err_cnt==2'b10) nx = UDP_cs;
            end
            UDP_cs : begin
                if(csum_cnt==10'd44) nx = UDP_End;
            end
            UDP_End : begin
                if(err_cnt==2'b10) nx = Ready;
            end
            Ready : begin
                if(BTN_C) nx = TX_En;
            end
            TX_En : begin
                if(tx_end) nx = TX_End;
            end
            TX_End : begin
                nx = Idle;
            end
            default : begin end
        endcase
    end
    
    /*---リセット信号---*/
    always_ff @(posedge clk125)begin
        if(st==Idle)    rst <= 1;
        else            rst <= 0;
    end    
    
    /*---Header Checksum Error---*/
    always_ff @(posedge clk125)begin
        if(st==IP_End)          err_cnt <= err_cnt + 2'b01;
        else if(st==UDP_End)    err_cnt <= err_cnt + 2'b01;
        else                    err_cnt <= 0;
    end    
    
    /*---チェックサム用データ---*/
    always_ff @(posedge clk125)begin         
        if(st==Idle)                csum_cnt <= 0;
        else if(st==IP_cs)begin
            if(csum_cnt==10'd20)    csum_cnt <= 0;
            else                    csum_cnt <= csum_cnt + 1;
        end
        else if(st==UDP_cs)begin
            if(csum_cnt==10'd44)    csum_cnt <= 0;
            else                    csum_cnt <= csum_cnt + 1;
        end
        else                        csum_cnt <= 0;
    end 
    
    always_ff @(posedge clk125)begin
        if(st==IP_cs)       data <= TXBUF[csum_cnt+eth_hd];
        else if(st==UDP_cs) data <= VBUF[csum_cnt];
        else                data <= 0;
    end
    
    always_ff @(posedge clk125)begin
        if(st==IP_cs)begin
            if(csum_cnt!=10'd20) data_en <= 1;
            else                 data_en <= 0;
        end
        else if(st==UDP_cs)begin
            if(csum_cnt!=10'd44)
                                 data_en <= 1;
            else                 data_en <= 0;
        end
        else if(st==Idle)        data_en <= 0;
        else                     data_en <= 0;
    end    
        
    /*---UDPパケット準備---*/
    integer i;
    always_ff @(posedge clk125)begin
        if(st==Idle)begin
            /*-イーサネットヘッダ-*/
            {TXBUF[0],TXBUF[1],TXBUF[2],TXBUF[3],TXBUF[4],TXBUF[5]} <= DstMAC;
            {TXBUF[6],TXBUF[7],TXBUF[8],TXBUF[9],TXBUF[10],TXBUF[11]} <= `my_MAC;
            {TXBUF[12],TXBUF[13]} <= FTYPE;
            /*-IPヘッダ-*/
            TXBUF[14] <= 8'h45;                             // Version/IHL
            TXBUF[15] <= 8'h00;                             // ToS
            {TXBUF[16],TXBUF[17]} <= 16'd52;                // Total Length(16'd52==IPヘッダ(20)+その下)
            {TXBUF[18],TXBUF[19]} <= 16'hAB_CD;             // Identification
            {TXBUF[20],TXBUF[21]} <= {3'b010,13'd0};        // Flags[15:13] ,Flagment Offset[12:0]
            TXBUF[22] <= TTL;                               // Time To Live
            TXBUF[23] <= 8'h11;                             // Protocol
            {TXBUF[24],TXBUF[25]} <= 16'h00_00;             // IP Checksum
            {TXBUF[26],TXBUF[27],TXBUF[28],TXBUF[29]} <= `my_IP;
            {TXBUF[30],TXBUF[31],TXBUF[32],TXBUF[33]} <= DstIP;
            /*-UDPヘッダ-*/
            {TXBUF[34],TXBUF[35]} <= 16'd60000;             // 発信元ポート番号
            {TXBUF[36],TXBUF[37]} <= 16'd60000;             // 宛先ポート番号   
            {TXBUF[38],TXBUF[39]} <= 16'd32;                // UDPデータ長 UDPヘッダ(8バイト)+UDPデータ
            {TXBUF[40],TXBUF[41]} <= 16'h00_00;             // UDP Checksum (仮想ヘッダ+UDP)
            /*-UDPデータ(24バイト)-*/
            for(i=0;i<24;i=i+1)begin
                TXBUF[6'd42+i] <= i;
            end
            {TXBUF[66],TXBUF[67],TXBUF[68],TXBUF[69]} <= 32'h00_00_00_00;
            tx_ready <= 1;
        end
        else if(st==IP_End&&err_cnt==2'b01)     {TXBUF[24],TXBUF[25]} <= csum;
        //else if(st==UDP_End&&err_cnt==2'b01)    {TXBUF[40],TXBUF[41]} <= csum;
        else if(st==Ready) tx_ready <= 0;
    end
    
    /*---仮想ヘッダ準備---*/
    always_ff @(posedge clk125)begin
        if(st==IP_End)begin
            {VBUF[0],VBUF[1],VBUF[2],VBUF[3]} <= `my_IP;
            {VBUF[4],VBUF[5],VBUF[6],VBUF[7]} <= DstIP;
            {VBUF[8],VBUF[9]} <= 16'h00_11;
            VBUF[11:10] <= TXBUF[39:38];
            VBUF[43:12] <= TXBUF[65:34];
        end
    end
    
    checksum udp_checksum(
        .clk_i(clk125),
        .d(data),
        .data_en(data_en),
        .csum_o(csum),
        .rst(rst)
    );
    
    reg [7:0] clk_cnt;
    always_ff @(posedge clk125)begin
        if(st==TX_En)begin
            clk_cnt <= clk_cnt + 1;
            if(clk_cnt==8'd70) tx_end <= 1; 
        end
        else if(st==Idle)begin
            clk_cnt <= 0;
            tx_end <= 0;
        end
    end
    
    reg [1:0] fcs_cnt;
    always_ff @(posedge clk125)begin
        if(st==TX_En&&clk_cnt<(8'd70-3'd4))begin
            UDP_d <= {1'b1,TXBUF[clk_cnt]};
            UDP_tx <= 1;
        end
        else if(st==TX_En&&fcs_cnt!=2'b11)begin
            UDP_d <= {1'b0,TXBUF[clk_cnt]};
            fcs_cnt <= fcs_cnt + 1;
        end
        else if(st==TX_En&&fcs_cnt==2'b11)begin
            UDP_tx <= 0;
        end
        else begin
            UDP_tx <= 0;
            UDP_d <= 0;
            fcs_cnt <= 0;
        end
    end    
    
endmodule
