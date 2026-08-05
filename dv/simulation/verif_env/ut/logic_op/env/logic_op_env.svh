`ifndef LOGIC_OP_ENV__SV
`define LOGIC_OP_ENV__SV
class logic_op_env extends uvm_env;

  // UVM Factory Registration Macro
  //
  `uvm_component_utils(logic_op_env)

  //------------------------------------------
  // Data Members
  //------------------------------------------
  //apb_shared_cfg apb_cfg;
  apb_agent_config apb_cfg;  
  logic_op_env_config  env_cfg;

  //------------------------------------------
  // Component Members
  //------------------------------------------
  //scb fifo inst

  //refm fifo inst

  //tlm inst

  //env inst

  //agent inst
  op_in_agent  input_agt;
  //apb_basic_env apb_env;
  apb_agent apb_env;
  op_out_agent  output_agt;

  //virtual sequencer inst
  logic_op_vsequencer logic_op_vseqr;
  

  //scb inst
  logic_op_scoreboard logic_op_scb;

  //refm inst
  logic_sync_reg_refm  logic_sync_reg_rm;
  logic_op_refm logic_op_rm;

  //func cov inst
  logic_op_func_cov  cov;

  //reg_model inst
  string hdl_path = "logic_op_tb_top.u_logic_op";
  logic_reg_model rgm;
  reg2apb_adapter reg2apb;
	uvm_reg_predictor #(apb_seq_item) apb2reg_preditor;


  //------------------------------------------
  // Methods
  //------------------------------------------

  // Standard UVM Methods:
  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass: logic_op_env

function logic_op_env::new(string name, uvm_component parent);
  super.new(name, parent);
  `uvm_info("TRACE",$sformatf("%m"), UVM_HIGH)
endfunction: new

function void logic_op_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("TRACE",$sformatf("%m"), UVM_HIGH)
  if(!uvm_config_db #(logic_op_env_config)::get(this, "", "logic_op_env_config", env_cfg)) begin
    `uvm_error("build_phase", "environment config not found");
  end
  //vip config get
  if (env_cfg.apb_cfg!=null) begin
    uvm_config_db#(apb_agent_config)::set(this, "apb_env", "cfg", env_cfg.apb_cfg);   
  end                                                                                            
  else begin                                                                                     
    apb_cfg = apb_agent_config::type_id::create("apb_cfg", this);                     
    uvm_config_db#(apb_agent_config)::set(this, "apb_env", "cfg", apb_cfg);   
  end                                                                                            

  //set s_env config to s_env

  //build reg_model
  if(!uvm_config_db#(logic_reg_model)::get(this, "", "logic_reg_model", rgm) && env_cfg.rgm == null) begin
    `uvm_info("GETRGM", "no top-down RGM hangle is assigned", UVM_LOW)
    rgm = logic_reg_model::type_id::create({get_full_name(), ".logic_reg_model"}, this);
    env_cfg.rgm = rgm;
    `uvm_info("NEWRGM", "created rgm instance locally", UVM_LOW)
  end
  else if(env_cfg.rgm != null) begin
    rgm = env_cfg.rgm;
  end
  if(env_cfg.sync_rgm == null) begin
    env_cfg.sync_rgm = logic_reg_model::type_id::create({get_full_name(), ".sync_rgm"}, this);
    env_cfg.sync_rgm.build();
    env_cfg.sync_rgm.lock_model();
  end
  if(rgm.get_parent()==null) begin
    rgm.build();
    rgm.add_hdl_path(hdl_path);
    rgm.lock_model();
    rgm.reset();
    rgm.map.set_auto_predict(0);
  end
  //uvm_config_db#(uvm_reg_block)::set(this, "apb_env.apb_master_env.master", "apb_regmodel", rgm);
	reg2apb = reg2apb_adapter::type_id::create("reg2apb");
	reg2apb.provides_responses = 1;
	apb2reg_preditor = uvm_reg_predictor#(apb_seq_item)::type_id::create("apb2reg_preditor", this);
	apb2reg_preditor.map = rgm.map;
	apb2reg_preditor.adapter = reg2apb;          

  //sub_env reg_model connect
  //Example:
  //if(env_cfg.has_sub_env) begin
  //  env_cfg.sub_env_cfg.rgm = rgm.sub_env_blk;
  //  env_cfg.sub_env_cfg.sync_rgm = env_cfg.sync_rgm.sub_env_blk;
  //end

  //scb fifo new

  //refm fifo new

  //v_seq new
  if(env_cfg.has_logic_op_vseqr) begin
    logic_op_vseqr = logic_op_vsequencer::type_id::create("logic_op_vseqr", this);
  end

  //env exists or not

  //agent exists or not
  if(env_cfg.has_input_agt) begin
    uvm_config_db #(op_in_agent_config)::set(this, "input_agt", "op_in_agent_config", env_cfg.input_agt_cfg);
    input_agt = op_in_agent::type_id::create("input_agt", this);
  end
  if(env_cfg.has_apb_agt) begin
		uvm_config_db #(apb_agent_config)::set(this, "apb_env", "apb_agent_config", env_cfg.apb_cfg);
    apb_env = apb_agent::type_id::create("apb_env", this);
  end
  if(env_cfg.has_output_agt) begin
    uvm_config_db #(op_out_agent_config)::set(this, "output_agt", "op_out_agent_config", env_cfg.output_agt_cfg);
    output_agt = op_out_agent::type_id::create("output_agt", this);
  end

  //reference_model new
  if(env_cfg.has_logic_op_refm) begin
    logic_op_rm = logic_op_refm::type_id::create($sformatf("logic_op_rm"),this);
  end

  //scoreboard new
  if(env_cfg.has_logic_op_scoreboard) begin
    logic_op_scb = logic_op_scoreboard::type_id::create($sformatf("logic_op_scb"),this);
  end

  //refm config

  //function coverage config
  if(env_cfg.has_functional_coverage) begin
    cov = logic_op_func_cov::type_id::create("cov",this);
  end
endfunction: build_phase

function void logic_op_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info("TRACE",$sformatf("%m"), UVM_HIGH)

  //reg_model connect

  //function coverage connect
  //if(env_cfg.has_functional_coverage) begin
  //  xxx_agt.analysis_port.connect(cov.cov_imp);
  //end

  //v_seqr connect

  //tlm connect

  //v_seqr config
  if(env_cfg.has_logic_op_vseqr && env_cfg.has_input_agt == 1 && env_cfg.input_agt_cfg.active == UVM_ACTIVE) begin
    logic_op_vseqr.input_seqr = input_agt.seqr;
  end
  if(env_cfg.has_logic_op_vseqr && env_cfg.has_apb_agt == 1) begin
    logic_op_vseqr.apb_seqr = apb_env.seqr;
  end
  if(env_cfg.has_logic_op_vseqr && env_cfg.has_output_agt == 1 && env_cfg.output_agt_cfg.active == UVM_ACTIVE) begin
    logic_op_vseqr.output_seqr = output_agt.seqr;
  end

  //refm connect
  if(env_cfg.has_logic_op_refm) begin
    input_agt.analysis_port.connect(logic_op_rm.op_in1_fifo.analysis_export);
  end

  //scoreboard connect
  if(env_cfg.has_logic_op_scoreboard) begin
    output_agt.analysis_port.connect(logic_op_scb.acutal_op_out1_fifo.analysis_export);
    logic_op_rm.op_out1_ap.connect(logic_op_scb.golden_op_out1_fifo.analysis_export);
  end

endfunction: connect_phase

`endif
