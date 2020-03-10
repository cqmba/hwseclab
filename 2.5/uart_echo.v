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

//reg triggered = 0;
//
//always @(posedge clk) 
//begin
//	if(rst) begin
//		triggered <= 0;
//	end else begin
//		en <= 1'b0;
//		if ( !triggered & valid & rdy ) begin
//			en <= 1'b1;
//			triggered <= 1'b1;
//		end else begin
//			if ( !valid ) begin
//				triggered <= 1'b0;
//			end
//		end
//	end
//end

endmodule
