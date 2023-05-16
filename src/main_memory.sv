module main_memory(
  input wire clk,
  input wire [7:0] addr,
  input wire [7:0] data_in,
  input wire write_en,
  output reg [7:0] data_out
);

  // Define the memory array
  logic [31:0] mem [0:255];

  // Write to the memory array when write_en is high
  always_ff @(posedge clk) begin
    if (write_en) mem[addr] <= data_in;
  end

  // Read from the memory array
  always_ff @(posedge clk) begin
    data_out <= mem[addr];
  end

endmodule
