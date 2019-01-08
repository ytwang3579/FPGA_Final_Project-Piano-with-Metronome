`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/26 19:46:23
// Design Name: 
// Module Name: PlayerCtrl
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

module PlayerCtrl (
	input clk,
	input rst,
	inout PS2_DATA,
	inout PS2_CLK,
	output reg [9:0] ibeat
);
	reg [15:0] nums;
	reg [4:0] key_num;
	reg [9:0] last_key;
	
	wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;

	KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);

	always @ (posedge clk, posedge rst) begin
		if (rst) begin
			nums <= 16'b0;
			ibeat <= 10'b0;
		end else begin
			nums <= nums;
			
			if (been_ready && key_down[last_change]==1'b1) begin
				ibeat <= last_change;
			end else if (been_ready && key_down[last_change]==1'b0) begin
				ibeat <= `M0;
			end else begin
				ibeat <= ibeat;
			end
		end
	end
	
	always @ (*) begin
		case (last_change)
			`KEY_1: key_num = 5'd0;
			`KEY_3: key_num = 5'd1;
			`KEY_4: key_num = 5'd2;
			`KEY_6: key_num = 5'd3;
			`KEY_7: key_num = 5'd4;
			`KEY_8: key_num = 5'd5;
			`KEY_0: key_num = 5'd6;
			`KEY_Q: key_num = 5'd7;
			`KEY_W: key_num = 5'd8;
			`KEY_E: key_num = 5'd9;
			`KEY_R: key_num = 5'd10;
			`KEY_T: key_num = 5'd11;
			`KEY_Y: key_num = 5'd12;
			`KEY_U: key_num = 5'd13;
			`KEY_I: key_num = 5'd14;
			`KEY_O: key_num = 5'd15;
			`KEY_P: key_num = 5'd16;
			`KEY_A: key_num = 5'd17;
			`KEY_D: key_num = 5'd18;
			`KEY_F: key_num = 5'd19;
			`KEY_H: key_num = 5'd20;
			`KEY_J: key_num = 5'd21;
			`KEY_K: key_num = 5'd22;
			`KEY_Z: key_num = 5'd23;
			`KEY_X: key_num = 5'd24;
			`KEY_C: key_num = 5'd25;
			`KEY_V: key_num = 5'd26;
			`KEY_B: key_num = 5'd27;
			`KEY_N: key_num = 5'd28;
			`KEY_M: key_num = 5'd29;
			`KEY_LB: key_num = 5'd30;
			`KEY_RB: key_num = 5'd31;
		endcase
	end

endmodule