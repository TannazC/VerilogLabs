module part2 (SW, LEDR);
    input [1:0] SW;
    output [9:0] LEDR;
    D_latch(SW[1], SW[0], LEDR[0]);
endmodule

module D_latch (Clk, D, Q) ;
    input Clk, D;
    output reg Q;
    always @ (D, Clk)
    if (Clk == 1)
    Q = D; //no else needed
endmodule