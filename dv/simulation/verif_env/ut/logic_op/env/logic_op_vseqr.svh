`ifndef LOGIC_OP_V_SEQUENCER
`define LOGIC_OP_V_SEQUENCER
class logic_op_vsequencer extends uvm_sequencer;

  // UVM Factory Registration Macro
  //
  `uvm_component_utils(logic_op_vsequencer)

  //------------------------------------------
  // Data Members
  //------------------------------------------
  logic_op_env_config env_cfg;

  //------------------------------------------
  // Component Members
  //------------------------------------------
  //agent seqr
  op_in_sequencer  input_seqr;
  //svt_apb_system_sequencer apb_seqr;
  apb_sequencer apb_seqr;
  op_out_sequencer  output_seqr;

  //sub_env v_seqr

  //------------------------------------------
  // Methods
  //------------------------------------------

  // Standard UVM Methods:
  extern function new(string name, uvm_component parent);

endclass

function logic_op_vsequencer::new(string name, uvm_component parent);
  super.new(name, parent);
  if(!uvm_config_db#(logic_op_env_config)::get(this, "", "logic_op_env_config", env_cfg))
    `uvm_error("CFGERR", "environment config is not set to virtual sequencer!")
  //set sub_env_cfg to sub_env's vseqr

  //create sub_v_seqr

endfunction

`endif

