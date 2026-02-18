module Lab4Part2(SW, KEY, HEX0, HEX1, HEX2, HEX3);
    input [1:0] SW;
    input [0:0] KEY;
    output [6:0] HEX0, HEX1, HEX2, HEX3;
    
    wire E, clk, clear;
    wire [15:0] Q;  
    
    assign clk = KEY[0];     
    assign E = SW[1];       
    assign clear = SW[0];   
    
    // 16 bit register repeated in one array -> display on HEX[3:0]
    nregister u0(E, clk, clear, Q); 
    
    // first nibble, read backwards Q3Q2Q1Q0 
    displayHex u1(Q[3:0], HEX0);    
    displayHex u2(Q[7:4], HEX1);     
    displayHex u3(Q[11:8], HEX2);    
    displayHex u4(Q[15:12], HEX3);  
endmodule

module displayHex(F, HEX);
    input [3:0] F;
    output [6:0] HEX;
    
    // covers the AbCdE for hex
    assign HEX[0] = (~F[3]&~F[2]&~F[1]&F[0]) | (~F[3]&F[2]&~F[1]&~F[0]) | (F[3]&F[2]&~F[1]&F[0]) | (F[3]&~F[2]&F[1]&F[0]);
    assign HEX[1] = (~F[3]&F[2]&~F[1]&F[0]) | (F[3]&F[2]&~F[0]) | (F[3]&F[1]&F[0]) | (F[2]&F[1]&~F[0]);
    assign HEX[2] = (~F[3]&~F[2]&F[1]&~F[0]) | (F[3]&F[2]&~F[0]) | (F[3]&F[2]&F[1]);
    assign HEX[3] = (~F[3]&F[2]&~F[1]&~F[0]) | (F[3]&~F[2]&F[1]&~F[0]) | (F[2]&F[1]&F[0]) | (~F[2]&~F[1]&F[0]);
    assign HEX[4] = (~F[3]&F[0]) | (~F[2]&~F[1]&F[0]) | (~F[3]&F[2]&~F[1]);
    assign HEX[5] = (F[3]&F[2]&~F[1]&F[0]) | (~F[3]&~F[2]&F[0]) | (~F[3]&~F[2]&F[1]) | (~F[3]&F[1]&F[0]);
    assign HEX[6] = (F[3]&F[2]&~F[1]&~F[0]) | (~F[3]&F[2]&F[1]&F[0]) | (~F[3]&~F[2]&~F[1]);
endmodule

module nregister(E, clk, clear, Q);
    input E, clk, clear;
    output reg [15:0] Q;  /
    
    always @(posedge clk)
    begin
        if (clear)
            Q <= 16'd0;      
        else if (E)
            Q <= Q + 1'b1; 
    end
endmodule

// module displayhex(Q2,Q1,Q0) // display each intermediate state 


	