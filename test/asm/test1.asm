addi x1, x0, 3
addi x2, x0, 6
nop
nop

add  x3, x1, x2
addi x4, x0, 100
nop
nop

addi x6, x0, 8
nop
nop
nop

slli x6, x6, 4
nop
lw x4, 0(x4)
nop

nop
nop
sw x2, 0(x6)
nop

add x5, x5, x4
nop
nop
nop


