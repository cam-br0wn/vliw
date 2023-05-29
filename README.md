
# RISC-(V)LIW

### This is a work in progress! ###

## About
This is a very rudimentary implementation of a VLIW RISC-V architecture does as an independent project at Northwestern University. No compiler has been written for this architecture, and as such, it's pretty much useless.

## Features
1. Four 3-stage in-order pipelines: two IXU, branch/jmp, and LSU.
2. Forwarding unit
3. That's it.


### To-do
- Hook up the destination registers of writeback to the hazard detector
- Wire up the top level
- Write compatible binaries and top-level testbench
- Make sure reading indexing of 4-inst bundles is correct from inst mem -> decode
- *check behavior of inst mem/PC on stalls*

### For future consideration
- Floating point
- Caches
- Branch Pred
- A compiler?
