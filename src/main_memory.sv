module main_memory
(
    input   logic         clk,
    input   logic         rst,
    // ports for LSU
    input   logic [31:0]  data_in,
    input   logic [31:0]  wr_addr,
    input   logic [31:0]  wr_data,
    input   logic         wr_en,
    input   logic [31:0]  rd_addr,
    input   logic         rd_en,
    output  logic [31:0]  data_out
    // ports for inst fetch
    input   logic [31:0]  pc_in,
    output  logic [127:0] inst_bundle_out
);

// Define the memory array
logic [31:0] mem [0:255];

// Write to the memory array when write_en is high
always_ff @(posedge clk) begin
    if (wr_en) mem[wr_addr] <= data_in;
end

// Read from the memory array
always_ff @(posedge clk) begin
    if (rd_en) data_out <= mem[rd_addr];
    inst_bundle_out <= mem[pc_in];
end

endmodule
