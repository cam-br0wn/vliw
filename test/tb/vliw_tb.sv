// top level testbench
module vliw_tb;

logic clk;
logic rst;

vliw dut (
    .clk(clk),
    .rst(rst)
);

initial begin
    clk = '0;
    forever
    #10 clk = ~clk;
end

initial begin
    rst = '0; 
    #10;
    rst = '1;
    #10;
    rst = '0;
    #100;
end

endmodule