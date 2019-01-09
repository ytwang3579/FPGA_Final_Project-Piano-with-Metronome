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
  PS2_CLK
);

// I/O declaration
input clk;  // clock from the crystal
input rst;  // active high reset
inout PS2_DATA;
inout PS2_CLK;
output audio_mclk; // master clock
output audio_lrck; // left-right clock
output audio_sck; // serial clock
output audio_sdin; // serial audio data input

// Declare internal nodes
wire [15:0] audio_in_left, audio_in_right;
wire [8:0] ibeatNum, ibeatNum2;
wire [31:0] freq, freq2;
wire [21:0] freq_out;
wire clkDiv23;
wire valid;
wire [511:0] key_down;
wire [4:0] outcnt;

clock_divider #(.n(24)) clock_23(
  .clk(clk),
	.clk_div(clkDiv23)
);

PlayerCtrl playerCtrl_00 ( 
    .clk(clk),
    .rst(rst),
    .ibeat(ibeatNum),
    .key_down(key_down),
    .PS2_DATA(PS2_DATA),
    .PS2_CLK(PS2_CLK)
);

Music music00 ( 
    .key_down(key_down),
    .tone(freq),
    .rst(rst),
    .clk(clk),
    .cnt(outcnt),
    .valid(valid)
);

assign freq_out = 50000000/freq;
//assign real_mute = (stop==1'b1) ? 1'b1 : mute;

// Note generation
note_gen Ung(
  .clk(clk), // clock from crystal
  .rst(rst), // active high reset
  .note_div(freq_out), // div for note generation
  .audio_left(audio_in_left), // left sound audio
  .audio_right(audio_in_right), // right sound audio
  .cnt(outcnt),
  .valid(valid)
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
