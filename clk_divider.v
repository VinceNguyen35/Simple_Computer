`timescale 1ns / 100ps

/****************************** C E C S  3 0 1 ******************************
 * 
 * File Name:  clk_divider.v
 * Project:    CECS 301 Lab 8: 16-Bit RISC Processor
 * Designer:   Matthew Buchholz 
 * Email:      matthew.buchholz@student.csulb.edu
 * Rev. No.:   Version 2.0
 * Rev. Date:  3/11/19 
 *
 * Purpose: This module simply divides the incoming clock by counting 
 *             a calculated number of ticks before switching the clock from
 *					low to high
 *             (or vice versa).
 *          The formula for given ticks in a half period is below
 *          Ouput: 500 hz clock signal
 ****************************************************************************/

module clk_divider(
    input clk_in,
    input rst,
    output reg clk_out
    );
    
    integer i;
    
    /**
     * Divide incoming clock by the 32-bit decimal value given by
     *  1 / 2 * (freq_in / freq_out)
     **/
     always @(posedge clk_in or posedge rst) begin
        if(rst == 1'b1) begin
            i = 0;
            clk_out = 0;
        end
        
        /**
         * Posedge of clock:
         *  Increment the counter and check for half period
         **/
         else begin
            i = i + 1;
            if(i >= 100000) begin
                clk_out = ~clk_out;
                i = 0;
            end
         end
     end
endmodule
