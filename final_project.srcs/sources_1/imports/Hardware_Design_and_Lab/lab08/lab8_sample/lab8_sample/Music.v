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

`define KEY_1R 10'h116
`define KEY_2R 10'h11E
`define KEY_3R 10'h126
`define KEY_4R 10'h125
`define KEY_5R 10'h12E
`define KEY_6R 10'h136
`define KEY_7R 10'h13D
`define KEY_8R 10'h13E
`define KEY_9R 10'h146
`define KEY_0R 10'h145
`define KEY_QR 10'h115
`define KEY_WR 10'h11D
`define KEY_ER 10'h124
`define KEY_RR 10'h12D
`define KEY_TR 10'h12C
`define KEY_YR 10'h135
`define KEY_UR 10'h13C
`define KEY_IR 10'h143
`define KEY_OR 10'h144
`define KEY_PR 10'h14D
`define KEY_AR 10'h11C
`define KEY_SR 10'h11B
`define KEY_DR 10'h123
`define KEY_FR 10'h12B
`define KEY_GR 10'h134
`define KEY_HR 10'h133
`define KEY_JR 10'h13B
`define KEY_KR 10'h142
`define KEY_LR 10'h143
`define KEY_ZR 10'h11A
`define KEY_XR 10'h122
`define KEY_CR 10'h121
`define KEY_VR 10'h12A
`define KEY_BR 10'h132
`define KEY_NR 10'h131
`define KEY_MR 10'h13A
`define KEY_LBR 10'h141
`define KEY_RBR 10'h149

module Music (
	input [8:0] ibeatNum,
    input [3:0] state1,
    input [3:0] state2,
    input m1,
    input m2,
    input mute,
	output reg [31:0] tone
);

    parameter [31:0] SOUND [0:37] = {
        `A2S, `B2, `C3, `C3S, `D3, `D3S, `E3, `F3, `F3S, `G3,
        `G3S, `A3, `A3S, `B3, `C4, `C4S, `D4, `D4S, `E4, `F4,
        `F4S, `G4, `G4S, `A4, `A4S, `B4, `C5, `C5S, `D5, `D5S,
        `E5, `F5, `F5S, `G5, `G5S, `A5, `A5S, `B5
    };
/*
    wire [31:0] diff1 = (state1 << 3);
    wire [31:0] diff2 = (state2 << 3);
*/
    always @* begin
        
        case (ibeatNum) 
        `KEY_1: tone = SOUND[12-state1];
        `KEY_3: tone = SOUND[15-state1];
        `KEY_4: tone = SOUND[17-state1];
        `KEY_6: tone = SOUND[20-state1];
        `KEY_7: tone = SOUND[22-state1];
        `KEY_8: tone = SOUND[24-state1];
        `KEY_0: tone = SOUND[27-state1];
        `KEY_Q: tone = SOUND[13-state1];
        `KEY_W: tone = SOUND[14-state1];
        `KEY_E: tone = SOUND[16-state1];
        `KEY_R: tone = SOUND[18-state1];
        `KEY_T: tone = SOUND[19-state1];
        `KEY_Y: tone = SOUND[21-state1];
        `KEY_U: tone = SOUND[23-state1];
        `KEY_I: tone = SOUND[25-state1];
        `KEY_O: tone = SOUND[26-state1];
        `KEY_P: tone = SOUND[28-state1];

        `KEY_A: tone = SOUND[state2];
        `KEY_D: tone = SOUND[3+state2];
        `KEY_F: tone = SOUND[5+state2];
        `KEY_H: tone = SOUND[8+state2];
        `KEY_J: tone = SOUND[10+state2];
        `KEY_K: tone = SOUND[12+state2];
        `KEY_Z: tone = SOUND[1+state2];
        `KEY_X: tone = SOUND[2+state2];
        `KEY_C: tone = SOUND[4+state2];
        `KEY_V: tone = SOUND[6+state2];
        `KEY_B: tone = SOUND[7+state2];
        `KEY_N: tone = SOUND[9+state2];
        `KEY_M: tone = SOUND[11+state2];
        `KEY_LB: tone = SOUND[13+state2];
        `KEY_RB: tone = SOUND[14+state2];

        default: tone = `M0;
        endcase

        if((m1|m2)&(~mute)) begin
            tone = `A5;
        end
    end

endmodule
