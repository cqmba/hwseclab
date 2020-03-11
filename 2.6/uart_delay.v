module uart_delay (
	input clk,
	input din,
	output reg dout=1'b1
);

parameter 	SYSTEM_CLOCK  	= 32000000;
parameter 	BAUD_RATE		= 9600;
parameter 	CYC_COUNT		= SYSTEM_CLOCK/BAUD_RATE;
parameter 	DELAY_CYCLES 	= CYC_COUNT * 10;
//parameter	DELAY_CYCLES		= $clog2(DELAY_CYCLES);

reg [DELAY_CYCLES:0] delay_chain = {DELAY_CYCLES{1'b1}};

always @(posedge clk) begin
	delay_chain <= {delay_chain[DELAY_CYCLES-1:0],din};
	dout		<= delay_chain[DELAY_CYCLES];
end

endmodule
