package SPI_slave_agt_pkg;
import SPI_slave_driver_pkg::*;
import SPI_slave_sequencer_pkg::*;
import SPI_slave_seq_item_pkg::*;
import SPI_slave_monitor_pkg::*;
import SPI_slave_config_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
//================ UNCOMPLETE =============================
class SPI_slave_agent extends uvm_agent;
`uvm_component_utils(SPI_slave_agent);
SPI_slave_monitor mon;
SPI_slave_sequencer sqr;
SPI_slave_config_obj cfg;
SPI_slave_driver drv;
uvm_analysis_port #(SPI_slave_seq_item) agt_ap;

  function new(string name="SPI_slave_agent", uvm_component parent = null );
    super.new(name,parent);
  endfunction //new()

//-------->BUILD PHASE
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv=SPI_slave_driver::type_id::create("drv",this);
    sqr=SPI_slave_sequencer::type_id::create("sqr",this);
    mon=SPI_slave_monitor::type_id::create("mon",this);
    cfg=SPI_slave_config_obj::type_id::create("cfg");
    agt_ap=new("agt_ap",this);
    if(!uvm_config_db #(SPI_slave_config_obj)::get(this,"","config",cfg))
    `uvm_fatal("BUILD_PHASE","couldn't retrieve the config_object");
  endfunction

//--------->CONNECT PHASE 
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  mon.SPI_test_vif=cfg.SPI_test_vif;
  drv.SPI_test_vif=cfg.SPI_test_vif;
  mon.mon_ap.connect(agt_ap);
  drv.seq_item_port.connect(sqr.seq_item_export);
endfunction
endclass //alsu_agent extends uvm_agent
endpackage