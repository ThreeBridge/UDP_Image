`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/16 21:26:20
// Design Name: 
// Module Name: csum_fast
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
// IPヘッダのチェックサム計算を1サイクルで行うためのモジュール
//

module csum_fast(
    /*---INPUT---*/
    data_i,
    dataen_i,
    reset_i,
    /*---OUTPUT---*/
    csum_o
    );
    /*---I/O Declare---*/
    input [7:0] data_i [19:0];
    input       dataen_i;
    input       reset_i;
    
    output [15:0] csum_o;
    
    /*---wire/resister---*/
    reg [16:0] sum;
    
    integer i;
    always_comb begin
        if (reset_i) sum = 17'b0;
        else if (dataen_i) begin
            for (i=0;i<20;i=i+2'd2) begin
                sum = sum + {1'b0,data_i[i],data_i[i+1'b1]};
                sum = sum[15:0] + sum[16];
            end
        end
        else sum = 17'b0;
    end
    
    assign csum_o = (dataen_i) ? sum[15:0] ^ 16'hFF_FF : 16'h55_55;
    
endmodule
