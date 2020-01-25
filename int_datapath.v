`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////////////////
// File Name: 	int_datapath.v
// Author:		Matthew Buchholz
// Rev. Date:	April 8, 2019
//
// Purpose:		This is the integer datapath module. The module instantiates a
//				8 x 16 register file and a ALU module.
//
// Notes:		A 2 to 1 mux is made within this module that selects the value of
//              the S address when the mux is a 0 and DS when the mux is a 1.
//
//////////////////////////////////////////////////////////////////////////////////

module int_datapath(
    input              clk,
    input              rst,
    input       [2:0]  W_Adr,
    input              we,
    input       [2:0]  R_Adr,
    input       [2:0]  S_Adr,
    input       [15:0] DS,
    input              S_Sel,
    input       [3:0]  ALU_OP,
    output wire [15:0] Reg_Out,
    output wire [15:0] Alu_Out,
    output             N,
    output             Z,
    output             C
    );
    
    wire [15:0] S, smux_out;
    
    Register_File u0(clk, rst, W_Adr, we, R_Adr, S_Adr, Alu_Out, Reg_Out, S);
    //S-MUX
    assign smux_out = (S_Sel == 1'b1) ? DS : S;
    
    alu16 u1(Reg_Out, smux_out, ALU_OP, Alu_Out, N, Z, C);
    
endmodule
