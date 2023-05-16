module ixu_alu
(
    input [31:0] X,
    input [31:0] Y,
    input [3:0] op,
    output [31:0] out
);

// necessary operations:
// ADD, SUB, XOR, OR, AND, SLL, SRL, SRA, SLT, SLTU
// ADDI, XORI, ORI, ANDI, SLLI, SRLI, SRAI

always_comb begin

    // ADD or ADDI
    if (op == 4'h0) begin
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
        out = X << Y;

    // SRL or SRLI
    end else if ( op == 4'h6 ) begin
        out = X >> Y;

    // SRA or SRAI
    end else if ( op == 4'h7 ) begin
        out = X >>> Y;

    // SLT or SLTI
    end else if ( op == 4'h8 ) begin
        out = ($signed(X) < $signed(Y)) ? 32'h1 : 32'h0;

    // SLTU or SLTUI
    end else if ( op == 4'h9 ) begin
        out = ($unsigned(X) < $unsigned(Y)) ? 32'h1 : 32'h0;

    // otherwise invalid opcode
    end else begin
        $error("ERROR: INVALID OP BITS PROVIDED TO ALU");
        out = 32'hDEADBEEF;
    end

end

endmodule