module setup
(
input logic clock,
input logic [23:0] data_ch,
input logic [0:3] button,
input logic [1:0] rezhim,
output logic [23:0] setup_data,
output logic setup_imp
);

logic [23:0] data;
logic [1:0] setup_rezhim;

always_ff @(posedge button[3], negedge reset)
begin
if (~reset) setup_rezhim <= 0;
else if (button[2] == 1) 
	begin
		if (rezhim == 3) setup_rezhim <= setup_rezhim + 1;
		else setup_rezhim <= setup_rezhim;
	end
else setup_rezhim <= setup_rezhim;
end

always_ff @(posedge clock)
begin
if (clock == 1) 
	begin
		if (setup_rezhim == 0) setup_data <= data_ch;
		else if ((setup_rezhim == 1) & (button[1] == 1)) 
			begin
				if (setup_data[7:0] < 59) setup_data[7:0] <= setup_data[7:0] + 1;
				else setup_data[7:0] <= 0;
			end
		else if ((setup_rezhim == 2) & (button[1] == 1)) 
			begin
				if (setup_data[7:0] < 59) setup_data[7:0] <= setup_data[7:0] + 1;
				else setup_data[7:0] <= 0;
			end
		else if ((setup_rezhim == 3) & (button[1] == 1)) 
			begin
				if (setup_data[7:0] < 23) setup_data[7:0] <= setup_data[7:0] + 1;
				else setup_data[7:0] <= 0;
				if (button[2] == 1) setup_imp <= 1;
				else setup_imp <= 0;
			end
		else setup_data <= setup_data
	end
end

endmodule