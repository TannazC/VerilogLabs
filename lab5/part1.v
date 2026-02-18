module part1(SW, LEDR, KEY);
    input [1:0] SW; // SW[0]=resetn, SW[1]=w
    input [0:0] KEY; // KEY[0]=clock
    output [9:0] LEDR; // LEDR[9]=z, LEDR[8:0]=state bits
    wire clk, resetn, w, z;
    wire [8:0] y;

    // next-state (1-bit each)
    wire Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7, Y8;

    // input/output wiring
    assign clk = KEY[0];
    assign w = SW[1];
    assign resetn = SW[0];
    assign LEDR[9] = z;
    assign LEDR[8:0] = y[8:0];

    // version two negates boolean expressions 
    // assign y[0] = ~y[0]

    //next-state logic (by inspection, one-hot) // ACTIVE LOW reset
    //if reset = 0, it resets, otherwise if = 1 we're good
    assign Y0 = !resetn; // A only by reset
    assign Y1 = resetn&((~w) & (y[0] | y[5] | y[6] | y[7] | y[8])); // -> B on 0
    assign Y2 = resetn&((~w) & y[1]); // -> C on 0
    assign Y3 = resetn&((~w) & y[2]); // -> D on 0
    assign Y4 = resetn&((~w) & (y[3] | y[4])); // ->/stay E on 0
    assign Y5 = resetn&(( w) & (y[0] | y[1] | y[2] | y[3] | y[4])); // -> F on 1
    assign Y6 = resetn&(( w) & y[5]); // -> G on 1
    assign Y7 = resetn&(( w) & y[6]); // -> H on 1
    assign Y8 = resetn&(( w) & (y[7] | y[8])); // ->/stay I on 1

    // Moore output
    assign z = y[4] | y[8];
    // instantiate 9 FFs (D, clk, resetn, Q)
    DFFs u0 (Y0, clk, resetn, y[0]);
    DFFs u1 (Y1, clk, resetn, y[1]);
    DFFs u2 (Y2, clk, resetn, y[2]);
    DFFs u3 (Y3, clk, resetn, y[3]);
    DFFs u4 (Y4, clk, resetn, y[4]);
    DFFs u5 (Y5, clk, resetn, y[5]);
    DFFs u6 (Y6, clk, resetn, y[6]);
    DFFs u7 (Y7, clk, resetn, y[7]);
    DFFs u8 (Y8, clk, resetn, y[8]);
endmodule

// FF module from other labs used **
module DFFs(D, clock, resetn, Q);
    input D, clock, resetn;
    output reg Q;
    always @(posedge clock)
    Q<= D;
endmodule
