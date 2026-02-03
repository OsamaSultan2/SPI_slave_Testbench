package RAM_test_pkg;
  import uvm_pkg::*;
  import RAM_env_pkg::*;
  import RAM_config_pkg::*;
  import RAM_seq_pkg::*;
  `include "uvm_macros.svh"

  class RAM_test extends uvm_test ;
  `uvm_component_utils(RAM_test);
  RAM_env             my_env;
  write_sequence      write_seq;
  read_sequence       read_seq;
  read_write_sequence read_write_seq;
  RAM_config_obj      RAM_config_obj_test;


  function new(string name="RAM_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  my_env               = RAM_env::type_id::create("my_env",this);
  RAM_config_obj_test  = RAM_config_obj::type_id::create("RAM_config_obj_test");
  write_seq            = write_sequence::type_id::create("write_seq");
  read_seq             = read_sequence::type_id::create("read_seq");
  read_write_seq       = read_write_sequence::type_id::create("read_write_seq");
  if(!uvm_config_db #(virtual RAM_ifc)::get(this,"","ifc",RAM_config_obj_test.RAM_test_vif))
    `uvm_fatal("NO_VIF","can't retrieve the virtual interface");
    uvm_config_db #(RAM_config_obj)::set(this,"*","config",RAM_config_obj_test);
  endfunction

  task  run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info("write_phase","starting the write sequence",UVM_LOW);
    write_seq.start(my_env.agt.sqr);
    `uvm_info("read_phase","starting the read sequence",UVM_LOW);
    read_seq.start(my_env.agt.sqr);
    `uvm_info("read_write_phase","starting the read_write sequence",UVM_LOW);
    read_write_seq.start(my_env.agt.sqr);
    phase.drop_objection(this);
  endtask 
  endclass 
endpackage