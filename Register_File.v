`timescale 1ns / 100ps

/****************************************************************************
 * 
 * File Name:  Register_File.v
 * Designer:   Matthew Buchholz 
 * Email:      matthew.buchholz@student.csulb.edu
 * Rev. No.:   Version 1.0
 * Rev. Date:  3/20/19
 *
 * Purpose: 	A 16 bit register to be used as a 8 x 16 memory.
 *		The module instantiates three 3 to 8 decoders and eight
 *		reg16 modules.
 *
 ****************************************************************************/

module Register_File(
    input 	  clk,
    input         rst,
    input  [2:0]  W_Adr,
    input 	  we,
    input  [2:0]  R_Adr,
    input  [2:0]  S_Adr,
    input  [15:0] W,
    output [15:0] R,
    output [15:0] S
    );
	 
	 wire [7:0] load, out_enA, out_enB;
	 
	 decoder_3to8 d0(W_Adr, we, load),
					  d1(R_Adr, 1'b1, out_enA),
					  d2(S_Adr, 1'b1, out_enB);
	 
	 reg16 r0(clk, rst, load[0], W, out_enA[0], out_enB[0], R, S),
			 r1(clk, rst, load[1], W, out_enA[1], out_enB[1], R, S),
			 r2(clk, rst, load[2], W, out_enA[2], out_enB[2], R, S),
			 r3(clk, rst, load[3], W, out_enA[3], out_enB[3], R, S),
			 r4(clk, rst, load[4], W, out_enA[4], out_enB[4], R, S),
			 r5(clk, rst, load[5], W, out_enA[5], out_enB[5], R, S),
			 r6(clk, rst, load[6], W, out_enA[6], out_enB[6], R, S),
			 r7(clk, rst, load[7], W, out_enA[7], out_enB[7], R, S);


endmodule
