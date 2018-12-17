`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/25 15:50:07
// Design Name: 
// Module Name: ping
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

module ping(
    /*---Input---*/
    eth_rxck,
    clk125,
    rst_rx,
    //RXBUF,
    pre,
    rxd,
    rx_cnt,
    arp_st,
    ping_st,
    my_MACadd,
    my_IPadd,
    //DstMAC,
    //DstIP,
    /*---Output---*/
    tx_en,
    ping_tx,
    ping_d
    );

    /*---I/O---*/
    input           eth_rxck;
    input           clk125;
    input           rst_rx;
    //input [7:0]     RXBUF [255:0];
    input           pre;
    input [7:0]     rxd;
    input [10:0]    rx_cnt;
    input           arp_st;
    input           ping_st;
    input [47:0]    my_MACadd;
    input [31:0]    my_IPadd;
    //input [47:0]    DstMAC;
    //input [31:0]    DstIP;
    
    output reg          tx_en;
    output reg          ping_tx;
    output reg [8:0]    ping_d;
    
    /*---parameter---*/
    parameter   Idle    =   8'h00;
    parameter   Presv   =   8'h01;
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
    parameter   V_I_T   =   16'h45_00;  // Version/IHL, TOS
    parameter   Protocol=   8'h01;
    parameter   ByteLen =   16'd102;
    
    /*---wire/register---*/
    (*dont_touch="true"*)reg [7:0] RXBUF [255:0];
    (*dont_touch="true"*)reg [7:0] TXBUF [255:0];
    reg rst;
    reg [47:0] DstMAC;
    reg [31:0] DstIP;
    reg [15:0] ToLen;   // Total Length
    reg [15:0] Ident;
    reg [15:0] SeqNum;
    reg [7:0] ICMP_Msg [255:0];
    
    /*---ステートマシン---*/
    (*dont_touch="true"*)reg [7:0]   st;
    reg [7:0]   nx;
    reg [10:0]  rx_cnt_i;     // データ数
    reg         Hcsum_st;
    reg         tx_end;
    reg [2:0]   end_cnt;
    (*dont_touch="true"*)reg [9:0]   csum_cnt;
    (*dont_touch="true"*)reg         csum_ok;
    reg [2:0]   err_cnt;
    //reg [2:0]   ready_cnt;
    
    always_ff @(posedge eth_rxck) begin
        if (rst_rx) st <= Idle;
        else        st <= nx;
    end
    
    always_comb begin
        nx = st;
        case(st)
            Idle : begin
                if(pre) nx = Presv;
            end
            Presv : begin
                if(arp_st)  nx = Idle;
                else if(ping_st) nx = Hcsum;
                else if(rx_cnt>255) nx = Idle;
            end
            Hcsum : begin
                if(csum_cnt==6'd20) nx = Hc_End;
            end
            Hc_End : begin 
                if(csum_ok) nx = Icsum;
                else if(err_cnt==2'b10) nx = Idle; 
            end
            Icsum : begin
                //if(csum_cnt==(rx_cnt_i-6'd38)) nx = Ic_End;
                if(csum_cnt==(ByteLen-6'd38)) nx = Ic_End;  // add 2018.11.20
            end
            Ic_End : begin
                if(csum_ok) nx = Ready;
                else if(err_cnt==2'b10) nx = Idle;
            end
            Ready : begin
                //if(ready_cnt==3'd7) nx = Tx_Hc;
                nx = Tx_Hc;
            end
            Tx_Hc : begin
                if(csum_cnt==6'd20) nx = Tx_HEnd;
            end
            Tx_HEnd : begin
                if(err_cnt==3'd7) nx = Tx_Ic;      // err_cnt==2'b01は引き伸ばすために行っているTXBUFの為でもあったが
            end                                     // 後述のTx_Dataのcsumの部分を改良したため無くても良い
            Tx_Ic : begin
                //if(csum_cnt==(rx_cnt_i-6'd38)) nx = Tx_IEnd;
                if(csum_cnt==(ByteLen-6'd38)) nx = Tx_IEnd; // add 2018.11.20
            end
            Tx_IEnd : begin
                if(err_cnt==3'd7) nx = Tx_En;      // err_cnt==2'b01は引き伸ばすために行っている上と同じ
            end
            Tx_En : begin
                if(tx_end) nx = Tx_End;
            end
            Tx_End : begin
                if(end_cnt==3'd7) nx = Idle;
            end
        endcase
    end
    
    /*---データ数/RXBUF保持---*/
    integer j;
    //always_ff @(posedge ping_st)begin
    always_ff @(posedge eth_rxck)begin
        if (st==Presv) begin
            RXBUF[rx_cnt]  <= rxd;
        end
        else if(st==Idle)begin
            for(j=0;j<256;j=j+1) RXBUF[j] <= 8'h00;
        end
    end 
    
    always_ff @(posedge eth_rxck)begin
        if(st==Hcsum)begin
            DstMAC  <= {RXBUF[6],RXBUF[7],RXBUF[8],RXBUF[9],RXBUF[10],RXBUF[11]};
            DstIP   <= {RXBUF[26],RXBUF[27],RXBUF[28],RXBUF[29]};
            ToLen   <= {RXBUF[16],RXBUF[17]};
            Ident   <= {RXBUF[38],RXBUF[39]};
            SeqNum  <= {RXBUF[40],RXBUF[41]};
        end
        else if(st==Idle)begin
            DstMAC  <= 48'b0;
            DstIP   <= 32'b0;
            ToLen   <= 16'b0;
            Ident   <= 16'b0;
            SeqNum  <= 16'b0;
        end
    end
    
    integer msg_cnt;
    always_ff @(posedge eth_rxck)begin
        if(st==Hcsum)begin
            for(msg_cnt=0;msg_cnt<(256-46);msg_cnt=msg_cnt+1) ICMP_Msg[msg_cnt] <= RXBUF[msg_cnt+42];
        end
        else if(st==Idle) begin
            for(msg_cnt=0;msg_cnt<256;msg_cnt=msg_cnt+1) ICMP_Msg[msg_cnt] <= 8'b0;
        end
    end
    
    always_ff @(posedge eth_rxck)begin
        if(st==Presv)begin
            rx_cnt_i <= rx_cnt;
        end
        else if(st==Idle)begin
            rx_cnt_i <= 0;
        end
    end
    
    /*---リセット信号---*/
    always_ff @(posedge eth_rxck)begin
        if(st==Idle)    rst <= 1;
        else            rst <= 0;
    end
    
    /*---チェックサム用データ---*/
    reg [7:0]       data;
    reg             data_en;
    (*dont_touch="true"*)reg [15:0]      csum;
    
    always_ff @(posedge eth_rxck)begin         
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
    always_ff @(posedge eth_rxck)begin    // 最初の14bitはMACヘッダ
        if(st==Hcsum)       data <= RXBUF[csum_cnt+ip_head];
        else if(st==Icsum)  data <= RXBUF[csum_cnt+icmp];
        else if(st==Tx_Hc)  data <= TXBUF[csum_cnt+ip_head];
        else if(st==Tx_Ic)  data <= TXBUF[csum_cnt+icmp];
        else                data <= 0;
    end
    
    /*---チェックサム計算開始用---*/
    always_ff @(posedge eth_rxck)begin
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
    always_ff @(posedge eth_rxck)begin
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
    always_ff @(posedge eth_rxck)begin
        tx_cnt <= rx_cnt_i;
    end

    /*---Ready Extend---*/
    /*
    always_ff @(posedge eth_rxck)begin
        if(st==Ready)begin
            ready_cnt <= ready_cnt + 1;
        end
        else begin
            ready_cnt <= 0;
        end
    end

    reg ready_rxck;                
    always_ff @(posedge eth_rxck)begin
        if(ready_cnt>=1&&ready_cnt<=3)begin
            ready_rxck <= 1;
        end
        else begin
            ready_rxck <= 0;
        end
    end
    */
    
    /*
    reg ready_clk125;
    reg ready_clk125_d;
     always_ff @(posedge clk125)begin
        ready_clk125_d <= ready_rxck;
        ready_clk125 <= ready_clk125_d;
    end
    */
    
    /*---tx_Hcend Extend---*/
    /*
    reg tx_hend_rxck;      
    reg tx_iend_rxck;  
    always_ff @(posedge eth_rxck)begin
        if(st==Tx_HEnd) begin
            if(err_cnt>=1&&err_cnt<=3)   tx_hend_rxck <= 1;
            else                         tx_hend_rxck <= 0;
        end 
        else if(st==Tx_IEnd)begin
            if(err_cnt>=1&&err_cnt<=3)   tx_iend_rxck <= 1;
            else                         tx_iend_rxck <= 0;
        end
        else begin
            tx_hend_rxck <= 0;
            tx_iend_rxck <= 0;
        end
    end
    */
    
    /*
    reg tx_hend_clk125;
    reg tx_hend_clk125_d;
    reg tx_iend_clk125;
    reg tx_iend_clk125_d;
    always_ff @(posedge clk125)begin
        tx_hend_clk125_d <= tx_hend_rxck;
        tx_hend_clk125 <= tx_hend_clk125_d;
        tx_iend_clk125_d <= tx_iend_rxck;
        tx_iend_clk125 <= tx_iend_clk125_d;
    end  
    */
    
    reg [15:0] csum_extend;
    always_ff @(posedge eth_rxck)begin 
       if(st==Tx_HEnd) begin
           if(err_cnt==2'b01) csum_extend <= csum;
       end
       else if(st==Tx_IEnd)begin
           if(err_cnt==2'b01) csum_extend <= csum;
       end
       else csum_extend <= 16'h5555;  // dummy value.
    end
    
    /*---送信用データ---*/
    integer i;
    //always_ff @(posedge clk125)begin
    always_ff @(posedge eth_rxck)begin
        //if(ready_clk125)begin
        if(st==Ready)begin
            {TXBUF[0],TXBUF[1],TXBUF[2],TXBUF[3],TXBUF[4],TXBUF[5]} <= DstMAC;
            //{TXBUF[6],TXBUF[7],TXBUF[8],TXBUF[9],TXBUF[10],TXBUF[11]} <= `my_MAC;
            {TXBUF[6],TXBUF[7],TXBUF[8],TXBUF[9],TXBUF[10],TXBUF[11]} <= my_MACadd;     // add 2018.12.5
            {TXBUF[12],TXBUF[13]} <= FTYPE;
            {TXBUF[14],TXBUF[15]} <= V_I_T;         // Version/IHL, TOS
            {TXBUF[16],TXBUF[17]} <= ToLen;         // Total Length         
            {TXBUF[18],TXBUF[19]} <= 16'hAB_CD;     // Identification
            {TXBUF[20],TXBUF[21]} <= 16'h40_00;     // Flags[15:13] ,Flagment Offset[12:0]
            TXBUF[22] <= TTL;                       // Time To Live
            //TXBUF[23] <= RXBUF[23];                 // Protocol ICMP=1
            TXBUF[23] <= Protocol;                 // Protocol ICMP=1
            {TXBUF[24],TXBUF[25]} <= 16'h00_00;     // Header Checksum
            //{TXBUF[26],TXBUF[27],TXBUF[28],TXBUF[29]} <= `my_IP;
            {TXBUF[26],TXBUF[27],TXBUF[28],TXBUF[29]} <= my_IPadd;                      // add 2018.12.5
            {TXBUF[30],TXBUF[31],TXBUF[32],TXBUF[33]} <= DstIP;
            {TXBUF[34],TXBUF[35]} <= 16'h00_00;     // Echo Reply = {Type=8'h00,Code=8'h00}
            {TXBUF[36],TXBUF[37]} <= 16'h00_00;     // ICMP Checksum      
            //TXBUF[39:38] <= RXBUF[39:38];         // Identifier
            {TXBUF[38],TXBUF[39]} <= Ident;
            //TXBUF[41:40] <= RXBUF[41:40];         // Sequence number
            {TXBUF[40],TXBUF[41]} <= SeqNum;
            /*--Random Data--*/
            for(i=0;i<(ByteLen-6'd46);i=i+1)begin
                //TXBUF[6'd42+i] <= RXBUF[6'd42+i];
                //TXBUF[6'd42+i] <= ICMP_Msg[i];
                TXBUF[6'd42+i] <= i;
            end
            //{TXBUF[rx_cnt_i-1],TXBUF[rx_cnt_i-2],TXBUF[rx_cnt_i-3],TXBUF[rx_cnt_i-4]} <= 32'h01_02_03_04;
            {TXBUF[ByteLen-4],TXBUF[ByteLen-3],TXBUF[ByteLen-2],TXBUF[ByteLen-1]} <= 32'h01_02_03_04;   // dummy
            //Hcsum_st <= 1;
        end
        //else if(tx_hend_clk125) {TXBUF[24],TXBUF[25]} <= csum_extend; // err_cnt==2'b01はTXBUFの中身が
        else if(st==Tx_HEnd) {TXBUF[24],TXBUF[25]} <= csum_extend;
        //else if(tx_iend_clk125) {TXBUF[36],TXBUF[37]} <= csum_extend; // 1回のみ変わるためにつけている
        else if(st==Tx_IEnd) {TXBUF[36],TXBUF[37]} <= csum_extend;
        /*
        else if(st==Idle)begin   //-- Leave as is.
            for(i=0;i<9'd256;i=i+1) TXBUF[i] <= 0;
            Hcsum_st <= 0;
        end
        */
        else TXBUF <= TXBUF; 
    end
    
    
    /*---Header Checksum Error---*/
    always_ff @(posedge eth_rxck)begin
        if(st==Hc_End)          err_cnt <= err_cnt + 3'b1;
        else if(st==Ic_End)     err_cnt <= err_cnt + 3'b1;
        else if(st==Tx_HEnd)    err_cnt <= err_cnt + 3'b1;
        else if(st==Tx_IEnd)    err_cnt <= err_cnt + 3'b1;
        else                    err_cnt <= 0;
    end
    
    always_ff @(posedge eth_rxck)begin
        if(st==Tx_End)begin
            end_cnt <= end_cnt + 1'b1;
        end
        else begin
            end_cnt <= 1'b0;
        end
    end
    
    checksum checksum(
        .clk_i(eth_rxck),
        .d(data),
        .data_en(data_en),
        .csum_o(csum),
        .rst(rst)
    );

    /*
    reg tx_en_clk125;
    reg tx_en_clk125_d;
    always_ff @(posedge clk125) begin
       tx_en_clk125_d <= tx_en;
       tx_en_clk125 <= tx_en_clk125_d; 
    end
    */
    
    reg [7:0] clk_cnt;
    //always_ff @(posedge clk125)begin
    always_ff @(posedge eth_rxck)begin
        if(st==Tx_En)begin
        //if (tx_en_clk125) begin
            clk_cnt <= clk_cnt + 1;
            //if(clk_cnt==rx_cnt_i) tx_end <= 1;
            if(clk_cnt==tx_cnt) tx_end <= 1; 
        end
        else begin
            clk_cnt <= 0;
            tx_end <= 0;
        end
    end
    
    reg [2:0] fcs_cnt;
    //always_ff @(posedge clk125)begin
    always_ff @(posedge eth_rxck)begin
        if(st==Tx_En&&clk_cnt<(rx_cnt_i-3'd4))begin
        //if(tx_en_clk125&&clk_cnt<(tx_cnt-3'd4))begin
            ping_d <= {1'b1,TXBUF[clk_cnt]};
            ping_tx <= 1;
        end
        else if(st==Tx_En&&fcs_cnt!=3'b100)begin
        //else if(tx_en_clk125&&fcs_cnt!=3'b100)begin
            ping_d <= {1'b0,TXBUF[clk_cnt]};
            fcs_cnt <= fcs_cnt + 1;
        end
        else if(st==Tx_En&&fcs_cnt==3'b100)begin
        //else if(tx_en_clk125&&fcs_cnt==3'b100)begin
            ping_tx <= 0;
        end
        else begin
            ping_tx <= 0;
            ping_d <= 0;
            fcs_cnt <= 0;
        end
    end
    
    always_ff @(posedge clk125)begin
        if(st==Tx_En)   tx_en <= 1'b1;
        else            tx_en <= 1'b0;
    end
    
endmodule
