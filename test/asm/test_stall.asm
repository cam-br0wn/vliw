addi x1 x0 0xf
addi x2 x0 0x70
nop
nop

nop
nop
lw x5 x2 0
nop

add x6 x5 x0
sub x7 x5 x0
nop
beq x5 x5 32

add x1 x1 x1
nop
nop
nop

addi x1 x0 10
nop
nop
ecall

.DATA

0
0
0
0

0
0
0
0xbeefface

0
0
0
0

0
0
0

