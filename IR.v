`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// File Name: 	IR.v
// Student:	Vince Nguyen & Matthew Buchholz
// Rev. Date:	May 8, 2019
//
// Purpose:	This is the Instruction Register, which sends instructions to be
//		executed in the CPU_EU.  The module will load new instructions if
//		ld is a 1, otherwise will retain the current instruction.
//
//////////////////////////////////////////////////////////////////////////////////

module IR(
    input 	       clk,
    input 	       rst,
    input 	       ld,
    input 	[15:0] D_in,
    output reg	[15:0] D_out
    );
	 
    always @(posedge clk or posedge rst)
	if(rst == 1)
		D_out = 16'b0;
	else
		if(ld)
			D_out = D_in;
		else
			D_out = D_out;

endmodule
