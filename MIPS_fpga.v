module MIPS_fpga(
    input clk, rst, button, [7:0] sw,
    output we_dm, [7:0] LEDSEL, LEDOUT );

    reg [15:0] reg_hex;
    wire clk_sec, clk_5KHz, clk_pb;
    wire [7:0] digit[0:7];
    wire [31:0] pc_current, instr, result, wd_dm, rd3;
    
    clk_gen     clk_gen (clk, rst, clk_sec, clk_5KHz);
    bdebouncer  bd      (clk_5KHz, button, clk_pb);

    MIPS mips           ( clk_pb, rst, sw[4:0], we_dm, pc_current, instr, result, wd_dm, rd3 );

    led_mux     led_mux (clk_5KHz, rst, digit[7], digit[6], digit[5], digit[4], digit[3], digit[2], digit[1], digit[0], LEDSEL, LEDOUT);

    bcd_to_7seg bcd7    (pc_current[15:12], digit[7]);
    bcd_to_7seg bcd6    (pc_current[11:8],  digit[6]);
    bcd_to_7seg bcd5    (pc_current[7:4],   digit[5]);
    bcd_to_7seg bcd4    (pc_current[3:0],   digit[4]);
    bcd_to_7seg bcd3    (reg_hex[15:12],    digit[3]);
    bcd_to_7seg bcd2    (reg_hex[11:8],     digit[2]);
    bcd_to_7seg bcd1    (reg_hex[7:4],      digit[1]);
    bcd_to_7seg bcd0    (reg_hex[3:0],      digit[0]);

    always @ (posedge clk) begin
        case ({sw[7], sw[6], sw[5]})
            3'b000:	reg_hex = rd3[15:0];
            3'b001: reg_hex = rd3[31:16];
            3'b010: reg_hex = instr[15:0];
            3'b011: reg_hex = instr[31:16];
            3'b100: reg_hex = result[15:0];
            3'b101: reg_hex = result[31:16];
            3'b110: reg_hex = wd_dm[15:0];
            3'b111: reg_hex = wd_dm[31:16];
        endcase
    end
endmodule
