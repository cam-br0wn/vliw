// Top level of whole design

module vliw 
(
    input   logic           clk,
    input   logic           rst
);

// IXU 1
ixu ixu_1
(
    .clk(clk),
    .rst(rst),
    .stall(),
    .inst(),
    .rs1_out(),
    .rs2_out(),
    .rs1_data(),
    .rs2_data(),
    .rd_out(),
    .data_out(),
    .reg_file_wr_en(),
    .is_rs1_fwd(),
    .is_rs2_fwd(),
    .rs1_fwd_data(),
    .rs2_fwd_data(),
    .branch_squash()
);

// IXU 2
ixu ixu_2
(
    .clk(clk),
    .rst(rst),
    .stall(),
    .inst(),
    .rs1_out(),
    .rs2_out(),
    .rs1_data(),
    .rs2_data(),
    .rd_out(),
    .data_out(),
    .reg_file_wr_en(),
    .is_rs1_fwd(),
    .is_rs2_fwd(),
    .rs1_fwd_data(),
    .rs2_fwd_data(),
    .branch_squash()
);

// LSU
lsu lsu_inst
(
    .clk(clk),
    .rst(rst),
    .stall(),
    .inst(),
    .rs1_out(),
    .rs2_out(),
    .rs1_data(),
    .rs2_data(),
    .wr_addr(),
    .wr_data(),
    .wr_en(),
    .rd_addr(),
    .mem_data_in(),
    .mem_data_out(),
    .rd_out(),
    .reg_file_wr_en(),
    .ex_is_load(),
    .wb_is_load(),
    .is_rs1_fwd(),
    .is_rs2_fwd(),
    .rs1_fwd_data(),
    .rs2_fwd_data(),
    .branch_squash()
);

// BRANCH
branch bru
(
    .clk(clk),
    .rst(rst),
    .stall(),
    .inst(),
    .inst_pc(),
    .rs1_out(),
    .rs2_out(),
    .rs1_data(),
    .rs2_data(),
    .rd_out(),
    .ret_addr(),
    .reg_file_wr_en(),
    .branch_taken(),
    .new_pc(),
    .is_rs1_fwd(),
    .is_rs2_fwd(),
    .rs1_fwd_data(),
    .rs2_fwd_data(),
    .branch_squash()
);

// reg file
register_file reg 
(
    .clk(),
    .rst(),
  
    // LSU ports
    .lsu_rs1()(),
    .lsu_rs2(),
    .lsu_rd(),
    .lsu_wr_data(),
    .lsu_wr_en(),
    .lsu_rs1_data(),
    .lsu_rs2_data(),

    // IXU1 ports
    .ixu1_rs1(),
    .ixu1_rs2(),
    .ixu1_rd(),
    .ixu1_wr_data(),
    .ixu1_wr_en(),
    .ixu1_rs1_data(),
    .ixu1_rs2_data(),

    // IXU2 ports
    .ixu2_rs1(),
    .ixu2_rs2(),
    .ixu2_rd(),
    .ixu2_wr_data(),
    .ixu2_wr_en(),
    .ixu2_rs1_data(),
    .ixu2_rs2_data(),

    // BRANCH ports
    .branch_rs1(),
    .branch_rs2(),
    .branch_rd(),
    .branch_wr_data(),
    .branch_wr_en(),
    .branch_rs1_data(),
    .branch_rs2_data()
);

// memory module
main_memory ram
(
    .clk(clk),
    .rst(rst),
    // LSU ports
    .wr_addr(),
    .wr_data(),
    .wr_en(),
    .rd_addr(),
    .rd_en(),
    .data_out(),
    // instruction fetch ports
    .pc_in(),
    .inst_bundle_out()
);

// Hazard detection unit
hazard_detection hzd
(
    .lsu_ex_rd(),
    .lsu_ex_is_load(),
    // decode src regs
    .ixu1_dc_rs1(),
    .ixu1_dc_rs2(),
    .ixu2_dc_rs1(),
    .ixu2_dc_rs2(),
    .lsu_dc_rs1(),
    .lsu_dc_rs2(),
    // stall output signal
    .stall_out()
);

// program counter
program_counter pc
(
    .clk(clk),
    .rst(rst),
    .stall(),
    .branch_taken(),
    .new_pc(),
    .pc(),
    .squash(),
);

// forwarding unit
forwarding_unit fwu
(
    .ixu1_wb_rd(),
    .ixu2_wb_rd(),
    .lsu_wb_rd(),
    .lsu_wb_is_load(),
    // note lack of branch writeback stage

    // writeback data
    .ixu1_wb_data(),
    .ixu2_wb_data(),
    .lsu_wb_data(),

    // execute source registers
    .ixu1_ex_rs1(),
    .ixu1_ex_rs2(),
    .ixu2_ex_rs1(),
    .ixu2_ex_rs2(),
    .lsu_ex_rs1(),
    .lsu_ex_rs2(),
    .branch_ex_rs1(),
    .branch_ex_rs2(),

    // forwarding activation lines
    .ixu1_rs1_fwd(),
    .ixu1_rs2_fwd(),
    .ixu2_rs1_fwd(),
    .ixu2_rs2_fwd(),
    .lsu_rs1_fwd(),
    .lsu_rs2_fwd(),
    .branch_rs1_fwd(),
    .branch_rs2_fwd(),
    // these signals will be the selector bits for muxes within execute stages to pick either reg file or wb data

    // need to encode where the data is coming from for each unit
    .ixu1_rs1_fwd_data(),
    .ixu1_rs2_fwd_data(),
    .ixu2_rs1_fwd_data(),
    .ixu2_rs2_fwd_data(),
    .lsu_rs1_fwd_data(),
    .lsu_rs2_fwd_data(),
    .branch_rs1_fwd_data(),
    .branch_rs2_fwd_data()
);

// instruction fetch combinational module
instruction_fetch inst_fetch
(
    .pc_in(),
    .inst_bundle(),
    .pc_out(),
    .ixu1_inst(),
    .ixu2_inst(),
    .lsu_inst(),
    .branch_inst()
);

endmodule