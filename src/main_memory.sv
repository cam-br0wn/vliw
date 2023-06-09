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
    input   logic [1:0]   wr_size,
    input   logic [31:0]  rd_addr,
    input   logic         rd_en,
    input   logic [1:0]   rd_size,
    input   logic         rd_zero_ext,
    output  logic [31:0]  data_out,
    // ports for inst fetch
    input   logic [31:0]  pc_in,
    output  logic [31:0]  data_start_addr,
    output  logic [127:0] inst_bundle_out
);

integer check_hex = 1;
integer file;
integer ram_size = 0;

integer char;
integer r;
integer d;
integer c = 0;
integer i = 0;
integer initNeeded = 1;
integer check_sram = 0;
integer addr_found = 1;

logic [3:0] slash;
logic [19:0] data_str;
logic [31:0] data_start;
logic [31:0] addr_value;
logic [31:0] data_value;
logic [8*100:1] line;
logic [31:0] dbuf;

localparam NUM_WORDS = 128;
logic [31:0] internal_wr_addr;
logic [31:0] internal_rd_addr;

assign internal_wr_addr = $signed(wr_addr) >>> 2;
assign internal_rd_addr = $signed(rd_addr) >>> 2;
assign data_start_addr = data_start;

// Define the memory array
logic [31:0] mem [0:NUM_WORDS-1][0:1];

// store operations
always_ff @(posedge clk) begin
    if (wr_en) begin
        // byte operation
        if (wr_size == 2'h0) begin
            if (wr_addr[1:0] == 2'h0) begin
                mem[internal_wr_addr][1] <= {mem[internal_wr_addr][1][31:8], wr_data[7:0]};
            end
            else if (wr_addr[1:0] == 2'h1) begin
                mem[internal_wr_addr][1] <= {mem[internal_wr_addr][1][31:16], wr_data[7:0], mem[internal_wr_addr][1][7:0]};
            end
            else if (wr_addr[1:0] == 2'h2) begin
                mem[internal_wr_addr][1] <= {mem[internal_wr_addr][1][31:24], wr_data[7:0], mem[internal_wr_addr][1][15:0]};
            end
            else begin
                mem[internal_wr_addr][1] <= {wr_data[7:0], mem[internal_wr_addr][1][23:0]};
            end
        end
        // half-word
        else if (wr_size == 2'h1) begin
            if (wr_addr[1:0] == 2'h0) begin
                mem[internal_wr_addr][1] <= {mem[internal_wr_addr][1][31:16], wr_data[15:0]};
            end
            else if (wr_addr[1:0] == 2'h1) begin
                mem[internal_wr_addr][1] <= {mem[internal_wr_addr][1][31:24], wr_data[15:0], mem[internal_wr_addr][1][7:0]};
            end
            else if (wr_addr[1:0] == 2'h2) begin
                mem[internal_wr_addr][1] <= {wr_data[15:0], mem[internal_wr_addr][1][15:0]};
            end
            else begin
                mem[internal_wr_addr][1] <= {wr_data[7:0], mem[internal_wr_addr][1][23:0]};
                mem[internal_wr_addr + 1][1] <= {mem[internal_wr_addr + 1][1][31:8], wr_data[15:8]};
            end
        end 
        // word
        else if (wr_size == 2'h2) begin
            if (wr_addr[1:0] == 2'h0) begin
                mem[internal_wr_addr][1] <= wr_data;
            end
            else if (wr_addr[1:0] == 2'h1) begin
                mem[internal_wr_addr][1] <= {wr_data[23:0], mem[internal_wr_addr][1][7:0]};
                mem[internal_wr_addr + 1][1] <= {mem[internal_wr_addr + 1][1][31:8], wr_data[31:24]};
            end
            else if (wr_addr[1:0] == 2'h2) begin
                mem[internal_wr_addr][1] <= {wr_data[15:0], mem[internal_wr_addr][1][15:0]};
                mem[internal_wr_addr + 1][1] <= {mem[internal_wr_addr + 1][1][31:16], wr_data[31:16]};
            end
            else begin
                mem[internal_wr_addr][1] <= {wr_data[7:0], mem[internal_wr_addr][1][23:0]};
                mem[internal_wr_addr + 1][1] <= {mem[internal_wr_addr + 1][1][31:24], wr_data[31:8]};
            end
        end
        else begin
            $error("RAM ERROR: could not determine size of store");
        end
    end
end

// load operations
always_ff @(posedge clk) begin
    if (rd_en) begin
        // byte operation
        if (rd_size == 2'h0) begin
            // unsigned load
            if (rd_zero_ext) begin
                if (rd_addr[1:0] == 2'h0) begin
                    data_out <= {24'h0, mem[internal_rd_addr][1][7:0]};
                end
                else if (rd_addr[1:0] == 2'h1) begin
                    data_out <= {24'h0, mem[internal_rd_addr][1][15:8]};
                end
                else if (rd_addr[1:0] == 2'h2) begin
                    data_out <= {24'h0, mem[internal_rd_addr][1][23:16]};
                end
                else begin
                    data_out <= {24'h0, mem[internal_rd_addr][1][31:24]};
                end
            end
            else begin
                if (rd_addr[1:0] == 2'h0) begin
                    data_out <= {{24{mem[internal_rd_addr][1][7]}}, mem[internal_rd_addr][1][7:0]};
                end
                else if (rd_addr[1:0] == 2'h1) begin
                    data_out <= {{24{mem[internal_rd_addr][1][15]}}, mem[internal_rd_addr][1][15:8]};
                end
                else if (rd_addr[1:0] == 2'h2) begin
                    data_out <= {{24{mem[internal_rd_addr][1][23]}}, mem[internal_rd_addr][1][23:16]};
                end
                else begin
                    data_out <= {{24{mem[internal_rd_addr][1][31]}}, mem[internal_rd_addr][1][31:24]};
                end
            end
        end
        // half-word
        else if (rd_size == 2'h1) begin
            // unsigned load
            if (rd_zero_ext) begin
                if (rd_addr[1:0] == 2'h0) begin
                    data_out <= {16'h0, mem[internal_rd_addr][1][15:0]};
                end
                else if (rd_addr[1:0] == 2'h1) begin
                    data_out <= {16'h0, mem[internal_rd_addr][1][23:8]};
                end
                else if (rd_addr[1:0] == 2'h2) begin
                    data_out <= {16'h0, mem[internal_rd_addr][1][31:16]};
                end
                else begin
                    data_out <= {16'h0, mem[internal_rd_addr + 1][1][7:0], mem[internal_rd_addr][1][31:24]};
                end
            end
            else begin
                if (rd_addr[1:0] == 2'h0) begin
                    data_out <= {{16{mem[internal_rd_addr][1][7]}}, mem[internal_rd_addr][1][15:0]};
                end
                else if (rd_addr[1:0] == 2'h1) begin
                    data_out <= {{16{mem[internal_rd_addr][1][15]}}, mem[internal_rd_addr][1][23:8]};
                end
                else if (rd_addr[1:0] == 2'h2) begin
                    data_out <= {{16{mem[internal_rd_addr][1][23]}}, mem[internal_rd_addr][1][31:16]};
                end
                else begin
                    data_out <= {{16{mem[internal_rd_addr + 1][1][7]}}, mem[internal_rd_addr + 1][1][7:0], mem[internal_rd_addr][1][31:24]};
                end
            end
        end
        else if (rd_size == 2'h2) begin
            if (rd_addr[1:0] == 2'h0) begin
                data_out <= mem[internal_rd_addr][1];
            end
            else if (rd_addr[1:0] == 2'h1) begin
                data_out <= {mem[internal_rd_addr + 1][1][7:0], mem[internal_rd_addr][1][31:8]};
            end
            else if (rd_addr[1:0] == 2'h2) begin
                data_out <= {mem[internal_rd_addr + 1][1][15:0], mem[internal_rd_addr][1][31:16]};
            end
            else begin
                data_out <= {mem[internal_rd_addr + 1][1][23:0], mem[internal_rd_addr][1][31:24]};
            end
        end
        else begin
            $error("RAM ERROR: Invalid size provided for load operation");
        end
    end
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
    data_start = '0;
    while (char != -1) begin
        line = "";
        slash = "";
        addr_value = 32'h0;
        data_value = 32'h0;
    
        r = $ungetc(char, file);
        r = $fgets(line, file);

        r = $sscanf(line, "%h %s %h", addr_value, slash, data_value);
        d = $sscanf(line, "%s", data_str);
        if (r == 3) begin
            mem[c][0] = addr_value;
            mem[c][1] = data_value;
            $display("Wrote: %h : %h", mem[c][0], mem[c][1]);
            c = c + 1;
            ram_size = ram_size + 1;
        end
        else if (d == 1) begin
            data_start = mem[c-1][0] + 4;
            $display("Located DATA memory start at: %08x", (mem[c-1][0] + 4));
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
