`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 09:36:02 PM
// Design Name: 
// Module Name: calculate_moduless2
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


module calculate_moduless2(
input [2:0] selected_quantity,
input [4:0] price_id,
output reg [7:0] total_price
    );
always@(*) begin
        total_price = price_id*selected_quantity;
    end
endmodule
