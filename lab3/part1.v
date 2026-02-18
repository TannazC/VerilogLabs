 module Lab3Part1 (Clk, R, S, Qa, Qb);
 // Learning how to use clocks/ edge detection/ flipflops
	 input Clk, R, S;
	 output Qa, Qb;
	 wire R_g, S_g;
	 assign R_g = R & Clk;
	 assign S_g = S & Clk;
	 assign Qa = ~(R_g | Qb);
	 assign Qb = ~(S_g | Qa);
 endmodule