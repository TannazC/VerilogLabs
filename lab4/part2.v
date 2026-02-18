// Lab 4 - Part 2
// 16-bit counter using Q <= Q + 1
// Tannaz C.
// 2026-02-17
// MIT License
//
// Objective:
// Implement a 16-bit counter using a single 16-bit register and increment logic.
// When Enable=1, the counter increments on each clock press.
// Clear is synchronous and active-LOW (Clear=0 forces Q=0 on next clock).
// KEY0 is the manual clock, SW1 is Enable, SW0 is Clear.
// HEX3..HEX0 display Q[15:0] in hexadecimal.

module Lab4Part2 (
    input  [1:0] SW,            // SW1=Enable, SW0=Clear (active-LOW, synchronous)
    input  [0:0] KEY,           // KEY0 pushbutton clock (active-LOW on DE1-SoC)
    output [6:0] HEX0, HEX1, HEX2, HEX3
);

    wire enable  = SW[1];        // enable counting when 1
    wire clear_n = SW[0];        // synchronous clear, active-LOW
    wire clk     = ~KEY[0];      // convert active-LOW button to active-HIGH clock

    wire [15:0] Q;               // 16-bit count value

    nregister u0 (enable, clk, clear_n, Q);     // holds and increments count

    displayHex u1 (Q[3:0],   HEX0);             // least-significant nibble
    displayHex u2 (Q[7:4],   HEX1);
    displayHex u3 (Q[11:8],  HEX2);
    displayHex u4 (Q[15:12], HEX3);             // most-significant nibble

endmodule

// nregister
// 16-bit synchronous counter: clear (active-LOW) and enable gate
module nregister (
    input  E,                   // enable
    input  clk,                 // clock (posedge)
    input  clear_n,             // synchronous clear, active-LOW
    output reg [15:0] Q         // counter state
);

    // always block
    // Clear has priority on the clock edge, then optional increment when enabled.
    always @(posedge clk) begin
        if (!clear_n)
            Q <= 16'd0;         // sync reset to 0
        else if (E)
            Q <= Q + 16'd1;     // increment by 1
    end

endmodule

// displayHex
// 4-bit value -> HEX segments (active-LOW), equations derived from truth table
module displayHex (
    input  [3:0] F,
    output [6:0] HEX
);

    assign HEX[0] = (~F[3]&~F[2]&~F[1]&F[0]) | (~F[3]&F[2]&~F[1]&~F[0]) | (F[3]&F[2]&~F[1]&F[0]) | (F[3]&~F[2]&F[1]&F[0]);
    assign HEX[1] = (~F[3]&F[2]&~F[1]&F[0]) | (F[3]&F[2]&~F[0]) | (F[3]&F[1]&F[0]) | (F[2]&F[1]&~F[0]);
    assign HEX[2] = (~F[3]&~F[2]&F[1]&~F[0]) | (F[3]&F[2]&~F[0]) | (F[3]&F[2]&F[1]);
    assign HEX[3] = (~F[3]&F[2]&~F[1]&~F[0]) | (F[3]&~F[2]&F[1]&~F[0]) | (F[2]&F[1]&F[0]) | (~F[2]&~F[1]&F[0]);
    assign HEX[4] = (~F[3]&F[0]) | (~F[2]&~F[1]&F[0]) | (~F[3]&F[2]&~F[1]);
    assign HEX[5] = (F[3]&F[2]&~F[1]&F[0]) | (~F[3]&~F[2]&F[0]) | (~F[3]&~F[2]&F[1]) | (~F[3]&F[1]&F[0]);
    assign HEX[6] = (F[3]&F[2]&~F[1]&~F[0]) | (~F[3]&F[2]&F[1]&F[0]) | (~F[3]&~F[2]&~F[1]);

endmodule
