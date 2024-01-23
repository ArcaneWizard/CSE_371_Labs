/* Module for EE/CSE371 Homework 1 Problem 2.
 * An arbitrary Mealy FSM.
 */
module hw1p2 (input logic clk,
    input logic reset,
    input logic in,
    output logic out);
     
	 // FSM present state and next state
	 logic [2:0] ps, ns;
    
	 // FSM transition logic
    always_comb begin
	    case (ps) 
		    3'b000: begin
			     if (in) ns = 3'b100;
				  else ns = 3'b011;
			 end
			 3'b010: begin
			     if (in) ns = 3'b000;
				  else ns = 3'b010;
			 end
			 3'b100: begin
			     if (in) ns = 3'b011;
				  else ns = 3'b010;
			 end
			 3'b001: begin
			     if (in) ns = 3'b100;
				  else ns = 3'b001;
			 end
			 3'b011: begin
			     if (in) ns = 3'b010;
				  else ns = 3'b001;
			 end
			 default: ns = 3'b000;
		endcase
	 end
	 
	 always_ff @(posedge clk) begin
         if (reset) ps <= 3'b000;
         else ps <= ns;
      end
	
	// Mealy FSM output is function of input and present state
	assign out = in & ~ps[2];
	 

endmodule  // hw2p2


/* Testbench for Homework 1 Problem 2 */
module hw1p2_testbench();

	 logic clk;
	 logic reset;
	 logic in;
	 logic out;
	 

    // Instantiate the hw1p2 module
	 hw1p2 dut (.clk(clk), .reset(reset), .in(in), .out(out));

    // Set up the clock
    parameter CLOCK_PERIOD = 10;  // Clock period in time units
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD / 2) clk = ~clk;
    end

     
	 // test every possible transition in FSM
    initial begin
	     reset = 1; @(posedge clk);
		  reset = 0; in = 1; @(posedge clk);
		  in = 0; @(posedge clk);
		  in = 0; @(posedge clk);
		  in = 1; @(posedge clk);
		  in = 0; @(posedge clk);
		  in = 0; @(posedge clk);
		  in = 0; @(posedge clk);
		  in = 1; @(posedge clk);
		  in = 1; @(posedge clk);
		  in = 1; @(posedge clk); // we've tested every transition
		  in = 0; @(posedge clk);
		  reset = 1; @(posedge clk);
        
    end  // initial
    
endmodule  // hw1p2_testbench