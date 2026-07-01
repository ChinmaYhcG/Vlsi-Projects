module seq_detector_1010_moore_tb;
  reg clk, rst_n, x;
  wire z;

  reg exp_z;
  reg [2:0] ref_state;

  seq_detector_1010_moore sd(clk, rst_n, x, z);

  initial clk = 0;
  always #2 clk = ~clk;

  initial begin
    x = 0;
    rst_n = 0;
    ref_state = 0;
    @(negedge clk);
    rst_n = 1;

    drive(1);
    drive(0);
    drive(1);
    drive(0);
    drive(1);
    drive(0);
    drive(1);
    drive(1);
    drive(1);
    drive(0);
    drive(1);
    drive(0);
    drive(1);
    drive(0);

    #10;
    $display("TEST COMPLETE");
    $finish;
  end

  task drive;
    input bit_val;
    reg bit_val;
    begin
      @(negedge clk);
      x = bit_val;
      case (ref_state)
        0: ref_state = bit_val ? 1 : 0;
        1: ref_state = bit_val ? 1 : 2;
        2: ref_state = bit_val ? 3 : 0;
        3: ref_state = bit_val ? 1 : 4;
        4: ref_state = bit_val ? 3 : 0;
        default: ref_state = 0;
      endcase
      @(posedge clk);
      #1;
      exp_z = (ref_state == 4);
      if (z !== exp_z)
        $display("MISMATCH at time %0t: x=%b state_ref=%0d z=%b expected=%b",
                  $time, bit_val, ref_state, z, exp_z);
      else
        $display("OK       at time %0t: x=%b state_ref=%0d z=%b", $time, bit_val, ref_state, z);
    end
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, seq_detector_1010_moore_tb);
  end

endmodule