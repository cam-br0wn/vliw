setenv LMC_TIMEUNIT -9
vlib work
vmap work work

vlog -work work "test/tb/vliw_tb.sv"
vlog -work work "src/**/*.sv"
vlog -work work "src/*.sv"

vsim -debugDB -classdebug -voptargs=+acc +notimingchecks -L work work.vliw_tb -wlf vliw_tb.wlf

# add the clock and reset
add wave -noupdate -group TB -radix hexadecimal /vliw_tb/*

# add top level signals
add wave -noupdate -group TOP -radix hexadecimal /vliw_tb/dut/*

# add the program counter
add wave -noupdate -group PC -radix hexadecimal /vliw_tb/dut/pc/*

# add the reg file
add wave -noupdate -group REGS -group REGS/_regs_ -radix hexadecimal /vliw_tb/dut/reg_file/regs
add wave -noupdate -group REGS -group REGS/_intr_ -radix hexadecimal /vliw_tb/dut/reg_file/*

# add ixu1
add wave -noupdate -group IXU_1 -group IXU_1/_dcod_ -radix hexadecimal /vliw_tb/dut/ixu_1/decode/*
add wave -noupdate -group IXU_1 -group IXU_1/_idex_ -radix hexadecimal /vliw_tb/dut/ixu_1/idex/*
add wave -noupdate -group IXU_1 -group IXU_1/_exec_ -radix hexadecimal /vliw_tb/dut/ixu_1/exec/*
add wave -noupdate -group IXU_1 -group IXU_1/_exwb_ -radix hexadecimal /vliw_tb/dut/ixu_1/exwb/*
add wave -noupdate -group IXU_1 -group IXU_1/_wrbk_ -radix hexadecimal /vliw_tb/dut/ixu_1/wb/*
add wave -noupdate -group IXU_1 -group IXU_1/_intr_ -radix hexadecimal /vliw_tb/dut/ixu_1/*

# add ixu2
add wave -noupdate -group IXU_2 -group IXU_2/_dcod_ -radix hexadecimal /vliw_tb/dut/ixu_2/decode/*
add wave -noupdate -group IXU_2 -group IXU_2/_idex_ -radix hexadecimal /vliw_tb/dut/ixu_2/idex/*
add wave -noupdate -group IXU_2 -group IXU_2/_exec_ -radix hexadecimal /vliw_tb/dut/ixu_2/exec/*
add wave -noupdate -group IXU_2 -group IXU_2/_exwb_ -radix hexadecimal /vliw_tb/dut/ixu_2/exwb/*
add wave -noupdate -group IXU_2 -group IXU_2/_wrbk_ -radix hexadecimal /vliw_tb/dut/ixu_2/wb/*
add wave -noupdate -group IXU_2 -group IXU_2/_intr_ -radix hexadecimal /vliw_tb/dut/ixu_2/*

# add lsu
add wave -noupdate -group LSU -group LSU/_dcod_ -radix hexadecimal /vliw_tb/dut/lsu_i/decode/*
add wave -noupdate -group LSU -group LSU/_idex_ -radix hexadecimal /vliw_tb/dut/lsu_i/idex/*
add wave -noupdate -group LSU -group LSU/_exec_ -radix hexadecimal /vliw_tb/dut/lsu_i/exec/*
add wave -noupdate -group LSU -group LSU/_exwb_ -radix hexadecimal /vliw_tb/dut/lsu_i/exwb/*
add wave -noupdate -group LSU -group LSU/_wrbk_ -radix hexadecimal /vliw_tb/dut/lsu_i/wb/*
add wave -noupdate -group LSU -group LSU/_intr_ -radix hexadecimal /vliw_tb/dut/lsu_i/*

# add branch
add wave -noupdate -group BRANCH -group BRANCH/dcod -radix hexadecimal /vliw_tb/dut/bru/decode/*
add wave -noupdate -group BRANCH -group BRANCH/idex -radix hexadecimal /vliw_tb/dut/bru/idex/*
add wave -noupdate -group BRANCH -group BRANCH/exec -radix hexadecimal /vliw_tb/dut/bru/exec/*
add wave -noupdate -group BRANCH -group BRANCH/intr -radix hexadecimal /vliw_tb/dut/bru/*

# add forwarding unit
add wave -noupdate -group FORWARD -radix hexadecimal /vliw_tb/dut/fwu/*

# add hazard detection
add wave -noupdate -group HAZARD -radix hexadecimal /vliw_tb/dut/hzd/*

# add memory array
add wave -noupdate -group RAM -group RAM/_mem_ -radix hexadecimal /vliw_tb/dut/ram/mem
add wave -noupdate -group RAM -group RAM/_intr_ -radix hexadecimal /vliw_tb/dut/ram/*

run -all