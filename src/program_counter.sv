// program counter module

module program_counter
(
    input   logic           clk,
    input   logic           rst,
    input   logic           stall,
    input   logic           branch_taken,
    input   logic           dont_squash_dec_in,
    input   logic           dont_squash_exec_in,
    input   logic [31:0]    new_pc,
    input   logic [31:0]    data_start_addr,
    input   logic           halt_in,
    output  logic [31:0]    pc,
    output  logic           squash,
    output  logic           dont_squash_dec_out,
    output  logic           dont_squash_exec_out,
    output  logic           halt_out
);

logic   [31:0]  program_counter;
// if there is a branch taken, on the next cycle, we need to issue squash to all pipe's decode and execute
// the latency between a branch taken evaluating true and the branch-taken instruction hitting decode is 2 cycles
// cycle n: branch taken computed, squash sent from branch-exec to PC
// cycle n+1: PC reads out branch-taken addr to inst mem, issues squashes to ID/EX and EX/WB D-pins
// cycle n+2: inst mem reads out branch-taken instruction to decodes, all executes and writebacks are NOPs

always_ff @ (posedge clk or posedge rst) begin

    if (rst == 1'b1) begin
        dont_squash_dec_out <= '0;
        dont_squash_exec_out <= '0;
        // initialize the program counter to address 0x00400020
        program_counter <= 32'h00000004;
        squash <= '0;
        halt_out <= '0;
    end
    else if (branch_taken == 1'b1) begin
        dont_squash_dec_out <= dont_squash_dec_in;
        dont_squash_exec_out <= dont_squash_exec_in;
        program_counter <= new_pc;
        squash <= '1;
    end
    else if (stall == 1'b1) begin
        dont_squash_dec_out <= '0;
        dont_squash_exec_out <= '0;
        program_counter <= program_counter;
    end
    // else if (program_counter >= data_start_addr) begin
    //     $display("Program Completed. Have a nice day.");
    //     $stop;
    // end
    else begin
        dont_squash_dec_out <= '0;
        dont_squash_exec_out <= '0;
        // add decimal 16 to pc on every clock pulse b/c 4 inst * 4 B/inst = 16B
        program_counter <= $signed(program_counter) + $signed(32'h00000010);
        squash <= '0;
    end

    // halt logic
    if (halt_out == '0) begin
        halt_out = halt_in;
    end else begin
        halt_out = halt_out;
    end
end

assign pc = program_counter;


endmodule