addi x1, x0, 8
addi x2, x0, 4
nop
nop

sll x2, x1, x2
addi x4, x2, -5
nop
nop

nop
nop
lhu x5, 4(x2)
nop

nop
nop
lhu x6, 5(x2)
nop

nop
nop
lhu x7, 6(x2)
nop

nop
nop
lhu x8, 7(x2)
nop

.DATA
7
0
0
0
0
0
babecafe
deadbeef
d00dface
0
0
