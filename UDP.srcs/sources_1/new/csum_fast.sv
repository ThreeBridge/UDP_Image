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


module csum_fast(
    /*---INPUT---*/
    CLK_i,
    data_i,
    dataen_i,
    reset_i,
    /*---OUTPUT---*/
    csum_o
    );
    /*---I/O Declare---*/
    input       CLK_i;
    input [7:0] data_i [19:0];
    input       dataen_i;
    input       reset_i;
    
    output [15:0] csum_o;
    
    /*---wire/resister---*/
    reg [16:0] sum;
    reg [16:0] buffer;
    
    always_comb begin
        if (reset_i) sum = 17'b0;
    end
    
endmodule
