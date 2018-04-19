`timescale 1ns/1ns
//Описание работы тестовой программы
module test

	(
//		input	logic		[3:0] low_sec_dig,
//		input	logic		[2:0]	high_sec_dig,
//		
//		input	logic				second,
//    input	logic				minute
output logic clock,
output logic reset,
output logic [0:3] button
	);
  // Объявление внутренних переменных
  int minute_cnt;
  
  //Процедурный блок. Все операции процедурного блока между begin и end выполняются последовательно,
  //т.е. как в обычном языке программирования (например С++)
  initial begin
    //Инициализация без затраты модельного времени
    //Инициализация начальных значений выходных линий
    clock = 0;
    reset = 0;
    //Инициализация начальных значений переменных
    button = 0;

	    
    //Процедурный блок fork ... join состоит из несккольких последовательных блоков, которые в свою очередь,
    //выполняются параллельно относительно друг друга.
    fork 
      //Первый последовательный блок
      //Определение бесконечного цикла генерации сигнала синхрочастоты
      forever #1 clock = ~clock;        //#5 - означет задержку в модельном времени перед изменением сигнала
                                    //относительно времени от предыдущего оператора. Единица измерения задержки
                                    //первое значение в команде директиве timescale
      //Второй последовательный блок
      //Описание сигнала сброса
      
	  forever begin
	  #2 reset = ~reset;
	  #100000 button[3] = ~button[3];
	  #600 button[3] = ~button[3];
	  #10 button[1] = ~button[1];
	  #600 button[1] = ~button[1];
	  #10 button[2] = ~button[2];
	  #600 button[2] = ~button[2];
	  #10 button[1] = ~button[1];
	  #600 button[1] = ~button[1];
	  #10 button[2] = ~button[2];
	  #600 button[2] = ~button[2];
	  #10 button[1] = ~button[1];
	  #600 button[1] = ~button[1];
	  #10 button[2] = ~button[2];
	  #600 button[2] = ~button[2];
	  #10 button[0] = ~button[0];
	  #600 button[0] = ~button[0];
	  #10 button[1] = ~button[1];
	  #600 button[1] = ~button[1];
	  #10 button[0] = ~button[0];
	  #600 button[0] = ~button[0];
	  #10 button[3] = ~button[3];
	  #600 button[3] = ~button[3];
	  #10 button[2] = ~button[2];
	  #600 button[2] = ~button[2];
	  #100000 button[2] = ~button[2];
	  #600 button[2] = ~button[2];
	  #10 button[1] = ~button[1];
	  #600 button[1] = ~button[1];
	  #10 button[3] = ~button[3];
	  #600 button[3] = ~button[3];
	  #10 button[1] = ~button[1];
	  #600 button[1] = ~button[1];
	  #10 button[2] = ~button[2];
	  #600 button[2] = ~button[2];
	  #10 button[1] = ~button[1];
	  #600 button[1] = ~button[1];
	  #10 button[2] = ~button[2];
	  #600 button[2] = ~button[2];
	  #10 button[1] = ~button[1];
	  #600 button[1] = ~button[1];
	  #10 button[2] = ~button[2];
	  #600 button[2] = ~button[2];
	  #10 button[0] = ~button[0];
	  #600 button[0] = ~button[0];
	  #10 button[1] = ~button[1];
	  #600 button[1] = ~button[1];
	  #10 button[3] = ~button[3];
	  #600 button[3] = ~button[3];
	  #100000 reset = ~reset;
	  end
	  
	 // forever
     // begin
     // #10 reset = ~reset;
     // #2700000 reset = ~reset;     //описание генерации сигнала сброса
     // #10 reset = ~reset;     //в соответствии с описанием модуля, устройство работает при значении "1"
     // end
     // //Третий последовательный блок
     // //Вывод информации о значении выходных портов устройства в консоль
	 // 
     // forever
     // begin
     // #5000 button[3] = ~button[3];
     // #55000 button[3] = ~button[3];
     // end
     // 
     // forever
     // begin
     // #10000 button[2] = ~button[2];
     // #5000 button[2] = ~button[2];
     // end
     // 
     // forever
     // begin
     // #11000 button[1] = ~button[1];
     // #4000 button[1] = ~button[1];
     // end
     // 
     // forever
     // begin
     // #10000 button[0] = ~button[0];
     // #5000 button[0] = ~button[0];
     // end
      
//     forever begin
//       @(posedge second);  //Оператор ожидания фронта секундного импульса от устройтва
//       $display ("Second impulse detect. Model time:%t\nDisplay second value: %d%d\n",$time(),high_sec_dig,low_sec_dig);
//       end
//     //Четвертый последовательный блок
//     //Детектирование минутных импульсов от устройтва и условие окончания симуляции
//     forever begin
//       @(posedge minute);
//       if (minute_cnt>5) $finish();
//       else minute_cnt++;
//       $display ("-------------------------------------------------");
//       $display ("Minute impulse detect. Model time:%t\nNumber of detect minute impulse:%d",$time(),minute_cnt);
//       $display ("-------------------------------------------------");
//       
//       
//       end
      //Пятый последовательный блок  
      begin
        $display ("------------------------ATTENTION------------------------------");
        $display ("Please add additional wave to waveform and run simulation");
        $display ("Menu Simulate/Run/Run -all or write command run -all to console");
        $display ("------------------------ATTENTION------------------------------");
        $stop();
      end
      
    join    // Окончание параллельного блока
  
  end
  
  
endmodule