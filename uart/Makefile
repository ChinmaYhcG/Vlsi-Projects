all:
	iverilog -g2012 -o baud_sim tb/baud_rate_gen_tb.v src/baud_rate_gen.v
	vvp baud_sim

baud:
	iverilog -g2012 -o baud_sim tb/baud_rate_gen_tb.v src/baud_rate_gen.v
	vvp baud_sim

uart:
	iverilog -g2012 -o uart_tx_sim tb/uart_tx_tb.v src/uart_tx.v
	vvp uart_tx_sim

clean:
	rm -f baud_sim baud_rate_gen_tb.vcd uart_tx_sim uart_tx_tb.vcd
