module FIFO_Control #(
    parameter depth = 4
)(
    input logic clk, reset,
    input logic read, write,
    output logic wr_en,
    output logic empty, full,
    output logic [depth-1:0] readAddr, writeAddr
);

    logic [depth-1:0] read_ptr, write_ptr;
    logic [depth-1:0] fifo_count;

    assign empty = (fifo_count == 0);
    assign full = (fifo_count == depth);
    assign wr_en = write && !full;
    assign readAddr = read_ptr;
    assign writeAddr = write_ptr;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            read_ptr <= 0;
            write_ptr <= 0;
            fifo_count <= 0;
        end
        else begin
            if (write && !full) begin
                write_ptr <= write_ptr + 1;
                fifo_count <= fifo_count + 1;
            end
            if (read && !empty) begin
                read_ptr <= read_ptr + 1;
                fifo_count <= fifo_count - 1;
            end
        end
    end

endmodule
