// pipeline state reg for IXU pipe between decode and execution
module ixu_id_ex
(
    input   logic           clk,
    input   logic           rst,
    input   logic           stall,
    input   logic [3:0]     op_in,
    input   logic           is_nop_in,
    input   logic           is_imm_type_in,
    input   logic [4:0]     rs1_in,
    input   logic [4:0]     rs2_in,
    input   logic [4:0]     rd_in,
    input   logic [11:0]    imm_in,
    output  logic [3:0]     op_out,
    output  logic           is_nop_out,
    output  logic           is_imm_type_out,
    output  logic [4:0]     rs1_out,
    output  logic [4:0]     rs2_out,
    output  logic [4:0]     rd_out,
    output  logic [11:0]    imm_out
);

always_ff @(posedge clk or posedge rst) begin

    if (rst == 1'b1) begin
        op_out <= '0;
        // TODO: check if issuing NOP on reset causes probs
        is_nop_out <= '1;
        is_imm_type_out <= '0;
        rs1_out <= '0;
        rs2_out <= '0;
        rd_out <= '0;
        imm_out <= '0;
    end
    else if (stall == 1'b1) begin
        op_out <= op_out;
        is_nop_out <= is_nop_out;
        is_imm_type_out <= is_imm_type_out;
        rs1_out <= rs1_out;
        rs2_out <= rs2_out;
        rd_out <= rd_out;
        imm_out <= imm_out;
    end
    else begin
        op_out <= op_in;
        // TODO: check if issuing NOP on reset causes probs
        is_nop_out <= is_nop_in;
        is_imm_type_out <= is_imm_type_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
        rd_out <= rd_in;
        imm_out <= imm_in;
    end

end

endmodule