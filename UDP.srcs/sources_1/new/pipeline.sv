`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/19 18:05:59
// Design Name: 
// Module Name: pipeline
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
// 複数のもの(1,000バイト以上)から一つを選択するという負荷の高い処理を 
// パイプラインを用いて軽減する
//////////////////////////////////////////////////////////////////////////////////


module pipeline(
    /*---INPUT---*/
    i_CLK,
    Buffer,
    buf_select,
    /*---OUTPUT---*/
    data
    );
    
    /*---Parameter*/
    parameter   BUF_MAX     =   12'd1088;
    parameter   pipe_MAX    =   5'd17;
    
    /*---I/O Declare*/
    input           i_CLK;
    input   [7:0]   Buffer  [BUF_MAX-1:0];
    input   [10:0]  buf_select;
    
    output  [7:0]   data;
    
    /*---wire/resister---*/
    wire    [10:0]  buf_sel = buf_select;
    wire    [4:0]   data_pipe_sel;
    
    reg [10:0]  buf_sel_d;
    reg [7:0]   data_pipe [pipe_MAX:0]; // part of pipelined selector from Buffer[].

    always_ff @(posedge i_CLK)begin
        buf_sel_d <= buf_sel;
    end

    assign data_pipe_sel = (buf_sel_d[10:6] < pipe_MAX)? 
                            buf_sel_d[10:6] : pipe_MAX ;

    always_ff @(posedge i_CLK) begin // inserted pipelined stage.
        data_pipe[0]  <=  Buffer[ buf_sel[5:0]         ];
        data_pipe[1]  <=  Buffer[ buf_sel[5:0] + 64    ];
        data_pipe[2]  <=  Buffer[ buf_sel[5:0] + 128   ];
        data_pipe[3]  <=  Buffer[ buf_sel[5:0] + 192   ];
        data_pipe[4]  <=  Buffer[ buf_sel[5:0] + 256   ];
        data_pipe[5]  <=  Buffer[ buf_sel[5:0] + 320   ];
        data_pipe[6]  <=  Buffer[ buf_sel[5:0] + 384   ];
        data_pipe[7]  <=  Buffer[ buf_sel[5:0] + 448   ];
        data_pipe[8]  <=  Buffer[ buf_sel[5:0] + 512   ];
        data_pipe[9]  <=  Buffer[ buf_sel[5:0] + 576   ];
        data_pipe[10] <=  Buffer[ buf_sel[5:0] + 640   ];
        data_pipe[11] <=  Buffer[ buf_sel[5:0] + 704   ];
        data_pipe[12] <=  Buffer[ buf_sel[5:0] + 768   ];
        data_pipe[13] <=  Buffer[ buf_sel[5:0] + 832   ];
        data_pipe[14] <=  Buffer[ buf_sel[5:0] + 896   ];
        data_pipe[15] <=  Buffer[ buf_sel[5:0] + 960   ];
        if (buf_sel[5:0] < 6'd22) begin
	       data_pipe[16] <=  Buffer[ buf_sel[5:0] + 1024  ];
        end else begin
	       data_pipe[16] <=  8'h00;
        end
        data_pipe[17] <= 8'h00;  // dummy value.
    end


endmodule
