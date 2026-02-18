// Lab 4 - Part 3
// Digit flipper: show 0..9 on HEX0, ~1 second per digit (50 MHz clock)
// Tannaz C.
// 2026-02-17
// MIT License
//
// Objective:
// Use CLOCK_50 (50 MHz) to advance a decimal digit 0..9 on HEX0 about once per second.
// A large counter generates a 1-cycle enable pulse (NE) every ~50,000,000 cycles.
// A small modulo-10 counter increments only when NE pulses.
// KEY0 is a synchronous reset for both counters (active-LOW on DE1-SoC).
// 7-seg equations are derived from the digit truth table (0–9 only).

module part3 (
    input  [0:0] KEY,          // KEY0 reset (active-LOW)
    input        CLOCK_50,      // 50 MHz clock
    output [6:0] HEX0           // active-LOW 7-seg
);

    wire resetn = KEY[0];       // resetn=0 resets state
    wire NE;                    // 1-cycle enable pulse (~1 Hz)
    wire [3:0] digit;           // 0..9 counter

    nregister  u1 (1'b1, CLOCK_50, resetn, NE);   // generates NE pulse every ~1 s
    lilregister u2 (NE,  CLOCK_50, resetn, digit); // increments digit on each NE

    displayBinary u3 (digit, HEX0);               // show digit on HEX0

endmodule

// nregister
// Large counter: counts 0..49,999,999 then emits a 1-cycle pulse NE and resets
module nregister (
    input  E,                   // enable (kept 1 in this lab)
    input  clk,                 // CLOCK_50
    input  resetn,              // active-LOW reset
    output reg NE               // 1-cycle enable pulse
);

    reg [25:0] Q;               // needs 26 bits to count up to 49,999,999

    // always block
    // Using only CLOCK_50 for all flip-flops (no derived clocks).
    always @(posedge clk) begin
        if (!resetn) begin
            Q  <= 26'd0;        // reset large counter
            NE <= 1'b0;         // no pulse on reset
        end else if (E) begin
            if (Q == 26'd49999999) begin
                Q  <= 26'd0;    // restart 1-second interval
                NE <= 1'b1;     // pulse HIGH for this one clock cycle
            end else begin
                Q  <= Q + 26'd1;// keep counting
                NE <= 1'b0;     // pulse stays LOW otherwise
            end
        end else begin
            NE <= 1'b0;         // if disabled, do not pulse
        end
    end

endmodule

// lilregister
// Small counter: modulo-10 (0..9), increments only when NE=1
module lilregister (
    input  E,                   // enable pulse (NE)
    input  clk,                 // CLOCK_50
    input  resetn,              // active-LOW reset
    output reg [3:0] Q          // digit value
);

    // always block
    // Updates only on CLOCK_50, gated by enable pulse.
    always @(posedge clk) begin
        if (!resetn)
            Q <= 4'd0;          // reset digit to 0
        else if (E) begin
            if (Q == 4'd9)
                Q <= 4'd0;      // wrap 9 -> 0
            else
                Q <= Q + 4'd1;  // next digit
        end
    end

endmodule

// displayBinary
// 4-bit value (0..9) -> HEX segments (active-LOW), equations from truth table
module displayBinary (
    input  [3:0] F,             // digit
    output [6:0] HEX            // segments
);

    assign HEX[0] = (~F[3]&~F[2]&~F[1]&F[0]) | (~F[3]&F[2]&~F[1]&~F[0]);
    assign HEX[1] = (F[2]&~F[1]&F[0]) | (F[2]&F[1]&~F[0]);
    assign HEX[2] = (~F[3]&~F[2]&F[1]&~F[0]);
    assign HEX[3] = (~F[2]&~F[1]&F[0]) | (F[2]&~F[1]&~F[0]) | (F[2]&F[1]&F[0]);
    assign HEX[4] = (F[0]) | (F[2]&~F[1]);
    assign HEX[5] = (F[1]&F[0]) | (~F[2]&F[1]&~F[0]) | (~F[3]&~F[2]&F[0]);
    assign HEX[6] = (~F[3]&~F[2]&~F[1]) | (F[2]&F[1]&F[0]);

endmodule
