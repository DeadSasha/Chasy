module chasy_RT
(
input logic clock,
input logic reset,
input logic [23:0] setup_data,
input logic setup_imp,
output logic [23:0] data_ch
); 

logic sec_imp;
logic min_imp;
logic hour_imp;
logic day_imp;

	divider
	#(
	.start_val 				(0),
	.fin_val					(50000000)
	 )		
	CLOCK_DIVIDER		
	(		
	.clock 					(clock),
	.reset 					(reset),
	.work_en 				(1),
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
	.setup_data				(setup_data[7:0]),
	.set 						(day_imp),
	.i_initial 				(1'b0),
	.work_en 				(sec_imp),
	.up_down					(1),
	.out_imp 				(min_imp),
	.data						(data_ch[7:0])
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
	.setup_data				(setup_data[15:8]),
	.set 						(day_imp),
	.i_initial 				(1'b0),
	.work_en 				(min_imp),
	.up_down					(1),
	.out_imp 				(hour_imp),
	.data						(data_ch[15:8])
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
	.setup_data				(setup_data[23:16]),
	.set 						(day_imp),
	.i_initial 				(1'b0),
	.work_en 				(hour_imp),
	.up_down					(1),
	.out_imp 				(day_imp),
	.data						(data_ch[23:16])
	);	
endmodule