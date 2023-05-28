# compiled with godbolt on RISC-V rv32gc clang (trunk)
add(int):                                # @add(int)
        addi    sp, sp, -16
        sw      ra, 12(sp)                      # 4-byte Folded Spill
        sw      s0, 8(sp)                       # 4-byte Folded Spill
        addi    s0, sp, 16
        sw      a0, -12(s0)
        lw      a0, -12(s0)
        add     a0, a0, a0
        lw      ra, 12(sp)                      # 4-byte Folded Reload
        lw      s0, 8(sp)                       # 4-byte Folded Reload
        addi    sp, sp, 16
        ret