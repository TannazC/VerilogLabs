// Lab 3 - Part 1
// Gated RS Latch (level-sensitive with clock enable)
// Tannaz C.
// 2026-02-17
// MIT License
// DE1-SoC (Cyclone V)
//
// Objective:
// Implement a gated RS latch using cross-coupled NOR logic.
// The clock (Clk) acts as an enable signal.
// When Clk = 1, R and S can affect the latch.
// When Clk = 0, the latch holds its previous state.
// Boolean equations follow directly from the RS latch truth table.

module Lab3Part1 (
    input  Clk,   // level-sensitive enable
    input  R,     // reset input
    input  S,     // set input
    output Qa,    // latch output
    output Qb     // complement output
);

    wire R_g;     // gated reset
    wire S_g;     // gated set

    assign R_g = R & Clk;      // R only active when Clk=1
    assign S_g = S & Clk;      // S only active when Clk=1

    assign Qa = ~(R_g | Qb);   // NOR latch equation
    assign Qb = ~(S_g | Qa);   // cross-coupled NOR feedback

endmodule
