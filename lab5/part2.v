module part2 (SW, KEY, LEDR);
    input [1:0] SW; // SW[0]=resetn, SW[1]=w
    input [0:0] KEY; // KEY[0]=clock
    output [4:0] LEDR; // LEDR[4]=z, LEDR[3:0]=state y

    // inputs
    wire clk = KEY[0];
    wire resetn = SW[0];
    wire w = SW[1];
    // state reg (current) and next state
    reg [3:0] y, Y;

    // state codes for FSM
    localparam A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011,
    E = 4'b0100, F = 4'b0101, G = 4'b0110, H = 4'b0111,
    I = 4'b1000;

    // --- state table ---
    always @(*) begin : state_table
    Y = A; // CRITICAL: Default assignment to prevent latches
    case (y)
        A: if (w) Y = F; else Y = B;
        B: if (w) Y = F; else Y = C;
        C: if (w) Y = F; else Y = D;
        D: if (w) Y = F; else Y = E;
        E: if (w) Y = F; else Y = E;
        F: if (w) Y = G; else Y = B;
        G: if (w) Y = H; else Y = B;
        H: if (w) Y = I; else Y = B;
        I: if (w) Y = I; else Y = B;
    endcase
    end

    // state registers
    always @(posedge clk) begin : state_FFs
        if (!resetn)
        y <= A; // Use parameter for clarity
        else
        y <= Y;
    end
    // Moore output and LEDs
    reg z; // Changed to reg for proper assignment
    always @(*) begin
        z = (y == E) || (y == I); // Use || instead of |
        end
        assign LEDR[4] = z;
        assign LEDR[3:0] = y;
endmodule