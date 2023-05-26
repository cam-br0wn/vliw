
# RISC-(V)LIW

### This is a work in progress! ###

## About
This is a very rudimentary implementation of a VLIW RISC-V architecture does as an independent project at Northwestern University. No compiler has been written for this architecture, and as such, it's pretty much useless.

## Features
1. Four 3-stage in-order pipelines: two IXU, branch/jmp, and LSU.
2. Forwarding unit
3. That's it.


### To-do
- Get decode squashing working upon branch taken
- Hook up the destination registers of writeback to the hazard detector
- Write the fetch logic
- Write the instruction memory file (in theory prefetching?)

### For future consideration
- Floating point
- Caches
- Branch Pred
- A compiler?
