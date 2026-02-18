// Lab 1 - Part 3
// 2-bit 3-to-1 Multiplexer (built from 2-to-1 mux stages)
// Tannaz C.
// 2026-02-17
// MIT License
// DE1-SoC (Cyclone V 5CSEMA5F31C6)
//
// Objective:
// Implement a 2-bit wide 3-to-1 multiplexer using two 2-to-1 multiplexers.
// The 2-bit select input s1s0 chooses which 2-bit input appears on M.
//
// Select behavior (truth table style):
//   s1s0 = 00  -> M = U
//   s1s0 = 01  -> M = V
//   s1s0 = 10  -> M = W
//   s1s0 = 11  -> (not used / don't-care in this lab)
//
// Board Mapping:
//   SW9..8  -> s1..s0
//   SW5..4  -> U[1:0]
//   SW3..2  -> V[1:0]
//   SW1..0  -> W[1:0]
//   LEDR1..0 -> M[1:0]
//

module part3 (
    input  [9:0] SW,        // slide switches
    output [9:0] LEDR       // red LEDs (only LEDR1..0 used)
);

    wire [1:0] s;            // select bits: s[1]=s1, s[0]=s0
    wire [1:0] U;            // 2-bit input U
    wire [1:0] V;            // 2-bit input V
    wire [1:0] W;            // 2-bit input W
    wire [1:0] M;            // 2-bit output
    wire [1:0] uv_sel;       // intermediate result after first mux stage

    assign s = SW[9:8];      // select from SW9..SW8
    assign U = SW[5:4];      // U from SW5..SW4
    assign V = SW[3:2];      // V from SW3..SW2
    assign W = SW[1:0];      // W from SW1..SW0

    // First 2-to-1 mux stage: choose U vs V using s0
    assign uv_sel[0] = (~s[0] & U[0]) | (s[0] & V[0]);  // bit 0
    assign uv_sel[1] = (~s[0] & U[1]) | (s[0] & V[1]);  // bit 1

    // Second 2-to-1 mux stage: choose (U/V result) vs W using s1
    assign M[0] = (~s[1] & uv_sel[0]) | (s[1] & W[0]);  // bit 0
    assign M[1] = (~s[1] & uv_sel[1]) | (s[1] & W[1]);  // bit 1

    assign LEDR[1:0] = M;    // show M on LEDR1..0
    assign LEDR[9:2] = 8'b0; // unused LEDs off

endmodule
