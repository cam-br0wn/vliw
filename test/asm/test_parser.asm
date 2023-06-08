addi x1 x0 8
addi x2 x0 4
nop
nop

sll x2 x1 x2
addi x4 x2 -5
nop
nop

nop
nop
lhu x5 x2 4
nop

nop
nop
lhu x6 x2 5
nop

nop
nop
lhu x7 x2 6
nop

nop
nop
lhu x8 x2 7
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
