`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:15:52 03/11/2020 
// Design Name: 
// Module Name:    top_module 
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
module top_module (
	input wire CLK,
	input wire RX,
    input wire A0,
	output wire TX,
    output wire A1,
    output wire A2
);


`define SYSTEM_CLOCK 32000000
`define BAUD_RATE       115200

reg reset = 0;

uart_echo_with_reset send_to_board(
    .clk(CLK),
	.rst(reset),
	.rx(RX),
	.tx(A1),
    .ext_rst(A2)
);

uart_echo send_to_pc(
    .clk(CLK),
	.rst(reset),
	.rx(A0),
	.tx(TX)
);

endmodule
