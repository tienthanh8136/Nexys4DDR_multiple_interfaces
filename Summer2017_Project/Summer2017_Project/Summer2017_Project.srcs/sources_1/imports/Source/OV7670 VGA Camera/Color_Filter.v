//////////////////////////////////////////////////////////////////////////////////
// Color_Filter.v
//
// Author:			Thanh Tien Truong
//
// Description:
// ------------
// This module is responsible for filtering all the pixels that have skin color
// 
//////////////////////////////////////////////////////////////////////////////////

module Color_Filter(
	input 			clk,
	input			reset,
	
	input 			enable_skin_detection,
	input           enable_spatial_filter,
	
	input   [9:0]   pixel_x,
	input   [9:0]   pixel_y,
	
	input	[15:0] 	raw_pixel_color,
	output	[11:0]	new_pixel_color,
	
	
	input           get_new_pixel,
	output          face_detect
);

    localparam pixel_x_MAX = 640;
    localparam pixel_y_MAX = 480;

    wire apply_filter;

    reg        face_detect_flag         = 0;
    reg        prev_face_detect_flag    = 0;
    reg        skin_pixel_detected      = 0;

    reg [5:0]  pixel_data           = 0;
    reg [5:0]  previous_pixel_value = 0;
    reg [5:0]  current_pixel_value  = 0;

    reg [9:0]   avgX, avgY, avgX_lpf, avgY_lpf;
    reg [29:0]  sum_x = 0, sum_y = 0;
    reg [19:0]  cnt = 0;
    reg [15:0]  fltr_reg;

	// RGB value for VGA
	reg [3:0]   original_vga_red, original_vga_green, original_vga_blue;
	reg [3:0] 	skin_detect_vga_red, skin_detect_vga_green, skin_detect_vga_blue;
	reg [3:0]   spatial_filter_vga_red, spatial_filter_vga_green, spatial_filter_vga_blue;
	reg [3:0]   temporal_filter_vga_red, temporal_filter_vga_green, temporal_filter_vga_blue;
	// RGB value for analyzing
	reg [4:0] 	raw_vga_red, raw_vga_green, raw_vga_blue;
	reg [639:0] data1, data2, data3, data4, data5, data6, data7, data8, data9, data10;

    assign apply_filter = enable_spatial_filter | enable_skin_detection;

	always @ (posedge clk) begin
	
		// Get the current value of RGB
		raw_vga_red 	<= raw_pixel_color[15:11];
		raw_vga_green 	<= raw_pixel_color[10:6];
		raw_vga_blue 	= raw_pixel_color[4:0];
	
		if (reset) begin
			original_vga_red 	<= 4'b0;
			original_vga_green 	<= 4'b0;
			original_vga_blue	<= 4'b0;
			raw_vga_red 	    <= 4'b0;
			raw_vga_green 	    <= 4'b0;
			raw_vga_blue 	    <= 4'b0;
			data1 			    <= 640'b0;
			
			sum_x               <= 30'b0;
            sum_y               <= 30'b0;
            cnt                 <= 20'b0;
                    
            avgX_lpf            <= avgX;
            avgY_lpf            <= avgY;        
                    
		end
		else //if (get_new_pixel) 
		    begin
			// If filter mode is on, modify RGB value
			if (apply_filter) begin
				
				///////////////////////////////////////
				// Skin detection
				//////////////////////////////////////
				
				if (((raw_vga_red - raw_vga_green) > 2) && ((raw_vga_red - raw_vga_green) < 10)) begin
					skin_detect_vga_red 	<= 4'hF;
					skin_detect_vga_green 	<= 4'hF;
					skin_detect_vga_blue 	<= 4'hF;
					
					face_detect_flag <= 1;
					
					
					// Add tag to that pixel --> white color
					if (pixel_x < pixel_x_MAX)
					   data1[pixel_x] <= 1;
				end
				else begin
					skin_detect_vga_red 	= 4'h0;
					skin_detect_vga_green 	= 4'h0;
					skin_detect_vga_blue 	= 4'h0;
					
					// Add tag to that pixel --> black color
					if (pixel_x < pixel_x_MAX)
                        data1[pixel_x] <= 0;
				end
				
				////////////////////////////////////////
				// Spatial Filter
				////////////////////////////////////////
				
				// Shift registers
				if (pixel_x == 10'b0) begin
                    data2 <= data1;
                    data3 <= data2;
                    data4 <= data3;
                    data5 <= data4;
                    data6 <= data5;
                    data7 <= data6;
                    data8 <= data7;
                    data9 <= data8;
                    data10 <= data9;
                end
                
                // Checking surrounding pixel value
                if (( data2[pixel_x - 'd1] + data2[pixel_x - 'd2] + data2[pixel_x - 'd3] + data2[pixel_x - 'd4] + data2[pixel_x] +
                    data2[pixel_x + 'd1] + data2[pixel_x + 'd2] + data2[pixel_x + 'd3] + data2[pixel_x + 'd4] +
                    data3[pixel_x - 'd1] + data3[pixel_x - 'd2] + data3[pixel_x - 'd3] + data3[pixel_x - 'd4] + data3[pixel_x] +
                    data3[pixel_x + 'd1] + data3[pixel_x + 'd2] + data3[pixel_x + 'd3] + data3[pixel_x + 'd4] +
                    data4[pixel_x - 'd1] + data4[pixel_x - 'd2] + data4[pixel_x - 'd3] + data4[pixel_x - 'd4] + data4[pixel_x] +
                    data4[pixel_x + 'd1] + data4[pixel_x + 'd2] + data4[pixel_x + 'd3] + data4[pixel_x + 'd4] +
                    data5[pixel_x - 'd1] + data5[pixel_x - 'd2] + data5[pixel_x - 'd3] + data5[pixel_x - 'd4] + data5[pixel_x] +
                    data5[pixel_x + 'd1] + data5[pixel_x + 'd2] + data5[pixel_x + 'd3] + data5[pixel_x + 'd4] +
                    data6[pixel_x - 'd1] + data6[pixel_x - 'd2] + data6[pixel_x - 'd3] + data6[pixel_x - 'd4] + data6[pixel_x] +
                    data6[pixel_x + 'd1] + data6[pixel_x + 'd2] + data6[pixel_x + 'd3] + data6[pixel_x + 'd4] +
                    data7[pixel_x - 'd1] + data7[pixel_x - 'd2] + data7[pixel_x - 'd3] + data7[pixel_x - 'd4] + data7[pixel_x] +
                    data7[pixel_x + 'd1] + data7[pixel_x + 'd2] + data7[pixel_x + 'd3] + data7[pixel_x + 'd4] +
                    data8[pixel_x - 'd1] + data8[pixel_x - 'd2] + data8[pixel_x - 'd3] + data8[pixel_x - 'd4] + data8[pixel_x] +
                    data8[pixel_x + 'd1] + data8[pixel_x + 'd2] + data8[pixel_x + 'd3] + data8[pixel_x + 'd4] +
                    data9[pixel_x - 'd1] + data9[pixel_x - 'd2] + data9[pixel_x - 'd3] + data9[pixel_x - 'd4] + data9[pixel_x] +
                    data9[pixel_x + 'd1] + data9[pixel_x + 'd2] + data9[pixel_x + 'd3] + data9[pixel_x + 'd4] +
                    data10[pixel_x - 'd1] + data10[pixel_x - 'd2] + data10[pixel_x - 'd3] + data10[pixel_x - 'd4] + data10[pixel_x] +
                    data10[pixel_x + 'd1] + data10[pixel_x + 'd2] + data10[pixel_x + 'd3] + data10[pixel_x + 'd4]) > 70) begin
                    
                    pixel_data                  <= 6'h3F;
                    spatial_filter_vga_red      <= 4'hF;
                    spatial_filter_vga_green    <= 4'hF;
                    spatial_filter_vga_blue     <= 4'hF;
                end
                else begin
                    pixel_data                  <= 6'h0;
                    spatial_filter_vga_red      <= 4'h0;
                    spatial_filter_vga_green    <= 4'h0;
                    spatial_filter_vga_blue     <= 4'h0;
                end 
                
                current_pixel_value <= previous_pixel_value - (previous_pixel_value >> 2) + (pixel_data >> 2);
                
                if (pixel_x[0])
                    previous_pixel_value <= current_pixel_value;
                else
                    previous_pixel_value <= previous_pixel_value; 
                  
                if ((pixel_x < avgX_lpf + 10'd5) && (pixel_x > avgX_lpf - 10'd5) &&
                    (pixel_y < avgY_lpf - 10'd5) && (pixel_y > 10'd5)) begin
                    fltr_reg <= fltr_reg + skin_pixel_detected;
                end
                else if ((pixel_x == 10'd630) && (pixel_y == 10'd470)) begin
                    fltr_reg <= 16'd0;
                    //face_detect_flag <= prev_face_detect_flag;
                end
                    
                if (fltr_reg > 16'd500) begin
                    if (current_pixel_value > 3) begin
                    
                        // Set flag for 7-Segment LEDs
                       
                    
                        skin_pixel_detected         <= 1'b1;
                        temporal_filter_vga_red     <= 4'hF;
                        temporal_filter_vga_green   <= 4'hF;
                        temporal_filter_vga_blue    <= 4'hF;
                    
                        // Draw centroid
                        if (cnt > 19'd500) begin // Set the threshold so when #pixels is too small, nothing will be detected
                            if ((pixel_x < avgX_lpf + 10'd20) && (pixel_x > avgX_lpf - 10'd20) &&
                                (pixel_y < avgY_lpf + 10'd20) && (pixel_y > avgY_lpf - 10'd20)) begin
                                    
                                    face_detect_flag <= 1;
                                    
                                    temporal_filter_vga_red     <= 4'hF;
                                    temporal_filter_vga_green   <= 4'h0;
                                    temporal_filter_vga_blue    <= 4'h0;
                            end
                        end
                    end
                    else begin
                    
                        // Set flag for 7-Segment LEDs
                        //prev_face_detect_flag <= 0;
                    
                        skin_pixel_detected         <= 1'b0;
                        temporal_filter_vga_red     <= 4'h0;
                        temporal_filter_vga_green   <= 4'h0;
                        temporal_filter_vga_blue    <= 4'h0;
                        
                        if (cnt > 19'd500) begin
                            if ((pixel_x < avgX_lpf + 10'd20) && (pixel_x > avgX_lpf - 10'd20) &&
                                (pixel_y < avgY_lpf + 10'd20) && (pixel_y > avgY_lpf - 10'd20)) begin
                                    temporal_filter_vga_red     <= 4'hF;
                                    temporal_filter_vga_green   <= 4'h0;
                                    temporal_filter_vga_blue    <= 4'h0;
                            end
                        end
                    end
                end
                else begin  
                
                    face_detect_flag <= 0;
                    
                    if (current_pixel_value > 3) begin
                        skin_pixel_detected         <= 1'b1;
                        temporal_filter_vga_red     <= 4'hF;
                        temporal_filter_vga_green   <= 4'hF;
                        temporal_filter_vga_blue    <= 4'hF;
                    end
                    else begin
                        skin_pixel_detected         <= 1'b0;
                        temporal_filter_vga_red     <= 4'h0;
                        temporal_filter_vga_green   <= 4'h0;
                        temporal_filter_vga_blue    <= 4'h0;
                    end     	
                end
                
                // Compute Area for the centroid
                if ((pixel_x > 10'd20) && (pixel_x < 10'd620) &&
                    (pixel_y > 10'd20) && (pixel_y < 10'd460)) begin
                    if (skin_pixel_detected) begin
                        sum_x   <= sum_x + pixel_x;
                        sum_y   <= sum_y + pixel_y;
                        cnt     <= cnt + 20'b1;
                    end
                end
                        
                if ((pixel_x == 10'd2) && (pixel_y == 10'd478)) begin
                    avgX        <= sum_x / cnt;
                    avgY        <= sum_y / cnt;
                    avgX_lpf    <= avgX_lpf - (avgX_lpf >> 'd2) + (avgX >> 'd2);
                    avgY_lpf    <= avgY_lpf - (avgY_lpf >> 'd2) + (avgY >> 'd2);
                    sum_x       <= 30'b0;
                    sum_y       <= 30'b0;
                    cnt         <= 20'b0;
                end
                		
			end
			// If filter mode is off, RGB value will not be modified
			else begin
				original_vga_red    <= raw_pixel_color[15:12];
				original_vga_green 	<= raw_pixel_color[10:7];
				original_vga_blue 	<= raw_pixel_color[4:1];
			end
		end
	end
	
	always @ (*) begin
        ///////////////////////////////////////////
        // Temporal filter
        ///////////////////////////////////////////
        
	end
	
	assign new_pixel_color = (apply_filter) ? {temporal_filter_vga_red, temporal_filter_vga_green, temporal_filter_vga_blue} : {original_vga_red, original_vga_green, original_vga_blue};
    assign face_detect = face_detect_flag;

endmodule