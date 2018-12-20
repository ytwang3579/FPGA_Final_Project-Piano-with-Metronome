`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/20/2018 04:17:42 PM
// Design Name: 
// Module Name: piano
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


module piano(rst, clk, DISPLAY, LED, DIGIT, btnU, btnL);
    input rst, clk, btnU, btnL;
    output [3:0] DIGIT;
    output [6:0] DISPLAY;
    output [15:0] LED;

    wire [15:0] rate;
    wire btnU_1p, btnL_1p;
    OnePulse btnu1p(.signal_single_pulse(btnU_1p), .signal(btnU), .clock(clk));
    OnePulse btnl1p(.signal_single_pulse(btnL_1p), .signal(btnL), .clock(clk));

    rate_control ratecontrol(.btnU(btnU_1p), .btnL(btnL_1p), .rate(rate), .rst(rst), .clk(clk));

    metronome met(.rst(rst), .clk(clk), .rate(rate), .LED(LED));

    SevenSegment showing(.display(DISPLAY), .nums(rate), .digit(DIGIT), .rst(rst), .clk(clk));

endmodule

module rate_control(btnU, btnL, rate, rst, clk);
    input btnU, btnL, rst, clk;
    output reg [15:0] rate;

    reg [15:0] next_rate;
    always @(posedge clk, posedge rst) begin
        if(rst==1'b1) begin
            rate <= 16'h0060;
        end else begin
            rate <= next_rate;
        end
    end

    always @* begin
        next_rate = rate;
        if(btnU==1'b1 && rate!=16'h0218) begin
            next_rate = rate + 1;
            if(rate[3:0]==4'h9) next_rate = rate + 7;
            if(rate[7:0]==8'h99) next_rate = rate + 103;
        end
        if(btnL==1'b1 && rate!=16'h0040) begin
            next_rate = rate - 1;
            if(rate[3:0]==4'h0) next_rate = rate - 7;
            if(rate[7:0]==12'h00) next_rate = rate - 103;
        end
    end

endmodule

module metronome(rst, clk, rate, LED);
    input rst, clk;
    input [15:0] rate;
    output reg [15:0] LED;

    reg [15:0] next_LED;
    reg [33:0] cnt, next_cnt;
    reg dir, next_dir;
    wire [8:0] real_rate = (rate[3:0] + (rate[7:4]*10) + (rate[11:8]*100));

    always @(posedge clk, posedge rst) begin
        if(rst==1'b1) begin
            LED <= 16'h0001;
            cnt <= 34'b0;
            dir <= 1'b0;
        end else begin
            LED <= next_LED;
            cnt <= next_cnt;
            dir <= next_dir;
        end
    end

    always @* begin
        next_dir = dir;
        if(cnt>=(400_000_000/real_rate)-1) begin
            next_cnt = 34'b0;
            if(dir==1'b0) begin
                next_LED = LED << 1;
                if(LED==16'h4000) begin
                    next_dir = 1'b1;
                end
            end else begin
                next_LED = LED >> 1;
                if(LED==16'h0002) begin
                    next_dir = 1'b0;
                end
            end
        end else begin
            next_cnt = cnt + 1;
            next_LED = LED;
        end
    end

endmodule