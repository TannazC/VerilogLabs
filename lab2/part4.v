// Lab 2 - Part 4
// BCD adder: X + Y + Cin -> show inputs and 2-digit BCD sum
// Tannaz C.
// 2026-02-17
// MIT License
// DE1-SoC (Cyclone V 5CSEMA5F31C6)
//
// Objective:
// Add two BCD digits X and Y (0–9), plus Cin, and display the decimal result (0–19).
// X is shown on HEX5, Y is shown on HEX3, and the sum S1S0 is shown on HEX1 (tens) + HEX0 (ones).
// The binary add is done with a ripple-carry adder, then corrected when the binary sum > 9.
// Comparator/correction and 7-seg equations are derived from truth tables (BCD correction logic).

module lab2part4 (
    input  [8:0] SW,        // SW7..4=X, SW3..0=Y, SW8=Cin
    output [8:0] LEDR,      // LEDR4..0 shows raw binary sum
    output [6:0] HEX1,      // tens digit of sum (0 or 1)
    output [6:0] HEX0,      // ones digit of sum (0..9)
    output [6:0] HEX5,      // displays X
    output [6:0] HEX3       // displays Y
);

    wire [3:0] X = SW[7:4]; // BCD digit X (assumed 0..9)
    wire [3:0] Y = SW[3:0]; // BCD digit Y (assumed 0..9)
    wire       Cin = SW[8]; // carry-in

    wire [4:0] S;           // raw 5-bit binary sum from ripple adder

    displayNum Ux (X, HEX5); // show X on HEX5
    displayNum Uy (Y, HEX3); // show Y on HEX3

    wire C1, C2, C3, Cout;  // ripple carries

    FA R1 (X[0], Y[0], Cin, S[0], C1);    // bit 0
    FA R2 (X[1], Y[1], C1,  S[1], C2);    // bit 1
    FA R3 (X[2], Y[2], C2,  S[2], C3);    // bit 2
    FA R4 (X[3], Y[3], C3,  S[3], Cout);  // bit 3

    assign S[4] = Cout;                  // final carry -> MSB of 5-bit sum
    assign LEDR[4:0] = S;                // show raw binary sum on LEDs
    assign LEDR[8:5] = 4'b0;             // unused LEDs off

    wire z = S[4] | (S[3] & (S[2] | S[1])); // z=1 when S > 9 (BCD correction needed)

    // HEX1 shows tens digit of the decimal sum (0 when z=0, 1 when z=1)
    assign HEX1[0] = z;                  // segments form '0' vs '1' using z
    assign HEX1[1] = 1'b0;               // ON for both (active-LOW)
    assign HEX1[2] = 1'b0;               // ON for both (active-LOW)
    assign HEX1[3] = z;                  // OFF for '1', ON for '0'
    assign HEX1[4] = z;                  // OFF for '1', ON for '0'
    assign HEX1[5] = z;                  // OFF for '1', ON for '0'
    assign HEX1[6] = 1'b1;               // middle segment always OFF

    wire [4:0] A;                        // corrected ones digit bits when z=1
    wire [4:0] F;                        // final value fed to ones-digit decoder

    assign A[4] = 1'b0;                  // corrected ones digit stays within 0..9
    assign A[3] = S[4] & ~S[3] & ~S[2] & S[1];           // correction logic bit 3
    assign A[2] = (S[4] & ~S[1]) | (S[3] & S[2] & S[1]); // correction logic bit 2
    assign A[1] = ~S[1];                                     // correction logic bit 1
    assign A[0] = S[0];                                      // preserve LSB

    assign F[0] = (~z & S[0]) | (z & A[0]);  // if z=0 use S, else use corrected A
    assign F[1] = (~z & S[1]) | (z & A[1]);
    assign F[2] = (~z & S[2]) | (z & A[2]);
    assign F[3] = (~z & S[3]) | (z & A[3]);
    assign F[4] = (~z & S[4]) | (z & A[4]);  // kept for completeness (A[4]=0)

    displayNum Usum (F[3:0], HEX0);          // show ones digit on HEX0 (0..9)

endmodule

// displayNum
// 4-bit value (0..9) -> 7-seg segments (active-LOW), equations derived from truth table
module displayNum (
    input  [3:0] F,          // digit value
    output [6:0] HEX         // 7-seg outputs (active-LOW)
);

    assign HEX[0] = (~F[3]&~F[2]&~F[1]&F[0]) | (~F[3]&F[2]&~F[1]&~F[0]); // seg 0
    assign HEX[1] = (F[2]&~F[1]&F[0]) | (F[2]&F[1]&~F[0]);               // seg 1
    assign HEX[2] = (~F[3]&~F[2]&F[1]&~F[0]);                            // seg 2
    assign HEX[3] = (~F[2]&~F[1]&F[0]) | (F[2]&~F[1]&~F[0]) | (F[2]&F[1]&F[0]); // seg 3
    assign HEX[4] = (F[0]) | (F[2]&~F[1]);                               // seg 4
    assign HEX[5] = (F[1]&F[0]) | (~F[2]&F[1]&~F[0]) | (~F[3]&~F[2]&F[0]); // seg 5
    assign HEX[6] = (~F[3]&~F[2]&~F[1]) | (F[2]&F[1]&F[0]);              // seg 6

endmodule

// Full Adder
// Adds a, b, Cin -> produces sum s and carry-out Cout (truth-table derived)
module FA (
    input  a,                // operand bit a
    input  b,                // operand bit b
    input  Cin,              // carry-in
    output s,                // sum bit
    output Cout              // carry-out
);

    assign s    = a ^ b ^ Cin;                     // XOR sum
    assign Cout = (a & b) | (a & Cin) | (b & Cin); // carry when 2+ inputs are 1

endmodule
