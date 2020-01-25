`timescale 1ns / 100ps
/***************************************************************************
 * 
 * File Name:  reg16.v
 * Designer:   Matthew Buchholz 
 * Email:      matthew.buchholz@student.csulb.edu
 * Rev. No.:   Version 1.0
 * Rev. Date:  3/20/19
 *
 * Purpose: 	A 16 bit register to be used as a 8 x 16 memory.
 *					
 ****************************************************************************/

module reg16(
    input         clk,
    input         rst,
    input         load,
    input  [15:0] Din,
    input         out_enA,
    input         out_enB,
    output [15:0] D_A,
    output [15:0] D_B
    );
    
    reg [15:0] Dout;
    
    //behavioral section for writing to the register
    always @ (posedge clk or posedge rst)
        if (rst)
            Dout <= 16'b0;
        else
            if (load)
                Dout <= Din;
            else
                Dout <= Dout;
        
        //conditional continuous assignments for reading the register
        assign D_A = out_enA ? Dout : 16'hz;
        assign D_B = out_enB ? Dout : 16'hz;
endmodule
