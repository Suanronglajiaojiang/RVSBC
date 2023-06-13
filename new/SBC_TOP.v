module SBC_TOP(
        input  clk_50m,     // 50 MHz clock
        input  rst_n,    // reset button
        input [7:0] keyCode,
        input dataReady,
        input [2:0] shift,
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
    wire [31:0] WriteData;
    // wire [15:0] dispBufferOut;
    wire clk_pix;
    
    // CPU_top CPU(
        // clk_pix,
        // rst,
        // writeData,
        // dataAddr,
        // MemWrite
        // dispBufferOut
    // );

    wire [31:0] PC;
    wire [31:0] Instr;
    wire [31:0] ReadData;
    riscvsingle rvsingle(
        clk_pix,
        rst,
        Instr,
        ReadData,
        PC,
        MemWrite,
        dataAddr,
        WriteData
    );
    
    imem imem(
        PC,
        Instr
    );

    wire [31:0] ReadData0;
    dmem dmem(
        clk_pix,
        MemWrite,
        dataAddr,
        WriteData,
        ReadData0
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
        WriteData,
        vga_hsync,    
        vga_vsync,    
        vga_r, 
        vga_g, 
        vga_b,
        clk_pix,
        led    
    );

    wire [31:0] ReadData1;
    externalDevice xDevice(
        clk_pix,
        rst_n,
        MemWrite,
        dataAddr,
        WriteData, 
        ReadData1,
        keyCode,
        dataReady,
        shift,
        led      
    );
        
    assign ReadData = dataAddr >= 456 ? ReadData1 : ReadData0;
    
    
    
    
endmodule
