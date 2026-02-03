package RAM_scoreboard_pkg;
import RAM_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class RAM_sb extends uvm_scoreboard;
  `uvm_component_utils(RAM_sb);
  uvm_analysis_export   #(RAM_seq_item) sb_ap;
  uvm_tlm_analysis_fifo #(RAM_seq_item) sb_fifo;
  RAM_seq_item chk_seq;
  int correct_count, error_count;
  function new(string name="RAM_sb", uvm_component parent = null );
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
      if(chk_seq.dout === chk_seq.dout_exp && chk_seq.tx_valid == chk_seq.tx_valid_exp) begin
        `uvm_info("SCOREBOARD","The RAM output is correct",UVM_HIGH);
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

endclass //RAM_sb extends uvm_scoreboard

endpackage