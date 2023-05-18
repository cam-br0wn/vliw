// integer pipeline register file between execution and writeback
module ixu_ex_wb
(
    input   logic           clk,
    input   logic           rst,
    input   logic           stall,
    input   logic           is_nop_in,
    input   logic [4:0]     rd_in,
    input   logic [31:0]    data_in,
    output  logic           is_nop_out,
    output  logic [4:0]     rd_out,
    output  logic [31:0]    data_out
);

always_ff @(posedge clk or posedge rst) begin

    if (rst == 1'b1) begin
        // TODO:  check if issuing NOP on reset causes probs
        is_nop_out <= '1;
        rd_out <= '0;
        data_out <= '0;
    end
    else if (stall == 1'b1) begin
        is_nop_out <= is_nop_out;
        rd_out <= rd_out;
        data_out <= data_out;
    end
    else begin
        is_nop_out <= is_nop_in;
        rd_out <= rd_in;
        data_out <= data_in;
    end
end

endmodule