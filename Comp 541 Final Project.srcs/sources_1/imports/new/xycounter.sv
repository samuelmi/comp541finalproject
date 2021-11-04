`timescale 1ns / 1ps
`default_nettype none

module xycounter #(parameter width=2, height=2) (
    input wire clock,
    input wire enable,
    output logic [$clog2(width)-1:0] x=0,
    output logic [$clog2(height)-1:0] y=0
    );
    
    always_ff @(posedge clock) begin
        if (enable) begin
            if (x == width - 1) begin // if x has reached its limit
                x <= 0; // reset x to 0
                if (y == height - 1) begin // if y has reached its limit
                    y <=0; // reset y to 0
                end
                else begin // otherwise, increment y
                    y <= y + 1;
                end
            end
            else begin // otherwise increment x
                x <= x + 1;
            end
        end
        else begin // If disabled, hold the values where they're at
            x <= x;
            y <= y;
        end
    end
             
    
endmodule
