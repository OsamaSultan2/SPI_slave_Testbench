package SPI_slave_seq_pkg;
import SPI_slave_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class main_sequence extends uvm_sequence #(SPI_slave_seq_item);
`uvm_object_utils(main_sequence);
  SPI_slave_seq_item seq_item;
  function new(string name="main_sequence");
    super.new(name);
  endfunction //new()

  virtual task body();
  seq_item = SPI_slave_seq_item::type_id::create("seq_item");
    repeat(20000) begin
      start_item(seq_item);
      assert (seq_item.randomize()) 
      else  `uvm_fatal("RANDOMIZATION","couldn't randomize the seqeunce item");
      finish_item(seq_item);
    end
  endtask 
endclass 
//============== RESET Sequence ===================================
class reset_sequence extends uvm_sequence #(SPI_slave_seq_item);
  `uvm_object_utils(reset_sequence);
  SPI_slave_seq_item seq_item;

  function new(string name ="reset_sequence");
    super.new(name);
  endfunction

  task body();
    seq_item = SPI_slave_seq_item::type_id::create("seq_item");
    start_item(seq_item);
    seq_item.rst_n       = 0;
    seq_item.MOSI        = 0;
    seq_item.SS_n        = 1;
    seq_item.tx_valid    = 0;
    seq_item.tx_data     = 8'b0;
    finish_item(seq_item);
  endtask 
endclass //reset_sequence extends uvm_sequence 
endpackage