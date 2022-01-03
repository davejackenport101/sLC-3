module testbench();
	timeunit 10ns;
	timeprecision 1ns;
	
	logic Clk;

	//variables so I can view my internal IR, MAR, MDR, PC, CC, BEN, etc
	logic [15:0] MAR_out, MDR_out, IR_out, PC_out, SR1_out, SR2_out, DATAP_out;
	logic [4:0] State_out;
	logic [2:0] CC_out;
	logic BEN_out;
	logic [3:0] hex_4_out[3:0];
	
	//copy input and output from slc3_testtop.sv
	//inputs
	logic [9:0] SW;
	logic	Run, Continue;
	
	//outputs
	logic [9:0] LED;
	logic [6:0] HEX0, HEX1, HEX2, HEX3;
	//logic [15:0] MAR, MDR, IR, PC;
	//logic CE, UB, LB, OE, WE;
	//logic [19:0] ADDR;
	//inout wire [15:0] Data;

	always begin : clk_gen
		#1 Clk = ~Clk;
	end
	
	initial begin : clk_init
		Clk = 0;
	end
	
	//initialize my top file
	slc3_testtop top(.*);
	
	//set temp variables to the internals
	always_comb begin
		MAR_out = top.slc.MAR;
		MDR_out = top.slc.MDR;
		IR_out = top.slc.IR;
		PC_out = top.slc.PC;
		CC_out = top.slc.CC;
		BEN_out = top.slc.BEN;
		SR1_out = top.slc.SR1;
		SR2_out = top.slc.SR2;
		DATAP_out = top.slc.DATAP;
		State_out = top.slc.state_controller.State;
		hex_4_out = top.slc.hex_4;
	end

	initial begin : test_vector
		Run = 0; Continue = 0;
		SW = 10'h006;
		LED = 10'h000;
		
		//test 1
		#2 Run = 1;
			Continue = 1;
			
		#2 Run = 0;
		
		#2 Run = 1;
		
		#95 SW = 10'h00E;
		
		#100 Continue = 0;
		
		#6 Continue = 1;
		
		#100 SW = 10'h005;
		
		#2 Continue = 0;
		
		#6 Continue = 1;
		
		#100 Continue = 0;
		
		#6 Continue = 1;
		
		
	end
	
	
endmodule 