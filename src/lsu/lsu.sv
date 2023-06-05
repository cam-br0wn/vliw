// LSU top level structural

module lsu
(
    input   logic           clk,
    input   logic           rst,
    input   logic           stall,   // signal from hazard detection unit
    // instruction from instruction register
    input   logic [31:0]    inst,
    // signals from ID/EX reg to access reg file
    output  logic [4:0]     rs1_out,
    output  logic [4:0]     rs2_out,
    // data coming back from reg file
    input   logic [31:0]    rs1_data,
    input   logic [31:0]    rs2_data,
    // write addr, data and enable for stores
    output  logic [31:0]    wr_addr,
    output  logic [31:0]    wr_data,
    output  logic           wr_en,
    // read addr for loads
    input   logic [31:0]    rd_data,    // data coming back from ram
    output  logic [31:0]    rd_addr,    // address to read from
    output  logic           rd_en,      // read enable
    // data to be written to reg file
    input   logic [31:0]    data_out,   
    // register to store data in on loads
    output  logic [4:0]     rd_out,
    // register file write enable
    output  logic           reg_file_wr_en,
    // need to inform hazard detection if execute is a load
    output  logic           ex_is_load,
    // need to inform forwarding unit if the writeback is a load
    output  logic           wb_is_load,

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

// Decode -> ID/EX reg signals
logic           decode_is_load;
logic           decode_zero_ext;
logic           decode_is_nop;
logic [1:0]     decode_size;
logic [4:0]     decode_rs1;
logic [4:0]     decode_rs2;
logic [11:0]    decode_imm;

assign dc_rs1 = decode_rs1;
assign dc_rs2 = decode_rs2;

// ID/EX reg -> execute signals
logic           idex_is_load;
logic           idex_zero_ext;
logic           idex_is_nop;
logic [1:0]     idex_size;
logic [4:0]     idex_rs1;
logic [4:0]     idex_rs2;
logic [11:0]    idex_imm;

// internal signal to or the decode is_nop with squash
logic           decode_nop_or_squash;
assign decode_nop_or_squash = decode_is_nop || branch_squash;
// internal signal to or the execute is_nop with squash
logic           exec_nop_or_squash;
assign exec_nop_or_squash = idex_is_nop || branch_squash;

lsu_decode lsu_decode_instance (
    .inst(inst),
    .is_load(decode_is_load),
    .zero_ext(decode_zero_ext),
    .is_nop(decode_is_nop),
    .size(decode_size),
    .rs1(decode_rs1),
    .rs2(decode_rs2),
    .rd(decode_rd),
    .imm(decode_imm)
);

lsu_id_ex lsu_id_ex_register (
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .is_load_in(decode_is_load),
    .zero_ext_in(decode_zero_ext),
    .is_nop_in(decode_nop_or_squash),
    .size_in(decode_size),
    .rs1_in(decode_rs1),
    .rs2_in(decode_rs2),
    .rd_in(decode_rd),
    .imm_in(decode_imm),
    .is_load_out(idex_is_load),
    .zero_ext_out(idex_zero_ext),
    .is_nop_out(idex_is_nop),
    .size_out(idex_size),
    .rs1_out(idex_rs1),
    .rs2_out(idex_rs2),
    .rd_out(idex_rd),
    .imm_out(idex_imm)
);

// connect to register file ports
assign rs1_out = idex_rs1;
assign rs2_out = idex_rs2;

lsu_execute lsu_execute_instance (
    .is_load(idex_is_load),
    .is_nop(idex_is_nop),
    .is_rs1_fwd(is_rs1_fwd),
    .is_rs2_fwd(is_rs2_fwd),
    .rs1_fwd_data(rs1_fwd_data),
    .rs2_fwd_data(rs2_fwd_data),
    .imm(idex_imm),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .wr_addr(wr_addr),
    .wr_data(wr_data),
    .wr_en(wr_en),
    .rd_addr(rd_addr),
    .rd_en(rd_en)
);

assign ex_is_load = idex_is_load;

// EX/WB reg -> writeback signals
logic           exwb_is_load;
logic           exwb_zero_ext;
logic           exwb_is_nop;
logic [1:0]     exwb_size;
logic [4:0]     exwb_rd;

assign wb_rd_out = exwb_rd;

lsu_ex_wb lsu_ex_wb_register (
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .is_load_in(idex_is_load),
    .zero_ext_in(idex_zero_ext),
    .is_nop_in(exec_nop_or_squash),
    .size_in(idex_size),
    .rd_in(idex_rd),
    .is_load_out(exwb_is_load),
    .zero_ext_out(exwb_zero_ext),
    .is_nop_out(exwb_is_nop),
    .size_out(exwb_size),
    .rd_out(exwb_rd)
);

lsu_writeback lsu_writeback_instance (
    .is_nop(exwb_is_nop),
    .is_load(exwb_is_load),
    .rd(exwb_rd),
    .data_in(rd_data),
    .size(exwb_size),
    .zero_ext(exwb_zero_ext),
    .data_out(data_out),
    .wr_en(reg_file_wr_en)
);

assign wb_is_load = exwb_is_load;

endmodule