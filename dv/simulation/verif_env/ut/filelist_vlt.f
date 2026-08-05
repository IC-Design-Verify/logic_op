// Verilator build filelist for the logic_op UVM environment.
//
// Uses the official Accellera UVM (IEEE 1800.2-2020) source shipped in
// uvm-verilator/ (chipsalliance/uvm-verilator), compiled in by Verilator.
//
// Requires env var (set by the build script):
//   PROJ_HOME = logic_op repo root (mounted at /work in the container)
//
// NOTE: the VCS `logic_op_test` program block is intentionally NOT listed;
// run_test() is launched from logic_op_tb_top under the -DVL_RUN_TEST guard.
// C++ DPI sources (logic_op_dpi.cpp, uvm-verilator/src/dpi/uvm_dpi.cc) are
// passed on the verilator command line, not here.

//////////////////////////////
// include directories
//////////////////////////////
+incdir+$PROJ_HOME/uvm-verilator/src
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/op_in
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/op_out
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/apb
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/common/rtl_model
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/env
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/env/reference_model
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/env/scoreboard
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/reg_model
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/sequences
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/sequences/reg_sequence
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/sequences/intr_sequence
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/tests/uvm_test
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/tb_top

//////////////////////////////
// UVM library (Accellera 1800.2 / chipsalliance uvm-verilator)
//////////////////////////////
$PROJ_HOME/uvm-verilator/src/uvm.sv

//////////////////////////////
// Design RTL
//////////////////////////////
$PROJ_HOME/design/logic_op/logic_op_reg_ctrl.v
$PROJ_HOME/design/logic_op/logic_op.v

//////////////////////////////
// RTL helper models (compiled, not instantiated)
//////////////////////////////
$PROJ_HOME/dv/simulation/verif_env/ut/common/rtl_model/tb_clk_div.v
$PROJ_HOME/dv/simulation/verif_env/ut/common/rtl_model/tb_reg_upd.v

//////////////////////////////
// env defines (MERGE_ITF_NAME etc.) - must precede tb_top
//////////////////////////////
$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/tb_top/logic_op_env_define.sv

//////////////////////////////
// standalone interfaces
//////////////////////////////
$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/clock_if.sv
$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/intr_if.sv
$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/reset_if.sv

//////////////////////////////
// agent packages (each pulls in its _if.sv + seq libs via `include)
//////////////////////////////
$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/op_in/op_in_agent_pkg.sv
$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/op_out/op_out_agent_pkg.sv
$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/apb/apb_agent_pkg.sv

//////////////////////////////
// register model package
//////////////////////////////
$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/reg_model/logic_reg_model_pkg.sv

//////////////////////////////
// env package
//////////////////////////////
$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/env/logic_op_env_pkg.sv

//////////////////////////////
// sequence packages
//////////////////////////////
$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/sequences/reg_sequence/logic_op_reg_seq_pkg.sv
$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/sequences/logic_op_vseq_lib_pkg.sv

//////////////////////////////
// testcase package
//////////////////////////////
$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/tests/uvm_test/logic_op_testcase_pkg.sv

//////////////////////////////
// tb top (single top; run_test() launched under -DVL_RUN_TEST)
//////////////////////////////
$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/tb_top/logic_op_tb_top.sv
