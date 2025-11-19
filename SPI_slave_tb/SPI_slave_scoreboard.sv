package SPI_slave_scoreboard_pkg;
import SPI_slave_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class SPI_slave_sb extends uvm_scoreboard;
  `uvm_component_utils(SPI_slave_sb);
  uvm_analysis_export   #(SPI_slave_seq_item) sb_ap;
  uvm_tlm_analysis_fifo #(SPI_slave_seq_item) sb_fifo;
  SPI_slave_seq_item chk_seq;
  int correct_count, error_count;
  function new(string name="SPI_slave_sb", uvm_component parent = null );
    super.new(name,parent);
  endfunction //new()

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_ap   = new("sp_ap",this);
    sb_fifo = new("sp_fifo",this);
  endfunction

  function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  sb_ap.connect(sb_fifo.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      sb_fifo.get(chk_seq);
      if(chk_seq.MISO == chk_seq.MISO_exp && chk_seq.rx_data == chk_seq.rx_data_exp && chk_seq.rx_valid == chk_seq.rx_valid_exp) begin
        `uvm_info("SCOREBOARD","The SPI_slave output is correct",UVM_HIGH);
        correct_count++;
      end
      else begin
        `uvm_error("SCOREBOARD",chk_seq.convert2string());
        error_count++;
      end
    end
  endtask 
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("REPORT_PHASE",$sformatf("correct transactions = %0d",correct_count),UVM_MEDIUM);
    `uvm_info("REPORT_PHASE",$sformatf("failed  transactions = %0d",error_count),UVM_MEDIUM);
  endfunction

endclass //SPI_slave_sb extends superClass

endpackage