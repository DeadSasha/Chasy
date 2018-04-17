module SEG7
(
input logic [3:0] i_tens,
input logic [3:0] i_ones,
output logic [6:0] segL,
output logic [6:0] segR
);

always_comb
begin
 case(i_tens)
	0: segL = 7'b1000000;
	1: segL = 7'b1111001;
	2: segL = 7'b0100100;
	3: segL = 7'b0110000;
	4: segL = 7'b0011001;
	5: segL = 7'b0010010;
	6: segL = 7'b0000010;
	7: segL = 7'b1111000;
	8: segL = 7'b0000000;
	9: segL = 7'b0011000;
	10: segL = 7'b0001000;
	11: segL = 7'b0000011;
	12: segL = 7'b1000110;
	13: segL = 7'b0100001;
	14: segL = 7'b0000110;
	15: segL = 7'b0001110;
	default: segL = 7'b1111111;
endcase
 case(i_ones)
	0: segR = 7'b1000000;
	1: segR = 7'b1111001;
	2: segR = 7'b0100100;
	3: segR = 7'b0110000;
	4: segR = 7'b0011001;
	5: segR = 7'b0010010;
	6: segR = 7'b0000010;
	7: segR = 7'b1111000;
	8: segR = 7'b0000000;
	9: segR = 7'b0011000;
	10: segR = 7'b0001000;
	11: segR = 7'b0000011;
	12: segR = 7'b1000110;
	13: segR = 7'b0100001;
	14: segR = 7'b0000110;
	15: segR = 7'b0001110;
	default: segR = 7'b1111111;
endcase
end

endmodule