# UART Project

A simple Verilog-based UART transmitter starter project for learning and simulation.

## Structure

- src/baud_rate_gen.v - baud-rate tick generator
- src/uart_tx.v - UART transmitter module
- tb/baud_rate_gen_tb.v - testbench for the baud-rate generator
- tb/uart_tx_tb.v - testbench for the transmitter
- Makefile - quick simulation commands

## Step-by-step plan

1. Build and test the baud-rate generator.
2. Use that tick to drive a simple UART transmitter.
3. Add a receiver module.
4. Connect both modules together.

## Simulate the baud-rate generator

```bash
cd uart
iverilog -g2012 -o baud_sim tb/baud_rate_gen_tb.v src/baud_rate_gen.v
vvp baud_sim
```

## Simulate the transmitter

```bash
cd uart
iverilog -g2012 -o uart_tx_sim tb/uart_tx_tb.v src/uart_tx.v
vvp uart_tx_sim
```

## Next Steps

- Add a receiver module
- Connect the baud generator to the transmitter
- Test on FPGA or hardware
