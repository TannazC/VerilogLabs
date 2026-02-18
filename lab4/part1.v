// Lab 4 - Part 1
// 8-bit synchronous counter using T flip-flops
// Tannaz C.
// 2026-02-17
// MIT License
//
// Objective:
// Build an 8-bit counter that increments on each clock press when Enable=1.
// Clear is synchronous and active-LOW (Clear=0 forces count to 0 on next clock).
// KEY0 is the manual clock, SW1 is Enable, SW0 is Clear.
// HEX1 shows count[7:4], HEX0 shows count[3:0] in hex (0–F).

module part1 (
    input  [1:0] SW,            // SW1=Enable, SW0=Clear (active-LOW, synchronous)
    input  [0:0] KEY,           // KEY0 pushbutton clock (active-LOW on DE1-SoC)
    output [6:0] HEX1, HEX0     // HEX displays (active-LOW segments)
);

    wire enable = SW[1];         // enable counting when 1
    wire clear_n = SW[0];        // synchronous clear, active-LOW
    wire clk = ~KEY[0];          // convert active-LOW button to active-HIGH clock

    wire [7:0] Q;                // 8-bit counter state
    wire [7:0] T;                // T inputs for each stage

    assign T[0] = enable;                         // toggle LSB when enabled
    assign T[1] = enable & Q[0];                  // toggle when all lower bits are 1
    assign T[2] = enable & Q[0] & Q[1];
    assign T[3] = enable & Q[0] & Q[1] & Q[2];
    assign T[4] = enable & Q[0] & Q[1] & Q[2] & Q[3];
    assign T[5] = enable & Q[0] & Q[1] & Q[2] & Q[3] & Q[4];
    assign T[6] = enable & Q[0] & Q[1] & Q[2] & Q[3] & Q[4] & Q[5];
    assign T[7] = enable & Q[0] & Q[1] & Q[2] & Q[3] & Q[4] & Q[5] & Q[6];

    Tflip t0 (clk, clear_n, T[0], Q[0]);          // bit 0
    Tflip t1 (clk, clear_n, T[1], Q[1]);          // bit 1
    Tflip t2 (clk, clear_n, T[2], Q[2]);          // bit 2
    Tflip t3 (clk, clear_n, T[3], Q[3]);          // bit 3
    Tflip t4 (clk, clear_n, T[4], Q[4]);          // bit 4
    Tflip t5 (clk, clear_n, T[5], Q[5]);          // bit 5
    Tflip t6 (clk, clear_n, T[6], Q[6]);          // bit 6
    Tflip t7 (clk, clear_n, T[7], Q[7]);          // bit 7

    displayHex u0 (Q[3:0], HEX0);                 // low nibble on HEX0
    displayHex u1 (Q[7:4], HEX1);                 // high nibble on HEX1

endmodule

// Tflip
// Synchronous T flip-flop with synchronous active-LOW clear
module Tflip (
    input  clk,                 // clock (posedge)
    input  clear_n,              // synchronous clear, active-LOW
    input  T,                    // toggle enable
    output reg Q                 // stored bit
);

    // always block
    // Clear happens on clock edge when clear_n=0. Toggle happens when T=1.
    always @(posedge clk) begin
        if (!clear_n)
            Q <= 1'b0;           // sync reset to 0
        else if (T)
            Q <= ~Q;             // toggle
        else
            Q <= Q;              // hold
    end

endmodule

// displayHex
// 4-bit value -> HEX segments (active-LOW), equations derived from truth table
module displayHex (
    input  [3:0] F,              // hex digit 0..F
    output [6:0] HEX             // segments 0..6 (active-LOW)
);

    assign HEX[0] = (~F[3]&~F[2]&~F[1]& F[0]) | (~F[3]& F[2]&~F[1]&~F[0]) | ( F[3]& F[2]&~F[1]& F[0]) | ( F[3]&~F[2]& F[1]& F[0]);
    assign HEX[1] = (~F[3]& F[2]&~F[1]& F[0]) | ( F[3]& F[2]&~F[0])      | ( F[3]& F[1]& F[0])      | ( F[2]& F[1]&~F[0]);
    assign HEX[2] = (~F[3]&~F[2]& F[1]&~F[0]) | ( F[3]& F[2]&~F[0])      | ( F[3]& F[2]& F[1]);
    assign HEX[3] = (~F[3]& F[2]&~F[1]&~F[0]) | ( F[3]&~F[2]& F[1]&~F[0]) | ( F[2]& F[1]& F[0])     | (~F[2]&~F[1]& F[0]);
    assign HEX[4] = (~F[3]& F[0])             | (~F[2]&~F[1]& F[0])      | (~F[3]& F[2]&~F[1]);
    assign HEX[5] = ( F[3]& F[2]&~F[1]& F[0]) | (~F[3]&~F[2]& F[0])      | (~F[3]&~F[2]& F[1])      | (~F[3]& F[1]& F[0]);
    assign HEX[6] = ( F[3]& F[2]&~F[1]&~F[0]) | (~F[3]& F[2]& F[1]& F[0]) | (~F[3]&~F[2]&~F[1]);

endmodule
