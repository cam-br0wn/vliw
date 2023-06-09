// Top level of whole design

module vliw #(
    parameter ram_file = "../test/bin/test1.hex"
)
(
    input   logic           clk,
    input   logic           rst
);

//////// internal signal declarations ////////

//// register file to pipeline signals ////
// IXU 1
logic [4:0]     ixu1_rs1_out;
logic [4:0]     ixu1_rs2_out;
logic [31:0]    ixu1_rs1_data;
logic [31:0]    ixu1_rs2_data;
logic [4:0]     ixu1_rd_out;
logic [31:0]    ixu1_data_out;
logic           ixu1_reg_file_wr_en;

// IXU 2
logic [4:0]     ixu2_rs1_out;
logic [4:0]     ixu2_rs2_out;
logic [31:0]    ixu2_rs1_data;
logic [31:0]    ixu2_rs2_data;
logic [4:0]     ixu2_rd_out;
logic [31:0]    ixu2_data_out;
logic           ixu2_reg_file_wr_en;

// LSU
logic [4:0]     lsu_rs1_out;
logic [4:0]     lsu_rs2_out;
logic [31:0]    lsu_rs1_data;
logic [31:0]    lsu_rs2_data;
logic [4:0]     lsu_rd_out;
logic           lsu_reg_file_wr_en;
logic [31:0]    lsu_data_out;

// BRANCH
logic [4:0]     bru_rs1_out;
logic [4:0]     bru_rs2_out;
logic [31:0]    bru_rs1_data;
logic [31:0]    bru_rs2_data;
logic [4:0]     bru_rd_out;
logic           bru_reg_file_wr_en;
logic [31:0]    bru_ret_addr;


//// branch taken and new pc signals ////
logic           bru_branch_taken_out;
logic [31:0]    bru_new_pc_out;


//// LSU to/from memory signals ////
logic [31:0]    lsu_wr_addr;
logic [31:0]    lsu_wr_data;
logic           lsu_wr_en;
logic [1:0]     lsu_wr_size;
logic [31:0]    lsu_rd_addr;
logic           lsu_rd_en;
logic [31:0]    lsu_rd_data;
logic [1:0]     lsu_rd_size;
logic           lsu_rd_zero_ext;


//// instruction fetch to/from memory signals ////
logic [127:0]   instr_bundle;
logic [31:0]    fetch_pc;
logic [31:0]    ex_pc;

//// fetch to pipeline signals ////
logic [31:0]    ixu1_inst;
logic [31:0]    ixu2_inst;
logic [31:0]    lsu_inst;
logic [31:0]    bru_inst;

//// program counter to fetch signals ////
logic [31:0]    pc_data_out;

//// address to stop execution if it's hit ////
logic [31:0]    data_start_addr;


//// forwarding signals ////
// IXU 1
logic           ixu1_is_rs1_fwd;
logic           ixu1_is_rs2_fwd;
logic [31:0]    ixu1_rs1_fwd_data;
logic [31:0]    ixu1_rs2_fwd_data;
logic [4:0]     ixu1_wb_rd;
logic           ixu_wb_nop;

// IXU 2
logic           ixu2_is_rs1_fwd;
logic           ixu2_is_rs2_fwd;
logic [31:0]    ixu2_rs1_fwd_data;
logic [31:0]    ixu2_rs2_fwd_data;
logic [4:0]     ixu2_wb_rd;
logic           ixu2_wb_nop;

// LSU
logic           lsu_is_rs1_fwd;
logic           lsu_is_rs2_fwd;
logic [31:0]    lsu_rs1_fwd_data;
logic [31:0]    lsu_rs2_fwd_data;
logic [4:0]     lsu_wb_rd;
logic           lsu_wb_is_load;
logic           lsu_wb_nop;

// BRANCH
logic           bru_is_rs1_fwd;
logic           bru_is_rs2_fwd;
logic [31:0]    bru_rs1_fwd_data;
logic [31:0]    bru_rs2_fwd_data;


//// hazard detection signals ////
// IXU 1
logic [4:0]     ixu1_dc_rs1;
logic [4:0]     ixu1_dc_rs2;
// IXU 2
logic [4:0]     ixu2_dc_rs1;
logic [4:0]     ixu2_dc_rs2;
// LSU
logic [4:0]     lsu_dc_rs1;
logic [4:0]     lsu_dc_rs2;
logic [4:0]     lsu_ex_rd;
logic           lsu_ex_is_load;
// BRANCH
logic [4:0]     bru_dc_rs1;
logic [4:0]     bru_dc_rs2;

logic           haz_det_stall;

// squash signals
logic           bru_dont_squash_dec;
logic           bru_dont_squash_exec;
logic           pc_dont_squash_dec;
logic           pc_dont_squash_exec;

// halt register (switched by ecall/ebreak writeback)
logic           halt_proc;
// wires from branch -> pc and pc -> halt reg
logic           pc_halt_in;
logic           pc_halt_out;

always_ff @ (negedge clk) begin
    halt_proc <= pc_halt_out;
end

always_comb begin
    if (halt_proc) begin
        $display("ECALL or EBREAK hit, ending simulation");
        $stop;
    end
end

//// module instances ////
// IXU 1
ixu ixu_1
(
    .clk(clk),
    .rst(rst),
    .stall(haz_det_stall),
    .inst(ixu1_inst),
    .rs1_out(ixu1_rs1_out),
    .rs2_out(ixu1_rs2_out),
    .rs1_data(ixu1_rs1_data),
    .rs2_data(ixu1_rs2_data),
    .ex_pc_in(ex_pc),
    .rd_out(ixu1_rd_out),
    .wb_rd_out(ixu1_wb_rd),
    .data_out(ixu1_data_out),
    .reg_file_wr_en(ixu1_reg_file_wr_en),
    .is_rs1_fwd(ixu1_is_rs1_fwd),
    .is_rs2_fwd(ixu1_is_rs2_fwd),
    .rs1_fwd_data(ixu1_rs1_fwd_data),
    .rs2_fwd_data(ixu1_rs2_fwd_data),
    .dc_rs1(ixu1_dc_rs1),
    .dc_rs2(ixu1_dc_rs2),
    .wb_nop(ixu1_wb_nop),
    .branch_squash(pc_squash_out),
    .dont_squash_dec(pc_dont_squash_dec),
    .dont_squash_exec(pc_dont_squash_exec)
);

// IXU 2
ixu ixu_2
(
    .clk(clk),
    .rst(rst),
    .stall(haz_det_stall),
    .inst(ixu2_inst),
    .rs1_out(ixu2_rs1_out),
    .rs2_out(ixu2_rs2_out),
    .rs1_data(ixu2_rs1_data),
    .rs2_data(ixu2_rs2_data),
    .ex_pc_in(ex_pc),
    .rd_out(ixu2_rd_out),
    .wb_rd_out(ixu2_wb_rd),
    .data_out(ixu2_data_out),
    .reg_file_wr_en(ixu2_reg_file_wr_en),
    .is_rs1_fwd(ixu2_is_rs1_fwd),
    .is_rs2_fwd(ixu2_is_rs2_fwd),
    .rs1_fwd_data(ixu2_rs1_fwd_data),
    .rs2_fwd_data(ixu2_rs2_fwd_data),
    .dc_rs1(ixu2_dc_rs1),
    .dc_rs2(ixu2_dc_rs2),
    .wb_nop(ixu2_wb_nop),
    .branch_squash(pc_squash_out),
    .dont_squash_dec(pc_dont_squash_dec),
    .dont_squash_exec(pc_dont_squash_exec)
);

// LSU
lsu lsu_i
(
    .clk(clk),
    .rst(rst),
    .stall(haz_det_stall),

    .inst(lsu_inst),

    .rs1_out(lsu_rs1_out),
    .rs2_out(lsu_rs2_out),

    .rs1_data(lsu_rs1_data),
    .rs2_data(lsu_rs2_data),

    .wr_addr(lsu_wr_addr),
    .wr_data(lsu_wr_data),
    .wr_en(lsu_wr_en),
    .wr_size(lsu_wr_size),

    .rd_data(lsu_rd_data),  // data from MEM -> LSU
    .rd_addr(lsu_rd_addr),
    .rd_en(lsu_rd_en),
    .rd_size(lsu_rd_size),
    .rd_zero_ext(lsu_rd_zero_ext),

    .data_out(lsu_data_out), // data from LSU -> reg file
    .rd_out(lsu_rd_out),
    
    .reg_file_wr_en(lsu_reg_file_wr_en),
    .ex_is_load(lsu_ex_is_load),
    .ex_rd(lsu_ex_rd),
    .wb_is_load(lsu_wb_is_load),
    .is_rs1_fwd(lsu_is_rs1_fwd),
    .is_rs2_fwd(lsu_is_rs2_fwd),
    .rs1_fwd_data(lsu_rs1_fwd_data),
    .rs2_fwd_data(lsu_rs2_fwd_data),
    .wb_rd_out(lsu_wb_rd),
    .dc_rs1(lsu_dc_rs1),
    .dc_rs2(lsu_dc_rs2),
    .wb_nop(lsu_wb_nop),
    .branch_squash(pc_squash_out),
    .dont_squash_dec(pc_dont_squash_dec),
    .dont_squash_exec(pc_dont_squash_exec)
);

// BRANCH
branch bru
(
    .clk(clk),
    .rst(rst),
    .stall(haz_det_stall),
    .inst(bru_inst),
    .inst_pc(fetch_pc),
    .rs1_out(bru_rs1_out),
    .rs2_out(bru_rs2_out),
    .rs1_data(bru_rs1_data),
    .rs2_data(bru_rs2_data),
    .ex_pc_out(ex_pc),
    .rd_out(bru_rd_out),
    .ret_addr(bru_ret_addr),
    .reg_file_wr_en(bru_reg_file_wr_en),
    .branch_taken(bru_branch_taken_out),
    .dont_squash_dec_out(bru_dont_squash_dec),
    .dont_squash_exec_out(bru_dont_squash_exec),
    .new_pc(bru_new_pc_out),
    .is_rs1_fwd(bru_is_rs1_fwd),
    .is_rs2_fwd(bru_is_rs2_fwd),
    .rs1_fwd_data(bru_rs1_fwd_data),
    .rs2_fwd_data(bru_rs2_fwd_data),
    .dc_rs1(bru_dc_rs1),
    .dc_rs2(bru_dc_rs2),
    .branch_squash(pc_squash_out),
    .dont_squash_dec_in(pc_dont_squash_dec),
    .halt_proc(pc_halt_in)
);

// reg file
register_file reg_file 
(
    .clk(clk),
    .rst(rst),
  
    // LSU ports
    .lsu_rs1(lsu_rs1_out),
    .lsu_rs2(lsu_rs2_out),
    .lsu_rd(lsu_rd_out),
    .lsu_wr_data(lsu_data_out),
    .lsu_wr_en(lsu_reg_file_wr_en),
    .lsu_rs1_data(lsu_rs1_data),
    .lsu_rs2_data(lsu_rs2_data),

    // IXU1 ports
    .ixu1_rs1(ixu1_rs1_out),
    .ixu1_rs2(ixu1_rs2_out),
    .ixu1_rd(ixu1_rd_out),
    .ixu1_wr_data(ixu1_data_out),
    .ixu1_wr_en(ixu1_reg_file_wr_en),
    .ixu1_rs1_data(ixu1_rs1_data),
    .ixu1_rs2_data(ixu1_rs2_data),

    // IXU2 ports
    .ixu2_rs1(ixu2_rs1_out),
    .ixu2_rs2(ixu2_rs2_out),
    .ixu2_rd(ixu2_rd_out),
    .ixu2_wr_data(ixu2_data_out),
    .ixu2_wr_en(ixu2_reg_file_wr_en),
    .ixu2_rs1_data(ixu2_rs1_data),
    .ixu2_rs2_data(ixu2_rs2_data),

    // BRANCH ports
    .branch_rs1(bru_rs1_out),
    .branch_rs2(bru_rs2_out),
    .branch_rd(bru_rd_out),
    .branch_wr_data(bru_ret_addr),
    .branch_wr_en(bru_reg_file_wr_en),
    .branch_rs1_data(bru_rs1_data),
    .branch_rs2_data(bru_rs2_data)
);

// memory module
main_memory #(
    ram_file
) ram
(
    .clk(clk),
    .rst(rst),
    // LSU ports
    .wr_addr(lsu_wr_addr),
    .wr_data(lsu_wr_data),
    .wr_en(lsu_wr_en),
    .wr_size(lsu_wr_size),
    .rd_addr(lsu_rd_addr),
    .rd_en(lsu_rd_en),
    .rd_size(lsu_rd_size),
    .rd_zero_ext(lsu_rd_zero_ext),
    .data_out(lsu_rd_data),
    // instruction fetch ports
    .pc_in(fetch_pc),
    .data_start_addr(data_start_addr),
    .inst_bundle_out(instr_bundle)
);

// Hazard detection unit
hazard_detection hzd
(
    .lsu_ex_rd(lsu_ex_rd),
    .lsu_ex_is_load(lsu_ex_is_load),
    // decode src regs
    .ixu1_dc_rs1(ixu1_dc_rs1),
    .ixu1_dc_rs2(ixu1_dc_rs2),
    .ixu2_dc_rs1(ixu2_dc_rs1),
    .ixu2_dc_rs2(ixu2_dc_rs2),
    .lsu_dc_rs1(lsu_dc_rs1),
    .lsu_dc_rs2(lsu_dc_rs2),
    .bru_dc_rs1(bru_dc_rs1),
    .bru_dc_rs2(bru_dc_rs2),
    // stall output signal
    .stall_out(haz_det_stall)
);

// program counter
program_counter pc
(
    .clk(clk),
    .rst(rst),
    .stall(haz_det_stall),
    .branch_taken(bru_branch_taken_out),
    .dont_squash_dec_in(bru_dont_squash_dec),
    .dont_squash_exec_in(bru_dont_squash_exec),
    .new_pc(bru_new_pc_out),
    .data_start_addr(data_start_addr),
    .halt_in(pc_halt_in),
    .pc(pc_data_out),
    .squash(pc_squash_out),
    .dont_squash_dec_out(pc_dont_squash_dec),
    .dont_squash_exec_out(pc_dont_squash_exec),
    .halt_out(pc_halt_out)
);

// forwarding unit
forwarding_unit fwu
(
    .ixu1_wb_rd(ixu1_wb_rd),
    .ixu2_wb_rd(ixu2_wb_rd),
    .lsu_wb_rd(lsu_wb_rd),
    .lsu_wb_is_load(lsu_wb_is_load),
    // note lack of branch writeback stage

    // writeback data
    .ixu1_wb_data(ixu1_data_out),
    .ixu2_wb_data(ixu2_data_out),
    .lsu_wb_data(lsu_data_out),

    // writeback are nops?
    .ixu1_wb_nop(ixu1_wb_nop),
    .ixu2_wb_nop(ixu2_wb_nop),
    .lsu_wb_nop(lsu_wb_nop),

    // execute source registers
    .ixu1_ex_rs1(ixu1_rs1_out),
    .ixu1_ex_rs2(ixu1_rs2_out),
    .ixu2_ex_rs1(ixu2_rs1_out),
    .ixu2_ex_rs2(ixu2_rs2_out),
    .lsu_ex_rs1(lsu_rs1_out),
    .lsu_ex_rs2(lsu_rs2_out),
    .branch_ex_rs1(bru_rs1_out),
    .branch_ex_rs2(bru_rs2_out),

    // forwarding activation lines
    .ixu1_rs1_fwd(ixu1_is_rs1_fwd),
    .ixu1_rs2_fwd(ixu1_is_rs2_fwd),
    .ixu2_rs1_fwd(ixu2_is_rs1_fwd),
    .ixu2_rs2_fwd(ixu2_is_rs2_fwd),
    .lsu_rs1_fwd(lsu_is_rs1_fwd),
    .lsu_rs2_fwd(lsu_is_rs2_fwd),
    .branch_rs1_fwd(bru_is_rs1_fwd),
    .branch_rs2_fwd(bru_is_rs2_fwd),
    // these signals will be the selector bits for muxes within execute stages to pick either reg file or wb data

    // need to encode where the data is coming from for each unit
    .ixu1_rs1_fwd_data(ixu1_rs1_fwd_data),
    .ixu1_rs2_fwd_data(ixu1_rs2_fwd_data),
    .ixu2_rs1_fwd_data(ixu2_rs1_fwd_data),
    .ixu2_rs2_fwd_data(ixu2_rs2_fwd_data),
    .lsu_rs1_fwd_data(lsu_rs1_fwd_data),
    .lsu_rs2_fwd_data(lsu_rs2_fwd_data),
    .branch_rs1_fwd_data(bru_rs1_fwd_data),
    .branch_rs2_fwd_data(bru_rs2_fwd_data)
);

// instruction fetch combinational module
instruction_fetch inst_fetch
(
    .pc_in(pc_data_out),
    .inst_bundle(instr_bundle),
    .pc_out(fetch_pc),
    .ixu1_inst(ixu1_inst),
    .ixu2_inst(ixu2_inst),
    .lsu_inst(lsu_inst),
    .branch_inst(bru_inst)
);

endmodule