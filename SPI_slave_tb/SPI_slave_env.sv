package SPI_slave_env_pkg;
import SPI_slave_coverage_pkg::*;
import SPI_slave_scoreboard_pkg::*;
import SPI_slave_agt_pkg::*;
import SPI_slave_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_slave_env extends uvm_env;
`uvm_component_utils(SPI_slave_env)
SPI_slave_agent    agt;
SPI_slave_coverage cov;
SPI_slave_sb       sb;

function new(string name = "SPI_slave_env", uvm_component parent= null);
  super.new(name , parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  agt = SPI_slave_agent::type_id::create("agt",this);
  cov = SPI_slave_coverage::type_id::create("cov",this);
  sb  = SPI_slave_sb::type_id::create("sb",this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  agt.agt_ap.connect(cov.cov_ap);
  agt.agt_ap.connect(sb.sb_ap);
endfunction 


endclass

endpackage