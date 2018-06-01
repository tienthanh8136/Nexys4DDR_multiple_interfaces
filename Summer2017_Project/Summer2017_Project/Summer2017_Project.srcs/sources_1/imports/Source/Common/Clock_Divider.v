`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2017 05:27:22 PM
// Design Name: 
// Module Name: Clock_Divider
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


module Clock_Divider(
    input clk_in,               // Input clock 
    output clk_out              // Output 1/2 clock
);
    // Internal clock value
    reg int_clock_out = 0;
    
    // FF_for generate 1/2 clock signal
    always @ (posedge clk_in) begin
            int_clock_out <= ~int_clock_out; 
    end
        
    // Assign value to output
    assign clk_out = int_clock_out;
    
endmodule
