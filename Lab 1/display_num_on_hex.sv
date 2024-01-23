
/* Raghav Narula, Pedro Amarante
   1/13/2024
	CSE 371
	Lab 1, Task 1
   
	This module takes a single digit number (4-bit num) as input. It outputs  
	a 7-bit HEX representing that number displayed visually on a 7-segment HEX display.
*/

module display_num_on_hex (num, HEX);
   input  logic [3:0] num;
   output logic [6:0] HEX;
   
	// set the HEX segment display to visually depict num
   //	when num lies in [0,9]
   always_comb begin
			case (num)
				4'b0000: HEX = ~7'b0111111; // 0
				4'b0001: HEX = ~7'b0000110; // 1
				4'b0010: HEX = ~7'b1011011; // 2
				4'b0011: HEX = ~7'b1001111; // 3
				4'b0100: HEX = ~7'b1100110; // 4
				4'b0101: HEX = ~7'b1101101; // 5
				4'b0110: HEX = ~7'b1111101; // 6
				4'b0111: HEX = ~7'b0000111; // 7
				4'b1000: HEX = ~7'b1111111; // 8
				4'b1001: HEX = ~7'b1101111; // 9
				default: HEX = 7'bX;
			endcase
		end
endmodule


/* display_num_on_hex tests covering expected, unexpected and edgecase behaviour */
module display_num_on_hex_testbench();
	 
    logic [3:0] num;
    logic [6:0] HEX;
	
    // Instantiate the display_num_on_hex module
    display_num_on_hex dut (.num(num), .HEX(HEX));
    
	 // test all hex segment outputs for num values between 0-9
    initial begin
	   for(int i = 0; i <= 9; i++) begin
			num = i; #10;
		 end
    end

endmodule  // display_num_on_hex_testbench