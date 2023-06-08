addi x1 x0 5
addi x2 x0 31
nop
nop

add x4 x4 x1
addi x5 x0 -1
nop
bne x1 x1 -1

add x3 x3 x1
addi x4 x4 -1
nop
bne x1 x1 -17

nop
nop
nop
bgeu x5 x3 -17

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