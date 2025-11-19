interface SPI_slave_IF (input bit clk);
logic       MOSI, rst_n, SS_n, tx_valid;
logic [7:0] tx_data;
logic [9:0] rx_data;
logic       rx_valid, MISO;
//====== GOLDEN MODEL OUTPUT ==========
logic [9:0] rx_data_exp;
logic       rx_valid_exp, MISO_exp;
endinterface