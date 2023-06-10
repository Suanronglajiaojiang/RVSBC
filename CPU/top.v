`timescale 1ns / 1ps
//µ¥ÖÜÆÚ RISC-V CPU + RAM
module CPU_top(
    input         clk,
    input         reset,
    output [31:0] WriteData,
    output [31:0] DataAdr,
    output        MemWrite
    );

    wire [31:0] PC;
    wire [31:0] Instr;
    wire [31:0] ReadData;

    riscvsingle rvsingle(
        clk,
        reset,
        PC,
        Instr,
        MemWrite,
        DataAdr,
        WriteData,
        ReadData
    );
    
    imem imem(
        PC,
        Instr
    );

    dmem dmem(
        clk,
        MemWrite,
        DataAdr,
        WriteData,
        ReadData
    );
    
endmodule
