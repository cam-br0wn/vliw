setenv LMC_TIMEUNIT -9
vlib work
vmap work work

vlog -work work "/home/ckb4640/vliw/src/ixu/ixu_execute.sv"
vlog -work work "/home/ckb4640/vliw/test/tb/ixu/ixu_execute_tb.sv"

vsim -classdebug -voptargs=+acc +notimingchecks -L work work.ixu_execute_tb -wlf ixu_execute.wlf\

add wave -noupdate -group ixu_execute_tb
add wave -noupdate -group ixu_execute_tb -radix hexadecimal /ixu_execute_tb/*

run -all