addi x1 x0 10
addi x2 x0 2
nop
nop

add x3 x1 x2
sub x4 x2 x1
nop
nop

xor x5 x1 x2
or x6 x1 x2
nop
nop

and x7 x1 x2
sll x8 x1 x2
nop
nop

srl x9 x8 x2
sra x10 x4 x2
nop
nop

slt x11 x2 x1
sltu x12 x1 x4
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