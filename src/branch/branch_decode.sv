// decode stage for branch instructions

module branch_decode
(
    input   logic [31:0]    inst,
    output  logic           is_nop,
    output  logic           is_jmp,
    output  logic           is_imm_type,
    output  logic           zero_ext,
    output  logic [1:0]     op,
    output  logic [4:0]     rs1,
    output  logic [4:0]     rs2,
    output  logic [4:0]     rd,
    output  logic [21:0]    imm
);

// internal signals
logic [2:0] funct3;
logic [6:0] opcode;

// combinational assigments
assign opcode = inst[6:0];

assign funct3 = inst[14:12];
assign rs1 = inst[19:15];
assign rs2 = inst[24:20];
assign rd = inst[11:7];
assign is_nop = (inst == 32'h0) ? '1 : '0;
assign zero_ext = (funct3 == 3'b110 || funct3 == 3'b111) ? '1 : '0;

always_comb begin

    // branch instruction
    if (opcode == 7'b1100011) begin
        is_jmp = '0;
        is_imm_type = '0;
        imm = {inst[31], inst[7], inst[30:25], inst[11:8]};
        if (funct3 == 3'h0) begin
            op = 2'b00;
        end else if (funct3 == 3'h1) begin
            op = 2'b01;
        end else if (funct3 == 3'h4 || funct3 == 3'h6) begin
            op = 2'b10;
        end else if (funct3 == 3'h5 || funct3 == 3'h7) begin
            op = 2'b11;
        end else begin
            $error("BRANCH DECODE ERROR: invalid funct3 bits provided!");
        end
    // JAL instruction
    end else if (opcode == 7'b1101111) begin
        imm = {inst[31], inst[19:12], inst[20], inst[30:21]};
        is_jmp = '1;
        is_imm_type = '0;
        op = '0;
    // JALR instruction
    end else if (opcode == 7'b1100111) begin
        imm = inst[31:20];
        is_jmp = '1;
        is_imm_type = '1;
        op = '0;
    end else begin
        $error("BRANCH DECODE ERROR: invalid opcode bits provided");
    end

end

endmodule