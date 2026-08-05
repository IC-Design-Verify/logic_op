`ifndef LOGIC_OP_TESTCASE__SV
`define LOGIC_OP_TESTCASE__SV
package logic_op_testcase_pkg;
  import uvm_pkg::*;

  //vip package
  //import svt_uvm_pkg::*;    
  //import svt_apb_uvm_pkg::*;    
	//import apb_env_pkg::*;

  import apb_agent_pkg::*;

  

  //reg_model package

  //m_env package
  import logic_op_env_pkg::*;

  //import logic_op_intr_seq_pkg::*;
  //reg_seq package

  //seq package
  import logic_op_vseq_lib_pkg::*;

  //include test_base
  `include "logic_op_test_base.svh"

  //include testcase
  `include "logic_op_test_lib.svh"

endpackage
`endif
