`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/27 18:47:57
// Design Name: 
// Module Name: axi_block_rw
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

`include "struct_list.vh"

module axi_block_rw(
    CLK_i,
    rst,
    recv_end,
    axi_arready,
    axi_r,
    axi_awready,
    axi_wready,
    
    axi_ar,
    axi_rready,
    axi_aw
);
    /*---parameter---*/
    parameter   IDLE    =   4'h0;
    parameter   ARCH    =   4'h1;
    parameter   AROK    =   4'h2;

    parameter   READ    =   4'h3;
    parameter   DEAL    =   4'h4;
    parameter   REND    =   4'h5;

    parameter   AWCH    =   4'h6;
    parameter   AWOK    =   4'h7;

    parameter   WCH     =   4'h8;
    parameter   WEND    =   4'h9;

    parameter   transaction_num =   4'd3;   // アドレスが飛ぶため,トランザクションを分ける

    /*---I/O---*/
    input   CLK_i;
    input   rst;
    input   recv_end;
    input   axi_arready;
    input   AXI_R   axi_r;
    input   axi_awready;
    input   axi_wready;

    output  AXI_AR  axi_ar;
    output  axi_rready;
    output  AXI_AW  axi_aw;
    output  AXI_W   axi_w; 

    /* State-Machine(AR_CH) */
    reg [3:0]   st_ar;
    reg [3:0]   nx_ar;
    reg [1:0]   transaction_cnt;
    wire        transaction_end = (transaction_cnt==transaction_num);
    wire        ar_valid = (axi_arready && axi_ar.valid)
    wire        ar_end = ar_valid && transaction_end;
    always_ff @(posedge CLK_i)begin
        if (rst)	st_ar <= IDLE;
        else		st_ar <= nx_ar;
    end
    
    always_comb begin
        nx_ar = st_ar;
        case (st_ar)
            IDLE : begin
                if(recv_end) nx_ar = ARCH;
            end
            ARCH : begin
                if(ar_end) nx_ar = AROK;
            end
            AROK : begin
                nx_ar = IDLE;
            end
            default : begin
            end
        endcase
    end

    /*---トランザクション数をカウント---*/
    always_ff @(posedge CLK_i)begin
        if(st_ar==ARCH)begin
            if (ar_valid)begin
                transaction_cnt <= transaction_cnt + 2'b1;
            end
        end
        else begin
            transaction_cnt <= 2'b0;
        end
    end

    /*---AR_CH---*/
    always_ff @(posedge CLK_i)begin
        if(st_ar==ARCH)begin
            axi_ar.id       <=  1'b0;
            axi_ar.len      <=  8'd2;
            axi_ar.size     <=  3'b010;
            axi_ar.burst    <=  2'b01;
            axi_ar.lock     <=  2'b0;
            axi_ar.cache    <=  4'b0011;
            axi_ar.prot     <=  3'b0;
            axi_ar.qos      <=  4'b0;
        end
        else begin
            axi_ar.id       <= 1'b0;
            axi_ar.len      <= 8'h0;
            axi_ar.size     <= 3'b0;
            axi_ar.burst    <= 2'b0;
            axi_ar.lock     <= 2'b0;
            axi_ar.cache    <= 4'b0;
            axi_ar.prot     <= 3'b0;
            axi_ar.qos      <= 4'b0;              
        end
    end

    /*--x/y count--*/
    reg [5:0] ar_xcount;
    reg [4:0] ar_ycount;
    always_ff @(posedge CLK_i)begin
        if(ar_xcount==6'd46)begin
            ar_xcount <= 6'b0;
        end
        else if(ar_end)begin
            ar_xcount <= ar_xcount + 6'b1;
        end
    end

    always_ff @(posedge CLK_i)begin
        if(ar_ycount==5'd28)begin
            ar_ycount <= 5'b0;
        end
        else if(ar_xcount==6'd46)begin
            ar_ycount <= ar_ycount + 5'b1;
        end
    end

    /*--Address--*/
    wire        addr_reset = rst;
    reg [28:0]  araddr_buff;
    always_ff @(posedge CLK_i)begin
        if(addr_reset)  araddr_buff <= 29'b0;
        else            araddr_buff <= ar_xcount + (ar_ycount<<5 + ar_ycount<<4);
    end
    assign axi_ar.addr = araddr_buff + (transaction_cnt<<5 + transaction_cnt<<4);

    /*--Valid--*/
    always_ff @(posedge CLK_i)begin
        if(st_ar==ARCH)begin
            if(ar_valid)begin
                axi_ar.valid <= `LO;
            end
            else begin
                axi_ar.valid <= `HI;
            end
        end
        else if(st_ar==AROK)begin
            axi_ar.valid <= `LO;
        end
        else if(st_ar==IDLE)begin
            axi_ar.valid <= `LO;
        end
    end

    /* State-Machine(R_CH) */
    reg [3:0] st_r;
    reg [3:0] nx_r;
    reg [3:0] im_cnt;
    always_ff @(posedge CLK_i)begin
        if (rst)	st_r <= IDLE;
        else		st_r <= nx_r;
    end
    
    always_comb begin
        nx_r = st_r;
        case (st_r)
            IDLE : begin
                if(axi_r.valid) nx_r = READ;
            end
            READ : begin
                if(im_cnt==4'd9) nx_r = DEAL;
            end
            DEAL : begin
                nx_r = REND;
            end
            READ : begin
                nx_r = IDLE;
            end
            default : begin
            end
        endcase
    end

    always_ff @(posedge CLK_i)begin
        if(st_r==IDLE)begin
            im_cnt <= 4'b0;
        end
        else if(axi_r.valid)begin
            im_cnt <= im_cnt + 4'b1;
        end
    end

    wire [7:0] dummy    = axi_r.data[31:24];
    wire [7:0] i_blue   = axi_r.data[23:16];
    wire [7:0] i_green  = axi_r.data[15:8];
    wire [7:0] i_red    = axi_r.data[7:0];
    reg  [7:0] image [2:0] [8:0];
    always_ff @(posedge CLK_i)begin
        if(axi_r.valid)begin
            image[0][im_cnt] <= i_blue;
            image[1][im_cnt] <= i_green;
            image[2][im_cnt] <= i_red;
        end
    end

    reg [7:0] value [2:0];
    integer i;
    always_ff @(posedge CLK_i)begin
        if(st_r==DEAL)begin
            for(i=0;i<9;i=i+1)begin
                value[0] <= value[0] + (image[0][i] / 9);   // blue
                value[1] <= value[1] + (image[1][i] / 9);   // green
                value[2] <= value[2] + (image[2][i] / 9);   // red
            end
        end
    end

    always_comb begin
        if(axi_r.valid)     axi_rready <= `HI;
        else                axi_rready <= `LO;
    end

    /*--Read_End--*/
    reg r_end;
    always_ff @(posedge CLK_i)begin
        if(st_r==REND)begin
            r_end <= 1'b1;
        end
        else begin
            r_end <= 1'b0;
        end
    end

    /*---AW_CH---*/
    /* State-Machine */
    reg [3:0]   st_aw;
    reg [3:0]   nx_aw;
    wire        aw_valid = axi_awready&&axi_aw.valid;
    always_ff @(posedge CLK_i)begin
        if (rst)	st_aw <= IDLE;
        else		st_aw <= nx_aw;
    end
    
    always_comb begin
        nx_aw = st_aw;
        case (st_aw)
            IDLE : begin
                if(ar_end) nx_aw = AWCH;
            end
            AWCH : begin
                if(aw_valid) nx_aw = AWOK;
            end
            AWOK : begin
                nx_aw = IDLE;
            end
            default : begin
            end
        endcase
    end

    /*---AW_CH signal---*/
    always_ff @(posedge CLK_i)begin
        if (st_aw==AWCH)begin
            axi_aw.id       <= 1'b0;
            axi_aw.len      <= 8'b0;
            axi_aw.size     <= 3'b010;
            axi_aw.burst    <= 2'b01;
            axi_aw.lock     <= 2'b0;
            axi_aw.cache    <= 4'b0011;
            axi_aw.prot     <= 3'b0;
            axi_aw.qos      <= 4'b0;
        end
        else if (st_aw==IDLE)begin
            axi_aw.id       <= 1'b0;
            axi_aw.len      <= 8'h0;
            axi_aw.size     <= 3'b0;
            axi_aw.burst    <= 2'b0;
            axi_aw.lock     <= 2'b0;
            axi_aw.cache    <= 4'b0;
            axi_aw.prot     <= 3'b0;
            axi_aw.qos      <= 4'b0;
        end
    end

    /*--x/y count--*/
    reg [5:0] aw_xcount;
    reg [4:0] aw_ycount;
    always_ff @(posedge CLK_i)begin
        if(aw_xcount==6'd46)begin
            aw_xcount <= 6'b0;
        end
        else if(ar_end)begin
            aw_xcount <= aw_xcount + 6'b1;
        end
    end

    always_ff @(posedge CLK_i)begin
        if(aw_ycount==5'd28)begin
            aw_ycount <= 5'b0;
        end
        else if(aw_xcount==6'd46)begin
            aw_ycount <= aw_ycount + 5'b1;
        end
    end

    /*--Address--*/
    wire        aw_addr_reset = rst;
    reg [28:0]  awaddr_buff;
    always_ff @(posedge CLK_i)begin
        if(aw_addr_reset)   awaddr_buff <= 29'b0;
        else                awaddr_buff <= aw_xcount  + 49 + (aw_ycount<<5 + aw_ycount<<4);
    end
    assign axi_ar.addr = awsaddr_buff;

    /*--Valid--*/
    always_ff @(posedge CLK_i)begin
        if(st_aw==AWCH)begin
            if(ar_valid)begin
                axi_aw.valid <= `LO;
            end
            else begin
                axi_aw.valid <= `HI;
            end
        end
        else if (st_aw==AW_OK)begin
            axi_aw.valid    <= `LO;
        end
        else if (st_aw==IDLE)begin
            axi_aw.valid    <= `LO;
        end
    end

    /*---W_CH---*/
    /* State-Machine */
    reg [3:0]   st_w;
    reg [3:0]   nx_w;
    wire        w_valid = axi_w.valid && axi_wready;
    always_ff @(posedge CLK_i)begin
        if (rst)	st_w <= IDLE;
        else		st_w <= nx_w;
    end
    
    always_comb begin
        nx_w = st_w;
        case (st_w)
            IDLE : begin
                if(r_end) nx_w = WCH;
            end
            WCH : begin
                if(w_valid) nx_w = WEND;
            end
            WEND : begin
                nx_w = IDLE;
            end
            default : begin
            end
        endcase
    end

    /*--strb--*/
    always_ff @(posedge CLK_i)begin
        if(st_w==WCH)begin
            axi_w.strb <= 4'hF;
        end
        else begin
            axi_w.strb <= 4'h0;
        end
    end

    /*--valid--*/
    always_ff @(posedge CLK_i)begin
        if(st_w==WCH)begin
            if(w_valid)begin
                axi_w.valid <= 1'b0;
            end
            else begin
                axi_w.valid <= 1'b1;
            end
        end
        else begin
            axi_w.valid <= 1'b0;
        end
    end

    /*--data--*/
    always_ff @(posedge CLK_i)begin
        axi_w.data <= {8'h55,value[0],value[1],value[2]};
    end

    /*--last--*/
    always_ff @(posedge CLK_i)begin
        if(st_w==WCH)begin
            if(w_valid)begin
                axi_w.last <= 1'b0;
            end
            else begin
                axi_w.last <= 1'b1;
            end
        end
        else begin
            axi_w.last <= 1'b0;
        end
    end

endmodule