//------------------------------------------------------------------------------
// Systemverilog verification environment for I2C protocol
// Component name : Monitor class
//------------------------------------------------------------------------------


class monitor;
  virtual i2c_if vif;
  mailbox #(packet) mbx_mon2sco;

  function new(virtual i2c_if vif, mailbox #(packet) mbx_mon2sco);
    this.vif = vif;
    this.mbx_mon2sco = mbx_mon2sco;
  endfunction : new


  task run();
    packet pkt;
    bit [6:0] addr;
    bit rw;
    bit ack;
    bit [7:0] data;
    forever begin
      pkt = new;
      @(negedge vif.i2c_sda);  // waiting for start condition
      @(posedge vif.i2c_scl);
      
      // Capturing address bits(7 bits) over sda line
      for(int i = 6; i >= 0; i--) begin   // As MSB is sent first
        addr[i] = vif.i2c_sda;
        @(posedge vif.i2c_scl);
      end
      
      // Capturing read/~write bit
      rw = vif.i2c_sda;
      @(posedge vif.i2c_scl);
      
      //Capturing acknowledgement bit
      ack = vif.i2c_sda;
      @(posedge vif.i2c_scl)
      
      if ( ack == 0 ) begin
        if(rw == 0)
          wdata(data); // task to sample written data(data sent by master)
        else rdata(data); // task to sample data sent by slave
    end
      
      pkt.addr = addr;
      pkt.rw = rw;
      pkt.data_out = data;
      pkt.ack = ack;
      
      // Clearing the variables for next transaction capture
      addr = 0;
      data = 0;
      ack = 0;
      rw = 0;
      mbx_mon2sco.put(pkt);
      //pkt.display("MON");
      @(posedge vif.i2c_sda); // waiting for stop condition
    end
  endtask : run
    

  task rdata(output [7:0] data);
    repeat(8) @(posedge vif.i2c_scl); // To capture 8 bits
    if(vif.i2c_sda == 0)  // Checking for ack bit
    data = vif.data_out;
    
  endtask : rdata


  task wdata(output [7:0] data);
    bit [7:0] w_data;
    // Capturing written data byte
    for(int i=7; i>=0; i--) begin   // As MSB is sent first
      w_data[i] = vif.i2c_sda;
      @(posedge vif.i2c_scl);
    end
    
    // Checking for acknowledgement bit
    if(vif.i2c_sda == 0)
      data = w_data;

  endtask : wdata

  


endclass : monitor 