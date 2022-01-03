module alu	(input [1:0] ALUK,
				input[15:0] SR1, SR2, DATAP,
				output logic [2:0] CC_Input,
				output logic [15:0] ALU);
		
	logic [15:0] out;
	
	always_comb begin
				
		//set the CC_Input bits depending on whatever value is on the DATAP
		if (DATAP[15] == 1'b1)
			CC_Input = 3'b100;
		else if (DATAP == 16'h0000)
			CC_Input = 3'b010;
		else if (DATAP == 16'hxxxx)
			CC_Input = 3'b000;
		else
			CC_Input = 3'b001;
			
		case (ALUK)
			2'b00 : //ADD
				out = SR1 + SR2;
			2'b01 : //AND
				out = SR1&SR2;
			2'b10 : //NOT
				out = ~SR1;
			2'b11 : //PASSA
				out = SR1;
		endcase
	
		ALU = out;
	end	
endmodule 