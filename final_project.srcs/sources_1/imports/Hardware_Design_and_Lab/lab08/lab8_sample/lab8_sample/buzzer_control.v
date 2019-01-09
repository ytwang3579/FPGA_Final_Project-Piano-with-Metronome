`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:01:35 05/02/2012 
// Design Name: 
// Module Name:    note_gen 
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
module note_gen(
  clk, // clock from crystal
  rst, // active high reset
  note_div, // div for note generation
  audio_left, // left sound audio
  audio_right, // right sound audio
  cnt, valid
);

// I/O declaration
input clk; // clock from crystal
input rst; // active low reset
input [21:0] note_div; // div for note generation
input [4:0] cnt;
input valid;
output [15:0] audio_left; // left sound audio
output [15:0] audio_right; // right sound audio

// Declare internal signals
reg [21:0] clk_cnt_next, clk_cnt;
reg [21:0] clk_cnt_next_2, clk_cnt_2;
reg b_clk, b_clk_next;
reg c_clk, c_clk_next;
reg [15:0] audioleft, audioright;
reg [15:0] audioleft_next, audioright_next;

reg [21:0] note1, note2, note3, note4;
reg [21:0] note1_next, note2_next, note3_next, note4_next;
reg [21:0] clk1, clk2, clk3, clk4;
reg [21:0] clk1_next, clk2_next, clk3_next, clk4_next;
reg clka, clkb, clkc, clkd;
reg clka_next, clkb_next, clkc_next, clkd_next;



// Note frequency generation
always @(posedge clk or posedge rst) begin
  if (rst == 1'b1) begin
    clk1 <= 22'd0; clk2 <= 22'd0; clk3 <= 22'd0; clk4 <= 22'd0;
    clka <= 1'b0; clkb <= 1'b0; clkc <= 1'b0; clkd <= 1'b0;
    note1 <= 22'b0; note2 <= 22'b0; note3 <= 22'b0; note4 <= 22'b0;
  end else begin
    clk1 <= clk1_next; clk2 <= clk2_next; clk3 <= clk3_next; clk4 <= clk4_next;
    clka <= clka_next; clkb <= clkb_next; clkc <= clkc_next; clkd <= clkd_next;
    note1 <= note1_next; note2 <= note2_next; note3 <= note3_next; note4 <= note4_next;
  end
end

always @* begin
  note1_next = note1; note2_next = note2; note3_next = note3; note4_next = note4;
  case(cnt)
  5'd1:
  begin
    note1_next = note_div;
  end
  5'd2:
  begin
    note2_next = note_div;
  end
  5'd3:
  begin
    note3_next = note_div;
  end
  5'd4:
  begin
    note4_next = note_div;
  end
  endcase
end
	 
always @* begin
  if(clk1==note1) begin
    clk1_next = 22'd1;
    clka_next = ~clka;
  end else begin
    clk1_next = clk1 + 1;
    clka_next = clka;
  end
  if(note1==22'd0) clk1_next = 22'd1;
end

always @* begin
  if(clk2==note2) begin
    clk2_next = 22'd1;
    clkb_next = ~clkb;
  end else begin
    clk2_next = clk2 + 1;
    clkb_next = clkb;
  end
  if(note2==22'd0) clk2_next = 22'd1;
end

always @* begin
  if(clk3==note3) begin
    clk3_next = 22'd1;
    clkc_next = ~clkc;
  end else begin
    clk3_next = clk3 + 1;
    clkc_next = clkc;
  end
  if(note3==22'd0) clk3_next = 22'd1;
end

always @* begin
  if(clk4==note4) begin
    clk4_next = 22'd1;
    clkd_next = ~clkd;
  end else begin
    clk4_next = clk4 + 1;
    clkd_next = clkd;
  end
  if(note4==22'd0) clk4_next = 22'd1;
end

// Assign the amplitude of the note
//assign audio_left = (b_clk == 1'b0) ? 16'hE000 : 16'h2000;
//assign audio_right = (c_clk == 1'b0) ? 16'hE000 : 16'h2000;

//TODO : assign audio outputs
always @* begin
  audioleft = 16'h0000; audioright = 16'h0000;
  case(cnt)
  5'd1:
  begin
    if(note1==22'd1000) begin
      audioleft = 16'h0000; audioright = 16'h0000;
    end else begin
      if(clka == 1'b0) begin
        audioleft = 16'h8001; audioright = 16'h8001;
      end else begin
        audioleft = 16'h7FFF; audioright = 16'h7FFF;
      end
    end
  end
  5'd2:
  begin
    audioright = 16'h0000; audioleft = 16'h0000;
    if(clka==1'b0 && clkb==1'b0) begin
      audioright = 16'h8001; audioleft = 16'h8001;
    end else if(clka==1'b1 || clkb==1'b1) begin
      audioright = 16'h0000; audioleft = 16'h0000;
    end else begin
      audioright = 16'h7FFF; audioleft = 16'h7FFF;
    end
  end
  endcase
end

assign audio_left = audioleft;
assign audio_right = audioright;

endmodule
