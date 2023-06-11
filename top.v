module CPU_top(
    input         clk,
    input         reset,
    output [31:0] WriteData,
    output [31:0] DataAdr,
    output        MemWrite
    // output [15:0] dispBufferOut
    );

    wire [31:0] PC;
    wire [31:0] Instr;
    wire [31:0] ReadData;

    riscvsingle rvsingle(
        clk,
        reset,
        Instr,
        ReadData,
        PC,
        MemWrite,
        DataAdr,
        WriteData
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
        // dispBufferOut
    );
    
endmodule
