`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// File Name: 	ram1a.v
// Authors:	Vince Nguyen & Matthew Buchholz
// Rev. Date:	May 8, 2019
//
// Purpose:	This is the first RAM file, which is 256 bits deep and 16 bits
//		wide.
//
//////////////////////////////////////////////////////////////////////////////////

module ram1a(
    input 	       clk,
    input 	       we,
    input 	[15:0] addr,
    input 	[15:0] din,
    output 	[15:0] dout
    );
	 
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
	ram_256x16 dut (
	  .clka(clk), // input clka
	  .wea(we), // input [0 : 0] wea
	  .addra(addr), // input [7 : 0] addra
	  .dina(din), // input [15 : 0] dina
	  .douta(dout) // output [15 : 0] douta
	);
// INST_TAG_END ------ End INSTANTIATION Template ---------


endmodule
