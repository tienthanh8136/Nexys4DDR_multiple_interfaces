////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Author:  Thanh Tien Truong
//          
// Description: 
// ------------
// This module represents the Audio Demo for the Nexys4 DDR onboard ADMP421 Omnidirectional Microphone
// The module generates the pdm_clk signal for the microphone, receives the microphone data and deserializes 
// it in 16-bit samples to save into a memory location. In addition, the module also generates pwm signals 
// for mono audio so that users can listen to whatever the microphone captures.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Audio_Generator (
	// Common
	input 			    clk_100Mhz,
    input 			    reset,
	input 			    btn_u,

	// Microphone PDM signals
	output 			    pdm_clk,					// Output M_CLK signal to the microphone
	input			    pdm_data,					// Input PDM data from the microphone
	output 			    pdm_lrsel,					// Set to '0', therefore data is read on the positive edge
	
	// Audio PWM signals
	output 			    pwm_audio,			// Output Audio data to the lowpass filters
	output     		    pwm_sdaudio		// Output Audio enable	
		
	);
	
/////////////////////////////////////////////////////////////////////////
// Constant Declarations
/////////////////////////////////////////////////////////////////////////
localparam integer SECONDS_TO_RECORD 		= 10;                                                       // How long the FPGA will enable the microphone
localparam integer PDM_FREQ_HZ    			= 3000000;                                                 // Clock signal for microphone (1 Mhz --> 3 Mhz)
localparam integer SYS_CLK_FREQ_HZ      	= 100000000;                                               // System clock signal
localparam integer NUMBER_OF_BITS       	= 16;                                                      // Number of bit in a recording sample                   
localparam integer NUMBER_SAMPLES_TO_REC    = (((SECONDS_TO_RECORD*PDM_FREQ_HZ)/NUMBER_OF_BITS) - 1);  // Maximum samples can be record in a period of time

// State declarations for FSM - one-hot encoding
parameter IDLE = 4'b0001;
parameter RECORD = 4'b0010;
//parameter INTERMEDIATE = 4'b0100; 
//parameter PLAYBACK = 4'b1000;
	
/////////////////////////////////////////////////////////////////////////
// Internal signals
/////////////////////////////////////////////////////////////////////////

// Counter for clock divider to generate PDM clock signal
reg [4:0]   clk_cntr_reg = 5'b0;

reg [3:0]   bit_playback_cnt = 4'd15;
reg [3:0]   bit_record_cnt = 4'b0;

// register for current state and next state
reg [3:0] 	state, next_state;

reg [15:0] temp_data = 16'b0;


reg         recording_en = 1'b0;
reg [31:0]  recording_samples = 32'b0;
reg         playback_en = 1'b0;
reg [31:0]  playback_samples = 32'b0;


reg [15:0]  PDM_data_reg = 16'b0;

wire [15:0]  PWM_data_reg;

reg [15:0]  record_data = 16'b0;
reg [15:0]  data = 16'b0;

reg [11:0]  Addr_w = 12'b0;
reg [11:0]  Addr_r = 12'b0;

wire int_pdm_clk;
////////////////////////////////////////////////////////////////////////
// Generate clock signal for MIC
///////////////////////////////////////////////////////////////////////

	//M_CLK = 100MHz / 32 = 3.125 MHz
    assign pdm_clk = clk_cntr_reg[4];
    assign int_pdm_clk = clk_cntr_reg[4];
    
    always @(posedge clk_100Mhz)
    begin
        clk_cntr_reg <= clk_cntr_reg + 1;
    end
	 
////////////////////////////////////////////////////////////////////////
//  FSM - Generating controll signals for 
//     - Deserializing and Serializing
//    - Data transfer between RAM and DDR2
//    - LEDs
//    - Audio
////////////////////////////////////////////////////////////////////////
	
	// Update current state
	always @ (posedge clk_100Mhz) begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	// Generating outputs for each state
	always @ (posedge clk_100Mhz) begin
		case (state)
			IDLE: begin
				recording_en  	<= 1'b0;		//  - Serializer and De-serializer are disable
				playback_en 	<= 1'b0;		// 	- RAM access (address) is set to 0
			end
			
			RECORD: begin
				recording_en   	<= 1'b1;		// 	- De-serializer is enable (Make serial data into parallel data)
				playback_en 	<= 1'b0;		// 	- RAM access (address) is update continuosly to get new data
			end
			
			default: begin
				recording_en   	<= 1'b0;				// 	- De-serializer is enable (Make serial data into parallel data)
                playback_en     <= 1'b0;        //     - RAM access (address) is update continuosly to get new data)
			end
			
		endcase
	end
	
	// Deciding next state
	always @ (state, btn_u, recording_samples, playback_samples) begin
		
		//next_state = state;
		
		case (state)
			IDLE: begin				// If pushbutton UP is pressed, jump to RECORD state	
				if (btn_u) next_state = RECORD;
				else next_state = IDLE;
			end
			
			RECORD: begin			// If 5 seconds is passed, jump to INTERMEDIATE state
				if (recording_samples == NUMBER_SAMPLES_TO_REC) next_state = IDLE;
				else next_state = RECORD;
			end
		
			default: next_state = IDLE;
		
		endcase
	
	end
	
////////////////////////////////////////////////////////////////////////
// Generating control signals to synchronize serializer, de-serializer
// and memory
////////////////////////////////////////////////////////////////////////

always @ (posedge clk_100Mhz) begin
    if(clk_cntr_reg == 5'b01111) begin
        if (recording_en) begin

            // Generating 16-bit sample for PDM microphone (De-serializing)
            PDM_data_reg <= {PDM_data_reg[14:0], pdm_data} ;
            
            if (bit_record_cnt == 4'd15) begin                      // If already had 16 bits
                bit_record_cnt <= 4'b0;                             // Reset current number of bit in the sample
                
                record_data <= PDM_data_reg;                        // Latching the sample to write into memory
                temp_data <= PDM_data_reg;                          // Latching the sample to generate PWM audio (Only for demo)
                          
                recording_samples <= recording_samples + 1'b1;      // Keep track of the amount of time for using microphones
                Addr_w <= Addr_w + 1'b1;                            // Update memory location to write new sample
            end
            else begin
                bit_record_cnt <= bit_record_cnt + 1'b1;    // Increment the current number of bits in the sample        
                temp_data <= {temp_data[14:0],1'b0};        // Serializing data to generate PWM Audio (Only for demo)
            end
        end
        else begin
            Addr_w <= 12'b0;                                // Resest memory location to write new data
            recording_samples <= 32'b0;                     // Reset current number of recording samples
            temp_data <= 16'b0;
        end
    end
end


////////////////////////////////////////////////////////////////////////
// Memory
////////////////////////////////////////////////////////////////////////
    
    DPRAM Dual_Port_RAM (
        .clk_W(clk_100Mhz), 
        .clk_R(clk_100Mhz),
        .R_enable(playback_en), 
        .W_enable(recording_en),
        
        .addr_wr(Addr_w),
        .data_wr(record_data),
    
        .addr_rd(Addr_r),
        .data_rd(PWM_data_reg)
    );


assign pwm_audio = (temp_data[15] == 0) ? 1'bz : 1'b1;
           
assign pdm_lrsel = 1'b0;      //mic LRSel
assign pwm_sdaudio = 1'b1;
      
endmodule