module Lab4Part3(CLOCK_50,KEY,HEX0);
    input CLOCK_50;
    input [0:0] KEY;
    output [6:0] HEX0;
    
    wire resetn;
    wire [25:0] Q;        // Large counter output
    wire [3:0] F;         // Small counter output
    wire NE;              // Enable from large counter
    
    assign resetn = KEY[0];
    
    // Large counter - always enabled (E=1), outputs NE when reaching 50M
    nregister u1(1'b1, CLOCK_50, resetn, Q, NE);
    
    // Small counter - enabled by NE pulse
    lilregister u2(NE, CLOCK_50, resetn, F);
    
    // Display
    displayBinary u3(F, HEX0);
    
endmodule

module nregister(E, clk, resetn, Q, NE);
    input E, clk, resetn;
    output reg [25:0] Q;
    output reg NE;
    
    always @(posedge clk or negedge resetn)
    begin
        if (~resetn)
        begin
            Q <= 26'd0;
            NE <= 1'b0;
        end
        else if (E)
        begin
            if (Q == 26'd49999999)  // Reached 50 million
            begin
                Q <= 26'd0;         // Reset counter
                NE <= 1'b1;         // Pulse enable HIGH
            end
            else
            begin
                Q <= Q + 1'b1;      // Keep counting
                NE <= 1'b0;         // Enable stays LOW
            end
        end
    end
endmodule

module lilregister(E, clk, resetn, Q);
    input E, clk, resetn;
    output reg [3:0] Q;
    
    always @(posedge clk or negedge resetn)
    begin
        if (~resetn)
            Q <= 4'd0;
        else if (E)  // Only increment when NE pulses
        begin
            if (Q == 4'd9)
                Q <= 4'd0;
            else
                Q <= Q + 1'b1;
        end
    end
endmodule

module displayBinary(F, HEX);
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
