`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/03 15:00:56
// Design Name: 
// Module Name: recv_ping
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


module recv_ping(
    eth_rxck,
    clk125,
    rst_rx,
    ping_st,
    
    ping_tx,
    ping_d
    );

    /*---I/O---*/
    input           eth_rxck;
    input           clk125;
    input           rst_rx;
    input           ping_st;
    
    output reg          ping_tx;
    output reg [8:0]    ping_d;
    
    /*---parameter---*/
    parameter   Idle    =   8'h00;
    parameter   Recv    =   8'h01;
    parameter   Hcsum   =   8'h02;
    parameter   Hc_End  =   8'h03;
    parameter   Icsum   =   8'h04;
    parameter   Ic_End  =   8'h05;
    parameter   Ready   =   8'h06;
    parameter   Tx_Hc   =   8'h07;
    parameter   Tx_HEnd =   8'h08;
    parameter   Tx_Ic   =   8'h09;
    parameter   Tx_IEnd =   8'h0A;
    parameter   Tx_En   =   8'h0B;
    parameter   Tx_End  =   8'h0C; 
    
    parameter   TTL     =   16'd255;
    parameter   ip_head =   4'd14;
    parameter   icmp    =   6'd34;
    parameter   FTYPE   =   16'h08_00;
    
    /*---wire/register---*/
    reg [7:0] RXBUF [102:0];
    reg [7:0] TXBUF [255:0];
    reg [9:0] rx_cnt;
    reg rst;
    reg [47:0] DstMAC;
    reg [31:0] DstIP;
    
    /*---ステートマシン---*/
    (*dont_touch="true"*)reg [7:0]   st;
    reg [7:0]   nx;
    reg [9:0]   rx_cnt_i;     // データ数
    reg [7:0]   RXBUF_i [255:0];
    reg         Hcsum_st;
    reg         tx_en;
    reg         tx_end;
    (*dont_touch="true"*)reg [9:0]   csum_cnt;
    (*dont_touch="true"*)reg         csum_ok;
    reg [1:0]   err_cnt;
    
    always_ff @(posedge clk125) begin
        if (rst_rx) st <= Idle;
        else        st <= nx;
    end
    
    always_comb begin
        nx = st;
        case(st)
            Idle : begin
                if(ping_st) nx = Hcsum;
            end
            Hcsum : begin
                if(csum_cnt==6'd20) nx = Hc_End;
            end
            Hc_End : begin 
                if(csum_ok) nx = Icsum;
                else if(err_cnt==2'b10) nx = Idle; 
            end
            Icsum : begin
                if(csum_cnt==(rx_cnt_i-6'd38)) nx = Ic_End;
            end
            Ic_End : begin
                if(csum_ok) nx = Ready;
                else if(err_cnt==2'b10) nx = Idle;
            end
            Ready : begin
                if(Hcsum_st) nx = Tx_Hc;
            end
            Tx_Hc : begin
                if(csum_cnt==6'd20) nx = Tx_HEnd;
            end
            Tx_HEnd : begin
                if(err_cnt==2'b01) nx = Tx_Ic;      // err_cnt==2'b01は引き伸ばすために行っているTXBUFの為でもあったが
            end                                     // 後述のTx_Dataのcsumの部分を改良したため無くても良い
            Tx_Ic : begin
                if(csum_cnt==(rx_cnt_i-6'd38)) nx = Tx_IEnd;
            end
            Tx_IEnd : begin
                if(err_cnt==2'b01) nx = Tx_En;      // err_cnt==2'b01は引き伸ばすために行っている上と同じ
            end
            Tx_En : begin
                if(tx_end) nx = Tx_End;
            end
            Tx_End : begin nx = Idle;
            end
        endcase
    end
    
    /*---データ数/RXBUF保持---*/
    integer j;
    //always_ff @(posedge ping_st)begin
    always_ff @(posedge clk125)begin
        if (ping_st) begin
            rx_cnt_i <= rx_cnt;
            RXBUF_i  <= RXBUF;
        end
        else if(st==Idle)begin
            rx_cnt_i <= 10'b0;
            for(j=0;j<256;j=j+1) RXBUF_i[j] <= 8'h00;
        end
    end 
    
    always_ff @(posedge clk125)begin
        if(ping_st)begin
            DstMAC  <= {RXBUF[6],RXBUF[7],RXBUF[8],RXBUF[9],RXBUF[10],RXBUF[11]};
            DstIP   <= {RXBUF[26],RXBUF[27],RXBUF[28],RXBUF[29]};
        end
        else if(st==Idle)begin
            DstMAC  <= 48'b0;
            DstIP   <= 32'b0;
        end
    end
    
    /*---リセット信号---*/
    always_ff @(posedge clk125)begin
        if(st==Idle)    rst <= 1;
        else            rst <= 0;
    end
    
    /*---チェックサム用データ---*/
    reg [7:0]       data;
    reg             data_en;
    (*dont_touch="true"*)reg [15:0]      csum;
    
    always_ff @(posedge clk125)begin         
        if(st==Idle)                       csum_cnt <= 0;
        else if(st==Hcsum)begin
            if(csum_cnt==6'd20)            csum_cnt <= 0;
            else                           csum_cnt <= csum_cnt + 1;
        end
        else if(st==Icsum)begin
            if(csum_cnt==(rx_cnt_i-6'd38)) csum_cnt <= 0;
            else                           csum_cnt <= csum_cnt + 1;
        end
        else if(st==Tx_Hc)begin
            if(csum_cnt==6'd20)            csum_cnt <= 0;
            else                           csum_cnt <= csum_cnt + 1;
        end
        else if(st==Tx_Ic)begin
            if(csum_cnt==(rx_cnt_i-6'd38)) csum_cnt <= 0;
            else                           csum_cnt <= csum_cnt + 1;
        end
        else                               csum_cnt <= 0; 
    end
    
    /*---チェックサム用データ---*/
    always_ff @(posedge clk125)begin    // 最初の14bitはMACヘッダ
        if(st==Hcsum)       data <= RXBUF_i[csum_cnt+ip_head];
        else if(st==Icsum)  data <= RXBUF_i[csum_cnt+icmp];
        else if(st==Tx_Hc)  data <= TXBUF[csum_cnt+ip_head];
        else if(st==Tx_Ic)  data <= TXBUF[csum_cnt+icmp];
        else                data <= 0;
    end
    
    /*---チェックサム計算開始用---*/
    always_ff @(posedge clk125)begin
        if(st==Hcsum)begin
            if(csum_cnt!=6'd20) data_en <= 1;
            else                data_en <= 0;
        end
        else if(st==Icsum)begin
            if(csum_cnt!=(rx_cnt_i-6'd38))
                                data_en <= 1;
            else                data_en <= 0;
        end
        else if(st==Tx_Hc)begin
            if(csum_cnt!=6'd20) data_en <= 1;
            else                data_en <= 0;
        end
        else if(st==Tx_Ic)begin
            if(csum_cnt!=(rx_cnt_i-6'd38))
                                data_en <= 1;
            else                data_en <= 0;
        end
        else if(st==Idle)       data_en <= 0;
        else                    data_en <= 0;
    end
    
    /*---Checksum OK---*/
    always_ff @(posedge clk125)begin
        if(st==Hc_End)begin
            if(csum==16'h00_00) csum_ok <= 1;
            else                csum_ok <= 0;
        end
        else if(st==Ic_End)begin
            if(csum==16'h00_00) csum_ok <= 1;
            else                csum_ok <= 0;
        end
        else                    csum_ok <= 0;
    end
    
    /*---Tx_Data Ready---*/
    reg [9:0] tx_cnt;
    always_ff @(posedge clk125)begin
        if(st==Idle)    tx_cnt <= 0;
        else            tx_cnt <= rx_cnt_i;
    end
    
    integer i;
    always_ff @(posedge clk125)begin
        if(st==Ready)begin
            {TXBUF[0],TXBUF[1],TXBUF[2],TXBUF[3],TXBUF[4],TXBUF[5]} <= DstMAC;
            {TXBUF[6],TXBUF[7],TXBUF[8],TXBUF[9],TXBUF[10],TXBUF[11]} <= `my_MAC;
            {TXBUF[12],TXBUF[13]} <= FTYPE;       
            TXBUF[17:14] <= RXBUF_i[17:14];
            {TXBUF[18],TXBUF[19]} <= 16'hAB_CD;     // Identification
            {TXBUF[20],TXBUF[21]} <= 16'h40_00;     // Flags[15:13] ,Flagment Offset[12:0]
            TXBUF[22] <= TTL;                       // Time To Live
            TXBUF[23] <= RXBUF_i[23];               // Protocol ICMP=1
            {TXBUF[24],TXBUF[25]} <= 16'h00_00;     // Header Checksum
            {TXBUF[26],TXBUF[27],TXBUF[28],TXBUF[29]} <= `my_IP;
            {TXBUF[30],TXBUF[31],TXBUF[32],TXBUF[33]} <= DstIP;
            {TXBUF[34],TXBUF[35]} <= 16'h00_00;     // Echo Reply = {Type=8'h00,Code=8'h00}
            {TXBUF[36],TXBUF[37]} <= 16'h00_00;     // ICMP Checksum      
            TXBUF[39:38] <= RXBUF_i[39:38];         // Identifier
            TXBUF[41:40] <= RXBUF_i[41:40];         // Sequence number
            /*--Random Data--*/
            for(i=0;i<(tx_cnt-6'd46);i=i+1)begin
                TXBUF[6'd42+i] <= RXBUF_i[6'd42+i];
            end
            {TXBUF[tx_cnt-1],TXBUF[tx_cnt-2],TXBUF[tx_cnt-3],TXBUF[tx_cnt-4]} <= 32'h00_00_00_00;
            Hcsum_st <= 1;
        end
        else if(st==Tx_HEnd&&err_cnt==2'b01) {TXBUF[24],TXBUF[25]} <= csum; // err_cnt==2'b01はTXBUFの中身が
        else if(st==Tx_IEnd&&err_cnt==2'b01) {TXBUF[36],TXBUF[37]} <= csum; // 1回のみ変わるためにつけている
        else if(st==Idle)begin
            for(i=0;i<9'd256;i=i+1) TXBUF[i] <= 0;
            Hcsum_st <= 0;
        end
        else TXBUF <= TXBUF; 
    end
    
    
    /*---Header Checksum Error---*/
    always_ff @(posedge clk125)begin
        if(st==Hc_End)          err_cnt <= err_cnt + 2'b01;
        else if(st==Ic_End)     err_cnt <= err_cnt + 2'b01;
        else if(st==Tx_HEnd)    err_cnt <= err_cnt + 2'b01;
        else if(st==Tx_IEnd)    err_cnt <= err_cnt + 2'b01;
        else                    err_cnt <= 0;
    end
    
    checksum checksum(
        .clk_i(clk125),
        .d(data),
        .data_en(data_en),
        .csum_o(csum),
        .rst(rst)
    );
    
    reg [7:0] clk_cnt;
    always_ff @(posedge clk125)begin
        if(st==Tx_En)begin
            clk_cnt <= clk_cnt + 1;
            if(clk_cnt==tx_cnt) tx_end <= 1; 
        end
        else if(st==Idle)begin
            clk_cnt <= 0;
            tx_end <= 0;
        end
    end
    
    reg [1:0] fcs_cnt;
    always_ff @(posedge clk125)begin
        if(st==Tx_En&&clk_cnt<(tx_cnt-3'd4))begin
            ping_d <= {1'b1,TXBUF[clk_cnt]};
            ping_tx <= 1;
        end
        else if(st==Tx_En&&fcs_cnt!=2'b11)begin
            ping_d <= {1'b0,TXBUF[clk_cnt]};
            fcs_cnt <= fcs_cnt + 1;
        end
        else if(st==Tx_En&&fcs_cnt==2'b11)begin
            ping_tx <= 0;
        end
        else begin
            ping_tx <= 0;
            ping_d <= 0;
            fcs_cnt <= 0;
        end
    end
    
endmodule