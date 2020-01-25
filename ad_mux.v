`timescale 1ns / 100ps

/****************************************************************************
 * 
 * File Name:  ad_mux.v
 * Designer:   Matthew Buchholz 
 * Email:      matthew.buchholz@student.csulb.edu
 * Rev. No.:   Version 1.0
 * Rev. Date:  3/11/19
 *
 * Purpose:    8-1 Multiplexer that takes as input the address and data stored
 *			   in that address
 *			   Uses 3 bit select signal from state machine to select the output
 *			   nibble to be displayed
 *			   on an 7-segment display
 *
 ****************************************************************************/

module ad_mux(
    input      [31:0] data,
    input      [2:0]  select,
    output reg [3:0]  out
    );
    
    always @(*)
        case(select)
            3'b000 : out = data[3:0];
            3'b001 : out = data[7:4];
            3'b010 : out = data[11:8];
            3'b011 : out = data[15:12];
            
            3'b100 : out = data[19:16];
            3'b101 : out = data[23:20];
            3'b110 : out = data[27:24];
            3'b111 : out = data[31:28];
            
            default: out = 4'b0000;
        endcase    
endmodule
