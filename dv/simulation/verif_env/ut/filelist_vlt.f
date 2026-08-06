// Combined view = DUT + UVM/TB.  Kept for backward compatibility.
//
// The build is now split into two filelists:
//   dut.f  -- the logic_op design (RTL)            verilator --top-module logic_op
//   uvm.f  -- UVM library + testbench               verilator --top-module logic_op_tb_top
//
// Full UVM sim uses both together:
//   verilator ... -f dut.f -f uvm.f
//
// (Relative -f paths resolve against the current working directory = ut/.)
-f dut.f
-f uvm.f
