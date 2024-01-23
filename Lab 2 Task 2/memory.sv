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
  logic [4:0] rdaddress;
  logic [4:0] wdaddress;
  logic [3:0] dataOut;
  logic write;
  logic reset;
  
  assign dataIn = SW[3:0];
  assign wdaddress = SW[8:4];
  
  // display the content of each four-bit word (in hexadecimal format) on the 7-segment display HEX0
  assign HEX0 = dataOut;
  
  // as each word is being displayed, show its address (in hex format) on the 7-segment displays HEX3−2
  display_num_on_hex address_byte_two (.num(rdaddress[4]), .HEX(HEX3));
  display_num_on_hex address_byte_one (.num(rdaddress[3:0]), .HEX(HEX2)); 
  
  // Use the 50 MHz clock, CLOCK_50, 
  logic [31:0] clock;
  clock_divider cdiv (.clock(CLOCK_50), .divided_clocks(clk));
  
  //use KEY 0 as a reset input.
  assign reset = ~KEY[0];
  
  //use KEY3 as your wr_en.
  assign write = ~KEY[3];
  
  
  
  display_num_on_hex address_byte_two (.num(wdaddress[4]), .HEX(HEX5));
  display_num_on_hex address_byte_one (.num(wdaddress[3:0]), .HEX(HEX4));
 
  display_num_on_hex data_in_display (.num(dataIn), .HEX(HEX2));
  display_num_on_hex data_out_display (.num(dataOut), .HEX(HEX0));
  
  ram32x4 memory(.clock(clock), .data(dataIn), .rdaddress(rdaddress), .wraddress(wdaddress), .wren(write), .q(dataOut));
  
    
  


  
    
endmodule  // DE1_SoC