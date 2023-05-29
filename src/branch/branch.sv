// branch pipeline top level
module branch
(
    input   logic           clk,
    input   logic           rst,
    input   logic           stall,
    // instruction from inst reg
    input   logic [31:0]    inst,
    // program counter for inst
    input   logic [31:0]    inst_pc,
    // signals from ID/EX to access reg file
    output  logic [4:0]     rs1_out,
    output  logic [4:0]     rs2_out,
    // data coming back from reg file
    input   logic [31:0]    rs1_data,
    input   logic [31:0]    rs2_data,
    // destination reg addr, data, write en
    output  logic [4:0]     rd_out,
    output  logic [31:0]    ret_addr,
    output  logic           reg_file_wr_en,
    // branch taken outcome (need so we can squash previous cycle)
    output  logic           branch_taken,
    output  logic [31:0]    new_pc,

    // forwarding inputs
    input   logic           is_rs1_fwd,
    input   logic           is_rs2_fwd,
    input   logic [31:0]    rs1_fwd_data,
    input   logic [31:0]    rs2_fwd_data,

    // squash from PC after branch taken
    input   logic           branch_squash
);

// internal signals coming out of decode
logic           decode_is_nop;
logic           decode_is_jmp;
logic           decode_is_imm_type;
logic           decode_zero_ext;
logic [1:0]     decode_op;
logic [4:0]     decode_rs1;
logic [4:0]     decode_rs2;
logic [4:0]     decode_rd;
logic [21:0]    decode_imm;

branch_decode branch_decode_instance (
    .inst(inst),
    .is_nop(decode_is_nop),
    .is_jmp(decode_is_jmp),
    .is_imm_type(decode_is_imm_type),
    .zero_ext(decode_zero_ext),
    .op(decode_op),
    .rs1(decode_rs1),
    .rs2(decode_rs2),
    .rd(decode_rd),
    .imm(decode_imm)
);

// internal signals coming out of ID/EX
logic           idex_is_nop;
logic           idex_is_jmp;
logic           idex_is_imm_type;
logic           idex_zero_ext;
logic [1:0]     idex_op;
logic [21:0]    idex_imm;
logic [31:0]    idex_pc;
// internal signal to or the decode is_nop with squash
logic           decode_nop_or_squash;
assign decode_nop_or_squash = decode_is_nop || branch_squash;

branch_id_ex branch_id_ex_reg (
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .is_nop_in(decode_nop_or_squash),
    .is_jmp_in(decode_is_jmp),
    .is_imm_type_in(decode_is_imm_type),
    .zero_ext_in(decode_zero_ext),
    .op_in(decode_op),
    .rs1_in(decode_rs1),
    .rs2_in(decode_rs2),
    .rd_in(decode_rd),
    .imm_in(decode_imm),
    .pc_in(inst_pc),
    .is_nop_out(idex_is_nop),
    .is_jmp_out(idex_is_jmp),
    .is_imm_type_out(idex_is_imm_type),
    .zero_ext_out(idex_zero_ext),
    .op_out(idex_op),
    .rs1_out(rs1_out),
    .rs2_out(rs2_out),
    .rd_out(rd_out),
    .imm_out(idex_imm),
    .pc_out(idex_pc)
);

branch_execute branch_execute_instance (
    .is_nop(idex_is_nop),
    .zero_ext(idex_zero_ext),
    .is_jmp(idex_is_jmp),
    .is_imm_type(idex_is_imm_type),
    .is_rs1_fwd(is_rs1_fwd),
    .is_rs2_fwd(is_rs2_fwd),
    .rs1_fwd_data(rs1_fwd_data),
    .rs2_fwd_data(rs2_fwd_data),
    .pc(idex_pc),
    .op(idex_op),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .imm(idex_imm),
    .branch_taken(branch_taken),
    .new_pc(new_pc),
    .ret_addr(ret_addr),
    .rd_wr_en(reg_file_wr_en)
);

endmodule