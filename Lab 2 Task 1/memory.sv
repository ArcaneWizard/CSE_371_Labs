

/* Raghav Narula, Pedro Amarante
   1/21/2024
	CSE 371
	Lab 2, Task 1
   
	Implementation of a RAM unit on an FPGA 
*/

module memory
  (
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
  output logic [9:0] LEDR,
  input  logic [3:0] KEY,     // True when not pressed, False when pressed
  input  logic [9:0] SW
  );
  
  logic [3:0] memory_array[31:0];
  logic [3:0] dataIn; 
  logic [4:0] address;
  logic [3:0] dataOut;
  logic write;
  logic clock;
  
  assign dataIn = SW[3:0];
  assign address = SW[8:4];

  assign write = SW[9];
  assign clock = ~KEY[0];
  
  assign HEX3 = ~7'b0000000;
  assign HEX1 = ~7'b0000000;
  
  display_num_on_hex address_byte_two (.num(address[4]), .HEX(HEX5));
  display_num_on_hex address_byte_one (.num(address[3:0]), .HEX(HEX4));
  display_num_on_hex data_in_display (.num(dataIn), .HEX(HEX2));
  display_num_on_hex data_out_display (.num(dataOut), .HEX(HEX0));
  
  
  assign dataOut = memory_array[address];
  
   always_ff@(posedge clock) begin
        if (write) begin
            memory_array[address] <= dataIn;
        end
    end
    
endmodule  // DE1_SoC

module memory_tb();

    // Inputs
    logic clock;
    logic [3:0] KEY;
    logic [9:0] SW;

    // Outputs
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [9:0] LEDR;

    
    memory dut ( 
        .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
        .LEDR(LEDR),
        .KEY(KEY), 
        .SW(SW)
    );
	 
	 assign KEY[0] = clock;

    parameter CLOCK_PERIOD=100;
      initial begin
         clock <= 0;
         forever #(CLOCK_PERIOD/2) clock <= ~clock;
      end

    // Testbench stimulus
    initial begin
        // Initialize Inputs
        KEY <= 4'b1111; @(posedge clock);
              
        // Write and read a value
        SW[9] <= 1'b1;  // Enable write
        SW[8:4] <= 5'b00010;  // Address
        SW[3:0] <= 4'b1010;  // Data
        @(posedge clock);
        SW[9] <= 1'b0;  // Disable write
            @(posedge clock);
        // Change address to read
        SW[8:4] <= 5'b00010;
          @(posedge clock);
        
    end

endmodule