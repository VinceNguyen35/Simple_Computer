`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////////////////
// File Name: 	CPU_EU.v
// Authors:	Vince Nguyen & Matthew Buchholz
// Rev. Date:	May 8, 2019
//
// Purpose:	This is the CPU Execution Unit.  The module utilizes an integer
//		datapath to execute instructions and write out to memory.  The 
//		module outputs a 16-bit address location and 16 bits of data out, 
//		along with 16 bits of data input.  A program counter and instruction
//		register is made as well, along with a 2-to-1 mux.  Lastly, a sign
//		extension statement is made to extend an 8-bit signed value to a
//		16-bit signed value, which will be added to a program counted to
//		be put back into the program counter.
//
//////////////////////////////////////////////////////////////////////////////////

module CPU_EU(
    input              clk,
    input              rst,
    input              adr_sel,
    input	       pc_sel,
    input              s_sel,
    input              pc_ld,
    input              pc_inc,
    input              reg_w_en,
    input              ir_ld,
    input	[2:0]  W_Adr,
    input	[2:0]  R_Adr,
    input	[2:0]  S_Adr,
    input	[3:0]  Alu_Op,
    input  	[15:0] D_in,
    output 	[15:0] adr,
    output	       N,
    output	       Z,
    output	       C,
    output wire	[15:0] D_out, 
    output wire	[15:0] ir_out
    );
    
    wire [15:0] reg_out, pc, pc_mux_out, sign_ext, sign_ext_add;
    
    IR			 ir(clk,
                            rst,
                            ir_ld,
                            D_in,
                            ir_out);
                            
    int_datapath      IntDP(clk, 
                            rst, 
                            W_Adr,
                            reg_w_en,
                            R_Adr, 
                            S_Adr,
                            D_in,
                            s_sel,
                            Alu_Op,
                            reg_out,
                            D_out,
                            N,
                            Z,
                            C);
                      
    PC	     ProgramCounter(clk,
                            rst,
                            pc_ld,
                            pc_inc,
                            pc_mux_out,
                            pc);
    
    // ADR-MUX
    assign adr = (adr_sel == 1'b1) ? reg_out : pc;
	 
	 // sign extension
	 assign sign_ext = {{8{ir_out[7]}}, ir_out[7:0]};
	 
	 // SIGN-EXT-ADD
	 assign sign_ext_add = sign_ext + pc;
	 
	 // PC-MUX
	 assign pc_mux_out = (pc_sel == 1'b1) ? D_out : sign_ext_add;
                   
endmodule
