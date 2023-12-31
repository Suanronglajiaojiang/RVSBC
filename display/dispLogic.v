module dispLogic #(
    parameter GRID_ROW = 5,
    parameter GRID_COL = 10,
    parameter ASCII_WIDTH = 8,
    parameter BUFFER_WIDTH = 16,
    parameter ADDR_WIDTH = 11,
    parameter CHARA_WIDTH = 8,  
    parameter CHARA_HEIGHT = 11,
    parameter CORDW = 16,
    parameter SCALE = 8
    )(
    input clk_pix,
    input rst_n,
    // input [BUFFER_WIDTH-1:0] dataWrite,
    // input dataReady,
    input bufferWe,
    input [31:0] bufferAddr,
    input [31:0] bufferData,
    output vga_hsync,    // horizontal sync
    output vga_vsync,    // vertical sync
    output reg [11:0] vga,  // 12-bit VGA color
    output [11:0] led
    );
    
    wire dataEnable;
    wire frameStart;
    wire lineStart;
    wire signed [CORDW - 1:0] sx;
    wire signed [CORDW - 1:0] sy;   
    wire hsync,vsync; 
    display_480p #(
        .SCALE(SCALE),
        .CHARA_WIDTH(CHARA_WIDTH),
        .CHARA_HEIGHT(CHARA_HEIGHT),
        .GRID_ROW(GRID_ROW),
        .GRID_COL(GRID_COL)
    ) display_inst(
        clk_pix,
        rst_n,
        vga_hsync,
        vga_vsync,
        dataEnable,
        frameStart,
        lineStart,
        sx,
        sy
    );
       
    reg [$clog2(GRID_COL)-1:0] chPos_x = 0;
    reg [$clog2(GRID_ROW)-1:0] chPos_y = 0;
    wire [15:0] charBundle;    
    dispBuffer #(
        BUFFER_WIDTH,
        ASCII_WIDTH,
        GRID_ROW,
        GRID_COL
    ) displayBuffer(
        clk_pix,
        rst_n,
        chPos_x,
        chPos_y,
        bufferWe,
        bufferAddr,
        bufferData,
        charBundle,
        led
    );
    
    wire [3:0] bitCnt;
    wire [3:0] lineCnt;
     
    magnifier #(
        SCALE,
        CHARA_WIDTH,
        CHARA_HEIGHT,
        CORDW
    ) charaMagnifier(
        clk_pix,
        rst_n,
        dataEnable,
        sx,
        sy,
        bitCnt,
        lineCnt
    );    
 
    wire [ADDR_WIDTH-1:0] charaLineAddr;
    asciiDec #(
        ASCII_WIDTH, 
        ADDR_WIDTH,
        CHARA_HEIGHT
    ) asciiDecLogic(
        charBundle[7:0],
        lineCnt,
        charaLineAddr
    );  
    
              
    wire [CHARA_WIDTH-1:0] charaLine;                                                               
    charaROM #(
        CHARA_WIDTH,
        ADDR_WIDTH 
    ) charrom(
        charaLineAddr,
        charaLine
    );                      
    
    wire [11:0] charColor;
    wire [11:0] backColor;
    CLUT backCLUT(charBundle[15:12],backColor);    
    CLUT charCLUT(charBundle[11:8],charColor);

    always@( posedge bitCnt == 0 or negedge rst_n) begin
        if(!rst_n) begin
            chPos_x <= 0;
        end        
        else if( dataEnable ) begin
            if( chPos_x == GRID_COL - 1 ) begin
                chPos_x <= 0;
            end
            else begin
                chPos_x <=  chPos_x + 1 ;             
            end
        end
    end
    
    always@( posedge lineCnt == 0 or negedge rst_n) begin
        if(!rst_n) begin
            chPos_y <= 0;
        end            
        else if( dataEnable ) begin
            if( chPos_y == GRID_ROW - 1 ) begin
                chPos_y <= 0;
            end
            else begin
                chPos_y <=  chPos_y + 1 ;             
            end
        end
    end   
    
           
    
    always@(posedge clk_pix or negedge rst_n) begin
        if(!rst_n) begin
            vga <= 12'h0;
        end
        else if ( dataEnable ) begin
            if ( charaLine[bitCnt] ) begin
                vga <= charColor;
            end
            else begin
                vga <= backColor;
            end
        end
        else begin
            vga <= 12'h0;
        end
    end                          
    
                    
endmodule 