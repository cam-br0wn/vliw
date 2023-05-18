// execution stage for LSU
// this module is designed to make memory accesses

// The first pass at this module assumes 1 cycle of latency in memory access
// Also assumes that register reads are combinational (no latency)
// This is obviously unsustainable in a real implementation

module lsu_execute
(
    input   logic           is_load,
    input   logic           is_nop,
    input   logic [11:0]    imm,
    input   logic [31:0]    rs1_data,
    input   logic [31:0]    rs2_data,
    output  logic [31:0]    wr_addr,
    output  logic [31:0]    wr_data,
    output  logic           wr_en,
    output  logic [31:0]    rd_addr
);

always_comb begin
    // if LOAD
    if (is_load == 1'b1 && is_nop == 1'b0) begin
        rd_addr = rs1_data + $signed({{20{imm[11]}}, imm}); // explictly sign-extend immediate
        wr_addr = '0;
        wr_data = '0;
        wr_en = '0;
    end
    // if STORE
    else if (is_load == 1'b0 && is_nop == 1'b0) begin
        rd_addr = '0;
        wr_addr = rs1 + $signed({{20{imm[11]}}, imm}); // explicitly sign-extend immediate
        wr_data = rs2_data;
        wr_en = 1'b1;
    end
    // if NOP
    else if (is_nop == 1'b1) begin
        rd_addr = '0;
        wr_addr = '0;
        wr_data = '0;
        wr_en = '0;
    end else begin
        $error("LSU EX: could not determine instruction type");
    end

end


endmodule