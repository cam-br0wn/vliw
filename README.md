
# RISC-(V)LIW

## About
This is a very rudimentary (and in-progress) implementation of a VLIW RISC-V architecture done as an independent project at Northwestern University.

## Features
1. Four 3-stage in-order pipelines: two IXU, branch/jmp, and LSU.
2. Data-forwarding unit
3. RAW hazard detection
4. A parser that converts from (a very strict form of) RISC-V assembly to binary the testbench/memory can use, written in Python3

## Details
- See `test/asm` for assembly examples
- See `test/bin` for the hex the parser converts them to
- I run `source questasim.env` from zsh and then `vsim -do <do file>` to launch simulator
- The file being run on any given simulation is `parameter test_file` in `test/tb/vliw_tb.sv`
- Big-Endian addressing
- Memory accesses can be made in word (32b), half-word (16b) or byte (8b) sizes
- Memory latency is currently simulated as being a single cycle
- Instruction access is simulated as being combinational for the time being

### Completed & To-do
- All integer operations working ✅
- Memory operations working ✅
- Data-forwarding working ✅
- Branching nearly working...

### Next steps
- Floating point
- Caches/realistic memory model
- Branch Pred
- Compiler
