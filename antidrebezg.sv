module antidrebezg 
(
input logic clock,
input logic reset,
input logic button,
output logic pulse
);
	logic [7:0] count;
	logic trigger_button;
	logic razresh;

always_ff @(posedge clock)
begin
	if(button == 0) 
		begin
      count <= 0;
      razresh <= 0;
		end
	else if (count == '1)
    begin
      count <= count;
      razresh <= 1;
    end
  else
    begin
      count <= count + 1;
      razresh <= 0;
    end
end

always_ff @(posedge clock)
begin
	trigger_button <= razresh;
end


always_ff @(posedge clock)
begin
	if((razresh == 1) && (trigger_button == 0))
		pulse <= 1;
	else	
		pulse <= 0;
end
endmodule