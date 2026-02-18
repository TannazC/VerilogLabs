// Lab 3 - Part 2
// Gated D Latch (top-level + latch module)
// Tannaz C.
// 2026-02-17
// MIT License
// DE1-SoC (Cyclone V)
//
// Objective:
// Implement a gated D latch (level-sensitive storage).
// When Clk = 1, Q follows D.
// When Clk = 0, Q holds its previous value.
// Top-level maps SW0 -> D, SW1 -> Clk, and displays Q on LEDR0.

module part2 (
    input  [1:0] SW,        // SW0=D, SW1=Clk
    output [9:0] LEDR       // LEDR0=Q, others unused
);

    D_latch u0 (
        .Clk(SW[1]),        // clock/enable from SW1
        .D  (SW[0]),        // data from SW0
        .Q  (LEDR[0])       // output to LEDR0
    );

    assign LEDR[9:1] = 9'b0; // unused LEDs off

endmodule

// D_latch
// Level-sensitive latch: transparent when Clk=1, holds when Clk=0
module D_latch (
    input  Clk,             // latch enable (level)
    input  D,               // data input
    output reg Q            // stored output
);

    // always block
    // When Clk is high, continuously update Q to match D.
    // When Clk is low, no assignment occurs, so Q retains its last value.
    always @ (D, Clk) begin
        if (Clk == 1'b1)
            Q = D;          // latch is transparent
    end

endmodule
