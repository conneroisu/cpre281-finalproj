
module SoC(
    input         clk, rst,
    input  [4:0]  ra3,
    input  [31:0] gpi1, gpi2,
    output [31:0] rd3, gpo1, gpo2 );

    wire        wem, we1, we2;
    wire [1:0]  sel;
    wire [31:0] fact_rd, gpio_rd;
    reg  [31:0] rd_soc;

    // expose data memory i/o for SoC
    wire        we_dm;
    wire [31:0] address, rd_dm, wd_dm;
    wire [31:0] DONT_USE[0:2];

    SoC_AD   ad   ( .we(we_dm), .a(address), .wem(wem), .we1(we1), .we2(we2), .sel(sel) );

    MIPS     mips ( .clk(clk), .rst(rst),
                    .ra3(ra3),
                    .pc_current(DONT_USE[0]), .instr(DONT_USE[1]), .result(DONT_USE[2]), .rd3(rd3),
                    .wem(wem), .rd_soc(rd_soc), .we_dm(we_dm), .address(address), .rd_dm(rd_dm), .wd_dm(wd_dm) );

    FA       fa   ( .clk(clk), .rst(rst),
                    .we(we1), .a(address[3:2]), .wd(wd_dm[3:0]),
                    .rd(fact_rd) );

    GPIO     gpio ( .clk(clk), .rst(rst),
                    .we(we2), .a(address[3:2]), .wd(wd_dm), .gpi1(gpi1), .gpi2(gpi2),
                    .gpo1(gpo1), .gpo2(gpo2), .rd(gpio_rd) );

    always @ ( * ) begin
        case (sel)
            2'b00:   rd_soc = rd_dm;
            2'b01:   rd_soc = rd_dm;
            2'b10:   rd_soc = fact_rd;
            2'b11:   rd_soc = gpio_rd;
            default: rd_soc = 32'bx;
        endcase
    end
endmodule
