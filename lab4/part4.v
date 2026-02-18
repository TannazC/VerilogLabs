
module Lab4Part4(CLOCK_50, KEY, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
    input CLOCK_50;
    input [0:0] KEY;
    output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
    
    wire resetn;
    wire [25:0] Q_large;
    wire [2:0] Q;
    wire NE;  // Enable pulse from large counter
    
    assign resetn = KEY[0];
    
    // Large counter - always enabled, outputs NE pulse
    nregister u1(1'b1, CLOCK_50, resetn, Q_large, NE);
    
    // Ticker counter - enabled by NE pulse
    tickerCounter u2(NE, CLOCK_50, resetn, Q);
    
    // Display
    tickerDisplay u3(Q, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
    
endmodule

module tickerCounter(E, clk, resetn, Q);
    input E, clk, resetn;
    output reg [2:0] Q;
    
    always @(posedge clk or negedge resetn)
    begin
        if (~resetn)
            Q <= 3'd0;
        else if (E)
        begin
            if (Q == 3'd5)
                Q <= 3'd0;
            else
                Q <= Q + 1'b1;
        end
    end
endmodule

module tickerDisplay(Q, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
    input [2:0] Q;
    output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
    
    // Character patterns
    wire [6:0] BLANK = 7'b1111111;
    wire [6:0] CHAR_d = 7'b0100001;
    wire [6:0] CHAR_E = 7'b0000110;
    wire [6:0] CHAR_1 = 7'b1111001;
    
    // Efficient assign statements using ternary operators
    // HEX5: blank(0,1,2), d(3), E(4), 1(5)
    assign HEX5 = (Q == 3'd3) ? CHAR_d :
                  (Q == 3'd4) ? CHAR_E :
                  (Q == 3'd5) ? CHAR_1 : BLANK;
    
    // HEX4: blank(0,1,5), d(2), E(3), 1(4)
    assign HEX4 = (Q == 3'd2) ? CHAR_d :
                  (Q == 3'd3) ? CHAR_E :
                  (Q == 3'd4) ? CHAR_1 : BLANK;
    
    // HEX3: blank(0,4,5), d(1), E(2), 1(3)
    assign HEX3 = (Q == 3'd1) ? CHAR_d :
                  (Q == 3'd2) ? CHAR_E :
                  (Q == 3'd3) ? CHAR_1 : BLANK;
    
    // HEX2: d(0), E(1), 1(2), blank(3,4,5)
    assign HEX2 = (Q == 3'd0) ? CHAR_d :
                  (Q == 3'd1) ? CHAR_E :
                  (Q == 3'd2) ? CHAR_1 : BLANK;
    
    // HEX1: E(0), 1(1), blank(2,3,4), d(5)
    assign HEX1 = (Q == 3'd0) ? CHAR_E :
                  (Q == 3'd1) ? CHAR_1 :
                  (Q == 3'd5) ? CHAR_d : BLANK;
    
    // HEX0: 1(0), blank(1,2,3), d(4), E(5)
    assign HEX0 = (Q == 3'd0) ? CHAR_1 :
                  (Q == 3'd4) ? CHAR_d :
                  (Q == 3'd5) ? CHAR_E : BLANK;
    
endmodule
