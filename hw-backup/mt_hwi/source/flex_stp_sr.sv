// $Id: $
// File name:   flex_stp_sr.sv
// Created:     2/7/2023
// Author:      Jacob Chappell
// Lab Section: 337-17
// Version:     1.0  Initial Design Entry
// Description: Flexible serial to parallel shift register implementation

module flex_stp_sr #(
	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 1
)(
	input clk, n_rst, shift_enable, serial_in,
	output logic [NUM_BITS-1:0] parallel_out
);

	logic [NUM_BITS-1:0] next_out;

	always_comb begin
		next_out = parallel_out;

		if(shift_enable == 1'b1) begin
			if(SHIFT_MSB == 1) begin
				next_out = {parallel_out[NUM_BITS-2:0], serial_in};
			end else begin
				next_out = {serial_in, parallel_out[NUM_BITS-1:1]};
			end
		end
	end

	always_ff @ (posedge clk, negedge n_rst) begin
		if(n_rst == 1'b0) begin
			parallel_out <= {NUM_BITS{1'b1}};
		end else begin
			parallel_out <= next_out;
		end
	end

endmodule
