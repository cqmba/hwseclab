`timescale 1 ns/1 ps 

module tb_mitm();

reg 		tb_clk, tb_rst, tb_en;
wire [1:0] 	state_out_dbg;
wire [7:0]	pc_rx_data_dbg;
wire [7:0]	pc_rx_data_snoop;
reg [7:0] 	tb_data;

wire 		tx_dout, tx_rdy;
wire 		rx_valid;
wire [7:0] 	rx_data;

wire 		pc_rx_valid_snoop;
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
		.dout(pc_tx_bus),
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
		.din(pc_tx_bus),
		.valid(pc_rx_valid_snoop),
		.data_rx(pc_rx_data_snoop)
	);


uart_mitm 
	#(
		.SYSTEM_CLOCK(`SYSTEM_CLOCK),
		.BAUD_RATE(`BAUD_RATE)
	)
	inst_uart_mitm (
	.clk(tb_clk),
	.rst(tb_rst),
	.b1_rx_bus(b1_tx_bus),
	.b1_tx_bus(b1_rx_bus),
	.b2_rx_bus(b2_tx_bus),
	.b2_tx_bus(b2_rx_bus),
	.pc_rx_bus(pc_tx_bus),
	.pc_tx_bus(pc_rx_bus),

	.pc_rx_data(pc_rx_data_dbg),
	.pc_rx_valid(pc_rx_valid_dbg)
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
#80 tb_data <= 8'h65; // 'e' enable
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
$dumpvars(0,tb_mitm);
//$dumpvars(0,tb_clk);
//$dumpvars(0,tb_rst);
//$dumpvars(0,tb_en);
//$dumpvars(0,tb_data);
//$dumpvars(0,tx_rdy);
//$dumpvars(0,tx_dout);
//$dumpvars(0,pc_tx_bus);
//$dumpvars(0,pc_rx_bus);
//$dumpvars(0,b1_tx_bus);
//$dumpvars(0,b1_rx_bus);
//$dumpvars(0,b2_tx_bus);
//$dumpvars(0,b2_rx_bus);
//$dumpvars(0,pc_rx_data_snoop);
//$dumpvars(0,pc_rx_valid_snoop);
//$dumpvars(0,pc_rx_data_dbg);
//$dumpvars(0,pc_rx_valid_dbg);
//$dumpvars(0,state_out_dbg);
//$dumpvars(0,rx_valid);
//$dumpvars(0,rx_data);
#(`CYC_COUNT*15*60) $finish;
end


endmodule
