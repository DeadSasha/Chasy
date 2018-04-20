module chasy
(
input logic clock,
input logic reset,
input logic [0:3] button,
output logic [6:0] ssegment0,
output logic [6:0] ssegment1,
output logic [6:0] ssegment2,
output logic [6:0] ssegment3,
output logic [6:0] ssegment4,
output logic [6:0] ssegment5,
output logic [3:0] led
);

logic [0:3] work_button;

logic [23:0] data_ch;
logic [23:0] data_s;
logic [23:0] data_t;
logic [23:0] setup_data;
logic [1:0] rezhim;
logic setup_imp;

antidrebezg button1
(
	.clock					(clock),
	.reset					(reset),
	.button					(~button[3]),
	.pulse					(work_button[0])
);

antidrebezg button2
(
	.clock					(clock),
	.reset					(reset),
	.button					(~button[2]),
	.pulse					(work_button[1])
);

antidrebezg button3
(
	.clock					(clock),
	.reset					(reset),
	.button					(~button[1]),
	.pulse					(work_button[2])
);

antidrebezg button4
(
	.clock					(clock),
	.reset					(reset),
	.button					(~button[0]),
	.pulse					(work_button[3])
);


always_ff @(posedge clock)
begin
if (reset == 1) rezhim <= 0;
else 
	begin
		if (work_button[0] == 1) rezhim <= rezhim + 1;
		else rezhim <= rezhim;
	end
end

logic [1:0] setup_rezhim_t;
logic [23:0] setup_data_t;

SEG7counter display
(
	.clock						(clock),
	.reset						(reset),
	.data_ch						(data_ch),
	.data_t						(data_t),
	.data_s						(data_s),
	.setup_data					(setup_data),
	.rezhim						(rezhim),
	.setup_rezhim_t			(setup_rezhim_t),
	.setup_data_t				(setup_data_t),
	.ssegmentHL					(ssegment5),
	.ssegmentHR					(ssegment4),
	.ssegmentML					(ssegment3),
	.ssegmentMR					(ssegment2),
	.ssegmentSL					(ssegment1),
	.ssegmentSR					(ssegment0)
);

setup SET_TIME
(
	.clock						(clock),
	.reset						(reset),
	.data_ch						(data_ch),
	.button						(work_button),
	.rezhim						(rezhim),
	.setup_data					(setup_data),
	.setup_imp					(setup_imp)
);

chasy_RT REAL_TIME_CLOCK
(
	.clock						(clock),
	.reset						(reset),
	.setup_data					(setup_data),
	.setup_imp					(setup_imp),
	.data_ch						(data_ch)
);

timer TIMER
(
	.clock						(clock),
	.reset						(reset),
	.rezhim						(rezhim),
	.button						(work_button),
	.data_t						(data_t),
	.setup_rezhim_t			(setup_rezhim_t),
	.setup_data_t				(setup_data_t),
	.led							(led)
); 

stopwatch STOPWATCH
(
	.clock						(clock),
	.reset						(reset),
	.rezhim						(rezhim),
	.button_start_stop		(work_button[1]),
	.button_reset				(work_button[2]),
	.data_s						(data_s)
); 

endmodule