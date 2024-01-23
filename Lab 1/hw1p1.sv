/* Module for EE/CSE371 Lab 1
 * A Moore FSM for detecting when cars enter or exit a parking lot.
 */
module parking_lot_change (clk, reset, a, b, enter, exit);
	 
	 input logic clk;
	 input logic reset;
	 input logic a, b;
	 
	 output logic enter;
	 output logic exit;

	 // FSM present state and next state
	 logic [3:0] ps, ns;
	 
	 // for a:
	 // 0001 0010 0011      //count on 1001
	 
	 // for b:
	 // 0101 0110 0111     //count on 1010
    
	 // FSM transition logic
    always_comb begin
	    case (ps) 
		    4'b0000: begin
			     if (a & ~b) ns = 4'b0001;  
				  else if (~a & ~b) ns = 4'b0000;
				  else if (~a & b) ns = 4'b0101; 
				  else ns = 4'b0000 //invalid
			 end
			 4'b0001: begin
			     if (a & b) ns = 4'b0010;
				  else if (a & ~b) = 4'b0001;
				  else if (~a & ~b) ns = 4'b0000;
				  else ns = 4'b0000; //invalid
			 end
			 4'b0010: begin 
				  if (a & b) ns = 4'b0010;
				  else if (a & ~b) = 4'b0001;
				  else if (~a & b) ns = 4'b0011;
				  else ns = 4'b0000; //invalid
			 end
			 4'0011: begin
			     if (a & b) ns = 4'b0010;
				  else if (~a & b) = 4'b0011;
				  else if (~a & ~b) ns = 4'b1001;
				  else ns = 4'b0000; //invalid
			 end
			 4'1001: begin
			     if (a & ~b) ns = 4'b0001;  
				  else if (~a & ~b) ns = 4'b0000;
				  else if (~a & b) ns = 4'b0101; 
				  else ns = 4'b0000 //invalid
			 end
			 4'b0101: begin
			     if (a & b) ns = 4'b0110;
				  else if (~a & b) = 4'b0101;
				  else if (~a & ~b) ns = 4'b0000;
				  else ns = 4'b0000; //invalid
			 end
			 4'b0110: begin 
				  if (a & b) ns = 4'b0110;
				  else if (a & ~b) = 4'b0111;
				  else if (~a & b) ns = 4'b0101;
				  else ns = 4'b0000; //invalid
			 end
			 4'0111: begin
			     if (a & b) ns = 4'b0110;
				  else if (a & ~b) = 4'b0111;
				  else if (~a & ~b) ns = 4'b1010;
				  else ns = 4'b0000; //invalid
			 end
			 4'1010: begin
			     if (a & ~b) ns = 4'b0001;  
				  else if (~a & ~b) ns = 4'b0000;
				  else if (~a & b) ns = 4'b0101; 
				  else ns = 4'b0000 //invalid
			 end
			 default: ns = 4'b0000;
		endcase
	 end
	 
	 always_ff @(posedge clk) begin
         if (reset) ps <= 4'b0000;
         else ps <= ns;
      end
	
	// enter and exit are function of present state
	assign enter = ps[3] & ps[0];
	assign exit = ps[3] & ps[1];

endmodule  // hw1p1


/* Testbench for Homework 1 Problem 1 */
module parking_lot_change_testbench();
	 
	 logic clk;
	 logic reset;
	 logic a, b;
	 
	 logic enter;
	 logic exit;

    // Instantiate the parking_lot_change module
    parking_lot_change dut (.clk(clk), .reset(reset), .a(a), .b(b), .enter(enter), .exit(exit));

    // Set up the clock
    parameter CLOCK_PERIOD = 10;  // Clock period in time units
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD / 2) clk = ~clk;
    end

   
    initial begin
       
        reset = 1; x = 0; y = 0;
        @(posedge clk);  
        reset = 0;
        @(posedge clk);  
		  
        // test car entering
        a = 1; b = 0; @(posedge clk);
        a = 1; b = 1; @(posedge clk);
        a = 0; b = 1; @(posedge clk);
        a = 0; b = 0; @(posedge clk);
		  
        // test car exiting
        a = 0; b = 1; @(posedge clk);
        a = 1; b = 1; @(posedge clk);
        a = 1; b = 0; @(posedge clk);
        a = 0; b = 0; @(posedge clk);
		  
		  
        // test car entering with some reversing midway
        a = 1; b = 0; @(posedge clk);
        a = 1; b = 1; @(posedge clk);
        a = 1; b = 0; @(posedge clk);
        a = 1; b = 1; @(posedge clk);
        a = 0; b = 1; @(posedge clk);
        a = 0; b = 0; @(posedge clk);
		  
        // test car starting to exit but then backing into the parking lot
		  // ie. not exiting at the end of the day
        a = 0; b = 1; @(posedge clk);
        a = 1; b = 1; @(posedge clk);
        a = 1; b = 0; @(posedge clk);
        a = 1; b = 1; @(posedge clk);
        a = 0; b = 1; @(posedge clk);
        a = 0; b = 0; @(posedge clk);
		  
        // reset to default state
        reset = 1; @(posedge clk);
        reset = 0; @(posedge clk); 

    end

endmodule  // hw1p1_testbench
