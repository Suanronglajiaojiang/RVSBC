//µ¥ÖÜÆÚ RISC-V CPU
module riscvsingle (
	input         clk,
	input         reset,
	input  [31:0] Instr,
	input  [31:0] ReadData,
	output [31:0] PC,
	output        MemWrite,
	output [31:0] ALUResult,
	output [31:0] WriteData
);
	
	wire ALUSrc;
	wire RegWrite;
	wire Jump;
	wire Zero;
	wire [1:0] ResultSrc;
	wire [1:0] ImmSrc;
	wire [2:0] ALUControl;
	wire PCSrc;
	controller c(
		Instr[6:0],
		Instr[14:12],
		Instr[30],
		Zero,
		ResultSrc,
		MemWrite,
		PCSrc,
		ALUSrc,
		RegWrite,
		Jump,
		ImmSrc,
		ALUControl
	);
	datapath dp(
		clk,
		reset,
		ResultSrc,
		PCSrc,
		ALUSrc,
		RegWrite,
		ImmSrc,
		ALUControl,
		Zero,
		PC,
		Instr,
		ALUResult,
		WriteData,
		ReadData
	);
endmodule
