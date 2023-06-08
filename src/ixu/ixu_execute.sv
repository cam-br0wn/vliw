// execution module for integer operations

module ixu_execute
(
    input   logic           is_rs1_fwd,
    input   logic           is_rs2_fwd,
    input   logic [31:0]    rs1_fwd_data,
    input   logic [31:0]    rs2_fwd_data,
    input   logic [31:0]    rs1_data,
    input   logic [31:0]    rs2_data,
    input   logic [11:0]    imm,
    input   logic           is_imm_type,
    input   logic           is_nop,
    input   logic [3:0]     op,
    output  logic [31:0]    out
);

// necessary operations:
// ADD, SUB, XOR, OR, AND, SLL, SRL, SRA, SLT, SLTU
// ADDI, XORI, ORI, ANDI, SLLI, SRLI, SRAI

logic [31:0] internal_rs1_data;
logic [31:0] internal_rs2_data;

assign internal_rs1_data = (is_rs1_fwd == 1'b1) ? rs1_fwd_data : rs1_data;
assign internal_rs2_data = (is_rs2_fwd == 1'b1) ? rs2_fwd_data : rs2_data;

logic [31:0] X;
logic [31:0] Y;

assign X = internal_rs1_data;
assign Y = (is_imm_type) ? {{20{imm[11]}}, imm} : internal_rs2_data;

always_comb begin
    // NOP
    if (is_nop == 1'b1) begin
        out = '0;
    // ADD or ADDI
    end else if (op == 4'h0) begin
        out = $signed(X) + $signed(Y);
    // SUB
    end else if ( op == 4'h1 ) begin
        out = $signed(X) - $signed(Y);
    // XOR or XORI
    end else if ( op == 4'h2 ) begin
        out = X ^ Y;
    // OR or ORI
    end else if ( op == 4'h3 ) begin
        out = X | Y;
    // AND or ANDI
    end else if ( op == 4'h4 ) begin
        out = X & Y;
    // SLL or SLLI
    end else if ( op == 4'h5 ) begin
        out = (is_imm_type) ? X << Y[4:0] : X << Y;
    // SRL or SRLI
    end else if ( op == 4'h6 ) begin
        out = (is_imm_type) ? X >> Y[4:0] : X >> Y;
    // SRA or SRAI
    end else if ( op == 4'h7 ) begin
        out = (is_imm_type) ? $signed(X) >>> Y[4:0] : $signed(X) >>> Y;
    // SLT or SLTI
    end else if ( op == 4'h8 ) begin
        out = ($signed(X) < $signed(Y)) ? 32'h1 : 32'h0;
    // SLTU or SLTUI
    end else if ( op == 4'h9 ) begin
        out = ($unsigned(X) < $unsigned(Y)) ? 32'h1 : 32'h0;
    // otherwise invalid opcode
    end else begin
        $error("IXU ALU ERROR: invalid op bits in ALU");
        out = 32'hDEADBEEF;
    end
end

endmodule