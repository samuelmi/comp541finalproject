`timescale 1ns / 1ps
`default_nettype none


module io_register #(
   parameter Dbits = 32                      // Number of bits in data
)(
   input wire clock,
   input wire wr,                            // WriteEnable:  if wr==1, data is written into mem
   input wire [Dbits-1 : 0] WriteData,       // Data for writing into memory (if wr==1)
   
   output wire [Dbits-1 : 0] ReadData
   );

   logic [Dbits-1:0] rf = 0;  

   always_ff @(posedge clock)                // Memory write: only when wr==1, and only at posedge clock
      if(wr)
         rf <= WriteData;

   assign ReadData = rf;
      
endmodule