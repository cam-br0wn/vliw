module register_file (
  input  logic clk,
  input  logic [2:0] rd_addr1,
  input  logic [2:0] rd_addr2,
  input  logic [2:0] wr_addr,
  input  logic [31:0] wr_data,
  input  logic wr_en,
  output logic [31:0] rd_data1,
  output logic [31:0] rd_data2
);

  logic [31:0] regs [0:31];

  always_ff @(posedge clk) begin
    if (wr_en) begin
      regs[wr_addr] <= wr_data;
    end
  end

  assign rd_data1 = regs[rd_addr1];
  assign rd_data2 = regs[rd_addr2];

endmodule
