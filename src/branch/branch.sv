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

    // ex stage PC output
    output  logic [31:0]    ex_pc_out,

    // destination reg addr, data, write en
    output  logic [4:0]     rd_out,
    output  logic [31:0]    ret_addr,
    output  logic           reg_file_wr_en,
    // branch taken outcome (need so we can squash previous cycle)
    output  logic           branch_taken,
    output  logic [31:0]    new_pc,
    output  logic           dont_squash_dec_out,
    output  logic           dont_squash_exec_out,

    // forwarding inputs
    input   logic           is_rs1_fwd,
    input   logic           is_rs2_fwd,
    input   logic [31:0]    rs1_fwd_data,
    input   logic [31:0]    rs2_fwd_data,

    // hazard signals
    output  logic [4:0]     dc_rs1,
    output  logic [4:0]     dc_rs2,

    // squash from PC after branch taken
    input   logic           branch_squash,
    input   logic           dont_squash_dec_in,

    // halt signal to go to PC
    output  logic           halt_proc
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
logic [19:0]    decode_imm;

assign dc_rs1 = decode_rs1;
assign dc_rs2 = decode_rs2;

branch_decode decode (
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
logic [19:0]    idex_imm;
logic [31:0]    idex_pc;
// internal signal to or the decode is_nop with squash
logic           decode_nop_or_squash;
assign decode_nop_or_squash = decode_is_nop || (branch_squash && ~dont_squash_dec_in);
assign ex_pc_out = idex_pc;

branch_id_ex idex (
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

branch_execute exec (
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
    .dont_squash_dec(dont_squash_dec_out),
    .dont_squash_exec(dont_squash_exec_out),
    .new_pc(new_pc),
    .ret_addr(ret_addr),
    .rd_wr_en(reg_file_wr_en),
    .halt_proc(halt_proc)
);

endmodule