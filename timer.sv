module timer
(
input logic clock,
input logic reset,
input logic [1:0] rezhim,
input logic [0:3] button,
output logic [23:0] data_t,
output logic [3:0] led,
output logic [1:0] setup_rezhim_t,
output logic [23:0] setup_data_t
); 

logic sec_imp;
logic min_imp;
logic hour_imp;
logic day_imp;
logic start_stop;

/*
always_comb
begin
if ((button_start_stop == 1) & (rezhim == 1)) start_stop = start_stop + 1;  
else	start_stop = start_stop;
end*/

always_ff @(posedge clock)
if (reset == 1)
begin
	start_stop <= 0;
end else
begin
	if ((button[3] == 1) & (rezhim == 1))
		begin
			if (setup_rezhim_t == 0) start_stop <= ~start_stop;
			else	start_stop <= start_stop;
		end
	else if (flag == 1)	start_stop <= 0;
	else	start_stop <= start_stop;
end


always_ff @(posedge clock)
begin
if (reset == 1) setup_rezhim_t <= 0;
else 
	begin
		if (button[2] == 1) 
			begin
				if (rezhim == 1) setup_rezhim_t <= setup_rezhim_t + 1;
				else setup_rezhim_t <= 0;
			end
		else setup_rezhim_t <= setup_rezhim_t;
	end
end

always_ff @(posedge clock)
begin
if (reset == 1) setup_data_t[7:0] <= 0;
else
	begin
		if (rezhim == 1)
			begin
				 if ((setup_rezhim_t == 1) & (button[1] == 1)) 
					begin
						if (setup_data_t[7:0] < 59) setup_data_t[7:0] <= setup_data_t[7:0] + 1;
						else setup_data_t[7:0] <= 0;
					end
				else setup_data_t[7:0] <= setup_data_t[7:0];
			end
		else setup_data_t[7:0] <= setup_data_t[7:0];	
	end
end



always_ff @(posedge clock)
begin
if (reset == 1) setup_data_t[15:8] <= 0;
else
	begin
		if (rezhim == 1)
			begin
				if ((setup_rezhim_t == 2) & (button[1] == 1)) 
					begin
						if (setup_data_t[15:8] < 59) setup_data_t[15:8] <= setup_data_t[15:8] + 1;
						else setup_data_t[15:8] <= 0;
					end
				else setup_data_t[15:8] <= setup_data_t[15:8];
			end
		else setup_data_t[15:8] <= setup_data_t[15:8];	
	end
end


always_ff @(posedge clock)
begin
if (reset == 1) setup_data_t[23:16] <= 0;
else
	begin
		if (rezhim == 1)
			begin
				if ((setup_rezhim_t == 3) & (button[1] == 1)) 
					begin
						if (setup_data_t[23:16] < 23) setup_data_t[23:16] <= setup_data_t[23:16] + 1;
						else setup_data_t[23:16] <= 0;
					end
				else setup_data_t[23:16] <= setup_data_t[23:16];
			end
		else setup_data_t[23:16] <= setup_data_t[23:16];	
	end
end

logic setup_imp;


always_ff @(posedge clock)
begin
if (reset == 1) setup_imp <= 0;
else
	begin
		if (rezhim == 1)
			begin
				if (setup_rezhim_t == 3) 
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
//		setup_data_t <= 0;
//	end
//else
//	begin
//		if (rezhim == 1)
//			begin
//				if (setup_rezhim_t == 0)
//					begin
//					if (setup_imp == 1) setup_imp <= 0;
//					else setup_imp <= setup_imp;
//					end
//				else if ((setup_rezhim_t == 1) & (button[1] == 1)) 
//					begin
//						if (setup_data_t[7:0] < 59) setup_data_t[7:0] <= setup_data_t[7:0] + 1;
//						else setup_data_t[7:0] <= 0;
//					end
//				else if ((setup_rezhim_t == 2) & (button[1] == 1)) 
//					begin
//						if (setup_data_t[15:8] < 59) setup_data_t[15:8] <= setup_data_t[15:8] + 1;
//						else setup_data_t[15:8] <= 0;
//					end
//				else if ((setup_rezhim_t == 3) & (button[1] == 1)) 
//					begin
//						if (setup_data_t[23:16] < 23) setup_data_t[23:16] <= setup_data_t[23:16] + 1;
//						else setup_data_t[23:16] <= 0;
//					end
//				else if (setup_rezhim_t == 3) 
//					begin
//						if (button[3] == 1) setup_imp <= 1;
//						else setup_imp <= 0;
//					end
//				else setup_data_t <= setup_data_t;
//			end
//		else setup_data_t <= setup_data_t;	
//	end
//end

logic flag;


always_comb
begin
led = led;
if (data_t == 0) 
	begin
	led = '1;
	flag <= 1;
	end
else 
	begin
	led = 0;
	flag <= 0;
	end
end

	divider
	#(
	.start_val 				(0),
	.fin_val					(50000000)
	 )		
	CLOCK_DIVIDER		
	(		
	.clock 					(clock),
	.reset 					(reset),
	.work_en 				(start_stop),
	.out_imp 				(sec_imp)
	);	
	
	counter
	#(
	.start_val				(0),
	.fin_val  				(59)
	)		
	SEC		
	(		
	.clock 					(clock),
	.reset 					(reset),
	.setup_imp				(setup_imp),
	.setup_data				(setup_data_t[7:0]),
	.set 						(day_imp),
	.i_initial 				(1'b0),
	.work_en 				(sec_imp),
	.up_down					(0),
	.out_imp 				(min_imp),
	.data						(data_t[7:0])
	);

	counter
	#(
	.start_val				(0),
	.fin_val  				(59)
	)		
	MIN		
	(		
	.clock 					(clock),
	.reset 					(reset),
	.setup_imp				(setup_imp),
	.setup_data				(setup_data_t[15:8]),
	.set 						(day_imp),
	.i_initial 				(1'b0),
	.work_en 				(min_imp),
	.up_down					(0),
	.out_imp 				(hour_imp),
	.data						(data_t[15:8])
	);		
			
	counter		
	#(		
	.start_val				(0),
	.fin_val  				(23)
	)		
	HOUR		
	(		
	.clock 					(clock),
	.reset 					(reset),
	.setup_imp				(setup_imp),
	.setup_data				(setup_data_t[23:16]),
	.set 						(day_imp),
	.i_initial 				(1'b0),
	.work_en 				(hour_imp),
	.up_down					(0),
	.out_imp 				(day_imp),
	.data						(data_t[23:16])
	);	
endmodule