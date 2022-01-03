//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Lab 5 Given Code - SLC-3 top-level (Physical RAM)
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 06-09-20 20
//	  Revised 03-02-2021
//------------------------------------------------------------------------------


module slc3(
	input logic [9:0] SW,
	input logic	Clk, Reset, Run, Continue,
	input logic [15:0] Data_from_SRAM,
	output logic OE, WE,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3,
	output logic [9:0] LED,
	output logic [15:0] ADDR,
	output logic [15:0] Data_to_SRAM
);


// An array of 4-bit wires to connect the hex_drivers efficiently to wherever we want
// For Lab 1, they will direclty be connected to the IR register through an always_comb circuit
// For Lab 2, they will be patched into the MEM2IO module so that Memory-mapped IO can take place
logic [3:0] hex_4[3:0]; 
HexDriver hex_drivers[3:0] (hex_4, {HEX3, HEX2, HEX1, HEX0});
// This works thanks to http://stackoverflow.com/questions/1378159/verilog-can-we-have-an-array-of-custom-modules



// Internal connections
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic SR2MUX, ADDR1MUX, MARMUX;
logic BEN_Input, BEN, MIO_EN, DRMUX, SR1MUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic [2:0] CC_Input, CC; //CC[2] = N, CC[1] = Z, CC[0] = P.
logic [11:0] LED_out;
logic [15:0] MDR_In, imm5, PCoffset11, PCoffset9, offset6;
logic [15:0] DATAP, ALU, SR1, SR2;
logic [15:0] MAR, MDR, IR, PC;

/*
// only useful for part 1 of the lab
HexDriver HexD0(.In0(PC[3:0]), .Out0(HEX0));
HexDriver HexD1(.In0(PC[7:4]), .Out0(HEX1));
HexDriver HexD2(.In0(PC[11:8]), .Out0(HEX2));
HexDriver HexD3(.In0(PC[15:12]), .Out0(HEX3));
*/

// Connect MAR to ADDR, which is also connected as an input into MEM2IO
//	MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
//	input into MDR)
assign ADDR = MAR; 
assign MIO_EN = OE;
assign LED = LED_out[9:0];

//holds a possible value of what BEN should be whenever we want to load BEN
assign BEN_Input = (IR[11]&CC[2]) | (IR[10]&CC[1]) | (IR[9]&CC[0]);

// Connect everything to the data path (you have to figure out this part)
logic [3:0] Data_Select;
assign Data_Select = {GatePC, GateALU, GateMDR, GateMARMUX};

// Our SRAM and I/O controller (note, this plugs into MDR/MAR)

Mem2IO memory_subsystem(
    .*, .Reset(Reset), .ADDR(ADDR), .Switches(SW),
    .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]),
    .Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// State machine, you need to fill in the code here as well
ISDU state_controller(
	.*, .Reset(Reset), .Run(Run), .Continue(Continue),
	.Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
   .Mem_OE(OE), .Mem_WE(WE)
);

//sign extension modules
sext_05 extendo5(.in(IR[10:0]), .out(PCoffset11));
sext_07 extendo7(.in(IR[8:0]), .out(PCoffset9));
sext_10 extendo10(.in(IR[5:0]), .out(offset6));
sext_11 sextendo_imm5(.in(IR[4:0]), .out(imm5));

//datapath stuff
datapath d0(.*);
data_registers data_reg0(.*, .PC_curr(PC), .MDR_curr(MDR), .IR_curr(IR));

//register file
register_file reg0(.*);

//ALU
alu alu0(.*);


/*
 //SRAM WE register
logic SRAM_WE_In, SRAM_WE;
// SRAM WE synchronizer
always_ff @(posedge Clk or posedge Reset)
begin
	if (Reset) SRAM_WE <= 1'b1; //resets to 1
	else 
		SRAM_WE <= SRAM_WE_In;
end
*/
	
endmodule
