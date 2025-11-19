package SPI_slave_monitor_pkg;
  import SPI_slave_seq_item_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  class SPI_slave_monitor extends uvm_monitor;
  `uvm_component_utils(SPI_slave_monitor);
    SPI_slave_seq_item rsp_seq;
    uvm_analysis_port #(SPI_slave_seq_item) mon_ap;
    virtual SPI_slave_IF SPI_test_vif;

    function new(string name="SPI_slave_monitor", uvm_component parent = null);
     super.new(name, parent);
    endfunction //new()
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon_ap =new("mon_ap",this);
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        @(negedge SPI_test_vif.clk)
        rsp_seq = SPI_slave_seq_item::type_id::create("rsp_seq");
        rsp_seq.rst_n        = SPI_test_vif.rst_n;
        rsp_seq.MOSI         = SPI_test_vif.MOSI;
        rsp_seq.SS_n         = SPI_test_vif.SS_n;
        rsp_seq.tx_valid     = SPI_test_vif.tx_valid;
        rsp_seq.tx_data      = SPI_test_vif.tx_data;
        rsp_seq.rx_data      = SPI_test_vif.rx_data;
        rsp_seq.rx_valid     = SPI_test_vif.rx_valid;
        rsp_seq.MISO         = SPI_test_vif.MISO;
        rsp_seq.MISO_exp     = SPI_test_vif.MISO_exp;
        rsp_seq.rx_data_exp  = SPI_test_vif.rx_data_exp;
        rsp_seq.rx_valid_exp = SPI_test_vif.rx_valid_exp;
        mon_ap.write(rsp_seq);
      end
    endtask 
  endclass //SPI_slave_monitor extends uvm_monitor
endpackage