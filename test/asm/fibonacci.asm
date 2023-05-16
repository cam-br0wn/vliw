fibonacci():
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      zero,-20(s0)
        li      a5,1
        sw      a5,-24(s0)
        sw      zero,-28(s0)
        j       .L2
.L3:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        add     a5,a4,a5
        sw      a5,-32(s0)
        lw      a5,-24(s0)
        sw      a5,-20(s0)
        lw      a5,-32(s0)
        sw      a5,-24(s0)
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L2:
        lw      a4,-28(s0)
        li      a5,9
        ble     a4,a5,.L3
        lw      a5,-24(s0)
        mv      a0,a5
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra