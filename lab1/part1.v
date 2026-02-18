// Lab 1 - Part 1
// Switch to LED Direct Mapping
// Tannaz C.
// 2026-02-17
// MIT License
// DE1-SoC (Cyclone V 5CSEMA5F31C6)

module part1 (
    input  [9:0] SW,     // 10 slide switches
    output [9:0] LEDR    // 10 red LEDs
);

    assign LEDR = SW;    // each LED reflects its corresponding switch

endmodule
