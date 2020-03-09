`timescale 1 ns/1 ps 

module ex2_tb();

reg tb_clk, tb_rst, tb_en;
wire [1:0] state_out_dbg;
reg [7:0] tb_data;

`define SYSTEM_CLOCK 	32e6
`define BAUD_RATE 		9600


uart_tx 
	#(
		.SYSTEM_CLOCK(`SYSTEM_CLOCK), 
		.BAUD_RATE(`BAUD_RATE)
	)
	tx1(
		.clk(tb_clk),
		.rst(tb_rst),
		.en (tb_en),
		.data_in(tb_data),
		.rdy(tx_rdy),
		.dout(tx_dout),
		.state_out_dbg(state_out_dbg)
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
$dumpvars(0,tx_dout);
$dumpvars(0,state_out_dbg);
#333*333 $finish;
end


endmodule
