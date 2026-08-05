`ifndef LOGIC_OP_V_SEQ_LIB__SV
`define LOGIC_OP_V_SEQ_LIB__SV
class logic_op_vseq_base extends uvm_sequence;
  // UVM Factory Registration Macro
  //
  `uvm_object_utils(logic_op_vseq_base)
  `uvm_declare_p_sequencer(logic_op_vsequencer)

  //uvc's sequences
  op_in_seq input_seq;

  //------------------------------------------
  // Data Members
  //------------------------------------------
  logic_op_env_config env_cfg;

  // intr_sequence inst

  //------------------------------------------
  // Methods
  //------------------------------------------

  // Standard UVM Methods:
  extern function new(string name = "logic_op_vseq_base");
  extern task pre_body();
  extern task post_body();

endclass: logic_op_vseq_base

function logic_op_vseq_base::new(string name = "logic_op_vseq_base");
  super.new(name);
  `uvm_info("TRACE",$sformatf("%m"), UVM_HIGH)
endfunction: new

task logic_op_vseq_base::pre_body();
  if(!uvm_config_db#(logic_op_env_config)::get(get_sequencer(), "", "logic_op_env_config", env_cfg))
    `uvm_fatal("CFGERR", "environment config is not set to virtual sequence!")
  `ifdef UVM_VERSION_1_1
    if(get_parent_sequence() == null && starting_phase != null) begin
      uvm_objection objection = starting_phase.get_objection();
      objection.set_drain_time(this,25ns);
      starting_phase.raise_objection(this);
    end
  `endif
  // Add for intr_sequence execution

endtask

task logic_op_vseq_base::post_body();
  `ifdef UVM_VERSION_1_1
    if(get_parent_sequence() == null && starting_phase != null) begin 
      starting_phase.drop_objection(this);
    end
  `endif
endtask




class logic_op_smoke_vseq extends logic_op_vseq_base;
  `uvm_object_utils(logic_op_smoke_vseq)
  //`uvm_declare_p_sequencer(logic_op_vsequencer)
  logic_op_reg_seq reg_seq;

  function new(string name = "logic_op_smoke_vseq");
    super.new(name);
    `uvm_info("TRACE",$sformatf("%m"), UVM_HIGH)
  endfunction: new

  task body();
    //`uvm_do(reg_seq)

    `ifndef UVM_VERSION
      `uvm_do_on(input_seq, p_sequencer.input_seqr)
    `else
      `uvm_do(input_seq, p_sequencer.input_seqr)
    `endif
  endtask
endclass: logic_op_smoke_vseq



//add new virtual sequences here -->
class logic_op_and_vseq extends logic_op_vseq_base;
  `uvm_object_utils(logic_op_and_vseq)
  //`uvm_declare_p_sequencer(logic_op_vsequencer)
  logic_op_and_reg_seq reg_seq;

  function new(string name = "logic_op_and_vseq");
    super.new(name);
    `uvm_info("TRACE",$sformatf("%m"), UVM_HIGH)
  endfunction: new

  task body();
    `uvm_do(reg_seq)

    `ifndef UVM_VERSION
      `uvm_do_on(input_seq, p_sequencer.input_seqr)
    `else
      `uvm_do(input_seq, p_sequencer.input_seqr)
    `endif
  endtask
endclass: logic_op_and_vseq

class logic_op_or_vseq extends logic_op_vseq_base;
  `uvm_object_utils(logic_op_or_vseq)
  //`uvm_declare_p_sequencer(logic_op_vsequencer)
  logic_op_or_reg_seq reg_seq;

  function new(string name = "logic_op_or_vseq");
    super.new(name);
    `uvm_info("TRACE",$sformatf("%m"), UVM_HIGH)
  endfunction: new

  task body();
    `uvm_do(reg_seq)

    `ifndef UVM_VERSION
      `uvm_do_on(input_seq, p_sequencer.input_seqr)
    `else
      `uvm_do(input_seq, p_sequencer.input_seqr)
    `endif
  endtask
endclass: logic_op_or_vseq

class logic_op_nxor_vseq extends logic_op_vseq_base;
  `uvm_object_utils(logic_op_nxor_vseq)
  //`uvm_declare_p_sequencer(logic_op_vsequencer)
  logic_op_nxor_reg_seq reg_seq;

  function new(string name = "logic_op_nxor_vseq");
    super.new(name);
    `uvm_info("TRACE",$sformatf("%m"), UVM_HIGH)
  endfunction: new

  task body();
    `uvm_do(reg_seq)

    `ifndef UVM_VERSION
      `uvm_do_on(input_seq, p_sequencer.input_seqr)
    `else
      `uvm_do(input_seq, p_sequencer.input_seqr)
    `endif
  endtask
endclass: logic_op_nxor_vseq

class logic_op_xor_vseq extends logic_op_vseq_base;
  `uvm_object_utils(logic_op_xor_vseq)
  //`uvm_declare_p_sequencer(logic_op_vsequencer)
  logic_op_xor_reg_seq reg_seq;

  function new(string name = "logic_op_xor_vseq");
    super.new(name);
    `uvm_info("TRACE",$sformatf("%m"), UVM_HIGH)
  endfunction: new

  task body();
    `uvm_do(reg_seq)

    `ifndef UVM_VERSION
      `uvm_do_on(input_seq, p_sequencer.input_seqr)
    `else
      `uvm_do(input_seq, p_sequencer.input_seqr)
    `endif
  endtask
endclass: logic_op_xor_vseq


`endif
