module five_bit_counter (clk, reset, inc, dec, out);

  input logic clk;
  input logic reset;
  input logic inc; // whether to increment the counter
  input logic dec; // whether to decrement the counter
  
  // current 5-bit value representing counter value
  output logic [4:0] out;

  // next 5-bit value for out (set on pos-edge of clock clk)
  // fOut is set to (out + 1) if inc equals 1
  // fOut is set to (out - 1) if dec equals 1
  // values bounded between 0 and 31 inclusive
  logic [4:0] fOut;
  
  always_comb begin
    if (inc) begin
       if (out == 5'b11111) fOut = 5'b11111;
       else fOut = out + 1'b1;
    end
    else if (dec) begin
       if (out == 5'b00000) fOut = 5'b00000;
       else fOut = out - 1'b1;
    end
	 else begin
	    // if inc and dec are set to 1 simultaneously, or both are set to 0,
		 // set fOut to out. the counter value won't change
	    fOut = out; 
    end
  end

  always_ff @(posedge clk) begin
    if (reset)
      out <= 5'b00000;
    else if (inc | dec)
      out <= fOut;
  end
  
endmodule