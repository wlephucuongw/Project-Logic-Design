`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 09:35:44 PM
// Design Name: 
// Module Name: check_moduless2
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


module check_moduless2(
input clk,
input [2:0] selected_id,
input [2:0] selected_quantity,
input [2:0] inventory_id,
output reg valid_id,
output reg valid_quantity
    );
always@(posedge clk) begin
    if(selected_id >= 3'b000 && selected_id <= 3'b111) begin
        valid_id <= 1;
    end else begin
        valid_id <= 0;
    end
    if(selected_quantity >= 1 && selected_quantity <= inventory_id) begin
        valid_quantity <= 1;
    end else begin
        valid_quantity <= 0;
    end
end
endmodule
//module check_moduless2(
//    input clk,
//    input [2:0] selected_id,
//    input [2:0] selected_quantity,
//    input [2:0] inventory_id,
//    output reg valid_id,
//    output reg valid_quantity
//);
//always @(posedge clk) begin
//    // Check if the selected_id is within range
//    if (selected_id <= 3'b111) begin
//        valid_id <= 1;
//    end else begin
//        valid_id <= 0;
//    end

//    // Check if the selected_quantity is valid
//    if (selected_quantity >= 3'b001 && selected_quantity <= inventory_id) begin
//        valid_quantity <= 1;
//    end else begin
//        valid_quantity <= 0;
//    end
//end
//endmodule
