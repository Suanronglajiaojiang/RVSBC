module externalDevice(
        input clk_pix,
        input rst_n,
        input MemWrite,
        input [31:0] dataAddr,
        input [31:0] WriteData, 
        output [31:0] ReadData,
        input [7:0] keyCode,
        input dataReady,
        input [2:0] shift,
        output [11:0] led      
    );

    reg [31:0] RAM [13:0];

    assign ReadData = RAM[dataAddr[31:2]];
    assign led = RAM[0][11:0];

    always@(posedge clk_pix) begin
        if( MemWrite & dataAddr == 456 )
            RAM[0] <= WriteData;
    end

    always@(*) begin
        RAM[1][31:3] <= 0;
        RAM[1][2:0] <= shift;
        RAM[2][31:1] <= 0;
        RAM[2] <= dataReady;
        RAM[3][31:8] <= 0;
        RAM[3] <= keyCode;
    end

endmodule