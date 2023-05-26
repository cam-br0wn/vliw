// hazard detection unit to issue stalls across all pipelines
// two main things:
// 1. Read-After-Write hazards for Loads only
//      > Other RAWs should be eliminated by forwarding unit
// 2. Control hazards from taken branches
//      > should result in squashed decode, replaced with a NOP
//      > i.e. cycle following branch-taken results has NOP in all pipes of exec
module hazard_detection
(
    // LSU execution dest reg
    input   logic [4:0]         lsu_ex_rd,
    input   logic               lsu_ex_is_load,
    // decode src regs
    input   logic [4:0]         ixu1_dc_rs1,
    input   logic [4:0]         ixu1_dc_rs2,
    input   logic [4:0]         ixu2_dc_rs1,
    input   logic [4:0]         ixu2_dc_rs2,
    input   logic [4:0]         lsu_dc_rs1,
    input   logic [4:0]         lsu_dc_rs2,
    // stall output signal
    output  logic               stall_out,

    // branch taken
    input   logic               branch_taken,
    // squash output signal
    output  logic               squash_out
);

// RAW from loads portion
always_comb begin
    stall_out = (
        ((ixu1_dc_rs1 == lsu_ex_rd) || 
        (ixu1_dc_rs2 == lsu_ex_rd) || 
        (ixu2_dc_rs1 == lsu_ex_rd) || 
        (ixu2_dc_rs2 == lsu_ex_rd) || 
        (lsu_dc_rs1 == lsu_ex_rd) || 
        (lsu_dc_rs2 == lsu_ex_rd)) && lsu_ex_is_load 
    ) ? '1 : '0;
end

// control hazards
always_comb begin
    squash_out = branch_taken;
end

endmodule