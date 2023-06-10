//RAMָ���
module imem(
    input  [31:0] a,
    output [31:0] rd
);
    
    reg [31:0] RAM[63:0];
    
    initial 
        $readmemh("riscvtest.mem",RAM);
        
    assign rd = RAM[a[31:2]];

endmodule