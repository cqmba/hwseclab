`timescale 1 ns/1 ps 
module ex2_tb();

reg tb_clk, tb_rst, tb_en;

wire [7:0] tb_cnt;

foo_counter cnti(
				.clk(tb_clk),
				.rst(tb_rst),
				.en(tb_en),
				.cnt(tb_cnt));

initial begin
tb_clk <= 1'b0;
tb_rst <= 1'b0;
tb_en <= 1'b0;
end

// Generate 50mhz clokc
always begin
#10 tb_clk <= ~tb_clk;
end

initial begin
#40 tb_rst <= 1'b1;
#40 tb_rst <= 1'b0;
end

initial begin 
#100 tb_en <= 1'b1;
#100 tb_en <= 1'b0;
end 

initial
begin
$dumpfile("test.vcd");
$dumpvars(0,tb_clk);
$dumpvars(0,tb_rst);
$dumpvars(0,tb_en);
$dumpvars(0,tb_cnt);
#250 $finish;
end


endmodule
