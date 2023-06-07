// execution stage for LSU
// this module is designed to make memory accesses

// The first pass at this module assumes 1 cycle of latency in memory access
// Also assumes that register reads are combinational (no latency)
// This is obviously unsustainable in a real implementation

module lsu_execute
(
    input   logic           is_load,
    input   logic           is_nop,
    input   logic           is_rs1_fwd,
    input   logic           is_rs2_fwd,
    input   logic [1:0]     size,
    input   logic [31:0]    rs1_fwd_data,
    input   logic [31:0]    rs2_fwd_data,
    input   logic [11:0]    imm,
    input   logic [31:0]    rs1_data,
    input   logic [31:0]    rs2_data,
    output  logic [31:0]    wr_addr,
    output  logic [31:0]    wr_data,
    output  logic           wr_en,
    output  logic [31:0]    rd_addr,
    output  logic           rd_en
);

// forwarding logic
logic [31:0] internal_rs1_data;
logic [31:0] internal_rs2_data;

assign internal_rs1_data = (is_rs1_fwd == 1'b1) ? rs1_fwd_data : rs1_data;
assign internal_rs2_data = (is_rs2_fwd == 1'b1) ? rs2_fwd_data : rs2_data;

always_comb begin
    // if LOAD
    if (is_load == 1'b1 && is_nop == 1'b0) begin
        rd_addr = internal_rs1_data + $signed({{20{imm[11]}}, imm}); // explictly sign-extend immediate
        rd_en = '1;
        wr_addr = '0;
        wr_data = '0;
        wr_en = '0;
    end
    // if STORE
    else if (is_load == 1'b0 && is_nop == 1'b0) begin
        rd_addr = '0;
        rd_en = '0;
        wr_addr = internal_rs1_data + $signed({{20{imm[11]}}, imm}); // explicitly sign-extend immediate
        wr_data = internal_rs2_data;
        wr_en = 1'b1;
    end
    // if NOP
    else if (is_nop == 1'b1) begin
        rd_addr = '0;
        rd_en = '0;
        wr_addr = '0;
        wr_data = '0;
        wr_en = '0;
    end else begin
        $error("LSU EX: could not determine instruction type");
    end

end


endmodule