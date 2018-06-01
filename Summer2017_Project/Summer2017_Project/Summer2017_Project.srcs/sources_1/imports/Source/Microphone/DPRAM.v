`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2017 05:12:46 PM
// Design Name: 
// Module Name: DPRAM
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


module DPRAM #(
    parameter ADDR_WIDTH = 12,
    parameter DATA_WIDTH = 16,
    parameter RAM_DEPTH = (1 << ADDR_WIDTH)
) 
(
    input                            clk_W, clk_R,
    
    input                            R_enable, W_enable,
    
    input       [ADDR_WIDTH - 1:0]   addr_wr,
    input       [DATA_WIDTH - 1:0]   data_wr,

    input       [ADDR_WIDTH - 1:0]   addr_rd,
    output reg  [DATA_WIDTH - 1:0]   data_rd
);

    reg [DATA_WIDTH-1:0] MEM [262143:0];
    
    always @ (posedge clk_W) begin
        
        if (W_enable) MEM[addr_wr] <= data_wr;
    end
    
    always @ (posedge clk_R) begin   
        if (R_enable) data_rd <= MEM[addr_rd];
    end
    
endmodule
