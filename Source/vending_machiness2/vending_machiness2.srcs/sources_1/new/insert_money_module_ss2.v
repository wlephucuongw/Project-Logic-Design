`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 09:40:12 PM
// Design Name: 
// Module Name: insert_money_module_ss2
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


module insert_money_moduless2(
    input clk,
    input [7:0] switchs,
    input enable,
    output reg [7:0] user_money
    );

    always@(posedge clk)begin
    if(enable) begin
        user_money <= switchs;
    end
    end
endmodule
