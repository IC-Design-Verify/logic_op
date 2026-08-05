//------------------------------------------------------------
//   Copyright 2010 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//------------------------------------------------------------
//
// Class Description:
//
//
`ifndef APB_DRIVER__SV
`define APB_DRIVER__SV
class apb_driver extends uvm_driver #(apb_seq_item, apb_seq_item);

// UVM Factory Registration Macro
//
`uvm_component_utils(apb_driver)

// Virtual Interface
virtual apb_if APB;

//------------------------------------------
// Data Members
//------------------------------------------
apb_agent_config m_cfg;
//------------------------------------------
// Methods
//------------------------------------------
extern function int sel_lookup(logic[31:0] address);
// Standard UVM Methods:
extern function new(string name = "apb_driver", uvm_component parent = null);
extern task run_phase(uvm_phase phase);
extern function void build_phase(uvm_phase phase);


endclass: apb_driver

function apb_driver::new(string name = "apb_driver", uvm_component parent = null);
  super.new(name, parent);
endfunction

task apb_driver::run_phase(uvm_phase phase);
  apb_seq_item req;
  apb_seq_item rsp;
  int psel_index;

  APB.PSEL <= 0;
  APB.PENABLE <= 0;
  APB.PADDR <= 0;
  // Wait for reset to clear
  @(posedge APB.PRESETn);

  forever begin
    APB.PSEL <= 0;
    APB.PENABLE <= 0;
    APB.PADDR <= 0;
    seq_item_port.get_next_item(req);
		//`uvm_info("APB_DRV_RUN", req.sprint(), UVM_MEDIUM)
    void'($cast(rsp, req.clone()));
    rsp.set_id_info(req);
    repeat(rsp.delay)
      @(APB.drv_cb);
    psel_index = sel_lookup(rsp.addr);
    if(psel_index >= 0) begin
      APB.PSEL[psel_index] <= 1;
      APB.PADDR <= rsp.addr;
      APB.PENABLE <= 0;
      APB.PWDATA <= rsp.data;
      APB.PWRITE <= rsp.we;
      @(APB.drv_cb);
      APB.PENABLE <= 1;
      @(APB.drv_cb);
      while (!APB.drv_cb.PREADY) begin
        @(APB.drv_cb);
      end
      if(rsp.we == 0)begin
        rsp.data = APB.PRDATA;
      end
      APB.PSEL[psel_index] <= 0;
      APB.PENABLE <= 0;
    end
    else begin
      `uvm_error("RUN", $sformatf("Access to addr %0h out of APB address range", rsp.addr))
      rsp.error = 1;
    end
    seq_item_port.item_done(rsp);
  end

endtask: run_phase

function void apb_driver::build_phase(uvm_phase phase);
  if(!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config", m_cfg)) begin
    `uvm_error("build_phase", "Unable to get apb_agent_config")
  end
endfunction: build_phase

// Looks up the address and returns PSEL line that should be activated
// If the address is invalid, a non positive integer is returned to indicate an error
function int apb_driver::sel_lookup(logic[31:0] address);
  for(int i = 0; i < m_cfg.no_select_lines; i++) begin
    if((address >= m_cfg.start_address[i]) && (address <= (m_cfg.start_address[i] + m_cfg.range[i]))) begin
      return i;
    end
  end
  return -1; // Error: Address not found
endfunction: sel_lookup
`endif
