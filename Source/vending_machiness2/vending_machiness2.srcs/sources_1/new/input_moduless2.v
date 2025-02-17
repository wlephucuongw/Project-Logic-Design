`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 09:34:44 PM
// Design Name: 
// Module Name: input_moduless2
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


module input_moduless2(
input clk,
input [2:0] switchs,
input enable,
output reg [2:0] id_or_quantity
    );
always @(posedge clk) begin
    if(enable) begin
    id_or_quantity <= switchs;
    end
    end
endmodule
