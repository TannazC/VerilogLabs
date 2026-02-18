// 2-bit wide 3-to-1 multiplexer (DE1-SoC wiring)
module part3 (input  [9:0] SW,output [9:0] LEDR);
  wire s1 = SW[9];
  wire s0 = SW[8];
  wire [1:0] U = SW[5:4];
  wire [1:0] V = SW[3:2];
  wire [1:0] W = SW[1:0];
  wire [1:0] M;

  // choose U (00), V (01), or W (1x)
  assign M = s1 ? W : (s0 ? V : U); //TERNARY OPERATOR!!!

  assign LEDR[1:0] = M;      // M → LEDR1..0
  assign LEDR[9:2] = 8'b0;   // others off
endmodule