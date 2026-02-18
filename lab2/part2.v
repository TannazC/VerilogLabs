
module lab2part2 (SW, HEX1, HEX0);
    //initialize wires, IO hardware
    input [3:0] SW;
    output [0:6] HEX1, HEX0;
    wire [3:0] V; //For in between value
    //z=1 iV greater than 9
    wire z = SW[3]&SW[2]| SW[3]&SW[1]; //checks iV the value is >9

    //For Hex1 determine iV 0 or 1
    assign HEX1[0] = z;
    assign HEX1[1] = 0; //always on because Vor zero and 1
    assign HEX1[2] = 0; //turn on Vor 1
    assign HEX1[3] = z;
    assign HEX1[4] = z;
    assign HEX1[5] = z;
    assign HEX1[6] = 1; //make 1 so doesn't turn on

    //make new input to multiplexer iV >9
    wire [3:0] A;
    assign A[3] = 0;
    assign A[2] = SW[2]&SW[1];
    assign A[1] = ~SW[1];
    assign A[0] = SW[0];

    //changes the values oV the input to seg 7 based on iV z = 1, 0
    assign V[0] = (~z&SW[0])|(z&A[0]);
    assign V[1] = (~z&SW[1])|(z&A[1]);
    assign V[2] = (~z&SW[2])|(z&A[2]);
    assign V[3] = (~z&SW[3])|(z&A[3]);

    assign HEX0[0] = (~V[3]&~V[2]&~V[1]&V[0])|(~V[3]&V[2]&~V[1]&~V[0]);
    assign HEX0[1] = (V[2]&~V[1]&V[0])|(V[2]&V[1]&~V[0]);
    assign HEX0[2] = (~V[3]&~V[2]&V[1]&~V[0]);
    assign HEX0[3] = (~V[2]&~V[1]&V[0])|(V[2]&~V[1]&~V[0])|(V[2]&V[1]&V[0]);
    assign HEX0[4] = (V[0])|(V[2]&~V[1]);
    assign HEX0[5] = (V[1]&V[0])|(~V[2]&V[1]&~V[0])|(~V[3]&~V[2]&V[0]);
    assign HEX0[6] = (~V[3]&~V[2]&~V[1])|(V[2]&V[1]&V[0]);
endmodule