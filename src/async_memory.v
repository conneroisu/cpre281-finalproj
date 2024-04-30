`timescale 1ns / 1ps

module async_memory (
    input clock,
    input reset,

    input  [31:0] addr_in,
    output [31:0] data_out,
    input  [31:0] data_in,
    input  [ 1:0] size_in,   //0=byte, 1=2-byte, 2=unaligned, 3=word
    input         we_in,
    input         re_in
);
  parameter MEM_ADDR = 16'h1000;
  parameter DO_INIT = 0;
  parameter INIT_PROGRAM0 = "inst_rom.memh";
  parameter INIT_PROGRAM1 = "inst_rom.memh";
  parameter INIT_PROGRAM2 = "inst_rom.memh";
  parameter INIT_PROGRAM3 = "inst_rom.memh";
  reg [256*8:1] file_init0, file_init1, file_init2, file_init3;

  localparam NUM_WORDS = 1024;
  localparam NUM_WORDS_LOG = 10;

  //memory for 4KB of data
  reg [7:0] mem3[0:NUM_WORDS-1];  //31:24
  reg [7:0] mem2[0:NUM_WORDS-1];  //23:16
  reg [7:0] mem1[0:NUM_WORDS-1];  //15:8
  reg [7:0] mem0[0:NUM_WORDS-1];  //7:0

  initial begin
    if (DO_INIT == 1) begin
      $readmemh(INIT_PROGRAM0, mem0);
      $readmemh(INIT_PROGRAM1, mem1);
      $readmemh(INIT_PROGRAM2, mem2);
      $readmemh(INIT_PROGRAM3, mem3);
    end
  end

  reg [31:0] rd;
  assign data_out = rd;

  // Read data all the time
  always @(*) begin
    rd[31:24] <= mem3[addr_in[2+NUM_WORDS_LOG-1:2]];
    rd[23:16] <= mem2[addr_in[2+NUM_WORDS_LOG-1:2]];
    rd[15:8]  <= mem1[addr_in[2+NUM_WORDS_LOG-1:2]];
    rd[7:0]   <= mem0[addr_in[2+NUM_WORDS_LOG-1:2]];
  end

  //alternate version uses negative edge of clock for memory accesses
  always @(negedge clock) begin
    rd[31:24] <= mem3[addr_in[2+NUM_WORDS_LOG-1:2]];
    rd[23:16] <= mem2[addr_in[2+NUM_WORDS_LOG-1:2]];
    rd[15:8]  <= mem1[addr_in[2+NUM_WORDS_LOG-1:2]];
    rd[7:0]   <= mem0[addr_in[2+NUM_WORDS_LOG-1:2]];
  end

  //decode address and size into byte-enables
  reg [3:0] rowWE;
  always @(*) begin
    case (size_in)
      2'b00: rowWE <= {addr_in[1:0] == 3, addr_in[1:0] == 2, addr_in[1:0] == 1, addr_in[1:0] == 0};
      2'b01: rowWE <= {{2{addr_in[1:0] == 2}}, {2{addr_in[1:0] == 0}}};
      2'b10: rowWE <= 4'b0000;  //unaligned write unsupported
      2'b11: rowWE <= {{4{addr_in[1:0] == 0}}};
    endcase
  end

  // Make sure the write data from the processor ends up in the correct byte location
  reg [31:0] write_data;
  always @(*) begin
    case (size_in)
      2'b00:   write_data <= {data_in[7:0], data_in[7:0], data_in[7:0], data_in[7:0]};
      2'b01:   write_data <= {data_in[15:0], data_in[15:0]};
      default: write_data <= data_in[31:0];
    endcase
  end


  // On posedge of clock, write data only if wr_en is high
  always @(posedge clock) begin
    if (reset) begin
    end else begin
      if (we_in && (addr_in[31:16] == MEM_ADDR)) begin
        if (rowWE[3]) mem3[addr_in[2+NUM_WORDS_LOG-1:2]] <= write_data[31:24];
        if (rowWE[2]) mem2[addr_in[2+NUM_WORDS_LOG-1:2]] <= write_data[23:16];
        if (rowWE[1]) mem1[addr_in[2+NUM_WORDS_LOG-1:2]] <= write_data[15:08];
        if (rowWE[0]) mem0[addr_in[2+NUM_WORDS_LOG-1:2]] <= write_data[07:00];
      end
    end
  end


endmodule

