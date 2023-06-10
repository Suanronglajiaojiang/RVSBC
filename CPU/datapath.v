////单周期 RISC-V CPU指令与数据通路
module datapath (
	input  wire       clk,
	input  wire       reset,
	input  wire [1:0] ResultSrc,
	input  wire       PCSrc,
	input  wire       ALUSrc,
	input  wire       RegWrite,
	input  wire [1:0] ImmSrc,
	input  wire [2:0] ALUControl,
	output wire       Zero,
	output wire [31:0] PC,
	input  wire [31:0] Instr,
	output wire [31:0] ALUResult,
	output wire [31:0] WriteData,
	input  wire [31:0] ReadData
);

	wire [31:0] PCNext;
	wire [31:0] PCPlus4;
	wire [31:0] PCTarget;
	wire [31:0] ImmExt;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] Result;
	flopr #(32) pcreg(
		clk,
		reset,
		PCNext,
		PC
	);
	adder pcadd4(
		PC,
		32'd4,
		1'b0,
		PCPlus4
	);
	adder pcaddbranch(
		PC,
		ImmExt,
		1'b0,
		PCTarget
	);
	mux2 #(32) pcmux(
		PCPlus4,
		PCTarget,
		PCSrc,
		PCNext
	);
	regfile rf(
		clk,
		RegWrite,
		Instr[19:15],
		Instr[24:20],
		Instr[11:7],
		Result,
		SrcA,
		WriteData
	);
	extend ext(
		Instr[31:7],
		ImmSrc,
		ImmExt
	);
	mux2 #(32) srcbmux(
		WriteData,
		ImmExt,
		ALUSrc,
		SrcB
	);
	alu alu(
		SrcA,
		SrcB,
		ALUControl,
		ALUResult,
		Zero
	);
	mux3 #(32) resultmux(
		ALUResult,
		ReadData,
		PCPlus4,
		ResultSrc,
		Result
	);
endmodule
