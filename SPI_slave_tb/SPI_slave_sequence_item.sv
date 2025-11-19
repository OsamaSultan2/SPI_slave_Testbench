package SPI_slave_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_slave_seq_item extends uvm_sequence_item;
  `uvm_object_utils(SPI_slave_seq_item);
  rand bit         MOSI,clk, rst_n, SS_n, tx_valid;
  rand bit [0:10]  MOSI_arr;
  rand bit [7:0]   tx_data;
//----------------- OUTPUTS --------------------------------
  logic    [9:0]   rx_data;
  logic            rx_valid, MISO;
//---------------- GOLDEN_MODEL_OUTPUT---------------------------------
  logic    [9:0]   rx_data_exp;
  logic            rx_valid_exp, MISO_exp;
//-------------------------------------------------------
  int              i               = 0;
  int              counter         = 0;
  bit      [0:2]   old_cmd         = 3'b001;
  bit              new_transacrion = 0;
  bit              read_data       = 0;
//=========== constraints ============================
//-------> RESET_CHK
  constraint rst_n_c{
    rst_n dist {1'b0 :=5, 1:=100};
  }
//-------> SS_n_CHK
  constraint SS_n_c {
    if (new_transacrion) {
      SS_n == 1;
    }
    else {
      SS_n == 0;
    }
  }
//-------> MOSI_ARR_CHK
  constraint MOSI_arr_c {
    if (old_cmd == 3'b000) {
      MOSI_arr[0:2] == 3'b001;
    }
    else if (old_cmd == 3'b110) {
      MOSI_arr[0:2] == 3'b111;
    }
    else {
      MOSI_arr[0:2] inside {3'b000,3'b110};
    }
  }

//--------> MOSI 
  constraint MOSI_c {
    MOSI == MOSI_arr[counter];  //will be disabled until the entering chk_cmd state
  }
//-------> tx_valid
  constraint tx_valid_c{
    if(read_data && counter>13){
      tx_valid ==1'b1;
    }
    else {
      tx_valid ==1'b0;
    }
  }
//------- post randomization for controlling the sequence flow 
function void post_randomize();
  if (!rst_n) begin
    counter=0;new_transacrion=0;read_data=0;old_cmd = 3'b001;i=0; // to begin randomization normally
    this.MOSI_arr.rand_mode(1);
    this.tx_data.rand_mode(1);
  end 
  else begin
    read_data = (MOSI_arr[0:2]==3'b111)? 1:0;
    //    SS_n normal operation 
    if (counter == 13 && read_data == 0 ) begin
      new_transacrion = 1; counter = 0; 
    end
    else if (counter == 23 && read_data == 1) begin
      new_transacrion = 1; counter = 0;
    end
    else begin
      new_transacrion = 0; counter++;
    end
    if (!new_transacrion) begin
      this.MOSI_arr.rand_mode(0); //stopping the array randomization until passing the whole sequence
      //passing the MOSI_arr elements to the MOSI
      if ( counter >=11 )begin
        // i++;
        MOSI_c.constraint_mode(0);
      end
      else begin
        // i=0;
        MOSI_c.constraint_mode(1);
      end
    end
    //randomize the array at the beginning of new transaction.
    else begin
      this.MOSI_arr.rand_mode(1);
      old_cmd = MOSI_arr[0:2];
    end
    //-------> tx_data control
    if(read_data) 
      this.tx_data.rand_mode(0);
    else 
      this.tx_data.rand_mode(1);
  end
  
  
endfunction
//======================== METHODS ========================
    function new(string name="SPI_slave_seq_item");
      super.new(name);
    endfunction //new()
    
    function string convert2string();
      return $sformatf("%s , rst_n=%0b, SS_n=%0b, MOSI=%0b, tx_valid=%0b, tx_data=%0b, rx_data=%0b, rx_valid=%0b, MISO=%0b
      rx_valid_exp= %0b, MISO_exp=%0b, rx_data_exp=%0b",
      super.convert2string() ,rst_n, SS_n, MOSI, tx_valid, tx_data, rx_data, rx_valid, MISO, rx_valid_exp, MISO_exp, rx_data_exp);
    endfunction
endclass //SPI_slave_seq_item extends uvm_sequence_item
endpackage