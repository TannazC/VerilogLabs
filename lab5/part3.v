// Lab 5 - Part 3
// Morse-code transmitter FSM (A–H): dots=0.5s, dashes=1.5s on LEDR0
// Tannaz C.
// 2026-02-17
// MIT License
//
// Objective:
// Press KEY1 to transmit the Morse code for the letter selected by SW2..0.
// SW2..0: 000=A, 001=B, ... , 111=H (first 8 letters).
// LEDR0 is ON for a dot (1 tick = 0.5s) and ON for a dash (3 ticks = 1.5s).
// A 1-tick OFF gap is inserted between symbols.
// KEY0 is a synchronous reset (active-LOW). CLOCK_50 is the only clock used.

module part3 (
    input        CLOCK_50,          // 50 MHz clock
    input  [2:0] SW,                // letter select
    input  [1:0] KEY,               // KEY1=start, KEY0=resetn (active-LOW)
    output [9:0] LEDR               // LEDR0=tx, others debug
);

    wire clk    = CLOCK_50;         // all sequential logic uses CLOCK_50
    wire resetn = KEY[0];           // active-LOW reset

    localparam IDLE   = 3'b000,
               BRANCH = 3'b001,
               DOT    = 3'b010,
               DASH   = 3'b011,
               GAP    = 3'b100,
               LOAD   = 3'b101;

    reg [2:0] y, Y;                 // FSM state

    reg load_sr, load_len;          // parallel-load controls
    reg shift_en, dec_en;           // shift/decrement controls
    reg led_on;                     // transmit LED control
    reg tick_en;                    // enables half-second tick generator

    wire [3:0] pattern;             // packed dots/dashes (MSB-first)
    wire [2:0] length;              // number of symbols in this letter
    wire [3:0] sr_q;                // shift register contents
    wire       b0;                  // current symbol (0=dot, 1=dash) from SR MSB
    wire [2:0] len_q;               // remaining symbols
    wire       done;                // 1 when len_q==0
    wire [25:0] div_q;              // half-second divider count (debug)
    wire       tick;                // 1-cycle pulse every 0.5 seconds

    assign LEDR[0]   = led_on;      // TX output (ON during dot/dash)
    assign LEDR[1]   = b0;          // current symbol bit (debug)
    assign LEDR[2]   = tick;        // 0.5s tick pulse (debug)
    assign LEDR[3]   = done;        // length done flag (debug)
    assign LEDR[6:4] = y;           // state (debug)
    assign LEDR[7]   = shift_en;    // shift enable (debug)
    assign LEDR[8]   = dec_en;      // length dec enable (debug)
    assign LEDR[9]   = tick_en;     // tick enable (debug)

    mux1 u_mux_pat (.s(SW[2:0]), .f(pattern));                                         // letter -> dot/dash pattern
    mux2 u_mux_len (.s(SW[2:0]), .f(length));                                          // letter -> symbol count
    shiftregister u_sr (.clk(clk), .resetn(resetn), .load(load_sr), .shift_en(shift_en),
                        .data_in(pattern), .sym(b0), .q(sr_q));                         // MSB is current symbol
    downcounter u_len (.clk(clk), .resetn(resetn), .load_len(load_len), .dec_en(dec_en),
                       .len_in(length), .q(len_q), .zero(done));                        // remaining symbols
    nregister u_tick (.E(tick_en), .clk(clk), .resetn(resetn), .Q(div_q), .NE(tick));   // 0.5s tick generator

    reg [1:0] tcnt;                // counts ticks during a dash (0..2)
    always @(posedge clk) begin
        if (!resetn) tcnt <= 2'd0;  // reset dash tick counter
        else if (!tick_en) tcnt <= 2'd0; // clear when not timing
        else if (tick) tcnt <= (tcnt == 2'd2) ? 2'd0 : (tcnt + 2'd1); // 3 ticks per dash
    end

    wire key1_level = ~KEY[1];     // KEY1 pressed -> 1 (buttons are active-LOW)
    reg  k1_sync1, k1_sync2;
    always @(posedge clk) begin
        k1_sync1 <= key1_level;    // synchronize KEY1 to CLOCK_50
        k1_sync2 <= k1_sync1;
    end

    reg start_prev;
    always @(posedge clk) begin
        if (!resetn) start_prev <= 1'b0;
        else start_prev <= k1_sync2;
    end

    wire start_pulse = k1_sync2 & ~start_prev; // 1-cycle pulse on KEY1 press

    // morse_fsm
    // FSM sequences: LOAD -> BRANCH -> (DOT/DASH) -> GAP -> shift/dec -> BRANCH ...
    always @(*) begin
        Y = y;
        load_sr  = 1'b0; load_len = 1'b0;
        shift_en = 1'b0; dec_en   = 1'b0;
        led_on   = 1'b0; tick_en  = 1'b0;

        case (y)
            IDLE: begin
                if (start_pulse) Y = LOAD;        // start transmission on KEY1 edge
            end

            LOAD: begin
                load_sr  = 1'b1;                  // load selected letter pattern
                load_len = 1'b1;                  // load selected length
                Y = BRANCH;                       // decide next symbol on next cycle
            end

            BRANCH: begin
                if (done) Y = IDLE;               // finished all symbols
                else if (b0 == 1'b0) Y = DOT;     // dot symbol
                else Y = DASH;                    // dash symbol
            end

            DOT: begin
                led_on  = 1'b1;                   // LED ON during dot
                tick_en = 1'b1;                   // run 0.5s tick
                if (tick) Y = GAP;                // dot lasts 1 tick
            end

            DASH: begin
                led_on  = 1'b1;                   // LED ON during dash
                tick_en = 1'b1;                   // run 0.5s tick
                if (tick && tcnt == 2'd2) Y = GAP; // dash lasts 3 ticks
            end

            GAP: begin
                tick_en = 1'b1;                   // LED OFF by default in GAP
                if (tick) begin
                    shift_en = 1'b1;              // consume current symbol
                    dec_en   = 1'b1;              // decrement remaining count
                    Y = BRANCH;                   // choose next symbol
                end
            end

            default: Y = IDLE;
        endcase
    end

    // state_FFs
    always @(posedge clk) begin
        if (!resetn) y <= IDLE;                   // reset FSM
        else y <= Y;                              // advance state
    end

endmodule

// mux1
// Letter -> packed dot/dash pattern (MSB-first, left-aligned; 0=dot, 1=dash)
module mux1 (
    input  [2:0] s,
    output reg [3:0] f
);
    always @(*) begin
        case (s)
            3'b000: f = 4'b0100; // A: • —
            3'b001: f = 4'b1000; // B: — • • •
            3'b010: f = 4'b1010; // C: — • — •
            3'b011: f = 4'b1000; // D: — • •
            3'b100: f = 4'b0000; // E: •
            3'b101: f = 4'b0010; // F: • • — •
            3'b110: f = 4'b1100; // G: — — •
            3'b111: f = 4'b0000; // H: • • • •
            default: f = 4'b0000;
        endcase
    end
endmodule

// mux2
// Letter -> number of symbols in the Morse sequence
module mux2 (
    input  [2:0] s,
    output reg [2:0] f
);
    always @(*) begin
        case (s)
            3'b000: f = 3'd2; // A
            3'b001: f = 3'd4; // B
            3'b010: f = 3'd4; // C
            3'b011: f = 3'd3; // D
            3'b100: f = 3'd1; // E
            3'b101: f = 3'd4; // F
            3'b110: f = 3'd3; // G
            3'b111: f = 3'd4; // H
            default: f = 3'd0;
        endcase
    end
endmodule

// shiftregister
// Parallel-load then shift left; MSB sr[3] is the current symbol
module shiftregister (
    input        clk,
    input        resetn,
    input        load,
    input        shift_en,
    input  [3:0] data_in,
    output       sym,
    output [3:0] q
);

    reg [3:0] sr;

    assign q   = sr;          // expose contents (debug)
    assign sym = sr[3];       // current symbol is MSB

    always @(posedge clk) begin
        if (!resetn) sr <= 4'b0000;                 // clear on reset
        else if (load) sr <= data_in;               // load new pattern
        else if (shift_en) sr <= {sr[2:0], 1'b0};   // shift toward MSB consumption
    end

endmodule

// downcounter
// Counts remaining symbols; zero=1 when cnt==0
module downcounter (
    input        clk,
    input        resetn,
    input        load_len,
    input        dec_en,
    input  [2:0] len_in,
    output [2:0] q,
    output       zero
);

    reg [2:0] cnt;

    assign q    = cnt;
    assign zero = (cnt == 3'd0);

    always @(posedge clk) begin
        if (!resetn) cnt <= 3'd0;                   // reset length
        else if (load_len) cnt <= len_in;           // load new length
        else if (dec_en && cnt != 3'd0) cnt <= cnt - 3'd1; // decrement per symbol
    end

endmodule

// nregister
// 0.5-second tick generator at 50 MHz: NE pulses for 1 cycle every HALF_SEC counts
module nregister (
    input        E,
    input        clk,
    input        resetn,
    output reg [25:0] Q,
    output reg   NE
);

    localparam HALF_SEC = 26'd25_000_000 - 1;       // 0.5s at 50 MHz

    always @(posedge clk) begin
        if (!resetn) begin
            Q  <= 26'd0;                            // reset divider
            NE <= 1'b0;
        end else if (E) begin
            if (Q == HALF_SEC) begin
                Q  <= 26'd0;                        // restart interval
                NE <= 1'b1;                         // 1-cycle tick
            end else begin
                Q  <= Q + 26'd1;                    // keep counting
                NE <= 1'b0;
            end
        end else begin
            Q  <= 26'd0;                            // disabled -> hold at 0
            NE <= 1'b0;
        end
    end

endmodule
