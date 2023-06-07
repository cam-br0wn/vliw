// combinational module to decode load/store instructions

module lsu_decode
(
    input   logic [31:0]    inst,
    output  logic           is_load,
    output  logic           zero_ext,
    output  logic           is_nop,
    output  logic [1:0]     size,
    output  logic [4:0]     rs1,
    output  logic [4:0]     rs2,
    output  logic [4:0]     rd,
    output  logic [11:0]    imm
);

// memory instructions include
// LB, LH, LW, LBU, LHU
// SB, SH, SW
// LBU and LHU zero-extend the data

logic [2:0] funct3;
logic [6:0] opcode;

assign funct3 = inst[14:12];
assign opcode = inst[6:0];

always_comb begin
    // don't really want default values...
    zero_ext = '0;
    // if it is a load
    if (opcode == 7'b0000011) begin
        rs1 = inst[19:15];
        rs2 = '0;
        rd = inst[11:7];
        imm = inst[31:20];
        is_nop = 1'b0;
        is_load = '1;
        zero_ext = (funct3 == 3'h4) || (funct3 == 3'h5);
        
        // sizing
        if ((funct3 == 3'h0) || (funct3 == 3'h4)) begin
            size = 2'h0;
        end
        else if ((funct3 == 3'h1) || (funct3 == 3'h5)) begin
            size = 2'h1;
        end
        else begin
            size = 2'h2;
        end
    end
    else if (opcode == 7'b0100011) begin
        rs1 = inst[19:15];
        rs2 = inst[24:20];
        rd = '0;
        imm = {{5{inst[31]}}, inst[31:25]};
        is_nop = '0;
        is_load = '0;
        zero_ext = '0;
        // sizing
        if (funct3 == 3'h0) begin
            size = 2'h0;
        end
        else if (funct3 == 3'h1) begin
            size = 2'h1;
        end
        else begin
            size = 2'h2;
        end
    end
        // NOTE: we don't calculate the load/store address at this stage, that's done in execution stage
    // if it is a NOP, continue but don't float signals
    else if (inst == 32'h00000000) begin
        is_nop = '1;
        is_load = '0;
        rs1 = '0;
        rs2 = '0;
        rd = '0;
        imm = '0;
        zero_ext = '0;
        size = '0;
    end else begin
        $error("LSU DECODE: couldn't determine inst");
    end
end

endmodule