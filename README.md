# VLSI Projects

Verilog implementations of digital logic circuits, built as part of a self-directed VLSI learning roadmap. All designs are simulated using Icarus Verilog and GTKWave on a Linux (WSL2) environment.

---

## Repository Structure

```
Vlsi-Projects/
├── gates/
│   ├── Behavioral_model/
│   ├── Dataflow_model/
│   ├── Structural_model/
│   └── Switch_level_model/
├── alu/
└── inverter/
```

---

## 1. Logic Gates — Four Abstraction Levels

Implemented the following gates across all four levels of Verilog abstraction:

**Gates:** NOT, NAND, NOR, AND, OR, XOR, XNOR

| Folder | Abstraction Level | Description |
|---|---|---|
| `Behavioral_model` | Behavioral | Described using `always` blocks and logical operators |
| `Dataflow_model` | Dataflow | Described using continuous `assign` statements |
| `Structural_model` | Structural | Instantiated using built-in Verilog gate primitives |
| `Switch_level_model` | Switch-level | Implemented using `nmos` and `pmos` transistor primitives |

The switch-level models reflect actual CMOS transistor networks — pull-up (PMOS) and pull-down (NMOS) networks are explicitly instantiated, matching the physical transistor layout.

### Simulate (example — Switch-level XNOR)

```bash
cd gates/Switch_level_model
iverilog -g2012 -o sim.vvp NOT_cmos.v NAND_cmos.v XOR_cmos.v XNOR_cmos.v XNOR_cmos_tb.v
vvp sim.vvp
```

---

## 2. 4-bit ALU

A 4-bit Arithmetic Logic Unit supporting 11 operations, implemented using behavioral Verilog with a `case` statement acting as an operation selector.

### Supported Operations

| Opcode | Operation | Description |
|---|---|---|
| `0000` | ADD | a + b |
| `0001` | SUB | a - b |
| `0010` | AND | a & b (bitwise) |
| `0011` | OR | a \| b (bitwise) |
| `0100` | XOR | a ^ b (bitwise) |
| `0101` | NOT | ~a (bitwise complement) |
| `0110` | SHL | a << 1 (left shift, multiply by 2) |
| `0111` | SHR | a >> 1 (right shift, divide by 2) |
| `1000` | EQ | 1 if a == b, else 0 |
| `1001` | LT | 1 if a < b, else 0 |
| `1010` | GT | 1 if a > b, else 0 |

Includes a **zero flag** output — asserts high when result is 0, mirroring the zero flag in real processor ALUs.

### Simulate

```bash
cd alu
iverilog -o alu_sim alu.v alu_tb.v
vvp alu_sim
```

### Sample Output

```
ADD:  5 + 3 = 8
SUB:  5 - 3 = 2
AND:  5 & 3 = 1
OR:   5 | 3 = 7
XOR:  5 ^ 3 = 6
EQ:   5 == 5 = 1
LT:   3 < 5 = 1
```

---

## Tools Used

- **Icarus Verilog** — simulation and compilation
- **GTKWave** — waveform viewing
- **WSL2 (Ubuntu)** — Linux environment on Windows
- **VS Code** — editor with WSL extension

---

## Roadmap

- [x] CMOS gate implementation — all four abstraction levels
- [x] 4-bit ALU with 11 operations
- [ ] UART Tx/Rx controller with FSM (Cummings style)
- [ ] RTL-to-GDSII flow using OpenLane + SKY130 PDK
- [ ] FPGA synthesis using Vivado

---

*2nd year ECE — Manipal Institute of Technology Bengaluru*

