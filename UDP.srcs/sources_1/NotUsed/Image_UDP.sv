`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/26 16:37:21
// Design Name: 
// Module Name: Image_UDP
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


module Image_UDP(
    /*---Input---*/
    eth_rxck,
    clk125,
    rst_rx,
    RXBUF,
    rx_cnt,
    UDP_st,
    /*---Output---*/
    UDP_tx,
    UDP_d
    );
    
    /*---Image_UDP.sv---*/
    /*
    画像データは100x100
    フラグメントなし
    1000バイトずつ
    UDPデータをすべて溜め込んで処理
    受信のみ
    */
    
    /*---I/O Declare---*/
    input           eth_rxck;
    input           clk125;
    input           rst_rx;
    input [7:0]     RXBUF [1045:0];
    input [9:0]     rx_cnt;
    input           UDP_st;
    
    output reg       UDP_tx;
    output reg [8:0] UDP_d;
  
    
    /*---parameter---*/
    parameter   IDLE        =   8'h00;
    parameter   Presv       =   8'h01;
    parameter   Hcsum       =   8'h02;
    parameter   Hc_End      =   8'h03;
    parameter   Ucsum       =   8'h04;
    parameter   Uc_End      =   8'h05;
    parameter   Select_r    =   8'h06;
    parameter   Recv_End    =   8'h07;
    parameter   READY       =   8'h08;
    parameter   Tx_Hc       =   8'h09;
    parameter   Tx_HEnd     =   8'h0A;
    parameter   Tx_Uc       =   8'h0B;
    parameter   Tx_UEnd     =   8'h0C;
    parameter   Tx_En       =   8'h0D;
    parameter   Tx_End      =   8'h0E;
    parameter   Select_t    =   8'h0F;
    parameter   Trans_End   =   8'h10;
    parameter   ERROR       =   8'hFF;
    
    parameter   eth_head    =   4'd14;
    parameter   udp         =   6'd34;
    parameter   FTYPE       =   16'h08_00;
    parameter   TTL         =   8'd255;
    
    /*---wire/register---*/
    reg [7:0]   image_buffer [9999:0];
    reg [7:0]   RXBUF_i [1045:0];
    reg [7:0]   VBUF    [1019:0];  // データ1000バイト+仮想ヘッダ12バイト+UDPヘッダ8バイト
    reg [7:0]   TXBUF   [1045:0];
    reg [47:0]  DstMAC;
    reg [31:0]  DstIP;
    reg [15:0]  SrcPort;
    reg [15:0]  DstPort;
    reg [10:0]  rx_cnt_i;
    reg         rst;
    reg [15:0]  MsgSize;
    reg [10:0]  UDP_cnt;  // 固定長のUDPデータ用カウント
    reg [15:0]  UDP_Checksum;
    reg [4:0]   end_cnt;
    reg         Hcsum_st;
    reg         tx_end;
    
    /*---ステートマシン---*/
    (*dont_touch="true"*)reg [7:0]   st;
    reg [7:0]   nx;
    reg [10:0]  csum_cnt;
    reg         csum_ok;
    reg [2:0]   err_cnt;
    reg [4:0]   packet_cnt;
    
    always_ff @(posedge eth_rxck) begin
        if (rst_rx) st <= IDLE;
        else        st <= nx;
    end
    
    always_comb begin
        nx = st;
        case(st)
            IDLE : begin
                if(UDP_st) nx = Presv;
            end
            Presv : begin
                nx = Hcsum;
            end
            Hcsum : begin
                if(csum_cnt==6'd20) nx = Hc_End;
            end
            Hc_End : begin 
                if(csum_ok) nx = Ucsum;
                else if(err_cnt==3'b010) nx = ERROR; 
            end
            Ucsum : begin
                if(csum_cnt==10'd1020) nx = Uc_End;    // 仮想ヘッダの長さ(仮想ヘッダ(12)+UDPデータ長(1008))
            end
            Uc_End : begin
                if(csum_ok) nx = Select_r;
                else if(err_cnt==3'b010) nx = ERROR;
            end
            Select_r : begin
                if(packet_cnt==4'd9) nx = Recv_End;
                else                 nx = IDLE;
            end
            Recv_End : begin
                if(end_cnt==5'h04) nx = READY;
            end
            READY : begin
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
                nx = Select_t;
            end
            Select_t : begin
                if(packet_cnt==5'd9) nx = Trans_End;
                else                 nx = READY;
            end
            Trans_End : begin
                nx = IDLE;
            end
        endcase
    end
    
    /*---データ保持---*/
    integer i;
    /*--データ数/パケット--*/
    always_ff @(posedge eth_rxck)begin
        if(st==Presv)begin
            rx_cnt_i    <= rx_cnt;
            RXBUF_i     <= RXBUF;
            MsgSize     <= {RXBUF[38],RXBUF[39]} - 4'd8;    // UDPデータグラム-UDヘッダ(8バイト)=1000バイト
        end
        else if(st==IDLE) begin
            rx_cnt_i    <= 11'd0;
            for (i=0;i<1046;i=i+1) RXBUF_i[i] <= 8'h00;
            MsgSize     <= 16'd0;
        end
    end
    /*--送信元MAC/IP--*/
    always_ff @(posedge eth_rxck)begin
        if (st==Presv) begin
            DstMAC  <= {RXBUF[6],RXBUF[7],RXBUF[8],RXBUF[9],RXBUF[10],RXBUF[11]};
            DstIP   <= {RXBUF[26],RXBUF[27],RXBUF[28],RXBUF[29]};
        end
        else if(st==IDLE)begin
            DstMAC  <= 48'b0;
            DstIP   <= 32'b0;
        end
    end
    /*--ポート番号--*/
    always_ff @(posedge eth_rxck)begin
        if(st==Presv)begin
            SrcPort <= {RXBUF[34],RXBUF[35]};
            DstPort <= {RXBUF[36],RXBUF[37]};    
            UDP_Checksum <= {RXBUF[40],RXBUF[41]}; 
        end
        else if(st==IDLE)begin
            SrcPort <= 16'b0;
            DstPort <= 16'b0;
            UDP_Checksum <= 16'b0;
        end
    end
    /*--データ部--*/
    integer msg_cnt;
    always_ff @(posedge eth_rxck)begin
        if (st==Presv) begin
            for(msg_cnt=0;msg_cnt<10'd1000;msg_cnt=msg_cnt+1) image_buffer[(packet_cnt*10'd1000)+msg_cnt] <= RXBUF[6'd42+msg_cnt];
        end
        else if((st==IDLE&&packet_cnt==0)||st==ERROR) begin 
            for(msg_cnt=0;msg_cnt<14'd10000;msg_cnt=msg_cnt+1) image_buffer[msg_cnt] <= 8'b0;
        end
    end

    /*---パケット数のカウント---*/
    always_ff @(posedge eth_rxck)begin
        if (rst_rx)             packet_cnt <= 5'd0;
        else if (st==Select_r)  packet_cnt <= packet_cnt + 1;
        else if (st==Recv_End||st==ERROR)  packet_cnt <= 0;
        else if (st==Select_t)  packet_cnt <= packet_cnt + 1;
        else if (st==Trans_End||st==ERROR) packet_cnt <= 0;
        
    end

    /*---リセット信号---*/
    always_ff @(posedge eth_rxck)begin
        if (st==IDLE)   rst <= 1;
        else            rst <= 0;
    end

    /*---チェックサム計算失敗用---*/
    always_ff @(posedge eth_rxck)begin
        if(st==Hc_End)          err_cnt <= err_cnt + 3'b1;
        else if(st==Uc_End)     err_cnt <= err_cnt + 3'b1;
        else                    err_cnt <= 0;
    end
    
    /*---チェックサム用データ---*/
    (*dont_touch="true"*)reg [7:0]       data;
    reg             data_en;
    (*dont_touch="true"*)reg [15:0]      csum;
    /*--チェックサム用カウンタ--*/
    always_ff @(posedge eth_rxck)begin         
        if(st==IDLE)                csum_cnt <= 0;
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
    /*--チェックサムデータ ENABLE--*/
    always_ff @(posedge eth_rxck)begin
        if(st==IDLE)       data_en <= 0;
        else if(st==Hcsum)begin
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
        else                    data_en <= 0;
    end
    /*--チェックサム用データ--*/
    always_ff @(posedge eth_rxck)begin    // 最初の14bitはMACヘッダ
        if(st==Hcsum)       data <= RXBUF_i[csum_cnt+eth_head];
        else if(st==Ucsum)  data <= VBUF[csum_cnt];
        else if(st==Tx_Hc)  data <= TXBUF[csum_cnt+eth_head];
        else if(st==Tx_Uc)  data <= VBUF[csum_cnt];
        else                data <= 0;
    end

    /*---仮想ヘッダ準備---*/
    integer v_cnt;
    always_ff @(posedge eth_rxck)begin
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
                VBUF[20+v_cnt]  <= image_buffer[(10'd1000*packet_cnt)+v_cnt];              
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
            for(v_cnt=0;v_cnt<10'd1000;v_cnt=v_cnt+1)
                VBUF[20+v_cnt] <= image_buffer[(10'd1000*packet_cnt)+v_cnt];
        end
        else if(st==IDLE)begin
            for(v_cnt=0;v_cnt<10'd1020;v_cnt=v_cnt+1) VBUF[v_cnt] <= 8'b0;
            v_cnt <= 0;
        end
        else v_cnt <= 0;
    end

    /*---終了---*/
    always_ff @(posedge eth_rxck)begin
        if (st==Recv_End) end_cnt <= end_cnt + 1;
        else              end_cnt <= 0;
    end

    /*---UDPパケット準備---*/
    integer j;
    always_ff @(posedge eth_rxck)begin
        if(st==READY)begin
            /*-イーサネットヘッダ-*/
            {TXBUF[0],TXBUF[1],TXBUF[2],TXBUF[3],TXBUF[4],TXBUF[5]} <= DstMAC;
            {TXBUF[6],TXBUF[7],TXBUF[8],TXBUF[9],TXBUF[10],TXBUF[11]} <= `my_MAC;
            {TXBUF[12],TXBUF[13]} <= FTYPE;
            /*-IPヘッダ-*/
            TXBUF[14] <= 8'h45;                             // Version/IHL
            TXBUF[15] <= 8'h00;                             // ToS
            {TXBUF[16],TXBUF[17]} <= 16'd1028;              // Total Length(16'd1028==IPヘッダ(20)+その下(1008))
            {TXBUF[18],TXBUF[19]} <= 16'hAB_CD;             // Identification
            {TXBUF[20],TXBUF[21]} <= {3'b010,13'd0};        // Flags[15:13] ,Flagment Offset[12:0]
            TXBUF[22] <= TTL;                               // Time To Live
            TXBUF[23] <= 8'h11;                             // Protocol 8'h11==8'd17==UDP
            {TXBUF[24],TXBUF[25]} <= 16'h00_00;             // IP Checksum
            {TXBUF[26],TXBUF[27],TXBUF[28],TXBUF[29]} <= `my_IP;
            {TXBUF[30],TXBUF[31],TXBUF[32],TXBUF[33]} <= DstIP;
            /*-UDPヘッダ-*/
            {TXBUF[34],TXBUF[35]} <= DstPort;               // 発信元ポート番号
            {TXBUF[36],TXBUF[37]} <= SrcPort;               // 宛先ポート番号   
            {TXBUF[38],TXBUF[39]} <= 16'd1008;              // UDPデータ長 UDPヘッダ(8バイト)+UDPデータ(1000バイト)
            {TXBUF[40],TXBUF[41]} <= 16'h00_00;             // UDP Checksum (仮想ヘッダ+UDP)
            /*-UDPデータ(可変長(受信データ長による))____1000バイトに固定____-*/
            for(j=0;j<1000;j=j+1) TXBUF[6'd42+j] <= image_buffer[j+(10'd1000*packet_cnt)];
            {TXBUF[1042],TXBUF[1043],TXBUF[1044],TXBUF[1045]} <= 32'h00_00_00_00;
            Hcsum_st <= 1;
        end
        else if(st==Hc_End&&err_cnt==2'b01)    {TXBUF[24],TXBUF[25]} <= csum;
        else if(st==Uc_End&&err_cnt==2'b01)    {TXBUF[40],TXBUF[41]} <= csum;
        else if(st==IDLE)begin
            for(j=0;j<11'd1046;j=j+1) TXBUF[j] <= 0;
            Hcsum_st <= 0;
            j <= 0;
        end
        else if(st==Tx_End) begin
            Hcsum_st <= 0;
        end
    end

    checksum image_checksum(
        .clk_i(eth_rxck),
        .d(data),
        .data_en(data_en),
        .csum_o(csum),
        .rst(rst)
    );

    /*---送信---*/
    reg [10:0] clk_cnt;
    always_ff @(posedge clk125)begin
        if(st==READY) tx_end <= 0;
        if(st==Tx_En)begin
            clk_cnt <= clk_cnt + 1;
            if(clk_cnt==11'd1046) tx_end <= 1; 
        end
        else if(st==IDLE)begin
            clk_cnt <= 0;
            tx_end <= 0;
        end
    end
    
    reg [1:0] fcs_cnt;
    always_ff @(posedge clk125)begin
        if(st==Tx_En&&clk_cnt<(11'd1046-3'd4))begin
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


//    /*---BlockRAM Generator---*/
//    image_RAM image_RAM(
//        .clka(eth_rxck),
//        .ena(1'b1),     // PortA  enable
//        .wea(),         // write enable
//        .addra(),       // write address
//        .dina(),        // write data
//        .clkb(eth_rxck),
//        .enb(1'b1),     // PortB enable
//        .addrb(),       // read address
//        .doutb()        // read data
//    );


endmodule
