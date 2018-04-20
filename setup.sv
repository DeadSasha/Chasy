module setup
(
input logic clock,
input logic reset,
input logic [23:0] data_ch,
input logic [0:3] button,
input logic [1:0] rezhim,
output logic [23:0] setup_data,
output logic setup_imp
);

logic [1:0] setup_rezhim;


always_ff @(posedge clock)
begin
if (reset == 1) setup_rezhim <= 0;
else
	begin
	if (button[2] == 1) 
		begin
			if (rezhim == 3) setup_rezhim <= setup_rezhim + 1;
			else setup_rezhim <= 0;
		end
	else setup_rezhim <= setup_rezhim;
	end
end

always_ff @(posedge clock)
begin
if (reset == 1) setup_data[7:0] <= 0;
else
	begin
		if (rezhim == 3)
			begin
				 if ((setup_rezhim == 1) & (button[1] == 1)) 
					begin
						if (setup_data[7:0] < 59) setup_data[7:0] <= setup_data[7:0] + 1;
						else setup_data[7:0] <= 0;
					end
				else setup_data[7:0] <= setup_data[7:0];
			end
		else setup_data[7:0] <= setup_data[7:0];	
	end
end



always_ff @(posedge clock)
begin
if (reset == 1) setup_data[15:8] <= 0;
else
	begin
		if (rezhim == 3)
			begin
				if ((setup_rezhim == 2) & (button[1] == 1)) 
					begin
						if (setup_data[15:8] < 59) setup_data[15:8] <= setup_data[15:8] + 1;
						else setup_data[15:8] <= 0;
					end
				else setup_data[15:8] <= setup_data[15:8];
			end
		else setup_data[15:8] <= setup_data[15:8];	
	end
end


always_ff @(posedge clock)
begin
if (reset == 1) setup_data[23:16] <= 0;
else
	begin
		if (rezhim == 3)
			begin
				if ((setup_rezhim == 3) & (button[1] == 1)) 
					begin
						if (setup_data[23:16] < 23) setup_data[23:16] <= setup_data[23:16] + 1;
						else setup_data[23:16] <= 0;
					end
				else setup_data[23:16] <= setup_data[23:16];
			end
		else setup_data[23:16] <= setup_data[23:16];	
	end
end


always_ff @(posedge clock)
begin
if (reset == 1) setup_imp <= 0;
else
	begin
		if (rezhim == 3)
			begin
				if (setup_rezhim == 3) 
					begin
						if (button[3] == 1) setup_imp <= 1;
						else setup_imp <= 0;
					end
				else setup_imp <= setup_imp;
			end
		else setup_imp <= setup_imp;	
	end
end







//always_ff @(posedge clock)
//begin
//if (reset == 1) 
//	begin
//		setup_imp <= 0;
//		setup_data <= 0;
//	end
//else
//	begin
//		if (rezhim == 3)
//			begin
//				if (setup_rezhim == 0) 
//					begin
//					setup_imp <= 0;
//					end
//				else if ((setup_rezhim == 1) & (button[1] == 1)) 
//					begin
//						if (setup_data[7:0] < 59) setup_data[7:0] <= setup_data[7:0] + 1;
//						else setup_data[7:0] <= 0;
//					end
//				else if ((setup_rezhim == 2) & (button[1] == 1)) 
//					begin
//						if (setup_data[15:8] < 59) setup_data[15:8] <= setup_data[15:8] + 1;
//						else setup_data[15:8] <= 0;
//					end
//				else if ((setup_rezhim == 3) & (button[1] == 1)) 
//					begin
//						if (setup_data[23:16] < 23) setup_data[23:16] <= setup_data[23:16] + 1;
//						else setup_data[23:16] <= 0;
//					end
//				else if (setup_rezhim == 3) 
//					begin
//						if (button[3] == 1) setup_imp <= 1;
//						else setup_imp <= 0;
//					end
//				else setup_data <= setup_data;
//			end
//		else setup_data <= setup_data;	
//	end
//end

endmodule