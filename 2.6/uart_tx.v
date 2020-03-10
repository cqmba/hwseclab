module uart_tx(
	input clk, rst, en,
	input [7:0] data_in,

	output reg rdy,
	output reg dout = 1'b1
);

parameter SYSTEM_CLOCK  = 32000000;
parameter BAUD_RATE		= 9600;
parameter CYC_COUNT		= SYSTEM_CLOCK/BAUD_RATE;
parameter CYC_PRO_BIT	= $clog2(CYC_COUNT);

`define STATE_RST		2'b00
`define STATE_START		2'b01
`define STATE_SENDBIT	2'b10


reg [1:0]cur_state = `STATE_START;
reg [9:0]data = 0;
reg [3:0]shift_amount = 0;
reg [CYC_PRO_BIT:0]wait_counter = 0 ;

always @(posedge clk)
begin

	if(rst) begin
		cur_state 		<= `STATE_START;
		rdy				<= 1'b0;
		dout			<= 1'b1;
		shift_amount 	<= 0;
		wait_counter 	<= 0;
	end else begin
		rdy  <= 1'b0;
		dout <= dout;
		shift_amount <= shift_amount; 
		wait_counter <= wait_counter;
		
		case (cur_state)
			`STATE_START: begin
				rdy <= 1'b1;
				if ( en == 1'b1 ) begin
					cur_state 	<= `STATE_SENDBIT;
					data 		<= {1'b1,data_in,1'b0};
					shift_amount 	<= 1'b0;
					wait_counter 	<= 0;
				end
			end
			`STATE_SENDBIT: begin
				rdy <= 1'b0;
				if (wait_counter == CYC_COUNT) begin
					dout 			<= (data >> shift_amount ) & 1;
					shift_amount 	<= shift_amount + 1;
					wait_counter 	<= 0;
				end else begin
					wait_counter <= wait_counter + 1;
				end

				if (shift_amount == 4'd10) begin
					cur_state <= `STATE_START;
				end
			end
		endcase
	end
end

endmodule
