module lab2part4 (SW, LEDR, HEX1, HEX0, HEX5, HEX3);
    //init I/O
    input [8:0] SW;
    output [6:0] HEX1, HEX0, HEX5, HEX3;
    output [8:0] LEDR;
    wire [3:0] X, Y;
    wire [4:0] S;
    assign X = SW[7:4]; //assume X and Y have to be <= 9
    assign Y = SW[3:0];
    wire Cin = SW[8];
    displayNum Ux(X, HEX5); //print seperate before adding
    displayNum UY(Y, HEX3);

    wire C1, C2, C3, Cout; //for connecting the ripple adder
    //Add X and Y
    FA R1(X[0],Y[0],Cin, S[0], C1);
    FA R2(X[1],Y[1],C1, S[1], C2);
    FA R3(X[2],Y[2],C2, S[2], C3);
    FA R4(X[3],Y[3],C3, S[3], Cout);
    assign S[4] = Cout;
    //S now carries the result of the addition
    assign LEDR [4:0] = S; //result of addition

    wire z = S[4] | (S[3]& (S[2]|S[1])); //checks if sum is >9

    //for Hex1 determine if 0 or 1
    assign HEX1[0] = z;
    assign HEX1[1] = 0; //always on because for zero and 1
    assign HEX1[2] = 0; //turn on for 1

    assign HEX1[3] = z;
    assign HEX1[4] = z;
    assign HEX1[5] = z;
    assign HEX1[6] = 1; //make 1 so doesn't turn on

    wire [4:0] A, F;
    assign A[4] = 0;
    assign A[3] = S[4]&~S[3]&~S[2]&S[1];
    assign A[2] = (S[4]&~S[1])|(S[3]&S[2]&S[1]);
    assign A[1] = ~S[1];
    assign A[0] = S[0];

    //changes the values of the input to seg 7 based on if z = 1, 0
    assign F[0] = (~z&S[0])|(z&A[0]);
    assign F[1] = (~z&S[1])|(z&A[1]);
    assign F[2] = (~z&S[2])|(z&A[2]);
    assign F[3] = (~z&S[3])|(z&A[3]);
    assign F[4] = (~z&S[4])|(z&A[4]);

    displayNum U5(F, HEX0);
endmodule

//convert binary to decimal display
module displayNum (F, HEX);
    input [3:0] F;
    output [6:0] HEX;
    assign HEX[0] = (~F[3]&~F[2]&~F[1]&F[0])|(~F[3]&F[2]&~F[1]&~F[0]);
    assign HEX[1] = (F[2]&~F[1]&F[0])|(F[2]&F[1]&~F[0]);
    assign HEX[2] = (~F[3]&~F[2]&F[1]&~F[0]);
    assign HEX[3] = (~F[2]&~F[1]&F[0])|(F[2]&~F[1]&~F[0])|(F[2]&F[1]&F[0]);
    assign HEX[4] = (F[0])|(F[2]&~F[1]);
    assign HEX[5] = (F[1]&F[0])|(~F[2]&F[1]&~F[0])|(~F[3]&~F[2]&F[0]);
    assign HEX[6] = (~F[3]&~F[2]&~F[1])|(F[2]&F[1]&F[0]);
endmodule

module FA (a, b, Cin, s, Cout); //full adder
    input a,b, Cin;
    output s, Cout;
    assign s = a^b^Cin; //this is the excllusive or symbol i think
    assign Cout = (a&b)|(a&Cin)|(b&Cin);
endmodule