
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// PWM_RGB.v
// Author  : Thanh Tien Truong
// Date    : September 16, 2017
// Version : 1
// 
// Description:
// ------------	
// This module is reponsible for controlling the brightness of the RGB LEDs
//
///////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module PWM_RGB(
    input clk,
    input d_in,             // Current status of the RGB LEDs
    output reg pwm          // PWM signal for controlling the brightness
);
    
    reg [17:0] counter = 0;
    
    always @ (posedge clk) begin
        if (d_in == 1) begin                // If the original singal is '1'
            counter <= counter + 1;
            
            if (counter >= 10000)   pwm <= 0;   // Only set the signal to '1' for certain period of time
            else                    pwm <= 1;
            
            if (counter >= 100000) counter <= 0;
            
        end
        else begin     // If the original singal is '0'
            pwm <= 0;
        end
    end 
       
endmodule
