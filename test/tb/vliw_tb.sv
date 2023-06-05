// top level testbench
`timescale 1ns/1ns
module vliw_tb;

logic clk;
logic rst;
parameter test_file = "test/bin/test1.hex";

vliw #(test_file)
dut (
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
    #1;
    rst = '1;
    #19;
    rst = '0;
    #300;
    $stop;
end

endmodule