// Lab 2 - Part 3
// 4-bit ripple-carry adder built from full adders
// Tannaz C.
// 2026-02-17
// MIT License
// DE1-SoC (Cyclone V 5CSEMA5F31C6)
//
// Objective:
// Implement a 4-bit adder A + B + Cin using four 1-bit full adders (ripple-carry).
// Each stage adds one bit and passes its carry to the next stage.
// Full-adder equations are derived from the full-adder truth table.

module lab2part3 (
    input  [9:0] SW,        // SW7..4=A, SW3..0=B, SW8=Cin
    output [9:0] LEDR       // LEDR3..0=sum, LEDR4=Cout, others unused
);

    wire [3:0] A, B;         // 4-bit operands
    wire [4:0] C;            // carry chain: C[0]=Cin, C[4]=Cout

    assign C[0] = SW[8];     // external carry-in
    assign A    = SW[7:4];   // A from switches
    assign B    = SW[3:0];   // B from switches

    // ripple-carry chain (LSB to MSB)
    FA fa0 (A[0], B[0], C[0], LEDR[0], C[1]);  // bit0 sum -> LEDR0, carry -> C1
    FA fa1 (A[1], B[1], C[1], LEDR[1], C[2]);  // bit1
    FA fa2 (A[2], B[2], C[2], LEDR[2], C[3]);  // bit2
    FA fa3 (A[3], B[3], C[3], LEDR[3], C[4]);  // bit3, final carry -> C4

    assign LEDR[4]   = C[4]; // show carry-out
    assign LEDR[9:5] = 5'b0; // unused LEDs off

endmodule

// Full Adder
// Adds a, b, Cin -> produces sum s and carry-out Cout
module FA (
    input  a,               // operand bit a
    input  b,               // operand bit b
    input  Cin,             // carry-in
    output s,               // sum bit
    output Cout             // carry-out
);

    assign s    = a ^ b ^ Cin;                     // sum from XOR chain
    assign Cout = (a & b) | (a & Cin) | (b & Cin); // carry when 2+ inputs are 1

endmodule
