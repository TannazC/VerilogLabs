// Lab 2 - Part 2
// 4-bit binary (0–15) to two decimal digits on HEX1/HEX0
// Tannaz C.
// 2026-02-17
// MIT License
// DE1-SoC (Cyclone V 5CSEMA5F31C6)
//
// Objective:
// Convert a 4-bit binary input V=SW3..0 into its 2-digit decimal form D=d1d0.
//   For V = 0..9  -> HEX1 shows 0, HEX0 shows V
//   For V = 10..15 -> HEX1 shows 1, HEX0 shows (V - 10)
// Comparator output z detects V > 9, then a mux selects either V (z=0) or A (z=1).
// Boolean equations for the comparator, A logic, and 7-seg decoder come from truth tables.

module lab2part2 (
    input  [3:0] SW,          // V[3:0] = SW3..0
    output [0:6] HEX1,         // tens digit (active-LOW segments)
    output [0:6] HEX0          // ones digit (active-LOW segments)
);

    wire [3:0] V;              // mux output into HEX0 decoder
    wire [3:0] A;              // adjusted value when V > 9 (A = V - 10 for 10..15)
    wire       z;              // comparator: 1 when V > 9

    assign z = (SW[3] & SW[2]) | (SW[3] & SW[1]);   // z=1 for 10..15 (1010–1111)

    // HEX1 shows the tens digit (0 or 1) using z
    assign HEX1[0] = z;        // segment pattern for '0' vs '1' controlled by z
    assign HEX1[1] = 1'b0;     // kept ON for both '0' and '1' (active-LOW)
    assign HEX1[2] = 1'b0;     // kept ON for both '0' and '1' (active-LOW)
    assign HEX1[3] = z;        // OFF for '1', ON for '0'
    assign HEX1[4] = z;        // OFF for '1', ON for '0'
    assign HEX1[5] = z;        // OFF for '1', ON for '0'
    assign HEX1[6] = 1'b1;     // always OFF (middle segment not used)

    // A logic (only matters when z=1): maps 10..15 -> 0..5
    assign A[3] = 1'b0;        // output range 0..5 fits in 3 bits
    assign A[2] = SW[2] & SW[1]; // high bit for 14,15 -> 4,5
    assign A[1] = ~SW[1];      // maps 10..13 -> 0..3
    assign A[0] = SW[0];       // preserves LSB

    // 4-bit wide 2-to-1 mux: V = (z ? A : SW)
    assign V[0] = (~z & SW[0]) | (z & A[0]);  // ones digit bit 0
    assign V[1] = (~z & SW[1]) | (z & A[1]);  // ones digit bit 1
    assign V[2] = (~z & SW[2]) | (z & A[2]);  // ones digit bit 2
    assign V[3] = (~z & SW[3]) | (z & A[3]);  // ones digit bit 3

    // HEX0 7-seg decode for digit 0..9 using V[3:0] (active-LOW)
    // Segment equations derived from the 7-seg truth table with don't-cares for 10..15.
    assign HEX0[0] = (~V[3]&~V[2]&~V[1]& V[0]) | (~V[3]& V[2]&~V[1]&~V[0]);
    assign HEX0[1] = ( V[2]&~V[1]& V[0]) | ( V[2]& V[1]&~V[0]);
    assign HEX0[2] = (~V[3]&~V[2]& V[1]&~V[0]);
    assign HEX0[3] = (~V[2]&~V[1]& V[0]) | ( V[2]&~V[1]&~V[0]) | ( V[2]& V[1]& V[0]);
    assign HEX0[4] = ( V[0]) | ( V[2]&~V[1]);
    assign HEX0[5] = ( V[1]& V[0]) | (~V[2]& V[1]&~V[0]) | (~V[3]&~V[2]& V[0]);
    assign HEX0[6] = (~V[3]&~V[2]&~V[1]) | ( V[2]& V[1]& V[0]);

endmodule
