`ifndef LOGIC_OP_ENV_PACKAGE__SV
`define LOGIC_OP_ENV_PACKAGE__SV
package logic_op_env_pkg;
  import uvm_pkg::*;

  //agent package
  import op_in_agent_pkg::*;;
  //import svt_uvm_pkg::*;;
  //import svt_apb_uvm_pkg::*;;
  //import apb_env_pkg::*;;
  import apb_agent_pkg::*;
  import op_out_agent_pkg::*;;

  

  //sub_env package

  //reg_model package
  import logic_reg_model_pkg::*;

  //vip items

  `include "logic_op_env_config.svh"
  `include "reference_model/logic_sync_reg_refm.svh"
  //include reference_model
  `include "reference_model/logic_op_reference_model.svh"

  //include scoreboard
  `include "scoreboard/logic_op_scoreboard.svh"

  `include "logic_op_vseqr.svh"
  `include "logic_op_func_cov.svh"
  `include "logic_op_env.svh"

endpackage
`endif

