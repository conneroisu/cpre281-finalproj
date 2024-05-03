

module fact #(parameter IN_WIDTH=4, OUT_WIDTH=32) (
    input  wire clk, rst, go,
    input  wire [IN_WIDTH-1:0] n,
    output wire done, error,
    output wire [OUT_WIDTH-1:0] nf,
    output wire cs );

    wire load_cnt, en_cnt, load_reg, sel, gt, err;

    fact_DP dp ( .clk(clk), .rst(rst),
                 .n(n),
                 .load_cnt(load_cnt), .en_cnt(en_cnt), .load_reg(load_reg), .sel(sel), .OE(done), .err(err),
                 .gt(gt),
                 .out(nf) );

    fact_CU cu ( .clk(clk), .rst(rst),
                 .go(go), .gt(gt), .err(err),
                 .load_cnt(load_cnt), .en_cnt(en_cnt), .load_reg(load_reg), .sel(sel), .OE(done), .error(error),
                 .cs(cs) );

endmodule

module fact_CU (
    input  wire clk, rst, go, gt, err,
    output wire load_cnt, en_cnt, load_reg, sel, OE, error,
    output reg  cs );

    parameter S0 = 1'b0,
              S1 = 1'b1;

    parameter IDLE = 6'b000000,
              LOAD = 6'b111100,
              WAIT = 6'b000000,
              DEC  = 6'b011000,
              DONE = 6'b000010,
              ERR  = 6'b000001;

    reg ns;
    reg [5:0] ctrl;

    assign { load_cnt, en_cnt, load_reg, sel, OE, error } = ctrl;

    always @(posedge clk, posedge rst) begin
        if (rst) cs <= S0;
        else     cs <= ns;
    end

    always @(go, err, cs, gt) begin
        case (cs)
            S0: begin
                if (err)     begin ctrl = ERR;  ns = S0; end
                else if (go) begin ctrl = LOAD; ns = S1; end
                else         begin ctrl = IDLE; ns = S0; end
            end

            S1: begin
                ctrl = WAIT;
                if (gt) begin  ctrl = DEC;  ns = S1; end
                else    begin  ctrl = DONE; ns = S0; end
            end
        endcase
    end
endmodule

module fact_DP #(parameter IN_WIDTH=4, OUT_WIDTH=32) (
    input  wire clk, rst,
    input  wire [IN_WIDTH-1:0] n,
    input  wire load_cnt, en_cnt, load_reg, sel, OE,
    output wire gt, err,
    output wire [OUT_WIDTH-1:0] out );

    wire [OUT_WIDTH-1:0] gnd = 0;
    wire [OUT_WIDTH-1:0] vcc = 1;

    wire [IN_WIDTH-1:0]  cnt_out;
    wire [OUT_WIDTH-1:0] reg_in, reg_out, mul_out;

    assign err = (n > 4'b1100) ? 1'b1 : 1'b0;

    wire [31:0] DONT_USE;

    mux2       #(OUT_WIDTH) MUX1 ( .sel(sel), .a(mul_out), .b(vcc), .y(reg_in) );

    counter    #(IN_WIDTH)  CNT  ( .rst(rst), .clk(clk), .load(load_cnt), .en(en_cnt), .D(n), .Q(cnt_out) );
    comparator #(IN_WIDTH)  CMP  ( .a(cnt_out), .b(vcc[IN_WIDTH-1:0]), .gt(gt) );

    dreg_en    #(OUT_WIDTH) REG  ( .clk(clk), .rst(rst), .en(load_reg), .D(reg_in), .Q(reg_out) );
    mul                     MUL  ( .a({28'b0, cnt_out}), .b(reg_out), .hi(DONT_USE), .lo(mul_out) );

    mux2       #(OUT_WIDTH) MUX2 ( .sel(OE), .a(gnd), .b(reg_out), .y(out) );

endmodule
