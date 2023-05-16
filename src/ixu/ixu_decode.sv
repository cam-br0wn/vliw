module ixu_decode
(
    input logic [31:0] inst,
    output logic [4:0] op,
    output logic is_imm_type
);

// we need to access regs this cycle so data is ready next cycle

// internal signals
logic [6:0] opcode;
logic [2:0] funct3;
logic [6:0] funct7;

assign opcode = inst[6:0];
assign funct3 = inst[14:12];
assign funct7 = inst[31:25];

// drive an output signal to be used on a mux between reg file and pipeline reg
always_comb begin
    // R-type
    if (opcode == 7'b0110011) begin
        is_imm_type = 1'b0;
    // I-type
    end else if (opcode == 7'b0010011) begin
        is_imm_type = 1'b1;
    // Neither (which is wrong)
    end else begin
        $error("ERROR: INVALID BITS IN OPCODE   !!");
        $quit;
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
    end else (funct3 == 3'h3) begin
        op = 4'h9;
    // invalid funct3
    end else begin
        $error("INVALID FUNCT3 BITS");
        op = 4'hF;
    end
end


endmodule