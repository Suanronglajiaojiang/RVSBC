//RAMÊý¾Ý¶Î
module dmem(
    input         clk,
    input         we,
    input  [31:0] a,
    input  [31:0] wd,
    output [31:0] rd
);

    reg [31:0]  RAM[127:0];
    
    initial 
    $readmemh("charrom.mem",RAM);
    
    assign rd = RAM[a[31:2]];

    always@(posedge clk)
        if(we)
            RAM[a[31:2]] <= wd;

endmodule