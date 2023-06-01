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
    output  logic           reg_file_wr_en,

    // forwarding inputs
    input   logic           is_rs1_fwd,
    input   logic           is_rs2_fwd,
    input   logic [31:0]    rs1_fwd_data,
    input   logic [31:0]    rs2_fwd_data,
    output  logic [4:0]     wb_rd_out,

    // hazard signals
    output  logic [4:0]     dc_rs1,
    output  logic [4:0]     dc_rs2,

    // squash from PC after branch taken
    input   logic           branch_squash
);

// Decode -> ID/EX register internal signals
logic [3:0]     decode_op;
logic           decode_is_nop;
logic           decode_is_imm_type;
logic [4:0]     decode_rs1;
logic [4:0]     decode_rs2;
logic [4:0]     decode_rd;
logic [11:0]    decode_imm;

assign dc_rs1 = decode_rs1;
assign dc_rs2 = decode_rs2;

ixu_decode ixu_decode_instance (
    .inst(inst),
    .op(decode_op),
    .is_nop(decode_is_nop),
    .is_imm_type(decode_is_imm_type),
    .rs1(decode_rs1),
    .rs2(decode_rs2),
    .rd(decode_rd),
    .imm(decode_imm)
);

// ID/EX -> Execution internal signals
logic [3:0]     idex_op;
logic           idex_is_nop;
logic           idex_is_imm_type;
logic [4:0]     idex_rd;
logic [11:0]    idex_imm;
// internal signal to or the decode is_nop with squash
logic           decode_nop_or_squash;
assign decode_nop_or_squash = decode_is_nop || branch_squash;

ixu_id_ex ixu_id_ex_reg (
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .op_in(decode_op),
    .is_nop_in(decode_is_nop),
    .is_imm_type_in(decode_is_imm_type),
    .rs1_in(decode_rs1),
    .rs2_in(decode_rs2),
    .rd_in(decode_rd),
    .imm_in(decode_imm),
    .op_out(idex_op),
    .is_nop_out(idex_is_nop),
    .is_imm_type_out(idex_is_imm_type),
    .rs1_out(rs1_out),
    .rs2_out(rs2_out),
    .rd_out(idex_rd),
    .imm_out(idex_imm)
);

// execution stage internal signals
logic [31:0]    execute_data;

ixu_execute ixu_execute_instance (
    .is_rs1_fwd(is_rs1_fwd),
    .is_rs2_fwd(is_rs2_fwd),
    .rs1_fwd_data(rs1_fwd_data),
    .rs2_fwd_data(rs2_fwd_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .imm(idex_imm),
    .is_imm_type(idex_is_imm_type),
    .is_nop(idex_is_nop),
    .op(idex_op),
    .out(execute_data)
);

// EX/WB -> writeback signals
logic           exwb_is_nop;
logic [4:0]     exwb_rd;
logic [31:0]    exwb_data;
// internal signal to or the execute is_nop with squash
logic           exec_nop_or_squash;
assign exec_nop_or_squash = idex_is_nop || branch_squash;

assign wb_rd_out = exwb_rd;

ixu_ex_wb ixu_ex_wb_reg (
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .is_nop_in(exec_nop_or_squash),
    .rd_in(idex_rd),
    .data_in(execute_data),
    .is_nop_out(exwb_is_nop),
    .rd_out(exwb_rd),
    .data_out(exwb_data)
);

ixu_writeback ixu_writeback_instance (
    .is_nop(exwb_is_nop),
    .rd(exwb_rd),
    .data_in(exwb_data),
    .rd_out(rd_out),
    .data_out(data_out),
    .wr_en(reg_file_wr_en)
);

endmodule