module uart_mitm(
	input clk,
	input rst,
	// rx = aus sicht des fpga empfangend
	input b1_rx_bus,
	output b1_tx_bus,

	input b2_rx_bus,
	output b2_tx_bus,

	input pc_rx_bus,
	output pc_tx_bus,
);

parameter SYSTEM_CLOCK  = 32000000;
parameter BAUD_RATE		= 9600;

wire [7:0] b1_rx_data;
wire [7:0] b2_rx_data;
wire [7:0] pc_rx_data;

wire b1_rx_valid;
wire b2_rx_valid;
wire pc_rx_valid;

wire b1_tx_rdy;
wire b2_tx_rdy;
wire pc_tx_rdy;

reg pc_override = 0;

`define BYTE_ENABLEOVERRIDE		8'h65 // 'e'
`define BYTE_DISABLEOVERRIDE	8'h64 // 'd'


// from PC, B1 to B2
uart_tx 
	#(
		.SYSTEM_CLOCK(SYSTEM_CLOCK), 
		.BAUD_RATE(BAUD_RATE)
	)
	b2_tx(
		.clk(clk),
		.rst(rst),
		.en (b2_tx_rdy & ( pc_override ? pc_rx_valid : b1_rx_valid ) ), // TODO
		.data_in(pc_override ? pc_rx_data : b1_rx_data),
		.rdy(b2_tx_rdy),
		.dout(b2_tx_bus)
	);
uart_rx
	#(
		.SYSTEM_CLOCK(SYSTEM_CLOCK), 
		.BAUD_RATE(BAUD_RATE)
	)
	b1_rx(
		.clk(clk),
		.rst(rst),
		.din(b1_rx_bus),
		.valid(b1_rx_valid),
		.data_rx(b1_rx_data)
	);

// from PC, B2 to B1
uart_tx 
	#(
		.SYSTEM_CLOCK(SYSTEM_CLOCK), 
		.BAUD_RATE(BAUD_RATE)
	)
	b1_tx(
		.clk(clk),
		.rst(rst),
		.en (b1_tx_rdy & (pc_override ? pc_rx_valid : b2_rx_valid) ), // TODO
		.data_in(pc_override ? pc_rx_data : b2_rx_data),
		.rdy(b1_tx_rdy),
		.dout(b1_tx_bus)
	);

uart_rx
	#(
		.SYSTEM_CLOCK(SYSTEM_CLOCK), 
		.BAUD_RATE(BAUD_RATE)
	)
	b2_rx(
		.clk(clk),
		.rst(rst),
		.din(b2_rx_bus),
		.valid(b2_rx_valid),
		.data_rx(b2_rx_data)
	);

// from PC
uart_rx
	#(
		.SYSTEM_CLOCK(SYSTEM_CLOCK), 
		.BAUD_RATE(BAUD_RATE)
	)
	pc_rx(
		.clk(clk),
		.rst(rst),
		.din(pc_rx_bus),
		.valid(pc_rx_valid),
		.data_rx(pc_rx_data)
	);


always @(posedge clk) begin
	if (pc_rx_valid) begin
		if( pc_rx_data == `BYTE_ENABLEOVERRIDE) begin // 'e'
			pc_override <= 1'b1;
		end else if ( pc_rx_data == `BYTE_DISABLEOVERRIDE ) begin
			pc_override <= 1'b0;
		end
	end 
end



endmodule














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
