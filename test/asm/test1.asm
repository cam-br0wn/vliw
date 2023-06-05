addi x1, x0, 24
addi x2, x0, 32
nop
nop

add  x3, x1, x2
addi x4, x0, 1
nop
nop

slli x4, x4, 28
nop
nop
nop

nop
nop
lw  x5, x4, x0
nop

add x5, x5, x4
nop
nop
nop
