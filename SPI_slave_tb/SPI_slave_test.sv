package SPI_slave_test_pkg;
  import uvm_pkg::*;
  import SPI_slave_env_pkg::*;
  import SPI_slave_config_pkg::*;
  import SPI_slave_seq_pkg::*;
  `include "uvm_macros.svh"

  class SPI_slave_test extends uvm_test ;
  `uvm_component_utils(SPI_slave_test);
  SPI_slave_env my_env;
  main_sequence main_seq;
  reset_sequence reset_seq;
  SPI_slave_config_obj SPI_slave_config_obj_test;


  function new(string name="SPI_slave_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  my_env                    = SPI_slave_env::type_id::create("my_env",this);
  SPI_slave_config_obj_test = SPI_slave_config_obj::type_id::create("SPI_slave_config_obj_test");
  main_seq                  = main_sequence::type_id::create("main_seq");
  reset_seq                 = reset_sequence::type_id::create("reset_seq");
  if(!uvm_config_db #(virtual SPI_slave_IF)::get(this,"","ifc",SPI_slave_config_obj_test.SPI_test_vif))
    `uvm_fatal("NO_VIF","can't retrieve the virtual interface");
    uvm_config_db #(SPI_slave_config_obj)::set(this,"*","config",SPI_slave_config_obj_test);
  endfunction

  task  run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info("run_phase","starting the reset sequence",UVM_LOW);
    reset_seq.start(my_env.agt.sqr);
    `uvm_info("run_phase","starting the main sequence",UVM_LOW);
    main_seq.start(my_env.agt.sqr);
    phase.drop_objection(this);
  endtask 
  endclass 
endpackage