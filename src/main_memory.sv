module main_memory #(
    parameter program_file = "../test/bin/test1.hex"
)
(
    input   logic         clk,
    input   logic         rst,
    // ports for LSU
    input   logic [31:0]  wr_addr,
    input   logic [31:0]  wr_data,
    input   logic         wr_en,
    input   logic [31:0]  rd_addr,
    input   logic         rd_en,
    output  logic [31:0]  data_out,
    // ports for inst fetch
    input   logic [31:0]  pc_in,
    output  logic [127:0] inst_bundle_out
);

integer check_hex = 1;
integer file;
integer ram_size = 0;

integer char;
integer r;
integer c = 0;
integer i = 0;
integer initNeeded = 1;
integer check_sram = 0;
integer addr_found = 1;

logic [3:0] slash;
logic [31:0] addr_value;
logic [31:0] data_value;
logic [8*100:1] line;
logic [31:0] dbuf;

localparam NUM_WORDS = 36;

// Define the memory array
logic [31:0] mem [0:NUM_WORDS-1][0:1];

// Write to the memory array when write_en is high
always_ff @(posedge clk) begin
    if (wr_en) mem[wr_addr / 4][1] <= wr_data;
end

// Read from the memory array
always_ff @(posedge clk) begin
    if (rd_en) data_out <= mem[rd_addr / 4][1];
end

assign inst_bundle_out = {mem[pc_in / 4][1], mem[(pc_in + 4) / 4][1], mem[(pc_in + 8) / 4][1], mem[(pc_in + 12) / 4][1]};

task reset;
    begin
    for(int i = 0; i < NUM_WORDS; i++) begin
        mem[i][0] <= '0;
        mem[i][1] <= '0;
    end
    end
endtask

task initialize;
    begin
    file = $fopen(program_file, "r");
    if (file == 0) begin
        $display("ERROR: file not found!");
        $finish;
    end
    char = $fgetc(file);
    c = 0;
    while (char != -1) begin
        line = "";
        slash = "";
        addr_value = 32'h0;
        data_value = 32'h0;

        r = $ungetc(char, file);
        r = $fgets(line, file);

        r = $sscanf(line, "%h %s %h", addr_value, slash, data_value);
        if (r == 3) begin
            mem[c][0] = addr_value;
            mem[c][1] = data_value;
            $display("Addr is written %h", mem[c][0]);
            $display("Data is written %h", mem[c][1]);
            c = c + 1;
            ram_size = ram_size + 1;
        end
        else if ((r == 2) || (r == 1)) begin
            $display("ERROR: Data %h is not in hex format: ", data_value);
            $finish;
        end
        char = $fgetc(file);
    end
    end
endtask

always @(posedge rst) begin
    // $display("Resetting RAM to 0s...");
    // reset();
    $display("Initialzing RAM with program values...");
    initialize();
end

endmodule
