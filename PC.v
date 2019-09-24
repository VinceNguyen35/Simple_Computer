`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// File Name: 	PC.v
// Project:		CECS 301 Lab 8: 16-bit RISC Processor
//	Student:		Vince Nguyen & Matthew Buchholz
//	Rev. Date:	May 8, 2019
//
//	Purpose:		This is the Program Counter, which keeps a count of which
//					instruction is being exectued in the CPU_EU.  The module will load
//					new instructions if ld is a 1.  If inc is a 1, then the Program
//					Counter will increment by 1.  Ld has a higher priority over inc.
//
//////////////////////////////////////////////////////////////////////////////////

module PC(
    input 				 clk,
    input 				 rst,
    input 				 ld,
    input 				 inc,
    input 		[15:0] D_in,
    output reg	[15:0] D_out
    );
	 
	 always @(posedge clk or posedge rst)
		if(rst)
			D_out = 16'b0;
		else
			if(ld)
				D_out = D_in;
			else
				if(inc)
					D_out = D_out + 1;
				else
					D_out = D_out;

endmodule
