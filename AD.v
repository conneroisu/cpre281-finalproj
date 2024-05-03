module FA_AD (
    input        we,
    input  [1:0] a,
    output reg   we1, we2,
    output [1:0] sel );

    assign sel = a;

    always @ ( we, a ) begin
        case (a)
            2'b00:   { we1, we2 } = { we,   1'b0 };
            2'b01:   { we1, we2 } = { 1'b0, we   };
            2'b10:   { we1, we2 } = { 1'b0, 1'b0 };
            2'b11:   { we1, we2 } = { 1'b0, 1'b0 };
            default: { we1, we2 } = { 1'bx, 1'bx };
        endcase
    end
endmodule

module GPIO_AD (
    input        we,
    input  [1:0] a,
    output reg   we1, we2,
    output [1:0] sel );

    assign sel = a;

    always @ ( we, a ) begin
        case (a)
            2'b00:   { we1, we2 } = { 1'b0, 1'b0 };
            2'b01:   { we1, we2 } = { 1'b0, 1'b0 };
            2'b10:   { we1, we2 } = { we,   1'b0 };
            2'b11:   { we1, we2 } = { 1'b0, we   };
            default: { we1, we2 } = { 1'bx, 1'bx };
        endcase
    end
endmodule

module SoC_AD (
    input         we,
    input  [31:0] a,
    output reg    wem, we1, we2, // we for dm, fa, gpio respectively
    output reg [1:0]  sel );         // rd sel

    initial begin
        wem = 1'b0;
        we1 = 1'b0;
        we2 = 1'b0;
    end

    always @ ( we, a ) begin
        case (a[11:8])
            4'h9:    begin { wem, we1, we2 } = { 1'b0, 1'b0, we }; sel = 2'b11; end // GPIO
            4'h8:    begin { wem, we1, we2 } = { 1'b0, we, 1'b0 }; sel = 2'b10; end // Factorial Accelerator
            default: begin { wem, we1, we2 } = { we, 1'b0, 1'b0 }; sel = 2'b00; end // Data Memory
        endcase
    end

endmodule
