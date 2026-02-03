import uvm_pkg::*;
`include "uvm_macros.svh"
module RAM_sva (
//=========== inputs ===============\\
  input logic clk,
  input logic rst,
  input logic rx_valid,
  input logic [9:0] din,
//========== outputs ===============\\
  input logic tx_valid,
  input logic [7:0]dout
);
//====>RST_CHK
    property rst_prop;
    @(posedge clk) !rst |=> dout == 8'b0 && tx_valid == 1'b0;
    endproperty
    RST_CHK: assert property (rst_prop) 
    else `uvm_error("RESET_CHK","dout or tx_valid is not zero after reset");
    cover property (rst_prop);
//====>WRITE_ADDR_TX_CHK
property write_add_tx;
  @(posedge clk) disable iff (!rst)
  din[9:8] == 2'b00 && rx_valid |=> !tx_valid;
endproperty
WRITE_TX_CHK: assert property (write_add_tx)
  else `uvm_error("WRITE_ADDR_TX_CHK","tx_valid is high during write address operation");
cover property (write_add_tx);
//====>WRITE_ADDR_TX_CHK
property write_data_tx;
  @(posedge clk) disable iff (!rst)
  din[9:8] == 2'b01  && rx_valid |=> !tx_valid;
endproperty
WRITE_DATA_TX_CHK: assert property (write_data_tx)
  else `uvm_error("WRITE_DATA_TX_CHK","tx_valid is high during write data operation");
cover property (write_data_tx);
//====>READ_ADDR_TX_CHK
property read_addr_tx;
  @(posedge clk) disable iff (!rst)
  din[9:8] && rx_valid == 2'b10 |=> !tx_valid;
endproperty
READ_ADDR_TX_CHK: assert property (read_addr_tx)
  else `uvm_error("READ_ADDR_TX_CHK","tx_valid is high during read address operation");
  cover property (read_addr_tx);
//====>READ_DATA_TX_CHK
property read_data_tx;
  @(posedge clk) disable iff (!rst)
  (din[9:8] == 2'b11 && rx_valid)|=> tx_valid ##1 (!tx_valid)[->1];
endproperty
READ_DATA_TX_CHK: assert property (read_data_tx)
  else `uvm_error("READ_DATA_TX_CHK","tx_valid didn't rise high during read data operation");
  cover property (read_data_tx);
//====>WRITE_ADDR_DATA_CHK 
property write_addr_data;
  @(posedge clk) disable iff (!rst)
  (din[9:8] == 2'b00 ) |=> (din[9:8] == 2'b01)[->1];
endproperty
WRITE_ADDR_DATA_CHK: assert property (write_addr_data)
  else `uvm_error("WRITE_ADDR_DATA_CHK","Write data operation didn't follow write address operation");
  cover property (write_addr_data);
//====>READ_ADDR_DATA_CHK 
property read_addr_data;
  @(posedge clk) disable iff (!rst)
  (din[9:8] == 2'b10 ) |=> (din[9:8] == 2'b11)[->1];
endproperty
READ_ADDR_DATA_CHK: assert property (read_addr_data)
  else `uvm_error("READ_ADDR_DATA_CHK","Read data operation didn't follow read address operation");
  cover property (read_addr_data);
endmodule