// fetch module to access instruction memory and pass to specific piplines

module instruction_fetch
(
    input   logic [31:0]    pc_in,
    input   logic [127:0]   inst_bundle,
    output  logic [31:0]    pc_out,
    output  logic [31:0]    ixu1_inst,
    output  logic [31:0]    ixu2_inst,
    output  logic [31:0]    lsu_inst,
    output  logic [31:0]    branch_inst
);

always_comb begin

    pc_out = pc_in;
    ixu1_inst = inst_bundle[127:96];
    ixu2_inst = inst_bundle[95:64];
    lsu_inst = inst_bundle[63:32];
    branch_inst = inst_bundle[31:0];

end

endmodule