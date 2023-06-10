module dmem(
    input         clk,
    input         we,
    input  [31:0] a,
    input  [31:0] wd,
    output [31:0] rd,
    output [15:0] dispBufferOut
);

    reg [31:0] RAM [127:0];
    
    initial 
        $readmemh("charrom.mem",RAM,0,127);
    
    assign rd = RAM[a[31:2]];
    assign dispBufferOut = RAM[0][15:0];

    always@(posedge clk)
        if(we)
            RAM[a[31:2]] <= wd;

endmodule