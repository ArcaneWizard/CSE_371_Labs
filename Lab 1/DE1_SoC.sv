/* Raghav Narula, Pedro Amarante
   1/13/2024
	CSE 371
	Lab 1, Task 1
   
	DE1_Soc takes in a 50 MHz Clock (CLOCK_50) and 36 GPIO pins (36 bit V_GPIO) as inputs.
	It returns values to six 7-segment Hex displays (7-bit HEX0, HEX1, HEX2, HEX3, HEX4, HEX5). Switches
	are connected to GPIO input pins 28,29,30 respectively and two LEDS are connected to output
   pins 26 and 27. This servers as the top-level module for a parking lot car tracker system using 
	photosensors in this lab.
*/
module DE1_SoC (V_GPIO, CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
   input logic	CLOCK_50; 
   inout logic [35:0] V_GPIO; 
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 

	logic enter; // whether a car is entering the parking lot
	logic exit; // whether a car is exiting the parking lot
	logic new_enter; // whether a car is entering a non-full parking lot
	logic SW0, SW1, SW2; // switches 0-2, corresponding to detector signals a, b, and reset respectively
	logic [4:0] cars_parked; // number of cars in parking lot (5 bit number)
	
	// set switches 0-2 to values of GPIO input pins 28,29,30 respectively
	// update new_enter (see definition above)
	always_comb begin
	  SW0 = V_GPIO[28];
	  SW1 = V_GPIO[29];
	  SW2 = V_GPIO[30];
	  new_enter = enter & (cars_parked < 25);
	end
	
	// set GPIO output pins 26,27 (both hooked to a LED) to
   // the values of switch 0 and switch 1 respectively
	assign V_GPIO[26] = SW0;
	assign V_GPIO[27] = SW1;
	
	// instantiate parking_lot_change module to detect cars entering/exiting parking lot. 
	// Use Clock-50 for clock
	// Use 1-bit inputs SW2 for reset, SW0 for signal a, and SW1 for signal b
	// store 1-bit ouput indicating whether a car is entering or exiting parking lot
	parking_lot_change parking (.clk(CLOCK_50), .reset(SW2), .a(SW0), .b(SW1), .enter(enter), .exit(exit));
	
	// instantiate five_bit_counter module to track the number of cars in parking lot 
	// Use Clock-50 for clock
	// Use 1-bit inputs SW2 for reset, new_enter for inc, and exit for dec
	// store 5-bit ouput for number of cars parked
	five_bit_counter counter (.clk(CLOCK_50), .reset(SW2), .inc(new_enter), .dec(exit), .out(cars_parked));
	
	// instantiate car_count_display module to display the number of cars parked on HEX displays
	// pass in the number of cars parked to COUNT, and the six 7-bit HEX diplays used
	car_count_display count_display(.COUNT(cars_parked), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));
	
endmodule



/* Testbench for DE1_SoC covering expected, unexpected and edgecase behaviour */
module DE1_SoC_testbench();	

   logic	CLOCK_50; 
   wire [35:0] V_GPIO; 
   logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 
	
    // Instantiate the DE1_SoC module
    DE1_SoC dut (.V_GPIO(V_GPIO), .CLOCK_50(CLOCK_50), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));

    // Set up the clock
    parameter CLOCK_PERIOD = 10;  // Clock period in time units
    initial begin
        CLOCK_50 = 0;
        forever #(CLOCK_PERIOD / 2) CLOCK_50 = ~CLOCK_50;
    end
	 
	 // switches 0-2, connected to input V_PIO pins 28-30 respectively
	 logic SW2, SW1, SW0; 
	 assign V_GPIO[30] = SW2;
	 assign V_GPIO[29] = SW1;
	 assign V_GPIO[28] = SW0;
    
	 
	 initial begin
	  // reset
	 SW2 = 1; @(posedge CLOCK_50);
	 SW2 = 0; @(posedge CLOCK_50);
	 
	 // cars entering
	 SW0 = 1; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 0; @(posedge CLOCK_50);
	 
	 SW0 = 1; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 0; @(posedge CLOCK_50);
	 
	 SW0 = 1; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 0; @(posedge CLOCK_50);
	 
	 // cars entering but stalling while doing so
	 SW0 = 1; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 0; @(posedge CLOCK_50);
	 
	 SW0 = 1; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 0; @(posedge CLOCK_50);
	 
	 
	 // cars exiting
	 SW0 = 0; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 0; @(posedge CLOCK_50);
	 
	 
	 SW0 = 0; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 0; @(posedge CLOCK_50);
	 
	 SW0 = 0; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 0; @(posedge CLOCK_50);
	 
	  // cars exiting but stalling while doing so
	 SW0 = 0; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 0; @(posedge CLOCK_50);
	 
	 
	 SW0 = 0; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 0; @(posedge CLOCK_50);
	 
	 
	 // car almost enters but backtracks
	 SW0 = 0; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 1; @(posedge CLOCK_50);
	 
	 // pedestrian walks by
	 
	 SW0 = 0; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 1; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 0; @(posedge CLOCK_50);
	 
	 // another pedestrian walks by, opposite direction
	 
	 SW0 = 1; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 0; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 1; @(posedge CLOCK_50);
	 SW0 = 0; SW1 = 0; @(posedge CLOCK_50);
	 end

endmodule  // DE1_SoC_testbench