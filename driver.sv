//------------------------------------------------------------------------------
// I2C protocol system verilog verification environment
// component name : driver class
//------------------------------------------------------------------------------


class driver;
  virtual i2c_if vif; // Virtual interface handle
  mailbox #(packet) mbx_gen2drv; // mailbox b/w generator and driver
  mailbox #(packet) mbx_drv2sco;  // mailbox between driver and scoreboard


  // Constructor method
  // To connect mailboxes
  function new(virtual i2c_if vif, mailbox #(packet) mbx_gen2drv, mbx_drv2sco);
    this.vif = vif;
    this.mbx_gen2drv = mbx_gen2drv;
    this.mbx_drv2sco = mbx_drv2sco;

  endfunction : new

  // Method to drive addr, data_in, enable, rw interface signals
  task run();
    packet pkt;  // packet handle
    forever begin
      mbx_gen2drv.get(pkt); // Retrieving packet from mailbox b/w generator and driver
      wait(vif.ready == 1); // waiting for ready signal to initiate next transaction
      vif.addr <= pkt.addr; // Driving input signals of i2c_controller
      vif.data_in <= pkt.data_in;
      vif.enable <= 1'b1;   // Enabling the transaction
      vif.rw <= pkt.rw;
      repeat (5) @(posedge vif.i2c_scl); // Random delay to wait for next ready
      mbx_drv2sco.put(pkt); // Putting driven packet into driver-scoreboard mbx
     // $display("driver drv2sco %0d", mbx_drv2sco.num());
      pkt.display("DRV");
    end
  endtask : run



endclass : driver

//******************************** End of driver class****************************************