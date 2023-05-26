// for loads, this module takes data from mem and stores in rd
// for stores, this module does nothing 
module lsu_writeback
(
    input   logic           is_nop,
    input   logic           is_load,
    input   logic [4:0]     rd, // dest reg
    input   logic [31:0]    data_in, // data from memory
    input   logic [1:0]     size, // byte, half-word, word
    input   logic           zero_ext, // unsigned op
    output  logic [31:0]    data_out, // data to be written to reg file
    output  logic           wr_en // drive high on loads
);

always_comb begin
    // if it's a NOP or a store
    if (is_nop == 1'b1 || is_load == 1'b0) begin
        data_out = '0;
        wr_en = '0;
    end
    // loads
    else if (is_load == 1'b1) begin
        wr_en = 1'b1;
        // unsigned operations
        if (zero_ext == 1'b1) begin
            // LBU
            if (size == 2'b00) begin
                data_out = data_in & 32'h000000FF;
            end 
            // LHU
            else if (size == 2'b01) begin
                data_out = data_in & 32'h0000FFFF;
            end else begin
                $error("LSU WB: Invalid size provided to unsigned load");
            end
        end
        else if (zero_ext == 1'b0) begin
            // LB
            if (size == 2'b00) begin
                data_out = {{24{data_in[7]}}, data_in[7:0]};
            // LH
            end else if (size == 2'b01) begin
                data_out = {{16{data_in[15]}}, data_in[15:0]};
            // LW
            end else if (size == 2'b10) begin
                data_out = data_in;
            end else begin
                $error("LSU WB: Invalid size provided to signed load in WB");
            end
        end else begin
            $error("LSU WB: zero extension flag undriven");
        end
    end
    else begin
        $error("LSU WB: could not determine instruction type");
    end

end


endmodule