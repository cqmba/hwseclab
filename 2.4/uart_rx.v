module uart_rx (
	input wire clk,
	input wire rst,
	input wire din,
	output reg valid,
	output [7:0] data_rx);

parameter SYSTEM_CLOCK  = 32000000;
parameter BAUD_RATE		= 9600;
parameter CYC_COUNT		= SYSTEM_CLOCK/BAUD_RATE;
parameter CYC_HALFCOUNT = CYC_COUNT/2;
parameter CYC_BIT_WIDTH	= $clog2(CYC_COUNT);

`define STATE_START			2'b00
`define STATE_READ_BIT		2'b10


reg [1:0] state;
reg [CYC_BIT_WIDTH:0]	counter;
reg [3:0]  bit_counter;
reg [8:0] data;

assign data_rx = data [7:0];

always @(posedge clk)
begin
	if(rst) begin 
		data <= 0;
		valid 	<= 0;
		state	<= `STATE_START;
		bit_counter <= 0;
	end else begin
		case (state)
			`STATE_START: begin
				//old_din <= din;
				if (din == 0) begin
					if (counter == CYC_HALFCOUNT) begin
						valid <= 0;
						state <= `STATE_READ_BIT;
						counter <= 0;
						bit_counter <= 0;
					end else begin
						counter <= counter + 1;
					end

				end else begin
					counter <= 0;
				end

			end
			`STATE_READ_BIT: begin
				counter <= counter + 1;
				if (bit_counter == 9) begin
					state <= `STATE_START;
					if (data[8] == 1) begin
						valid <= 1;
					end else begin
						valid <= 0;
					end 
				end else if (counter == CYC_COUNT) begin
					counter <= 0;
					bit_counter <= bit_counter + 1;
					data <= {din,data[8:1]};
				end

			end
		endcase	
	end
end

endmodule
