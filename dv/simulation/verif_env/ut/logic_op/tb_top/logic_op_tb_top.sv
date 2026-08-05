`ifndef LOGIC_OP_TB_TOP__SV
`define LOGIC_OP_TB_TOP__SV

//`ifdef RUN_LOGIC_OP
module logic_op_tb_top();
  import uvm_pkg::*;
  // import package
  //import svt_uvm_pkg::*;    
  //import svt_apb_uvm_pkg::*;    

         
  //type_width

  //`ifdef RUN_LOGIC_OP
  //clock reset itf


  //`ifdef TB_USE_ASSIGN
  //interface
  `define LOGIC_OP_ITF_PRE_NAME logic_op
  //`define LOGIC_OP_PATH
  `include "logic_op_include/logic_op_itf_inst.sv"
  //`endif

  //dut inst
  logic_op u_logic_op (
                                        .clk                             (`MERGE_ITF_NAME(logic_op, sys_clk.CLOCK)          )
                                        ,.rst_n                          (`MERGE_ITF_NAME(logic_op, sys_rst.RESET)          )
                                        ,.pclk                           (`MERGE_ITF_NAME(logic_op, apb_clk.CLOCK)          )
                                        ,.presetn                        (`MERGE_ITF_NAME(logic_op, apb_rst.RESET)          )
      );


  //use for download program to instr memory
  `include "logic_op_include/logic_op_program_download.sv"

  //`ifdef TB_USE_ASSIGN
  //itf_assignment
	`define LOGIC_OP_ITF_PRE_NAME logic_op
  `define LOGIC_OP_PRE_NAME LOGIC_OP
  `include "logic_op_include/logic_op_interface_assignment.sv"
	`undef LOGIC_OP_ITF_PRE_NAME
  `undef LOGIC_OP_PRE_NAME
  //`endif

  //`endif

  //sub_env test_top param
  //parameter xxx_top_name = "xxx_uvm_test_top";

  //>>>>>>> subsys TB >>>>>>>
  //<<<<<<< subsys TB <<<<<<<


  initial begin
  //`ifdef TB_USE_ASSIGN
    //`ifdef RUN_LOGIC_OP
    //config interface
		`define LOGIC_OP_ITF_PRE_NAME logic_op
    `define LOGIC_OP_PRE_NAME LOGIC_OP
    `define LOGIC_OP_ENV_INST_NAME m_env
    `include "logic_op_include/logic_op_itf_config.sv"
	  `undef LOGIC_OP_ITF_PRE_NAME
    `undef LOGIC_OP_PRE_NAME
    `undef LOGIC_OP_ENV_INST_NAME
    //`endif
  //`endif
  end

  `ifdef DEMO_MAKEFILE
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, logic_op_tb_top);
  end
  `endif

  //`ifdef POST_SIM 
  //initial begin
  //  `ifdef SDF_MAX
  //    $sdf_annotate("../../xxx_max.sdf", xxx_tb_top.u_dut, 
  //                   "TYPICAL", "1:1:1", "FROM_MTM");
  //  `elsif SDF_MIN
  //    $sdf_annotate("../../xxx_min.sdf", xxx_tb_top.u_dut, 
  //                   "TYPICAL", "1:1:1", "FROM_MTM");
  //  `endif
  //end
  //`endif

endmodule
//`endif 

//`ifndef TB_USE_ASSIGN
//Include Bind File
//`define LOGIC_OP_NAME logic_op
//`define LOGIC_OP_INST_PATH logic_op_tb_top.u_logic_op
//`define LOGIC_OP_PRE_NAME LOGIC_OP
//`include "logic_op_include/logic_op_bind.sv"
//`endif

`endif
