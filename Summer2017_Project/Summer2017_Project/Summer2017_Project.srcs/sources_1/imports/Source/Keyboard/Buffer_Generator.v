/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Buffer_Generator.v
// Author  : Thanh Tien Truong
// Date    : September 16, 2017
// Version : 1
// 
// Description:
// ------------	
// This module is reponsible for writing an ASCII value into a memory location or
// reading an ASCII value from a memory location.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Buffer_Generator (
    input clk,
    
    input [11:0] Addr_Write,
    input [7:0] Data_Write,
    
    input [11:0] Addr_Read,
    output reg [7:0] Data_Read
);

localparam integer DATA_SIZE = 8;
localparam integer BUFFER_SIZE = 4096;

reg [DATA_SIZE - 1 : 0] buffer [BUFFER_SIZE - 1 : 0];

always @ (posedge clk) begin
    buffer[Addr_Write] <= Data_Write;    
end

always @ (posedge clk) begin
    Data_Read <= buffer[Addr_Read];
end

endmodule
