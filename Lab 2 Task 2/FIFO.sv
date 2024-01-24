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
    parameter depth = 32,  // Assuming the depth matches the memory's addressable depth
    parameter width = 4    // Assuming the width matches the memory's data width
)(
    input logic clk, reset,
    input logic read, write,
    input logic [width-1:0] inputBus,
    output logic empty, full,
    output logic [width-1:0] outputBus
);

    logic wr_en;
    logic [depth-1:0] readAddr, writeAddr;

    // Instantiate FIFO Control
    // The FIFO_Control module manages read and write operations and tracks the FIFO's status.
    FIFO_Control #(depth) control (
        .clk(clk),
        .reset(reset),
        .read(read),
        .write(write),
        .wr_en(wr_en),
        .empty(empty),
        .full(full),
        .readAddr(readAddr),
        .writeAddr(writeAddr)
    );

    // Instantiate Dual-Port RAM
    // The ram32x4 module provides memory storage for the FIFO, with separate read and write addresses.
    ram32x4 memory (
        .clock(clk),
        .data(inputBus),
        .rdaddress(readAddr),
        .wraddress(writeAddr),
        .wren(wr_en),
        .q(outputBus)
    );

endmodule
