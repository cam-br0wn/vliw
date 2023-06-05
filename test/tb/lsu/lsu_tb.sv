// LSU testbench
`timescale 1ns/1ns
module lsu_tb;

parameter test_file = "test/bin/test_loads.hex";
logic           clk,
logic           rst,
logic           stall,   // signal from hazard detection unit
    // instruction from instruction register
logic [31:0]    inst,
    // signals from ID/EX reg to access reg file
logic [4:0]     rs1_out,
logic [4:0]     rs2_out,
    // data coming back from reg file
logic [31:0]    rs1_data,
logic [31:0]    rs2_data,
    // write addr, data and enable for stores
logic [31:0]    wr_addr,
logic [31:0]    wr_data,
logic           wr_en,
    // read addr for loads
logic [31:0]    rd_data,    // data coming back from ram
logic [31:0]    rd_addr,    // address to read from
logic           rd_en,      // read enable
    // data to be written to reg file
logic [31:0]    data_out,   
    // register to store data in on loads
logic [4:0]     rd_out,
    // register file write enable
logic           reg_file_wr_en,
    // need to inform hazard detection if execute is a load
logic           ex_is_load,
    // need to inform forwarding unit if the writeback is a load
logic           wb_is_load,
    // forwarding inputs
logic           is_rs1_fwd,
logic           is_rs2_fwd,
logic [31:0]    rs1_fwd_data,
logic [31:0]    rs2_fwd_data,
logic [4:0]     wb_rd_out,
    // hazard signals
logic [4:0]     dc_rs1,
logic [4:0]     dc_rs2,
    // squash from PC after branch taken
logic           branch_squash

// memory signals
logic [31:0] pc;
logic [127:0] instr_bundle;

assign stall = '0;
assign inst = instr_bundle[63:32];


lsu lsu_instance
(
    .clk(clk),
    .rst(rst),
    .stall(stall),

    .inst(inst),

    .rs1_out(rs1_out),
    .rs2_out(rs2_out),

    .rs1_data(rs1_data),
    .rs2_data(rs2_data),

    .wr_addr(wr_addr),
    .wr_data(wr_data),
    .wr_en(wr_en),

    .rd_data(rd_data),  // data from MEM -> LSU
    .rd_addr(rd_addr),
    .rd_en(rd_en),

    .data_out(data_out), // data from LSU -> reg file
    .rd_out(rd_out),
    
    .reg_file_wr_en(reg_file_wr_en),
    .ex_is_load(ex_is_load),
    .wb_is_load(wb_is_load),
    .is_rs1_fwd(is_rs1_fwd),
    .is_rs2_fwd(is_rs2_fwd),
    .rs1_fwd_data(rs1_fwd_data),
    .rs2_fwd_data(rs2_fwd_data),
    .wb_rd_out(wb_rd),
    .dc_rs1(dc_rs1),
    .dc_rs2(dc_rs2),
    .branch_squash(branch_squash)
);

main_memory ram #(
    test_file
)
(
    .clk(clk),
    .rst(rst),
    // LSU ports
    .wr_addr(wr_addr),
    .wr_data(wr_data),
    .wr_en(wr_en),
    .rd_addr(rd_addr),
    .rd_en(rd_en),
    .data_out(rd_data),
    // instruction fetch ports
    .pc_in(pc),
    .inst_bundle_out(instr_bundle)
);

register_file reg_file 
(
    .clk(clk),
    .rst(rst),
  
    // LSU ports
    .lsu_rs1(rs1_out),
    .lsu_rs2(rs2_out),
    .lsu_rd(rd_out),
    .lsu_wr_data(data_out),
    .lsu_wr_en(reg_file_wr_en),
    .lsu_rs1_data(rs1_data),
    .lsu_rs2_data(rs2_data),

    // IXU1 ports
    .ixu1_rs1('0),
    .ixu1_rs2('0),
    .ixu1_rd(5'h1),
    .ixu1_wr_data('0),
    .ixu1_wr_en('0),
    .ixu1_rs1_data('0),
    .ixu1_rs2_data('0),

    // IXU2 ports
    .ixu2_rs1('0),
    .ixu2_rs2('0),
    .ixu2_rd('0),
    .ixu2_wr_data('0),
    .ixu2_wr_en('0),
    .ixu2_rs1_data('0),
    .ixu2_rs2_data('0),

    // BRANCH ports
    .branch_rs1('0),
    .branch_rs2('0),
    .branch_rd('0),
    .branch_wr_data('0),
    .branch_wr_en('0),
    .branch_rs1_data('0),
    .branch_rs2_data('0)
);

initial begin
    clk = '0;
    rst = '0;
    pc = 0'h00000004;
    
    #5;
    rst = '1;
    #5;
    rst = '0;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;
    
    #10;
    clk = '0;
    #10;
    clk = '1;
    
    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;
    

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;

    #10;
    clk = '0;
    #10;
    clk = '1;
    
    #10;
    clk = '0;
    #10;
    clk = '1;
    #10;
    $stop;
end

endmodule