// combinational module to decode load/store instructions

module lsu_decode
(
    input logic [31:0] inst,
    input logic stall,
    output logic is_load,
    output logic zero_ext,
    output logic is_nop,
    output logic [1:0] size,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [11:0] imm
);

// memory instructions include
// LB, LH, LW, LBU, LHU
// SB, SH, SW
// LBU and LHU zero-extend the data

// TODO: Implement stalling capability that issues a NOP

logic [2:0] funct3;
logic [6:0] funct7;

assign funct3 = inst[14:12];
assign funct7 = inst[31:25];

always_comb begin
    // don't really want default values...
    zero_ext = '0;
    // if it is a load
    if (stall == 1'b0 && (funct7 == 7'b0000011 || funct7 == 7'b0100011)) begin

        // set is_nop to 0
        is_nop = 1'b0;

        // set the is_load flag accordingly
        is_load = (funct7 == 7'b0000011) ? '1 : '0;
        
        // only assign rs2 if it's a store
        rs2 = (funct7 == 7'b0100011) ? inst[24:20] : '0;

        // resize immediate if it's a store
        imm = (funct7 == 7'b0100011) ? {{5{inst[31]}}, inst[31:25]} : inst[31:20];

        // set the zero-extension flag if it is an unsigned operation
        zero_ext = (funct3 == 3'h4 || funct3 == 3'h5) ? '1 : '0;
        
        // if the load/store size is a byte
        if (funct3 == 3'h0 || funct3 == 3'h4) begin
            size = 2'b00;
        
        // if the load/store size is a half-word
        end else if (funct3 == 3'h1 || funct3 == 3'h5) begin
            size = 2'b01;
        
        // otherwise it's a full word
        end else begin
            size = 2'b10;
        end

        // NOTE: we don't calculate the load/store address at this stage, that's done in execution stage

    // if it is a NOP, continue but don't float signals
    end else if (inst == 32'h00000000 || stall == 1'b1) begin

        is_nop = 1'b1;

    end else begin
        $error("INVALID FUNCT7 BITS PROVIDED TO LSU DECODE");
    end
end

endmodule