module register_file (
  input  logic clk,
  // need to give each execution pipe it's own ports
  // LSU ports
  input   logic [4:0]   lsu_rs1,
  input   logic [4:0]   lsu_rs2,
  input   logic [4:0]   lsu_rd,
  input   logic [4:0]   lsu_wr_addr,
  input   logic [31:0]  lsu_wr_data,
  input   logic         lsu_wr_en,
  output  logic [31:0]  lsu_rd_data1,
  output  logic [31:0]  lsu_rd_data2
);

  logic [4:0] regs [0:31];

  always_ff @(posedge clk) begin
    if (wr_en) begin
      regs[wr_addr] <= wr_data;
    end
  end

  assign rd_data1 = regs[rd_addr1];
  assign rd_data2 = regs[rd_addr2];

endmodule
