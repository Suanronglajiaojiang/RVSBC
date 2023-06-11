`timescale 1ns / 1ps
//ALU（架构参照书本）
module alu(
    input [31:0] SrcA,SrcB,
    input [2:0] ALUControl,
    output wire [31:0] ALUResult,
    output wire Zero
    );

    wire [31:0] Sum;
    wire [31:0] MuxOut;
    wire [31:0] Diff = Sum;
    wire slt = (Sum[31]^((~ALUControl[1])&(Sum[31]^SrcA[31])&(~(ALUControl[0]^(SrcA[31]^SrcB[31])))));
    wire [31:0] SLT = {31'b0,slt};

    mux2   #(32)mux( SrcB, ~SrcB, ALUControl[0], MuxOut );
    adder       adder( SrcA, MuxOut, ALUControl[0], Sum );
    mux5        mux5( Sum, Diff, (SrcA & SrcB), (SrcA | SrcB), SLT, ALUControl, ALUResult );
    assign Zero = !ALUResult;//结果为0标志位
    
endmodule

//ALU专用多路复用
module mux5(
    input [31:0] Sum,Diff,And,Or,SLT,
    input [2:0]  ALUControl,
    output reg [31:0] Result
    );
    always@(*)
       case ( ALUControl )
        3'b000: Result = Sum;
        3'b001: Result = Diff;
        3'b010: Result = And;
        3'b011: Result = Or;
        default:Result = SLT;
    endcase
    
endmodule