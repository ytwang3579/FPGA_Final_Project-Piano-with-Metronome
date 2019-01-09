`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/26 19:54:13
// Design Name: 
// Module Name: Music
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
`define M0  32'd50000

`define A2S 32'd117
`define B2  32'd123

`define C3  32'd131
`define C3S 32'd139
`define D3F 32'd139
`define D3  32'd147
`define D3S 32'd156
`define E3F 32'd156
`define E3  32'd165
`define F3  32'd175
`define F3S 32'd185
`define G3F 32'd185
`define G3  32'd196
`define G3S 32'd208
`define A3F 32'd208
`define A3  32'd220
`define A3S 32'd233
`define B3F 32'd233
`define B3  32'd247

`define C4  32'd262
`define C4S 32'd277
`define D4F 32'd277
`define D4  32'd294
`define D4S 32'd311
`define E4F 32'd311
`define E4  32'd330
`define F4  32'd349
`define F4S 32'd370
`define G4F 32'd370
`define G4  32'd392
`define G4S 32'd415
`define A4F 32'd415
`define A4  32'd440
`define A4S 32'd466
`define B4F 32'd466
`define B4  32'd494

`define C5  32'd523
`define C5S 32'd554
`define D5F 32'd554
`define D5  32'd587
`define D5S 32'd622
`define E5F 32'd622
`define E5  32'd659
`define F5  32'd698
`define F5S 32'd740
`define G5F 32'd740
`define G5  32'd784
`define G5S 32'd831
`define A5F 32'd831
`define A5  32'd880
`define A5S 32'd932
`define B5F 32'd932
`define B5  32'd988

`define KEY_1 9'h016
`define KEY_2 9'h01E
`define KEY_3 9'h026
`define KEY_4 9'h025
`define KEY_5 9'h02E
`define KEY_6 9'h036
`define KEY_7 9'h03D
`define KEY_8 9'h03E
`define KEY_9 9'h046
`define KEY_0 9'h045
`define KEY_Q 9'h015
`define KEY_W 9'h01D
`define KEY_E 9'h024
`define KEY_R 9'h02D
`define KEY_T 9'h02C
`define KEY_Y 9'h035
`define KEY_U 9'h03C
`define KEY_I 9'h043
`define KEY_O 9'h044
`define KEY_P 9'h04D
`define KEY_A 9'h01C
`define KEY_S 9'h01B
`define KEY_D 9'h023
`define KEY_F 9'h02B
`define KEY_G 9'h034
`define KEY_H 9'h033
`define KEY_J 9'h03B
`define KEY_K 9'h042
`define KEY_L 9'h043
`define KEY_Z 9'h01A
`define KEY_X 9'h022
`define KEY_C 9'h021
`define KEY_V 9'h02A
`define KEY_B 9'h032
`define KEY_N 9'h031
`define KEY_M 9'h03A
`define KEY_LB 9'h041
`define KEY_RB 9'h049

module Music (
	input [511:0] key_down,
    input rst,
    input clk,
	output reg [31:0] tone,
    output reg [4:0] cnt,
    output reg valid
);
    reg [8:0] ibeatNum, next_ibeatNum;
    reg [4:0] next_cnt;

    always @(posedge clk, posedge rst) begin
        if(rst==1'b1) begin
            ibeatNum <= 9'b0;
            cnt <= 5'd0;
        end else begin
            ibeatNum <= next_ibeatNum;
            cnt <= next_cnt;
        end
    end
    
    always @* begin
        if(ibeatNum==`KEY_1) begin
            valid <= 1'b1;
        end else begin
            valid <= 1'b0;
        end
    end

    always @* begin
        case (ibeatNum)
        `KEY_1: next_ibeatNum = `KEY_3;
        `KEY_3: next_ibeatNum = `KEY_4;
        `KEY_4: next_ibeatNum = `KEY_6;
        `KEY_6: next_ibeatNum = `KEY_7;
        `KEY_7: next_ibeatNum = `KEY_8;
        `KEY_8: next_ibeatNum = `KEY_0;
        `KEY_0: next_ibeatNum = `KEY_Q;
        `KEY_Q: next_ibeatNum = `KEY_W;
        `KEY_W: next_ibeatNum = `KEY_E;
        `KEY_E: next_ibeatNum = `KEY_R;
        `KEY_R: next_ibeatNum = `KEY_T;
        `KEY_T: next_ibeatNum = `KEY_Y;
        `KEY_Y: next_ibeatNum = `KEY_U;
        `KEY_U: next_ibeatNum = `KEY_I;
        `KEY_I: next_ibeatNum = `KEY_O;
        `KEY_O: next_ibeatNum = `KEY_P;
        `KEY_P: next_ibeatNum = `KEY_A;

        `KEY_A: next_ibeatNum = `KEY_S;
        `KEY_D: next_ibeatNum = `KEY_F;
        `KEY_F: next_ibeatNum = `KEY_H;
        `KEY_H: next_ibeatNum = `KEY_J;
        `KEY_J: next_ibeatNum = `KEY_K;
        `KEY_K: next_ibeatNum = `KEY_Z;
        `KEY_Z: next_ibeatNum = `KEY_X;
        `KEY_X: next_ibeatNum = `KEY_C;
        `KEY_C: next_ibeatNum = `KEY_V;
        `KEY_V: next_ibeatNum = `KEY_B;
        `KEY_B: next_ibeatNum = `KEY_N;
        `KEY_N: next_ibeatNum = `KEY_M;
        `KEY_M: next_ibeatNum = `KEY_LB;
        `KEY_LB: next_ibeatNum = `KEY_RB;
        `KEY_RB: next_ibeatNum = `KEY_1;

        default: next_ibeatNum = `KEY_1;
        endcase
    end


    always @* begin
        next_cnt = cnt;
        case (ibeatNum) 
        `KEY_1:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = 5'd1;
                tone = `A3S;
            end else begin
                next_cnt = 5'd0;
            end
        end
        `KEY_3:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `C4S;
            end
        end
        `KEY_4:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `D4S;
            end
        end
        `KEY_6:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `F4S;
            end
        end
        `KEY_7:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `G4S;
            end
        end
        `KEY_8:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `A4S;
            end
        end
        `KEY_0:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `C5S;
            end
        end
        `KEY_Q:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `B3;
            end
        end
        `KEY_W:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `C4;
            end
        end
        `KEY_E:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `D4;
            end
        end
        `KEY_R:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `E4;
            end
        end
        `KEY_T:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `F4;
            end
        end
        `KEY_Y:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `G4;
            end
        end
        `KEY_U:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `A4;
            end
        end
        `KEY_I:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `B4;
            end
        end
        `KEY_O:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `C5;
            end
        end
        `KEY_P:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `D5;
            end
        end

        `KEY_A:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `A2S;
            end
        end
        `KEY_D:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `C3S;
            end
        end
        `KEY_F:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `D3S;
            end
        end
        `KEY_H:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `F3S;
            end
        end
        `KEY_J:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `G3S;
            end
        end
        `KEY_K:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `A3S;
            end
        end
        `KEY_Z:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `B2;
            end
        end
        `KEY_X:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `C3;
            end
        end
        `KEY_C:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `D3;
            end
        end
        `KEY_V:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `E3;
            end
        end
        `KEY_B:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `F3;
            end
        end
        `KEY_N:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `G3;
            end
        end
        `KEY_M:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `A3;
            end
        end
        `KEY_LB:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `B3;
            end
        end
        `KEY_RB:
        begin
            if(key_down[ibeatNum]==1'b1) begin
                next_cnt = cnt + 1;
                tone = `C4;
            end
        end

        default: tone = `M0;
        endcase
    end

endmodule
