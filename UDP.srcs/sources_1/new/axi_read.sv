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
    input [8:0] sel;
    input       axi_arready;
    input       axi_r;
    
    output      axi_ar;
    output reg  axi_rready;
    
    /*---wire/register---*/
    reg [31:0]  im_buf [249:0];
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
    
    /*---ステートマシン(AR_CH)---*/
    reg [3:0] st_ar;
    reg [3:0] nx_ar;
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
                if (axi_arready) nx_ar = AR_OK;
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
    always_ff @(posedge clk_i)begin
        if(rst) st_r <= IDLE;
        else    st_r <= nx_ar;        
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
                if (axi_r.last) nx_r = REND;
            end
        endcase
    end
    
    /*---AR_CH---*/
    always_ff @(posedge clk_i)begin
        if(st_ar==ARCH)begin
            axi_ar.id       <=  1'b0;
            axi_ar.valid    <=  `HI;
            axi_ar.addr     <=  29'b0 + (8'd250*sel);
            axi_ar.len      <=  8'hF9;
            axi_ar.size     <=  3'b010;
            axi_ar.burst    <=  2'b01;
            axi_ar.lock     <=  2'b0;
            axi_ar.cache    <=  4'b0011;
            axi_ar.prot     <=  3'b0;
            axi_ar.qos      <=  4'b0;
        end
        else if(st_ar==AR_OK)begin
            axi_ar.valid    <=  1'b0;
        end
        else if(st_ar==IDLE)begin
            axi_ar.id       <= 1'b0;
            axi_ar.valid    <= `LO;
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
    
    always_ff @(posedge clk_i)begin
        if(st_ar==AR_OK)    r_ch_st <= `HI;
        else                r_ch_st <= `LO;
    end
    
    /*---R_CH---*/
    always_ff @(posedge clk_i)begin
        if(axi_r.valid)     axi_rready <= `HI;
        else if(axi_r.last) axi_rready <= `LO;
        else                axi_rready <= `LO;
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
    
    integer i;
    always_ff @(posedge clk_i)begin
        if(st_r==READ)begin
            im_buf[rd_cnt] <= axi_r.data;
        end
        else if(st_r==IDLE)begin
            for(i=0;i<8'd250;i=i+1) im_buf[i] <= 32'b0;
        end
    end
    
    
endmodule
