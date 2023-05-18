// execution module for integer operations

module ixu_execute
(
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

logic [31:0] X;
logic [31:0] Y;

assign X = rs1_data;
assign Y = (is_imm_type) ? {{20{imm[11]}}, imm} : rs2_data;

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
        out = (is_imm_type) ? X >>> Y[4:0] : X >>> Y; // this one probably doesn't work cuz >>> operator sucks
    // SLT or SLTI
    end else if ( op == 4'h8 ) begin
        out = ($signed(X) < $signed(Y)) ? 32'h1 : 32'h0;
    // SLTU or SLTUI
    end else if ( op == 4'h9 ) begin
        out = (is_imm_type) ? (($unsigned(X) < $unsigned({{20{1'b0}}, Y[11:0]})) ? 32'h1 : 32'h0) : (($unsigned(X) < $unsigned(Y)) ? 32'h1 : 32'h0);
    // otherwise invalid opcode
    end else begin
        $error("IXU ALU ERROR: invalid op bits in ALU");
        out = 32'hDEADBEEF;
    end
end

endmodule