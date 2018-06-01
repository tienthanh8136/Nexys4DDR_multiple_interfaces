//////////////////////////////////////////////////////////////////////////////////
// VGA_Controller.v - Horizontal & Vertical Display Timing & RGB generator for VGA display
//
// Author:			Thanh Tien Truong
//
// Description:
// ------------
//	 This circuit provides horizontal and vertical sync pulse RGB value for 
//   a 640 x 480 video image based on the receiving data from a RAM (frame buffer)
//				
//////////////////////////////////////////////////////////////////////////////////

module VGA_Controller(
    input          clk25,               // 25Mhz clock for VGA 640x480
    
    //input  [15:0]  frame_pixel,
    input  [11:0]  frame_pixel,         // Data read from a memory location	
	output [17:0]  frame_addr,          // Address to read from memory
	
	output [9:0]   pixel_x,             // Current VGA_pixel_x
	output [9:0]   pixel_y,             // Current VGA_pixel_y
	
	output [3:0]   vga_red,             // VGA RED
	output [3:0]   vga_green,           // VGA GREEN
    output [3:0]   vga_blue,            // VGA BLUE
    output         vga_hsync,           // Horizontal sync pulse
    output         vga_vsync            // Vertical sync pulse
   
); 

	// Timing constants
	parameter hRez = 639; 
	parameter hStartSync = 659; 
	parameter hEndSync = 755; 
	parameter hMaxCount = 799; 
	
	parameter vRez = 480; 
	parameter vStartSync = 493; 
	parameter vEndSync = 494; 
	parameter vMaxCount = 524; 
	
	// Pixel row and col 
	reg [9:0] hCounter = {10{1'b0}};
	reg [9:0] vCounter = {10{1'b0}};
	
	// Address to read from memory
	reg [17:0] address = {18{1'b0}};
	
	// Flag to indicate the area to display images
	reg blank = 0;
	
	// Internal signals for VGA interface
	reg [3:0] vga_red_temp = 0;		
	reg [3:0] vga_blue_temp = 0;
	reg [3:0] vga_green_temp = 0;
	reg vga_hsync_temp = 0;
	reg vga_vsync_temp = 0;
	
	always @(posedge clk25) begin
	    // Increasement horizontal sync counter 
	    if (hCounter == hMaxCount)	
            hCounter <= 10'd0;
        else    
            hCounter <= hCounter + 10'd1;
	    
	    // Increasement vertical sync counter
	    if ((vCounter >= vMaxCount) && (hCounter >= hMaxCount))
            vCounter <= 10'd0;
        else if (hCounter == hMaxCount)
            vCounter <= vCounter + 10'd1;

        // Generate RGB value for VGA display
        // if blank is asserted, the area will be black
        // if blank is de-asserted, the area will have color
	    if(blank == 0) begin 
            //vga_red_temp   <= frame_pixel[15:12];
			//vga_green_temp <= frame_pixel[10:7];
			//vga_blue_temp  <= frame_pixel[4:1];	
			
			 vga_red_temp   <= frame_pixel[11:8];
             vga_green_temp <= frame_pixel[7:4];
             vga_blue_temp  <= frame_pixel[3:0];    	
	    end
	    else begin
			vga_red_temp   <= {4{1'b0}};
			vga_green_temp <= {4{1'b0}};
			vga_blue_temp <= {4{1'b0}};
	    end
		
		// Indicate area to display images
		// blank is only de-asserted if the column pixel less than 640
		// and row pixel less than 480
        if(vCounter >= vRez) begin
            address <= {18{1'b0}};
            blank <= 1;
        end
        else begin
            if(hCounter < 640) begin
                blank <= 0;
                // Double size the image to display full screen
                // Otherwise, it will have duplicate image or half screen will be black
                if (hCounter[1] == 1'b1) 
                    address <= address+1'b1;
            end
            else blank <= 1;                     
        end
                
		// generate active-low horizontal sync pulse
        vga_hsync_temp <=  ~((hCounter >= hStartSync) && (hCounter <= hEndSync));
				
		// generate active-low vertical sync pulse
        vga_vsync_temp <= ~((vCounter >= vStartSync) && (vCounter <= vEndSync));
             		
	end
	
	// Assign value to output ports 
	assign frame_addr = address;
	assign vga_hsync = vga_hsync_temp;
    assign vga_vsync = vga_vsync_temp;
	
	assign vga_red = vga_red_temp;
	assign vga_blue = vga_blue_temp;
	assign vga_green = vga_green_temp;
	
	assign pixel_x = hCounter;
	assign pixel_y = vCounter;
		
endmodule