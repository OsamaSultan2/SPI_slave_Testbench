package RAM_driver_pkg;
import uvm_pkg::*;
import RAM_seq_item_pkg::*;
`include "uvm_macros.svh"

class RAM_driver extends uvm_driver #(RAM_seq_item);
    `uvm_component_utils(RAM_driver)
    virtual RAM_ifc RAM_test_vif;
    RAM_seq_item seq_item;
    function new(string name = "RAM_driver", uvm_component parent=null);
      super.new(name,parent);
    endfunction //new()

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
        seq_item=RAM_seq_item::type_id::create("seq_item");
      forever begin
        seq_item_port.get_next_item(seq_item);
        RAM_test_vif.rst      = seq_item.rst;
        RAM_test_vif.din      = seq_item.din;
        RAM_test_vif.rx_valid = seq_item.rx_valid;
        @(negedge RAM_test_vif.clk);
        seq_item_port.item_done();
        `uvm_info("DRIVING DATA",seq_item.convert2string(),UVM_HIGH);
      end
      

   endtask
endclass //Spi_driver extends uvm_driver
endpackage