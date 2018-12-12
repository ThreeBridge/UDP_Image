`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/27 18:47:57
// Design Name: 
// Module Name: trans_image
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

/*---trans_image.sv---*/
// 受け取った画像データを受信時と同じく1,000バイトずつ送信
// 送信準備 -> 送信終了 の遷移を10回繰り返すことで10,000バイト送信する
// 送信回数をDIPスライドスイッチの入力から動的に設定できる.
// MAC/IP address はDIPスライドスイッチの入力から動的に設定できる.

module trans_image(
    /*---Input---*/
    eth_rxck,
    clk125,
    rst_rx,
    rst_btn,
    imdata,
    recvend,
    //image_buffer,
    my_MACadd,
    my_IPadd,
    DstMAC,
    DstIP,
    SrcPort,
    DstPort,
    SW,
    /*---Output---*/
    image_cnt,
    addr_cnt,
    UDP_tx,
    UDP_d,
    trans_err       // 送信エラー
    );
    
    /*---I/O Declare---*/
    input       eth_rxck;
    input       clk125;
    input       rst_rx;
    input       rst_btn;
    input [7:0] imdata;
    input       recvend;
    //input [7:0] image_buffer [9999:0];
    input [47:0] my_MACadd;     //<--- add 2018.12.5
    input [31:0] my_IPadd;      //--->
    input [47:0] DstMAC;
    input [31:0] DstIP;
    input [15:0] SrcPort;
    input [15:0] DstPort;
    input [7:0]  SW;
    
    output reg [9:0]   image_cnt;
    output reg [8:0]   addr_cnt;            
    (*dont_touch="true"*)output               UDP_tx;
    (*dont_touch="true"*)output reg [8:0]    UDP_d;
    output reg         trans_err;
    
    /*---parameter---*/
    parameter   IDLE    =   8'h00;
    parameter   Presv   =   8'h01;
    parameter   READY   =   8'h02;
    parameter   Hcsum   =   8'h03;
    parameter   Hc_End  =   8'h04;
    parameter   Ucsum   =   8'h05;
    parameter   Uc_End  =   8'h06;
    parameter   Tx_En   =   8'h07;
    parameter   Select  =   8'h08;
    parameter   Tx_End  =   8'h09;
    parameter   ERROR   =   8'h0A;
    
    parameter   eth_head =  4'd14;
    parameter   udp     =   6'd34;
    parameter   FTYPE   =   16'h08_00;
    parameter   MsgSize =   16'd1000;
    parameter   TTL     =   8'd255;
    parameter   PckSize =   11'd1046;
    
    /*---wire/register---*/
    //wire [3:0] packet_cnt_sel = (SW[7:4]==4'd0) ? SW[7:4] : (SW[7:4] - 4'd1);
    wire [8:0] packet_cnt_sel = (SW[7:4]==4'd0) ? 4'd0 :                            // add 2018.12.6
                                 (SW[7:4]==4'd1) ? 4'd1-1'b1 :
                                 (SW[7:4]==4'd2) ? 4'd2-1'b1 :
                                 (SW[7:4]==4'd3) ? 4'd4-1'b1 :
                                 (SW[7:4]==4'd4) ? 4'd8-1'b1 :
                                 (SW[7:4]==4'd5) ? 5'd16-1'b1 :
                                 (SW[7:4]==4'd6) ? 6'd32-1'b1 :
                                 (SW[7:4]==4'd7) ? 7'd64-1'b1 :
                                 (SW[7:4]==4'd8) ? 8'd128-1'b1 :
                                 (SW[7:4]==4'd9) ? 9'd256-1'b1 :
                                 (SW[7:4]==4'd10) ? 4'd10-1'b1 :
                                 8'd160-1'b1 ;


    //reg [7:0]   image_buffer_i [9999:0];
    //reg [7:0]   image_buffer [999:0];
    reg [7:0]   image_bufferA [499:0];
    reg [7:0]   image_bufferB [499:0];
    reg [7:0]   TXBUF [1045:0];
    reg [7:0]   VBUF [1019:0];
    reg         rst;
    reg [47:0]  DstMAC_i;
    reg [31:0]  DstIP_i;
    reg [10:0]  UDP_cnt;  // 固定長のUDPデータ用カウント
    (*dont_touch="true"*)reg [15:0] SrcPort_i;
    (*dont_touch="true"*)reg [15:0] DstPort_i;
    reg [15:0] UDP_Checksum;
    
    /*---ステートマシン---*/
    (*dont_touch="true"*)reg [7:0]   st;
    reg [7:0]   nx;
    (*dont_touch="true"*)reg [10:0]  csum_cnt;
    (*dont_touch="true"*)reg         csum_ok;
    reg [3:0]   err_cnt;
    (*dont_touch="true"*)reg [3:0]   tx_end;
    reg [8:0]   packet_cnt;
    //reg         Hcsum_st;
    reg [3:0]   ready_cnt;
    reg [9:0]   d_img_cnt [2:0];        // BlockRAMの出力が1サイクルずれるため & recv_image側でimage_cntにFFを挟むため
    
    always_ff @(posedge eth_rxck)begin
        if (rst_rx) st <= IDLE;
        else        st <= nx;
    end
    
    always_comb begin
        nx = st;
        case (st)
            IDLE : begin
                if (recvend) nx = Presv;
            end
            Presv : begin
                if (d_img_cnt[2]>10'd999) nx = READY;
            end
            READY : begin
                if (ready_cnt==4'd8) nx = Hcsum;
            end
            Hcsum : begin
                if (csum_cnt==11'd22) nx = Hc_End;
            end
            Hc_End : begin
                if (err_cnt==4'd8) nx = Ucsum;
            end
            Ucsum : begin
                if (csum_cnt==11'd1022) nx = Uc_End;
            end
            Uc_End : begin
                if (err_cnt==4'd8) nx = Tx_En; 
            end
            Tx_En : begin
                //if (tx_end[3]) nx = Select;
                if (tx_end_rxck[1]) nx = Select;
                else if (rst_btn) nx = IDLE;
            end
            Select : begin
                //if(packet_cnt==4'd9) nx = Tx_End;
                if(packet_cnt==packet_cnt_sel) nx = Tx_End;       // add 2018.12.5
                else                 nx = READY;
            end
            Tx_End : begin
                nx = IDLE;
            end
            ERROR :begin
                nx = IDLE;
            end
            default : begin
                nx = ERROR;
            end
        endcase
    end
    
    /*---データの受け渡し---*/
    always_ff @(posedge eth_rxck)begin
        if (recvend) begin
            DstMAC_i <= DstMAC;
            DstIP_i <= DstIP;
            SrcPort_i <= SrcPort;
            DstPort_i <= DstPort;
        end
        else if (st==IDLE) begin
            DstMAC_i <= 48'b0;
            DstIP_i <= 32'b0;
            SrcPort_i <= 16'b0;
            DstPort_i <= 16'b0;        
        end
    end
    
    /*---画像データ---*/
//    integer i;
//    always_ff @(posedge eth_rxck)begin
//        if (recvend) begin
//            for (i=0;i<10000;i=i+1) image_buffer_i[i] <= ~image_buffer[i];
//        end
//        else if(st==IDLE) begin
//            for (i=0;i<10000;i=i+1) image_buffer_i[i] <= 8'b0;
//        end
//    end
    
    always_ff @(posedge eth_rxck)begin              // recv_imageにあるBRAMの出力用アドレス
        if(st==Presv)begin
            if(image_cnt<1000)begin
                image_cnt <= image_cnt + 10'b1;
            end
        end
//        else if(st==Ucsum&&packet_cnt!=9)begin        10,000回カウントは冗長
//            if(image_cnt<((packet_cnt+2)*1000))
//                image_cnt <= image_cnt + 14'b1;
//        end
        //else if(st==Ucsum&&packet_cnt!=9)begin
        else if(st==Ucsum&&packet_cnt!=packet_cnt_sel)begin     // add 2018.12.5
            if(image_cnt<1000)begin
                image_cnt <= image_cnt + 10'b1;
            end
        end
        else if(st==READY)begin
            image_cnt <= 10'b0;
        end
        else if(st==IDLE)begin
            image_cnt <= 10'b0;
        end
    end
    
    
    always_ff @(posedge eth_rxck)begin              // BRAMのアドレスを表現するためのもの
        if(st==IDLE)        addr_cnt <= 9'b0;
        else if(st==Hc_End) addr_cnt <= packet_cnt + 1;
    end
    
    
//    reg [9:0] buffer_cnt;
//    always_ff @(posedge eth_rxck)begin
//        if(st==IDLE)begin
//            buffer_cnt <= 10'b0;
//        end
//        else if(st==Ucsum)begin
//            if(buffer_cnt<1000)begin
//                buffer_cnt <= buffer_cnt + 10'b1;
//            end
//        end
//        else if(st==READY)begin
//            buffer_cnt <= 10'b0;
//        end
//    end
    
    
    always_ff @(posedge eth_rxck)begin
        d_img_cnt <= {d_img_cnt[1:0],image_cnt};
    end
    
    //<-- add 2018.12.12
    reg [8:0] d_packet_cnt;
    always_ff @(posedge eth_rxck)begin
        d_packet_cnt <= packet_cnt;
    end
    //-->
    
    
    integer bufferA;
    integer bufferB;    
//    always_ff @(posedge eth_rxck)begin
//        if(st==Presv)begin
//            //image_buffer[image_cnt] <= imdata ^ 8'hFF;
//            if(d_img_cnt[2]<500)
//                image_bufferA[d_img_cnt[2]] <= imdata ^ 8'hFF;
//            else
//                image_bufferB[d_img_cnt[2]-500] <= imdata ^ 8'hFF;
//        end
//        //else if(st==Ucsum&&packet_cnt!=9)begin
//        //else if(st==Ucsum&&packet_cnt!=packet_cnt_sel)begin      // add 2018.12.5
//        else if(st==Ucsum&&d_packet_cnt!=packet_cnt_sel)begin
//            //image_buffer[image_cnt] <= imdata ^ 8'hFF;
//            if(d_img_cnt[2]<500)
//                image_bufferA[d_img_cnt[2]] <= imdata ^ 8'hFF;
//            else
//                image_bufferB[d_img_cnt[2]-500] <= imdata ^ 8'hFF;
//        end
//        else if(st==IDLE)begin
////            for(buffer=0;buffer<1000;buffer=buffer+1)begin
////                image_buffer[buffer] <= 8'b0;
////            end
//            for(bufferA=0;bufferA<500;bufferA=bufferA+1)begin
//                image_bufferA[bufferA] <= 8'b0;
//            end
//            for(bufferB=0;bufferB<500;bufferB=bufferB+1)begin
//                image_bufferB[bufferB] <= 8'h55;    // dummy
//            end
//        end
//    end
    //<-- add 2018.12.12
    always_ff @(posedge eth_rxck)begin
        if(st==Presv)begin
            if(d_img_cnt[2]<500)
                image_bufferA[d_img_cnt[2]] <= imdata ^ 8'hFF;
        end
        else if(st==Ucsum&&d_packet_cnt!=packet_cnt_sel)begin
            if(d_img_cnt[2]<500)
                image_bufferA[d_img_cnt[2]] <= imdata ^ 8'hFF;
        end
        else if(st==IDLE)begin
            for(bufferA=0;bufferA<500;bufferA=bufferA+1)begin
                image_bufferA[bufferA] <= 8'b0;
            end
        end
    end
    
    always_ff @(posedge eth_rxck)begin
        if(st==Presv)begin
            if(d_img_cnt[2]>=500)
                image_bufferB[d_img_cnt[2]-500] <= imdata ^ 8'hFF;
        end
        else if(st==Ucsum&&d_packet_cnt!=packet_cnt_sel)begin
            if(d_img_cnt[2]>=500)
                image_bufferB[d_img_cnt[2]-500] <= imdata ^ 8'hFF;
        end
        else if(st==IDLE)begin
            for(bufferB=0;bufferB<500;bufferB=bufferB+1)begin
                image_bufferB[bufferB] <= 8'h55;    // dummy
            end
        end
    end
    //-->
    
    
    /*---パケット数のカウント---*/
    always_ff @(posedge eth_rxck)begin
        if (rst_rx)             packet_cnt <= 9'd0;
        else if (st==IDLE)      packet_cnt <= 9'd0;
        else if (st==Select)    packet_cnt <= packet_cnt + 9'b1;
        else if (st==Tx_End)    packet_cnt <= 0;
    end    
    
    /*---リセット信号---*/
    always_ff @(posedge eth_rxck)begin
        if(st==IDLE)    rst <= 1;
        else            rst <= 0;
    end
    
    always_ff @(posedge eth_rxck)begin
        if (st==Hc_End)         err_cnt <= err_cnt + 4'b1;
        else if (st==Uc_End)    err_cnt <= err_cnt + 4'b1;
        else                    err_cnt <= 0;
    end     
    
    /*---チェックサム用データ---*/
    (*dont_touch="true"*)reg [7:0]       data;
    reg [1:0]            data_en;
    (*dont_touch="true"*)reg [15:0]      csum;
    
    always_ff @(posedge eth_rxck)begin         
        if(st==IDLE)                csum_cnt <= 0;
        else if(st==Hcsum)begin
            if(csum_cnt==6'd22)     csum_cnt <= 0;
            else                    csum_cnt <= csum_cnt + 1;
        end
        else if(st==Ucsum)begin
            if(csum_cnt==10'd1022)  csum_cnt <= 0;
            else                    csum_cnt <= csum_cnt + 1;
        end
        else                        csum_cnt <= 0; 
    end
    
//<-- moikawa add (2018.11.02)
    //TXBUF
    wire [10:0] txbuf_sel = csum_cnt + eth_head;
    reg [7:0]  data_pipe [17:0]; // part of pipelined selector from TXBUF[].
    wire [4:0]  data_pipe_sel;
    //VBUF
    wire [10:0] txbuf_sel_v = csum_cnt;
    reg [7:0]  data_pipe_v [16:0]; // part of pipelined selector from TXBUF[].
    wire [4:0]  data_pipe_sel_v;
//--> moikawa add (2018.11.02)
    
    /*---チェックサム用データ---*/
    always_ff @(posedge eth_rxck)begin    // 最初の14bitはMACヘッダ
        //if(st==Hcsum)      data <= TXBUF[csum_cnt+eth_head];
        if(st==Hcsum)      data <= data_pipe[ data_pipe_sel ];
        else if(st==Ucsum) data <= data_pipe_v[ data_pipe_sel_v ];
        else               data <= 0;
    end

//<-- moikawa add (2018.11.02)
    reg [10:0] txbuf_sel_d;
    integer    k;

    always_ff @(posedge eth_rxck) begin
        txbuf_sel_d <= txbuf_sel;
    end
    assign data_pipe_sel = (txbuf_sel_d[10:6] < 5'd17)? 
                            txbuf_sel_d[10:6] : 5'd17 ;

    always_ff @(posedge eth_rxck) begin // inserted pipelined stage.
        //for (k=0; k<64; k=k+1) begin
        //  data_pipe[k] <= TXBUF[ (64*k) + txbuf_sel[5:0] ];
        //end
        data_pipe[0]  <=  TXBUF[ txbuf_sel[5:0]         ];
        data_pipe[1]  <=  TXBUF[ txbuf_sel[5:0] + 64    ];
        data_pipe[2]  <=  TXBUF[ txbuf_sel[5:0] + 128   ];
        data_pipe[3]  <=  TXBUF[ txbuf_sel[5:0] + 192   ];
        data_pipe[4]  <=  TXBUF[ txbuf_sel[5:0] + 256   ];
        data_pipe[5]  <=  TXBUF[ txbuf_sel[5:0] + 320   ];
        data_pipe[6]  <=  TXBUF[ txbuf_sel[5:0] + 384   ];
        data_pipe[7]  <=  TXBUF[ txbuf_sel[5:0] + 448   ];
        data_pipe[8]  <=  TXBUF[ txbuf_sel[5:0] + 512   ];
        data_pipe[9]  <=  TXBUF[ txbuf_sel[5:0] + 576   ];
        data_pipe[10] <=  TXBUF[ txbuf_sel[5:0] + 640   ];
        data_pipe[11] <=  TXBUF[ txbuf_sel[5:0] + 704   ];
        data_pipe[12] <=  TXBUF[ txbuf_sel[5:0] + 768   ];
        data_pipe[13] <=  TXBUF[ txbuf_sel[5:0] + 832   ];
        data_pipe[14] <=  TXBUF[ txbuf_sel[5:0] + 896   ];
        data_pipe[15] <=  TXBUF[ txbuf_sel[5:0] + 960   ];
        if (txbuf_sel[5:0] < 6'd22) begin
	       data_pipe[16] <=  TXBUF[ txbuf_sel[5:0] + 1024  ];
        end else begin
	       data_pipe[16] <=  8'h00;
        end
        data_pipe[17] <= 8'h00;  // dummy value.
    end
//--> moikawa add (2018.11.02)

    /*---VBUF用data_pipe---*/
    reg [10:0] txbuf_sel_v_d;

    always_ff @(posedge eth_rxck) begin
        txbuf_sel_v_d <= txbuf_sel_v;
    end
    assign data_pipe_sel_v = (txbuf_sel_v_d[10:6] < 5'd17)? 
                              txbuf_sel_v_d[10:6] : 5'd17 ;

    always_ff @(posedge eth_rxck) begin // inserted pipelined stage.
        data_pipe_v[0]  <=  VBUF[ txbuf_sel_v[5:0]         ];
        data_pipe_v[1]  <=  VBUF[ txbuf_sel_v[5:0] + 64    ];
        data_pipe_v[2]  <=  VBUF[ txbuf_sel_v[5:0] + 128   ];
        data_pipe_v[3]  <=  VBUF[ txbuf_sel_v[5:0] + 192   ];
        data_pipe_v[4]  <=  VBUF[ txbuf_sel_v[5:0] + 256   ];
        data_pipe_v[5]  <=  VBUF[ txbuf_sel_v[5:0] + 320   ];
        data_pipe_v[6]  <=  VBUF[ txbuf_sel_v[5:0] + 384   ];
        data_pipe_v[7]  <=  VBUF[ txbuf_sel_v[5:0] + 448   ];
        data_pipe_v[8]  <=  VBUF[ txbuf_sel_v[5:0] + 512   ];
        data_pipe_v[9]  <=  VBUF[ txbuf_sel_v[5:0] + 576   ];
        data_pipe_v[10] <=  VBUF[ txbuf_sel_v[5:0] + 640   ];
        data_pipe_v[11] <=  VBUF[ txbuf_sel_v[5:0] + 704   ];
        data_pipe_v[12] <=  VBUF[ txbuf_sel_v[5:0] + 768   ];
        data_pipe_v[13] <=  VBUF[ txbuf_sel_v[5:0] + 832   ];
        data_pipe_v[14] <=  VBUF[ txbuf_sel_v[5:0] + 896   ];
        if(txbuf_sel_v[5:0] < 6'd60)begin
            data_pipe_v[15] <=  VBUF[ txbuf_sel_v[5:0] + 960   ];
        end else begin
	       data_pipe_v[15] <=  8'h00;
        end
        data_pipe_v[16] <= 8'h00;  // dummy value.
    end




    /*---チェックサム計算開始用---*/
    always_ff @(posedge eth_rxck)begin
        if(st==Hcsum)begin
            if(csum_cnt!=6'd22) data_en <= {data_en[0],1'b1};
            else                data_en <= 0;
        end
        else if(st==Ucsum)begin
            if(csum_cnt!=(5'd22+MsgSize))
                                data_en <= {data_en[0],1'b1};
            else                data_en <= 0;
        end
        else if(st==IDLE)       data_en <= 0;
        else                    data_en <= 0;
    end    
    
    /*---READY Extend---*/
    always_ff @(posedge eth_rxck)begin
        if(st==READY)begin
            ready_cnt <= ready_cnt + 1'b1;
        end
        else begin
            ready_cnt <= 4'b0;
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

    reg ready_clk125;
    reg ready_clk125_d;
    always_ff @(posedge clk125)begin
        ready_clk125_d <= ready_rxck;
        ready_clk125 <= ready_clk125_d;
    end
    
    /*---tx_Hcend Extend---*/
    reg hcend_rxck;      
    reg ucend_rxck;  
    always_ff @(posedge eth_rxck)begin
        if(st==Hc_End) begin
            if(err_cnt>=1&&err_cnt<=3)   hcend_rxck <= 1;
            else                         hcend_rxck <= 0;
        end 
        else if(st==Uc_End)begin
            if(err_cnt>=1&&err_cnt<=3)   ucend_rxck <= 1;
            else                         ucend_rxck <= 0;
        end
        else begin
            hcend_rxck <= 0;
            ucend_rxck <= 0;
        end
    end
    
    reg hcend_clk125;
    reg hcend_clk125_d;
    reg ucend_clk125;
    reg ucend_clk125_d;
    always_ff @(posedge clk125)begin
        hcend_clk125_d <= hcend_rxck;
        hcend_clk125 <= hcend_clk125_d;
        ucend_clk125_d <= ucend_rxck;
        ucend_clk125 <= ucend_clk125_d;
    end  
    
    reg [15:0] csum_extend;
    always_ff @(posedge eth_rxck)begin 
       if(st==Hc_End) begin
           if(err_cnt==2'b01) csum_extend <= csum;
       end
       else if(st==Uc_End)begin
           if(err_cnt==2'b01) csum_extend <= csum;
       end
       else csum_extend <= 16'h5555;  // dummy value.
    end    
    
    
    
    /*---UDPパケット準備---*/
    integer tx_A;
    integer tx_B;
    always_ff @(posedge clk125)begin
        if(ready_clk125)begin
            /*-イーサネットヘッダ-*/
            {TXBUF[0],TXBUF[1],TXBUF[2],TXBUF[3],TXBUF[4],TXBUF[5]} <= DstMAC_i;
            //{TXBUF[6],TXBUF[7],TXBUF[8],TXBUF[9],TXBUF[10],TXBUF[11]} <= `my_MAC;
            {TXBUF[6],TXBUF[7],TXBUF[8],TXBUF[9],TXBUF[10],TXBUF[11]} <= my_MACadd;
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
            //{TXBUF[26],TXBUF[27],TXBUF[28],TXBUF[29]} <= `my_IP;
            {TXBUF[26],TXBUF[27],TXBUF[28],TXBUF[29]} <= my_IPadd;
            {TXBUF[30],TXBUF[31],TXBUF[32],TXBUF[33]} <= DstIP_i;
            /*-UDPヘッダ-*/
            {TXBUF[34],TXBUF[35]} <= DstPort_i;             // 発信元ポート番号
            {TXBUF[36],TXBUF[37]} <= SrcPort_i;             // 宛先ポート番号   
            {TXBUF[38],TXBUF[39]} <= 16'd1008;              // UDPデータ長 UDPヘッダ(8バイト)+UDPデータ(1000バイト)
            {TXBUF[40],TXBUF[41]} <= 16'h00_00;             // UDP Checksum (仮想ヘッダ+UDP)
            /*-UDPデータ(可変長(受信データ長による))____1000バイトに固定____-*/
            //for(j=0;j<1000;j=j+1) TXBUF[6'd42+j] <= image_buffer[j];
            for(tx_A=0;tx_A<500;tx_A=tx_A+1) TXBUF[6'd42+tx_A] <= image_bufferA[tx_A];      // 2018.11.16
            for(tx_B=0;tx_B<500;tx_B=tx_B+1) TXBUF[6'd42+tx_B+500] <= image_bufferB[tx_B];  // 2018.11.16
            {TXBUF[1042],TXBUF[1043],TXBUF[1044],TXBUF[1045]} <= 32'h01_02_03_04;   // dummy
            //Hcsum_st <= 1;
        end
        else if(hcend_clk125)    {TXBUF[24],TXBUF[25]} <= csum_extend;
        else if(ucend_clk125)    {TXBUF[40],TXBUF[41]} <= csum_extend;
        /*
        else if(st==IDLE)begin
            for(j=0;j<11'd1046;j=j+1) TXBUF[j] <= 0;
            //Hcsum_st <= 0;
            //j <= 0;
        end
        */
    end    
    
    /*---仮想ヘッダ準備---*/
    integer v_cnt;
    integer v_cnt_A;
    integer v_cnt_B;
    always_ff @(posedge eth_rxck)begin
        if(st==Hc_End)begin
            //{VBUF[0],VBUF[1],VBUF[2],VBUF[3]} <= `my_IP;
            {VBUF[0],VBUF[1],VBUF[2],VBUF[3]} <= my_IPadd;
            {VBUF[4],VBUF[5],VBUF[6],VBUF[7]} <= DstIP_i;
            {VBUF[8],VBUF[9]} <= 16'h00_11;
            {VBUF[10],VBUF[11]} <= MsgSize+4'd8;
            {VBUF[12],VBUF[13]} <= DstPort_i;
            {VBUF[14],VBUF[15]} <= SrcPort_i;
            {VBUF[16],VBUF[17]} <= MsgSize+4'd8;
            {VBUF[18],VBUF[19]} <= 16'h00_00;
            //for(v_cnt=0;v_cnt<10'd1000;v_cnt=v_cnt+1)
            //    VBUF[20+v_cnt]  <= image_buffer[v_cnt];
            for(v_cnt_A=0;v_cnt_A<500;v_cnt_A=v_cnt_A+1) VBUF[20+v_cnt_A] <= image_bufferA[v_cnt_A];      // 2018.11.16
            for(v_cnt_B=0;v_cnt_B<500;v_cnt_B=v_cnt_B+1) VBUF[20+v_cnt_B+500] <= image_bufferB[v_cnt_B];  // 2018.11.16
        end
        else if(st==IDLE)begin
            for(v_cnt=0;v_cnt<10'd1020;v_cnt=v_cnt+1) VBUF[v_cnt] <= 8'b0;
            v_cnt <= 0;
        end
        else v_cnt <= 0;
    end    
    
    checksum trans_checksum(
        .clk_i(eth_rxck),
        .d(data),
        .data_en(data_en[1]),
        .csum_o(csum),
        .rst(rst)
    );
    
    //<----------
    /*
    データを出すクロックを"clk125"で行うために,ステートがTx_Enであると"HIGH"になる信号を
    clk125を用いて生成している.
    */
    reg tx_en;
    always_ff @(posedge eth_rxck)begin
       if(st==Tx_En) tx_en <= 1'b1;
       else          tx_en <= 1'b0;  
    end
    reg tx_en_clk125;
    reg tx_en_clk125_d;
    
    always_ff @(posedge clk125) begin
       tx_en_clk125_d <= tx_en;
       tx_en_clk125 <= tx_en_clk125_d; 
    end
    //---------->
    
    /*---送信---*/
    (*dont_touch="true"*)reg [10:0] clk_cnt;
    always_ff @(posedge clk125)begin
        if(ready_clk125)begin
            tx_end <= 0;
            clk_cnt <= 0;
        end
        else if(tx_en_clk125)begin
            clk_cnt <= clk_cnt + 1;
            if(clk_cnt==PckSize+1) tx_end <= 4'hF; 
        end
        else begin
            tx_end <= {tx_end[2:0],1'b0};
            clk_cnt <= 0;
        end
    end
//<-- moikawa add (2018.12.11)
    (*dont_touch="true"*)reg [1:0] tx_end_rxck;
    always_ff @(posedge eth_rxck)begin
        if (rst_rx) tx_end_rxck <= 2'b0;
        else        tx_end_rxck <= {tx_end_rxck[0], tx_end[3]};   
    end    
    
//--> moikawa add (2018.12.11)

//<-- moikawa add (2018.11.02)
       wire [10:0] txbuf_sel2 = clk_cnt;
       reg [7:0]  data_pipe2 [17:0]; // part of pipelined selector from TXBUF[].
       wire [4:0]  data_pipe_sel2;    
//--> moikawa add (2018.11.02)
    reg [1:0] delay_tx;;
    reg [2:0] fcs_cnt;
    always_ff @(posedge clk125)begin
        if(tx_en_clk125&&clk_cnt<(PckSize-3'd3))begin
            UDP_d <= {1'b1,data_pipe2[data_pipe_sel2]};
            delay_tx <= {delay_tx[0],1'b1};     // pipeによる遅延を考慮
        end
        else if(tx_en_clk125&&fcs_cnt!=3'b100)begin
            UDP_d <= {1'b0,data_pipe2[data_pipe_sel2]};
            fcs_cnt <= fcs_cnt + 1;
        end
        else if(tx_en_clk125&&fcs_cnt==3'b100)begin
            delay_tx <= 2'b0;
        end
        else begin
            delay_tx <= 0;
            UDP_d <= 0;
            fcs_cnt <= 0;
        end
    end

    assign UDP_tx = delay_tx[1];


//<-- moikawa add (2018.11.02)
    reg [10:0] txbuf_sel_d2;

    always_ff @(posedge clk125) begin
        txbuf_sel_d2 <= txbuf_sel2;
    end
    assign data_pipe_sel2 = (txbuf_sel_d2[10:6] < 5'd17)? 
                             txbuf_sel_d2[10:6] : 5'd17 ;

    always_ff @(posedge clk125) begin // inserted pipelined stage.
        //for (k=0; k<64; k=k+1) begin
        //  data_pipe[k] <= TXBUF[ (64*k) + txbuf_sel[5:0] ];
        //end
        data_pipe2[0]  <=  TXBUF[ txbuf_sel2[5:0]         ];
        data_pipe2[1]  <=  TXBUF[ txbuf_sel2[5:0] + 64    ];
        data_pipe2[2]  <=  TXBUF[ txbuf_sel2[5:0] + 128   ];
        data_pipe2[3]  <=  TXBUF[ txbuf_sel2[5:0] + 192   ];
        data_pipe2[4]  <=  TXBUF[ txbuf_sel2[5:0] + 256   ];
        data_pipe2[5]  <=  TXBUF[ txbuf_sel2[5:0] + 320   ];
        data_pipe2[6]  <=  TXBUF[ txbuf_sel2[5:0] + 384   ];
        data_pipe2[7]  <=  TXBUF[ txbuf_sel2[5:0] + 448   ];
        data_pipe2[8]  <=  TXBUF[ txbuf_sel2[5:0] + 512   ];
        data_pipe2[9]  <=  TXBUF[ txbuf_sel2[5:0] + 576   ];
        data_pipe2[10] <=  TXBUF[ txbuf_sel2[5:0] + 640   ];
        data_pipe2[11] <=  TXBUF[ txbuf_sel2[5:0] + 704   ];
        data_pipe2[12] <=  TXBUF[ txbuf_sel2[5:0] + 768   ];
        data_pipe2[13] <=  TXBUF[ txbuf_sel2[5:0] + 832   ];
        data_pipe2[14] <=  TXBUF[ txbuf_sel2[5:0] + 896   ];
        data_pipe2[15] <=  TXBUF[ txbuf_sel2[5:0] + 960   ];
        if (txbuf_sel2[5:0] < 6'd22) begin
	       data_pipe2[16] <=  TXBUF[ txbuf_sel2[5:0] + 1024  ];
        end else begin
	       data_pipe2[16] <=  8'h00;
        end
        data_pipe2[17] <= 8'h00;  // dummy value.
    end
//--> moikawa add (2018.11.02)


    /*---ERROR---*/
    always_ff @(posedge eth_rxck)begin
        if(st==ERROR)   trans_err <= 1'b1;
        else            trans_err <= 1'b0;
    end
    
endmodule