module Lab3Part3 (SW, LEDR);
    input [9:0] SW;
    output [9:0] LEDR;
    wire D = SW[0];
    wire Qm; //should assign to reg??
    wire Q = LEDR[0];
    //clock is sw 1
    D_latch Master(~SW[1], D, Qm);
    D_latch Slave(SW[1], Qm, Q);
endmodule

module D_latch (Clk, D, Q) ;
    input Clk, D;
    output reg Q;
    always @ (D, Clk)
    if (Clk == 1)
    Q = D; //no else needed
endmodule