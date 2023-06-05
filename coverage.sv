class coverage;
  packet pkt;
  
  covergroup cg;
    addr : coverpoint pkt.addr {
      bins valid_addr = {7'b0101010};
      ignore_bins invalid_addr = {!(7'b0101010)};
    }
    rd_wr : coverpoint pkt.rw;
    data : coverpoint pkt.data_in;
    
  endgroup : cg
  
  function new();
    cg = new;
  endfunction : new
  
  task sample (packet pkt);
    this.pkt = pkt;
    cg.sample();
    
  endtask : sample
  
  
  
endclass