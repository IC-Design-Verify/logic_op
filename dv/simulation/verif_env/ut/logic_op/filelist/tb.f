$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/tb_top/logic_op_env_define.sv
//////////////////////////////
//sub_env filelist
//////////////////////////////
//uvc directory
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/commom/uvc
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/op_in
//+incdir+$DESIGNWARE_VIP_HOME/src/sverilog/vcs
//+incdir+$DESIGNWARE_VIP_HOME/include/sverilog
//+incdir+$DESIGNWARE_VIP_HOME/src/verilog/vcs
//+incdir+$DESIGNWARE_VIP_HOME/include/verilog
//+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/svt_apb/env
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/op_out
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/apb

//////////////////////////////
//rtl_model directory
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/common/rtl_model


//////////////////////////////
//env directory
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/env
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/env/reference_model
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/env/scoreboard
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/reg_model
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/sequences
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/sequences/reg_sequence
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/sequences/intr_sequence
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/tests/uvm_test
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/headers
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/tb_top

//////////////////////////////
//env define

//////////////////////////////
//interface
$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/clock_if.sv
$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/intr_if.sv
$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/reset_if.sv

//////////////////////////////
//agent package
+incdir+$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc
$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/op_in/op_in_agent_pkg.sv
//$DESIGNWARE_VIP_HOME/include/sverilog/svt_apb.uvm.pkg
//$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/svt_apb/env/apb_env_pkg.sv
$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/op_out/op_out_agent_pkg.sv
$PROJ_HOME/dv/simulation/verif_env/ut/common/uvc/apb/apb_agent_pkg.sv

//////////////////////////////
//sub_env package begin
//sub_env package end
//////////////////////////////

//////////////////////////////
//env package
$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/reg_model/logic_reg_model_pkg.sv
$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/env/logic_op_env_pkg.sv
$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/sequences/reg_sequence/logic_op_reg_seq_pkg.sv
$PROJ_HOME/dv/simulation/verif_env/ut/logic_op/sequences/logic_op_vseq_lib_pkg.sv
