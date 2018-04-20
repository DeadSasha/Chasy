module divider
#(
	parameter start_val = 0,
	parameter fin_val = 50000000
)
(
input logic clock,
input logic reset,
input logic work_en,
output logic out_imp
);

logic [def::numofbits(fin_val)-1:0] data;

always_ff @(posedge clock)
begin
if (reset == 1)
	begin
		out_imp <= 0;
		data <= start_val;
	end
else 
	begin
		if (work_en == 1)
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
				out_imp <= 0;
				data <= data;
			end
	end	
end

endmodule