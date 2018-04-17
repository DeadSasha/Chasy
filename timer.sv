module timer
(
input logic clock,
input logic reset, //reset
input logic [1:0] rezhim,
input logic button_start_stop,
input logic button_reset,
input logic [23:0] setup_data,
input logic setup_imp,
output logic [23:0] data_t,
output logic [3:0] led
); 

logic sec_imp;
logic min_imp;
logic hour_imp;
logic day_imp;
logic start_stop;
logic button_reset_en;

/*
always_comb
begin
if ((button_start_stop == 1) & (rezhim == 1)) start_stop = start_stop + 1;  
else	start_stop = start_stop;
end*/

always_ff @(posedge clock, negedge reset)
if (reset)
begin
	start_stop <= 0;
end else
begin
	if ((button_start_stop == 1) & (rezhim == 1)) start_stop <= ~start_stop;  
		else	start_stop = start_stop;
end


always_comb
begin
button_reset_en = button_reset_en;
if ((button_reset == 1) & (rezhim == 1)) button_reset_en = 1;
else button_reset_en = 0;
end

always_comb
begin
led = '0;
if ((sec_imp == 1) & (min_imp == 1) & (hour_imp == 1) & (day_imp == 1)) led = '1;
else led = led;
end

	counter
	#(
	.start_val 				(0),
	.fin_val					(50000000)
	 )		
	CLOCK_DIVIDER		
	(		
	.clock 					(clock),
	.reset 					(reset),
	.setup_imp				(setup_imp),
	.setup_data				(0),
	.set 						(1'b0),
	.i_initial 				(),
	.work_en 				(start_stop),
	.up_down					(0),
	.timer_reset			(button_reset_en),
	.rezhim					(),
	.out_imp 				(sec_imp),
	.data						()
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
	.up_down					(0),
	.timer_reset			(button_reset_en),
	.rezhim					(),
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
	.setup_data				(setup_data[15:8]),
	.set 						(day_imp),
	.i_initial 				(1'b0),
	.work_en 				(min_imp),
	.up_down					(0),
	.timer_reset			(button_reset_en),
	.rezhim					(),
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
	.setup_data				(setup_data[23:16]),
	.set 						(day_imp),
	.i_initial 				(1'b0),
	.work_en 				(hour_imp),
	.up_down					(0),
	.timer_reset			(button_reset_en),
	.rezhim					(),
	.out_imp 				(day_imp),
	.data						(data_t[23:16])
	);	
endmodule