// execution of branch

module branch_execute
(
    input   logic           is_nop,
    input   logic           zero_ext,
    input   logic           is_jmp,
    input   logic           is_imm_type,
    input   logic [31:0]    pc,
    input   logic [1:0]     op,
    input   logic [31:0]    rs1_data,
    input   logic [31:0]    rs2_data,
    input   logic [21:0]    imm,
    output  logic           branch_taken,
    output  logic           new_pc
);

logic [31:0] internal_imm;
// if it's a JAL, only sign extend by 10 bits, otherwise sign extend by 20
assign internal_imm = (is_jmp == '1 && is_imm_type == '0) ? {{10{imm[21]}}, imm} : {{20{imm[11]}}, imm};

always_comb begin
    if (is_nop == '0) begin
        // branch instruction
        if (is_jmp == '0 && is_imm_type == '0) begin
            // BEQ
            if (op == 2'h0) begin
                branch_taken = (rs1_data == rs2_data) ? '1 : '0;
                new_pc = $signed(pc) + $signed(internal_imm);
            // BNE
            end else if (op == 2'h1) begin
                branch_taken = (rs1_data == rs2_data) ? '0 : '1;
                new_pc = $signed(pc) + $signed(internal_imm);
            // BLT or BLTU
            end else if (op == 2'h2) begin
                if (zero_ext == 1'b1) begin
                    branch_taken = ($unsigned(rs1_data) < $unsigned(rs2_data)) ? '1 : '0;
                    new_pc = $signed(pc) + $signed(internal_imm);
                end else if (zero_ext == 1'b0) begin
                    branch_taken = ($signed(rs1_data) < $signed(rs2_data)) ? '1 : '0;
                    new_pc = $signed(pc) + $signed(internal_imm);
                end else begin
                    $error("BRANCH EXEC ERROR: zero ext flag not set");
                end
            // BGE OR BGEU
            end else if (op == 2'h3) begin
                if (zero_ext == 1'b1) begin
                    branch_taken = ($unsigned(rs1_data) >= $unsigned(rs2_data)) ? '1 : '0;
                    new_pc = $signed(pc) + $signed(internal_imm);
                end else if (zero_ext == 1'b0) begin
                    branch_taken = ($signed(rs1_data) >= $signed(rs2_data)) ? '1 : '0;
                    new_pc = $signed(pc) + $signed(internal_imm);
                end else begin
                    $error("BRANCH EXEC ERROR: zero ext flag not set");
                end
            // invalid opcode
            end else begin
                $error("BRANCH EXEC ERROR: branch opcode bits not driven");
            end

        // JAL
        end else if (is_jmp == '1 && is_imm_type == '0) begin
            branch_taken = '1;
            new_pc = $signed(pc) + $signed(internal_imm);
            
        // JALR
        end else if (is_jmp == '1 && is_imm_type == '1) begin
            branch_taken = '1;
            new_pc = $signed(pc) + $signed(internal_imm);

        // INVALID
        end else begin
            $error("BRANCH EXEC ERROR: could not determine if br, jal or jalr");
        end
    end else if (is_nop == '1) begin
        branch_taken = '0;
    end else begin
        $error("BRANCH EXEC ERROR: is_nop is floating");
    end
end

endmodule