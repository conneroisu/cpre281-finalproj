`include "processor.v"
module processor_scripts_test_1_testbench ();
  reg clock;
  reg reset;
  wire [7:0] serial_out;
  wire serial_wren;
  wire [31:0] ret1;
  wire [31:0] ret2;
  wire [31:0] ret3;
  wire [31:0] ret4;
  wire [6:0] seg1;
  wire [6:0] seg2;
  wire [6:0] seg3;
  wire [6:0] seg4;
  wire [6:0] seg5;
  assign ret1 = dut.registers.registers[10];
  assign ret2 = dut.registers.registers[11];
  assign ret3 = dut.registers.registers[12];
  assign ret4 = dut.registers.registers[13];
  //Generate clock at 100 MHz
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0, testbench);
    clock <= 1'b0;
    reset <= 1'b1;
    forever #10 clock <= ~clock;
  end
  //Drop reset after 200 ns
  always begin
    #200 reset <= 1'b0;
  end
  //instantiate the processor  "DUT"
  processor dut (
      .clock(clock),
      .reset(reset),
      .serial_in(8'b0),
      .serial_valid_in(1'b0),  // active-high
      .serial_ready_in(1'b1),  // active-high
      .serial_rden_out(),  //active-high
      .serial_out(serial_out),
      .serial_wren_out(serial_wren),  //active-high
      .seg1(seg1),
      .seg2(seg2),
      .seg3(seg3),
      .seg4(seg4),
      .seg5(seg5)
  );
  //This will print out a message whenever the serial port is written to
  always @(posedge clock) begin
    if (reset) begin
    end else begin
      if (serial_wren) begin
        $display("[%0d] Serial: %c", $time, serial_out);
      end
    end
  end
endmodule
