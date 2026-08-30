# UART Controller (Verilog)

Verilog implementation of a UART transmitter and receiver, built and verified module-by-module using Icarus Verilog and Vivado's simulator. Coded in the Cummings three-always-block FSM style.

## Status

| Module | Status |
|---|---|
| Baud rate generator | Complete, self-checking testbench passing (both TX and RX enable paths verified, including forced mid-count `rx_reset` realignment) |
| Transmitter (TX FSM) | Complete, self-checking testbench passing across 4 test bytes (`0xA5`, `0x3C`, `0x00`, `0xFF`) |
| Receiver (RX FSM) | Complete, self-checking loopback testbench passing across 5 test bytes (`0xA5`, `0x3C`, `0x00`, `0xFF`, `0x55`) |
| Integration test (baud generator + transmitter) | Passing, 0 errors across all test bytes |
| Integration test (baud generator + transmitter + receiver, loopback) | Passing, 0 errors across all test bytes |

## Structure

```
src/
  baud_rate_gen.v   - shared TX/RX baud tick generator, async active-low reset
  transmitter.v     - UART TX FSM (idle -> start -> data -> stop), tx_enb-gated
  receiver.v        - UART RX FSM, 16x oversampled, recovers bit timing from an
                       external line with no shared clock enable
tb/
  baud_rate_gen_tb.v - self-checking baud generator testbench
  transmitter_tb.v   - top_integration_tb: instantiates baud_rate_gen + transmitter,
                        self-checks reconstructed byte against expected data
  receiver_tb.v      - instantiates baud_rate_gen + transmitter + receiver in loopback
                        (transmitter's tx line feeds receiver's rx line directly),
                        self-checks received byte against what was sent
```

## Design notes

- **Reset convention:** asynchronous, active-low (`rst_n`) throughout, matching the Cummings papers this project follows. Chosen deliberately to stay consistent with the async FIFO (planned next) which requires async reset on its CDC synchronizer flops regardless.
- **Baud generator is shared, not duplicated:** `transmitter` and `receiver` both take enable signals from the same `baud_rate_gen` instance rather than each building a private timing reference, so TX and RX stay on the same clock enable instead of drifting independently.
- **Receiver timing recovery:** unlike the transmitter, `receiver` has no shared enable signal with the line it's reading — it detects the incoming start edge, drives `rx_reset` back into the baud generator to realign the RX sample counter, then qualifies the start bit at the half-bit mark (protects against short glitches) before sampling every subsequent bit at the full-bit mark, 16x-oversampled.
- **Metastability handling:** `rx` is an external, asynchronous signal, so `receiver` runs it through a 2-flop synchronizer before use, plus a third register purely for edge detection (comparing synchronized-now vs synchronized-previous).
- **Known limitation:** the start bit is currently qualified with a single sample at its midpoint, not a majority vote across multiple samples. This is the standard approach for rejecting a genuine timing offset but does not protect against a noise spike that happens to persist through that one sample instant. Not exercised by the current loopback testbench, since a simulated wire has no noise.
- **All correctness claims here are backed by console `$display` PASS/FAIL output**, not waveform inspection alone. Waveforms are used for debugging, not as evidence of correctness.

## Simulate

```bash
cd uart

iverilog -g2012 -o baud_sim tb/baud_rate_gen_tb.v src/baud_rate_gen.v
vvp baud_sim

iverilog -g2012 -o transmitter_sim tb/transmitter_tb.v src/transmitter.v src/baud_rate_gen.v
vvp transmitter_sim

iverilog -g2012 -o receiver_sim tb/receiver_tb.v src/receiver.v src/transmitter.v src/baud_rate_gen.v
vvp receiver_sim
```

## Next steps

1. Async FIFO with gray-code CDC (Cummings paper currently being read).
2. FSM memory read controller.
