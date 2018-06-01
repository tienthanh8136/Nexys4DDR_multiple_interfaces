//////////////////////////////////////////////////////////////////////////////////
// OV7670_Frame_Collector.v
//
// Author:			Thanh Tien Truong
//
// Description:
// ------------
//  Captures the pixels coming from the OV7670 camera and 
//  stores them in block RAM
//	
//////////////////////////////////////////////////////////////////////////////////

module OV7670_Frame_Collector(
    input pclk,                         // Pixel clock signal from OV7670 
    input vsync,                        // Vsync signal from OV7670
    input href,                         // Href signal from OV7670
    input [7:0] d,                      // 8-bit data signal from OV7670
    output [17:0] addr,                 // Memory address location to write into RAM
    output [15:0] dout,                 // data to write into RAM
    output we                           // Write-enable signal to write into RAM
);
    // Internal signals                       
    reg [15:0] d_latch = {16{1'b0}};
    reg [18:0] address = {19{1'b0}};
    reg [18:0] address_next = {19{1'b0}};
    reg [1:0] wr_hold = {2{1'b0}};
    
    reg [15:0] dout_temp;
    
    reg we_temp;

    always @ (posedge pclk) begin
    
        // Href starts a pixel transfer that takes 2 cycles to transfer all the RGB of a pixel
        // So, it's requires at least 3 cycles to capture the necessary data to save into a memory
        //
        //         Input   | state after clock tick
        //          href   | wr_hold    d_latch           d                 we address  address_next
        // cycle 0   1     |    x1      xxxxxxxxRRRRRGGG  xxxxxxxxxxxxxxxx  x   xxxx     addr
        // cycle 1   0     |    10      RRRRRGGGGGGBBBBB  xxxxxxxxRRRRRGGG  x   addr     addr
        // cycle 2   x     |    0x      GGGBBBBBxxxxxxxx  RRRRRGGGGGGBBBBB  1   addr     addr+1
         
        if(vsync == 1)
            begin
                address <= {19{1'b0}};
                address_next <= {19{1'b0}};
                wr_hold <= {2{1'b0}};
            end
        else begin
            // Latch 3-bit of R, 3-bit of G and 3-bit of B from a 16-bit data
            //
            // Notice: There are 5 bits of R, 6 bits of G and 5 bits of B
            // Depends on the bits for the RGB ports that the board can support, 
            // it's possible to take full RGB data from OV7670 for displaying
            
            dout_temp <= d_latch;
            //dout_temp <= {d_latch[15:12],d_latch[10:7],d_latch[4:1]};
            
            // Update new address
            address <= address_next;
            
            // Write-enable signal to the RAM
            we_temp <= wr_hold[1];
            
            // Current state of capturing data process
            wr_hold <= {wr_hold[0], (href && !wr_hold[0])};
            
            // Latching data (a byte) from OV7670
            d_latch <= {d_latch [7:0], d};
            
            // A memory location is filled, go to the next location
            if(wr_hold[1] == 1) begin
                address_next <= address_next+1;
            end
        end
    end
    
    // Assign value to outputs
    assign addr = address[18:1];
    assign dout = dout_temp;
    assign we = we_temp;
        
endmodule
