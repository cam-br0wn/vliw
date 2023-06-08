// second pipeline state register for LSU

module lsu_ex_wb
(
    input   logic           clk,
    input   logic           rst,
    input   logic           stall,
    input   logic           is_load_in,
    input   logic           zero_ext_in,
    input   logic           is_nop_in,
    input   logic [1:0]     size_in,
    input   logic [4:0]     rd_in,
    output  logic           is_load_out,
    output  logic           zero_ext_out,
    output  logic           is_nop_out,
    output  logic [1:0]     size_out,
    output  logic [4:0]     rd_out
);

always_ff @(posedge clk or posedge rst) begin

    if (rst == 1'b1) begin
        is_load_out <= '0;
        zero_ext_out <= '0;
        // TODO: check if issuing NOP on reset causes probs
        is_nop_out <= '1;
        size_out <= '0;
        rd_out <= '0;
    end
    else begin
        is_load_out <= is_load_in;
        zero_ext_out <= zero_ext_in;
        is_nop_out <= is_nop_in;
        size_out <= size_in;
        rd_out <= rd_in;
    end

end

endmodule