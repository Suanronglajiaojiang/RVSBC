module dispBuffer #(
    parameter BUFFER_WIDTH = 16,
    parameter ASCII_WIDTH = 8,
    parameter GRID_ROW = 5,
    parameter GRID_COL = 10
    ) (
    input clk_pix,
    input rst_n,
    input [$clog2(GRID_COL)-1:0] chPos_x,
    input [$clog2(GRID_ROW)-1:0] chPos_y,
    // input dataReady,
    // input [ASCII_WIDTH-1:0] ascii,
    // input [(BUFFER_WIDTH-ASCII_WIDTH)/2-1:0] colorIndexF_in,
    // input [(BUFFER_WIDTH-ASCII_WIDTH)/2-1:0] colorIndexB_in,
    input         we,
    input  [31:0] a,
    input  [31:0] wd,    
    output reg [BUFFER_WIDTH-1:0] bufferBundle,
    output [11:0] led
    ); 
    integer i;

    reg [BUFFER_WIDTH-1:0] Buffer [GRID_COL*GRID_ROW  -1 : 0];

    initial begin
        $readmemh("dispBufferInit.mem",Buffer);
    end

    // reg temp0,temp1;
    // wire trig = temp0 & !temp1;
    // 
    // always@( clk_pix ) begin
        // temp0 <= we;
        // temp1 <= temp0;
    // end


    always@( posedge clk_pix ) begin
        if( we & a >= 256 & a < 456 )
            Buffer[a[7:2]] <= wd[15:0];

    end

    // assign led[3:0] = Buffer[3][3:0];
    // assign led[7:4] = Buffer[1][3:0]; 
    // assign led[11:8] = Buffer[0][3:0];

    always@(posedge clk_pix or negedge rst_n) begin
        if(!rst_n) begin
            bufferBundle <= 16'b0;
        end
        else begin
            bufferBundle <= Buffer[chPos_x + GRID_COL*chPos_y];
        end
    end
    
endmodule
