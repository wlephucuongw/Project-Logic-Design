`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 07:03:21 PM
// Design Name: 
// Module Name: vending_machiness2
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


module vending_machiness2(
    input clk,
    input button_pay, 
    input button_view, 
    input button_select, 
    input button_reset,
    input switch_admin,
    input  [7:0 ] switchs,  
    output reg [3:0] seven_segment1, 
    output reg [3:0] seven_segment2,
    output reg [3:0] seven_segment3,
    output reg [3:0] seven_segment4,
    output reg [3:0] led,    
    output reg [7:0] lcd_data, // Data to be sent to LCD
    output reg rs, 
    output reg en
    //output rw    // Control signals for L
);

    reg [2:0] selected_id;
    reg [2:0] selected_quantity;
    wire [2:0] id;
    wire [2:0] quantity; 
     
     
    wire [2:0] admin_id;
    wire [2:0] admin_quantity; 
    reg [2:0] id_for_update;
    reg [2:0] new_quantity;
    wire [4:0] admin_price; 
    reg  [4:0] new_price;
  
    
    wire valid_id;
    wire valid_quantity;
    
    wire [7:0] sum_price;
    reg [7:0] total_price;  
    
    wire [7:0] user_money;
    reg [7:0] total_money;
    
    wire enough_money_flag;
    
    wire [7:0] remaining_money;
    reg  [7:0] change;
    
    reg [2:0] product_inventory [0:7];
    reg [4:0] product_price [0:7];
    reg [13:0] state;
    reg [2:0] current_product; 
    reg [31:0] delay_counter;
    
    
    reg [18:0] delay_lcd;
    reg [7:0]data_rom[37:0];
    integer data_pos;
    
//    reg [7:0] lcd_data;
//    reg lcd_rs, lcd_rw, lcd_en;
//    wire [7:0] data_to_lcd;
    
    localparam IDLE = 14'b01000000000000;
    localparam SELECT_ID = 14'b00000000000001;
    localparam SELECT_QUANTITY = 14'b00000000000010;
    localparam CHECK_ID = 14'b00100000000000;
    localparam CHECK_QUANTITY = 14'b00010000000000;
    localparam CALCULATE = 14'b00001000000000;
    localparam PAYMENT = 14'b00000000000100;
    localparam DELIVERY = 14'b00000100000000;
    localparam ERROR = 14'b00000010000000;   
    localparam ADMIN_UPDATE_ID = 14'b00000000001000; 
    localparam ADMIN_UPDATE_QUANTITY = 14'b00000000010000;
    localparam ADMIN_UPDATE_PRICE = 14'b00000000100000;
    localparam INSERT_MONEY = 14'b00000001000000;   
    localparam RETURN_MONEY = 14'b10000001000000;
    
//        function [6:0] seven_segment_encode;
//        input [3:0] value;
//        case (value)
//            4'd0: seven_segment_encode = 7'b1000000;  // S? 0
//            4'd1: seven_segment_encode = 7'b1111001;  // S? 1
//            4'd2: seven_segment_encode = 7'b0100100;  // S? 2
//            4'd3: seven_segment_encode = 7'b0110000;  // S? 3
//            4'd4: seven_segment_encode = 7'b0011001;  // S? 4
//            4'd5: seven_segment_encode = 7'b0010010;  // S? 5
//            4'd6: seven_segment_encode = 7'b0000010;  // S? 6
//            4'd7: seven_segment_encode = 7'b1111000;  // S? 7
//            4'd8: seven_segment_encode = 7'b0000000;  // S? 8
//            4'd9: seven_segment_encode = 7'b0010000;  // S? 9
//            default: seven_segment_encode = 7'b0001110; // T?t LED
//        endcase
//    endfunction
    
    initial begin
        product_inventory[3'b000] = 3'd5;
        product_inventory[3'b001] = 3'd5;
        product_inventory[3'b010] = 3'd5;
        product_inventory[3'b011] = 3'd5;
        product_inventory[3'b100] = 3'd5;
        product_inventory[3'b101] = 3'd5;
        product_inventory[3'b110] = 3'd5;
        product_inventory[3'b111] = 3'd5;
          
        product_price[3'b000] = 5'd5;
        product_price[3'b001] = 5'd10; 
        product_price[3'b010] = 5'd15; 
        product_price[3'b011] = 5'd20; 
        product_price[3'b100] = 5'd25; 
        product_price[3'b101] = 5'd30;
        product_price[3'b110] = 5'd30; 
        product_price[3'b111] = 5'd30; 
        
        current_product = 3'b000;  
        state = IDLE;
        delay_counter = 0;
        change = 8'd0;
        selected_id = 3'b000;
        selected_quantity = 3'b000;
        new_price =5'b00000;
        id_for_update = 3'b000;
        new_quantity = 3'b000;
        total_money = 8'b00000000;
        total_price = 8'b00000000;
        change = 8'b00000000;
    end
//    reg [7:0] state_name [0:13]; // Mảng lưu chuỗi tên trạng thái
//initial begin
//    state_name[IDLE]              = "IDLE";
//    state_name[SELECT_ID]         = "SELECT_ID";
//    state_name[SELECT_QUANTITY]   = "SELECT_QTY";
//    state_name[CHECK_ID]          = "CHECK_ID";
//    state_name[CHECK_QUANTITY]    = "CHECK_QTY";
//    state_name[CALCULATE]         = "CALCULATE";
//    state_name[PAYMENT]           = "PAYMENT";
//    state_name[DELIVERY]          = "DELIVERY";
//    state_name[ERROR]             = "ERROR";
//    state_name[ADMIN_UPDATE_ID]   = "ADMIN_ID";
//    state_name[ADMIN_UPDATE_QUANTITY] = "ADMIN_QTY";
//    state_name[ADMIN_UPDATE_PRICE]    = "ADMIN_PRC";
//    state_name[INSERT_MONEY]      = "INSERT_MNY";
//    state_name[RETURN_MONEY]      = "RETURN_MNY";
//end
    
    
    input_moduless2 input_handle_id(.clk(clk), .switchs(switchs[2:0]),
    .enable(state[0]),
    .id_or_quantity(id)
    );
    
    input_moduless2 input_handle_quantity(.clk(clk), .switchs(switchs[5:3]),
    .enable(state[1]), 
    .id_or_quantity(quantity)
    );
    
     input_moduless2 input_handle_admin_update_id(.clk(clk), .switchs(switchs[2:0]),
    .enable(state[3]), 
    .id_or_quantity(admin_id)
    );
    
    input_moduless2 input_handle_admin_update_quantity(.clk(clk), .switchs(switchs[5:3]),
    .enable(state[4]), 
    .id_or_quantity(admin_quantity)
    );
    
    
    check_moduless2 check(.clk(clk), .selected_id(selected_id), 
                       .selected_quantity(selected_quantity),
                       .inventory_id(product_inventory[selected_id]),
                       .valid_id(valid_id),
                       .valid_quantity(valid_quantity));
                       
     calculate_moduless2 calculate(.selected_quantity(selected_quantity),
                               .price_id(product_price[selected_id]),
                               .total_price(sum_price));
                               
     insert_money_moduless2 insert_money(.clk(clk), .switchs(switchs),
     .enable(state[6]),
     .user_money(user_money)
     );
     
//      insert_money_moduless2 insert_money_admin_update_price(.clk(clk), .switchs(switchs),
//     .enable(state[5]),
//     .user_money_or_new_price(admin_price)
//     );
        insert_price insert_price_admin(.clk(clk), .switchs(switchs[4:0]), .enable(state[5]),
        .new_price(admin_price)
        );
     
    payment_moduless2 payment(.clk(clk), .total_price(total_price),
    .total_money(total_money),
    .enough_money_flag(enough_money_flag),
    .remaining_money(remaining_money)
    );         
    
//    lcd_controller lcd_inst (
//    .clk(clk),
//    .data(data_to_lcd), // Dữ liệu cần hiển thị
//    .rs(lcd_rs),
//    .rw(lcd_rw),
//    .lcd_en(lcd_en),
//    .lcd_data(lcd_data)
//    );                
     
    reg button_view_prev;
    reg button_select_prev;
    reg button_pay_prev;
    reg button_reset_prev; 
    
//    always@(posedge clk) begin
//        if(button_reset_prev && !button_reset) begin    
//        state <= IDLE;
//        current_product <= 3'b000;
//        end
//    end
    
    
    
    //assign rw=1'b0;
    
    always @(posedge clk) begin
        delay_lcd<=delay_lcd+1;
        if (delay_lcd<50000) begin
           
            en<=1'b1;
            lcd_data<=data_rom[data_pos];
        end
        else begin 
            if (delay_lcd>=50000 && delay_lcd<250000) begin
//                delay_lcd<=delay_lcd+1;
                en<=1'b0;
            end
            else if (delay_lcd==250000) begin
                delay_lcd<=0;
                data_pos<=data_pos+1;
            end
        end
        if (data_pos<5) begin
            rs<=1'b0;
        end
        else if (data_pos>=5 && data_pos<21) begin
            rs<=1'b1;
        end
        else if (data_pos==21) begin
            rs<=1'b0;
        end
        else if (data_pos>21 && data_pos <38) begin
            rs<=1'b1;
        end
        else if (data_pos>=38) begin
            data_pos<=4;
        end
    end
    
    
    always @(posedge clk ) begin
        button_view_prev <= button_view;
        button_select_prev <= button_select;
        button_pay_prev <= button_pay;
        button_reset_prev <= button_reset;
            case(state)
                IDLE: begin
                    led <= 4'b0000;
//                    seven_segment1 <= seven_segment_encode(current_product);
//                    seven_segment2 <= seven_segment_encode(product_inventory[current_product]);
//                    seven_segment3 <= seven_segment_encode(product_price[current_product] / 10);  
//                    seven_segment4 <= seven_segment_encode(product_price[current_product] % 10); 
                    delay_counter <= 0;
                    data_rom[0]<= 8'h38;
                    data_rom[1]<=8'h0c;
                    data_rom[2]<=8'h06;
                    data_rom[3]<=8'h01;
                    data_rom[4]<=8'h80;
                    data_rom[5]<=8'h49;//I
                    data_rom[6]<=8'h44;//D
                    data_rom[7]<=8'h3a;//:
                    data_rom[8]<=8'h20;
                    data_rom[9]<=8'h30+current_product;
                    data_rom[10]<=8'h20;
                    data_rom[11]<=8'h20;
                    data_rom[12]<=8'h20;
                    data_rom[13]<="S";
                    data_rom[14]<="L";
                    data_rom[15]<=":";
                    data_rom[16]<=8'h20;
                    data_rom[17]<=8'h30+product_inventory[current_product];
                    data_rom[18]<=8'h20;
                    data_rom[19]<=8'h20;
                    data_rom[20]<=8'h20;
                    data_rom[21]<=8'hc0;
                    data_rom[31]<=8'h20;
                    data_rom[22]<="P";
                    data_rom[23]<="R";
                    data_rom[24]<="I"; 
                    data_rom[25]<="C";
                    data_rom[26]<="E";  
                    data_rom[27]<=":";
                    data_rom[28]<=" ";
                    data_rom[29]<=(product_price[current_product] / 4'd10)+8'h30;
                    data_rom[30]<=( product_price[current_product] % 4'd10)+8'h30;
                    data_rom[32]<=" ";                    
                    data_rom[33]<=" ";                                   
                    data_rom[34]<=" ";
                    data_rom[35]<=" ";
                    data_rom[36]<=" ";
                    data_rom[37]<=" ";
//                    data_rom[38]<=" ";                                        
                   seven_segment1 <= current_product;
                    seven_segment2 <= product_inventory[current_product];
                     seven_segment3 <= product_price[current_product] / 4'd10;  
                    seven_segment4 <= product_price[current_product] % 4'd10; 
                
                    if (button_view_prev && !button_view) begin
                        current_product <= current_product + 1;
                        if (current_product == 3'b111) begin
                            current_product <= 3'b000;  
                        end
                    end
                    
                    if (button_select_prev && !button_select) begin
                        state <= SELECT_ID;  
                    end
                    
                    if(switch_admin) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                    if(button_reset_prev && !button_reset) begin    
                        state <= IDLE;
                        current_product <= 3'b000;
                    end
                end
                
                SELECT_ID: begin
//                    seven_segment1 <= seven_segment_encode(4'd0);
//                    seven_segment2 <= seven_segment_encode(4'd0);
//                    seven_segment3 <= seven_segment_encode(4'd0);  
//                    seven_segment4 <= seven_segment_encode(selected_id);
                    led <= 4'b0001;
                    selected_id <= id;
                    seven_segment1 <= 4'd0;
                    seven_segment2 <= 4'd0;
                    seven_segment3 <= 4'd0;  
                    seven_segment4 <= selected_id; 
                    data_rom[5]<=8'h20;//I
                    data_rom[6]<="S";//D
                    data_rom[7]<="E";//:
                    data_rom[8]<="L";
                    data_rom[9]<="E";
                    data_rom[10]<="C";
                    data_rom[11]<="T";
                    data_rom[12]<=" ";
                    data_rom[13]<="I";
                    data_rom[14]<="D";
                    data_rom[15]<=":";
                    data_rom[16]<=8'h20;
                    data_rom[17]<=8'h30+selected_id;
                    data_rom[18]<=8'h20;
                    data_rom[19]<=8'h20;
                    data_rom[20]<=8'h20;
                    data_rom[21]<=8'hc0;
                    data_rom[22]<=8'h20;
                    data_rom[23]<=8'h20;
                    data_rom[24]<=8'h20;
                    data_rom[25]<=8'h20; 
                    data_rom[26]<=8'h20;
                    data_rom[27]<=8'h20;  
                    data_rom[28]<=8'h20;
                    data_rom[29]<=8'h20;
                    data_rom[30]<=8'h20;
                    data_rom[31]<=8'h20;
                    data_rom[32]<=" ";                    
                    data_rom[33]<=" ";                                   
                    data_rom[34]<=" ";
                    data_rom[35]<=" ";
                    data_rom[36]<=" ";
                    data_rom[37]<=" ";
                    if (button_select_prev && !button_select) begin
                        state <= CHECK_ID;  
                    end
                    
                    if(switch_admin) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                    if (button_view_prev && !button_view) begin
                        state <= IDLE;
                    end
                    if(button_reset_prev && !button_reset) begin    
                        state <= IDLE;
                        current_product <= 3'b000;
                    end
                end
                
                 SELECT_QUANTITY: begin
//                    seven_segment1 <= seven_segment_encode(4'd0);
//                    seven_segment2 <= seven_segment_encode(4'd0);
//                    seven_segment3 <= seven_segment_encode(4'd0);  
//                    seven_segment4 <= seven_segment_encode(selected_quantity);
                    led <= 4'b0011;
                    selected_quantity <= quantity;
                    
                    seven_segment1 <= selected_id;
                    seven_segment2 <= 4'd0;
                    seven_segment3 <= 4'd0;  
                    seven_segment4 <= selected_quantity; 
                    data_rom[5]<=8'h20;//I
                    data_rom[6]<="Q";//D
                    data_rom[7]<="U";//:
                    data_rom[8]<="A";
                    data_rom[9]<="N";
                    data_rom[10]<="T";
                    data_rom[11]<="I";
                    data_rom[12]<="T";
                    data_rom[13]<="Y";
                    data_rom[14]<=":";
                    data_rom[15]<=" ";
                    data_rom[16]<=8'h30+selected_quantity;
                    data_rom[17]<=8'h20;
                    data_rom[18]<=8'h20;
                    data_rom[19]<=8'h20;
                    data_rom[20]<=8'h20;
                    if (button_select_prev && !button_select) begin
                        state <= CHECK_QUANTITY;  
                    end
                    
                    if(switch_admin) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                    
                    if(button_reset_prev && !button_reset) begin    
                        state <= IDLE;
                        current_product <= 3'b000;
                    end
                    if (button_view_prev && !button_view) begin
                        state <= SELECT_ID;
                    end
                end       
                        
                CHECK_ID: begin
                    seven_segment1 <= 4'd0;
                    seven_segment2 <= 4'd0;
                    seven_segment3 <= 4'd0;  
                    seven_segment4 <= selected_id;
                    if (valid_id) begin
                        state <= SELECT_QUANTITY;  
                    end else begin
                        state <= ERROR;  
                    end
                    
                end
                 CHECK_QUANTITY: begin
//                    seven_segment1 <= selected_id;
//                    seven_segment2 <= 4'd0;
//                    seven_segment3 <= 4'd0;  
//                    seven_segment4 <= selected_quantity; 
                    if(valid_quantity) begin
                        state <= CALCULATE;
                    end else begin
                        state <= ERROR;
                    end
       
                end
                CALCULATE: begin
//                    seven_segment1 <= seven_segment_encode(4'd0);
//                    seven_segment2 <= seven_segment_encode(4'd0);
//                    seven_segment3 <= seven_segment_encode(total_price / 10);  
//                    seven_segment4 <= seven_segment_encode(total_price % 10);  
                    total_price <= sum_price;
                    seven_segment1 <= 4'd0;
                    seven_segment2 <= total_price / 100;
                    seven_segment3 <= (total_price % 100) / 10;  
                    seven_segment4 <= total_price % 10; 
                     
                    data_rom[5]<="T";//D
                    data_rom[6]<="O";//:
                    data_rom[7]<="T";
                    data_rom[8]<="A";
                    data_rom[9]<="L";
                    data_rom[10]<=" ";
                    data_rom[11]<="P";
                    data_rom[12]<="R";
                    data_rom[13]<="I";
                    data_rom[14]<="C";
                    data_rom[15]<="E";
                    data_rom[16]<=":";
                    data_rom[17]<=8'h20;
                    data_rom[18]<=8'h30+total_price / 100;
                    data_rom[19]<=8'h30+(total_price % 100) / 10;
                    data_rom[20]<=8'h30+total_price % 10;
                    
                    if(button_select_prev && !button_select) begin
                    state <= INSERT_MONEY;
                    end
                    
                    if(switch_admin) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                    if(button_reset_prev && !button_reset) begin    
                        state <= IDLE;
                        current_product <= 3'b000;
                    end
                    if (button_view_prev && !button_view) begin
                        state <= SELECT_QUANTITY;
                    end
                end
                INSERT_MONEY: begin
//                    seven_segment1 <= seven_segment_encode(4'd0);
//                    seven_segment2 <= seven_segment_encode(4'd0);
//                    seven_segment3 <= seven_segment_encode(total_money / 10);  
//                    seven_segment4 <= seven_segment_encode(total_money % 10);  
                    led <= 4'b0111;
                    total_money <= user_money;
                    change <= remaining_money;
                    seven_segment1 <= 4'd0;
                    seven_segment2 <= total_money / 100;
                    seven_segment3 <= (total_money % 100) / 10;  
                    seven_segment4 <= total_money % 10; 
                    data_rom[5]<="E";//D
                    data_rom[6]<="N";//:
                    data_rom[7]<="T";
                    data_rom[8]<="E";
                    data_rom[9]<="R";
                    data_rom[10]<=" ";
                    data_rom[11]<="M";
                    data_rom[12]<="O";
                    data_rom[13]<="N";
                    data_rom[14]<="E";
                    data_rom[15]<="Y";
                    data_rom[16]<=":";
                    data_rom[17]<=8'h20;
                    data_rom[18]<=8'h30+total_money / 100;
                    data_rom[19]<=8'h30+(total_money % 100) / 10;  
                    data_rom[20]<=8'h30+ total_money % 10; 
                    if(button_pay_prev && !button_pay) begin
                    state <= PAYMENT;
                    end
                    
                    if(switch_admin) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                    if(button_reset_prev && !button_reset) begin    
                        state <= IDLE;
                        current_product <= 3'b000;
                    end
                    if (button_view_prev && !button_view) begin
                        state <= CALCULATE;
                    end
                    end
                PAYMENT: begin
                
                    if (enough_money_flag) begin
                        state <= DELIVERY; 
                        led <= 4'b1111;
                    end
                    else begin
                        state <= ERROR;
                    end
                end
                
                DELIVERY: begin
                    led <= 4'b1111;
//                        seven_segment1 <= seven_segment_encode(4'd0);
//                        seven_segment2 <= seven_segment_encode(4'd0);
//                        seven_segment3 <= seven_segment_encode(remaining_money / 10);
//                        seven_segment4 <= seven_segment_encode(remaining_money % 10); 
                        seven_segment1 <= 4'd0; // F
                        seven_segment2 <= 4'd0; // F
                        seven_segment3 <= 4'd0; // F
                        seven_segment4 <= 4'd0; // F  
                        data_rom[5]="S";
                        data_rom[6]="U";
                        data_rom[7]="C";
                        data_rom[8]="C";
                        data_rom[9]="E";
                        data_rom[10]="S";
                        data_rom[11]="S";
                        data_rom[12]=" ";
                        data_rom[13]=" ";
                        data_rom[14]=" ";
                        data_rom[15]=" ";
                        data_rom[16]=" ";
                        data_rom[17]=" ";
                        data_rom[18]=" ";
                        data_rom[19]=" ";
                        data_rom[20]=" ";
                        if (delay_counter < 300000000) begin
                            delay_counter <= delay_counter + 1;
                            end
                        else begin
                            product_inventory[selected_id] <= product_inventory[selected_id] - selected_quantity; 
                            state <=RETURN_MONEY;
                            delay_counter <= 0; 
                        end 
                end
                ERROR: begin
                        led <= 4'b0000;
                        seven_segment1 <= 4'd9; // F
                        seven_segment2 <= 4'd9; // F
                        seven_segment3 <= 4'd9; // F
                        seven_segment4 <= 4'd9; // F
                        data_rom[5]="E";
                        data_rom[6]="R";
                        data_rom[7]="R";
                        data_rom[8]="O";
                        data_rom[9]="R";
                        data_rom[10]=" ";
                        data_rom[11]=" ";
                        data_rom[12]=" ";
                        data_rom[13]=" ";
                        data_rom[14]=" ";
                        data_rom[15]=" ";
                        data_rom[16]=" ";
                        data_rom[17]=" ";
                        data_rom[18]=" ";
                        data_rom[19]=" ";
                        data_rom[20]=" ";
                        if (delay_counter < 300000000) begin
                            delay_counter <= delay_counter + 1;
                            end
                        else begin
                            state <=RETURN_MONEY;
                            delay_counter <= 0;
                        end 
                 end
                RETURN_MONEY: begin
                    led <= 4'b0000;

//                    seven_segment1 <= 4'd0;
//                    seven_segment2 <= change / 100;
//                    seven_segment3 <= (change % 100) / 10;  
//                    seven_segment4 <= change % 10;
                    data_rom[5]<="C";//D
                    data_rom[6]<="H";//:
                    data_rom[7]<="A";
                    data_rom[8]<="N";
                    data_rom[9]<="G";
                    data_rom[10]<="E";
                    data_rom[11]<=":";
                    data_rom[12]<=" ";
                    data_rom[13]<=8'h30+change / 100;
                    data_rom[14]<=8'h30+(change % 100) / 10;
                    data_rom[15]<=8'h30+change % 10;
                    data_rom[16]<=" ";
                    data_rom[17]<=8'h20;
                    data_rom[18]<=8'h20;
                    data_rom[19]<=8'h20;
                    data_rom[20]<=8'h20;
                if (delay_counter < 200000000) begin
                            delay_counter <= delay_counter + 1;
                            end
                        else begin
                            state <=IDLE;
                            delay_counter <= 0;
                            current_product <= 3'b000;
                            change <= 8'd0; 
                end 
                end
                ADMIN_UPDATE_ID: begin              
                if (delay_counter < 100000000) begin
                            delay_counter <= delay_counter + 1;
                            led <= 4'b1111; 
                            end
                        else begin
                            led <= 4'b0001; 
              
                end
                    
//                        seven_segment1 <= seven_segment_encode(4'd0); 
//                        seven_segment2 <= seven_segment_encode(4'd0); 
//                        seven_segment3 <= seven_segment_encode(4'd0); 
//                        seven_segment4 <= seven_segment_encode(id_for_update); 
                    id_for_update <= admin_id;
                    seven_segment1 <= 4'd0;
                    seven_segment2 <= 4'd0;
                    seven_segment3 <= 4'd0;  
                    seven_segment4 <= id_for_update;
                        data_rom[5]="U";
                        data_rom[6]="P";
                        data_rom[7]="D";
                        data_rom[8]="A";
                        data_rom[9]="T";
                        data_rom[10]="E";
                        data_rom[11]=" ";
                        data_rom[12]="I";
                        data_rom[13]="D";
                        data_rom[14]=":";
                        data_rom[15]=" ";
                        data_rom[16]=8'h30+id_for_update;
                        data_rom[17]=" ";
                        data_rom[18]=" ";
                        data_rom[19]=" ";
                        data_rom[20]=" ";
                        data_rom[21]=8'hc0;
                        data_rom[22]=" ";
                        data_rom[23]=" ";
                        data_rom[24]=" ";
                        data_rom[25]=" ";
                        data_rom[26]=" ";
                        data_rom[27]=" ";
                        data_rom[28]=" ";
                        data_rom[29]=" ";
                        data_rom[30]=" ";
                        data_rom[31]=" ";
                        data_rom[32]=" ";
                        data_rom[33]=" ";
                        data_rom[34]=" ";
                        data_rom[35]=" ";
                        data_rom[36]=" ";
                        data_rom[37]=" ";
                        if(button_select_prev && !button_select) begin
                                state <= ADMIN_UPDATE_QUANTITY;
                        end
                        
                        if(!switch_admin)begin
                            state <= IDLE;
                        end
                    if(button_reset_prev && !button_reset) begin    
                        state <= IDLE;
                        current_product <= 3'b000;
                    end
                end
                 ADMIN_UPDATE_QUANTITY: begin
                           led <= 4'b0011;
//                        seven_segment1 <= seven_segment_encode(4'd0); 
//                        seven_segment2 <= seven_segment_encode(4'd0); 
//                        seven_segment3 <= seven_segment_encode(4'd0); 
//                        seven_segment4 <= seven_segment_encode(new_quantity); 
                    new_quantity <= admin_quantity;
                    seven_segment1 <= id_for_update;
                    seven_segment2 <= 4'd0;
                    seven_segment3 <= 4'd0;  
                    seven_segment4 <= new_quantity;
                    data_rom[5]="U";
                    data_rom[6]="P";
                    data_rom[7]="D";
                    data_rom[8]="A";
                    data_rom[9]="T";
                    data_rom[10]="E";
                    data_rom[11]=" ";
                    data_rom[12]="Q";
                    data_rom[13]="U";
                    data_rom[14]="A";
                    data_rom[15]="N";
                    data_rom[16]=":";
                    data_rom[17]=" ";
                    data_rom[18]=8'h30+new_quantity;
                    data_rom[19]=" ";
                    data_rom[20]=" ";
                        if(button_select_prev && !button_select) begin
                                product_inventory[id_for_update] <= new_quantity;
                                state <= ADMIN_UPDATE_PRICE;
                        end
                        
                        if(!switch_admin)begin
                            state <= IDLE;
                        end
                    if(button_reset_prev && !button_reset) begin    
                        state <= IDLE;
                        current_product <= 3'b000;
                    end
                    if (button_view_prev && !button_view) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                end
                 ADMIN_UPDATE_PRICE: begin
                   led <= 4'b0111;
//                        seven_segment1 <= seven_segment_encode(4'd0); 
//                        seven_segment2 <= seven_segment_encode(4'd0); 
//                        seven_segment3 <= seven_segment_encode(new_price / 10); 
//                        seven_segment4 <= seven_segment_encode(new_price % 10); 
                    new_price <= admin_price;
                    seven_segment1 <= 4'd0;
                    seven_segment2 <= 4'd0;
                    seven_segment3 <= new_price / 10;  
                    seven_segment4 <= new_price % 10;
                    data_rom[5]="U";
                        data_rom[6]="P";
                        data_rom[7]="D";
                        data_rom[8]="A";
                        data_rom[9]="T";
                        data_rom[10]="E";
                        data_rom[11]=" ";
                        data_rom[12]="P";
                        data_rom[13]="R";
                        data_rom[14]="I";
                        data_rom[15]="C";
                        data_rom[16]="E";
                        data_rom[17]=":";
                        data_rom[18]=" ";
                        data_rom[19]=8'h30+ new_price / 10;
                        data_rom[20]=8'h30+ new_price % 10;
                        if(button_select_prev && !button_select) begin
                                product_price[id_for_update] <= new_price;
                                delay_counter <= 0;
                                state <= ADMIN_UPDATE_ID;
                               
                        end
                        
                        if(!switch_admin)begin
                            current_product <= 3'b000;
                            state <= IDLE;
                        end
                     if(button_reset_prev && !button_reset) begin    
                        state <= IDLE;
                        current_product <= 3'b000;
                       
                    end
                    if (button_view_prev && !button_view) begin
                        state <= ADMIN_UPDATE_QUANTITY;
         
                    end
                end
                default: state <= IDLE;
            endcase
        end
endmodule