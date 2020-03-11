`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:11:45 03/11/2020 
// Design Name: 
// Module Name:    uart_echo_with_reset 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module uart_echo_with_reset(
	input clk,
	input rst,
	input rx,
	output tx,
    output ext_rst
);

parameter SYSTEM_CLOCK  = 32000000;
parameter BAUD_RATE		= 115200;


`define RESET_BYTE_HEX 8'h72

wire rdy,valid;

wire [7:0] data;
wire en;

uart_tx 
	#(
		.SYSTEM_CLOCK(SYSTEM_CLOCK), 
		.BAUD_RATE(BAUD_RATE)
	)
	echo_tx(
		.clk(clk),
		.rst(rst),
		.en (en),
		.data_in(data),
		.rdy(rdy),
		.dout(tx)
	);

uart_rx
	#(
		.SYSTEM_CLOCK(SYSTEM_CLOCK), 
		.BAUD_RATE(BAUD_RATE)
	)
	echo_rx(
		.clk(clk),
		.rst(rst),
		.din(rx),
		.valid(valid),
		.data_rx(data)
	);

// GLUE LOGIC
assign en = rdy & valid;
assign ext_rst = conditional_reset;

reg conditional_reset = 1;


always @(posedge clk) begin
    conditional_reset <= 1;
	if (valid) begin
		if( data == `RESET_BYTE_HEX) begin // 'r'
			conditional_reset <= 0;
		end
	end 
end

endmodule
