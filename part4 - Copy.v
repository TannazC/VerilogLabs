// Part IV — 7-segment decoder: 00->'d', 01->'E', 10->'1', 11->blank
module part4 (
    input  [1:0] SW,     // c1c0 on SW1..0
    output [9:0] LEDR,   // show inputs; others off
    output [6:0] HEX0    // HEX0 segments (active-LOW)
);

    wire c1 = SW[1];
    wire c0 = SW[0];

    // Segment indices: 0 top, 1 tr, 2 br, 3 bottom, 4 bl, 5 tl, 6 middle
    // 'd' -> {1,2,3,4,6}, 'E' -> {0,3,4,5,6}, '1' -> {1,2}, 'blank' -> {}
    assign HEX0[0] = ~(~c1 &  c0);  // only 'E'
    assign HEX0[1] =  c0;           // 'd' and '1'
    assign HEX0[2] =  c0;           // 'd' and '1'
    assign HEX0[3] =  c1;           // 'd' and 'E'
    assign HEX0[4] =  c1;           // 'd' and 'E'
    assign HEX0[5] = ~(~c1 &  c0);  // only 'E'
    assign HEX0[6] =  c1;           // 'd' and 'E'

    // LEDs: mirror inputs on LEDR1..0; others off
    assign LEDR[1:0] = SW;
    assign LEDR[9:2] = 8'b0;

endmodule