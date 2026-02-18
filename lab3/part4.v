// Lab 3 - Part 4
// Compare: gated D latch vs posedge DFF vs negedge DFF
// Tannaz C.
// 2026-02-17
// MIT License
// DE1-SoC (Cyclone V)
//
// Objective:
// Instantiate three storage elements driven by the same D and Clk, then compare behavior:
//   Qa: gated D latch (level-sensitive, transparent when Clk=1)
//   Qb: positive-edge D flip-flop (updates only on rising edge)
//   Qc: negative-edge D flip-flop (updates only on falling edge)

module part4 (
    input  Clk,        // shared clock
    input  D,          // shared data input
    output Qa,         // latch output
    output Qb,         // posedge FF output
    output Qc          // negedge FF output
);

    D_latch u1 (Clk, D, Qa);     // Qa follows D while Clk=1, holds while Clk=0
    upFlip  u2 (Clk, D, Qb);     // Qb samples D on posedge of Clk
    dnFlip  u3 (Clk, D, Qc);     // Qc samples D on negedge of Clk

endmodule

// upFlip
// Positive-edge triggered D flip-flop
module upFlip (
    input  Clk,                 // clock
    input  D,                   // data
    output reg Q                // registered output
);

    // always block (posedge)
    // Q updates only on the rising edge of Clk.
    always @ (posedge Clk)
        Q <= D;                 // nonblocking assignment for sequential logic

endmodule

// dnFlip
// Negative-edge triggered D flip-flop
module dnFlip (
    input  Clk,                 // clock
    input  D,                   // data
    output reg Q                // registered output
);

    // always block (negedge)
    // Q updates only on the falling edge of Clk.
    always @ (negedge Clk)
        Q <= D;                 // nonblocking assignment for sequential logic

endmodule

// D_latch
// Level-sensitive latch: transparent when Clk=1, holds when Clk=0
module D_latch (
    input  Clk,                 // latch enable (level)
    input  D,                   // data
    output reg Q                // stored output
);

    // always block
    // When Clk is high, Q follows D continuously.
    // When Clk is low, no assignment occurs, so Q holds its last value.
    always @ (D, Clk) begin
        if (Clk == 1'b1)
            Q = D;              // blocking assignment matches latch behavior
    end

endmodule
