// Lab 5 - Part 2
// Binary-encoded FSM (case-based): detect 0000 or 1111 (overlap allowed)
// Tannaz C.
// 2026-02-17
// MIT License
//
// Objective:
// Implement the same sequence detector as Part 1, but using binary state encoding
// and a case-based state table (no manual D-input boolean derivations).
// Input w is sampled on each clock. z=1 when the FSM reaches the "4 zeros" state
// or the "4 ones" state. Overlap is allowed.
// SW0=resetn (active-LOW), SW1=w, KEY0=clock.
// LEDR4 shows z, LEDR3..0 shows the current state code.

module part2 (
    input  [1:0] SW,          // SW0=resetn, SW1=w
    input  [0:0] KEY,         // KEY0=clock
    output [4:0] LEDR         // LEDR4=z, LEDR3..0=state
);

    wire clk    = KEY[0];      // FSM clock
    wire resetn = SW[0];       // active-LOW reset
    wire w      = SW[1];       // input symbol

    reg  [3:0] y;              // current state (binary-coded)
    reg  [3:0] Y;              // next state

    localparam A = 4'b0000,    // start / no run
               B = 4'b0001,    // seen 0
               C = 4'b0010,    // seen 00
               D = 4'b0011,    // seen 000
               E = 4'b0100,    // seen 0000 (z=1)
               F = 4'b0101,    // seen 1
               G = 4'b0110,    // seen 11
               H = 4'b0111,    // seen 111
               I = 4'b1000;    // seen 1111 (z=1)

    // state_table
    // Next-state logic derived from the provided FSM diagram, coded as a case statement.
    always @(*) begin : state_table
        Y = A;                 // default to avoid inferred latches
        case (y)
            A: Y = (w) ? F : B;
            B: Y = (w) ? F : C;
            C: Y = (w) ? F : D;
            D: Y = (w) ? F : E;
            E: Y = (w) ? F : E; // stay in E while w=0 (overlap for 00000...)
            F: Y = (w) ? G : B;
            G: Y = (w) ? H : B;
            H: Y = (w) ? I : B;
            I: Y = (w) ? I : B; // stay in I while w=1 (overlap for 11111...)
            default: Y = A;
        endcase
    end

    // state_FFs
    // State register updates on the clock edge.
    always @(posedge clk) begin : state_FFs
        if (!resetn)
            y <= A;            // reset to start state
        else
            y <= Y;            // load next state
    end

    wire z = (y == E) || (y == I);  // Moore output: high in states E or I

    assign LEDR[4]   = z;      // display z
    assign LEDR[3:0] = y;      // display current state code

endmodule
