/* Raghav Narula, Pedro Amarante
   1/23/2024
   CSE 371
   Lab 2, Task 3

   This module is the control unit for a FIFO (First-In-First-Out) buffer.
   It manages the read and write pointers, and keeps track of the FIFO's status, including whether it is empty or full.
   The module takes a clock (clk) and reset signal as inputs, along with read and write control signals.
   The FIFO's depth is parameterized, allowing for flexible buffer size.
   Outputs include write enable (wr_en), empty and full status signals, and the current read and write addresses.
*/

module FIFO_Control #(
    parameter depth = 5,
	 parameter width = 4
)(
    input logic clk, reset,
    input logic read, write,
	 input logic [width-1:0] frontValue,
    output logic wr_en,
    output logic empty, full,
    output logic [depth-1:0] readAddr, writeAddr,
	 output logic [width-1:0] readValue
);

    // Read and write pointers
    logic [depth-1:0] read_ptr, write_ptr;
    
    // FIFO count to track the number of elements in the FIFO
    logic [depth-1:0] fifo_count;
	 
	 logic [depth-1:0] fullCount = 2**depth-1;

    // FIFO status signals
    assign empty = (fifo_count == 0);
    assign full = (fifo_count == fullCount);

    // Write enable signal, active when write is requested and FIFO is not full
    assign wr_en = write && !full;

    // Current read and write addresses
    assign readAddr = read_ptr;
    assign writeAddr = write_ptr;

    // Sequential logic to update pointers and FIFO count
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset pointers and count
            read_ptr <= 0;
            write_ptr <= 0;
            fifo_count <= 0;
				readValue <= 7'b1000000;
        end
        else begin
            // Update write pointer and count on write request
            if (write && !full) begin
				    write_ptr <= (write == fullCount) ? 0 : write_ptr + 1;
                fifo_count <= fifo_count + 1;
            end
            // Update read pointer and count on read request
            if (read && !empty) begin
				    readValue <= frontValue;
				    read_ptr <= (read == fullCount) ? 0 : read_ptr + 1;
                fifo_count <= fifo_count - 1;
            end
				else if (read && empty) begin
				    readValue <= 7'b1000000;
				end
        end
    end

endmodule

/* FIFO_Control tests covering expected, unexpected and edgecase behaviour */
module FIFO_Control_testbench();
    
    parameter depth = 5, width = 4;
    logic clk, reset, read, write;
    logic [width-1:0] frontValue, readValue;
    logic wr_en, empty, full;
    logic [depth-1:0] readAddr, writeAddr;

    logic [depth-1:0] fullCount = 2**depth-1;

    // Instantiate the FIFO_Control module
    FIFO_Control #(depth, width) dut (
        .clk(clk), 
        .reset(reset), 
        .read(read), 
        .write(write), 
        .frontValue(frontValue),
        .wr_en(wr_en),
        .empty(empty), 
        .full(full), 
        .readAddr(readAddr), 
        .writeAddr(writeAddr),
        .readValue(readValue)
    );

    // Sset up the clock
    parameter CLOCK_PERIOD = 10;  // Clock period in time units
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        // initialize inputs
        reset = 1; read = 0; write = 0; frontValue = 0;
        @(posedge clk);  
        reset = 0;
        @(posedge clk);  

        // test writing to the fifo
        write = 1; frontValue = 4'hA; @(posedge clk);
        write = 1; frontValue = 4'hB; @(posedge clk);
        write = 0;

        // test reading from the FIFO
        read = 1; @(posedge clk);
        read = 1; @(posedge clk);
        read = 0;

        // Test FIFO full condition
        repeat(fullCount) begin
            write = 1; frontValue = frontValue + 1; @(posedge clk);
        end
        write = 0;

        // test FIFO empty condition
        repeat(fullCount) begin
            read = 1; @(posedge clk);
        end
        read = 0;

        //  Test reset functionality
        reset = 1; @(posedge clk);
        reset = 0; @(posedge clk); 

        
    end

endmodule  // FIFO_Control_testbench
