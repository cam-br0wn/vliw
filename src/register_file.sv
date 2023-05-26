module register_file (
  input   logic         clk,
  input   logic         rst,
  
  // LSU ports
  input   logic [4:0]   lsu_rs1,
  input   logic [4:0]   lsu_rs2,
  input   logic [4:0]   lsu_rd,
  input   logic [31:0]  lsu_wr_data,
  input   logic         lsu_wr_en,
  output  logic [31:0]  lsu_rs1_data,
  output  logic [31:0]  lsu_rs2_data,

  // IXU1 ports
  input   logic [4:0]   ixu1_rs1,
  input   logic [4:0]   ixu1_rs2,
  input   logic [4:0]   ixu1_rd,
  input   logic [31:0]  ixu1_wr_data,
  input   logic         ixu1_wr_en,
  output  logic [31:0]  ixu1_rs1_data,
  output  logic [31:0]  ixu1_rs2_data,

  // IXU2 ports
  input   logic [4:0]   ixu2_rs1,
  input   logic [4:0]   ixu2_rs2,
  input   logic [4:0]   ixu2_rd,
  input   logic [31:0]  ixu2_wr_data,
  input   logic         ixu2_wr_en,
  output  logic [31:0]  ixu2_rs1_data,
  output  logic [31:0]  ixu2_rs2_data,

  // BRANCH ports
  input   logic [4:0]   branch_rs1,
  input   logic [4:0]   branch_rs2,
  input   logic [4:0]   branch_rd,
  input   logic [31:0]  branch_wr_data,
  input   logic         branch_wr_en,
  output  logic [31:0]  branch_rs1_data,
  output  logic [31:0]  branch_rs2_data
);

  // 32x 32b registers
  logic [4:0] regs [0:31];

  // logic no_dest_reg_overlap = (lsu_rd == ixu1_rd || (lsu_rd == ixu2_rd || ixu1_rd == ixu2_rd)) ? '0 : '1;

  always_ff @(posedge clk) begin
    if (rst == 1'b1) begin
      for (int i = 0; i < 32; i = i+1) begin
        regs[i] <= '0;
      end
    end
    else begin
      if (lsu_wr_en == 1'b1) begin
        regs[lsu_rd] <= lsu_wr_data;
      end
      if (ixu1_wr_en == 1'b1) begin
        regs[ixu1_rd] <= ixu1_wr_data;
      end
      if (ixu2_wr_en == 1'b1) begin
        regs[ixu2_rd] <= ixu2_wr_data;
      end
      if (branch_wr_en == 1'b1) begin
        regs[branch_rd] <= branch_wr_data;
      end
    end
  end

  // drive reads constantly
  // LSU reads
  assign lsu_rs1_data = regs[lsu_rs1];
  assign lsu_rs2_data = regs[lsu_rs2];

  // IXU1 reads
  assign ixu1_rs1_data = regs[ixu1_rs1];
  assign ixu1_rs2_data = regs[ixu1_rs2];

  // IXU2 reads
  assign ixu2_rs1_data = regs[ixu2_rs1];
  assign ixu2_rs2_data = regs[ixu2_rs2];

  // BRANCH reads
  assign branch_rs1_data = regs[branch_rs1];
  assign branch_rs2_data = regs[branch_rs2];

endmodule
