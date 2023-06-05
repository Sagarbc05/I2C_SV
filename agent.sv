class agent;
  generator gen;
  driver drv;
  monitor mon;
  
  mailbox #(packet) mbx_gen2drv;
  mailbox #(packet) mbx_drv2sco;
  mailbox #(packet) mbx_mon2sco;
  
  virtual i2c_if vif;
  
  function new (virtual i2c_if vif, mailbox #(packet) mbx_drv2sco, mbx_mon2sco);
    this.vif = vif;
    this.mbx_drv2sco = mbx_drv2sco;
    this.mbx_mon2sco = mbx_mon2sco;
  endfunction : new
  
  task build();
    mbx_gen2drv = new;
    gen = new(mbx_gen2drv);
    drv = new(vif, mbx_gen2drv, mbx_drv2sco);
    mon = new(vif, mbx_mon2sco);
  endtask : build
  
  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
    join_none
  endtask : run
  
endclass : agent