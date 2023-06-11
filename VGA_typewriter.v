module VGA_typewriter #(
        parameter H_RES = 640,
        parameter V_RES = 480,
        parameter SCALE = 8, //choose from 1,2,4,5,8,10
        parameter CHARA_WIDTH = 8,  
        parameter CHARA_HEIGHT = 11,
        parameter GRID_COL = H_RES/(CHARA_WIDTH*SCALE),
        parameter GRID_ROW = V_RES/(CHARA_HEIGHT*SCALE),  
        parameter ADDR_WIDTH = 11,                
        parameter ASCII_WIDTH = 8
    )(
        input  clk_50m,     // 50 MHz clock
        input  rst,    // reset button
        // input [15:0] dataWrite,
        // input dataReady,
        input bufferWe,
        input [31:0] bufferAddr,
        input [31:0] bufferData,        
        output vga_hsync,    // horizontal sync
        output vga_vsync,    // vertical sync
        output [3:0] vga_r,  // 4-bit VGA red
        output [3:0] vga_g,  // 4-bit VGA green
        output [3:0] vga_b,  // 4-bit VGA blue
        output clk_pix
    );
    
    // generate pixel clock
//    wire clk_pix;
    wire clk_pix_locked;
//    wire [ASCII_WIDTH-1:0] dataWrite;
    wire writeEn;
    
    
    clk_wiz_0 clock_pix_inst (
       clk_pix,
       rst,  // reset button is active low
       clk_pix_locked,
       clk_50m  // not used for VGA output
    );

    wire rst_n = clk_pix_locked;  // wait for clock lock

    wire [11:0] vga;
    assign vga = {vga_r,vga_g,vga_b};
    
    dispLogic #(
        .GRID_ROW(GRID_ROW),
        .GRID_COL(GRID_COL),
        .ASCII_WIDTH(ASCII_WIDTH), 
        .ADDR_WIDTH(ADDR_WIDTH),
        .CHARA_WIDTH(CHARA_WIDTH), 
        .CHARA_HEIGHT(CHARA_HEIGHT),
        .SCALE(SCALE)
    )Display (
        clk_pix,
        rst_n,
        // dataWrite,
        // dataReady,
        bufferWe,
        bufferAddr,
        bufferData,        
        vga_hsync,  
        vga_vsync,  
        vga
    );
    

endmodule


