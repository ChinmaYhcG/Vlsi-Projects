# VLSI Projects

Verilog implementations of digital logic circuits, built as part of a self-directed VLSI learning roadmap. All designs are simulated using Icarus Verilog and GTKWave on a Linux (WSL2) environment.

## Repository Structure

```
Vlsi-Projects/
├── gates/
│   ├── Behavioral_model/
│   ├── Dataflow_model/
│   ├── Structural_model/
│   └── Switch_level_model/
└── alu/
```

## 1. Logic Gates — Four Abstraction Levels

Implemented the following gates across all four levels of Verilog abstraction:  
**Gates:** NOT, NAND, NOR, AND, OR, XOR, XNOR

| Folder | Abstraction Level | Description |
|--------|------------------|-------------|
| Behavioral_model | Behavioral | Described using `always` blocks and logical operators |
| Dataflow_model | Dataflow | Described using continuous `assign` statements |
| Structural_model | Structural | Instantiated using built-in Verilog gate primitives |
| Switch_level_model | Switch-level | Implemented using `nmos` and `pmos` transistor primitives |

The switch-level models reflect actual CMOS transistor networks — pull-up (PMOS) and pull-down (NMOS) networks are explicitly instantiated, matching the physical transistor layout.

**Simulate (example — Switch-level XNOR):**
```bash
cd gates/Switch_level_model
iverilog -g2012 -o sim.vvp NOT_cmos.v NAND_cmos.v XOR_cmos.v XNOR_cmos.v XNOR_cmos_tb.v
vvp sim.vvp
# Replace the last two filenames to simulate a different gate
```

## 2. 4-bit ALU

A 4-bit Arithmetic Logic Unit supporting 16 operations, implemented using behavioral Verilog with a `case` statement acting as an operation selector.

| Opcode | Operation | Description |
|--------|-----------|-------------|
| 0000 | ADD | a + b |
| 0001 | SUB | a - b |
| 0010 | AND | a & b |
| 0011 | OR | a \| b |
| 0100 | XOR | a ^ b |
| 0101 | NOT | ~a |
| 0110 | SHL1 | a << 1 |
| 0111 | SHR1 | a >> 1 |
| 1000 | SHL2 | a << 2 |
| 1001 | SHR2 | a >> 2 |
| 1010 | NAND | ~(a & b) |
| 1011 | NOR | ~(a \| b) |
| 1100 | XNOR | ~(a ^ b) |
| 1101 | EQ | 1 if a == b |
| 1110 | LT | 1 if a < b |
| 1111 | GT | 1 if a > b |

Includes a zero flag output — asserts high when result is 0, mirroring the zero flag in real processor ALUs.

**Simulate:**
```bash
cd alu
iverilog -o alu_sim alu.v alu_tb.v
vvp alu_sim
```

## Tools Used
- Icarus Verilog — simulation and compilation
- GTKWave — waveform viewing
- WSL2 (Ubuntu) — Linux environment on Windows
- VS Code — editor with WSL extension

*3rd year ECE — Manipal Institute of Technology Bengaluru*
