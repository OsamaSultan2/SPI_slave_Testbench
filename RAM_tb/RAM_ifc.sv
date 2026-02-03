interface RAM_ifc(input bit  clk);
//=========== inputs ===============\\
  logic rst;
  logic rx_valid;
  logic [9:0] din;
//========== outputs ===============\\
  logic tx_valid;
  logic [7:0]dout;
//========== golden_model outputs ===============\\
  logic tx_valid_exp;
  logic [7:0]dout_exp;
endinterface //RAM_ifc(input clk)