`ifndef LOGIC_OP_V_SEQUENCE_PACKAGE__SV
`define LOGIC_OP_V_SEQUENCE_PACKAGE__SV
package logic_op_vseq_lib_pkg;
  import uvm_pkg::*;

  //vip package
  //import svt_uvm_pkg::*;    
  //import svt_apb_uvm_pkg::*;    
	//import apb_env_pkg::*;

  //agent package
  import op_in_agent_pkg::*;
  import op_out_agent_pkg::*;
  import apb_agent_pkg::*;

  //reg_model package
  import logic_reg_model_pkg::*;

  //env package
  import logic_op_env_pkg::*;

  //sub_env sequence_pkg

  //include reg_sequence
  import logic_op_reg_seq_pkg::*;

  //include intr_sequence

  //include v_sequence
  `include "logic_op_vseq_lib.svh"

  //include other sequences

endpackage
`endif
