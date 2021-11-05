`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2021 06:16:57 PM
// Design Name: 
// Module Name: memory_mapper
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


module memory_mapper#( parameter wordsize)(
    input wire cpu_wr,
    input wire [wordsize-1:0] cpu_addr,
    input wire [wordsize-1:0] accel_val,
    input wire [wordsize-1:0] keyb_char,
    input wire [wordsize-1:0] smem_readdata,
    input wire [wordsize-1:0] dmem_readdata, 
    
    output wire [wordsize-1:0] cpu_readdata,
    output wire lights_wr,
    output wire sound_wr,
    output wire smem_wr,
    output wire dmem_wr
    );
    
    assign lights_wr = (cpu_addr == 32'h1003_000c) ? cpu_wr : 0;
    assign sound_wr = (cpu_addr == 32'h1003_0008) ? cpu_wr : 0;
    assign smem_wr = (cpu_addr <= 32'h1002_12BC && cpu_addr >= 32'h1002_0000) ? cpu_wr : 0;
    assign dmem_wr = (cpu_addr <= 32'h1001_0FFC && cpu_addr >= 32'h1001_0000) ? cpu_wr : 0;
    
    assign cpu_readdata = (cpu_addr == 32'h1003_0004) ? accel_val 
                        : (cpu_addr == 32'h1003_0000) ? keyb_char
                        : (cpu_addr <= 32'h1002_12BC && cpu_addr >= 32'h1002_0000) ? smem_readdata
                        : (cpu_addr <= 32'h1001_0FFC && cpu_addr >= 32'h1001_0000) ? dmem_readdata
                        : 32'hxxxx_xxxx;
    
    
endmodule
