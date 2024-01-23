
/* Raghav Narula, Pedro Amarante
   1/13/2024
	CSE 371
	Lab 1, Task 1
   
	This modules tracks when cars are leaving or entering the parking lot.
	Takes in a 1-bit clock (clk), reset, two photo sensor signals (a and b) as inputs.
	It returns whether a car entered the parking lot (1-bit enter), and whether 
	a clock exited the parking lot (1-bit exit).
*/


module parking_lot_change (clk, reset, a, b, enter, exit);
	 
	 input logic clk;
	 input logic reset; // whether to reset FSM to default state
	 input logic a, b; // Photosensors a and b (1 = blocked, 0 = not blocked)
	 
	 output logic enter;
	 output logic exit;

	 // FSM present state and next state
	 logic [3:0] ps, ns;
    
	 // Moore FSM transition logic
	 // note state 0000 is default state
	 // path 0001 0010 0011 1001 corresponds to car entering
	 // path 0101, 0110, 011, 1010 corresponds to car exiting
	 // state 1001 confirms a car entered; 1010, confirms a car exited
    always_comb begin
	    case (ps) 
		    4'b0000: begin
			     if (a & ~b) ns = 4'b0001;  
				  else if (~a & ~b) ns = 4'b0000;
				  else if (~a & b) ns = 4'b0101; 
				  else ns = 4'b0000; //invalid
			 end
			 4'b0001: begin
			     if (a & b) ns = 4'b0010;
				  else if (a & ~b) ns = 4'b0001;
				  else if (~a & ~b) ns = 4'b0000;
				  else ns = 4'b0000; //invalid
			 end
			 4'b0010: begin 
				  if (a & b) ns = 4'b0010;
				  else if (a & ~b) ns = 4'b0001;
				  else if (~a & b) ns = 4'b0011;
				  else ns = 4'b0000; //invalid
			 end
			 4'b0011: begin
			     if (a & b) ns = 4'b0010;
				  else if (~a & b) ns = 4'b0011;
				  else if (~a & ~b) ns = 4'b1001;
				  else ns = 4'b0000; //invalid
			 end
			 4'b1001: begin
			     if (a & ~b) ns = 4'b0001;  
				  else if (~a & ~b) ns = 4'b0000;
				  else if (~a & b) ns = 4'b0101; 
				  else ns = 4'b0000; //invalid
			 end
			 4'b0101: begin
			     if (a & b) ns = 4'b0110;
				  else if (~a & b) ns = 4'b0101;
				  else if (~a & ~b) ns = 4'b0000;
				  else ns = 4'b0000; //invalid
			 end
			 4'b0110: begin 
				  if (a & b) ns = 4'b0110;
				  else if (a & ~b) ns = 4'b0111;
				  else if (~a & b) ns = 4'b0101;
				  else ns = 4'b0000; //invalid
			 end
			 4'b0111: begin
			     if (a & b) ns = 4'b0110;
				  else if (a & ~b) ns = 4'b0111;
				  else if (~a & ~b) ns = 4'b1010;
				  else ns = 4'b0000; //invalid
			 end
			 4'b1010: begin
			     if (a & ~b) ns = 4'b0001;  
				  else if (~a & ~b) ns = 4'b0000;
				  else if (~a & b) ns = 4'b0101; 
				  else ns = 4'b0000; //invalid
			 end
			 default: ns = 4'b0000;
		endcase
	 end
	 
	 // on clock posedge, do FSM transitions (set present state to next state)
	 // on reset, set present state to default state
	 always_ff @(posedge clk) begin
         if (reset) ps <= 4'b0000;
         else ps <= ns;
      end
	
	// enter and exit are functions of present state
	assign enter = ps[3] & ps[0];
	assign exit = ps[3] & ps[1];

endmodule  // hw1p1


/* parking_lot_change tests covering expected, unexpected and edgecase behaviour */
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
       
        reset = 1; a = 0; b = 0;
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

endmodule  // parking_lot_change_testbench
