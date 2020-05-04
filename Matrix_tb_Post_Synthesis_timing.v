`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2020 09:34:33
// Design Name: 
// Module Name: Matrix_tb
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


module Matrix_tb();
reg clk, rst;
reg [31:0] Din;

wire [31:0]Dout;
wire flag;

integer i, j, size = 100;
reg [31:0] alpha = 1;
reg [31:0] beta = 1;

Matrix Mat(clk, Din, Dout, rst, flag);

initial
clk = 1'b1;
always #5 clk = ~clk;


initial
begin
    
    rst = 1;
    Din = alpha;
    #100
    #10

    rst = 0; 
    
    
    #10 Din = beta;
    #10;
    
    for(i = 1; i < size + 1; i = i + 1)
        for(j = 1; j < size + 1; j = j + 1)
                #10 Din = j;
    #10
    for(i = 1; i < size + 1; i = i + 1)
        for(j = 1; j < size + 1; j = j + 1)
                #10 Din = j;
            
    
end

endmodule
