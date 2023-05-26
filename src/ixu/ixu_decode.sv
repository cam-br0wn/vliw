module ixu_decode
(
    input   logic [31:0]    inst,
    output  logic [3:0]     op,
    output  logic           is_nop,
    output  logic           is_imm_type,
    output  logic [4:0]     rs1,
    output  logic [4:0]     rs2,
    output  logic [4:0]     rd,
    output  logic [11:0]    imm
);

// internal signals
logic [6:0] opcode;
logic [2:0] funct3;
logic [6:0] funct7;

assign opcode = inst[6:0];
assign funct3 = inst[14:12];
assign funct7 = inst[31:25];
assign rs1 = inst[19:15];
assign rd = inst[11:7];

// drive an output signal to be used on a mux between reg file and pipeline reg
always_comb begin
    if (inst == 32'h0) begin
        is_nop = 1'b1;
        rs2 = '0;
        imm = '0;
    // R-type
    end else if (opcode == 7'b0110011) begin
        is_imm_type = 1'b0;
        is_nop = 1'b0;
        rs2 = inst[24:20];
        imm = '0;
    // I-type
    end else if (opcode == 7'b0010011) begin
        is_imm_type = 1'b1;
        is_nop = 1'b0;
        rs2 = '0;
        imm = inst[31:20];

    // Neither and not a NOP (which is wrong)
    end else begin
        $error("IXU DECODE ERROR: invalid opcode");
    end
end

// determine op bits
always_comb begin
    // parse funct3
    // either ADD or SUB
    if (funct3 == 3'h0) begin
        op = (funct7 == 7'h00) ? 4'h0 : 4'h1;
    // XOR
    end else if (funct3 == 3'h4) begin
        op = 4'h2;
    // OR
    end else if (funct3 == 3'h6) begin
        op = 4'h3;
    // AND
    end else if (funct3 == 3'h7) begin
        op = 4'h4;
    // SLL
    end else if (funct3 == 3'h1) begin
        op = 4'h5;
    // SRL or SRA
    end else if (funct3 == 3'h5) begin
        op = (funct7 == 7'h00) ? 4'h6 : 4'h7;
    // SLT
    end else if (funct3 == 3'h2) begin
        op = 4'h8;
    // SLTU
    end else if (funct3 == 3'h3) begin
        op = 4'h9;
    // invalid funct3
    end else begin
        $error("INVALID FUNCT3 BITS");
        op = 4'hF;
    end
end


endmodule