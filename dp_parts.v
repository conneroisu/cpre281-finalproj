
// 2 to 1 MUX
module mux2 #(parameter WIDTH=32) (
    input sel,
    input [WIDTH-1:0] a, b,
    output [WIDTH-1:0] y );

    assign y = (sel) ? b : a;

endmodule

// 4 to 1 MUX
module mux4 #(parameter WIDTH=32) (
    input [1:0] sel,
    input [WIDTH-1:0] a, b, c, d,
    output reg [WIDTH-1:0] y );

    always @ (*) begin
        case (sel)
            2'b00: y = a;
            2'b01: y = b;
            2'b10: y = c;
            2'b11: y = d;
        endcase
    end
endmodule

module signext
(input [15:0] a, output [31:0] y);
    assign y = {{16{a[15]}}, a};
endmodule

module adder (
    input [31:0] a, b,
    output [31:0] y );

    assign y = a + b;

endmodule

module alu (
    input [2:0] op,
    input [31:0] a, b,
    output zero,
    output reg [31:0] y );

    assign zero = (y == 0);

    always @ (op, a, b) begin
        case (op)
            3'b000: y = a & b;
            3'b001: y = a | b;
            3'b010: y = a + b;
            3'b100: y = b << a;
            3'b101: y = b >> a;
            3'b110: y = a - b;
            3'b111: y = (a < b) ? 1 : 0;
        endcase
    end
endmodule

module mul (
    input [31:0] a, b,
    output [31:0] hi, lo );

    assign { hi, lo } = a * b;

endmodule

module dreg (
    input clk, rst,
    input [31:0] D,
    output reg [31:0] Q );

    initial Q = 0;

    always @ (posedge clk, posedge rst) begin
        if (rst) Q <= 0;
        else     Q <= D;
    end
endmodule

module dreg_en #(parameter WIDTH=32) (
    input clk, rst, en,
    input [WIDTH-1:0] D,
    output reg [WIDTH-1:0] Q );
    initial Q = 0;
    always @ (posedge clk, posedge rst) begin
        if (rst)     Q <= 0;
        else if (en) Q <= D;
        else         Q <= Q;
    end
endmodule

module sr_reg #(parameter WIDTH=32) (
    input clk, rst,
    input [WIDTH-1:0] S,
    output reg [WIDTH-1:0] Q );
    initial Q <= 0;
    always @ ( posedge clk, posedge rst ) begin
        if      (rst) Q <= 0;
        else if (S)   Q <= S;
    end
endmodule

module regfile (
    input clk, we,
    input [4:0] ra1, ra2, ra3, wa,
    input [31:0] wd,
    output [31:0] rd1, rd2, rd3 );

    reg [31:0] rf [0:31];
    integer i;

    initial
        for (i = 0; i < 32; i = i + 1) rf[i] = 32'h0;

    always @ (posedge clk)
        if (we) rf[wa] <= wd;

    assign rd1 = (ra1 == 0) ? 0 : rf[ra1];
    assign rd2 = (ra2 == 0) ? 0 : rf[ra2];
    assign rd3 = (ra3 == 0) ? 0 : rf[ra3];

endmodule

module counter #(WIDTH=4)(
    input  wire rst, clk, load, en,
    input  wire [WIDTH-1:0] D,
    output reg [WIDTH-1:0] Q );
    initial Q = 0;
    always @(posedge clk, posedge rst) begin
        if (rst)              Q <= 0;
        else if (load && en)  Q <= D;
        else if (!load && en) Q <= Q - 1;
    end

endmodule

module comparator #(WIDTH=16)(
    input  wire [WIDTH-1:0] a, b,
    output reg gt );

    always @(a, b) begin
        if (a == b) gt <= 1'b0;
        else        gt <= (a > b);
    end
endmodule
