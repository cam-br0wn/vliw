// execution of branch

module branch_execute
(
    input   logic           is_nop,
    input   logic           zero_ext,
    input   logic           is_jmp,
    input   logic           is_imm_type,
    input   logic           is_rs1_fwd,
    input   logic           is_rs2_fwd,
    input   logic [31:0]    rs1_fwd_data,
    input   logic [31:0]    rs2_fwd_data,
    input   logic [31:0]    pc,
    input   logic [1:0]     op,
    input   logic [31:0]    rs1_data,
    input   logic [31:0]    rs2_data,
    input   logic [19:0]    imm,
    output  logic           branch_taken,
    output  logic [31:0]    new_pc,
    output  logic [31:0]    ret_addr,
    output  logic           rd_wr_en
);

logic [31:0] internal_imm;
logic [31:0] internal_rs1_data;
logic [31:0] internal_rs2_data;

// if there is forwarding, do it
assign internal_rs1_data = (is_rs1_fwd == 1'b1) ? rs1_fwd_data : rs1_data;
assign internal_rs2_data = (is_rs2_fwd == 1'b1) ? rs2_fwd_data : rs2_data;

always_comb begin
    if (is_nop == '0) begin
        // branch instruction
        if (is_jmp == '0) begin
            ret_addr = '0;
            rd_wr_en = '0;
            internal_imm = {{16{imm[11]}}, imm[11:0], 4'h0};
            // BEQ
            if (op == 2'h0) begin
                branch_taken = (internal_rs1_data == internal_rs2_data);
                new_pc = $signed(pc) + $signed(internal_imm);
            // BNE
            end else if (op == 2'h1) begin
                branch_taken = ~(internal_rs1_data == internal_rs2_data);
                new_pc = $signed(pc) + $signed(internal_imm);
            // BLT or BLTU
            end else if (op == 2'h2) begin
                if (zero_ext == 1'b1) begin
                    branch_taken = ($unsigned(internal_rs1_data) < $unsigned(internal_rs2_data)) ? '1 : '0;
                    new_pc = $signed(pc) + $signed(internal_imm);
                end else if (zero_ext == 1'b0) begin
                    branch_taken = ($signed(internal_rs1_data) < $signed(internal_rs2_data)) ? '1 : '0;
                    new_pc = $signed(pc) + $signed(internal_imm);
                end else begin
                    $error("BRANCH EXEC ERROR: zero ext flag not set");
                end
            // BGE OR BGEU
            end else if (op == 2'h3) begin
                if (zero_ext == 1'b1) begin
                    branch_taken = ($unsigned(internal_rs1_data) >= $unsigned(internal_rs2_data)) ? '1 : '0;
                    new_pc = $signed(pc) + $signed(internal_imm);
                end else if (zero_ext == 1'b0) begin
                    branch_taken = ($signed(internal_rs1_data) >= $signed(internal_rs2_data)) ? '1 : '0;
                    new_pc = $signed(pc) + $signed(internal_imm);
                end else begin
                    $error("BRANCH EXEC ERROR: zero ext flag not set");
                end
            // invalid opcode
            end else begin
                $error("BRANCH EXEC ERROR: branch opcode bits not driven");
            end

        // JAL or JALR
        end else if (is_jmp == '1) begin
            branch_taken = '1;
            ret_addr = $signed(pc) + $signed(32'd16);
            rd_wr_en = '1;
            // JALR
            if (is_imm_type) begin
                internal_imm = {{20{imm[11]}}, imm[11:0]};
                new_pc = {{$signed(internal_rs1_data) + $signed(internal_imm)}[31:4], 4'h0} + 4;
            end
            // JAL
            else begin
                internal_imm = {{8{imm[19]}}, imm, 4'h0};
                new_pc = $signed(pc) + $signed(internal_imm);
            end

        // INVALID
        end else begin
            $error("BRANCH EXEC ERROR: could not determine if br, jal or jalr");
        end
    end else if (is_nop == '1) begin
        internal_imm = '0;
        branch_taken = '0;
        ret_addr = '0;
        rd_wr_en = '0;
        new_pc = '0;
    end else begin
        $error("BRANCH EXEC ERROR: is_nop is floating");
    end
end

endmodule