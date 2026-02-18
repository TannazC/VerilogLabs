module Lab4Part1(SW,KEY,HEX0,HEX1);
	input [1:0] SW;
	input [0:0] KEY;
	output [6:0] HEX0, HEX1;
	
	wire E,clk, clear, Q;
	wire [3:0] Q1,Q2;
	
	assign KEY[0] = clk;
	assign SW[1] = E
	assign SW[0] = clear
	
	// instantiate togglr flipflop 8 times, store in Q1 Q2 resp.
		// easier to print

// first nibble, read backwards Q3Q2Q1Q0	
	Tflip(E,clk,clear,Q);
	
	Q1[0] = Q&E; // and gate
	Tflip(Q1[0],clk,clear,Q);
	
	Q1[1] = Q&Q1[0];
	Tflip(Q1[1],clk,clear,Q);
	
	Q1[2] = Q&Q1[1];
	Tflip(Q1[2],clk,clear,Q);
	
	Q1[3] = Q&Q1[2];
	Tflip(Q1[3],clk,clear,Q);
	
// second nibble
	
	Q2[0] = Q&E;
	Tflip(Q2[0],clk,clear,Q);
	
	Q2[1] = Q&Q2[0];
	Tflip(Q1[1],clk,clear,Q);
	
	Q2[2] = Q&Q2[1];
	Tflip(Q1[2],clk,clear,Q);
	
	Q2[3] = Q
	
	
	displayHex u1(Q1, HEX0)
	displayHex u2(Q2, HEX1)
endmodule 	
		
module displayHex (F, HEX);
	input [3:0] F;
	output [6:0] HEX;
	//covers the AbCdE for hex
	assign HEX[0] = (~F[3]&~F[2]&~F[1]&F[0]) | (~F[3]&F[2]&~F[1]&~F[0]) | (F[3]&F[2]&~F[1]&F[0]) | (F[3]&~F[2]&F[1]&F[0]);
	assign HEX[1] = (~F[3]&F[2]&~F[1]&F[0]) | (F[3]&F[2]&~F[0]) | (F[3]&F[1]&F[0]) | (F[2]&F[1]&~F[0]);
	assign HEX[2] = (~F[3]&~F[2]&F[1]&~F[0]) | (F[3]&F[2]&~F[0]) | (F[3]&F[2]&F[1]);
	assign HEX[3] = (~F[3]&F[2]&~F[1]&~F[0]) | (F[3]&~F[2]&F[1]&~F[0]) | (F[2]&F[1]&F[0]) | (~F[2]&~F[1]&F[0]);
	assign HEX[4] = (~F[3]&F[0]) | (~F[2]&~F[1]&F[0]) | (~F[3]&F[2]&~F[1]);
	assign HEX[5] = (F[3]&F[2]&~F[1]&F[0]) | (~F[3]&~F[2]&F[0]) | (~F[3]&~F[2]&F[1]) | (~F[3]&F[1]&F[0]);
	assign HEX[6] = (F[3]&F[2]&~F[1]&~F[0]) | (~F[3]&F[2]&F[1]&F[0]) | (~F[3]&~F[2]&~F[1]);
endmodule

module displayHex2(F, HEX0,HEX1)
	input [3:0] F;
	output [6:0] HEX;
	//covers the AbCdE for hex
	assign HEX[0] = (~F[3]&~F[2]&~F[1]&F[0]) | (~F[3]&F[2]&~F[1]&~F[0]) | (F[3]&F[2]&~F[1]&F[0]) | (F[3]&~F[2]&F[1]&F[0]);
	assign HEX[1] = (~F[3]&F[2]&~F[1]&F[0]) | (F[3]&F[2]&~F[0]) | (F[3]&F[1]&F[0]) | (F[2]&F[1]&~F[0]);
	assign HEX[2] = (~F[3]&~F[2]&F[1]&~F[0]) | (F[3]&F[2]&~F[0]) | (F[3]&F[2]&F[1]);
	assign HEX[3] = (~F[3]&F[2]&~F[1]&~F[0]) | (F[3]&~F[2]&F[1]&~F[0]) | (F[2]&F[1]&F[0]) | (~F[2]&~F[1]&F[0]);
	assign HEX[4] = (~F[3]&F[0]) | (~F[2]&~F[1]&F[0]) | (~F[3]&F[2]&~F[1]);
	assign HEX[5] = (F[3]&F[2]&~F[1]&F[0]) | (~F[3]&~F[2]&F[0]) | (~F[3]&~F[2]&F[1]) | (~F[3]&F[1]&F[0]);
	assign HEX[6] = (F[3]&F[2]&~F[1]&~F[0]) | (~F[3]&F[2]&F[1]&F[0]) | (~F[3]&~F[2]&~F[1]);
endmodule

module Tflip(E,clk,clear,Q);
	input E clk, clear;
	output Q;
	
	reg Q;
	always @( negedge clear, posedge E,,posedge clk)
		begin
		if(clear)
			Q<= 1'b0;
		if else(T)
			Q<= ~Q;
		end
endmodule 






