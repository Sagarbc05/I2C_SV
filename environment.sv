//------------------------------------------------------------------------------
// I2C protocol Systemverilog verification environment
// Component name : Environment class
//------------------------------------------------------------------------------


class environment;
  virtual i2c_if vif;
  mailbox #(packet) mbx_gen2drv;
  mailbox #(packet) mbx_drv2sco;
  mailbox #(packet) mbx_mon2sco;
  
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  
  function new(virtual i2c_if vif);
    this.vif = vif;
  endfunction : new

  task build();
    mbx_gen2drv = new;
    mbx_drv2sco = new;
    mbx_mon2sco = new;
    gen = new(mbx_gen2drv);
    drv = new(vif, mbx_gen2drv, mbx_drv2sco);
    mon = new(vif, mbx_mon2sco);
    sco = new(mbx_drv2sco, mbx_mon2sco);
  endtask : build

  task reset();
    vif.rst = 1'b0;
    repeat(5) @(posedge vif.clk);
    vif.rst = 1'b1;
    repeat(20) @(posedge vif.clk);
    vif.rst = 1'b0;
 
  endtask : reset
  
  task report();
    if(error == 0)
      $display("Test case passed");
    else $display("Test case failed with %0d errors", error);
  endtask : report
  
  task final_report();
    if(error == 0)
      $display("All test cases are passed");
    else $display("Few test cases are failed with %0d errors", error);
    
    $display("Functional Coverage report\n %0f", $get_coverage());
    
  endtask


  task run();
   //build();
   //reset();
   fork
     gen.run();
     drv.run();
     mon.run();
     sco.run();
   join_none
   wait (nop == nop_out);
    disable fork;
    report();

  endtask : run

endclass : environment