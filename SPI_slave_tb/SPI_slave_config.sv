package SPI_slave_config_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  class SPI_slave_config_obj extends uvm_object;
    `uvm_object_utils(SPI_slave_config_obj);
    virtual SPI_slave_IF SPI_test_vif;
    function new(string name="SPI_slave_config_obj");
      super.new(name);
    endfunction //new()
  
  endclass //SPI_config_obj extends

endpackage