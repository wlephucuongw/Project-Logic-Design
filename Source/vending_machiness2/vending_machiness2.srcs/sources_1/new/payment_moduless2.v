`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 09:36:43 PM
// Design Name: 
// Module Name: payment_moduless2
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


module payment_moduless2(
input clk,
input [7:0] total_price,
input [7:0] total_money,
output reg enough_money_flag,
output reg [7:0] remaining_money
    );
 always @(posedge clk) begin
        enough_money_flag = 0;
        if(total_money >= total_price) begin
            enough_money_flag = 1;
            remaining_money = total_money - total_price;
        end
        else begin
            enough_money_flag = 0;
            remaining_money = total_money;
        end
    end
endmodule
