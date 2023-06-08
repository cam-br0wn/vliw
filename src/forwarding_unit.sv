// module to foward data from wb directly to execute
module forwarding_unit
(
    // writeback destination registers
    input   logic [4:0]         ixu1_wb_rd,
    input   logic [4:0]         ixu2_wb_rd,
    input   logic [4:0]         lsu_wb_rd,
    input   logic               lsu_wb_is_load,
    // note lack of branch writeback stage

    // writeback data
    input   logic [31:0]        ixu1_wb_data,
    input   logic [31:0]        ixu2_wb_data,
    input   logic [31:0]        lsu_wb_data,

    // if they're nops, don't want to forward
    input   logic               ixu1_wb_nop,
    input   logic               ixu2_wb_nop,
    input   logic               lsu_wb_nop,

    // execute source registers
    input   logic [4:0]         ixu1_ex_rs1,
    input   logic [4:0]         ixu1_ex_rs2,
    input   logic [4:0]         ixu2_ex_rs1,
    input   logic [4:0]         ixu2_ex_rs2,
    input   logic [4:0]         lsu_ex_rs1,
    input   logic [4:0]         lsu_ex_rs2,
    input   logic [4:0]         branch_ex_rs1,
    input   logic [4:0]         branch_ex_rs2,

    // forwarding activation lines
    output  logic               ixu1_rs1_fwd,
    output  logic               ixu1_rs2_fwd,
    output  logic               ixu2_rs1_fwd,
    output  logic               ixu2_rs2_fwd,
    output  logic               lsu_rs1_fwd,
    output  logic               lsu_rs2_fwd,
    output  logic               branch_rs1_fwd,
    output  logic               branch_rs2_fwd,
    // these signals will be the selector bits for muxes within execute stages to pick either reg file or wb data

    // need to encode where the data is coming from for each unit
    output  logic [31:0]        ixu1_rs1_fwd_data,
    output  logic [31:0]        ixu1_rs2_fwd_data,
    output  logic [31:0]        ixu2_rs1_fwd_data,
    output  logic [31:0]        ixu2_rs2_fwd_data,
    output  logic [31:0]        lsu_rs1_fwd_data,
    output  logic [31:0]        lsu_rs2_fwd_data,
    output  logic [31:0]        branch_rs1_fwd_data,
    output  logic [31:0]        branch_rs2_fwd_data
);

// IXU1 RS1
always_comb begin
    if ((ixu1_ex_rs1 == ixu1_wb_rd) && (ixu1_wb_rd != '0) && ~ixu1_wb_nop) begin
        ixu1_rs1_fwd = '1;
        ixu1_rs1_fwd_data = ixu1_wb_data;
    end
    else if ((ixu1_ex_rs1 == ixu2_wb_rd) && (ixu2_wb_rd != '0) && ~ixu2_wb_nop) begin
        ixu1_rs1_fwd = '1;
        ixu1_rs1_fwd_data = ixu2_wb_data;
    end
    // if memory latency is just 1 cycle, we can fwd loads
    else if ((ixu1_ex_rs1 == lsu_wb_rd) && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
        ixu1_rs1_fwd = '1;
        ixu1_rs1_fwd_data = lsu_wb_data;
    end
    // use this one otherwise
    // else if ((ixu1_ex_rs1 == lsu_wb_rd) && ~lsu_wb_is_load && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
    //     ixu1_rs1_fwd = '1;
    //     ixu1_rs1_fwd_data = lsu_wb_data;
    // end
    else begin
        ixu1_rs1_fwd = '0;
        ixu1_rs1_fwd_data = '0;
    end
end

// IXU1 RS2
always_comb begin
    if ((ixu1_ex_rs2 == ixu1_wb_rd) && (ixu1_wb_rd != '0) && ~ixu1_wb_nop) begin
        ixu1_rs2_fwd = '1;
        ixu1_rs2_fwd_data = ixu1_wb_data;
    end
    else if ((ixu1_ex_rs2 == ixu2_wb_rd) && (ixu2_wb_rd != '0) && ~ixu2_wb_nop) begin
        ixu1_rs2_fwd = '1;
        ixu1_rs2_fwd_data = ixu2_wb_data;
    end
    else if ((ixu1_ex_rs2 == lsu_wb_rd) && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
        ixu1_rs2_fwd = '1;
        ixu1_rs2_fwd_data = lsu_wb_data;
    end
    // use if mem latency > 1 cycle
    // else if ((ixu1_ex_rs2 == lsu_wb_rd) && ~lsu_wb_is_load && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
    //     ixu1_rs2_fwd = '1;
    //     ixu1_rs2_fwd_data = lsu_wb_data;
    // end
    else begin
        ixu1_rs2_fwd = '0;
        ixu1_rs2_fwd_data = '0;
    end
end

// IXU2 RS1
always_comb begin
    if ((ixu2_ex_rs1 == ixu1_wb_rd) && (ixu1_wb_rd != '0) && ~ixu1_wb_nop) begin
        ixu2_rs1_fwd = '1;
        ixu2_rs1_fwd_data = ixu1_wb_data;
    end
    else if ((ixu2_ex_rs1 == ixu2_wb_rd) && (ixu2_wb_rd != '0) && ~ixu2_wb_nop) begin
        ixu2_rs1_fwd = '1;
        ixu2_rs1_fwd_data = ixu2_wb_data;
    end
    else if ((ixu2_ex_rs1 == lsu_wb_rd) && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
        ixu2_rs1_fwd = '1;
        ixu2_rs1_fwd_data = lsu_wb_data;
    end
    // use if mem latency > 1 cycle
    // else if ((ixu2_ex_rs1 == lsu_wb_rd) && ~lsu_wb_is_load && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
    //     ixu2_rs1_fwd = '1;
    //     ixu2_rs1_fwd_data = lsu_wb_data;
    // end
    else begin
        ixu2_rs1_fwd = '0;
        ixu2_rs1_fwd_data = '0;
    end
end

// IXU2 RS2
always_comb begin
    if ((ixu2_ex_rs2 == ixu1_wb_rd) && (ixu1_wb_rd != '0) && ~ixu1_wb_nop) begin
        ixu2_rs2_fwd = '1;
        ixu2_rs2_fwd_data = ixu1_wb_data;
    end
    else if ((ixu2_ex_rs2 == ixu2_wb_rd) && (ixu2_wb_rd != '0) && ~ixu2_wb_nop) begin
        ixu2_rs2_fwd = '1;
        ixu2_rs2_fwd_data = ixu2_wb_data;
    end
    else if ((ixu2_ex_rs2 == lsu_wb_rd) && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
        ixu2_rs2_fwd = '1;
        ixu2_rs2_fwd_data = lsu_wb_data;
    end
    // use if mem latency > 1 cycle
    // else if ((ixu2_ex_rs2 == lsu_wb_rd) && ~lsu_wb_is_load && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
    //     ixu2_rs2_fwd = '1;
    //     ixu2_rs2_fwd_data = lsu_wb_data;
    // end
    else begin
        ixu2_rs2_fwd = '0;
        ixu2_rs2_fwd_data = '0;
    end
end

// LSU RS1
always_comb begin
    if ((lsu_ex_rs1 == ixu1_wb_rd) && (ixu1_wb_rd != '0) && ~ixu1_wb_nop) begin
        lsu_rs1_fwd = '1;
        lsu_rs1_fwd_data = ixu1_wb_data;
    end
    else if ((lsu_ex_rs1 == ixu2_wb_rd) && (ixu2_wb_rd != '0) && ~ixu2_wb_nop) begin
        lsu_rs1_fwd = '1;
        lsu_rs1_fwd_data = ixu2_wb_data;
    end
    else if ((lsu_ex_rs1 == lsu_wb_rd) && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
        lsu_rs1_fwd = '1;
        lsu_rs1_fwd_data = lsu_wb_data;
    end
    // use if mem latency > 1 cycle
    // else if ((lsu_ex_rs1 == lsu_wb_rd) && (lsu_wb_is_load == 1'b0) && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
    //     lsu_rs1_fwd = '1;
    //     lsu_rs1_fwd_data = lsu_wb_data;
    // end
    else begin
        lsu_rs1_fwd = '0;
        lsu_rs1_fwd_data = '0;
    end
end

// LSU RS2
always_comb begin
    if ((lsu_ex_rs2 == ixu1_wb_rd) && (ixu1_wb_rd != '0) && ~ixu1_wb_nop) begin
        lsu_rs2_fwd = '1;
        lsu_rs2_fwd_data = ixu1_wb_data;
    end
    else if ((lsu_ex_rs2 == ixu2_wb_rd) && (ixu2_wb_rd != '0) && ~ixu2_wb_nop) begin
        lsu_rs2_fwd = '1;
        lsu_rs2_fwd_data = ixu2_wb_data;
    end
    else if ((lsu_ex_rs2 == lsu_wb_rd) && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
        lsu_rs2_fwd = '1;
        lsu_rs2_fwd_data = lsu_wb_data;
    end
    // use if mem latency > 1 cycle
    // else if ((lsu_ex_rs2 == lsu_wb_rd) && ~lsu_wb_is_load && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
    //     lsu_rs2_fwd = '1;
    //     lsu_rs2_fwd_data = lsu_wb_data;
    // end
    else begin
        lsu_rs2_fwd = '0;
        lsu_rs2_fwd_data = '0;
    end
end

// Branch RS1
always_comb begin
    if ((branch_ex_rs1 == ixu1_wb_rd) && (ixu1_wb_rd != '0) && ~ixu1_wb_nop) begin
        branch_rs1_fwd = '1;
        branch_rs1_fwd_data = ixu1_wb_data;
    end
    else if ((branch_ex_rs1 == ixu2_wb_rd) && (ixu2_wb_rd != '0) && ~ixu2_wb_nop) begin
        branch_rs1_fwd = '1;
        branch_rs1_fwd_data = ixu2_wb_data;
    end
    else if ((branch_ex_rs1 == lsu_wb_rd) && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
        branch_rs1_fwd = '1;
        branch_rs1_fwd_data = lsu_wb_data;
    end
    // use if mem latency > 1 cycle
    // else if ((branch_ex_rs1 == lsu_wb_rd) && ~lsu_wb_is_load && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
    //     branch_rs1_fwd = '1;
    //     branch_rs1_fwd_data = lsu_wb_data;
    // end
    else begin
        branch_rs1_fwd = '0;
        branch_rs1_fwd_data = '0;
    end
end

// Branch RS2
always_comb begin
    if ((branch_ex_rs2 == ixu1_wb_rd) && (ixu1_wb_rd != '0) && ~ixu1_wb_nop) begin
        branch_rs2_fwd = '1;
        branch_rs2_fwd_data = ixu1_wb_data;
    end
    else if ((branch_ex_rs2 == ixu2_wb_rd) && (ixu2_wb_rd != '0) && ~ixu2_wb_nop) begin
        branch_rs2_fwd = '1;
        branch_rs2_fwd_data = ixu2_wb_data;
    end
    else if ((branch_ex_rs2 == lsu_wb_rd) && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
        branch_rs2_fwd = '1;
        branch_rs2_fwd_data = lsu_wb_data;
    end
    // use if mem latency > 1
    // else if ((branch_ex_rs2 == lsu_wb_rd) ~lsu_wb_is_load && (lsu_wb_rd != '0) && ~lsu_wb_nop) begin
    //     branch_rs2_fwd = '1;
    //     branch_rs2_fwd_data = lsu_wb_data;
    // end
    else begin
        branch_rs2_fwd = '0;
        branch_rs2_fwd_data = '0;
    end
end

endmodule