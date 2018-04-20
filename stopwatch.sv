module stopwatch
(
input logic clock,
input logic reset,
input logic [1:0] rezhim,
input logic button_start_stop,
input logic button_reset,
output logic [23:0] data_s
); 

logic sec_imp;
logic min_imp;
logic hour_imp;
logic day_imp;
logic start_stop;
logic button_reset_en;


always_ff @(posedge clock)
if (reset == 1)
begin
	start_stop <= 0;
end else
begin
	if ((button_start_stop == 1) & (rezhim == 2)) start_stop <= ~start_stop;  
		else	start_stop = start_stop;
end

always_ff @(posedge clock)
if (reset == 1)
begin
	button_reset_en <= 0;
end else
begin
	if ((button_reset == 1) & (rezhim == 2)) button_reset_en <= 1;
	else button_reset_en <= 0;
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
	.setup_imp				(button_reset_en),
	.setup_data				(0),
	.set 						(day_imp),
	.i_initial 				(1'b0),
	.work_en 				(sec_imp),
	.up_down					(1),
	.timer_reset			(),
	.rezhim					(),
	.out_imp 				(min_imp),
	.data						(data_s[7:0])
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
	.setup_imp				(button_reset_en),
	.setup_data				(0),
	.set 						(day_imp),
	.i_initial 				(1'b0),
	.work_en 				(min_imp),
	.up_down					(1),
	.timer_reset			(),
	.rezhim					(),
	.out_imp 				(hour_imp),
	.data						(data_s[15:8])
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
	.setup_imp				(button_reset_en),
	.setup_data				(0),
	.set 						(day_imp),
	.i_initial 				(1'b0),
	.work_en 				(hour_imp),
	.up_down					(1),
	.timer_reset			(),
	.rezhim					(),
	.out_imp 				(day_imp),
	.data						(data_s[23:16])
	);	
endmodule