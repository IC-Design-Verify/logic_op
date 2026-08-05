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
`ifndef APB_AGENT__SV
`define APB_AGENT__SV
class apb_agent extends uvm_component;

// UVM Factory Registration Macro
//
`uvm_component_utils(apb_agent)

virtual apb_if vif;
//------------------------------------------
// Data Members
//------------------------------------------
apb_agent_config m_cfg;
//------------------------------------------
// Component Members
//------------------------------------------
uvm_analysis_port #(apb_seq_item) analysis_port;
apb_monitor   mon;
apb_sequencer seqr;
apb_driver    drv;
apb_coverage_monitor m_fcov_monitor;
//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "apb_agent", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass: apb_agent


function apb_agent::new(string name = "apb_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void apb_agent::build_phase(uvm_phase phase);
  if(!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config", m_cfg)) begin
    `uvm_error("build_phase", "APB agent config not found")
  end
  else
    uvm_config_db #(apb_agent_config)::set(this, "*", "apb_agent_config", m_cfg);

	//uvm_config_db#(virtual apb_if)::get(this, "", "apb_if", vif);
	if(m_cfg.APB == null) begin
		`uvm_fatal("CFGERR",$sformatf("Interface for Agent not set"))
	end
  vif = m_cfg.APB;
  // Monitor is always present
  mon = apb_monitor::type_id::create("mon", this);
  // Only build the driver and sequencer if active
  if(m_cfg.active == UVM_ACTIVE) begin
    drv = apb_driver::type_id::create("drv", this);
    seqr = apb_sequencer::type_id::create("seqr", this);
  end
  if(m_cfg.has_functional_coverage) begin
    m_fcov_monitor = apb_coverage_monitor::type_id::create("m_fcov_monitor", this);
  end
endfunction: build_phase

function void apb_agent::connect_phase(uvm_phase phase);
  mon.APB = m_cfg.APB;
  mon.apb_index = m_cfg.apb_index;
  analysis_port = mon.analysis_port;
  // Only connect the driver and the sequencer if active
  if(m_cfg.active == UVM_ACTIVE) begin
    drv.seq_item_port.connect(seqr.seq_item_export);
    drv.APB = m_cfg.APB;
  end
  if(m_cfg.has_functional_coverage) begin
    mon.analysis_port.connect(m_fcov_monitor.analysis_export);
  end

endfunction: connect_phase
`endif
