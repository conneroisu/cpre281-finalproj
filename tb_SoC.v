`timescale 1ns / 1ps

module tb_SoC;
    reg         clk, rst;
    reg  [4:0]  ra3;
    reg  [31:0] gpi1, gpi2;
    wire [31:0] rd3, gpo1, gpo2;

    SoC DUT ( clk, rst, ra3, gpi1, gpi2, rd3, gpo1, gpo2 );

    reg       sel;
    reg [3:0] n;

    wire [31:0] pc_current = DUT.mips.pc_current;
    wire [31:0] instr      = DUT.mips.instr;

    //wire        we_dm    = DUT.mips.cu.we_dm;
    //wire        wem      = DUT.ad.wem;
    //wire        we1      = DUT.ad.we1;
    //wire        we2      = DUT.ad.we2;
    //wire [1:0]  rd_sel   = DUT.ad.sel;
    //wire [31:0] address  = DUT.ad.a;

    wire [31:0] wd       = DUT.mips.wd_dm;
    wire [31:0] rd_soc   = DUT.mips.rd_soc;

    //wire [1:0]  fa_a      = DUT.fa.a;
    //wire [1:0]  fa_we1    = DUT.fa.ad.we1;
    //wire [1:0]  fa_we2    = DUT.fa.ad.we2;
    wire [3:0]  fa_n      = DUT.fa.in_reg.Q;
    //wire        fact_cs   = DUT.fa.fact.cs;
    wire        fact_go   = DUT.fa.fact.go;
    wire        fact_done = DUT.fa.fact.done;

    wire        fa_go_pul = DUT.fa.go_pulse_reg.D;
    wire        fa_go     = DUT.fa.go_reg.Q;
    wire        fa_done   = DUT.fa.done_reg.Q;
    wire [31:0] fa_res    = DUT.fa.res_reg.Q;

    wire [31:0] rf_00    = DUT.mips.dp.rf.rf[0];
    wire [31:0] rf_t0    = DUT.mips.dp.rf.rf[8];
    wire [31:0] rf_t1    = DUT.mips.dp.rf.rf[9];
    wire [31:0] rf_t2    = DUT.mips.dp.rf.rf[10];
    wire [31:0] rf_t3    = DUT.mips.dp.rf.rf[11];
    wire [31:0] rf_t4    = DUT.mips.dp.rf.rf[12];
    wire [31:0] rf_t5    = DUT.mips.dp.rf.rf[13];

    integer i;

    task TICK;  begin #5 clk = 1; #5 clk = 0; end endtask
    task RESET; begin #5 rst = 1; #5 rst = 0; end endtask

    initial begin
        RESET;

        for (i = 0; i <= 12; i = i + 1) begin
            sel = 1'b1; n = i[3:0];
            gpi1 = { 27'b0, sel, n };

            while(pc_current != 32'h40) TICK;

            TICK;
        end

        $finish;
    end
endmodule
