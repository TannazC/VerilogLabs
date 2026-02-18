// Lab 5 - Part 1
// One-hot FSM: detect 0000 or 1111 (overlap allowed)
// Tannaz C.
// 2026-02-17
// MIT License
//
// Objective:
// Recognize four consecutive 0s or four consecutive 1s on input w.
// Output z=1 whenever the last four samples of w are all 0 or all 1.
// Overlap is allowed (e.g., 11111 makes z high on the 4th and 5th 1).
// FSM is implemented with one-hot encoding using y8..y0 (9 state flip-flops).
// Next-state boolean equations are derived by inspection from the provided state diagram.

module part1 (
    input  [1:0] SW,          // SW0=resetn, SW1=w
    input  [0:0] KEY,         // KEY0=clock
    output [9:0] LEDR         // LEDR9=z, LEDR8..0=state bits
);

    wire clk    = KEY[0];      // FSM clock
    wire w      = SW[1];       // input symbol
    wire resetn = SW[0];       // active-LOW reset
    wire [8:0] y;              // one-hot present state bits
    wire z;                    // Moore output

    wire Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7, Y8; // one-hot next-state bits

    assign LEDR[9]   = z;      // show output
    assign LEDR[8:0] = y;      // show state bits

    // next-state logic (one-hot), derived from state diagram
    assign Y0 = ~resetn;                                                    // go to A on reset
    assign Y1 =  resetn & (~w) & (y[0] | y[5] | y[6] | y[7] | y[8]);         // -> B on 0
    assign Y2 =  resetn & (~w) &  y[1];                                      // -> C on 0
    assign Y3 =  resetn & (~w) &  y[2];                                      // -> D on 0
    assign Y4 =  resetn & (~w) & (y[3] | y[4]);                              // ->/stay E on 0 (detect 0000)
    assign Y5 =  resetn & ( w) & (y[0] | y[1] | y[2] | y[3] | y[4]);         // -> F on 1
    assign Y6 =  resetn & ( w) &  y[5];                                      // -> G on 1
    assign Y7 =  resetn & ( w) &  y[6];                                      // -> H on 1
    assign Y8 =  resetn & ( w) & (y[7] | y[8]);                              // ->/stay I on 1 (detect 1111)

    assign z = y[4] | y[8];                                                 // z=1 in E or I (Moore output)

    DFFs u0 (Y0, clk, y[0]);                                                // state A
    DFFs u1 (Y1, clk, y[1]);                                                // state B
    DFFs u2 (Y2, clk, y[2]);                                                // state C
    DFFs u3 (Y3, clk, y[3]);                                                // state D
    DFFs u4 (Y4, clk, y[4]);                                                // state E
    DFFs u5 (Y5, clk, y[5]);                                                // state F
    DFFs u6 (Y6, clk, y[6]);                                                // state G
    DFFs u7 (Y7, clk, y[7]);                                                // state H
    DFFs u8 (Y8, clk, y[8]);                                                // state I

endmodule

// DFFs
// Simple D flip-flop used for one-hot state storage
module DFFs (
    input  D,                  // next-state bit
    input  clock,              // clock (posedge)
    output reg Q               // present-state bit
);

    always @(posedge clock)
        Q <= D;                // one-hot state update

endmodule
