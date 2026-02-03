package RAM_monitor_pkg;
  import RAM_seq_item_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  class RAM_monitor extends uvm_monitor;
  `uvm_component_utils(RAM_monitor);
    RAM_seq_item rsp_seq;
    uvm_analysis_port #(RAM_seq_item) mon_ap;
    virtual RAM_ifc RAM_test_vif;

    function new(string name="RAM_monitor", uvm_component parent = null);
     super.new(name, parent);
    endfunction //new()
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon_ap =new("mon_ap",this);
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        @(negedge RAM_test_vif.clk)
        rsp_seq = RAM_seq_item::type_id::create("rsp_seq");
        rsp_seq.rst          = RAM_test_vif.rst;
        rsp_seq.rx_valid     = RAM_test_vif.rx_valid;
        rsp_seq.din          = RAM_test_vif.din;
        rsp_seq.tx_valid     = RAM_test_vif.tx_valid;
        rsp_seq.dout         = RAM_test_vif.dout;
        rsp_seq.tx_valid_exp = RAM_test_vif.tx_valid_exp;
        rsp_seq.dout_exp     = RAM_test_vif.dout_exp;
        mon_ap.write(rsp_seq);
      end
    endtask 
  endclass //RAM_monitor extends uvm_monitor
endpackage