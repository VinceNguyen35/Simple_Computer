`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// File Name: 	RISC_Processor.v
// Authors:	Vince Nguyen & Matthew Buchholz
// Rev. Date:	May 8, 2019
//
// Purpose:	To instantiate the control unit and the CPU Execution unit to make
//		the 16-bit RISC Processor.
//
//////////////////////////////////////////////////////////////////////////////////

module RISC_Processor(
    input	  clk,
    input	  rst,
    input  [15:0] D_in,
    output [15:0] D_out,
    output [15:0] Address,
    output [7:0]  status,
    output 	  mw_en
    );
	 
    wire   [2:0]  W_Adr, R_Adr, S_Adr;
    wire   [3:0]  Alu_Op;
    wire   [15:0] IR_out;
    wire	  rw_en, s_sel, adr_sel, ir_ld, pc_ld, pc_inc, pc_sel, N, Z, C;
	 

	control_unit         u1(clk,
				rst,
				IR_out,
				N,
				Z,
				C,
				W_Adr,
				R_Adr,
				S_Adr,
				adr_sel,
				s_sel,
				pc_ld,
				pc_inc,
				pc_sel,
				ir_ld,
				mw_en,
				rw_en,
				Alu_Op,
				status);
	
	CPU_EU         	     u2(clk,
				rst,
				adr_sel,
				pc_sel,
				s_sel,
				pc_ld,
				pc_inc,
				rw_en,
				ir_ld,
				W_Adr,
				R_Adr,
				S_Adr,
				Alu_Op,
				D_in,
				Address,
				N,
				Z,
				C,
				D_out,
				IR_out); 

endmodule
