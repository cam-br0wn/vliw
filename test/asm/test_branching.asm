addi x1 x0 5
addi x2 x0 31
nop
nop

add x4 x4 x1
nop
nop
bne x1 x1 -1

add x3 x3 x1
nop
nop
bne x1 x1 -17

nop
nop
nop
jal x5 -17

add x3 x0 x2
nop
nop
nop

.DATA
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0