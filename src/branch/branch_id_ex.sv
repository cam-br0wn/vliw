// ID/EX state register for branch pipeline

module branch_id_ex
(
    input   logic           clk,
    input   logic           rst,
    input   logic           stall,
    input   logic           is_nop_in,
    input   logic           is_jmp_in,
    input   logic           is_imm_type_in,
    input   logic           zero_ext_in,
    input   logic [1:0]     op_in,
    input   logic [4:0]     rs1_in,
    input   logic [4:0]     rs2_in,
    input   logic [4:0]     rd_in,
    input   logic [21:0]    imm_in,
    output  logic           is_nop_out,
    output  logic           is_jmp_out,
    output  logic           is_imm_type_out,
    output  logic           zero_ext_out,
    output  logic [1:0]     op_out,
    output  logic [4:0]     rs1_out,
    output  logic [4:0]     rs2_out,
    output  logic [4:0]     rd_out,
    output  logic [21:0]    imm_out
);

always_ff @(posedge clk or posedge rst) begin

    if (rst == 1'b1) begin
        is_nop_out <= '1;
        is_jmp_out <= '0;
        is_imm_type_out <= '0;
        zero_ext_out <= '0;
        op_out <= '0;
        rs1_out <= '0;
        rs2_out <= '0;
        rd_out <= '0;
        imm_out <= '0;
    end

    // if stall, preserve state
    else if (stall == 1'b1) begin
        is_nop_out <= is_nop_out;
        is_jmp_out <= is_jmp_out;
        is_imm_type_out <= is_imm_type_out;
        zero_ext_out <= zero_ext_out;
        op_out <= op_out;
        rs1_out <= rs1_out;
        rs2_out <= rs2_out;
        rd_out <= rd_out;
        imm_out <= imm_out;
    end

    else begin
        is_nop_out <= is_nop_in;
        is_jmp_out <= is_jmp_in;
        is_imm_type_out <= is_imm_type_in;
        zero_ext_out <= zero_ext_in;
        op_out <= op_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
        rd_out <= rd_in;
        imm_out <= imm_in;
    end

end

endmodule