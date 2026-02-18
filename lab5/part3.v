// ==================== TOP: part3 (hardware build) ====================
module part3 (SW, CLOCK_50, KEY, LEDR);
    input CLOCK_50;
    input [2:0] SW;
    input [1:0] KEY;
    output [9:0] LEDR;
    wire clk = CLOCK_50;
    wire resetn = KEY[0]; // active-low synchronous reset

    // === State encoding ===
    localparam IDLE=3'b000, BRANCH=3'b001, DOT=3'b010, DASH=3'b011, GAP=3'b100,
    LOAD=3'b101;

    // FSM regs
    reg [2:0] y, Y;

    // control lines
    reg load_sr, load_len;
    reg shift_en, dec_en;
    reg led_on;
    reg tick_en;

    // datapath signals
    wire [3:0] pattern; wire [2:0] length;
    wire [3:0] sr_q; wire b0;
    wire [2:0] len_q; wire done;
    wire [25:0] div_q; wire tick;

    // === LED debug mapping ===
    // [0]=led_on, [1]=b0, [2]=tick, [3]=done, [6:4]=state, [7]=shift_en, [8]=dec_en, [9]=tick_en
    assign LEDR[0] = led_on;
    assign LEDR[1] = b0;
    assign LEDR[2] = tick;
    assign LEDR[3] = done;
    assign LEDR[6:4] = y;
    assign LEDR[7] = shift_en;
    assign LEDR[8] = dec_en;
    assign LEDR[9] = tick_en;

    // ===== Letter selection and datapath =====
    mux1 u_mux_pat (.s(SW[2:0]), .f(pattern));
    mux2 u_mux_len (.s(SW[2:0]), .f(length));
    shiftregister u_sr (.clk(clk), .resetn(resetn),.load(load_sr), .shift_en(shift_en),.data_in(pattern), .sym(b0), .q(sr_q));
    downcounter u_len (.clk(clk), .resetn(resetn),.load_len(load_len), .dec_en(dec_en),.len_in(length), .q(len_q), .zero(done));
    nregister u_tick ( .E(tick_en), .clk(clk), .resetn(resetn), .Q(div_q), .NE(tick) );

    // ===== 3-tick dash counter =====
    reg [1:0] tcnt;
    always @(posedge clk) begin
        if (!resetn) tcnt <= 2'd0;
        else if (!tick_en) tcnt <= 2'd0;
        else if (tick) tcnt <= (tcnt==2'd2) ? 2'd0 : (tcnt + 2'd1);
    end

    // ===== KEY1 synchronizer + edge detect (active when KEY1 is pressed) =====
    wire key1_level_n = ~KEY[1]; // KEY1 pressed -> 1
    reg k1_sync1, k1_sync2;

    always @(posedge clk) begin
        k1_sync1 <= key1_level_n;
        k1_sync2 <= k1_sync1;
    end

    wire start_sync = k1_sync2;
    reg start_prev;

    always @(posedge clk) begin
        if (!resetn) start_prev <= 1'b0;
        else start_prev <= start_sync;
    end

    wire start_pulse = start_sync & ~start_prev;

    // ===== FSM: next-state and outputs ====
    //MORSE CODE STATE FSM
    always @(*) begin
        // defaults
        Y = y;
        load_sr = 1'b0; load_len = 1'b0;
        shift_en = 1'b0; dec_en = 1'b0;
        led_on = 1'b0; tick_en = 1'b0;
        case (y)

        IDLE: begin
            if (start_pulse) Y = LOAD; // loads happen in LOAD only
                end
            LOAD: begin
                load_sr = 1'b1;
                load_len = 1'b1;
                Y = BRANCH; // next cycle, done reflects new length
        end
        
        BRANCH: begin
            if (done) Y = IDLE;
            else if (b0==1'b0) Y = DOT;
            else Y = DASH;
        end

        DOT: begin
            led_on = 1'b1;
            tick_en = 1'b1;
            if (tick) Y = GAP; // 1 tick
        end

        DASH: begin
            led_on = 1'b1;
            tick_en = 1'b1;
            if (tick && tcnt==2'd2) Y = GAP; // 3 ticks
        end

        GAP: begin
            tick_en = 1'b1; // LED off by default
            if (tick) begin
            shift_en = 1'b1; // consume current symbol
            dec_en = 1'b1; // decrement remaining length
            Y = BRANCH;
        end

    end
    default: Y = IDLE;
    endcase
    end

    // state register
    always @(posedge clk) begin
        if (!resetn) y <= IDLE;
        else y <= Y;
    end

endmodule

// ==================== Letter pattern selection (MSB-first, left-aligned)====================
module mux1 (input [2:0] s, output reg [3:0] f);
    always @(*) begin
        case (s)
            3'b000: f = 4'b0100; // A: •—
            3'b001: f = 4'b1000; // B: —•••
            3'b010: f = 4'b1010; // C: —•—•
            3'b011: f = 4'b1000; // D: —••
            3'b100: f = 4'b0000; // E: •
            3'b101: f = 4'b0010; // F: ••—•
            3'b110: f = 4'b1100; // G: ——•
            3'b111: f = 4'b0000; // H: ••••
            default: f = 4'b0000;
        endcase
    end
endmodule

// ==================== Morse length selection ====================
module mux2 (input [2:0] s, output reg [2:0] f);
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
// ==================== 4-bit MSB-first shift register ====================
module shiftregister (
    input clk, input resetn,
    input load, input shift_en,
    input [3:0] data_in,
    output sym, output [3:0] q);

    reg [3:0] sr;
    assign q = sr;
    assign sym = sr[3]; // MSB is current symbol
    always @(posedge clk) begin
        if (!resetn) sr <= 4'b0000;
        else if (load) sr <= data_in;
        else if (shift_en) sr <= {sr[2:0], 1'b0};
    end
endmodule

// ==================== Down counter for remaining symbols ====================
module downcounter (input clk, input resetn,input load_len, input dec_en,input [2:0] len_in,output [2:0] q, output zero);

    reg [2:0] cnt;
    assign q = cnt;
    assign zero = (cnt == 3'd0);
    always @(posedge clk) begin
        if (!resetn) cnt <= 3'd0;
        else if (load_len) cnt <= len_in;
        else if (dec_en && cnt!=3'd0) cnt <= cnt - 3'd1;
    end
endmodule

// ==================== Half-second tick generator (50 MHz hardware)====================
module nregister (input E, input clk, input resetn,output reg [25:0] Q, output reg NE);

    localparam HALF_SEC = 26'd25_000_000 - 1; // 0.5 s at 50 MHz
    always @(posedge clk) begin
        if (!resetn) begin
            Q <= 26'd0; NE <= 1'b0;
            end else if (E) begin
        if (Q == HALF_SEC) begin
            Q <= 26'd0; NE <= 1'b1;
            end else begin
            Q <= Q + 26'd1; NE <= 1'b0;
        end
        
        end else begin
        Q <= 26'd0; NE <= 1'b0;
        end
    end
endmodule