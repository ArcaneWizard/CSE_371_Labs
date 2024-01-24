/* Raghav Narula, Pedro Amarante
   1/21/2024
    CSE 371
    Lab 2, Task 3
   
    Using our FIFO implemntation in the FPGA 
*/

module DE1_SoC_FIFO
  (
  input logic CLOCK_50,
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
  output logic [9:0] LEDR,
  input  logic [3:0] KEY,     // True when not pressed, False when pressed
  input  logic [9:0] SW
  );

  logic [7:0] outputBus;
  display_num_on_hex in_data_byte1 (.num(inputBus[7:4), .HEX(HEX5));
  display_num_on_hex in_data_byte0 (.num(inputBus[3:0]), .HEX(HEX4));
  display_num_on_hex out_data_byte1 (.num(outputBus[7:4), .HEX(HEX1));
  display_num_on_hex out_data_byte0 (.num(outputBus[3:0]), .HEX(HEX0));
  FIFO fpga_fifo (.clk(CLOCK_50), .reset(~KEY[0]), .read(~KEY[1]), .write(~KEY[2]), .inputBus(SW[7:0]), .empty(LEDR[8]), .full(LEDR[9], .outputBus(outputBus);
 
endmodule  // DE1_SoC
