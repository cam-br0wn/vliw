// writeback stage for integer ops
module ixu_writeback
(
    input   logic           is_nop,
    input   logic [4:0]     rd,
    input   logic [31:0]    data_in,
    output  logic [4:0]     rd_out,
    output  logic [31:0]    data_out,
    output  logic           wr_en
);

always_comb begin

    if (is_nop) begin
        rd_out = '0;
        data_out = '0;
        wr_en = '0;
    end else begin
        rd_out = rd;
        data_out = data_in;
        wr_en = '1;
    end

end

endmodule