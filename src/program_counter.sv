// program counter module

module program_counter
(
    input   logic           clk,
    input   logic           rst,
    input   logic           stall,
    input   logic           branch_taken,
    input   logic [31:0]    new_pc,
    output  logic [31:0]    pc,
    output  logic           squash
);

logic   [31:0]  program_counter;
// if there is a branch taken, on the next cycle, we need to issue squash to all pipe's decode and execute
// the latency between a branch taken evaluating true and the branch-taken instruction hitting decode is 2 cycles
// cycle n: branch taken computed, squash sent from branch-exec to PC
// cycle n+1: PC reads out branch-taken addr to inst mem, issues squashes to ID/EX and EX/WB D-pins
// cycle n+2: inst mem reads out branch-taken instruction to decodes, all executes and writebacks are NOPs

always_ff @ (posedge clk or posedge rst) begin

    if (rst == 1'b1) begin
        // initialize the program counter to address 0x00400020
        program_counter <= 32'h00400020;
        squash <= '0;
    end
    else if (branch_taken == 1'b1) begin
        program_counter <= new_pc;
        squash <= '1;
    end
    else if (stall == 1'b1) begin
        program_counter <= program_counter;
    end
    else begin
        // add decimal 16 to pc on every clock pulse b/c 4 inst * 4 B/inst = 16B
        program_counter <= $signed(program_counter) + $signed(32'h00000010);
        squash <= '0;
    end
end

assign pc = program_counter;

endmodule