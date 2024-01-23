/* Raghav Narula, Pedro Amarante
   1/21/2024
    CSE 371
    Lab 2, Task 1
   
    implementation of a RAM unit on an FPGA 
*/

module memory
  (
  input logic CLOCK_50,
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
  output logic [9:0] LEDR,
  input  logic [3:0] KEY,     // True when not pressed, False when pressed
  input  logic [9:0] SW
  );

 
  logic [3:0] dataIn;
  logic [4:0] raddress;
  logic [4:0] waddress;
  logic [3:0] dataOut;
  logic write;
  logic reset;
  logic one_sec_clk;
  
  //use KEY 0 as a reset input.
  assign reset = ~KEY[0];
  
  always_ff @(posedge CLOCK_50) begin
	  dataIn <= SW[3:0];
	  waddress <= SW[8:4];
	  write <= ~KEY[3];  
  end
  
  
  one_sec_clock one_sec (.clock(CLOCK_50), .new_clock(one_sec_clk)); 
  five_bit_counter counter (.clk(one_sec_clk), .reset(reset), .inc(1), .dec(0), .out(raddress));
  
  // as each word is being displayed, show its address (in hex format) on the 7-segment displays HEX3−2
  display_num_on_hex hex0 (.num(dataOut), .HEX(HEX0));
  display_num_on_hex hex2 (.num(raddress[3:0]), .HEX(HEX2)); 
  display_num_on_hex hex3 (.num(raddress[4]), .HEX(HEX3));
  
  display_num_on_hex address_byte_two (.num(waddress[4]), .HEX(HEX5));
  display_num_on_hex address_byte_one (.num(waddress[3:0]), .HEX(HEX4));
  display_num_on_hex hex1 (.num(dataIn), .HEX(HEX1));
  
  
  ram32x4 memory(.clock(CLOCK_50), .data(dataIn), .rdaddress(raddress), .wraddress(waddress), .wren(write), .q(dataOut));
    
endmodule  // DE1_SoC