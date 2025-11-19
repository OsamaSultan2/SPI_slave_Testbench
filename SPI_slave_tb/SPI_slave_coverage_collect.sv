package SPI_slave_coverage_pkg;
import  SPI_slave_seq_item_pkg::*;
import  uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_slave_coverage extends uvm_component;
  `uvm_component_utils(SPI_slave_coverage);
  SPI_slave_seq_item cov_item;
  uvm_analysis_export   #(SPI_slave_seq_item) cov_ap;
  uvm_tlm_analysis_fifo #(SPI_slave_seq_item) cov_fifo;
//============== functional coverage ===============================================================
covergroup cg;
//======> RX_data coverage
Rx_data_cp:coverpoint cov_item.rx_data[9:8]{
  bins values[] = {[0:$]};
  bins trans [] = (2'b00 => 2'b01) , (2'b10 => 2'b11);
}
//======> SS_n coverage
SS_n_cp: coverpoint cov_item.SS_n{
  bins normal_tx    = ( 1 => 0[*13] => 1);
  bins Read_data_tx = ( 1 => 0[*23] => 1);
}
//======> MOSI
MOSI_cp:coverpoint cov_item.MOSI{
  bins write_addr = (0 => 0 => 0);
  bins write_data = (0 => 0 => 1);
  bins read_addr  = (1 => 1 => 0);
  bins read_data  = (1 => 1 => 1);
}
//======> MOSI
// MOSI_arr_cp:coverpoint cov_item.MOSI_arr[0:2]{
//   bins write_addr = {3'b000};
//   bins write_data = {3'b001};
//   bins read_addr  = {3'b110};
//   bins read_data  = {3'b111};
// }
//======> cross MOSI,SS_N
cross_MOSI_SS: cross SS_n_cp, MOSI_cp{
  ignore_bins READ          = binsof(MOSI_cp.read_data)  && binsof(SS_n_cp.normal_tx);
  ignore_bins write_data_ig = binsof(MOSI_cp.write_data) && binsof(SS_n_cp.Read_data_tx);
  ignore_bins write_addr_ig = binsof(MOSI_cp.write_addr) && binsof(SS_n_cp.Read_data_tx);
  ignore_bins read_addr_ig  = binsof(MOSI_cp.read_addr)  && binsof(SS_n_cp.Read_data_tx);
}

endgroup

//===================================================================================================
  function new(string name="SPI_slave_coverage", uvm_component parent = null);
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
endclass //SPI_slave_coverage
endpackage