// Lab 3 - Part 3
// Master-slave D flip-flop built from two gated D latches
// Tannaz C. 
// 2026-02-17
// MIT License
// DE1-SoC (Cyclone V)
//
// Objective:
// Build an edge-triggered D flip-flop using two level-sensitive D latches.
// The master latch is enabled when Clk=0, and the slave latch is enabled when Clk=1.
// This master-slave arrangement updates Q on the rising edge of the clock.
// Board mapping: SW0 -> D, SW1 -> Clk, LEDR0 -> Q.

module Lab3Part3 (
    input  [9:0] SW,        // SW0=D, SW1=Clk
    output [9:0] LEDR       // LEDR0=Q, others unused
);

    wire D;                 // data input
    wire Clk;               // clock input
    wire Qm;                // master latch output (internal)

    assign D   = SW[0];     // drive D from SW0
    assign Clk = SW[1];     // drive clock from SW1

    // master latch (transparent when Clk=0)
    D_latch Master (
        .Clk(~Clk),         // enable master on low clock level
        .D  (D),            // sample D
        .Q  (Qm)            // hold sampled value
    );

    // slave latch (transparent when Clk=1)
    D_latch Slave (
        .Clk(Clk),          // enable slave on high clock level
        .D  (Qm),           // take master output
        .Q  (LEDR[0])       // drive final Q to LEDR0
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
    // When Clk is high, Q follows D. When Clk is low, Q retains its last value.
    always @ (D, Clk) begin
        if (Clk == 1'b1)
            Q = D;          // transparent phase
    end

endmodule
