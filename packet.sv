//------------------------------------------------------------------------------
// I2C comuunication protocol verification environment
// Component name : Packet class
//------------------------------------------------------------------------------


class packet;
  rand bit [6:0] addr;
  rand bit [7:0] data_in;
  rand bit rw;
  bit [7:0] data_out;
  bit ack;  // To capture acknowledge bit after sending valid and invalid address

  constraint read_write {rw dist {0:=2, 1:=2};}
  constraint slave_addr {addr inside {7'b0101010};} // Since only single slave is driven in the design
  //constraint read_write {rw == 0;}
  

  function void display(string name = "");
    $display("[%0s] addr = %0b data_in = %0b rw = %0b ack = %0b data_out = %0b", name, addr, data_in, rw, ack, data_out);
  endfunction : display
    
  
   // Method to compare packets in the scoreboard
  function int compare (packet pkt);
    compare = 1;
    // Checking for address capture
    if(addr != pkt.addr)
      compare = 0;
    
    // Checking for acknowledgement bit for valid slave address
    if((addr == pkt.addr) && (addr == 7'b0101010)) begin
      if(pkt.ack) compare = 0; 
      if(rw == 0) begin
        if(data_in != pkt.data_out)
          compare = 0;
    end
      else if(pkt.data_out != 8'b11001100)
        compare = 0;
    end
    
    // Checking for acknowledgement bit for invalid slave address
    if((addr == pkt.addr) && (addr != 7'b0101010)) begin
      if(!pkt.ack) compare = 0; end
    
    
    
  endfunction : compare

  
endclass : packet