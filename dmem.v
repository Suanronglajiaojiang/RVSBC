module dmem(
    input         clk,
    input         we,
    input  [31:0] a,
    input  [31:0] wd,
    output [31:0] rd
    // output [15:0] dispBufferOut
);

    reg [31:0] RAM[63:0];
    
    initial begin
//        $readmemh("riscvtest.mem",RAM);
//        $readmemh("data.mem",RAM);
        RAM[0]<=32'h3;
        RAM[1]<=32'h9;
        RAM[2]<=32'hc;
    end
    
    assign rd = RAM[a[31:2]];
    // assign dispBufferOut = RAM[0][15:0];

    always@(posedge clk)
        if( we & !a[8] )
            RAM[a[7:2]] <= wd;

endmodule