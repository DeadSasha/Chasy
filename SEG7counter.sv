module SEG7counter
(
input logic clock,
input logic reset,
input logic [23:0] data_ch,
input logic [23:0] data_t,
input logic [23:0] data_s,
input logic [23:0] setup_data,
input logic [1:0]	rezhim,
input logic [1:0] setup_rezhim_t,
input logic [23:0] setup_data_t,
output logic [6:0] ssegmentHL,
output logic [6:0] ssegmentHR,
output logic [6:0] ssegmentML,
output logic [6:0] ssegmentMR,
output logic [6:0] ssegmentSL,
output logic [6:0] ssegmentSR
);

logic [23:0] data;
logic [7:0] hour;
logic [7:0] min;
logic [7:0] sec;

always_ff @(posedge clock)
begin
if (reset == 0)
	begin
	data <= 0;
	hour <= 0;
	min <= 0;
	sec <= 0;
	end
else 
	begin
	if (rezhim == 0)
		begin
		data <= data_ch;
		hour <= data[23:16];
		min <= data[15:8];
		sec <= data[7:0];
		end
	else if (rezhim == 1)
		begin
		if (setup_rezhim_t != 0) data <= setup_data_t;
		else data <= data_t;
		hour <= data[23:16];
		min <= data[15:8];
		sec <= data[7:0];	
		end
	else if (rezhim == 2)
		begin
		data <= data_s;
		hour <= data[23:16];
		min <= data[15:8];
		sec <= data[7:0];	
		end
	else
		begin
		data <= setup_data;
		hour <= data[23:16];
		min <= data[15:8];
		sec <= data[7:0];
		end
	end
end

bin_to_bcd TENS_ONES_HOUR
(
	.preobr			(hour),
	.sgmentL			(ssegmentHL),
	.sgmentR			(ssegmentHR)
);

bin_to_bcd TENS_ONES_MIN
(
	.preobr			(min),
	.sgmentL			(ssegmentML),
	.sgmentR			(ssegmentMR)
);

bin_to_bcd TENS_ONES_SEC
(
	.preobr			(sec),
	.sgmentL			(ssegmentSL),
	.sgmentR			(ssegmentSR)
);

endmodule