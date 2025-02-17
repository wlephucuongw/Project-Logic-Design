`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2024 09:39:01 PM
// Design Name: 
// Module Name: insert_price
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


module insert_price(
    input clk,
    input [4:0] switchs,
    input enable,
    output reg [4:0] new_price
    );

    always@(posedge clk)begin
    if(enable) begin
        new_price <= switchs;
    end
    end
endmodule
