`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.vh"

module vgadisplaydriver  #(
    parameter Nchars=4,                         // number of characters/sprites
    parameter smem_size=1200,                   // smem size, 30 rows x 40 cols
    parameter bmem_init="bitmapmem.mem", 	// text file to initialize bitmap memory
    parameter sprite_size=16                    // Size of sprite. Default = 16 x 16 pixels
)(
    input wire clk,
    input wire [$clog2(Nchars)-1:0] charcode,
    
    output wire [$clog2(smem_size)-1:0] smem_addr,
    output wire [3:0] red, green, blue,
    output wire hsync, vsync
    );
    
    wire [`xbits-1:0] x;
    wire [`ybits-1:0] y;
    wire activevideo;
    
    wire [$clog2(Nchars * (sprite_size ** 2))-1:0] bitmap_addr;
    wire [11:0] color_value; // Values set by bitmap_memory

    //wire [$clog2(sprite_size) - 1:0] bitmap_x_col;
    //wire [$clog2(sprite_size) - 1:0] bitmap_y_col;
    
    vgatimer timer(
        .clk, 
        .hsync, 
        .vsync, 
        .x, 
        .y, 
        .activevideo);
    
    rom_module #(
            Nchars * (sprite_size ** 2),    // #chars * #pixels per sprite
            12,                             // 12 bit color code
            bmem_init) 
        bitmap_memory(
            .addr(bitmap_addr), 
            .dout(color_value));
            
    assign smem_addr = (x >> $clog2(sprite_size)) + ((y >> $clog2(sprite_size)) * (640 / sprite_size));
   
    // charcode * sprite_size^2 = starting address for character
    // x[log_2(sprite_size):0] = the first log_2(sprite_size) bits of x (determines col within sprite)
    // y[log_2(sprite_size):0] = the first log_2(sprite_size) bits of y (determines the row within the sprite)
    assign bitmap_addr  = (charcode * (sprite_size ** 2)) + ((sprite_size *  y[$clog2(sprite_size) - 1:0]) +  x[$clog2(sprite_size) - 1:0]); 
    
    assign red = (activevideo == 1) ? color_value[11:8] : 4'b0;
    assign green = (activevideo == 1) ? color_value[7:4] : 4'b0;
    assign blue = (activevideo == 1) ? color_value[3:0] : 4'b0;
    
endmodule