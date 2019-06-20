`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/24 16:45:16
// Design Name: 
// Module Name: axi_read
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


module axi_read(
    /*---INPUT---*/
    clk_i,
    rst,
    rd_en,
    sel,
    axi_arready,
    axi_r,
    /*---OUTPUT---*/
    axi_ar,
    axi_rready
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
    }AXI_AR;
    
    typedef struct packed{
        logic [31:0]    data;
        logic [3:0]     strb;
        logic           last;
        logic           valid;
        logic [1:0]     resp;
    }AXI_R;    
    
    /*---I/O Declare---*/
    input       clk_i;
    input       rst;
    input       rd_en;
    input [10:0] sel;
    input       axi_arready;
    input       axi_r;
    
    output      axi_ar;
    output reg  axi_rready;
    
    /*---wire/register---*/
    //reg [31:0]  im_buf [249:0];
    reg         r_ch_st;
    
    AXI_AR      axi_ar;
    AXI_R       axi_r;
    
    /*---parameter---*/
    parameter   IDLE    =   4'h0;
    parameter   ARCH    =   4'h1;
    parameter   AR_OK   =   4'h2;
    
    parameter   STBY    =   4'h3;
    parameter   READ    =   4'h4;
    parameter   REND    =   4'h5;
    
    parameter   transaction_num =   4'd2;   // トランザクションの数(480回連続では送れないため)
    
    /*---ステートマシン(AR_CH)---*/
    reg [3:0] st_ar;
    reg [3:0] nx_ar;
    reg [1:0] transaction_cnt;
    reg [1:0] read_end;
    wire      transaction = (transaction_cnt==(transaction_num));
    wire      archannel_ok = (axi_arready&&axi_ar.valid)&&transaction;
    always_ff @(posedge clk_i)begin
        if(rst) st_ar <= IDLE;
        else    st_ar <= nx_ar;
    end
    
    always_comb begin
        nx_ar = st_ar;
        case (st_ar)
            IDLE : begin
                if (rd_en) nx_ar = ARCH;
            end
            ARCH : begin
                if (archannel_ok) nx_ar = AR_OK;
            end
            AR_OK :begin
                nx_ar = IDLE;
            end
            default : begin
            end
        endcase
    end    
    
    /*---ステートマシン(R_CH)---*/
    reg [3:0] st_r;
    reg [3:0] nx_r;
    wire rdchannel_end = axi_r.last&&(read_end==transaction_num);
    always_ff @(posedge clk_i)begin
        if(rst) st_r <= IDLE;
        else    st_r <= nx_r;        
    end
    
    always_comb begin
        nx_r = st_r;
        case (st_r)
            IDLE : begin
                if (r_ch_st) nx_r = STBY;
            end
            STBY : begin
                if (axi_r.valid) nx_r = READ;
            end
            READ : begin
                if (rdchannel_end) nx_r = REND;
            end
            REND : begin
                nx_r = IDLE;
            end
        endcase
    end
    
    /*---トランザクション数をカウント---*/
    always_ff @(posedge clk_i)begin
        if(st_ar==ARCH)begin
            if(axi_arready&&(transaction_cnt!=2'd2))begin
                transaction_cnt <= transaction_cnt + 2'b1;
            end
        end
        else if(st_ar==IDLE)begin
            transaction_cnt <= 2'b0;
        end
    end    
    
    /*---AR_CH---*/
    always_ff @(posedge clk_i)begin
        if(st_ar==ARCH)begin
            axi_ar.id       <=  1'b0;
            //axi_ar.addr     <=  29'b0 + (10'd1000*sel);
            axi_ar.addr     <=  29'b0+(11'd960*(sel*2+transaction_cnt));
            axi_ar.len      <=  8'd239;
            axi_ar.size     <=  3'b010;
            axi_ar.burst    <=  2'b01;
            axi_ar.lock     <=  2'b0;
            axi_ar.cache    <=  4'b0011;
            axi_ar.prot     <=  3'b0;
            axi_ar.qos      <=  4'b0;
        end
        else if(st_ar==IDLE)begin
            axi_ar.id       <= 1'b0;
            axi_ar.addr     <= 29'b0;
            axi_ar.len      <= 8'h0;
            axi_ar.size     <= 3'b0;
            axi_ar.burst    <= 2'b0;
            axi_ar.lock     <= 2'b0;
            axi_ar.cache    <= 4'b0;
            axi_ar.prot     <= 3'b0;
            axi_ar.qos      <= 4'b0;        
        end
    end
    
    /*--valid--*/
    always_ff @(posedge clk_i)begin
        if(st_ar==ARCH)begin
            if(archannel_ok)begin
                axi_ar.valid <= `LO;
            end
            else begin
                axi_ar.valid <= `HI;
            end
        end
        else if (st_ar==AR_OK)begin
            axi_ar.valid    <= `LO;
        end
        else if (st_ar==IDLE)begin
            axi_ar.valid    <= `LO;
        end
    end    

    
    always_ff @(posedge clk_i)begin
        if(st_ar==AR_OK)    r_ch_st <= `HI;
        else                r_ch_st <= `LO;
    end
    
    /*---R_CH---*/
    always_comb begin
        if(axi_r.valid)     axi_rready <= `HI;
        else                axi_rready <= `LO;
    end
    
    always_ff @(posedge clk_i)begin
        if(st_r==IDLE)begin
            read_end <= 2'b0;
        end
        else begin
            if(axi_r.last)begin
                read_end <= read_end + 2'b1;
            end
        end
    end
    
    reg [8:0] rd_cnt;
    always_ff @(posedge clk_i)begin
        if(st_r==READ)begin
            rd_cnt <= rd_cnt + 9'b1;
        end
        else if(st_r==IDLE)begin
            rd_cnt <= 9'b0;
        end
    end
    
//    integer i;
//    always_ff @(posedge clk_i)begin
//        if(st_r==READ)begin
//            im_buf[rd_cnt] <= axi_r.data;
//        end
//        else if(st_r==IDLE)begin
//            for(i=0;i<8'd250;i=i+1) im_buf[i] <= 32'b0;
//        end
//    end
    
    
endmodule
