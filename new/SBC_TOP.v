module SBC_TOP(
        input  clk_50m,     // 50 MHz clock
        input  rst_n,    // reset button
        input [3:0] colorIndexF,
        input [3:0] colorIndexB,
        input [7:0] keyCode,
        input dataReady,
        output vga_hsync,    // horizontal sync
        output vga_vsync,    // vertical sync
        output [3:0] vga_r,  // 4-bit VGA red
        output [3:0] vga_g,  // 4-bit VGA green
        output [3:0] vga_b,  // 4-bit VGA blue
        output [11:0] led
    );
    
    CPU_top CPU(
        
    
    
    
    
    
endmodule
