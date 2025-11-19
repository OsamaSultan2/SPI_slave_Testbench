import uvm_pkg::*;
`include "uvm_macros.svh"
module SPI_slave_sva (input            MOSI, clk, rst_n, SS_n, tx_valid,
input      [7:0] tx_data,
input [9:0] rx_data,
input       rx_valid, MISO
);
//===========> RESET_CHK
 property reset_n_p;
    @(posedge clk) 
      !rst_n|=> rx_valid == 1'b0 && MISO == 1'b0 && rx_data == 10'b0;
  endproperty
  RESET_CHK: assert property(reset_n_p) else
      `uvm_fatal("RESET_CHK", "error in reset operation");
  cover property(reset_n_p);

  //=====> SS_n sequences 
  //------> write_addr_chk
  property write_add_p;
    @(posedge clk) disable iff(!rst_n) 
    !MOSI ##1 !MOSI ##1 !MOSI |-> ##10 rx_valid && SS_n [->1];
  endproperty
  WRITE_ADDR_CHK: assert property(write_add_p) else
      `uvm_fatal("SEQUENCE_CHK", "error in write address sequence");
  cover property(write_add_p);
  //------> write_data_chk
  property write_data_p;
    @(posedge clk) disable iff(!rst_n) 
    !MOSI ##1 !MOSI ##1 MOSI |-> ##10 rx_valid && SS_n [->1];
  endproperty
  WRITE_DATA_CHK: assert property(write_data_p) else
      `uvm_fatal("SEQUENCE_CHK", "error in write data sequence");
  cover property(write_data_p);

  //------> read_addr_chk
  property read_addr_p;
    @(posedge clk) disable iff(!rst_n) 
    MOSI ##1 MOSI ##1 !MOSI |-> ##10 rx_valid && SS_n [->1];
  endproperty
  READ_ADDR_CHK: assert property(read_addr_p) else
      `uvm_fatal("SEQUENCE_CHK", "error in read addr sequence");
  cover property(read_addr_p);
   //------> read_data_chk
  property read_data_p;
    @(posedge clk) disable iff(!rst_n) 
    MOSI ##1 MOSI ##1 MOSI |-> ##10 (rx_valid && SS_n [->1]);
  endproperty
  READ_DATA_CHK: assert property(read_data_p) else
      `uvm_fatal("SEQUENCE_CHK", "error in read data sequence");
  cover property(read_data_p);
endmodule