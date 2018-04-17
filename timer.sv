module timer
(
input logic clock,
input logic reset,
input logic [1:0] rezhim,
input logic [0:3] button,
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
if (~reset)
begin
	start_stop <= 0;
end else
begin
	if ((button[3] == 1) & (rezhim == 1)) start_stop <= ~start_stop;  
		else	start_stop = start_stop;
end

logic [23:0] setup_data;
logic [1:0] setup_rezhim;
logic setup_imp;

always_ff @(posedge button[2], negedge reset)
begin
if (~reset) setup_rezhim <= 0;
else if (button[2] == 1) 
	begin
		if (rezhim == 1) setup_rezhim <= setup_rezhim + 1;
		else setup_rezhim <= setup_rezhim;
	end
else setup_rezhim <= setup_rezhim;
end

always_ff @(posedge clock)
begin
if (clock == 1) 
	begin
		if (rezhim == 1)
			begin
				if (setup_rezhim == 0)
					begin
					setup_imp <= 0;
					setup_data <= data_t;
					end
				else if ((setup_rezhim == 1) & (button[1] == 1)) 
					begin
						if (setup_data[7:0] < 59) setup_data[7:0] <= setup_data[7:0] + 1;
						else setup_data[7:0] <= 0;
					end
				else if ((setup_rezhim == 2) & (button[1] == 1)) 
					begin
						if (setup_data[15:8] < 59) setup_data[15:8] <= setup_data[15:8] + 1;
						else setup_data[15:8] <= 0;
					end
				else if ((setup_rezhim == 3) & (button[1] == 1)) 
					begin
						if (setup_data[23:16] < 23) setup_data[23:16] <= setup_data[23:16] + 1;
						else setup_data[23:16] <= 0;
						if (button[2] == 1) setup_imp <= 1;
						else setup_imp <= 0;
					end
				else setup_data <= setup_data;
			end
	end
end

logic flag;


always_comb
begin
led = led;
if (data_t == 0) 
	begin
	led = '1;
	flag = 1;
	end
else 
	begin
	led = 0;
	flag = 0;
	end
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
	.set 						(flag),
	.i_initial 				(0),
	.work_en 				(start_stop),
	.up_down					(0),
	.timer_reset			(),
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
	.timer_reset			(flag),
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
	.timer_reset			(flag),
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
	.timer_reset			(flag),
	.rezhim					(),
	.out_imp 				(day_imp),
	.data						(data_t[23:16])
	);	
endmodule