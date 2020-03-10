`timescale 1 ns/1 ps 

module ex2_tb();

reg 		tb_clk, tb_rst, tb_en;
wire [1:0] 	state_out_dbg;
reg [7:0] 	tb_data;

wire 		tx_dout, tx_rdy;
wire 		rx_valid;
wire [7:0] 	rx_data;


`define SYSTEM_CLOCK 	32000000
`define BAUD_RATE 		9600
`define CYC_COUNT		`SYSTEM_CLOCK/`BAUD_RATE

uart_tx 
	#(
		.SYSTEM_CLOCK(`SYSTEM_CLOCK), 
		.BAUD_RATE(`BAUD_RATE)
	)
	pc_tx1(
		.clk(tb_clk),
		.rst(tb_rst),
		.en (tb_en),
		.data_in(tb_data),
		.rdy(tx_rdy),
		.dout(tx_dout),
		.state_out_dbg(state_out_dbg)
	);

uart_rx
	#(
		.SYSTEM_CLOCK(`SYSTEM_CLOCK), 
		.BAUD_RATE(`BAUD_RATE)
	)
	pc_rx1(
		.clk(tb_clk),
		.rst(tb_rst),
		.din(rx_din),
		.valid(rx_valid),
		.data_rx(rx_data)
	);



uart_echo 
	#(
		.SYSTEM_CLOCK(`SYSTEM_CLOCK),
		.BAUD_RATE(`BAUD_RATE)
	)
	inst_uartecho(
		.clk(tb_clk),
		.rst(tb_rst),
		.rx(tx_dout),
		.tx(rx_din)
	);

initial begin
tb_clk <= 1'b0;
tb_rst <= 1'b0;
tb_en <= 1'b0;
end

// Generate 100MMz clock
always begin
#5 tb_clk <= ~tb_clk;
end

initial begin
#40 tb_rst <= 1'b1;
#40 tb_rst <= 1'b0;
end

initial begin 
#80 tb_data <= 8'h55;
#100 tb_en <= 1'b1;
#100 tb_en <= 1'b0;

wait ( tx_rdy == 1 ) 

#80 tb_data <= 8'h03;
#100 tb_en <= 1'b1;
#100 tb_en <= 1'b0;
end 

initial
begin
$dumpfile("test.vcd");
$dumpvars(0,tb_clk);
$dumpvars(0,tb_rst);
$dumpvars(0,tb_en);
$dumpvars(0,tb_data);
$dumpvars(0,tx_rdy);
$dumpvars(0,tx_dout);
$dumpvars(0,rx_din);
$dumpvars(0,state_out_dbg);
$dumpvars(0,rx_valid);
$dumpvars(0,rx_data);
#(`CYC_COUNT*15*60) $finish;
end


endmodule
