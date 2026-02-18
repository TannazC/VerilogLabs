// Lab 1 - Part 2
// 4-bit 2-to-1 Multiplexer (SW-controlled)
// Tannaz C.
// 2026-02-17
// MIT License
// DE1-SoC (Cyclone V 5CSEMA5F31C6)
//
// Objective:
// Implement a 4-bit wide 2-to-1 multiplexer using sum-of-products logic.
// The select input (s) chooses between two 4-bit inputs (X and Y).
// If s = 0 → M = X
// If s = 1 → M = Y
//
// Board Mapping:
//   SW9    → select (s)
//   SW3-0  → X[3:0]
//   SW7-4  → Y[3:0]
//   LEDR3-0 → output M[3:0]
//   LEDR9   → displays select
//

module part2 (
    input  [9:0] SW,        // slide switches
    output [9:0] LEDR       // red LEDs
);

    wire        s;           // select line
    wire [3:0]  X;           // 4-bit input X
    wire [3:0]  Y;           // 4-bit input Y
    wire [3:0]  M;           // 4-bit mux output

    assign s = SW[9];        // select from SW9
    assign X = SW[3:0];      // X input from SW3..0
    assign Y = SW[7:4];      // Y input from SW7..4

    // Per-bit sum-of-products implementation of 2:1 mux
    assign M[0] = (~s & X[0]) | (s & Y[0]);   // bit 0
    assign M[1] = (~s & X[1]) | (s & Y[1]);   // bit 1
    assign M[2] = (~s & X[2]) | (s & Y[2]);   // bit 2
    assign M[3] = (~s & X[3]) | (s & Y[3]);   // bit 3

    assign LEDR[3:0] = M;     // display result
    assign LEDR[9]   = s;     // display select
    assign LEDR[8:4] = 5'b0;  // unused LEDs off

endmodule
