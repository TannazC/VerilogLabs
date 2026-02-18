// Lab 4 - Part 4
// Ticker tape: scroll "dE1" right-to-left across HEX5..HEX0 (~1 Hz)
// Tannaz C.
// 2026-02-17
// MIT License
//
// Objective:
// Display the word dE1 on HEX5..HEX0 and shift it left every ~1 second.
// CLOCK_50 is the only clock used for all flip-flops.
// KEY0 is a synchronous reset (active-LOW) for both counters.
// A large counter generates a 1-cycle enable pulse (NE) about once per second.
// A small ticker counter steps through the 6 display states.

module Lab4Part4 (
    input        CLOCK_50,       // 50 MHz clock
    input  [0:0] KEY,            // KEY0 reset (active-LOW)
    output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0  // active-LOW 7-seg
);

    wire resetn = KEY[0];         // resetn=0 resets state
    wire NE;                      // 1-cycle enable pulse (~1 Hz)
    wire [2:0] pos;               // ticker position 0..5

    nregister      u1 (1'b1, CLOCK_50, resetn, NE);           // generate NE pulse
    tickerCounter  u2 (NE,  CLOCK_50, resetn, pos);           // advance position
    tickerDisplay  u3 (pos, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0); // drive HEX outputs

endmodule

// nregister
// Large counter: emits 1-cycle NE pulse every ~50,000,000 CLOCK_50 cycles
module nregister (
    input  E,                     // enable (kept 1)
    input  clk,                   // CLOCK_50
    input  resetn,                // active-LOW reset
    output reg NE                 // 1-cycle pulse
);

    reg [25:0] Q;                 // 26-bit counter for 0..49,999,999

    always @(posedge clk) begin
        if (!resetn) begin
            Q  <= 26'd0;          // reset large counter
            NE <= 1'b0;           // no pulse on reset
        end else if (E) begin
            if (Q == 26'd49999999) begin
                Q  <= 26'd0;      // restart interval
                NE <= 1'b1;       // pulse HIGH for one cycle
            end else begin
                Q  <= Q + 26'd1;  // keep counting
                NE <= 1'b0;       // pulse LOW otherwise
            end
        end else begin
            NE <= 1'b0;           // disabled -> no pulse
        end
    end

endmodule

// tickerCounter
// Steps through 6 states (0..5), advancing only when NE pulses
module tickerCounter (
    input  E,                     // enable pulse
    input  clk,                   // CLOCK_50
    input  resetn,                // active-LOW reset
    output reg [2:0] Q            // position/state
);

    always @(posedge clk) begin
        if (!resetn)
            Q <= 3'd0;            // start at state 0
        else if (E) begin
            if (Q == 3'd5)
                Q <= 3'd0;        // wrap after 5
            else
                Q <= Q + 3'd1;    // next state
        end
    end

endmodule

// tickerDisplay
// Maps ticker state to HEX5..HEX0 segment patterns for scrolling "dE1"
module tickerDisplay (
    input  [2:0] Q,               // ticker state 0..5
    output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0
);

    wire [6:0] BLANK  = 7'b1111111; // all segments OFF (active-LOW)
    wire [6:0] CHAR_d = 7'b0100001; // pattern for 'd'
    wire [6:0] CHAR_E = 7'b0000110; // pattern for 'E'
    wire [6:0] CHAR_1 = 7'b1111001; // pattern for '1'

    assign HEX5 = (Q == 3'd3) ? CHAR_d :
                  (Q == 3'd4) ? CHAR_E :
                  (Q == 3'd5) ? CHAR_1 : BLANK;   // d,E,1 enter from right

    assign HEX4 = (Q == 3'd2) ? CHAR_d :
                  (Q == 3'd3) ? CHAR_E :
                  (Q == 3'd4) ? CHAR_1 : BLANK;   // shift left

    assign HEX3 = (Q == 3'd1) ? CHAR_d :
                  (Q == 3'd2) ? CHAR_E :
                  (Q == 3'd3) ? CHAR_1 : BLANK;   // shift left

    assign HEX2 = (Q == 3'd0) ? CHAR_d :
                  (Q == 3'd1) ? CHAR_E :
                  (Q == 3'd2) ? CHAR_1 : BLANK;   // centered

    assign HEX1 = (Q == 3'd0) ? CHAR_E :
                  (Q == 3'd1) ? CHAR_1 :
                  (Q == 3'd5) ? CHAR_d : BLANK;   // wrap-around positions

    assign HEX0 = (Q == 3'd0) ? CHAR_1 :
                  (Q == 3'd4) ? CHAR_d :
                  (Q == 3'd5) ? CHAR_E : BLANK;   // exiting on the left

endmodule
