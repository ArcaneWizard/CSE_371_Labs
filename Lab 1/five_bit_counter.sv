
/* Raghav Narula, Pedro Amarante
   1/13/2024
	CSE 371
	Lab 1, Task 1
   
	Takes in a single bit clock (clk), reset, increment signal (inc), and decrement signal (dec)
   as inputs. Returns a 5-bit number out representing the counter value. This module tracks
	a 5-bit number, and can increment or decrement said number on posedge of the clock.
*/

module five_bit_counter (clk, reset, inc, dec, out);

  input logic clk;
  input logic reset;
  input logic inc;
  input logic dec;
  output logic [4:0] out;

  // 5-bit value to set counter to (on next pos-edge of clock)
  logic [4:0] fOut;
  
  // Update next counter value based on inc and dec values.
  // it's value is bounded between 0 and 31 inclusive
  always_comb begin
     // decrement
    if (inc & ~dec) begin
       if (out == 5'b11111) fOut = 5'b11111;
       else fOut = out + 1'b1;
    end
	 
	 // increment
    else if (~inc & dec) begin
       if (out == 5'b00000) fOut = 5'b00000;
       else fOut = out - 1'b1;
    end
	 
	  // counter shouldn't change since inc and dec are set to 1 simultaneously, 
	  // or both are set to 0
	 else begin
	    fOut = out; 
    end
  end
  
   // update counter value (out) on posedge of clock
	// when incrementing or decrementing. On reset, set counter to 0
  always_ff @(posedge clk) begin
    if (reset)
      out <= 5'b00000;
    else if (inc | dec)
      out <= fOut;
  end
  
endmodule


/* five_bit_counter tests covering expected, unexpected and edgecase behaviour */
module five_bit_counter_testbench();
	 
    logic clk;
    logic reset;
    logic inc;
    logic dec;
	 logic [4:0] out;
	
    // Instantiate the five_bit_counter module
    five_bit_counter dut (.clk(clk), .reset(reset), .inc(inc), .dec(dec), .out(out));

    // Set up the clock
    parameter CLOCK_PERIOD = 10;  // Clock period in time units
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD / 2) clk = ~clk;
    end
   
	 int count = 25;
   
    initial begin
        
		  // reset counter to start at 0, and set inc/dec to 0
        reset = 1; inc = 0; dec = 0;
        @(posedge clk);  
        reset = 0;
        @(posedge clk);  
		  
        // test incrementing all the way to the max-counter value and stopping there
        inc = 1; dec = 0; #(CLOCK_PERIOD * 40);
		  
		  // test decrementing all the way down to 0 and stopping there
		  inc = 0; dec = 1; #(CLOCK_PERIOD * 40);
		  
		  // test alternating incrementing and decrementing
		  inc = 1; dec = 0; #(CLOCK_PERIOD * 5);
		  inc = 0; dec = 1; #(CLOCK_PERIOD * 2);
		  inc = 1; dec = 0; #(CLOCK_PERIOD * 3);
		  inc = 0; dec = 1; #(CLOCK_PERIOD * 3);
		  
		  // test simulatenously setting inc and dec to 1. counter shouldn't change
		  inc = 1; dec = 1; #(CLOCK_PERIOD * 3);
		  
		  // test simulatenously setting inc and dec to 0. counter shouldn't change
		  inc = 0; dec = 0; #(CLOCK_PERIOD * 3);
		  
        // test resetting counter to 0
        reset = 1; @(posedge clk);
        reset = 0; @(posedge clk); 
		  
		  // test incrementing and decrementing after reset
		  inc = 1; dec = 0; #(CLOCK_PERIOD * 3);
		  inc = 0; dec = 1; #(CLOCK_PERIOD * 2);
    end

endmodule  // five_bit_counter_testbench