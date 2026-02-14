// 4-bit wide 2-to-1 mux, per-bit form
module part2 (SW, LEDR);
  input  [9:0] SW;      // switches on board
  output [9:0] LEDR;    // red LEDs on board

  wire        s = SW[9];      // select
  wire [3:0]  X = SW[3:0];    // X input (x3..x0)
  wire [3:0]  Y = SW[7:4];    // Y input (y3..y0)
  wire [3:0]  M;

  // ---- per-bit mux equations ----
  assign M[0] = (~s & X[0]) | (s & Y[0]);
  assign M[1] = (~s & X[1]) | (s & Y[1]);
  assign M[2] = (~s & X[2]) | (s & Y[2]);
  assign M[3] = (~s & X[3]) | (s & Y[3]);

  // drive LEDs
  assign LEDR[3:0] = M;       // show m3..m0 on LEDR3..0
  assign LEDR[9]   = s;       // show select on LEDR9
  assign LEDR[8:4] = 5'b0;    // unused LEDs off
endmodule
