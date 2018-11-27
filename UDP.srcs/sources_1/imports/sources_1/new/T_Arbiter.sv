`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/04 19:59:37
// Design Name: 
// Module Name: T_Arbiter
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


module T_Arbiter(
    input [8:0] arp_d,
    input [8:0] ping_d,
    input [8:0] UDP_btn_d,
    input [8:0] UDP_d,
    input arp_tx,
    input ping_tx,
    input UDP_btn_tx,
    input UDP_tx,
    input clk125,
    input clk125_90,
    input rst125,
    
    output reg [7:0] txd,
    output reg gmii_txctl,
   
    output reg [7:0] LED
    );
    
parameter Idle      =  8'h00;   // 待機状態
parameter Tx_Pre    =  8'h01;   // プリアンブル送信
parameter Tx_Data   =  8'h02;   // データ送信
parameter Tx_End    =  8'h03;   // 送信終了
    
    /* ステートマシン */
    wire tx_any = (arp_tx || ping_tx || UDP_btn_tx || UDP_tx);
    reg [7:0] st;
    reg [7:0] nx;
    reg       tx_pre;
    reg       tx_data;
    reg       tx_end;
    reg [3:0] pre_cnt;;
    always_ff @(posedge clk125) begin
        if (rst125) st <= Idle;
        else        st <= nx;
    end
    
    always_comb begin
        nx = st;
        case(st)
            Idle : begin
                if(tx_any) nx = Tx_Pre;
            end
            Tx_Pre : begin
                if(pre_cnt==4'd7) nx = Tx_Data;
            end
            Tx_Data : begin
                if(tx_end) nx = Tx_End;
            end
            Tx_End : begin nx = Idle;
            end
        endcase
    end
    
    
    /*-----Queue-----*/
    reg  [8:0] q_din;
    reg        wr_en;
    reg        rd_en;
    wire       full;
    wire       overflow;
    wire       empty;
    wire       valid;
    wire       underflow;
    wire [10:0] data_count;
    wire [8:0] q_dout;
    
    queue TX_queue(
        .clk(clk125),
        .srst(rst125),
        .din(q_din),            // 書き込むデータ [8:0]din = {1'data_frame,8'data}
        .wr_en(wr_en),          // 書き込み開始
        .rd_en(rd_en),          // 読み出し開始
        .dout(q_dout),          // 読み出しデータ
        .full(full),
        .overflow(overflow),    // キューがオーバーフロー
        .empty(empty),          // キュー内が空
        .valid(valid),          // 書き込みflg
        .underflow(underflow),  // キューがアンダーフロー
        .data_count(data_count) // データの数
    );
    /*--書き込み--*/  
    always_comb begin
        if(arp_tx)begin
            wr_en <= arp_tx;
            q_din <= arp_d;
        end
        else if(ping_tx) begin
            wr_en <= ping_tx;
            q_din <= ping_d;
        end
        else if(UDP_btn_tx)begin
            wr_en <= UDP_btn_tx;
            q_din <= UDP_btn_d;
        end
        else if(UDP_tx)begin
            wr_en <= UDP_tx;
            q_din <= UDP_d;
        end
        else wr_en <= 1'b0;
    end
    
    /*--CRC用データ--*/
    reg [7:0] crc_d;
    reg       crc_en;
    always_ff @(posedge clk125)begin
        if(arp_tx)begin
            crc_d <= arp_d[7:0];
            crc_en <= arp_d[8];
        end
        else if(ping_tx)begin
            crc_d <= ping_d[7:0];
            crc_en <= ping_d[8];
        end
        else if(UDP_btn_tx)begin
            crc_d <= UDP_btn_d[7:0];
            crc_en <= UDP_btn_d[8];
        end
        else if(UDP_tx)begin
            crc_d <= UDP_d[7:0];
            crc_en <= UDP_d[8];
        end
        else begin
            crc_d<=0;
            crc_en<=0;
        end
    end
    
    /*----- 送信 -----*/
    reg [7:0] d;       // CRC用
    reg flg;
    reg [9:0] tx_cnt;
    reg txen;
    reg [2:0] fcs_cnt;
    /*--プリアンブル--*/
    always_ff @(posedge clk125)begin
        if(st==Tx_Pre) pre_cnt <= pre_cnt + 1;
        else if(st==Idle) pre_cnt <= 0;        
    end
    /*--読み出し管理(rd_en)--*/
    always_ff @(posedge clk125)begin
        if(pre_cnt==4'd6)begin
            rd_en<=1;
        end
        else if(st==Tx_Data&&fcs_cnt==3'b011) rd_en<=0;
        else if(st==Idle) rd_en <= 0;
    end
    
    /*--送信--*/
    (*dont_touch="true"*) reg [31:0] CRC32;
    always_ff @(posedge clk125)begin
        if(st==Idle) begin
            txd <= `PREAMB;
        end
        else if(st==Tx_Pre)begin
            if(pre_cnt==4'd7) txd<=`SFD;
            else begin
                txd <= `PREAMB;
            end
        end
        else if(st==Tx_Data)begin
            if(q_dout[8])
                txd <= q_dout[7:0];
            else if(!q_dout[8])begin
                txd <= (fcs_cnt==3'b000) ? CRC32[31:24] : (
                            (fcs_cnt==3'b001) ? CRC32[25:16] : (
                                (fcs_cnt==3'b010) ? CRC32[15:8] : CRC32[7:0]
                            )
                       );
        /*--debug--*/
//                txd <= (fcs_cnt==3'b000) ? 8'h01 : (
//                                   (fcs_cnt==3'b001) ? 8'h02 : (
//                                       (fcs_cnt==3'b010) ? 8'h03 : 8'h04
//                                   )
//                              );
            end
        end
    end
    
    /*--txen管理--*/
    always_ff @(posedge clk125)begin
        if(st==Idle)begin
            gmii_txctl <= 0;
            fcs_cnt <= 0;
            tx_end <= 0;
        end
        else if(st==Tx_Pre) begin
            gmii_txctl <= 1;
        end
        else if(st==Tx_Data)begin
            if(!q_dout[8]&&fcs_cnt!=3'b100)begin
                fcs_cnt <= fcs_cnt + 1;
            end
            else if(!q_dout[8]&&fcs_cnt==3'b100)begin
                gmii_txctl <= 0;
                tx_end <= 1;
            end
            else begin
                fcs_cnt <= 0;
            end
        end
    end
    
    /*--CRC計算--*/
    wire [31:0] crc0_reg;
    wire [7:0]  crc0;
    wire crc0_init = !txen;
    reg crc0_valid;
    
    crc_32 Tx_crc_32(
        .crc_reg(crc0_reg),
        .crc(crc0),
        .d(q_dout[7:0]),
        .calc(q_dout[8]),
        .init(crc0_init),
        .d_valid(crc0_valid),
        .clk(clk125),
        .reset(1'b0)
    );
    
    /*--CRC計算2--*/
    reg [31:0] CRC;
    CRC_ge T_crc_ge(
        .d(crc_d),
        .CLK(clk125),
        .reset(crc_en),
        .flg(crc_en),
        .CRC(CRC)
    );
    
    reg [31:0] r_crc;
    always_ff @(posedge clk125) begin
        if(q_dout[8])begin
            r_crc <= ~{CRC[24],CRC[25],CRC[26],CRC[27],CRC[28],CRC[29],CRC[30],CRC[31],
                      CRC[16],CRC[17],CRC[18],CRC[19],CRC[20],CRC[21],CRC[22],CRC[23],
                      CRC[8],CRC[9],CRC[10],CRC[11],CRC[12],CRC[13],CRC[14],CRC[15],
                      CRC[0],CRC[1],CRC[2],CRC[3],CRC[4],CRC[5],CRC[6],CRC[7]};
        end
        else if(st==Idle) r_crc <= 32'b0;
    end
    
    
    reg [1:0] delay_crc_en;
    always_ff @(posedge clk125)begin
        delay_crc_en <= {delay_crc_en[0],crc_en};
    end
    
    always_ff @(posedge clk125)begin
        if(st==Idle) CRC32 <= 0;
        else if(delay_crc_en[1]) CRC32 <= r_crc;
        else if(!delay_crc_en[1]) CRC32 <= CRC32;
        else CRC32 <= 0;
    end
    
    always_ff @(posedge clk125)begin
        if(st==Tx_End)begin
            LED <= LED + 1'd1;
        end
    end
    
endmodule
