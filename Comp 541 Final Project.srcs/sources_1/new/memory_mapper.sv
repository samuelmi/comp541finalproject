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
    
    assign lights_wr = (cpu_addr[17:16] == 2'b11 && cpu_addr[3:2] == 2'b11) ? cpu_wr : 0;
    assign sound_wr = (cpu_addr[17:16] == 2'b11 && cpu_addr[3:2] == 2'b10) ? cpu_wr : 0;
    assign smem_wr = (cpu_addr[17:16] == 2'b10) ? cpu_wr : 0;
    assign dmem_wr = (cpu_addr[17:16] == 2'b01) ? cpu_wr : 0;
    
    assign cpu_readdata = (cpu_addr[17:16] == 2'b11)  
                            ? (cpu_addr[3:2] == 2'b01) ? accel_val 
                            : (cpu_addr[3:2] == 2'b00) ? keyb_char
                            : 32'hxxxx_xxxx
                        : (cpu_addr[17:16] == 2'b10) ? smem_readdata
                        : (cpu_addr[17:16] == 2'b01) ? dmem_readdata
                        : 32'hxxxx_xxxx;
    
    
endmodule
