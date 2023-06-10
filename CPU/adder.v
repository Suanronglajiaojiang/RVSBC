module adder (
	a,
	b,
	s,
	y
);
	input wire [31:0] a;
	input wire [31:0] b;
	input wire s;
	output reg [31:0] y;
	always @(*)
		case (s)
			0: y = a + b;
			1: y = (a + b) + 1;
		endcase
endmodule
