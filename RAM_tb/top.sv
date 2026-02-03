import RAM_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module top ();
  bit clk;
  //========== CLOCK GENERATION ==============
  initial begin
    clk=0;
    forever begin
      #5 clk = ~clk;
    end
  end
  //========== modules instantiation ==============
  RAM_ifc ifc (clk);
  RAM DUT ( .clk(ifc.clk),
            .rst_n(ifc.rst),
            .din(ifc.din),
            .dout(ifc.dout),
            .rx_valid(ifc.rx_valid),
            .tx_valid(ifc.tx_valid)
            );
  Golden_RAM GOLDEN ( .clk(ifc.clk),
                      .rst_n(ifc.rst),
                      .din(ifc.din),
                      .dout(ifc.dout_exp),
                      .rx_valid(ifc.rx_valid),
                      .tx_valid(ifc.tx_valid_exp)
                      );
  bind DUT RAM_sva SVA ( .clk(ifc.clk),
                        .rst(ifc.rst),
                        .din(ifc.din),
                        .dout(ifc.dout),
                        .rx_valid(ifc.rx_valid),
                        .tx_valid(ifc.tx_valid)
                        );
  //========== UVM TESTBENCH ==============
  initial begin
    uvm_config_db #(virtual RAM_ifc)::set(null,"uvm_test_top","ifc",ifc);
    run_test("RAM_test");
  end
endmodule