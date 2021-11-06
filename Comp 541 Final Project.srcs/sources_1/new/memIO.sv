`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2021 01:16:06 PM
// Design Name: 
// Module Name: memIO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module memIO #( parameter wordsize, parameter dmem_size, parameter dmem_init, 
                parameter Nchars, parameter smem_size, parameter smem_init
)(
        input wire clk, cpu_wr,
        input wire [wordsize-1:0] cpu_addr, cpu_writedata, keyb_char, accel_val,
        
        output wire [wordsize-1:0] cpu_readdata, period, 
        output wire [15:0] lights, 
        output wire [$clog2(smem_size)-1:0] vga_addr,
        output wire [$clog2(Nchars)-1:0] vga_readdata
    );
    
    wire [wordsize-1:0] smem_readdata, dmem_readdata;
    wire [$clog2(Nchars)-1:0] smem_raw;
    
    wire lights_wr;
    wire sound_wr;
    wire smem_wr;
    wire dmem_wr;
    
    wire [$clog2(smem_size)-1:0] trimmed_smem_addr; // Stores the trimmed address for smem
    wire [$clog2(dmem_size)-1:0] trimmed_dmem_addr; // Stores the trimmed address for dmem
    
    assign trimmed_smem_addr = cpu_addr[$clog2(smem_size) + 1:2];
    assign trimmed_dmem_addr = cpu_addr[$clog2(dmem_size) + 1:2];
        
    // Memory Mapper
    memory_mapper #(.wordsize(wordsize)) mem_map(.cpu_wr(cpu_wr), .cpu_addr(cpu_addr), .accel_val(accel_val), .keyb_char(keyb_char), 
        .smem_readdata(smem_readdata), .dmem_readdata(dmem_readdata), .cpu_readdata(cpu_readdata), .lights_wr(lights_wr),
        .sound_wr(sound_wr), .smem_wr(smem_wr), .dmem_wr(dmem_wr));
    
    // LED register
    io_register #(.Dbits(wordsize)) LED_reg(.clock(clk), .wr(lights_wr), 
        .WriteData(cpu_writedata[15:0]), .ReadData(lights));    
    // sound register
    io_register #(.Dbits(wordsize)) sound_reg(.clock(clk), .wr(lights_wr), 
        .WriteData(cpu_writedata), .ReadData(period));  
                                            
    // RAM
    ram_module #(.Nloc(dmem_size), .Dbits(wordsize), .initfile(dmem_init)) dmem(.clock(clk), .wr(dmem_wr), 
        .addr(trimmed_dmem_addr), .din(cpu_writedata), .dout(dmem_readdata));
    
    // Screen Memory
    two_port_ram #(.Nloc(smem_size), .Dbits($clog2(Nchars)), .initfile(smem_init)) smem(.clock(clk), .wr(smem_wr), .addr1(trimmed_smem_addr), .addr2(vga_addr),
        .din(cpu_writedata), .dout1(smem_raw), .dout2(vga_readdata));
   
    // Padding smem_readdata with extra bits
    assign smem_readdata = {{(wordsize - $clog2(Nchars))*{1'b0}}, smem_raw}; 
    
    
endmodule
