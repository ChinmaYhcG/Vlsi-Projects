# UART Controller (Verilog)

Verilog implementation of a UART transmitter, built and verified module-by-module using Icarus Verilog and Vivado's simulator. Coded in the Cummings three-always-block FSM style.

## Status

| Module | Status |
|---|---|
| Baud rate generator | Complete, self-checking testbench passing (both TX and RX enable paths verified, including forced mid-count `rx_reset` realignment) |
| Transmitter (TX FSM) | Complete, self-checking testbench passing across 4 test bytes (`0xA5`, `0x3C`, `0x00`, `0xFF`) |
| Integration test (baud generator + transmitter) | Passing, 0 errors across all test bytes |
| Receiver (RX FSM) | Not started |

## Structure

```
src/
  baud_rate_gen.v      - shared TX/RX baud tick generator, async active-low reset
  transmitter.v         - UART TX FSM (idle -> start -> data -> stop), tx_enb-gated
tb/
  baud_rate_gen_tb.v    - self-checking baud generator testbench
  transmitter_tb.v       - top_integration_tb: instantiates baud_rate_gen + transmitter,
                           self-checks reconstructed byte against expected data
```

## Design notes

- **Reset convention:** asynchronous, active-low (`rst_n`) throughout, matching the Cummings papers this project follows. Chosen deliberately to stay consistent with the async FIFO (planned next) which requires async reset on its CDC synchronizer flops regardless.
- **Baud generator is shared, not duplicated:** `transmitter` takes `tx_enb` as an external input rather than instantiating its own timing reference, so TX and the future RX FSM stay on the same clock enable instead of drifting independently.
- **All correctness claims here are backed by console `$display` PASS/FAIL output**, not waveform inspection alone. Waveforms are used for debugging, not as evidence of correctness.

## Simulate

```bash
cd uart
iverilog -g2012 -o baud_sim tb/baud_rate_gen_tb.v src/baud_rate_gen.v
vvp baud_sim

iverilog -g2012 -o transmitter_sim tb/transmitter_tb.v src/transmitter.v src/baud_rate_gen.v
vvp transmitter_sim
```

## Next steps

1. UART receiver (RX FSM) - the harder half, since it has to recover bit timing from an external serial line with no shared enable signal, rather than reusing `tx_enb` directly.
2. Async FIFO with gray-code CDC (Cummings paper currently being read).
3. FSM memory read controller.
