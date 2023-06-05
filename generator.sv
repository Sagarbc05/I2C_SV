//------------------------------------------------------------------------------
// I2C protocol Systemverilog verification environment
// Component name : Generator class
//------------------------------------------------------------------------------


class generator;
  packet gpkt;  // Packet class handle
  mailbox #(packet) mbx_gen2drv;  // Mailbox b/w generator and driver


  // Constructor method
  // To connect mailbox b/w generator and driver
  function new (mailbox #(packet) mbx_gen2drv);
    gpkt = new;
    this.mbx_gen2drv = mbx_gen2drv;
  endfunction : new

  //Method to generate randomised packets
  task run();
    packet pkt;
    repeat(nop) begin
      assert(gpkt.randomize()) else $error("Randomisation failed");
      pkt = new gpkt;
      mbx_gen2drv.put(pkt);
      pkt.display("GEN");
    end

  endtask : run

endclass : generator