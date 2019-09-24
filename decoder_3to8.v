`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////////////////
// File Name: 	decoder_3to8.v
// Project:		CECS 301 Lab 5: Register Files
//	Student:		Vince Nguyen
//	Rev. Date:	Mar. 20, 2019
//
//	Purpose:		This is a 3 to 8 decoder that selects a single output signal based
//					on a 3 bit input signal.
//
//	Notes:		The decoder will only select a single signal if enable is active.
//					Otherwise, output will be zero.
//
//////////////////////////////////////////////////////////////////////////////////


module decoder_3to8(
    input      [2:0]  data,
    input      		 enable,
    output reg [7:0]  out
    );
    
    always @(*)
		  if(enable == 1'b1)
			  case(data)
					3'b000 : out = 8'b0000_0001;
					3'b001 : out = 8'b0000_0010;
					3'b010 : out = 8'b0000_0100;
					3'b011 : out = 8'b0000_1000;
					3'b100 : out = 8'b0001_0000;
					3'b101 : out = 8'b0010_0000;
					3'b110 : out = 8'b0100_0000;
					3'b111 : out = 8'b1000_0000;
					
					default: out = 8'b0;
			  endcase
			  
		  else out = 8'b0;
endmodule
