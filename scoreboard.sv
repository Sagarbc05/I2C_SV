class scoreboard;
  
  mailbox #(packet) mbx_drv2sco;
  mailbox #(packet) mbx_mon2sco;
  
  function new(mailbox #(packet) mbx_drv2sco, mbx_mon2sco);
    this.mbx_drv2sco = mbx_drv2sco;
    this.mbx_mon2sco = mbx_mon2sco;
  endfunction : new
  
  
  task run();
    packet pkt_mon;
    packet pkt_drv;
    
    forever begin
     coverage cg = new;
      mbx_drv2sco.get(pkt_drv);
      $display("Expected packet");
      pkt_drv.display("SCO");
      
      mbx_mon2sco.get(pkt_mon);
      $display("Actual packet");
      pkt_mon.display("SCO");
      
      cg.sample(pkt_mon);
      
      if (pkt_drv.compare(pkt_mon))
        $display("packets are matched");
      else
        error++;
      
      nop_out++;
      
    end
    
  endtask : run
endclass : scoreboard