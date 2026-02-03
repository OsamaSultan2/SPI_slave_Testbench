package RAM_coverage_pkg;
import  RAM_seq_item_pkg::*;
import  uvm_pkg::*;
`include "uvm_macros.svh"

class RAM_coverage extends uvm_component;
  `uvm_component_utils(RAM_coverage);
  RAM_seq_item cov_item;
  uvm_analysis_export   #(RAM_seq_item) cov_ap;
  uvm_tlm_analysis_fifo #(RAM_seq_item) cov_fifo;
//============== functional coverage ===============================================================
covergroup cg;
//====> DIN_CHK 
din_cov:coverpoint cov_item.din[9:8] {
  bins write_address  = {2'b00};
  bins write_data     = {2'b01};
  bins read_address   = {2'b10};
  bins read_data      = {2'b11};
  bins write_address_then_data = (2'b00 => 2'b01);
  bins read_address_then_data  = (2'b10 => 2'b11);
  bins full_transition         = (2'b00 => 2'b01 => 2'b10 => 2'b11);
}
rx_valid_cov:coverpoint cov_item.rx_valid{
  bins high = {1'b1};
  bins low  = {1'b0};
  option.weight = 0;
}
tx_valid_cov:coverpoint cov_item.tx_valid{
  bins high = {1'b1};
  bins low  = {1'b0};
  option.weight = 0;
}
cross_cov_rx:cross din_cov, rx_valid_cov{
  ignore_bins low_rx = binsof(rx_valid_cov) intersect{0};
}
cross_cov_tx:cross din_cov,tx_valid_cov{
  option.cross_auto_bin_max = 0;
  bins read_high_tx = binsof(tx_valid_cov.high) && binsof(din_cov.read_data);
}
endgroup

//===================================================================================================
  function new(string name="RAM_coverage", uvm_component parent = null);
    super.new(name,parent);
    cg =new();
  endfunction //new()

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_ap  = new("cov_ap",this);
    cov_fifo= new("cov_fifo",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_ap.connect(cov_fifo.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
    cov_fifo.get(cov_item);
    cg.sample();
    
    end
  endtask
endclass //RAM_coverage
endpackage