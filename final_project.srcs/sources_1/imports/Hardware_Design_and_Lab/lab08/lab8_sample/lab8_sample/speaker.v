`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:29:06 05/02/2012 
// Design Name: 
// Module Name:    speaker 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module speaker(
  clk, // clock from crystal
  rst, // active high reset
  audio_mclk, // master clock
  audio_lrck, // left-right clock
  audio_sck, // serial clock
  audio_sdin, // serial audio data input
  PS2_DATA,
  PS2_CLK,
  m1,
  m2,
  state1,
  state2,
  mute
);

// I/O declaration
input clk;  // clock from the crystal
input rst;  // active high reset
inout PS2_DATA;
inout PS2_CLK;
input m1;
input m2;
input mute;
output audio_mclk; // master clock
output audio_lrck; // left-right clock
output audio_sck; // serial clock
output audio_sdin; // serial audio data input
output [3:0] state1;
output [3:0] state2;

// Declare internal nodes
wire [15:0] audio_in_left, audio_in_right;
wire [9:0] ibeatNum;
wire [31:0] freq;
wire [21:0] freq_out;
wire clkDiv23;


clock_divider #(.n(24)) clock_23(
  .clk(clk),
	.clk_div(clkDiv23)
);

PlayerCtrl playerCtrl_00 ( 
    .clk(clk),
    .rst(rst),
    .ibeat(ibeatNum),
    .PS2_DATA(PS2_DATA),
    .PS2_CLK(PS2_CLK),
    .state1(state1),
    .state2(state2)
);

Music music00 ( 
    .ibeatNum(ibeatNum),
    .tone(freq),
    .state1(state1),
    .state2(state2),
    .m1(m1),
    .m2(m2),
    .mute(mute)
);

assign freq_out = 50000000/freq;
//assign real_mute = (stop==1'b1) ? 1'b1 : mute;

// Note generation
note_gen Ung(
  .clk(clk), // clock from crystal
  .rst(rst), // active high reset
  .note_div(freq_out), // div for note generation
  .audio_left(audio_in_left), // left sound audio
  .audio_right(audio_in_right) // right sound audio
);

// Speaker controllor
speaker_control Usc(
  .clk(clk),  // clock from the crystal
  .rst(rst),  // active high reset
  .audio_in_left(audio_in_left), // left channel audio data input
  .audio_in_right(audio_in_right), // right channel audio data input
  .audio_mclk(audio_mclk), // master clock
  .audio_lrck(audio_lrck), // left-right clock
  .audio_sck(audio_sck), // serial clock
  .audio_sdin(audio_sdin) // serial audio data input
);

endmodule
