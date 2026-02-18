// Lab 2 - Part 1
// Dual 7-seg Decoder for SW7..0 (0–9 only)
// Tannaz C.
// 2026-02-17
// MIT License
// DE1-SoC (Cyclone V 5CSEMA5F31C6)
//
// Objective:
// Display SW values on LEDs and show two decimal digits on HEX1 and HEX0.
//   HEX0 displays SW3..0
//   HEX1 displays SW7..4
// Only digits 0–9 are supported (1010–1111 treated as don't-cares).
// All segment equations were derived manually from truth tables
// using Boolean minimization (sum-of-products form).
// HEX displays are active-LOW (0 turns a segment ON).

module lab2part1 (
    input  [7:0] SW,        // switch inputs
    output [7:0] LEDR,      // LEDs mirror switches
    output [6:0] HEX1,      // tens digit (active-LOW)
    output [6:0] HEX0       // ones digit (active-LOW)
);

    assign LEDR = SW;       // show switch states directly

    // ---- HEX0 decode (SW3..0 → digit 0–9) ----
    // Each segment equation is derived from the 7-seg truth table.
    assign HEX0[0] = (~SW[3]&~SW[2]&~SW[1]& SW[0]) | (~SW[3]& SW[2]&~SW[1]&~SW[0]);
    assign HEX0[1] = ( SW[2]&~SW[1]& SW[0]) | ( SW[2]& SW[1]&~SW[0]);
    assign HEX0[2] = (~SW[3]&~SW[2]& SW[1]&~SW[0]);
    assign HEX0[3] = (~SW[2]&~SW[1]& SW[0]) | ( SW[2]&~SW[1]&~SW[0]) | ( SW[2]& SW[1]& SW[0]);
    assign HEX0[4] = ( SW[0]) | ( SW[2]&~SW[1]);
    assign HEX0[5] = ( SW[1]& SW[0]) | (~SW[2]& SW[1]&~SW[0]) | (~SW[3]&~SW[2]& SW[0]);
    assign HEX0[6] = (~SW[3]&~SW[2]&~SW[1]) | ( SW[2]& SW[1]& SW[0]);

    // ---- HEX1 decode (SW7..4 → digit 0–9) ----
    // Same logic structure applied to upper nibble.
    assign HEX1[0] = (~SW[7]&~SW[6]&~SW[5]& SW[4]) | (~SW[7]& SW[6]&~SW[5]&~SW[4]);
    assign HEX1[1] = ( SW[6]&~SW[5]& SW[4]) | ( SW[6]& SW[5]&~SW[4]);
    assign HEX1[2] = (~SW[7]&~SW[6]& SW[5]&~SW[4]);
    assign HEX1[3] = (~SW[6]&~SW[5]& SW[4]) | ( SW[6]&~SW[5]&~SW[4]) | ( SW[6]& SW[5]& SW[4]);
    assign HEX1[4] = ( SW[4]) | ( SW[6]&~SW[5]);
    assign HEX1[5] = ( SW[5]& SW[4]) | (~SW[6]& SW[5]&~SW[4]) | (~SW[7]&~SW[6]& SW[4]);
    assign HEX1[6] = (~SW[7]&~SW[6]&~SW[5]) | ( SW[6]& SW[5]& SW[4]);

endmodule
