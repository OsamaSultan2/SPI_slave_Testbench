module Slave_interface (clk,rst_n,MOSI,MISO,rx_valid,
tx_valid,rx_data,tx_data,ss_n);
  parameter IDLE      = 3'b000;
  parameter CHK_CMD   = 3'b001;
  parameter WRITE     = 3'b010;
  parameter READ_ADD  = 3'b011;
  parameter READ_DATA = 3'b100;
  input             clk,rst_n,tx_valid,ss_n,MOSI;
  input       [7:0] tx_data;
  output reg        MISO,rx_valid;
  output reg  [9:0] rx_data;
         reg  [2:0] cs , ns;
         reg  [3:0] counter;
         reg        address_sent;
//=========== next state logic =============================
always @(*) begin
  case (cs)
    IDLE:begin
      if (ss_n==0) begin
        ns=CHK_CMD;
      end
      else 
      ns=IDLE;
    end 
    CHK_CMD:begin
      if (ss_n==0 && MOSI==0) begin
        ns=WRITE;
      end
      else if (ss_n==0 && MOSI==1 && address_sent==0) begin
        ns=READ_ADD;
      end
      else if (ss_n==0 && MOSI==1 && address_sent==1) begin
        ns=READ_DATA;
      end
      else if (ss_n==1) begin
        ns=IDLE;
      end
      else
      ns=CHK_CMD;
    end 
    WRITE:begin
      if (ss_n==1) begin    
        ns=IDLE;
      end
      else
        ns=WRITE;
    end 
    READ_ADD:begin
      if (ss_n==1) begin     
        ns= IDLE;
      end
      else 
        ns = READ_ADD;
    end 
    READ_DATA:begin
      if (ss_n==1) begin                    
        ns= IDLE;
      end
      else 
        ns = READ_DATA;
    end 
    default:ns= IDLE;
  endcase
end
//================= memory state logic ==============================
always @(posedge clk) begin
  if (~rst_n) begin
    cs<=IDLE;
  end
  else
  cs<=ns;
end
//=============== output logic =====================================
always @(posedge clk) begin
  if (~rst_n) begin
    rx_valid          <= 0;
    MISO              <= 0;
    rx_data           <= 0;
    address_sent      <= 0;
  end
  else begin
    case (cs)
      IDLE : begin
            rx_valid           <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter            <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter            <= counter - 1;
                end
                else begin
                    rx_valid         <= 1;
                    address_sent     <= 1;
                end
            end
            READ_DATA : begin
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter > 0) begin
                        MISO    <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        address_sent  <= 0;
                    end
                end
                else begin
                    if (counter > 0) begin
                        rx_data[counter-1]  <= MOSI;
                        counter             <= counter - 1;
                    end
                    else begin
                        rx_valid <= 1;
                        counter  <= 8;
                    end
                end
            end
    endcase
  end
end
endmodule