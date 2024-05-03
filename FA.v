
// 4-bit top level factorial accelerator
module FA(
    input             clk, rst,
    input             we,
    input      [1:0]  a,
    input      [3:0]  wd,
    output reg [31:0] rd );

    wire        we1, we2, go, go_pulse, go_pulse_cmb, f_done, f_err, done, err, DONT_USE;
    wire [1:0]  sel;
    wire [3:0]  n;
    wire [31:0] nf, result;

    assign go_pulse_cmb = ( wd[0] & we2 );

    FA_AD        ad           ( .we(we), .a(a), .we1(we1), .we2(we2), .sel(sel) );

    dreg_en #(4) in_reg       ( .clk(clk), .rst(1'b0),         .en(we1),    .D(wd),           .Q(n) );
    dreg_en #(1) go_reg       ( .clk(clk), .rst(1'b0),         .en(we2),    .D(wd[0]),        .Q(go) );
    dreg_en #(1) go_pulse_reg ( .clk(clk), .rst(1'b0),         .en(1'b1),   .D(go_pulse_cmb), .Q(go_pulse) );
    sr_reg  #(1) done_reg     ( .clk(clk), .rst(go_pulse_cmb),              .S(f_done),       .Q(done) );
    sr_reg  #(1) err_reg      ( .clk(clk), .rst(go_pulse_cmb),              .S(f_err),        .Q(err) );
    dreg_en      res_reg      ( .clk(clk), .rst(1'b0),         .en(f_done), .D(nf),           .Q(result) );

    fact      fact         ( .clk(clk), .rst(rst),
                             .go(go_pulse),
                             .n(n),
                             .done(f_done), .error(f_err),
                             .nf(nf), .cs(DONT_USE) );
                             
    always @ ( sel, n, go, done, err, result ) begin
        case (sel)
            2'b00:   rd = { 28'b0, n };
            2'b01:   rd = { 31'b0, go };
            2'b10:   rd = { 30'b0, err, done };
            2'b11:   rd = result;
            default: rd = 32'bx;
        endcase
    end

endmodule
