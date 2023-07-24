# u[Dark]RISC -- micro-DarkRISC

This is an early 16-bit RISC processor designed years before DarkRISCV. Although never intendend for real use (it was derived from a serie of experimental cores for a presentation in a University), it is very simple and easy to understand.

# Features

Designed back in 2015 (years before DarkRISCV), it includes:
- Two state pipelined RISC
- Flexible 16x16-bit registers
- 16-bit Program Counter (PC)
- Harvard Architecture w/ separate ROM/RAM up to 64Kword each - Memory mapped IO
- Less than 100 lines of Verilog
- 1/3 of a XC3S50AN@75MHz
- Can be easily changed!

# History & Motivation

The beggning: VLIW DSPs on FPGAs, with high optimized ALUs around DSP blocks, in a way that MAC operations can be optimized. However, conventional code was hard to port for VLIW DSPs, so a more general purpose processor was needed...

Lots of different concepts around accumulator-oriented, register bank oriented, VLIW, 16/32-bits, etc most designs were identified just as “core” or “dsp”, but this specific concept was named uRISC for an external presentation on a University. Because there are too much processors called uRISC already, it was renamed to uDarkRISC (micro-DarkRISC).

Designed as a evaluation processor, it was never designed to be used on real products and never tested with complex applications... however, the more conventional approach was used as base for DarkRISCV, a high-performance processor which implements a RV32I/E 100% compatible with GCC compiler! For more information about DarkRISCV, please check: https://github.com/darklife/darkriscv/tree/master

# Instruction Decode

The 16bit instruction word is read from the synchronous BRAM and divided in 3 or 4 fields:

- bits 15:12 are the instruction opcode
- bits 11:8 are the destination register (DREG)
- bits 7:4 are the source register (SREG)
- bits 3:0 are reserved for instruction options

Alternatively, the fields 7:4 can be used to load a signed extended 8-bit constant.

# Instruction Execution

According to the Destination Register, Source Register, Option Data or Immediate Data, all 16 possible instructions are computed in parallel and put in a 16x16-bit array:

- shift SREG>>>OPTS ROR)
- shift SREG<<<OPTS (ROL)
- add DREG+OPTS or DREG+SREG (ADD)
- sub DREG-OPTS or DREG-SREG (SUB)
- xor DREG^SREG (XOR)
- and DREG&SREG (AND)
- or DREG|SREG (OR)
- not ~DREG (NOT)
- load (LOD) 
- store (STO)
- immediate (IMM)
- (DREG*SREG)>>>OPTS (MUL)
- branch (BRA)
- branch to sub-routine (BSR)
- return from sub-routine (RET)
- test, decrement and branch (LOP)

Note that there is no conditional branches other than the LOP instruction.

As far as the instructions are read from the ROM, the opcode is used to index the above array, so the result is written directly to the register bank. Also, the PC is computed, in a way that it can be 0 (RES==0), DREG (RET instruction), PC+IMM (BSR, BRA or LOP instructions) or just PC+1.

Finnaly, the LOD and STO activate the RD and WR signals for load/store, with DATA active w/ DREG on store or tri-state on load and SREG as pointer in both cases (so, no addressing modes).

# Pipeline Detail

The micro-DarkRISC is a high performacne processor that needs a lot of bandwidth on the instructon bus: running at 75MHz, it requires 150MB/s continuously! So the pipeline is optimized in a way that the pipeline is always filled, even in the case of a branch: there is no flush pipeline, so the pre-fetched instruction is executed and the core peaks IPC = 1 all time.

Since the load/store instructions are not used so often, there is no optimization regarding the load/store. The impact of such decision depends on the application: for applications that are handled only with internal registe, there is no impact. For most case, however, a small LUTRAM may be enough and, again there is no impact. 

Eventually, in the case of BRAM, wait-states are required, but the core does not foresee a HALT signal, so there is no way to insert wait-states. Instead, it is possible simulate such wait-states by sucessive load/store instructions at the same address, so the memory is read multiple times until it is ready.

# Instruction Set

The direct supported instructions are:

- ROR/ROL: register right or left rotate
- ADD/SUB: register add/sub
- XOR/AND/OR/NOT: register logic operations
- LOD/STO: register to/from memory operations
- IMM: immediate data load (8-bit LSB value)
- MUL: register multiply and right rotate (trying include some DSP support, but without a wide accumulator) - BRA/BSR: load PC from PC+immediate data and, optionally, save PC to a register
- RET: load PC from register data
- LOP: test register, decrement register and set PC to PC+immediate data

In addition, there is an Advanced Instruction Set (aka “pseudo-instructions”). 

The known pseudo-instructions are:

- MOV: ROR or ROL with shift value = 0.
- NOP: MOV with same source/destination register.
- ADDQ/SUBQ: quick add/sub a value between 1 and 15.
- JMP: move the address to a register and RET from this register - INC/DEC: ADDQ/SUBQ with value 1.
- CLR: xor in the same register.
- and much more! 

# Development System

Limited to an AWK-based assembler that generates a Verilog file w/ the ROM description.

# Conclusion

Although the uDarkRISC was frozen in time and replaced by the DarkRISCV, there are always people trying find a simple processor to study, which means that there is no bad processors, just processors that are better for different applications. So, although DarkRISCV is good because it can actually run complex code generated by GCC, the uDarkRISC may be far better for starters that are just trying understand how design a simple processor.
