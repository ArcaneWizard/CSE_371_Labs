/* Raghav Narula, Pedro Amarante
   1/21/2024
    CSE 371
    Lab 2, Task 1
   
    implementation of a RAM unit on an FPGA 
*/

// Modelsim-ASE requires a timescale directive
`timescale 1 ns / 1 ns

module memory
  (
  input logic CLOCK_50,
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
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
  five_bit_counter counter (.clk(one_sec_clk), .reset(reset | (raddress == 31)), .inc(1), .dec(0), .out(raddress));
  
  // as each word is being displayed, show its address (in hex format) on the 7-segment displays HEX3−2
  display_num_on_hex hex0 (.num(dataOut), .HEX(HEX0));
  display_num_on_hex hex2 (.num(raddress[3:0]), .HEX(HEX2)); 
  display_num_on_hex hex3 (.num(raddress[4]), .HEX(HEX3));
  
  display_num_on_hex address_byte_two (.num(waddress[4]), .HEX(HEX5));
  display_num_on_hex address_byte_one (.num(waddress[3:0]), .HEX(HEX4));
  display_num_on_hex hex1 (.num(dataIn), .HEX(HEX1));
  
  
  ram32x4 memory(.clock(CLOCK_50), .data(dataIn), .rdaddress(raddress), .wraddress(waddress), .wren(write), .q(dataOut));
    
endmodule  // DE1_SoC


module memory_testbench();

    // Inputs
    logic clock;
    logic [3:0] KEY;
    logic [9:0] SW;

    // Outputs
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    memory dut ( 
	     .CLOCK_50(clock),
        .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
        .KEY(KEY), 
        .SW(SW)
    );
	 
	 assign KEY[0] = clock;

    parameter CLOCK_PERIOD=10;
      initial begin
         clock <= 0;
         forever #(CLOCK_PERIOD/2) clock <= ~clock;
      end

    // Testbench stimulus
    initial begin
              
        // Write and read a value
        SW[9] <= 1'b1;  // Enable write
        SW[8:4] <= 5'b00010;  // Address
        SW[3:0] <= 4'b1010;  // Data
        
		  @(posedge clock);
		  
			for(int i = 0; i <= 31; i++) begin
				SW[8:4] <= i;
            @(posedge clock);
			end
		 
			for(int i = 0; i <= 31; i++) begin
				SW[8:4] <= i;
            @(posedge clock);
			end
		 
			for(int i = 0; i <= 31; i++) begin
				SW[8:4] <= i;
            @(posedge clock);
			end
		  
        SW[9] <= 1'b0;  // Disable write
           @(posedge clock);
				
        // Change address to read
        SW[8:4] <= 5'b00010;
          @(posedge clock);
        
    end

endmodule