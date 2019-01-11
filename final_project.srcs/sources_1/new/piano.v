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


module piano(rst, clk, DISPLAY, LED, DIGIT, btnU, btnD, btnL, btnR, PS2_DATA, PS2_CLK, audio_mclk, audio_lrck, audio_sck, audio_sdin, mute);
    input rst, clk, btnU, btnD, btnL, btnR, mute;
    inout PS2_DATA, PS2_CLK;
    output [3:0] DIGIT;
    output [6:0] DISPLAY;
    output [15:0] LED;
    output audio_mclk, audio_lrck, audio_sck, audio_sdin;

    wire clk_18;
    clock_divider #(.n(18)) clk18(.clk_div(clk_18), .clk(clk));

    wire out;
    wire [3:0] state1, state2;
    wire [15:0] state = (out) ? ({state1, rate[11:0]}) : ({state2, rate[11:0]});

    wire [15:0] rate;
    wire btnU_d, btnD_d, btnL_d, btnR_d, btnU_1p, btnD_1p, btnL_1p, btnR_1p;
    Debounce btnud(.pb_d(btnU_d), .pb(btnU), .clk(clk_18));
    Debounce btndd(.pb_d(btnD_d), .pb(btnD), .clk(clk_18));
    Debounce btnld(.pb_d(btnL_d), .pb(btnL), .clk(clk_18));
    Debounce btnrd(.pb_d(btnR_d), .pb(btnR), .clk(clk_18));
    OnePulse btnu1p(.signal_single_pulse(btnU_1p), .signal(btnU_d), .clock(clk_18));
    OnePulse btnd1p(.signal_single_pulse(btnD_1p), .signal(btnD_d), .clock(clk_18));
    OnePulse btnl1p(.signal_single_pulse(btnL_1p), .signal(btnL_d), .clock(clk_18));
    OnePulse btnr1p(.signal_single_pulse(btnR_1p), .signal(btnR_d), .clock(clk_18));

    rate_control ratecontrol(.btnU(btnU_1p), .btnD(btnD_1p), .rate(rate), .rst(rst), .clk(clk_18));
    upordown uod(.btnR(btnR_1p), .btnL(btnL_1p), .out(out));
    metronome met(.rst(rst), .clk(clk), .rate(rate), .LED(LED));

    SevenSegment showing(.display(DISPLAY), .nums(rate), .digit(DIGIT), .rst(rst), .clk(clk));

    speaker pout(.clk(clk), .rst(rst), .mute(mute), .state1(state1), .state2(state2), .audio_mclk(audio_mclk), .audio_lrck(audio_lrck), .audio_sck(audio_sck), .audio_sdin(audio_sdin), .PS2_DATA(PS2_DATA), .PS2_CLK(PS2_CLK), .m1(LED[0]), .m2(LED[15]));

endmodule

module upordown(btnR, btnL, out);
    input btnR, btnL;
    inout out;
    reg nextout;
    assign out = nextout;

    always @(btnR, btnL) begin
        if(btnR|btnL) begin
            nextout = ~out;
        end else begin
            nextout = out;
        end
    end

endmodule

module rate_control(btnU, btnD, rate, rst, clk);
    input btnU, btnD, rst, clk;
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
        if(btnD==1'b1 && rate!=16'h0040) begin
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
                if(LED==16'h0000) begin
                    next_LED = 16'h4000;
                    next_dir = 1'b1;
                end else if(LED==16'h4000) begin
                    next_dir = 1'b1;
                end
            end else begin
                next_LED = LED >> 1;
                if(LED==16'h0000) begin
                    next_LED = 16'h0001;
                    next_dir = 1'b0;
                end else if(LED==16'h0002) begin
                    next_dir = 1'b0;
                end
            end
        end else begin
            next_cnt = cnt + 1;
            next_LED = LED;
        end
    end

endmodule

