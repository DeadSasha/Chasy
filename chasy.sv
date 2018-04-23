/*Файл разрабатываемого устройства верхнего уровня,предназначен для определения внешних портов,
а также линий соединений модулей нижнего уровня*/

//Объявление описания модуля верхнего уровня устройства
module chasy
//Блок объявления входных и выходных портов устройства
(
input logic clock,					//Вход от генератора частоты


//Значение младшего разряда секунд после дешифратора для отображения на скмисегментном дисплее
//Значение старшего знака секунд для отображения на диодах

input logic reset,					//Внешний сброс	
input logic [0:3] button,			//кнопки управления часами
output logic [6:0] ssegment0,		//Значение младшего разряда секунд после дешифратора для отображения на скмисегментном дисплее
output logic [6:0] ssegment1,		//Значение старшего разряда секунд после дешифратора для отображения на скмисегментном дисплее
output logic [6:0] ssegment2,		//Значение младшего разряда минут после дешифратора для отображения на скмисегментном дисплее
output logic [6:0] ssegment3,		//Значение старшего разряда минут после дешифратора для отображения на скмисегментном дисплее
output logic [6:0] ssegment4,		//Значение младшего разряда часов после дешифратора для отображения на скмисегментном дисплее
output logic [6:0] ssegment5,		//Значение старшего разряда часов после дешифратора для отображения на скмисегментном дисплее
output logic [3:0] led				//Светодиоды для отображения завершения работы таймера
);

//Определение внутренних переменных и проводов, соединяющих модули
logic [0:3] work_button;
logic [23:0] data_ch;
logic [23:0] data_s;
logic [23:0] data_t;
logic [23:0] setup_data;
logic [1:0] rezhim;
logic setup_imp;
	
//Объявление экзкмпляров модулей
	
//Экземпляр модуля антидребезга кнопки
//antidrebezg -общее наименование модуля
	
antidrebezg button1 //button1 - название экземпляра
//Начало блока посоединения портов
(
	.clock					(clock), 			//к порту clock (так он называется в молуде antidrebezg)
	.reset					(reset),				//подсоединен входной порт линия clock
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

//Процедурный блок определяющий триггерную логику (ff - означает flip-flop, то есть триггер)
//Все переменные блока работают по фронту (posedge) сигнала синхрочастоты (т.е. меняют свои значения только в
//данный промежуток модельного времени и одновременно),
//а также имеют ассинхронный сброс (наличие второго сигнала) по спаду (negedge) сигнала сброса
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