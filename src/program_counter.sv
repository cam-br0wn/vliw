// program counter module

module program_counter
(
    input   logic           clk,
    input   logic           rst,
    input   logic           branch_taken,
    input   logic [31:0]    new_pc,
    output  logic [31:0]    pc
);

always_ff @ (posedge clk or posedge rst) begin

    if (rst == 1'b1) begin
        pc <= 32'h00400020;
    end
    else if (branch_taken == 1'b1) begin
        pc <= new_pc;
    end
    else begin
        // add decimal 20 to pc on every clock pulse b/c 5 inst * 4 B/inst = 20B
        pc <= $signed(pc) + $signed(32'h00000014);
    end
end

endmodule