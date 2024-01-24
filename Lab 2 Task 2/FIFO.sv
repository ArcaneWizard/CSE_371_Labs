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
    logic [$clog2(depth)-1:0] readAddr, writeAddr;

    // Instantiate FIFO Control
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
    ram32x4 memory (
        .clock(clk),
        .data(inputBus),
        .rdaddress(readAddr),
        .wraddress(writeAddr),
        .wren(wr_en),
        .q(outputBus)
    );

endmodule
