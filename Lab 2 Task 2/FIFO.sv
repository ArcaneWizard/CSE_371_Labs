/* Raghav Narula, Pedro Amarante
   1/23/2024
   CSE 371
   Lab 2, Task 2

   This module implements a FIFO (First-In-First-Out) memory buffer.
   It takes a clock (clk) and reset signal as inputs, along with read and write control signals.
   The FIFO has parameterized depth and width, allowing for flexible memory size and data width.
   The module interfaces with a dual-port RAM and a FIFO control unit to manage data storage and retrieval.
   Outputs include empty and full signals, indicating the FIFO's status, and the outputBus for data output.
*/

module FIFO #(
    parameter depth = 5,  // Assuming the depth matches the memory's addressable depth
    parameter width = 4    // Assuming the width matches the memory's data width
)(
    input logic clk, reset,
    input logic pop, push,
    input logic [width-1:0] pushedValue,
    output logic empty, full,
    output logic [width-1:0] poppedValue
);

    logic wr_en;
	 logic [width-1:0] frontValue;
    logic [depth-1:0] readAddr, writeAddr;

    // Instantiate FIFO Control
    // The FIFO_Control module manages read and write operations and tracks the FIFO's status.
    FIFO_Control #(depth, width) control (
        .clk(clk),
        .reset(reset),
        .read(pop),
        .write(push),
		  .frontValue(frontValue),
        .wr_en(wr_en),
        .empty(empty),
        .full(full),
        .readAddr(readAddr),
        .writeAddr(writeAddr),
		  .readValue(poppedValue)
    );

    // Instantiate Dual-Port RAM
    // The ram32x4 module provides memory storage for the FIFO, with separate read and write addresses.
    ram32x4 memory (
        .clock(clk),
        .data(pushedValue),
        .rdaddress(readAddr),
        .wraddress(writeAddr),
        .wren(wr_en),
        .q(frontvalue)
    );

endmodule

/* FIFO tests covering expected, unexpected and edgecase behaviour */
module FIFO_testbench();
    
    parameter depth = 5, width = 4;
    logic clk, reset, pop, push;
    logic [width-1:0] pushedValue, poppedValue;
    logic empty, full;


    FIFO #(depth, width) dut (
        .clk(clk),
        .reset(reset),
        .pop(pop),
        .push(push),
        .pushedValue(pushedValue),
        .empty(empty),
        .full(full),
        .poppedValue(poppedValue)
    );

   
    parameter CLOCK_PERIOD = 10;  // Clock period in time units
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        // init inputs
        reset = 1; pop = 0; push = 0; pushedValue = 0;
        @(posedge clk);
        reset = 0;
        @(posedge clk);

        // test pushing data 
        repeat(depth - 1) begin
            push = 1; pushedValue = pushedValue + 1; @(posedge clk);
        end
        push = 0;

        // Test FIFO full condition
        push = 1; pushedValue = pushedValue + 1; @(posedge clk);
        push = 0;

        // Test pop
        repeat(depth) begin
            pop = 1; @(posedge clk);
        end
        pop = 0;

        // Test FIFO empty
        pop = 1; @(posedge clk);
        pop = 0;

        // Test reset 
        reset = 1; @(posedge clk);
        reset = 0; @(posedge clk); 

        
    end

endmodule  // FIFO_testbench

