`ifdef LOGIC_OP_ITF_PRE_NAME
//clock reset itf
clock_if #(100, 0) `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_clk)();
clock_if #(100, 0) `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_clk)();
reset_if #(100) `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_rst)(.clk(`MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_clk.CLOCK)), .rst_n(`MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_rst).RESET));
reset_if #(100) `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_rst)(.clk(`MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_clk.CLOCK)), .rst_n(`MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_rst).RESET));

//interface
op_in_if `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, input_vif) (.clk(`MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_clk.CLOCK)), .rst_n(`MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_rst.RESET)));
//svt_apb_if  `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_master_vif) ();
//svt_apb_if  `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_slave_vif)  ();
op_out_if `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, output_vif) (.clk(`MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_clk.CLOCK)), .rst_n(`MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_rst.RESET)));
apb_if `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_vif) ();
  

// Sub Environment Interface Instance

`undef LOGIC_OP_ITF_PRE_NAME
`endif

