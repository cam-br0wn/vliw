// testbench for ixu execution
`timescale 1ns/1ns
module ixu_execute_tb;

logic is_rs1_fwd, is_rs2_fwd, is_imm_type, is_nop;
logic [31:0] rs1_fwd_data, rs2_fwd_data, rs1_data, rs2_data, out;
logic [11:0] imm;
logic [3:0] op;

ixu_execute ixu_execute_instance (
    .is_rs1_fwd(is_rs1_fwd),
    .is_rs2_fwd(is_rs2_fwd),
    .rs1_fwd_data(rs1_fwd_data),
    .rs2_fwd_data(rs2_fwd_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .imm(imm),
    .is_imm_type(is_imm_type),
    .is_nop(is_nop),
    .op(op),
    .out(out)
);

initial begin

    // Template //
    // is_rs1_fwd = 
    // is_rs2_fwd = 
    // rs1_fwd_data = 
    // rs2_fwd_data = 
    // rs1_data = 
    // rs2_data = 
    // imm =
    // is_imm_type = 
    // is_nop = 
    // op = 
    // #10

    // test add positive & positive
    is_rs1_fwd = '0;
    is_rs2_fwd = '0;
    rs1_fwd_data = '0;
    rs2_fwd_data = '0;
    rs1_data = 32'h00001000;
    rs2_data = 32'h00001000;
    imm = '0;
    is_imm_type = '0;
    is_nop = '0;
    op = '0;
    #10

    // test add positive & negative
    is_rs1_fwd = '0;
    is_rs2_fwd = '0;
    rs1_fwd_data = '0;
    rs2_fwd_data = '0;
    rs1_data = 32'h00000010;
    rs2_data = 32'hFFFFFFFF;
    imm = '0;
    is_imm_type = '0;
    is_nop = '0;
    op = '0;
    #10 

    // test add negative & negative
    is_rs1_fwd = '0;
    is_rs2_fwd = '0;
    rs1_fwd_data = '0;
    rs2_fwd_data = '0;
    rs1_data = 32'hFFFFFFFE;
    rs2_data = 32'hFFFFFFFE;
    imm = '0;
    is_imm_type = '0;
    is_nop = '0;
    op = '0;
    #10

    // test addi positive & positive immediate
    is_rs1_fwd = '0;
    is_rs2_fwd = '0;
    rs1_fwd_data = '0;
    rs2_fwd_data = '0;
    rs1_data = 32'h00001000;
    rs2_data = 32'h00001000;
    imm = 12'd128;
    is_imm_type = '1;
    is_nop = '0;
    op = '0;
    #10

    // test addi positive & negative immediate
    is_rs1_fwd = '0;
    is_rs2_fwd = '0;
    rs1_fwd_data = '0;
    rs2_fwd_data = '0;
    rs1_data = 32'h00001000;
    rs2_data = 32'h00001000;
    imm = 12'hFFF;
    is_imm_type = '1;
    is_nop = '0;
    op = '0;
    #10

    // test addi negative & negative immediate
    is_rs1_fwd = '0;
    is_rs2_fwd = '0;
    rs1_fwd_data = '0;
    rs2_fwd_data = '0;
    rs1_data = 32'hFFFFFFFD;
    rs2_data = 32'h00001000;
    imm = 12'hFFD;
    is_imm_type = '1;
    is_nop = '0;
    op = '0;
    #10;

end

endmodule