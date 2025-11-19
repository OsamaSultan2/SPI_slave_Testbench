package SPI_slave_driver_pkg;
import uvm_pkg::*;
import SPI_slave_seq_item_pkg::*;
`include "uvm_macros.svh"

class SPI_slave_driver extends uvm_driver #(SPI_slave_seq_item);
    `uvm_component_utils(SPI_slave_driver)
    virtual SPI_slave_IF SPI_test_vif;
    SPI_slave_seq_item seq_item;
    function new(string name = "SPI_slave_driver", uvm_component parent=null);
      super.new(name,parent);
    endfunction //new()


    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        seq_item=SPI_slave_seq_item::type_id::create("seq_item");
        seq_item_port.get_next_item(seq_item);
        SPI_test_vif.rst_n     = seq_item.rst_n;
        SPI_test_vif.MOSI      = seq_item.MOSI; 
        SPI_test_vif.SS_n      = seq_item.SS_n;
        SPI_test_vif.tx_valid  = seq_item.tx_valid;
        SPI_test_vif.tx_data   = seq_item.tx_data;
        @(negedge SPI_test_vif.clk);
        seq_item_port.item_done();
        `uvm_info("DRIVING DATA",seq_item.convert2string(),UVM_HIGH);
      end

   endtask
endclass //Spi_driver extends uvm_driver
endpackage