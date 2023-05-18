module main_memory(
  input logic clk,
  input logic [31:0] wr_addr,
  input logic [31:0] wr_data,
  input logic        wr_en,
  input logic [31:0] rd_addr,
  output logic [31:0] data_out
);

  // Define the memory array
  logic [31:0] mem [0:255];

  // Write to the memory array when write_en is high
  always_ff @(posedge clk) begin
    if (wr_en) mem[addr] <= data_in;
  end

  // Read from the memory array
  always_ff @(posedge clk) begin
    data_out <= mem[addr];
  end

endmodule
