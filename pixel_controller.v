`timescale 1ns / 100ps
/****************************** C E C S  3 0 1 ******************************
 * 
 * File Name:  pixel_controller.v
 * Project:    CECS 301 Lab 6: Register Files
 * Designer:   Matthew Buchholz 
 * Email:      matthew.buchholz@student.csulb.edu
 * Rev. No.:   Version 2.0
 * Rev. Date:  3/20/19
 *
 * Purpose: Verilog module for an autonomous state machine.
 *					-consists of sequential logic block that indefinitely iterates
 *						through 8 states
 *					-outputs 11-bits: 
 *					 8-bit to select which anode to turn on and change the LEDs on
 *					 	3-bit to send select signal to address mux to select which
 *						data nibble to display
 *                  -Using Moore template #2
 *					
 *
 ****************************************************************************/

module pixel_controller(
    input  clk,
    input  rst,
    output reg [7:0] anodes,
    output reg [2:0] seg_sel
    );

    reg [2:0] present_state, next_state;
    
    /**
     * Next state combinational logic
     */
    always @ (present_state)
        case (present_state)
            3'b000 : next_state = 3'b001;
            3'b001 : next_state = 3'b010;
            3'b010 : next_state = 3'b011;
            3'b011 : next_state = 3'b100;
            
            3'b100 : next_state = 3'b101;
            3'b101 : next_state = 3'b110;
            3'b110 : next_state = 3'b111;
            3'b111 : next_state = 3'b000;
            default: next_state = 3'b0;
        endcase

    /**
     * Sequential Logic
     */
    always @ (posedge clk or posedge rst)
        if( rst == 1'b1)
            present_state = 3'b0;
        else
            present_state = next_state;

    /**
     * Output combinational logic
     */
    always @ (present_state)
        case (present_state)
            3'b000 : {anodes, seg_sel} = 11'b1111_1110_000;
            3'b001 : {anodes, seg_sel} = 11'b1111_1101_001;
            3'b010 : {anodes, seg_sel} = 11'b1111_1011_010;
            3'b011 : {anodes, seg_sel} = 11'b1111_0111_011;
            
            3'b100 : {anodes, seg_sel} = 11'b1110_1111_100;
            3'b101 : {anodes, seg_sel} = 11'b1101_1111_101;
            3'b110 : {anodes, seg_sel} = 11'b1011_1111_110;
            3'b111 : {anodes, seg_sel} = 11'b0111_1111_111;
            default: {anodes, seg_sel} = 11'b0;
        endcase
endmodule