/////////////////////////////////////////////////////////////////////////////////////////////////////////
// keyboard.v
// Author  : Thanh Tien Truong
// Date    : September 16, 2017
// Version : 1
// 
// Description:
// ------------	
// This module is reponsible for monitoring the PS2 CLK and capturing the data from PS DATA.
// The module is supported by the "debouncer" module that helps dealing with bouncing signal
// when pressing a key on a keyboard.
//
// The module is implemented based on PS2 protocol. The module will receive PS2 and PS2 DATA
// and generate 8-bit scan-code, 12-bit memory address location and a flag indicating if 
// CAPLKS is ON or OFF.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module keyboard(
    input clk,                      // Global clock (50 MHz)
    input reset,                    // Global reset
    
    input kclk,                     // PS2 CLK
    input kdata,                    // PS2 DATA
    
    output CAPS_ON,                 // Flag for CAPLKS
    //output reg DELETE_ON,
    //output reg ENTER_ON,
    
    output [11:0] Address,          // 12-bit address location to save into memory
    output reg [7:0] key_press      // 8-bit scan code
);
    
wire kclkf, kdataf;
reg [10:0]datacur;
reg [3:0]cnt;
reg isBreak;

reg int_caps_on = 1'b0;
reg int_delete = 1'b0;
reg int_enter = 1'b0;

// Address to write into memory
reg [11:0] int_address = 12'b0;
    
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
    CAPSLK  = 8'h58,
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

// Initialize counter and break flag
initial begin
   cnt <= 4'b0000;
   isBreak <=1'b0;
end

// Debounce module to deal with bouncing singals
debouncer debounce(
    .clk(clk),
    .I0(kclk),
    .I1(kdata),
    .O0(kclkf),
    .O1(kdataf)
);
   
always @ (negedge kclkf or posedge reset) begin
    if (reset) begin
        int_address <= 12'b0;
        datacur <= 11'b0;
        cnt <=  4'b0;
        key_press  <= 8'b0;
        isBreak <= 1'b0; 
        int_caps_on <= 1'b0;
    end
    else begin
        // If the flag is asserted (a key is released), get the last 10 bits
        if(isBreak == 1'b1) begin
            // get 10 bit of the data
            datacur [cnt] = kdataf;
            cnt = cnt + 1'b1;
            if (cnt == 11) cnt = 0;
            // After getting 10 bits, analyze the middle 8 bits
            // Check for single key character 
            if (datacur[8:1] == A && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == B && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == C && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == D && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == E && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == F && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == G && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == H && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == I && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == J && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == K && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == L && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == M && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == N && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == O && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == P && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == Q && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == R && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == S && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == T && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == U && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == V && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == W && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == X && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == Y && cnt == 0) begin key_press  = 0; isBreak = 0; end 
            if (datacur[8:1] == Z && cnt == 0) begin key_press  = 0; isBreak = 0; end 
                    
            // Check for keys enter, dot, comma and space
            if (datacur[8:1] == CAPSLK && cnt == 0)     begin key_press = 0; isBreak = 0; end
            if (datacur[8:1] == ENTER && cnt == 0)      begin key_press = 0; isBreak = 0; end
            if (datacur[8:1] == DOT && cnt == 0)        begin key_press = 0; isBreak = 0; end
            if (datacur[8:1] == COMMA && cnt == 0)      begin key_press = 0; isBreak = 0; end
            if (datacur[8:1] == SPACE && cnt == 0)      begin key_press = 0; isBreak = 0; end
            if (datacur[8:1] == ESC && cnt == 0)        begin key_press = 0; isBreak = 0; end       
            if (datacur[8:1] == QUESTION && cnt == 0)   begin key_press = 0; isBreak = 0; end
            
            // Check for number keys
            if (datacur[8:1] == ZERO && cnt == 0)   begin key_press = 0; isBreak = 0; end
            if (datacur[8:1] == ONE && cnt == 0)    begin key_press = 0; isBreak = 0; end
            if (datacur[8:1] == TWO && cnt == 0)    begin key_press = 0; isBreak = 0; end
            if (datacur[8:1] == THREE && cnt == 0)  begin key_press = 0; isBreak = 0; end
            if (datacur[8:1] == FOUR && cnt == 0)   begin key_press = 0; isBreak = 0; end
            if (datacur[8:1] == FIVE && cnt == 0)   begin key_press = 0; isBreak = 0; end
            if (datacur[8:1] == SIX && cnt == 0)    begin key_press = 0; isBreak = 0; end
            if (datacur[8:1] == SEVEN && cnt == 0)  begin key_press = 0; isBreak = 0; end
            if (datacur[8:1] == EIGHT && cnt == 0)  begin key_press = 0; isBreak = 0; end
            if (datacur[8:1] == NINE && cnt == 0)   begin key_press = 0; isBreak = 0; end
                      
            // Check for back space on keyboard
            if (datacur[8:1] == BACKSPC && cnt == 0) begin key_press = 0; isBreak = 0; end                
         end
         else begin
            // Get the 1st 10 bits - Start bit, 8-bit data, Stop bit
            datacur[cnt] = kdataf; 
            cnt = cnt + 1'b1; 
            if(cnt == 11) cnt = 0;
            // After getting 10 bits, analyze the middle 8 bits
            // Check for key single character
            if (datacur[8:1] == A && cnt == 0) key_press = A; 
            if (datacur[8:1] == B && cnt == 0) key_press = B;
            if (datacur[8:1] == C && cnt == 0) key_press = C;
            if (datacur[8:1] == D && cnt == 0) key_press = D;
            if (datacur[8:1] == E && cnt == 0) key_press = E;
            if (datacur[8:1] == F && cnt == 0) key_press = F; 
            if (datacur[8:1] == G && cnt == 0) key_press = G;
            if (datacur[8:1] == H && cnt == 0) key_press = H;
            if (datacur[8:1] == I && cnt == 0) key_press = I;
            if (datacur[8:1] == J && cnt == 0) key_press = J;  
            if (datacur[8:1] == K && cnt == 0) key_press = K; 
            if (datacur[8:1] == L && cnt == 0) key_press = L;
            if (datacur[8:1] == M && cnt == 0) key_press = M;
            if (datacur[8:1] == N && cnt == 0) key_press = N;
            if (datacur[8:1] == O && cnt == 0) key_press = O;
            if (datacur[8:1] == P && cnt == 0) key_press = P;
            if (datacur[8:1] == Q && cnt == 0) key_press = Q;
            if (datacur[8:1] == R && cnt == 0) key_press = R;
            if (datacur[8:1] == S && cnt == 0) key_press = S;
            if (datacur[8:1] == T && cnt == 0) key_press = T;
            if (datacur[8:1] == U && cnt == 0) key_press = U;
            if (datacur[8:1] == V && cnt == 0) key_press = V;
            if (datacur[8:1] == W && cnt == 0) key_press = W;
            if (datacur[8:1] == X && cnt == 0) key_press = X;
            if (datacur[8:1] == Y && cnt == 0) key_press = Y;
            if (datacur[8:1] == Z && cnt == 0) key_press = Z;
            
            // Check for keys enter, dot, comma and space
            if (datacur[8:1] == CAPSLK && cnt == 0)     begin key_press = CAPSLK; int_caps_on = ~int_caps_on; end
            if (datacur[8:1] == ENTER && cnt == 0)      key_press = ENTER;
            if (datacur[8:1] == DOT && cnt == 0)        key_press = DOT;
            if (datacur[8:1] == COMMA && cnt == 0)      key_press = COMMA;
            if (datacur[8:1] == SPACE && cnt == 0)      key_press = SPACE;
            if (datacur[8:1] == ESC && cnt == 0)        key_press = ESC;
            if (datacur[8:1] == QUESTION && cnt == 0)   key_press = QUESTION;
            
            // Check for number keys
            if (datacur[8:1] == ZERO && cnt == 0)   key_press = ZERO;
            if (datacur[8:1] == ONE && cnt == 0)    key_press = ONE;
            if (datacur[8:1] == TWO && cnt == 0)    key_press = TWO;
            if (datacur[8:1] == THREE && cnt == 0)  key_press = THREE;
            if (datacur[8:1] == FOUR && cnt == 0)   key_press = FOUR;
            if (datacur[8:1] == FIVE && cnt == 0)   key_press = FIVE;
            if (datacur[8:1] == SIX && cnt == 0)    key_press = SIX;
            if (datacur[8:1] == SEVEN && cnt == 0)  key_press = SEVEN;
            if (datacur[8:1] == EIGHT && cnt == 0)  key_press = EIGHT;
            if (datacur[8:1] == NINE && cnt == 0)   key_press = NINE;
                               
            // Check for back space on keyboard
            if (datacur[8:1] == BACKSPC && cnt == 0) begin key_press = BACKSPC; end
            
            // If data is F0, assert the flag to get the last 10 bit
            if (datacur[8:1] == 8'hF0 && cnt == 0) begin 
                isBreak = 1; 
                if (key_press == CAPSLK)        int_address = int_address;          // CAPLKS    --> don't increase the memory address
                else if (key_press == BACKSPC)  int_address = int_address - 1'b1;   // BACKSPACE --> go to previous memory address
                else                            int_address = int_address + 1'b1;   // OTHER     --> increment memory address
            end         
         
         end
    end
end

assign Address = int_address;
assign CAPS_ON = int_caps_on;

endmodule
