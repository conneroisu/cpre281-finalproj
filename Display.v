module Display (
    input clk,
    input reset,
    input [6:0] seg_first_1,
    input [6:0] seg_first_2,
    input [6:0] seg_second_1,
    input [6:0] seg_second_2,
    input [6:0] seg_third_1,
    input [6:0] seg_third_2,
    input [6:0] seg_fourth_1,
    input [6:0] seg_fourth_2,
    input [6:0] seg_fifth_1,
    input [6:0] seg_fifth_2,
    output reg [6:0] display_out_1,
    output reg [6:0] display_out_2,
    output reg [6:0] display_out_3,
    output reg [6:0] display_out_4,
    output reg [6:0] display_out_5
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        display_out_1 <= 7'b1111111; // Reset to blank
        display_out_2 <= 7'b1111111;
        display_out_3 <= 7'b1111111;
        display_out_4 <= 7'b1111111;
        display_out_5 <= 7'b1111111;
    end else begin
        // Display 1
        if (seg_first_1 != 7'b1111111 || seg_first_2 != 7'b1111111)
            {display_out_1, display_out_2} <= {seg_first_1, seg_first_2};
        else
            {display_out_1, display_out_2} <= {7'b1111111, 7'b1111111}; // Blank

        // Display 2
        if (seg_second_1 != 7'b1111111 || seg_second_2 != 7'b1111111)
            {display_out_2, display_out_3} <= {seg_second_1, seg_second_2};
        else
            {display_out_2, display_out_3} <= {7'b1111111, 7'b1111111}; // Blank

        // Display 3
        if (seg_third_1 != 7'b1111111 || seg_third_2 != 7'b1111111)
            {display_out_3, display_out_4} <= {seg_third_1, seg_third_2};
        else
            {display_out_3, display_out_4} <= {7'b1111111, 7'b1111111}; // Blank

        // Display 4
        if (seg_fourth_1 != 7'b1111111 || seg_fourth_2 != 7'b1111111)
            {display_out_4, display_out_5} <= {seg_fourth_1, seg_fourth_2};
        else
            {display_out_4, display_out_5} <= {7'b1111111, 7'b1111111}; // Blank

        // Display 5
        if (seg_fifth_1 != 7'b1111111 || seg_fifth_2 != 7'b1111111)
            {display_out_5, display_out_1} <= {seg_fifth_1, seg_fifth_2};
        else
            {display_out_5, display_out_1} <= {7'b1111111, 7'b1111111}; // Blank
    end
end

endmodule
