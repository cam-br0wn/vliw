module ixu_decode
(
    input   logic [31:0]    inst,
    output  logic [3:0]     op,
    output  logic           is_nop,
    output  logic           is_imm_type,
    output  logic [4:0]     rs1,
    output  logic [4:0]     rs2,
    output  logic [4:0]     rd,
    output  logic [19:0]    imm
);

// internal signals
logic [6:0] opcode;
logic [2:0] funct3;
logic [6:0] funct7;

assign opcode = inst[6:0];
assign rd = inst[11:7];

// drive an output signal to be used on a mux between reg file and pipeline reg
always_comb begin
    // R-type instruction
    if (opcode == 7'b0110011) begin
        funct3 = inst[14:12];
        rs1 = inst[19:15];
        funct7 = inst[31:25];
        rs2 = inst[24:20];
        imm = '0;
        is_imm_type = '0;
        is_nop = '0;
        // add or sub
        if (funct3 == 3'h0) begin
            // add
            if (funct7 == 7'h00) begin
                op = 4'h0;
            end
            // sub
            else if (funct7 == 7'h20) begin
                op = 4'h1;
            end
        end
        // xor
        else if (funct3 == 3'h4) begin
            op = 4'h2;
        end
        // or
        else if (funct3 == 3'h6) begin
            op = 4'h3;
        end
        // and
        else if (funct3 == 3'h7) begin
            op = 4'h4;
        end
        // sll
        else if (funct3 == 3'h1) begin
            op = 4'h5;
        end
        // srl or sra
        else if (funct3 == 3'h5) begin
            // srl
            if (funct7 == 7'h00) begin
                op = 4'h6;
            end
            // sra
            else if (funct7 == 7'h20) begin
                op = 4'h7;
            end
        end
        // slt
        else if (funct3 == 3'h2) begin
            op = 4'h8;
        end
        // sltu
        else if (funct3 == 3'h3) begin
            op = 4'h9;
        end
        else begin
            $error("IXU DECODE ERROR: could not decode IXU reg instr");
        end
    end
    // I-type instruction
    else if (opcode == 7'b0010011) begin
        funct3 = inst[14:12];
        rs1 = inst[19:15];
        funct7 = '0;
        rs2 = '0;
        imm = {{8{inst[31]}}, inst[31:20]};
        is_imm_type = '1;
        is_nop = '0;
        // addi
        if (funct3 == 3'h0) begin
            op = 4'h0;
        end
        // xori
        else if (funct3 == 3'h4) begin
            op = 4'h2;
        end
        // ori
        else if (funct3 == 3'h6) begin
            op = 4'h3;
        end
        // andi
        else if (funct3 == 3'h7) begin
            op = 4'h4;
        end
        // slli
        else if (funct3 == 3'h1) begin
            op = 4'h5;
        end
        // srli or srai
        else if (funct3 == 3'h5) begin
            // srli
            if (imm[11:5] == 7'h00) begin
                op = 4'h6;
            end
            // srai
            else if (imm[11:5] == 7'h20) begin
                op = 4'h7;
            end
        end
        // slti
        else if (funct3 == 3'h2) begin
            op = 4'h8;
        end
        // sltiu
        else if (funct3 == 3'h3) begin
            op = 4'h9;
        end
        else begin
            $error("IXU DECODE ERROR: could not decode IXU imm instr");
        end
    end
    // U-type
    else if ((opcode == 7'b0110111) || (opcode == 7'b0010111)) begin
        // LUI
        if (opcode == 7'b0110111) begin
            op = 4'hA;
        end
        // AUIPC
        if (opcode == 7'b0010111) begin
            op = 4'hB;
        end
        funct7 = '0;
        rs2 = '0;
        imm = inst[31:12];
        is_imm_type = '1;
        is_nop = '0;
    end
    // NOP
    else if (inst == 32'h00000000) begin
        funct3 = '0;
        op = '0;
        rs1 = '0;
        funct7 = '0;
        rs2 = '0;
        imm = '0;
        is_imm_type = '0;
        is_nop = '1;
    end
    else begin
        $error("IXU DECODE ERROR: invalid IXU instr");
    end
end

endmodule