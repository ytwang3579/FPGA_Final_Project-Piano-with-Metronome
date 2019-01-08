`define KEY_1 10'h016
`define KEY_2 10'h01E
`define KEY_3 10'h026
`define KEY_4 10'h025
`define KEY_5 10'h02E
`define KEY_6 10'h036
`define KEY_7 10'h03D
`define KEY_8 10'h03E
`define KEY_9 10'h046
`define KEY_0 10'h045
`define KEY_Q 10'h015
`define KEY_W 10'h01D
`define KEY_E 10'h024
`define KEY_R 10'h02D
`define KEY_T 10'h02C
`define KEY_Y 10'h035
`define KEY_U 10'h03C
`define KEY_I 10'h043
`define KEY_O 10'h044
`define KEY_P 10'h04D
`define KEY_A 10'h01C
`define KEY_S 10'h01B
`define KEY_D 10'h023
`define KEY_F 10'h02B
`define KEY_G 10'h034
`define KEY_H 10'h033
`define KEY_J 10'h03B
`define KEY_K 10'h042
`define KEY_L 10'h043
`define KEY_Z 10'h01A
`define KEY_X 10'h022
`define KEY_C 10'h021
`define KEY_V 10'h02A
`define KEY_B 10'h032
`define KEY_N 10'h031
`define KEY_M 10'h03A
`define KEY_, 10'h041
`define KEY_. 10'h049

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
`define KEY_,R 10'h141
`define KEY_.R 10'h149



module SampleDisplay(
	output wire [6:0] display,
	output wire [3:0] digit,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
	);
	
	parameter [8:0] LEFT_SHIFT_CODES  = 9'b0_0001_0010;
	parameter [8:0] RIGHT_SHIFT_CODES = 9'b0_0101_1001;
	parameter [8:0] KEY_CODES [0:19] = {
		9'b0_0100_0101,	// 0 => 45
		9'b0_0001_0110,	// 1 => 16
		9'b0_0001_1110,	// 2 => 1E
		9'b0_0010_0110,	// 3 => 26
		9'b0_0010_0101,	// 4 => 25
		9'b0_0010_1110,	// 5 => 2E
		9'b0_0011_0110,	// 6 => 36
		9'b0_0011_1101,	// 7 => 3D
		9'b0_0011_1110,	// 8 => 3E
		9'b0_0100_0110,	// 9 => 46
		
		9'b0_0111_0000, // right_0 => 70
		9'b0_0110_1001, // right_1 => 69
		9'b0_0111_0010, // right_2 => 72
		9'b0_0111_1010, // right_3 => 7A
		9'b0_0110_1011, // right_4 => 6B
		9'b0_0111_0011, // right_5 => 73
		9'b0_0111_0100, // right_6 => 74
		9'b0_0110_1100, // right_7 => 6C
		9'b0_0111_0101, // right_8 => 75
		9'b0_0111_1101  // right_9 => 7D
	};
	
	reg [15:0] nums;
	reg [3:0] key_num;
	reg [9:0] last_key;
	
	wire shift_down;
	wire [511:0] key_down;
	wire [9:0] last_change;
	wire been_ready;
	
	assign shift_down = (key_down[LEFT_SHIFT_CODES] == 1'b1 || key_down[RIGHT_SHIFT_CODES] == 1'b1) ? 1'b1 : 1'b0;
	
	SevenSegment seven_seg (
		.display(display),
		.digit(digit),
		.nums(nums),
		.rst(rst),
		.clk(clk)
	);
		
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
		end else begin
			nums <= nums;
			if (been_ready && key_down[last_change] == 1'b1) begin
				if (key_num != 4'b1111)begin
					if (shift_down == 1'b1) begin
						nums <= {key_num, nums[15:4]};
					end else begin
						nums <= {nums[11:0], key_num};
					end
				end
			end
		end
	end
	
	always @ (*) begin
		case (last_change)
			KEY_CODES[00] : key_num = 4'b0000;
			KEY_CODES[01] : key_num = 4'b0001;
			KEY_CODES[02] : key_num = 4'b0010;
			KEY_CODES[03] : key_num = 4'b0011;
			KEY_CODES[04] : key_num = 4'b0100;
			KEY_CODES[05] : key_num = 4'b0101;
			KEY_CODES[06] : key_num = 4'b0110;
			KEY_CODES[07] : key_num = 4'b0111;
			KEY_CODES[08] : key_num = 4'b1000;
			KEY_CODES[09] : key_num = 4'b1001;
			KEY_CODES[10] : key_num = 4'b0000;
			KEY_CODES[11] : key_num = 4'b0001;
			KEY_CODES[12] : key_num = 4'b0010;
			KEY_CODES[13] : key_num = 4'b0011;
			KEY_CODES[14] : key_num = 4'b0100;
			KEY_CODES[15] : key_num = 4'b0101;
			KEY_CODES[16] : key_num = 4'b0110;
			KEY_CODES[17] : key_num = 4'b0111;
			KEY_CODES[18] : key_num = 4'b1000;
			KEY_CODES[19] : key_num = 4'b1001;
			default		  : key_num = 4'b1111;
		endcase
	end
	
endmodule
