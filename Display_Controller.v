`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////////////////
// File Name: 	Display_Controller.v
// Project:		CECS 301 Lab 8: 16-bit RISC Processor
//	Student:		Vince Nguyen & Matthew Buchholz
//	Rev. Date:	Mar. 20, 2019
//
//	Purpose:		This is the display controller that outputs onto the anodes.
//
//	Notes:		The module uses a 480Hz clock, a pixel controller, a 8 to 1 mux,
//					and a hex to 7 segment display.
//
//////////////////////////////////////////////////////////////////////////////////

module Display_Controller(
    input         clk,
    input         rst,
    input  [31:0] seg,
    output [7:0]  A,
    output [6:0]  hex
    );
    
    wire       pixel_clk_out;
    wire [2:0] seg_sel;
	 wire [3:0]	hex_sel;
    
    pixel_clk		 	u0(clk, 				rst, 	   pixel_clk_out);
	 pixel_controller u1(pixel_clk_out, rst, A,  seg_sel);
	 ad_mux		     	u2(seg, 				seg_sel, hex_sel);
    hex_to_7seg		u3(pixel_clk_out, rst, 		hex_sel, hex);
endmodule
