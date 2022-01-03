module sext_11(input [4:0] in, 
				output [15:0] out ); //out left as wire

  assign out = { {11{in[4]}}, in}; 
  
endmodule

module sext_10(input [5:0] in, 
				output [15:0] out ); //out left as wire

  assign out = { {10{in[5]}}, in}; 
  
endmodule

module sext_05(input [10:0] in, 
				output [15:0] out ); //out left as wire

  assign out = { {5{in[10]}}, in}; 
  
endmodule

module sext_07(input [8:0] in, 
				output [15:0] out ); //out left as wire

  assign out = { {7{in[8]}}, in}; 
  
endmodule