package RAM_agent_pkg;
import RAM_driver_pkg::*;
import RAM_sequencer_pkg::*;
import RAM_seq_item_pkg::*;
import RAM_monitor_pkg::*;
import RAM_config_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
//================ UNCOMPLETE =============================
class RAM_agent extends uvm_agent;
`uvm_component_utils(RAM_agent);
RAM_monitor mon;
RAM_sequencer sqr;
RAM_config_obj cfg;
RAM_driver drv;
uvm_analysis_port #(RAM_seq_item) agt_ap;

  function new(string name="RAM_agent", uvm_component parent = null );
    super.new(name,parent);
  endfunction //new()

//-------->BUILD PHASE
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv=RAM_driver::type_id::create("drv",this);
    sqr=RAM_sequencer::type_id::create("sqr",this);
    mon=RAM_monitor::type_id::create("mon",this);
    cfg=RAM_config_obj::type_id::create("cfg");
    agt_ap=new("agt_ap",this);
    if(!uvm_config_db #(RAM_config_obj)::get(this,"","config",cfg))
    `uvm_fatal("BUILD_PHASE","couldn't retrieve the config_object");
  endfunction

//--------->CONNECT PHASE 
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  mon.RAM_test_vif=cfg.RAM_test_vif;
  drv.RAM_test_vif=cfg.RAM_test_vif;
  mon.mon_ap.connect(agt_ap);
  drv.seq_item_port.connect(sqr.seq_item_export);
endfunction
endclass //RAM_agent extends uvm_agent
endpackage