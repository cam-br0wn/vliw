// top level structural for IXU
module ixu
(
    input   logic           clk,
    input   logic           rst,
    input   logic           stall,
    // instruction from instruction register
    input   logic [31:0]    inst,
    // signals from ID/EX to access reg file
    output  logic [4:0]     rs1_out,
    output  logic [4:0]     rs2_out,
    // data coming back from reg file
    input   logic [31:0]    rs1_data,
    input   logic [31:0]    rs2_data,
    // destination register addr, data, write enable
    output  logic [4:0]     rd_out,
    output  logic [31:0]    data_out,
    output  logic           reg_file_wr_en
);

ixu_decode ixu_decode_instance (
    .inst(inst),
    .op(),
    .is_nop(),
    .is_imm_type(),
    .rs1(),
    .rs2(),
    .rd(),
    .imm()
);

ixu_id_ex ixu_id_ex_reg (
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .op_in(),
    .is_nop_in(),
    .is_imm_type_in(),
    .rs1_in(),
    .rs2_in(),
    .rd_in(),
    .imm_in(),
    .op_out(),
    .is_nop_out(),
    .is_imm_type_out(),
    .rs1_out(),
    .rs2_out(),
    .rd_out(),
    .imm_out()
);

ixu_execute ixu_execute_instance (
    .rs1_data(),
    .rs2_data(),
    .imm(),
    .is_imm_type(),
    .is_nop(),
    .op(),
    .out()
);

ixu_ex_wb ixu_ex_wb_reg (
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .is_nop_in(),
    .rd_in(),
    .data_in(),
    .is_nop_out(),
    .rd_out(),
    .data_out()
);

ixu_writeback ixu_writeback_instance (
    .is_nop(),
    .rd(),
    .data_in(),
    .rd_out(),
    .data_out(),
    .wr_en()
);

endmodule