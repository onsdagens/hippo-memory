# Hippo Memory

This is a Bender package of the memory used in the [Hippomenes](https://github.com/perlindgren/hippomenes) architecture.

From the bottom up, we use byte-wide inferred BRAM-based memory mostly ripped from [Atalanta](https://github.com/soc-hub-fi/atalanta).

Since Hippomenes is a 32-bit architecture, we wrap the basic memory blocks, using them as columns in an interleaved fashion (i.e. Block 0 
contains bytes where the address `addr%4==0`, Block 1 `addr%4==1` etc.).

This allows us to keep the characteristic single-cycle nature of Hippomenes for misaligned accesses.


## Repo structure

The base Bender package is contained in the root of this repo.

Under `./fpga/` we include a separate Bender package intended as a minimal synthesizeable example of using the memory.
If you're unsure of how to procede, this is probably a good start.
