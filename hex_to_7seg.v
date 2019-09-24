`timescale 1ns / 100ps

/****************************** C E C S  3 0 1 ******************************
 * 
 * File Name:  hex_to_7seg.v
 * Project:    Lab Project 4: Memory & Display Controllers
 * Designer:   Matthew Buchholz 
 * Email:      matthew.buchholz@student.csulb.edu
 * Rev. No.:   Version 2.0
 * Rev. Date:  3/11/19
 *
 * Purpose: -4:16 decoder that maps a 4-bit input vector to the corresponding
 *					7-bit vector
 *             where each bit in the 7-bit vector corresponds to a single
 *					7-segment LED
 *          -7 segment LEDs are LOW active
 *          -For this lab a mix of upper and lower case letters are displayed,
 *					but may change
 *             for later labs
 *
 ****************************************************************************/

module hex_to_7seg(
    input        clk,
    input        reset,
    input  [3:0] hex,
    output [6:0] segment     
    );
    
    assign segment = (hex == 4'b0_000) ? 7'b100_0000: //display 0 on 7-segment
                     (hex == 4'b0_001) ? 7'b111_1001: //display 1 on 7-segment
                     (hex == 4'b0_010) ? 7'b010_0100: //display 2 on 7-segment
                     (hex == 4'b0_011) ? 7'b011_0000: //display 3 on 7-segment
                     (hex == 4'b0_100) ? 7'b001_1001: //display 4 on 7-segment
                     (hex == 4'b0_101) ? 7'b001_0010: //display 5 on 7-segment
                     (hex == 4'b0_110) ? 7'b000_0010: //display 6 on 7-segment
                     (hex == 4'b0_111) ? 7'b111_1000: //display 7 on 7-segment
                     (hex == 4'b1_000) ? 7'b000_0000: //display 8 on 7-segment
                     (hex == 4'b1_001) ? 7'b001_0000: //display 9 on 7-segment
                     (hex == 4'b1_010) ? 7'b000_1000: //display A on 7-segment
                     (hex == 4'b1_011) ? 7'b000_0011: //display b on 7-segment
                     (hex == 4'b1_100) ? 7'b100_0110: //display C on 7-segment
                     (hex == 4'b1_101) ? 7'b010_0001: //display d on 7-segment
                     (hex == 4'b1_110) ? 7'b000_0110: //display E on 7-segment
                     (hex == 4'b1_111) ? 7'b000_1110: //display F on 7-segment
                                         7'b111_1111; //display blank on 7-segment
    
endmodule
