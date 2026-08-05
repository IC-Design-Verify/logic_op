`ifndef LOGIC_OP_ENV_CONFIG__SV
`define LOGIC_OP_ENV_CONFIG__SV
class logic_op_env_config extends uvm_object;

  // UVM Factory Registration Macro
  //
  `uvm_object_utils(logic_op_env_config)

  // Virtual Interface
  virtual clock_if#(100,0) sys_clk;
  virtual clock_if#(100,0) apb_clk;
  virtual reset_if#(100) sys_rst;
  virtual reset_if#(100) apb_rst;

  //------------------------------------------
  // Data Members
  //------------------------------------------
  //use for interrupt process
  process main_process;

  //func_cov active
  bit has_functional_coverage = 0;

  //refm active
  bit has_logic_op_refm = 1;

  //scoreboard active
  bit has_logic_op_scoreboard = 1;

  //virtual sequencer active
  bit has_logic_op_vseqr = 1;

  //have env or not


  //have agent or not
  bit has_input_agt = 1;
  bit has_apb_agt = 1;
  bit has_output_agt = 1;

  //add env config

  //add agent config
  op_in_agent_config  input_agt_cfg;
  //apb_shared_cfg apb_cfg;
  apb_agent_config apb_cfg;
  op_out_agent_config  output_agt_cfg;

  //register model
  logic_reg_model  rgm;
  logic_reg_model  sync_rgm;


  extern function new(string name="logic_op_env_config");
  extern virtual function config_env(string name="LOGIC_OP");

  //vip config function
  extern virtual function config_apb();


endclass: logic_op_env_config

function logic_op_env_config::new(string name="logic_op_env_config");
  super.new(name);
  //create env config

  //create agent config
  input_agt_cfg = op_in_agent_config::type_id::create("input_agt_cfg");
  //apb_cfg = apb_shared_cfg::type_id::create("apb_cfg");
  apb_cfg = apb_agent_config::type_id::create("apb_cfg");
  output_agt_cfg = op_out_agent_config::type_id::create("output_agt_cfg");
        
endfunction: new

function logic_op_env_config::config_env(string name="LOGIC_OP");
  `uvm_info("CONFIG_ENV", "Starting config Environment", UVM_MEDIUM)

  //Get Interface To Agent Config
  if(!uvm_resource_db #(virtual apb_if)::read_by_name("interface_pool", {name, "_apb_if"}, apb_cfg.APB)) begin
    `uvm_fatal("VIF_NOT_FOUND", {"Fail to get ", name, "_input_if from resource_db: interface_pool"})
  end
  if(!uvm_resource_db #(virtual op_in_if)::read_by_name("interface_pool", {name, "_input_if"}, input_agt_cfg.vif)) begin
    `uvm_fatal("VIF_NOT_FOUND", {"Fail to get ", name, "_input_if from resource_db: interface_pool"})
  end
  if(!uvm_resource_db #(virtual op_out_if)::read_by_name("interface_pool", {name, "_output_if"}, output_agt_cfg.vif)) begin
    `uvm_fatal("VIF_NOT_FOUND", {"Fail to get ", name, "_output_if from resource_db: interface_pool"})
  end
  if(!uvm_resource_db #(virtual reset_if#(100))::read_by_name("interface_pool", {name, "_sys_rst"}, sys_rst)) begin
    `uvm_fatal("VIF_NOT_FOUND", {"Fail to get ", name, "_sys_rst from resource_db: interface_pool"})
  end
  if(!uvm_resource_db #(virtual reset_if#(100))::read_by_name("interface_pool", {name, "_apb_rst"}, apb_rst)) begin
    `uvm_fatal("VIF_NOT_FOUND", {"Fail to get ", name, "_apb_rst from resource_db: interface_pool"})
  end


    

  if(name=="LOGIC_OP") begin
  //Agent Configuration
  input_agt_cfg.active = UVM_ACTIVE;
  output_agt_cfg.active = UVM_ACTIVE;
  //End Agent Configuration
  end

  //call vip config function

  config_apb();
  `ifndef PREFIX
    `define PREFIX LOGIC_OP
  `endif
  //Sub Environment Configuration

  `undef PREFIX
endfunction

// vip function here -->
//function logic_op_env_config::config_apb();
//  apb_cfg.master_cfg.uvm_reg_enable = 1;
//  apb_cfg.master_cfg.apb4_enable = 0;
//  apb_cfg.master_cfg.apb3_enable = 0;
//
//endfunction
function logic_op_env_config::config_apb();
  apb_cfg.start_address[0] = 32'h00000000;
  apb_cfg.range[0] = 32'hffffffff;

endfunction
`endif

