`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 12:56:50 PM
// Design Name: 
// Module Name: lcd_controller
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


module lcd_controller(
    input wire clk,             // Clock đầu vào
    input wire [7:0] data,      // Dữ liệu cần hiển thị (8-bit)
    input wire en,              // Tín hiệu kích hoạt
    output reg rs,              // Chọn chế độ: 0 = lệnh, 1 = dữ liệu
    output reg rw,              // Đọc/ghi: 0 = ghi, 1 = đọc
    output reg lcd_en,          // Tín hiệu Enable cho LCD
    output reg [7:0] lcd_data   // Dữ liệu gửi đến LCD
);
reg [2:0] state; // Trạng thái FSM cho việc gửi dữ liệu
localparam IDLE = 3'd0,
           SETUP = 3'd1,
           ENABLE_LCD = 3'd2,
           WAIT_LCD = 3'd3,
           COMPLETE = 3'd4;

reg [15:0] delay_counter; // Bộ đếm delay để đồng bộ với LCD

always @(posedge clk) begin
    case (state)
        IDLE: begin
            lcd_en <= 0;
            if (en) begin
                state <= SETUP;
                lcd_data <= data; // Ghi dữ liệu đầu vào
                rs <= 1;          // Chọn chế độ dữ liệu
                rw <= 0;          // Chế độ ghi
            end
        end

        SETUP: begin
            lcd_en <= 1;          // Bật tín hiệu Enable
            delay_counter <= 0;   // Reset bộ đếm delay
            state <= ENABLE_LCD;
        end

        ENABLE_LCD: begin
            if (delay_counter < 16'd1000) // Delay 1ms (tuỳ thuộc vào tần số clock)
                delay_counter <= delay_counter + 1;
            else begin
                lcd_en <= 0;      // Tắt Enable
                state <= WAIT_LCD;
                delay_counter <= 0;
            end
        end

        WAIT_LCD: begin
            if (delay_counter < 16'd2000) // Thêm delay để đảm bảo LCD xử lý xong
                delay_counter <= delay_counter + 1;
            else
                state <= COMPLETE;
        end

        COMPLETE: begin
            state <= IDLE;        // Quay lại trạng thái ban đầu
        end

        default: state <= IDLE;
    endcase
end

endmodule
