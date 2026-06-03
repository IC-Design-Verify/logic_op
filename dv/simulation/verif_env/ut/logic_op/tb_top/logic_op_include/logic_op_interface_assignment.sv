//interface assignment
//op_in : input
assign u_logic_op.in1                                     = `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, input_vif).data1;
assign u_logic_op.in2                                     = `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, input_vif).data2;
assign u_logic_op.in_en                                   = `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, input_vif).data_en;
//svt_apb : apb
assign `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_master_vif).pclk    = `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_clk.CLOCK);
assign `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_master_vif).presetn = `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_rst.RESET);
assign `LOGIC_OP_PATH.psel             = `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_master_vif).psel     ;
assign `LOGIC_OP_PATH.penable          = `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_master_vif).penable  ;
assign `LOGIC_OP_PATH.paddr            = `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_master_vif).paddr    ;
assign `LOGIC_OP_PATH.pwrite           = `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_master_vif).pwrite   ;
assign `LOGIC_OP_PATH.pwdata           = `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_master_vif).pwdata   ;
assign `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_master_vif).slave_if[0].prdata  = `LOGIC_OP_PATH.prdata;
assign `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_master_vif).slave_if[0].pslverr = 'b0                     ;
assign `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_master_vif).slave_if[0].pready  = 'b1                     ;
assign `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_slave_vif).pclk    = 0;//`MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_clk.CLOCK);
assign `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_slave_vif).presetn = 0;//`MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, sys_rst.RESET);
//assign `LOGIC_OP_PATH.apb_psel             = `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_slave_vif).psel[0]  ;
//assign `LOGIC_OP_PATH.apb_penable          = `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_slave_vif).penable  ;
//assign `LOGIC_OP_PATH.apb_paddr            = `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_slave_vif).paddr    ;
//assign `LOGIC_OP_PATH.apb_pwrite           = `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_slave_vif).pwrite   ;
//assign `LOGIC_OP_PATH.apb_pwdata           = `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_slave_vif).pwdata   ;
//assign `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_slave_vif).slave_if[0].prdata  = `LOGIC_OP_PATH.apb_prdata;
//assign `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_slave_vif).slave_if[0].pslverr = 'b0                     ;
//assign `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, apb_slave_vif).slave_if[0].pready  = 'b1                     ;
//op_out : output
assign `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, output_vif).data = u_logic_op.out                                    ;
assign `MERGE_ITF_NAME(`LOGIC_OP_ITF_PRE_NAME, output_vif).data_en = u_logic_op.out_en                                 ;
