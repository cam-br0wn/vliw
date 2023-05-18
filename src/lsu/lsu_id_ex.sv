module lsu_id_ex
(
    input logic clk,
    input logic rst,
    input logic is_load_in,
    input logic zero_ext_in,
    input logic is_nop_in,
    input logic [1:0] size_in,
    input logic [4:0] rs1_in,
    input logic [4:0] rs2_in,
    input logic [4:0] rd_in,
    input logic [11:0] imm_in,
    output logic is_load_out,
    output logic zero_ext_out,
    output logic is_nop_out,
    output logic [1:0] size_out,
    output logic [4:0] rs1_out,
    output logic [4:0] rs2_out,
    output logic [4:0] rd_out,
    output logic [11:0] imm_out
);

always_ff @(posedge clk or posedge rst) begin

    if (rst) begin
        is_load_out <= '0;
        zero_ext_out <= '0;
        size_out <= '0;
        rs1_out <= '0;
        rs2_out <= '0;
        rd_out <= '0;
        imm_out <= '0;
        // TODO: check if issuing NOP on reset causes a problem
        // idea is that we don't want it to crash just because of a reset
        is_nop_out <= '1;
    end
    else begin
        is_load_out <= is_load_in;
        zero_ext_out <= zero_ext_in;
        size_out <= size_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
        rd_out <= rd_in;
        imm_out <= imm_in;
        is_nop_out <= is_nop_in;
    end

end

endmodule