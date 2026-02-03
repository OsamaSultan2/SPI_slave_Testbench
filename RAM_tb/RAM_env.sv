package RAM_env_pkg;
import RAM_coverage_pkg::*;
import RAM_scoreboard_pkg::*;
import RAM_agent_pkg::*;
import RAM_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class RAM_env extends uvm_env;
`uvm_component_utils(RAM_env)
RAM_agent    agt;
RAM_coverage cov;
RAM_sb       sb;

function new(string name = "RAM_env", uvm_component parent= null);
  super.new(name , parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  agt = RAM_agent::type_id::create("agt",this);
  cov = RAM_coverage::type_id::create("cov",this);
  sb  = RAM_sb::type_id::create("sb",this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  agt.agt_ap.connect(cov.cov_ap);
  agt.agt_ap.connect(sb.sb_ap);
endfunction 


endclass

endpackage