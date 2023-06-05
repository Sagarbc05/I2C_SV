//------------------------------------------------------------------------------
//  I2C protocol Systemverilog verfication environment
//  Component name : test
//------------------------------------------------------------------------------


class pkt_test1 extends packet;
  constraint read_write {rw == 0;}
endclass : pkt_test1

class pkt_test2 extends packet;
  constraint read_write {rw == 1;}
endclass : pkt_test2

class pkt_test3 extends packet;
  constraint slave_addr {addr != 7'b0101010; } 
endclass : pkt_test3

program test (i2c_if pif);

  environment env;
  pkt_test1 t1;
  pkt_test2 t2;
  pkt_test3 t3;
  
  initial begin
    env = new(pif);
    t1 = new;
    t2 = new;
    t3 = new;
    
    env.build();
    env.reset();
   
    // Test case 01
    // Reset Test case
    $display("Test case 01 : Reset test case");
    if ((pif.i2c_scl == 1) && (pif.i2c_sda == 1))
      $display("Reset test case passed");
    else
      $display("Reset test case failed");
    
    // Test case 02
    // Generating random packets
    $display("Test case 02 : 10 Random packets with valid slave address");
    nop = 10;
    env.run();
    
   
    // Test case 03
    // Repeated write operation to valid slave_address
    $display("Test case 03 : Repeated write with valid slave address");
    env.agt.gen.gpkt = t1;
    nop = 5;
    nop_out = 0;
    env.run();
   
   
     // Test case 04
    // Repeated read operation to valid slave_address
    $display("Test case 04 : Repeated read with valid slave address");
    env.agt.gen.gpkt = t2;
    nop = 5;
    nop_out = 0;
    env.run();
    
    
     // Test case 05
    // Driving invalid slave address
    $display("Test case 05 : Packet with invalid slave address");
    env.agt.gen.gpkt = t3;
    nop = 1;
    nop_out = 0;
    env.run();
    
    
    env.final_report();
  end



endprogram : test