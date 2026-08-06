// =============================================================================
// DUT filelist  --  the logic_op design under test (RTL only)
// -----------------------------------------------------------------------------
// Standalone-compilable:  verilator --cc --top-module logic_op -f dut.f
// Requires env var: PROJ_HOME = logic_op repo root.
// =============================================================================

//////////////////////////////
// logic_op design RTL
//////////////////////////////
$PROJ_HOME/design/logic_op/logic_op_reg_ctrl.v
$PROJ_HOME/design/logic_op/logic_op.v
