
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module state_machine(
	//////////// CLOCK //////////
	input 		          		ADC_CLK_10,

	//////////// SEG7 //////////
	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
	output		     [7:0]		HEX2,
	output		     [7:0]		HEX3,
	output		     [7:0]		HEX4,
	output		     [7:0]		HEX5,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW
);

// Blank LEDs 6:3
assign LEDR[6:3] = {3'b000, SW[9]};
SevenSeg SS1(.HEX(HEX1), .NUM(8'd88));
SevenSeg SS2(.HEX(HEX2), .NUM(8'd88));
SevenSeg SS3(.HEX(HEX3), .NUM(8'd88));
SevenSeg SS4(.HEX(HEX4), .NUM(8'd88));
SevenSeg SS5(.HEX(HEX5), .NUM(8'd88));

// Latch KEY[0] reset
reg reset_latch = 1'b1;
wire reset_latch_wire;
always @(negedge KEY[0])
	begin
		reset_latch <= ~reset_latch;
	end
assign reset_latch_wire = reset_latch;

// Latch KEY[1] right/left turn signal
reg turn_sig_latch = 1'b0;
wire turn_sig_latch_wire;
always @(negedge KEY[1])
	begin
		turn_sig_latch <= ~turn_sig_latch;
	end
assign turn_sig_latch_wire = turn_sig_latch;

// Clock Divider
wire mem_clk;
clock_divider #(25_000_000) CD1(.clk(ADC_CLK_10), .reset_n(reset_latch_wire), .slower_clk(mem_clk));

wire [2:0] CurrentState;
wire [2:0] NextState;

CSL CSL0(.CLK(mem_clk), .reset_n(reset_latch), .NextState(NextState), .CurrentState(CurrentState));
NSL NSL0(.turn_sig_latch(turn_sig_latch_wire), .SW(SW[1:0]), .CurrentState(CurrentState), .NextState(NextState));
OL OL0(.CLK(mem_clk), .reset_n(reset_latch), .CurrentState(CurrentState), .SW(SW[1:0]), .HEX0(HEX0), .LEDR_L(LEDR[9:7]), .LEDR_R(LEDR[2:0]));

endmodule
