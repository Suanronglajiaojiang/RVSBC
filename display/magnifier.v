module magnifier#(
    parameter SCALE = 8,
    parameter CHARA_WIDTH = 8,
    parameter CHARA_HEIGHT = 11,
    parameter CORDW = 16
    )(
    input clk_pix,
    input rst_n,
    input de,
    input signed [CORDW - 1:0] sx,
    input signed [CORDW - 1:0] sy,
    output reg [3:0] bitCnt,
    output reg [3:0] lineCnt
    );

    reg x_tick;
    reg y_tick;
    reg [1:0] temp;


    always@ (*) begin
        x_tick <= sx % SCALE == 0;
        temp[0] <= sy % SCALE == 0;
        y_tick = temp[0] & !temp[1];
    end

    always@(posedge clk_pix) begin
        temp[1] <= temp[0];
    end

    always@(negedge clk_pix) begin
        if(!rst_n) begin
            bitCnt <= 0;
        end                
        else if(de & x_tick) begin
            bitCnt <= bitCnt == CHARA_WIDTH -1 ? 0 : bitCnt + 4'b1 ;      
        end
    end 
    

    always@(negedge clk_pix) begin
        if(!rst_n) begin
            lineCnt <= 0;
        end                 
        else if(de & y_tick) begin   
            lineCnt <= lineCnt == CHARA_HEIGHT -1 ? 0 : lineCnt + 4'b1 ;
        end
    end
    
    
endmodule
