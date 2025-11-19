import SPI_slave_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module top ();
//========== CLOCK GENERATION ==============
  bit clk;
initial begin
  clk=0;
  forever begin
  #5 clk = ~clk;
    end
  
end
//========== modules instantiation ==============
  SPI_slave_IF ifc (clk);
  SLAVE DUT ( .clk(ifc.clk),
                  .rst_n(ifc.rst_n),
                  .MOSI(ifc.MOSI),
                  .MISO(ifc.MISO),
                  .SS_n(ifc.SS_n),
                  .rx_data(ifc.rx_data),
                  .rx_valid(ifc.rx_valid),
                  .tx_data(ifc.tx_data),
                  .tx_valid(ifc.tx_valid)
                  );
  Slave_interface GOLDEN ( .clk(ifc.clk),
                  .rst_n(ifc.rst_n),
                  .MOSI(ifc.MOSI),
                  .MISO(ifc.MISO_exp),
                  .ss_n(ifc.SS_n),
                  .rx_data(ifc.rx_data_exp),
                  .rx_valid(ifc.rx_valid_exp),
                  .tx_data(ifc.tx_data),
                  .tx_valid(ifc.tx_valid)
                  );
  bind DUT SPI_slave_sva SVA (.clk(ifc.clk),
                  .rst_n(ifc.rst_n),
                  .MOSI(ifc.MOSI),
                  .MISO(ifc.MISO),
                  .SS_n(ifc.SS_n),
                  .rx_data(ifc.rx_data),
                  .rx_valid(ifc.rx_valid),
                  .tx_data(ifc.tx_data),
                  .tx_valid(ifc.tx_valid)
                  );
//========== UVM TESTBENCH ==============
  initial begin
    uvm_config_db #(virtual SPI_slave_IF)::set(null,"uvm_test_top","ifc",ifc);
    run_test("SPI_slave_test");
  end

endmodule