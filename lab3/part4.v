module part4 (Clk, D, Qa, Qb, Qc);
    input Clk, D;
    output Qa, Qb, Qc;
    D_latch U1(Clk, D, Qa);
    upFlip U2(Clk, D, Qb);
    upFlip U3(~Clk, D, Qc);
endmodule

module upFlip (Clk, D, Q);
    input Clk, D;
    output reg Q;
    always @ (posedge Clk)
    Q <= D;
endmodule

//module dwnFlip (Clk, D, Q);
    // input Clk, D;
    // output reg Q;
    //
    // always @ (negedge Clk)
    // Q <= D;
    //
//endmodule

module D_latch (Clk, D, Q) ;
    input Clk, D;
    output reg Q;
    always @ (D, Clk)
    if (Clk == 1)
    Q = D; //no else needed
endmodule