`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/22 16:07:38
// Design Name: 
// Module Name: UDP_reply
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


module UDP_reply(
    /*---Input---*/
    clk125,
    rst_rx,
    RXBUF,
    rx_cnt,
    UDP_st,
    /*---Output---*/
    UDP_tx,
    UDP_d
    );
    /*---UDP_reply.sv---*/
    /*
    UDPデータの長さは固定
    最小は22バイト
    送信される文字列は24バイトで固定
    */
    
    /*---I/O Declare---*/
    input           clk125;
    input           rst_rx;
    input [7:0]     RXBUF [1045:0];
    input [10:0]    rx_cnt;
    input           UDP_st;
    
    output reg          UDP_tx;
    output reg [8:0]    UDP_d;
    
    /*---parameter---*/
    parameter   Idle    =   8'h00;
    parameter   Hcsum   =   8'h01;
    parameter   Hc_End  =   8'h02;
    parameter   Ucsum   =   8'h03;
    parameter   Uc_End  =   8'h04;
    parameter   Ready   =   8'h05;
    parameter   Tx_Hc   =   8'h06;
    parameter   Tx_HEnd =   8'h07;
    parameter   Tx_Uc   =   8'h08;
    parameter   Tx_UEnd =   8'h09;
    parameter   Tx_En   =   8'h0A;
    parameter   Tx_End  =   8'h0B;
    parameter   st_que  =   8'h0C;
    parameter   Select  =   8'h0D;
    
    parameter   eth_head =  4'd14;
    parameter   udp     =   6'd34;
    parameter   FTYPE   =   16'h08_00;
    
     /*---wire/register---*/
    reg [7:0] TXBUF [1045:0];
    reg [7:0] VBUF  [1019:0];
    reg rst;
    reg [47:0] DstMAC;
    reg [31:0] DstIP;
    reg [7:0] TTL;
    reg [15:0] MsgSize;
    reg [9:0] UDP_cnt;  // 固定長のUDPデータ用カウント
    
    /*---ステートマシン---*/
    (*dont_touch="true"*)reg [7:0]   st;
    reg [7:0]   nx;
    reg [10:0]  rx_cnt_i;     // データ数
    reg [7:0]   RXBUF_i [1045:0];
    reg         Hcsum_st;
    reg         tx_en;
    reg         tx_end;
    (*dont_touch="true"*)reg [9:0]   csum_cnt;
    (*dont_touch="true"*)reg         csum_ok;
    reg [2:0]   err_cnt;
    reg [4:0]   packet_cnt;
    
    always_ff @(posedge clk125) begin
        if (rst_rx) st <= Idle;
        else        st <= nx;
    end
    
    always_comb begin
        nx = st;
        case(st)
            Idle : begin
                if(UDP_st) nx = st_que;
            end
            st_que : begin
                nx = Hcsum;
            end
            Hcsum : begin
                if(csum_cnt==6'd20) nx = Hc_End;
            end
            Hc_End : begin 
                if(csum_ok) nx = Ucsum;
                else if(err_cnt==3'b010) nx = Idle; 
            end
            Ucsum : begin
                if(csum_cnt==10'd1020) nx = Uc_End;    // 仮想ヘッダの長さ(仮想ヘッダ(12)+UDPデータ長(1008))
            end
            Uc_End : begin
                if(csum_ok) nx = Select;
                else if(err_cnt==3'b010) nx = Idle;
            end
            Select : begin
                if(packet_cnt==4'd9) nx = Ready;
                else                 nx = Idle;
            end
            Ready : begin
                if(Hcsum_st) nx = Tx_Hc;
            end
            Tx_Hc : begin
                if(csum_cnt==6'd20) nx = Tx_HEnd;
            end
            Tx_HEnd : begin
                if(err_cnt==3'b001) nx = Tx_Uc;     // err_cnt==2'b01は引き伸ばすために行っているTXBUFの為でもあったが
            end                                     // 後述のTx_Dataのcsumの部分を改良したため無くても良い
            Tx_Uc : begin
                if(csum_cnt==10'd1020) nx = Tx_UEnd;
            end
            Tx_UEnd : begin
                if(err_cnt==2'b01) nx = Tx_En;      // err_cnt==2'b01は引き伸ばすために行っている上と同じ
            end
            Tx_En : begin
                if(tx_end) nx = Tx_End;
            end
            Tx_End : begin
                if(packet_cnt==1'd1) nx = Idle;
                else                 nx = Ready;
            end
        endcase
    end    
    
    /*---データ数/RXBUF保持---*/
    integer j;
    
    //always_ff @(posedge ping_st)begin
    always_ff @(posedge clk125)begin
        if (UDP_st) begin
            rx_cnt_i <= rx_cnt;
            RXBUF_i  <= RXBUF;
            TTL      <= 8'd255;
            MsgSize  <= {RXBUF[38],RXBUF[39]} - 4'd8;
        end
        else if(st==Idle)begin
            rx_cnt_i <= 10'b0;
            for(j=0;j<256;j=j+1) RXBUF_i[j] <= 8'h00;
            MsgSize  <= 16'b0;
        end
    end 
    
    always_ff @(posedge clk125)begin
        if(UDP_st)begin
            DstMAC  <= {RXBUF[6],RXBUF[7],RXBUF[8],RXBUF[9],RXBUF[10],RXBUF[11]};
            DstIP   <= {RXBUF[26],RXBUF[27],RXBUF[28],RXBUF[29]};
        end
        else if(st==Idle)begin
            DstMAC  <= 48'b0;
            DstIP   <= 32'b0;
        end
    end
    
    /*---パケット数のカウント---*/
    always_ff @(posedge clk125)begin
        if(st==Select)       packet_cnt <= packet_cnt + 1;
        else if(st==Tx_End)  packet_cnt <= packet_cnt - 1;
    end
    
    /*---UDPデータ保存---*/
    reg [7:0] imageBuffer [9999:0];
    (*dont_touch="true"*)reg [15:0] SrcPort;
    (*dont_touch="true"*)reg [15:0] DstPort;
    reg [15:0] UDP_Checksum;
    always_ff @(posedge clk125)begin
        if(UDP_st)begin
            SrcPort <= {RXBUF[34],RXBUF[35]};
            DstPort <= {RXBUF[36],RXBUF[37]};    
            UDP_Checksum <= {RXBUF[40],RXBUF[41]}; 
        end
        else if(st==Idle)begin
            SrcPort <= 16'b0;
            DstPort <= 16'b0;
            UDP_Checksum <= 16'b0;
        end
    end
    
    /*---1000バイトのデータをバッファにコピー---*/
    integer msg_cnt;
    always_ff @(posedge clk125)begin
        if(st==st_que)begin
            for(msg_cnt=0;msg_cnt<10'd1000;msg_cnt=msg_cnt+1) imageBuffer[(packet_cnt*10'd1000)+msg_cnt] <= RXBUF[6'd42+msg_cnt];
        end
        else if(st==Idle&&packet_cnt==0) begin 
            for(msg_cnt=0;msg_cnt<14'd10000;msg_cnt=msg_cnt+1) imageBuffer[msg_cnt] <= 8'b0;
        end
    end
    
    /*---リセット信号---*/
    always_ff @(posedge clk125)begin
        if(st==Idle)    rst <= 1;
        else            rst <= 0;
    end

    always_ff @(posedge clk125)begin
        if(st==Hc_End)          err_cnt <= err_cnt + 3'b1;
        else if(st==Uc_End)     err_cnt <= err_cnt + 3'b1;
        else if(st==Tx_HEnd)    err_cnt <= err_cnt + 3'b1;
        else if(st==Tx_UEnd)    err_cnt <= err_cnt + 3'b1;
        else                    err_cnt <= 0;
    end 
    
    /*---チェックサム用データ---*/
    (*dont_touch="true"*)reg [7:0]       data;
    reg             data_en;
    (*dont_touch="true"*)reg [15:0]      csum;
    
    always_ff @(posedge clk125)begin         
        if(st==Idle)                csum_cnt <= 0;
        else if(st==Hcsum)begin
            if(csum_cnt==6'd20)     csum_cnt <= 0;
            else                    csum_cnt <= csum_cnt + 1;
        end
        else if(st==Ucsum)begin
            if(csum_cnt==10'd1020)  csum_cnt <= 0;
            else                    csum_cnt <= csum_cnt + 1;
        end
        else if(st==Tx_Hc)begin
            if(csum_cnt==6'd20)     csum_cnt <= 0;
            else                    csum_cnt <= csum_cnt + 1;
        end
        else if(st==Tx_Uc)begin
            if(csum_cnt==10'd1020)  csum_cnt <= 0;
            else                    csum_cnt <= csum_cnt + 1;
        end
        else                        csum_cnt <= 0; 
    end
    
    /*---チェックサム用データ---*/
    always_ff @(posedge clk125)begin    // 最初の14bitはMACヘッダ
        if(st==Hcsum)       data <= RXBUF_i[csum_cnt+eth_head];
        else if(st==Ucsum)  data <= VBUF[csum_cnt];
        else if(st==Tx_Hc)  data <= TXBUF[csum_cnt+eth_head];
        else if(st==Tx_Uc)  data <= VBUF[csum_cnt];
        else                data <= 0;
    end
    
    /*---チェックサム計算開始用---*/
    always_ff @(posedge clk125)begin
        if(st==Hcsum)begin
            if(csum_cnt!=6'd20) data_en <= 1;
            else                data_en <= 0;
        end
        else if(st==Ucsum)begin
            if(csum_cnt!=(5'd20+MsgSize))
                                data_en <= 1;
            else                data_en <= 0;
        end
        else if(st==Tx_Hc)begin
            if(csum_cnt!=6'd20) data_en <= 1;
            else                data_en <= 0;
        end
        else if(st==Tx_Uc)begin
            if(csum_cnt!=(5'd20+MsgSize))
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
        else if(st==Uc_End)begin
            if(csum==16'h00_00) csum_ok <= 1;
            else                csum_ok <= 0;
        end
        else                    csum_ok <= 0;
    end
    
    /*---Tx_Data Ready---*/
    reg [10:0] tx_cnt;
    always_ff @(posedge clk125)begin
        if(st==Idle)    tx_cnt <= 0;
        else            tx_cnt <= rx_cnt_i;
    end    
    
    /*---UDPパケット準備---*/
    integer i;
    always_ff @(posedge clk125)begin
        if(st==Ready)begin
            /*-イーサネットヘッダ-*/
            {TXBUF[0],TXBUF[1],TXBUF[2],TXBUF[3],TXBUF[4],TXBUF[5]} <= DstMAC;
            {TXBUF[6],TXBUF[7],TXBUF[8],TXBUF[9],TXBUF[10],TXBUF[11]} <= `my_MAC;
            {TXBUF[12],TXBUF[13]} <= FTYPE;
            /*-IPヘッダ-*/
            TXBUF[14] <= 8'h45;                             // Version/IHL
            TXBUF[15] <= 8'h00;                             // ToS
            {TXBUF[16],TXBUF[17]} <= 16'd52;                // Total Length(16'd54==IPヘッダ(20)+その下(32))
            {TXBUF[18],TXBUF[19]} <= 16'hAB_CD;             // Identification
            {TXBUF[20],TXBUF[21]} <= {3'b010,13'd0};        // Flags[15:13] ,Flagment Offset[12:0]
            TXBUF[22] <= TTL;                               // Time To Live
            TXBUF[23] <= 8'h11;                             // Protocol
            {TXBUF[24],TXBUF[25]} <= 16'h00_00;             // IP Checksum
            {TXBUF[26],TXBUF[27],TXBUF[28],TXBUF[29]} <= `my_IP;
            {TXBUF[30],TXBUF[31],TXBUF[32],TXBUF[33]} <= DstIP;
            /*-UDPヘッダ-*/
            {TXBUF[34],TXBUF[35]} <= DstPort;               // 発信元ポート番号
            {TXBUF[36],TXBUF[37]} <= SrcPort;               // 宛先ポート番号   
            {TXBUF[38],TXBUF[39]} <= 16'd1008;              // UDPデータ長 UDPヘッダ(8バイト)+UDPデータ(1000バイト)
            {TXBUF[40],TXBUF[41]} <= 16'h00_00;             // UDP Checksum (仮想ヘッダ+UDP)
            /*-UDPデータ(可変長(受信データ長による))____24バイトに固定____-*/
            for(i=0;i<1000;i=i+1) TXBUF[6'd42+i] <= imageBuffer[i+(10'd1000*(4'd10-packet_cnt))];
            {TXBUF[1042],TXBUF[1043],TXBUF[1044],TXBUF[1045]} <= 32'h00_00_00_00;
            Hcsum_st <= 1;
        end
        else if(st==Tx_HEnd&&err_cnt==2'b01)    {TXBUF[24],TXBUF[25]} <= csum;
        else if(st==Tx_UEnd&&err_cnt==2'b01)    {TXBUF[40],TXBUF[41]} <= csum;
        else if(st==Idle)begin
            for(i=0;i<10'd1000;i=i+1) TXBUF[i] <= 0;
            Hcsum_st <= 0;
            i <= 0;
        end
    end
    
    /*---仮想ヘッダ準備---*/
    integer v_cnt;
    always_ff @(posedge clk125)begin
        if(st==Hc_End)begin
            {VBUF[0],VBUF[1],VBUF[2],VBUF[3]} <= `my_IP;
            {VBUF[4],VBUF[5],VBUF[6],VBUF[7]} <= DstIP;
            {VBUF[8],VBUF[9]} <= 16'h00_11;
            {VBUF[10],VBUF[11]} <= MsgSize+4'd8;
            {VBUF[12],VBUF[13]} <= SrcPort;
            {VBUF[14],VBUF[15]} <= DstPort;
            {VBUF[16],VBUF[17]} <= MsgSize+4'd8;
            {VBUF[18],VBUF[19]} <= UDP_Checksum;
            for(v_cnt=0;v_cnt<10'd1000;v_cnt=v_cnt+1)
                VBUF[20+v_cnt]  <= imageBuffer[(10'd1000*packet_cnt)+v_cnt];
           
        end
        else if(st==Tx_HEnd)begin
            {VBUF[0],VBUF[1],VBUF[2],VBUF[3]} <= `my_IP;
            {VBUF[4],VBUF[5],VBUF[6],VBUF[7]} <= DstIP;
            {VBUF[8],VBUF[9]} <= 16'h00_11;
            {VBUF[10],VBUF[11]} <= MsgSize+4'd8;
            {VBUF[12],VBUF[13]} <= {TXBUF[34],TXBUF[35]};
            {VBUF[14],VBUF[15]} <= {TXBUF[36],TXBUF[37]};
            {VBUF[16],VBUF[17]} <= MsgSize+4'd8;
            {VBUF[18],VBUF[19]} <= {TXBUF[40],TXBUF[41]};
            for(v_cnt=0;v_cnt<1000;v_cnt=v_cnt+1)
                VBUF[20+v_cnt] <= imageBuffer[(10'd1000*(4'd10-packet_cnt))+v_cnt];
        end
        else if(st==Idle)begin
            for(v_cnt=0;v_cnt<10'd1020;v_cnt=v_cnt+1) VBUF[v_cnt] <= 8'b0;
            v_cnt <= 0;
        end
        else v_cnt <= 0;
    end    

    /*---可変長のUDPデータ用---*/
//    integer count;
//    always_ff @(posedge clk125)begin
//        if(st==Hc_End)begin
//            for(count=0;count<50;count=count+1)begin
//                if(UDP_cnt==MsgSize) break;
//                else UDP_cnt <= UDP_cnt + 1;
//            end
//        end
//        else if(st==Ready)begin
//            for(count=0;count<50;count=count+1)begin
//                if(UDP_cnt==MsgSize) break;
//                else UDP_cnt <= UDP_cnt + 1;
//            end
//        end
//        else if(st==Tx_HEnd)begin
//            for(count=0;count<50;count=count+1)begin
//                if(UDP_cnt==MsgSize) break;
//                else UDP_cnt <= UDP_cnt + 1;
//            end            
//        end
//        else UDP_cnt <= 0;
//    end

    checksum udp_checksum2(
        .clk_i(clk125),
        .d(data),
        .data_en(data_en),
        .csum_o(csum),
        .rst(rst)
    );
    
    reg [9:0] clk_cnt;
    always_ff @(posedge clk125)begin
        if(st==Ready) tx_end <= 0;
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
            UDP_d <= {1'b1,TXBUF[clk_cnt]};
            UDP_tx <= 1;
        end
        else if(st==Tx_En&&fcs_cnt!=2'b11)begin
            UDP_d <= {1'b0,TXBUF[clk_cnt]};
            fcs_cnt <= fcs_cnt + 1;
        end
        else if(st==Tx_En&&fcs_cnt==2'b11)begin
            UDP_tx <= 0;
        end
        else begin
            UDP_tx <= 0;
            UDP_d <= 0;
            fcs_cnt <= 0;
        end
    end
    
endmodule
