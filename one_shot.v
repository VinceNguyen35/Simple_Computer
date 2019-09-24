`timescale 1ns / 100ps
/****************************** C E C S  3 0 1 ******************************
 * 
 * File Name:  one_shot.v
 * Project:    CECS 301 Lab 8: 16-Bit RISC Processor
 * Designer:   Matthew Buchholz 
 * Email:      matthew.buchholz@student.csulb.edu
 * Rev. No.:   Version 3.0
 * Rev. Date:  3/11/19 
 *
 * Purpose: Creates a one shot pulse (logic level HIGH) by sampling an exisiting signal
 *          The outgoing signal only remains high as long as the input has just switched
 *              from low to high (9 samples high and the first sample low)
 *          When the sample is stablilized the signal of the pulse goes low
 *          
 *          A one-shot pulse is desired (as opposed to a level pulse) to debounce a switch
 *              press. This gives a stabilized signal that is desired from the act of pressing
 *              a switch.
 *          1 new samples are taken each posedge clock (divided clock @ 500 hz)
 *          Output: generated pulse
 ****************************************************************************/

module one_shot(
    input clk,
    input rst,
    input sample,
    output wire pulse
    );
    
    reg [9:0] q;
    
    always @(posedge clk or posedge rst)
        if(rst == 1'b1)
            q <= 10'b0;
        else begin
            q[9] <= q[8];
            q[8] <= q[7];
            q[7] <= q[6];
            q[6] <= q[5];
            q[5] <= q[4];
            q[4] <= q[3];
            q[3] <= q[2];
            q[2] <= q[1];
            q[1] <= q[0];
            q[0] <= sample;
         end
         
    assign pulse = !q[9] & q[8] & q[7] & q[6] & q[5] & 
                     q[4] & q[3] & q[2] & q[1] & q[0];
endmodule
