
module one_sec_clock (clock, new_clock);
	input  logic  clock;
	output logic new_clock;
	
	
  logic [31:0] divided_clocks;

	initial
		divided_clocks = 0;

	always_ff @(posedge clock) begin
	
	   if (divided_clocks == 50000000) begin
		     new_clock <= 1;
			  divided_clocks <= 0;
		end
	   else begin
		   divided_clocks <= divided_clocks + 1;
			new_clock <= 0;
		end
		
	end
        
endmodule