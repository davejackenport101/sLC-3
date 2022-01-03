module register_file(input Clk, Reset, LD_REG, DRMUX, SR1MUX, SR2MUX,
							input [15:0] DATAP, IR, PC, imm5,
							output logic [15:0] SR1, SR2);
							
	logic [2:0] SR1_choose;
	logic [8:0] LD_R, LD_R_1;
	logic [15:0] R0, R1, R2, R3, R4, R5, R6, R7, SR2_1;
	
	//decoder of IR[11:9] to assign proper load values for the 8 registers
	always_comb begin
				
		//handles assignment of SR1
		case (SR1MUX)
			1'b1 : 
				SR1_choose = IR[11:9];
			1'b0 :
				SR1_choose = IR[8:6];
		endcase
		
		case (SR1_choose)
			3'b000:
				SR1 = R0;
			3'b001:
				SR1 = R1;
			3'b010:
				SR1 = R2;
			3'b011:
				SR1 = R3;
			3'b100:
				SR1 = R4;
			3'b101:
				SR1 = R5;
			3'b110:
				SR1 = R6;
			3'b111:
				SR1 = R7;
		endcase
					
		//handles assignment of SR2
		
		case (IR[2:0])
			3'b000 :
				SR2_1 = R0;
			3'b001 :
				SR2_1 = R1;
			3'b010 :
				SR2_1 = R2;
			3'b011 :
				SR2_1 = R3;
			3'b100 :
				SR2_1 = R4;
			3'b101 :
				SR2_1 = R5;
			3'b110 :
				SR2_1 = R6;
			3'b111 :
				SR2_1 = R7;
		endcase
		
		case (SR2MUX)
			1'b0 : 
				SR2 = SR2_1;
				
			1'b1 :
				SR2 = imm5;
		endcase

		//performs all of the control of the DR
		case (IR[11:9])
			3'b000 :
				LD_R_1 = 9'b000000001;
			3'b001 :
				LD_R_1 = 9'b000000010;
			3'b010 :
				LD_R_1 = 9'b000000100;
			3'b011 :
				LD_R_1 = 9'b000001000;
			3'b100 :
				LD_R_1 = 9'b000010000;
			3'b101 :
				LD_R_1 = 9'b000100000;
			3'b110 :
				LD_R_1 = 9'b001000000;
			3'b111 :
				LD_R_1 = 9'b010000000;
		endcase
		
		case(DRMUX)
			1'b1 :
				LD_R = 9'b010000000;
			1'b0 :
				LD_R = LD_R_1;
		endcase
		
		if (!LD_REG)
			LD_R = 9'b100000000;
		
	end
		
	register Reg0(.*, .Load(LD_R[0]), .Data(DATAP), .Data_Out(R0));
	register Reg1(.*, .Load(LD_R[1]), .Data(DATAP), .Data_Out(R1));
	register Reg2(.*, .Load(LD_R[2]), .Data(DATAP), .Data_Out(R2));
	register Reg3(.*, .Load(LD_R[3]), .Data(DATAP), .Data_Out(R3));
	register Reg4(.*, .Load(LD_R[4]), .Data(DATAP), .Data_Out(R4));
	register Reg5(.*, .Load(LD_R[5]), .Data(DATAP), .Data_Out(R5));
	register Reg6(.*, .Load(LD_R[6]), .Data(DATAP), .Data_Out(R6));
	register Reg7(.*, .Load(LD_R[7]), .Data(DATAP), .Data_Out(R7));
	
endmodule



module register
						#(parameter width = 16)
						 (input Clk, Load, Reset,
						  input [width-1:0] Data, 
						  output logic [width-1:0] Data_Out) ;
						  
	logic [width-1:0] Dout;
	
	always_ff @(posedge Clk) begin
		if (Reset) Dout <= 16'h0000;
		else if (Load) Dout <= Data;
	end
	
	assign Data_Out = Dout;
					
endmodule 