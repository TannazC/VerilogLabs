// Lab 1 - Part 4
// 7-seg decoder (SW1..0 selects: d, E, 1, blank)
// Tannaz C.
// 2026-02-17
// MIT License
// DE1-SoC (Cyclone V 5CSEMA5F31C6)
//
// Objective:
// Build a 2-bit (c1c0) 7-segment decoder using only assign statements.
// SW1..0 provide the code, and HEX0 displays:
//   00 -> 'd'
//   01 -> 'E'
//   10 -> '1'
//   11 -> blank
// HEX0 is active-LOW (0 turns a segment ON).

module part4 (
    input  [1:0] SW,        // c1c0 on SW1..0
    output [9:0] LEDR,      // mirror inputs; others off
    output [6:0] HEX0       // HEX0 segments (active-LOW)
);

    wire c1 = SW[1];         // select bit 1
    wire c0 = SW[0];         // select bit 0

    // Segment indices: 0 top, 1 top-right, 2 bottom-right, 3 bottom,
    //                  4 bottom-left, 5 top-left, 6 middle
    // 'd' -> segments {1,2,3,4,6} ON
    // 'E' -> segments {0,3,4,5,6} ON
    // '1' -> segments {1,2} ON
    // blank -> none ON

    assign HEX0[0] = ~(~c1 &  c0);  // ON only for 01 ('E')
    assign HEX0[1] =  c0;           // ON for 00 ('d') and 10 ('1')
    assign HEX0[2] =  c0;           // ON for 00 ('d') and 10 ('1')
    assign HEX0[3] =  c1;           // ON for 00 ('d') and 01 ('E')
    assign HEX0[4] =  c1;           // ON for 00 ('d') and 01 ('E')
    assign HEX0[5] = ~(~c1 &  c0);  // ON only for 01 ('E')
    assign HEX0[6] =  c1;           // ON for 00 ('d') and 01 ('E')

    assign LEDR[1:0] = SW;          // show c1c0 on LEDR1..0
    assign LEDR[9:2] = 8'b0;        // unused LEDs off

endmodule
