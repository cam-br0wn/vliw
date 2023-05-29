// ixu pipeline testbench

module ixu_tb;

logic           clk;
logic           rst;
logic           stall;
logic [31:0]    inst;
logic [4:0]     rs1_out;
logic [4:0]     rs2_out;
logic [31:0]    rs1_data;
logic [31:0]    rs2_data;
logic [4:0]     rd_out;
logic [31:0]    data_out;
logic           reg_file_wr_en;
logic           is_rs1_fwd;
logic           is_rs2_fwd;
logic [31:0]    rs1_fwd_data;
logic [31:0]    rs2_fwd_data;

ixu ixu_inst (
    .clk(clk),
    .rst(rst),
    .stall(stall),
    // instruction from instruction register
    .inst(inst),
    // signals from ID/EX to access reg file
    .rs1_out(rs1_out),
    .rs2_out(rs2_out),
    // data coming back from reg file
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    // destination register addr, data, write enable
    .rd_out(rd_out),
    .data_out(data_out),
    .reg_file_wr_en(reg_file_wr_en),

    // forwarding inputs
    .is_rs1_fwd(is_rs1_fwd),
    .is_rs2_fwd(is_rs2_fwd),
    .rs1_fwd_data(rs1_fwd_data),
    .rs2_fwd_data(rs2_fwd_data)
);

initial begin
    clk = '0;
    forever
    #10 clk = ~clk;
end

initial begin

end

endmodule