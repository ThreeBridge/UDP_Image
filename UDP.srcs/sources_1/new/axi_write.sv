`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/24 16:45:16
// Design Name: 
// Module Name: axi_write
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


module axi_write(
    /*---INPUT---*/
    clk_i,
    rst,
    wea,
    data_i,
    udp_flg,
    packet_cnt,
    UDP_st,
    
    axi_awready,
    axi_wready,
    
    /*---OUTPUT---*/
    axi_aw,
    axi_w
    
    );
    /*---STRUCT---*/
    typedef struct packed{
        logic           id;
        logic [28:0]    addr;
        logic [7:0]     len;
        logic [2:0]     size;
        logic [1:0]     burst;
        logic           lock;
        logic [3:0]     cache;
        logic [2:0]     prot;
        logic [3:0]     qos;
        logic           valid;    
    }AXI_AW;
    
    typedef struct packed{
        logic [31:0]    data;
        logic [3:0]     strb;
        logic           last;
        logic           valid;  
    }AXI_W;
    
    /*---I/O Declare---*/
    input       clk_i;
    input       rst;
    input       wea;
    input [7:0] data_i;
    input       udp_flg;
    input [8:0] packet_cnt;
    input       UDP_st;
    
    input       axi_awready;
    input       axi_wready;
    
    output      axi_aw;
    output      axi_w;
    
    /*---signal---*/
    reg         w_ch_st;    // Write Transaction start
    reg [7:0]   write_cnt;
    reg         fifo_sel=0;
    
    AXI_AW      axi_aw;
    AXI_W       axi_w;
    
    
    /*---parameter---*/
    parameter   IDLE    =   4'h0;
    parameter   AWCH    =   4'h1;
    parameter   AW_OK   =   4'h2;
    
    parameter   STBY    =   4'h3;
    parameter   WCH     =   4'h4;
    parameter   WEND    =   4'h5;
    
    /*---ステートマシン(AW_CH)---*/
    reg [3:0] st_aw;
    reg [3:0] nx_aw;
    always_ff @(posedge clk_i)begin
        if(rst) st_aw <= IDLE;
        else    st_aw <= nx_aw;
    end
    
    always_comb begin
        nx_aw = st_aw;
        case (st_aw)
            IDLE : begin
                if (udp_flg) nx_aw = AWCH;
            end
            AWCH : begin
                if (axi_awready) nx_aw = AW_OK;
            end
            AW_OK :begin
                nx_aw = IDLE;
            end
            default : begin
            end
        endcase
    end
    
    /*---ステートマシン(W_CH)---*/
    reg [3:0] st_w;
    reg [3:0] nx_w;
    always_ff @(posedge clk_i)begin
        if(rst) st_w <= IDLE;
        else    st_w <= nx_w;
    end
    
    always_comb begin
        nx_w = st_w;
        case (st_w)
            IDLE : begin
                if (w_ch_st) nx_w = STBY;
            end
            STBY : begin
                if (UDP_st) nx_w = WCH;
            end
            WCH : begin
                if (write_cnt==8'd250) nx_w = WEND;
            end
            WEND : begin
                nx_w = IDLE;
            end
            default : begin
            end
        endcase
    end
    
    
    always_ff @(posedge clk_i)begin
        if(st_aw==AW_OK)begin
            w_ch_st <= `HI;
        end
        else begin
            w_ch_st <= `LO;
        end
    end
    
    
    always_ff @(posedge clk_i)begin
        if (st_aw==AWCH)begin
            axi_aw.id       <= 1'b0;
            axi_aw.valid    <= `HI;
            axi_aw.addr     <= 29'b0+(8'd250*packet_cnt);
            axi_aw.len      <= 8'hF9;
            axi_aw.size     <= 3'b010;
            axi_aw.burst    <= 2'b01;
            axi_aw.lock     <= 2'b0;
            axi_aw.cache    <= 4'b0011;
            axi_aw.prot     <= 3'b0;
            axi_aw.qos      <= 4'b0;
        end
        else if (st_aw==AW_OK)begin
            axi_aw.valid    <= 1'b0;
        end
        else if (st_aw==IDLE)begin
            axi_aw.id       <= 1'b0;
            axi_aw.valid    <= `LO;
            axi_aw.addr     <= 29'b0;
            axi_aw.len      <= 8'h0;
            axi_aw.size     <= 3'b0;
            axi_aw.burst    <= 2'b0;
            axi_aw.lock     <= 2'b0;
            axi_aw.cache    <= 4'b0;
            axi_aw.prot     <= 3'b0;
            axi_aw.qos      <= 4'b0;        
        end
    end
    
    /*---8to32 FIFO---*/
    logic [7:0] data0;
    logic [7:0] data1;
    logic       wr_en0;
    logic       wr_en1;
    
    always_comb begin
        if(packet_cnt[0]==1'b0)begin
            data0 = data_i;
        end
        else begin
            data1 = data_i;
        end
    end
    
    always_comb begin
        if(packet_cnt[0]==1'b0)begin
            wr_en0 = wea;
        end
        else begin
            wr_en1 = wea;
        end
    end
    
    reg rd_en0;
    reg rd_en1;
    always_ff @(posedge clk_i)begin
        if(st_w==WCH)begin
            if(!fifo_sel)   rd_en0 <= `HI;
            else            rd_en1 <= `HI;
        end
        else if(st_w==WEND)begin
             rd_en0 <= 1'b0;
             rd_en1 <= 1'b0;       
        end
        else if(st_w==IDLE)begin
            rd_en0 <= 1'b0;
            rd_en1 <= 1'b0;
        end
    end
    
    logic [31:0] d_out0;
    logic [31:0] d_out1;
    
    always_ff @(posedge clk_i)begin
        if(st_w==WCH)begin
            axi_w.data  <= (!fifo_sel) ? d_out0 : d_out1;
            axi_w.strb  <= 4'hF;
            axi_w.valid <= `HI;
        end
        else if(st_w==IDLE)begin
            axi_w.data  <= 32'b0;
            axi_w.strb  <= 4'h0;
            axi_w.valid <= `LO;            
        end
    end

    always_ff @(posedge clk_i)begin
        if(st_w==WCH)begin
            write_cnt <= write_cnt + 8'b1;
        end
        else if(st_w==IDLE)begin
            write_cnt <= 8'b0;
        end
    end
    
    always_ff @(posedge clk_i)begin
        if(st_w==WCH)begin
            if(write_cnt==8'd250)   axi_w.last <= `HI;
            else                    axi_w.last <= `LO;
        end
        else if(st_w==IDLE)begin
            axi_w.last <= `LO;
        end
    end
    
    always_ff @(posedge clk_i)begin
        if(st_w==WEND) fifo_sel <= fifo_sel + 1'b1;
    end
    
    image_8to32 image_8to32_0(
        .clk        (clk_i),
        .srst       (rst),
        .din        (data0),
        .wr_en      (wr_en0),
        .rd_en      (rd_en0),
        .dout       (d_out0),
        .full       (),
        .overflow   (),
        .empty      (),
        .valid      (),
        .underflow  ()
    );

    image_8to32 image_8to32_1(
        .clk        (clk_i),
        .srst       (rst),
        .din        (data1),
        .wr_en      (wr_en1),
        .rd_en      (rd_en1),
        .dout       (d_out1),
        .full       (),
        .overflow   (),
        .empty      (),
        .valid      (),
        .underflow  ()
    );    
    
    
endmodule
