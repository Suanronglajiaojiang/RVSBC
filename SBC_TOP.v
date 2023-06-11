module SBC_TOP(
        input  clk_50m,     // 50 MHz clock
        input  rst_n,    // reset button
        // input [7:0] keyCode,
        // input dataReady,
        output vga_hsync,    // horizontal sync
        output vga_vsync,    // vertical sync
        output [3:0] vga_r,  // 4-bit VGA red
        output [3:0] vga_g,  // 4-bit VGA green
        output [3:0] vga_b,  // 4-bit VGA blue
        output [11:0] led
    );

    wire rst = !rst_n;
    wire MemWrite;
    wire [31:0] dataAddr;
    wire [31:0] writeData;
    // wire [15:0] dispBufferOut;
    wire clk_pix;
    
    CPU_top CPU(
        clk_pix,
        rst,
        writeData,
        dataAddr,
        MemWrite
        // dispBufferOut
    );
    
//    wire dataReady_n = !dataReady;
    
    VGA_typewriter display(
        clk_50m,
        rst_n,    
        // dispBufferOut,
        // dataReady,
        MemWrite,
        dataAddr,
        writeData,
        vga_hsync,    
        vga_vsync,    
        vga_r, 
        vga_g, 
        vga_b,
        clk_pix    
    );
        
    
    
    
    
    
endmodule
