
/* Raghav Narula, Pedro Amarante
   1/13/2024
	CSE 371
	Lab 1, Task 1
   
	Displays the number of cars parked (and potentially a bonus msg) 
   on HEX segment displays. Takes an input COUNT (number of carks parked)
	and returns 7-bit HEX0, HEX1, HEX2, HEX3, HEX4, HEX5.
*/

module car_count_display (COUNT, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
   input  logic [4:0] COUNT; // number of cars parked (5-bit number)
   output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; // 6 HEX segment displays (each 7 bits)
   
	// store the ones and tens digit of the number of cars parked. use 4-bit values
	logic [3:0] ones_digit, tens_digit;
	assign ones_digit = COUNT % 10;
	assign tens_digit = COUNT / 10;
		 
   // set temp_HEX0 and temp_HEX1 (7-bits) to save how to display 
	// the ones and tens digit of the number of cars parked
	logic [6:0] temp_HEX0;
	logic [6:0] temp_HEX1;
   display_num_on_hex ones (.num(ones_digit), .HEX(temp_HEX0));
	display_num_on_hex tens (.num(tens_digit), .HEX(temp_HEX1));
	
	// Display number of cars parked on HEX 0-5:
	// The number appears on HEX0 if zero, and HEX0-HEX1 if non-zero
	// A bonus message appears on other HEXs (between HEX0-HEX5) sometimes
   always_comb begin
       // display CLEAR 0
	   if (COUNT == 0) begin
		  HEX5 = ~7'b0111001; // C
		  HEX4 = ~7'b0110000; // l
		  HEX3 = ~7'b1111001; // E
		  HEX2 = ~7'b1110111; // A
		  HEX1 = ~7'b1010000; // r
		  HEX0 = ~7'b0111111; // 0
		end
		
		// display Full, followed by number
		else if (COUNT >= 25) begin
         HEX5 = ~7'b1110001; // F
         HEX4 = ~7'b0011100; // u
         HEX3 = ~7'b0110000; // l
         HEX2 = ~7'b0110000; // l
         HEX1 = temp_HEX1; // tens digit
		   HEX0 = temp_HEX0; // ones digit
		end
		
		// just display number
		else begin
		   HEX5 = 7'b1111111; // empty
         HEX4 = 7'b1111111; // empty
         HEX3 = 7'b1111111; // empty
         HEX2 = 7'b1111111; // empty
         HEX1 = temp_HEX1; // tens digit
		   HEX0 = temp_HEX0; // ones digit
		end
	end
endmodule

/* car_count_display tests covering expected, unexpected and edgecase behaviour */
module car_count_display_testbench();
	 
   logic [4:0] COUNT;
   logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    // Instantiate the car_count_display module
    car_count_display dut (.COUNT(COUNT), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));
   
	 // test all car count values between 0 and 25 (maximum parking space) inclusive
	 // check if the Hex segment displays update to display the right number (and msg where applicable)
    initial begin
		 for(int i = 0; i <= 25; i++) begin
			COUNT = i; #10;
		 end
    end

endmodule  //car_count_display_testbench