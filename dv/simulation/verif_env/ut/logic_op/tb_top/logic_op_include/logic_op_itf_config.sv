`ifdef LOGIC_OP_ITF_PRE_NAME
`ifndef LOGIC_OP_ENV_INST_NAME
  `define LOGIC_OP_ENV_INST_NAME m_env
`endif
//config interface
// NOTE: legacy `"...`" stringify outside a macro definition is rejected by
// strict tools (slang); the standard-conforming stringify macro below
// produces the identical string ("LOGIC_OP") under Verilator/VCS/slang.
`define LOGIC_OP_STR(x) `"x`"
uvm_resource_db #(virtual op_in_if)::set("interface_pool", {`LOGIC_OP_STR(`LOGIC_OP_PRE_NAME), "_input_if"}, `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, input_vif));
//uvm_config_db#(svt_apb_vif)::set(uvm_root::get(), `"uvm_test_top.`LOGIC_OP_ENV_INST_NAME.apb_env.apb_master_env`", "vif", `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_master_vif));
//uvm_config_db#(svt_apb_vif)::set(uvm_root::get(), `"uvm_test_top.`LOGIC_OP_ENV_INST_NAME.apb_env.apb_slave_env`" , "vif", `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_slave_vif) );
uvm_resource_db #(virtual op_out_if)::set("interface_pool", {`LOGIC_OP_STR(`LOGIC_OP_PRE_NAME), "_output_if"}, `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, output_vif));
uvm_resource_db #(virtual apb_if)::set("interface_pool", {`LOGIC_OP_STR(`LOGIC_OP_PRE_NAME), "_apb_if"}, `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_vif));


uvm_resource_db #(virtual clock_if#(100,0))::set("interface_pool", {`LOGIC_OP_STR(`LOGIC_OP_PRE_NAME), "_sys_clk"}, `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_clk));
uvm_resource_db #(virtual clock_if#(100,0))::set("interface_pool", {`LOGIC_OP_STR(`LOGIC_OP_PRE_NAME), "_apb_clk"}, `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_clk));


uvm_resource_db #(virtual reset_if#(100))::set("interface_pool", {`LOGIC_OP_STR(`LOGIC_OP_PRE_NAME), "_sys_rst"}, `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_rst));
uvm_resource_db #(virtual reset_if#(100))::set("interface_pool", {`LOGIC_OP_STR(`LOGIC_OP_PRE_NAME), "_apb_rst"}, `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_rst));




`undef LOGIC_OP_ITF_PRE_NAME
`undef LOGIC_OP_PRE_NAME
`undef LOGIC_OP_STR
`endif

