setenv LMC_TIMEUNIT -9
vlib work
vmap work work

vlog -work work "test/tb/vliw_tb.sv"
vlog -work work "src/**/*.sv"
vlog -work work "src/*.sv"

vsim -debugDB -classdebug -voptargs=+acc +notimingchecks -L work work.vliw_tb -wlf vliw_tb.wlf

# add the clock and reset
add wave -noupdate -group vliw_tb
add wave -noupdate -group vliw_tb -radix hexadecimal /vliw_tb/*

# add dut signals
add wave -noupdate -group vliw_tb/dut
add wave -noupdate -group vliw_tb/dut -radix hexadecimal /vliw_tb/dut/*

# add the program counter
add wave -noupdate -group vliw_tb/dut/pc
add wave -noupdate -group vliw_tb/dut/pc -radix hexadecimal /vliw_tb/dut/pc/*

# add the reg file registers
add wave -noupdate -group vliw_tb/dut/reg_file/regs
add wave -noupdate -group vliw_tb/dut/reg_file/regs -radix hexadecimal /vliw_tb/dut/reg_file/regs

# add the reg file signals
add wave -noupdate -group vliw_tb/dut/reg_file
add wave -noupdate -group vliw_tb/dut/reg_file -radix hexadecimal /vliw_tb/dut/reg_file/*

# add ixu1
add wave -noupdate -group vliw_tb/dut/ixu_1
add wave -noupdate -group vliw_tb/dut/ixu_1 -radix hexadecimal /vliw_tb/dut/ixu_1/*

# add ixu2
add wave -noupdate -group vliw_tb/dut/ixu_2
add wave -noupdate -group vliw_tb/dut/ixu_2 -radix hexadecimal /vliw_tb/dut/ixu_2/*

# add lsu
add wave -noupdate -group vliw_tb/dut/lsu_instance
add wave -noupdate -group vliw_tb/dut/lsu_instance -radix hexadecimal /vliw_tb/dut/lsu_instance/*

# add lsu writeback signals
add wave -noupdate -group vliw_tb/dut/lsu_instance/lsu_writeback_instance
add wave -noupdate -group vliw_tb/dut/lsu_instance/lsu_writeback_instance -radix hexadecimal /vliw_tb/dut/lsu_instance/lsu_writeback_instance/*

# add branch
add wave -noupdate -group vliw_tb/dut/bru
add wave -noupdate -group vliw_tb/dut/bru -radix hexadecimal /vliw_tb/dut/bru/*

# add forwarding unit
add wave -noupdate -group vliw_tb/dut/fwu
add wave -noupdate -group vliw_tb/dut/fwu -radix hexadecimal /vliw_tb/dut/fwu/*

# add hazard detection
add wave -noupdate -group vliw_tb/dut/hzd
add wave -noupdate -group vliw_tb/dut/hzd -radix hexadecimal /vliw_tb/dut/hzd/*

# add memory array
add wave -noupdate -group vliw_tb/dut/ram/mem
add wave -noupdate -group vliw_tb/dut/ram/mem -radix hexadecimal /vliw_tb/dut/ram/mem

# add ram signals
add wave -noupdate -group vliw_tb/dut/ram
add wave -noupdate -group vliw_tb/dut/ram -radix hexadecimal /vliw_tb/dut/ram/*

run -all