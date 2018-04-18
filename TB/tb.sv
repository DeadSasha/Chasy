//Директива определения точности моделирования 
`timescale 1ns/1ns
//Объявление модуля testbench - являющегося модулем сборки
//тестируемого устройства и программы, которая его тестирует,
//т.е. модуль организует интерфейс между ними
module tb ();

//Объявление самого интерфейса (проводов) между программой и модулем
logic clock;
logic reset;
logic [0:3] button;


//Объявление экземпляра тестовой программы
test TEST 
  (
	.clock				(clock		),
	.reset				(reset		),
	.button				(button		)
  );

//Объявление экземпляра устройства  
chasy CHASY
(
	.clock				  (clock		),
	.reset				  (reset		),
	.button				  (button		),
	.ssegment0			(),
	.ssegment1			(),
	.ssegment2			(),
	.ssegment3			(),
	.ssegment4			(),
	.ssegment5			(),
	.led			    	()
);

endmodule