
# RISC-(V)LIW

## About
This is a very rudimentary implementation of a VLIW RISC-V architecture done as an independent project at Northwestern University.

# Details
- Big-Endian addressing
- Memory accesses can be made in word (32b), half-word (16b) or byte (8b) sizes
- Memory latency is currently simulated as being a single cycle
- Instruction access is simulated as being combinational

## Features
1. Four 3-stage in-order pipelines: two IXU, branch/jmp, and LSU.
2. Forwarding unit
3. RAW hazard detection
4. A parser from (a very strict form of) RISC-V assembly to binary the testbench/memory can use, written in Python 3


### To-do and Completed
- All integer operations working ✅
- Byte-addressing working ✅
- Test branching
- Test stalling
- *check behavior of inst mem/PC on stalls*

### For future consideration
- Floating point
- Caches/realistic memory model
- Branch Pred
- Compiler
