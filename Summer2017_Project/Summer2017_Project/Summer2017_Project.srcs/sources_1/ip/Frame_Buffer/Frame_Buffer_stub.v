// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
// Date        : Sat Sep 16 18:02:18 2017
// Host        : Thanh-PC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/Thanh/Desktop/Summer2017_Project/Summer2017_Project.srcs/sources_1/ip/Frame_Buffer/Frame_Buffer_stub.v
// Design      : Frame_Buffer
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_3,Vivado 2016.2" *)
module Frame_Buffer(clka, wea, addra, dina, clkb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[17:0],dina[15:0],clkb,addrb[17:0],doutb[15:0]" */;
  input clka;
  input [0:0]wea;
  input [17:0]addra;
  input [15:0]dina;
  input clkb;
  input [17:0]addrb;
  output [15:0]doutb;
endmodule
