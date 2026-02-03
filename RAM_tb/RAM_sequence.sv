package RAM_seq_pkg;
import RAM_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class write_sequence extends uvm_sequence #(RAM_seq_item);
`uvm_object_utils(write_sequence);
  RAM_seq_item seq_item;
  function new(string name="write_sequence");
    super.new(name);
  endfunction //new()

  virtual task body();
  seq_item = RAM_seq_item::type_id::create("seq_item");
  seq_item.read_Write.constraint_mode(0);
  seq_item.read.constraint_mode(0);
    repeat(10000) begin
      start_item(seq_item);
      assert (seq_item.randomize()) 
      else  `uvm_fatal("RANDOMIZATION","couldn't randomize the seqeunce item");
      finish_item(seq_item);
    end
  endtask 
endclass 
//============== READ Sequence ===================================
class read_sequence extends uvm_sequence #(RAM_seq_item);
  `uvm_object_utils(read_sequence);
  RAM_seq_item seq_item;

  function new(string name ="read_sequence");
    super.new(name);
  endfunction

  task body();
    seq_item = RAM_seq_item::type_id::create("seq_item");
    seq_item.read_Write.constraint_mode(0);
    seq_item.write.constraint_mode(0);
    repeat(10000) begin
      start_item(seq_item);
      assert (seq_item.randomize()) 
      else  `uvm_fatal("RANDOMIZATION","couldn't randomize the seqeunce item");
      finish_item(seq_item);
    end
  endtask 

endclass //read_sequence extends uvm_sequence 
  //============== READ_write Sequence ===================================
class read_write_sequence extends uvm_sequence #(RAM_seq_item);
  `uvm_object_utils(read_write_sequence);
  RAM_seq_item seq_item;

  function new(string name ="read_write_sequence");
    super.new(name);
  endfunction

  task body();
    seq_item = RAM_seq_item::type_id::create("seq_item");
    seq_item.write.constraint_mode(0);
    seq_item.read.constraint_mode(0);
    repeat(10000) begin
      start_item(seq_item);
      assert (seq_item.randomize()) 
      else  `uvm_fatal("RANDOMIZATION","couldn't randomize the seqeunce item");
      finish_item(seq_item);
    end
  endtask 
endclass
endpackage