module datapath(input [3:0] Data_Select,
					input [15:0] MAR, MDR, ALU, PC, 
					output logic [15:0] DATAP);
					
		always_comb begin
			case (Data_Select)
				4'b1000 :
					DATAP = PC;
				4'b0100 :
					DATAP = ALU;
				4'b0010 :
					DATAP = MDR;
				4'b0001 :
					DATAP = MAR;
				default :
					DATAP = 16'hx;
			endcase
		end
		
endmodule 



module data_registers(input Clk, Reset, LD_MAR, LD_MDR, LD_PC, LD_IR, LD_CC, LD_BEN, LD_LED, BEN_Input, MIO_EN, ADDR1MUX, MARMUX,
							input [1:0] PCMUX, ADDR2MUX,
							input [2:0] CC_Input,
							input [15:0] MDR_In, DATAP, PC_curr, MDR_curr, SR1, IR_curr, PCoffset11, PCoffset9, offset6,
							output logic BEN,
							output logic [2:0] CC,
							output logic [11:0] LED_out,
							output logic [15:0] PC, MAR, MDR, IR);
							
	logic [15:0] PC_Input, MDR_Input, PC_Adder, ADDR1, ADDR2, MAR_Adder, MAR_Input;
							
	always_comb begin
		case (ADDR1MUX)
			1'b0 :
				ADDR1 = PC_curr;
			1'b1 :
				ADDR1 = SR1;
		endcase
		
		case (ADDR2MUX)
			2'b11 :
				ADDR2 = PCoffset11;
			2'b01 :
				ADDR2 = PCoffset9;
			2'b10 :
				ADDR2 = offset6;
			2'b00 :
				ADDR2 = 16'h0000;
		endcase
	
		PC_Adder = ADDR1 + ADDR2;
		MAR_Adder = ADDR1 + ADDR2;
		
		case (MARMUX)
			1'b0 :
				MAR_Input = DATAP;
			1'b1 :
				MAR_Input = MAR_Adder;
		endcase
		
		case (PCMUX)
			2'b00 : 
				PC_Input = PC_curr + 1;
			2'b01 : 
				PC_Input = DATAP;
			2'b10:
				PC_Input = PC_Adder;
			default : 
				PC_Input = PC_curr;
		endcase
		
		case (MIO_EN)
			1'b0 : 
				MDR_Input = DATAP;
			1'b1 : 
				MDR_Input = MDR_In;
		endcase
		
	end
	
	register PC_reg(.*, .Load(LD_PC), .Data(PC_Input), .Data_Out(PC));
	register IR_reg(.*, .Load(LD_IR), .Data(DATAP), .Data_Out(IR));
	register MAR_reg(.*, .Load(LD_MAR), .Data(MAR_Input), .Data_Out(MAR));
	register MDR_reg(.*, .Load(LD_MDR), .Data(MDR_Input), .Data_Out(MDR));		
	register #(1) BEN_reg(.*, .Load(LD_BEN), .Data(BEN_Input), .Data_Out(BEN));
	register #(3) CC_reg(.*, .Load(LD_CC), .Data(CC_Input), .Data_Out(CC));	
	register #(12) LED_reg(.*, .Load(LD_LED), .Data(IR_curr[11:0]), .Data_Out(LED_out));
	
endmodule