module counter
#(
	parameter start_val = 0,
	parameter fin_val = 50000000
)
(
input logic clock,
input logic reset,
input logic	set,
input logic setup_imp,
input logic [7:0] setup_data,
input logic	i_initial,
input logic work_en,
input logic up_down,
input logic timer_reset,
output logic out_imp,
output logic [7:0] data
);

always_ff @(posedge clock)
begin
	if (reset == 1)
		begin
			out_imp <= 0;
			data <= start_val;
		end
	else 
	begin
		if (set == 1) 
			begin
				out_imp <= 0;
				data <= i_initial;
			end
		else if (setup_imp == 1) 
			begin
			out_imp <= 0;
			data <= setup_data;
			end
		else
			begin
				if (work_en == 1)
					begin
						if (up_down == 1)
							begin
								if (data < fin_val)
									begin
										data <= data + 1;
										out_imp <= 0;
									end
								else 
									begin
										out_imp <= 1;
										data <= start_val;
									end
							end
						else
							begin
								if (data == start_val)
									begin
										data <= fin_val;
										out_imp <= 1;
									end
								else 
									begin
										data <= data - 1;
										out_imp <= 0;
									end
							end
					end
				else begin
					out_imp <= 0;
					data <= data;
					end	
			end
	end
end

endmodule