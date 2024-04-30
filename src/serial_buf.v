module serial_buffer (
    input clock,  // 50 MHz
    input reset,  // active-high
    input [31:0] addr_in,  // 32-bit address
    output reg [31:0] data_out,  // 32-bit data
    input re_in,  // active-high
    input [31:0] data_in,  // 32-bit data
    input we_in,  // active-high
    input s_data_valid_in,  // active-high
    input [7:0] s_data_in,  // 8-bit data
    input s_data_ready_in,  // active-high
    output s_rden_out,  // active-high
    output [7:0] s_data_out,  // 8-bit data
    output s_wren_out  // active-high
);
  parameter MEM_ADDR = 16'hffff;
  always @(*) begin
    case (addr_in[3:2])
      2'h0: data_out = {31'b0, s_data_valid_in};
      2'h1: data_out = {24'b0, s_data_in};
      2'h2: data_out = {31'b0, s_data_ready_in};
      2'h3: data_out = {32'b0};
    endcase
  end
  reg read_en;
  reg write_en;
  reg [7:0] sbyte;
  assign s_rden_out = read_en;
  assign s_wren_out = write_en;
  assign s_data_out = sbyte;
  always @(posedge clock) begin
    if (reset) begin
      read_en <= 1'b0;
      write_en <= 1'b0;
      sbyte <= 8'b0;
    end else begin
      read_en  <= 1'b0;
      write_en <= 1'b0;
      if (addr_in[31:16] == MEM_ADDR) begin
        if (re_in && (addr_in[3:2] == 2'h1)) begin  //read data byte
          read_en <= 1'b0;
        end
        if (we_in && (addr_in[3:2] == 2'h3)) begin  //byte write
          sbyte <= data_in[7:0];
          write_en <= 1'b1;
        end
      end
    end
  end
endmodule
