package RAM_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class RAM_seq_item extends uvm_sequence_item;
  `uvm_object_utils(RAM_seq_item);
  rand bit        rst;
  rand bit        rx_valid;
  rand bit [9:0]  din;
  //========== outputs ===============\\
  logic       tx_valid;
  logic [7:0] dout;
  //========== golden_model outputs ===============\\
  logic       tx_valid_exp;
  logic [7:0] dout_exp;
  //--------------------------------------------------
  bit[1:0] old_cmd =2'b00;
////////////////////////////////////////////////////////////////////////////////////
/////======================== CONSTRAINTS =====================================/////
//---->RST
constraint rst_c{
 rst dist {1:=95, 0:=5};
}

//----> rx_valid
constraint rx_valid_c {
  rx_valid dist {1:=95 , 0:=5 };
}

//----> write_sequence 
constraint write{
  if(old_cmd==2'b00){
    din[9:8] inside {2'b00, 2'b01};
  } 
  else{
    din[9:8] == 2'b00;
  } 

}

//----> read_sequence
constraint read{
  if(old_cmd==2'b10){
    din[9:8] inside {2'b10, 2'b11};
  } 
  else{
    din[9:8] == 2'b10;
  } 
}

//----> read_Write
constraint read_Write{
  if (old_cmd == 2'b00) {
    din[9:8] inside {2'b00, 2'b01};
  }
  else if(old_cmd==2'b10){
    din[9:8] inside {2'b10, 2'b11};
  }   
  else if (old_cmd == 2'b01){
    din[9:8] dist {2'b00 :=40, 2'b10 :=60};
  } else {
    din[9:8] dist {2'b00 :=60, 2'b10 :=40};
  }
}

//======================== METHODS ========================
    function void post_randomize();
      old_cmd = din[9:8];
    endfunction

    function new(string name="RAM_seq_item");
      super.new(name);
    endfunction //new()
    
    function string convert2string();
      return $sformatf("%s , rst= %0b, din= %0b , rx_valid= %0b, tx_valid= %0b, tx_valid_exp= %0b,
      dout=%0b, dout_exp=%0b",
      super.convert2string(),rst,din,rx_valid,tx_valid,tx_valid_exp,dout,dout_exp);
    endfunction
endclass //RAM_seq_item extends uvm_sequence_item
endpackage