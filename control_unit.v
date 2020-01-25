`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// File Name: 	control_unit.v
// Authors:	Vince Nguyen & Matthew Buchholz
// Rev. Date:	May 8, 2019
//
// Purpose:	A "Moore" finite state machine that implements the major cycles for
//		fetching and executing instructions for the 16-bit RISC Processor.
//
//////////////////////////////////////////////////////////////////////////////////

module control_unit(
    input 	  clk,			// clock
    input 	  reset,		// reset
    input  [15:0] ir,			// instruction register input
    input 	  N,			// datapath status inputs:	Negative
    input 	  Z,			//				Zero
    input 	  C,			// 				Carry
    output [2:0]  W_Adr,		// register file address outputs
    output [2:0]  R_Adr, 		//
    output [2:0]  S_Adr,		//
    output 	  adr_sel,		// mux select outputs
    output 	  s_sel,		//
    output 	  pc_ld,		// pc load
    output 	  pc_inc,		// pc inc
    output 	  pc_sel,		// pc select
    output 	  ir_ld,		// ir load
    output 	  mw_en,		// memory write
    output 	  rw_en,		// register file write
    output [3:0]  alu_op,		// ALU opcode output
    output [7:0]  status		// 8 LED outputs to display current state
    );

	/////////////////////////////
	//	data structures	   //
	/////////////////////////////

	reg	[2:0]	W_Adr, R_Adr, S_Adr;	// These 12
	reg		adr_sel, s_sel;		// fields make
	reg		pc_ld, pc_inc;		// up the
	reg		pc_sel, ir_ld;		// control word
	reg		mw_en, rw_en;		// of the
	reg	[3:0]	alu_op;			// control unit

	reg	[4:0]	state;			// present state register
	reg	[4:0]	nextstate;		// next state register
	reg	[7:0]	status;			// LED status/state outputs
	reg		ps_N, ps_Z, ps_C;	// present state flags register
	reg		ns_N, ns_Z, ns_C;	// next state flags register

	parameter	RESET=0,	FETCH=1,	DECODE=2,
					ADD=3,	SUB=4,	CMP=5,	MOV=6,
					INC=7,	DEC=8,	SHL=9,	SHR=10,
					LD=11,	STO=12,	LDI=13,
					JE=14,	JNE=15,	JC=16,	JMP=17,
					HALT=18,
					ILLEGAL_OP=31;

	///////////////////////////////////
	//	Control Unit Sequencer	 //
	///////////////////////////////////

	// synchronous state register assignment
	always @(posedge clk or posedge reset)
		if(reset)
			state = RESET;
		else
			state = nextstate;

	// synchronous flags register assignment
	always @(posedge clk or posedge reset)
		if(reset)
			{ps_N,ps_Z,ps_C} = 3'b0;
		else
			{ps_N,ps_Z,ps_C} = {ns_N,ns_Z,ns_C};

	// combinational logic section for both next state logic
	// and control word outputs for CPU_EU and memory modules
	always @(state)
		case(state)

			RESET:	begin			// Default Control Word Values
							// LED pattern = 1111_111
				W_Adr		= 3'b000;	R_Adr	 = 3'b000;	S_Adr	 = 3'b000;
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= 1'b0;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b0;		alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = 3'b0;
				status = 8'hFF;
				nextstate = FETCH;
			end

			FETCH:	begin			// IR <-- M[PC],	PC <- PC+1
							// LED pattern = 1000_000
				W_Adr		= 3'b000;	R_Adr	 = 3'b000;	S_Adr	 = 3'b000;
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= 1'b0;		pc_inc = 1'b1;		pc_sel = 1'b0;		ir_ld = 1'b1;
				mw_en		= 1'b0;		rw_en  = 1'b0;		alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N,ps_Z,ps_C};	// flags remain the same
				status = 8'h80;
				nextstate = DECODE;
			end

			DECODE:	begin			// Default Control Word, NS <- case(IR[15:9])
							// LED pattern = 1100_000
				W_Adr		= 3'b000;	R_Adr	 = 3'b000;	S_Adr	 = 3'b000;
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= 1'b0;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b0;		alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N,ps_Z,ps_C};	// flags remain the same
				status = 8'hC0;
				case(ir[15:9])
					7'h70:	nextstate = ADD;
					7'h71:	nextstate = SUB;
					7'h72:	nextstate = CMP;
					7'h73:	nextstate = MOV;
					7'h74:	nextstate = SHL;
					7'h75:	nextstate = SHR;
					7'h76:	nextstate = INC;
					7'h77:	nextstate = DEC;
					7'h78:	nextstate = LD;
					7'h79:	nextstate = STO;
					7'h7a:	nextstate = LDI;
					7'h7b:	nextstate = HALT;
					7'h7c:	nextstate = JE;
					7'h7d:	nextstate = JNE;
					7'h7e:	nextstate = JC;
					7'h7f:	nextstate = JMP;
					default:	nextstate = ILLEGAL_OP;
				endcase
			end

			ADD:	begin			// R[ir(8:6)] <- R[ir(5:3)] + R[ir(2:0)]
							// LED pattern = {ps_N,ps_Z,ps_C,5'b00000}
				W_Adr		= ir[8:6];	R_Adr	 = ir[5:3];	S_Adr	 = ir[2:0];
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= 1'b0;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b1;		alu_op = 4'b0100;
				{ns_N,ns_Z,ns_C} = {N,Z,C};
				status = {ps_N,ps_Z,ps_C,5'b00000};
				nextstate = FETCH;	// go back to fetch
			end

			SUB:	begin			// R[ir(8:6)] <- R[ir(5:3)] - R[ir(2:0)]
							// LED pattern = {ps_N,ps_Z,ps_C,5'b00001}
				W_Adr		= ir[8:6];	R_Adr	 = ir[5:3];	S_Adr	 = ir[2:0];
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= 1'b0;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b1;		alu_op = 4'b0101;
				{ns_N,ns_Z,ns_C} = {N,Z,C};
				status = {ps_N,ps_Z,ps_C,5'b00001};
				nextstate = FETCH;	// go back to fetch
			end

			CMP:	begin			// R[ir(5:3)] - R[ir(2:0)]
							// LED pattern = {ps_N,ps_Z,ps_C,5'b00010}
				W_Adr		= 3'b000;	R_Adr	 = ir[5:3];	S_Adr	 = ir[2:0];
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= 1'b0;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b0;		alu_op = 4'b0101;
				{ns_N,ns_Z,ns_C} = {N,Z,C};
				status = {ps_N,ps_Z,ps_C,5'b00010};
				nextstate = FETCH;	// go back to fetch
			end

			MOV:	begin			// R[ir(8:6)] <- R[ir(2:0)]
							// LED pattern = {ps_N,ps_Z,ps_C,5'b00011}
				W_Adr		= ir[8:6];	R_Adr	 = 3'b000;	S_Adr	 = ir[2:0];
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= 1'b0;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b1;		alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N,ps_Z,ps_C};	// flags remain the same
				status = {ps_N,ps_Z,ps_C,5'b00011};
				nextstate = FETCH;	// go back to fetch
			end

			SHL:	begin			// R[ir(8:6)] <- R[ir(2:0)] << 1
							// LED pattern = {ps_N,ps_Z,ps_C,5'b00100}
				W_Adr		= ir[8:6];	R_Adr	 = 3'b000;	S_Adr	 = ir[2:0];
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= 1'b0;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b1;		alu_op = 4'b0111;
				{ns_N,ns_Z,ns_C} = {N,Z,C};
				status = {ps_N,ps_Z,ps_C,5'b00100};
				nextstate = FETCH;	// go back to fetch
			end

			SHR:	begin			// R[ir(8:6)] <- R[ir(2:0)] >> 1
							// LED pattern = {ps_N,ps_Z,ps_C,5'b00101}
				W_Adr		= ir[8:6];	R_Adr	 = 3'b000;	S_Adr	 = ir[2:0];
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= 1'b0;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b1;		alu_op = 4'b0110;
				{ns_N,ns_Z,ns_C} = {N,Z,C};
				status = {ps_N,ps_Z,ps_C,5'b00101};
				nextstate = FETCH;	// go back to fetch
			end

			INC:	begin			// R[ir(8:6)] <- R[ir(2:0)] + 1
							// LED pattern = {ps_N,ps_Z,ps_C,5'b00110}
				W_Adr		= ir[8:6];	R_Adr	 = 3'b000;	S_Adr	 = ir[2:0];
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= 1'b0;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b1;		alu_op = 4'b0010;
				{ns_N,ns_Z,ns_C} = {N,Z,C};
				status = {ps_N,ps_Z,ps_C,5'b00110};
				nextstate = FETCH;	// go back to fetch
			end

			DEC:	begin			// R[ir(8:6)] <- R[ir(2:0)] - 1
							// LED pattern = {ps_N,ps_Z,ps_C,5'b00111}
				W_Adr		= ir[8:6];	R_Adr	 = 3'b000;	S_Adr	 = ir[2:0];
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= 1'b0;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b1;		alu_op = 4'b0011;
				{ns_N,ns_Z,ns_C} = {N,Z,C};
				status = {ps_N,ps_Z,ps_C,5'b00111};
				nextstate = FETCH;	// go back to fetch
			end

			LD:	begin			// R[ir(8:6)] <- M[ R[ir(2:0)] ]
							// LED pattern = {ps_N,ps_Z,ps_C,5'b01000}
				W_Adr		= ir[8:6];	R_Adr	 = ir[2:0];	S_Adr	 = 3'b000;
				adr_sel	= 1'b1;		s_sel  = 1'b1;
				pc_ld		= 1'b0;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b1;		alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N,ps_Z,ps_C};	// flags remain the same
				status = {ps_N,ps_Z,ps_C,5'b01000};
				nextstate = FETCH;	// go back to fetch
			end

			STO:	begin			// M[ R[ir(8:6)] ] <- R[ir(2:0)]
							// LED pattern = {ps_N,ps_Z,ps_C,5'b01001}
				W_Adr		= 3'b000;	R_Adr	 = ir[8:6];	S_Adr	 = ir[2:0];
				adr_sel	= 1'b1;		s_sel  = 1'b0;
				pc_ld		= 1'b0;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b1;		rw_en  = 1'b0;		alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N,ps_Z,ps_C};	// flags remain the same
				status = {ps_N,ps_Z,ps_C,5'b01001};
				nextstate = FETCH;	// go back to fetch
			end

			LDI:	begin			// R[ir(8:6)] <- M[PC], PC <- PC + 1
							// LED pattern = {ps_N,ps_Z,ps_C,5'b1010}
				W_Adr		= ir[8:6];	R_Adr	 = 3'b000;	S_Adr	 = 3'b000;
				adr_sel	= 1'b0;		s_sel  = 1'b1;
				pc_ld		= 1'b0;		pc_inc = 1'b1;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b1;		alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N,ps_Z,ps_C};	// flags remain the same
				status = {ps_N,ps_Z,ps_C,5'b01010};
				nextstate = FETCH;	// go back to fetch
			end

			JE:	begin			// if (ps Z=1) 		PC <-- PC+se IR[7:0]
							// else			PC <-- PC
							// LED pattern = {ps_N,ps_Z,ps_C,5'b1100}
				W_Adr		= 3'b000;	R_Adr	 = 3'b000;	S_Adr	 = 3'b000;
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= ps_Z;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b0;		alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N,ps_Z,ps_C};	// flags remain the same
				status = {ps_N,ps_Z,ps_C,5'b01100};
				nextstate = FETCH;	// go back to fetch
			end

			JNE:	begin			// if (ps Z=0) 		PC <-- PC+se IR[7:0]
							// else			PC <-- PC
							// LED pattern = {ps_N,ps_Z,ps_C,5'b1101}
				W_Adr		= 3'b000;	R_Adr	 = 3'b000;	S_Adr	 = 3'b000;
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= !ps_Z;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b0;		alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N,ps_Z,ps_C};	// flags remain the same
				status = {ps_N,ps_Z,ps_C,5'b01101};
				nextstate = FETCH;	// go back to fetch
			end

			JC:	begin			// if (ps C=1) 		PC <-- PC+se IR[7:0]
							// else			PC <-- PC
							// LED pattern = {ps_N,ps_Z,ps_C,5'b1110}
				W_Adr		= 3'b000;	R_Adr	 = 3'b000;	S_Adr	 = 3'b000;
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= ps_C;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b0;		alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N,ps_Z,ps_C};	// flags remain the same
				status = {ps_N,ps_Z,ps_C,5'b01110};
				nextstate = FETCH;	// go back to fetch
			end

			JMP:	begin			// PC <-- R[ir(2:0)]
							// LED pattern = {ps_N,ps_Z,ps_C,5'b1111}
				W_Adr		= 3'b000;	R_Adr	 = 3'b000;	S_Adr	 = ir[2:0];
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= 1'b1;		pc_inc = 1'b0;		pc_sel = 1'b1;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b0;		alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N,ps_Z,ps_C};	// flags remain the same
				status = {ps_N,ps_Z,ps_C,5'b01111};
				nextstate = FETCH;	// go back to fetch
			end

			HALT:	begin			// Default Control Word Values
							// LED pattern = {ps_N,ps_Z,ps_C,5'b1011}
				W_Adr		= 3'b000;	R_Adr	 = 3'b000;	S_Adr	 = 3'b000;
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= 1'b0;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b0;		alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = 3'b0;	// flags remain the same
				status = {ps_N,ps_Z,ps_C,5'b1011};
				nextstate = HALT;	// loop here forever
			end

			ILLEGAL_OP:	begin			// Default Control Word Values
								// LED pattern = 111_0000
				W_Adr		= 3'b000;	R_Adr	 = 3'b000;	S_Adr	 = 3'b000;
				adr_sel	= 1'b0;		s_sel  = 1'b0;
				pc_ld		= 1'b0;		pc_inc = 1'b0;		pc_sel = 1'b0;		ir_ld = 1'b0;
				mw_en		= 1'b0;		rw_en  = 1'b0;		alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = 3'b0;	// flags remain the same
				status = 8'hF0;
				nextstate = ILLEGAL_OP;	// loop here forever
			end

		endcase
			
endmodule
