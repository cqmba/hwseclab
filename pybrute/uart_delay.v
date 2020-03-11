module uart_delay (
	input clk,
	input din,
	output reg dout=1'b1
);


// zu viele ressourcen


parameter 	SYSTEM_CLOCK  	= 32000000;
parameter	CLK_DIV			= 64;
parameter	CLK_WIDTH		= $clog2(CLK_DIV)-1;
parameter	NEW_CLK			= SYSTEM_CLOCK / CLK_DIV;

parameter 	BAUD_RATE		= 9600;
parameter 	CYC_COUNT		= NEW_CLK/BAUD_RATE;
parameter	CYC_HALF_COUNT	= CYC_COUNT*2;
parameter 	DELAY_CYCLES 	= CYC_COUNT * 10;

reg [DELAY_CYCLES:0] delay_chain = {DELAY_CYCLES{1'b1}};

reg [CLK_WIDTH:0] div_clk = 0 ;

always @(posedge clk) begin
	div_clk <= div_clk + 1;
end

wire slower_clk = div_clk[CLK_WIDTH];

always @(posedge slower_clk) begin
	delay_chain <= {delay_chain[DELAY_CYCLES-1:0],din};
	dout		<= delay_chain[DELAY_CYCLES];
end

endmodule
