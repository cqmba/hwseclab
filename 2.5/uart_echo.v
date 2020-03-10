module uart_echo(
	input clk,
	input rst,
	input rx,
	output tx
);

parameter SYSTEM_CLOCK  = 32000000;
parameter BAUD_RATE		= 9600;

wire rdy,valid;

wire [7:0] data;

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
		.SYSTEM_CLOCK(`SYSTEM_CLOCK), 
		.BAUD_RATE(`BAUD_RATE)
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

//
//always @(posedge clk) 
//begin
//	if ( valid & rdy ) begin
//		en <= 1'b1;
//	end else begin
//		en <= 1'b0;
//	end
//end
//
endmodule
