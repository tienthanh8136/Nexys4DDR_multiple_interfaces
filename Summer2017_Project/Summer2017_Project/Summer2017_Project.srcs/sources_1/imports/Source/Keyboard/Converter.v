/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Converter.v
// Author  : Thanh Tien Truong
// Date    : September 16, 2017
// Version : 1
// 
// Description:
// ------------	
// This module is reponsible for converting a scan code to an equivalent ASCII value
//
// The module will receive 8-bit scan code and a flag indicating if CAPLKS is ON or OFF
// and generate 8-bit ASCII
//
// Note:
// -----
// For alphabet, CAPLKS flag will decide if the ASCII value is for upper case letter or
// lower case letter. For numbering keys on a keyboard, CAPLKS flag will decide if the
// ASCII is for the numbers or the symbols on those numbering keys. 
//
// Example:
// --------
//
//    Scan code    |    CAPLKS    |     ASCII
//      8'h1C      |      0       |     8'h61
//      8'h1C      |      1       |     8'h41
//      8'h16      |      0       |     8'h31
//      8'h16      |      1       |     8'h21
//
///////////////////////////////////////////////////////////////////////////////////////////////////////

module Converter (
    input clk,                          // Global clock
    input CapsLk,                       // CAPLS ON or OFF
    input [7:0] data,		            // 8-bit Scan code
    output reg [7:0] keypress = 8'b0    // 8-bit ASCII 
);		    

parameter              // Parameter keyboard button for character 
    A       = 8'h1C,
    B       = 8'h32,
    C       = 8'h21,
    D       = 8'h23,
    E       = 8'h24,
    F       = 8'h2B,
    G       = 8'h34,
    H       = 8'h33,
    I       = 8'h43,
    J       = 8'h3B,
    K       = 8'h42,
    L       = 8'h4B,
    M       = 8'h3A,
    N       = 8'h31,
    O       = 8'h44,
    P       = 8'h4D,
    Q       = 8'h15,
    R       = 8'h2D,
    S       = 8'h1B,
    T       = 8'h2C,
    U       = 8'h3C,
    V       = 8'h2A,
    W       = 8'h1D,
    X       = 8'h22,
    Y       = 8'h35,
    Z       = 8'h1A,
    ENTER   = 8'h5A,
    DOT     = 8'h49,
    COMMA   = 8'h41,
    SPACE   = 8'h29,
    BACKSPC = 8'h66,
    ESC     = 8'h76,
    QUESTION= 8'h4A;
        
parameter   // Scan code for number
    ZERO    = 8'h45, 
    ONE     = 8'h16,
    TWO     = 8'h1E,
    THREE   = 8'h26,
    FOUR    = 8'h25,
    FIVE    = 8'h2E,
    SIX     = 8'h36,
    SEVEN   = 8'h3D,
    EIGHT   = 8'h3E,
    NINE    = 8'h46;

always @(posedge clk)
begin
    // Map key pressed to ASCII and assert or de-assert flags
    case (data)
        A    : begin 
                    if (CapsLk) keypress <= 8'h41;
                    else        keypress <= 8'h61;
               end
        B    : begin 
                    if (CapsLk) keypress <= 8'h42;
                    else        keypress <= 8'h62; 
               end
        C    : begin 
                    if (CapsLk) keypress <= 8'h43;
                    else        keypress <= 8'h63; 
               end
        D    : begin 
                    if (CapsLk) keypress <= 8'h44;
                    else        keypress <= 8'h64; 
               end
        E    : begin 
                    if (CapsLk) keypress <= 8'h45;
                    else        keypress <= 8'h65; 
               end
        F    : begin 
                    if (CapsLk) keypress <= 8'h46;
                    else        keypress <= 8'h66; 
               end
        G    : begin 
                    if (CapsLk) keypress <= 8'h47;
                    else        keypress <= 8'h67; 
               end
        H    : begin 
                    if (CapsLk) keypress <= 8'h48;
                    else        keypress <= 8'h68; 
               end
        I    : begin 
                    if (CapsLk) keypress <= 8'h49;
                    else        keypress <= 8'h69;
               end
        J    : begin 
                    if (CapsLk) keypress <= 8'h4a;
                    else        keypress <= 8'h6a; 
               end
        K    : begin 
                    if (CapsLk) keypress <= 8'h4b;
                    else        keypress <= 8'h6b; 
               end
        L    : begin 
                    if (CapsLk) keypress <= 8'h4c;
                    else        keypress <= 8'h6c; 
               end
        M    : begin 
                    if (CapsLk) keypress <= 8'h4d;
                    else        keypress <= 8'h6d; 
               end
        N    : begin 
                    if (CapsLk) keypress <= 8'h4e;
                    else        keypress <= 8'h6e; 
               end
        O    : begin 
                    if (CapsLk) keypress <= 8'h4f;
                    else        keypress <= 8'h6f; 
               end
        P    : begin 
                    if (CapsLk) keypress <= 8'h50;
                    else        keypress <= 8'h70; 
               end
        Q    : begin 
                    if (CapsLk) keypress <= 8'h51;
                    else        keypress <= 8'h71; 
               end
        R    : begin 
                    if (CapsLk) keypress <= 8'h52;
                    else        keypress <= 8'h72; 
               end
        S    : begin 
                    if (CapsLk) keypress <= 8'h53;
                    else        keypress <= 8'h73; 
               end
        T    : begin 
                    if (CapsLk) keypress <= 8'h54;
                    else        keypress <= 8'h74; 
               end
        U    : begin 
                    if (CapsLk) keypress <= 8'h55;
                    else        keypress <= 8'h75; 
               end
        V    : begin 
                    if (CapsLk) keypress <= 8'h56;
                    else        keypress <= 8'h76; 
               end
        W    : begin 
                    if (CapsLk) keypress <= 8'h57;
                    else        keypress <= 8'h77;
               end
        X    : begin 
                    if (CapsLk) keypress <= 8'h58;
                    else        keypress <= 8'h78; 
               end
        Y    : begin 
                    if (CapsLk) keypress <= 8'h59;
                    else        keypress <= 8'h79; 
               end
        Z    : begin 
                    if (CapsLk) keypress <= 8'h5a;
                    else        keypress <= 8'h7a; 
               end
                    
        // Map special key to ASCII
        SPACE:      begin keypress <= 8'h20; end
        DOT  :      begin keypress <= 8'h2e; end
        COMMA:      begin keypress <= 8'h2c; end
        QUESTION:   begin keypress <= 8'h3f; end
        
        // BackSpace and Enter
        BACKSPC: begin keypress <= 8'h20; end
        ENTER  : begin keypress <= 8'h20; end
        ESC    : begin keypress <= 8'h20; end
        
        // Map number character to ASCII
        ZERO : begin 
                    if (CapsLk) keypress <= 8'h29;
                    else        keypress <= 8'h30; 
               end
        ONE  : begin 
                    if (CapsLk) keypress <= 8'h21;
                    else        keypress <= 8'h31; 
               end
        TWO  : begin 
                    if (CapsLk) keypress <= 8'h40;
                    else        keypress <= 8'h32;
               end 
        THREE: begin 
                    if (CapsLk) keypress <= 8'h23;
                    else        keypress <= 8'h33;
               end 
        FOUR : begin 
                    if (CapsLk) keypress <= 8'h24;
                    else        keypress <= 8'h34; 
               end 
        FIVE : begin 
                    if (CapsLk) keypress <= 8'h25;
                    else        keypress <= 7'h35;
               end 
        SIX  : begin 
                    if (CapsLk) keypress <= 8'h5e;
                    else        keypress <= 8'h36;
               end
        SEVEN: begin 
                    if (CapsLk) keypress <= 8'h26;
                    else        keypress <= 8'h37;
               end 
        EIGHT: begin 
                    if (CapsLk) keypress <= 8'h2a;
                    else        keypress <= 8'h38; 
               end 
        NINE : begin 
                    if (CapsLk) keypress <= 8'h28;
                    else        keypress <= 8'h39;
               end 
        default: begin keypress <= keypress; end 
    endcase
end

endmodule