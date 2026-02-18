
module lab2part3(SW, LEDR);
    //Initlize I/O 
    input [9:0] SW;
    output [9:0] LEDR;
    wire [3:0] A, B;
    wire [4:0] C; //for cin, in between and cout
    assign C[0] = SW[8];
    assign A = SW[7:4];
    assign B = SW[3:0];

    //wire C1, C2, C3; //in between steps
    FA(A[0],B[0],C[0], LEDR[0], C[1]);
    FA(A[1],B[1],C[1], LEDR[1], C[2]);
    FA(A[2],B[2],C[2], LEDR[2], C[3]);
    FA(A[3],B[3],C[3], LEDR[3], C[4]);
    assign C[4] = LEDR[4]; //c[4] is Cout`
endmodule

//Full adder module 
module FA (a, b, Cin, s, Cout);
    input a,b, Cin;
    output s, Cout;
    assign s = a^b^Cin; //this is the exclusive or symbol i think
    assign Cout = (a&b)|(a&Cin)|(b&Cin);
endmodule