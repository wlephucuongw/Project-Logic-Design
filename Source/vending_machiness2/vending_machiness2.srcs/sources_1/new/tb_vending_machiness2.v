`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 09:09:36 PM
// Design Name: 
// Module Name: tb_vending_machiness2
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


`timescale 1ns / 1ps

module tb_vending_machiness2;

// Khai b�o c�c t�n hi?u ?? k?t n?i v?i m�-?un ch�nh
reg clk;
reg button_pay;
reg button_view;
reg button_select;
reg button_reset;
reg switch_admin;
reg  [7:0] switchs;
wire [3:0] seven_segment1;
wire [3:0] seven_segment2;
wire [3:0] seven_segment3;
wire [3:0] seven_segment4;
wire led;
wire [7:0] lcd_data;
reg lcd_rs, lcd_rw, lcd_en;

// Kh?i t?o m�-?un vending_machine
vending_machiness2 uut (
    .clk(clk),
    .button_pay(button_pay),
    .button_view(button_view),
    .button_select(button_select),
    .button_reset(button_reset),
    .switch_admin(switch_admin),
    .switchs(switchs),
    .seven_segment1(seven_segment1),
    .seven_segment2(seven_segment2),
    .seven_segment3(seven_segment3),
    .seven_segment4(seven_segment4),
    .led(led),
    .lcd_data(lcd_data),
    .lcd_rs(lcd_rs),
    .lcd_rw(lcd_rw),
    .lcd_en(lcd_en)   
);

// T?o xung nh?p
always #5 clk = ~clk;

initial begin
    // Kh?i t?o t�n hi?u
    clk = 0;
    button_view = 1;
    button_select = 1;
    switchs = 7'b0000000;
    button_reset = 1;
    // Gi?i ph�ng reset sau m?t th?i gian ng?n
    
    // M� ph?ng m?t chu?i h�nh ??ng c?a ng??i d�ng

    // 1. Xem s?n ph?m
    #20 button_view = 1;
    #10 button_view = 0;
    
    #20 button_view = 1;
    #10 button_view = 0;
    
    #20 button_view = 1;
    #10 button_view = 0;
    
    
    #20 button_view = 1;
    #10 button_view = 0;
    
    #20 button_view = 1;
    #10 button_view = 0;
    
    #20 button_view = 1;
    #10 button_view = 0;
    

    #20 button_select = 1;
    #10 button_select = 0;
    
    switchs = 7'b0000001; 
    
    #20 button_select = 1;
    #10 button_select = 0;     
    
    switchs = 7'b0000101; 
    
    #20 button_select = 1;
    #10 button_select = 0;
    
    #20 button_select = 1;
    #10 button_select = 0;
    
    #10 switchs = 7'b1111111; 
    
    #30 button_select = 1;
    #10 button_select = 0;
    
    #20 switchs = 7'b0111111;
     
    #10 button_pay = 1;
    #20 button_pay = 0;
  
     #20 button_view = 1;
    #10 button_view = 0;
    
    #20 button_view = 1;
    #10 button_view = 0;
    
    #20 button_view = 1;
    #10 button_view = 0;
    
//      #20 button_admin = 0;
//      #10 button_admin = 1;
        
//        switch = 1; 
        
//    #20 button_select = 0;
//    #10 button_select = 1;
        
//         switch0 = 0; 
//         switch1 = 0;
              
//    #20 button_select = 0;
//    #10 button_select = 1;   
         
//         switch0 = 1; 
//         switch1 = 1;
         
//     #20 button_select = 0;
//    #10 button_select = 1;  
    
//    #20 button_admin = 0;
//      #10 button_admin = 1;
      
//          #20 button_view = 0;
//    #10 button_view = 1;
    
//    #20 button_view = 0;
//    #10 button_view = 1;
    
//    #20 button_view = 0;
//    #10 button_view = 1;
    #100 $finish;
end

endmodule

