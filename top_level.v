`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////////////////
// File Name: 	top_level.v
// Project:		CECS 301 Lab 8: 16-Bit RISC Processor
//	Student:		Vince Nguyen & Matthew Buchholz
//	Rev. Date:	May 8, 2019
//
//	Purpose:		This is the top level module that instantiates all the modules
//					for the RISC Processor.
//
//	Notes:		The module uses a clock divider of 500hz, a one shot debounce for
//					500hz clock, another one shot debounce for stepping through memory,
//					a 16-bit RISC Processor, 3 RAM files that are 256x16 (but only uses
//					one for demo purposes, a counter to go through memory, and a
//					display controller.
//
//////////////////////////////////////////////////////////////////////////////////

module top_level(
    input        clk_100,
    input        rst,
    input		  step_clk,
	 input		  step_mem,
    input        dump_mem,
	 output [7:0] status,
    output [7:0] anodes,
	 output [6:0] seg
	);
    
    wire        clk_500, pulse, pulse_mem, mw_en;
    wire [15:0] cpu_out, addr_out, mem_out, mem_dump, mem_count;
    
    clk_divider			 u0(clk_100, rst, clk_500);
    one_shot		       u1(clk_500, rst, step_clk, pulse);
	 one_shot				 u2(clk_500, rst, step_mem, pulse_mem);
	 RISC_Processor		 u3(pulse,
									 rst,
									 mem_out,
									 cpu_out,
									 addr_out,
									 status,
									 mw_en);
	 Mem_Dump_Counter		 u4(pulse_mem, rst, mem_dump);
    //ram1a                 u5(clk_100, mw_en, mem_count, cpu_out, mem_out);
	 //ram2a                 u5(clk_100, mw_en, mem_count, cpu_out, mem_out);
	 ram3a                u5(clk_100, mw_en, mem_count, cpu_out, mem_out);	 
    Display_Controller   u6(clk_100, rst, {mem_count, mem_out}, anodes, seg);
	 
	 // DUMP-MEM-MUX
    assign 					 mem_count = (dump_mem == 1'b1) ? mem_dump : addr_out;
	 
endmodule
