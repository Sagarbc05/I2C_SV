`timescale 1ns / 1ps

module i2c_slave_controller(
	inout sda,
	inout scl
	);
	
	localparam ADDRESS = 7'b0101010;
	
	localparam READ_ADDR = 0;
	localparam SEND_ACK = 1;
	localparam READ_DATA = 2;
	localparam WRITE_DATA = 3;
	localparam SEND_ACK2 = 4;
        localparam READ_ACK = 5;
        localparam STOP = 6;	

	reg [7:0] addr;
	reg [7:0] counter;
        reg [7:0] state = 0;  
	reg [7:0] data_in = 0;
	reg [7:0] data_out = 8'b11001100;
	reg sda_out = 0;
	reg sda_in = 0;
	reg start = 0;
	reg write_enable = 0;
	
	assign sda = (write_enable == 1) ? sda_out : 'bz;
	
	always @(negedge sda) begin
		if ((start == 0) && (scl == 1)) begin
			start <= 1;	
			counter <= 7;
		end
	end
	
	always @(posedge sda) begin
		if ((start == 1) && (scl == 1)) begin
			state <= READ_ADDR;
			start <= 0;
			write_enable <= 0;
		end
	end
	
	always @(posedge scl) begin
		if (start == 1) begin
			case(state)
				READ_ADDR: begin
					addr[counter] <= sda;
	 		if(counter == 0) state <= SEND_ACK;
					else counter <= counter - 1;					
				end
				
				SEND_ACK: begin
					if(addr[7:1] == ADDRESS) begin
						counter <= 7;
						if(addr[0] == 0) begin 
							state <= READ_DATA;
						end
						else state <= WRITE_DATA;
					end
				end
				
				READ_DATA: begin
					data_in[counter] <= sda;
					if(counter == 0) begin
						state <= SEND_ACK2;
					end else counter <= counter - 1;
				end
				
				SEND_ACK2: begin
					state <= STOP;					
				end
				
				WRITE_DATA: begin
					if(counter == 0) state <= READ_ACK;
					else counter <= counter - 1;		
				end
             
                                READ_ACK: begin                             // Modified code
                                      if(sda == 0) state <= STOP;
                                      else state <= READ_ACK;
                                end
                               
                                STOP: begin
                                   state <= READ_ADDR;
                                end                                          //
                                
                            
				
			endcase
		end
	end
	
	always @(negedge scl) begin
		case(state)
			
			READ_ADDR: begin
				write_enable <= 0;			
			end
			
			SEND_ACK: begin
              if(addr[7:1] == ADDRESS)
				sda_out <= 0;
              else sda_out <= 1;
				write_enable <= 1;	
			end
			
			READ_DATA: begin
				write_enable <= 0;
			end
			
			WRITE_DATA: begin
				sda_out <= data_out[counter];
				write_enable <= 1;
                               //#1 $display("slave sda[%0d] = %0b",counter, sda_out);
			end
			
			SEND_ACK2: begin
				sda_out <= 0;
				write_enable <= 1;
			end
                        READ_ACK: begin
                               write_enable <= 0;
                        end
                        //STOP: begin                      // Modified code
                          //  write_enable <= 0;
                        //end
                             
		endcase
	end
endmodule