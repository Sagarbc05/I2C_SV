//------------------------------------------------------------------------------
// I2C protocol Systemverilog verification environment
// Component name : Top level testbench
//------------------------------------------------------------------------------
`timescale 1ns/1ps

`include "global.sv"
`include "interface.sv"
`include "packet.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "coverage.sv"
`include "scoreboard.sv"
`include "environment_agent.sv"
`include "test.sv"


module test_top;
  reg clk;

  i2c_if pif(clk); // Physical interface

  test TEST (pif); // Test instantiation
  
  // Both controller and slave are connected to common interface
  // Instantiating i2c_master controller
  i2c_controller MASTER (
                  .clk(clk),
                 .rst(pif.rst),
                 .addr(pif.addr),
                 .data_in(pif.data_in),
                 .enable(pif.enable),
                 .rw(pif.rw),
                 .data_out(pif.data_out),
                 .ready(pif.ready),
                 .i2c_sda(pif.i2c_sda),
                 .i2c_scl(pif.i2c_scl)                 
  );


  // Instantiating I2C salve controller
  i2c_slave_controller SLAVE (
            .sda(pif.i2c_sda),
            .scl(pif.i2c_scl)
                  
  );


  always #5 clk = ~clk;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, test_top);
    clk = 0;
  end
    
endmodule : test_top