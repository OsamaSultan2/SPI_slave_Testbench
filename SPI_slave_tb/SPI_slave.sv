module SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

input            MOSI, clk, rst_n, SS_n, tx_valid;
input      [7:0] tx_data;
output reg [9:0] rx_data;
output reg       rx_valid, MISO;

reg [3:0] counter;
reg       received_address;
reg [2:0] cs, ns;

always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI)
                    ns = WRITE;
                else begin
                    if (received_address) 
                        ns = READ_DATA; //bug ns should be READ_DATA WHEN the recieved address equals one
                    else
                        ns = READ_ADD;
                end
            end
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data           <= 0;
        rx_valid          <= 0;
        received_address  <= 0;
        MISO              <= 0;
    end
    else begin
        case (cs)
            IDLE : begin
                rx_valid          <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                    received_address <= 1;
                end
            end
            READ_DATA : begin 
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter > 0) begin
                        MISO <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        received_address  <= 0;
                    end
                end
                else begin
                    if (counter > 0) begin
                        rx_data[counter-1] <= MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        rx_valid <= 1;
                        counter <= 8;
                    end
                end
            end
            default: begin
                rx_data           <= 0;
                rx_valid          <= 0;
                received_address  <= 0;
                MISO              <= 0;
            end
        endcase
    end
end

//============================= ASSERTION =======================
`ifdef SIM
//---> IDLE 
    property IDLE_trans_p;
        @(posedge clk) disable iff(!rst_n) 
        cs == IDLE  && !SS_n |=> cs == CHK_CMD; 
    endproperty
    IDLE_TRANS_CHK: assert property(IDLE_trans_p) else
    $error("error in idle to chk_cmd transition");

//---> CHK_CMD
    property CMD_trans_p;
        @(posedge clk) disable iff(!rst_n) 
        cs == CHK_CMD  && !SS_n |=> cs == WRITE || cs == READ_ADD || cs == READ_DATA; 
    endproperty
    CMD_TRANS_CHK: assert property(CMD_trans_p) else
    $error("error in transition from CHK_CMD");

//-----> WRITE to IDLE state
    property WRITE_to_IDLE_trans_p;
        @(posedge clk) disable iff(!rst_n) 
        cs == WRITE  && SS_n |=> cs == IDLE; 
    endproperty
    WRITE_to_IDLE_TRANS_CHK: assert property(WRITE_to_IDLE_trans_p) else
    $error("error in returning to IDLE state from WRITE state");

//-----> READ_ADDR to IDLE state
    property READ_ADDR_to_IDLE_trans_p;
        @(posedge clk) disable iff(!rst_n) 
        cs == READ_ADD   && SS_n |=> cs == IDLE; 
    endproperty
    READ_ADDR_to_IDLE_TRANS_CHK: assert property(READ_ADDR_to_IDLE_trans_p) else
    $error("error in returning to IDLE state from READ_ADDR state");

//-----> READ_DATA to IDLE state
    property READ_DATA_to_IDLE_trans_p;
        @(posedge clk) disable iff(!rst_n) 
        cs == READ_DATA   && SS_n |=> cs == IDLE; 
    endproperty
    READ_DATA_to_IDLE_TRANS_CHK: assert property(READ_DATA_to_IDLE_trans_p) else
    $error("error in returning to IDLE state from READ_DATA state");

`endif
endmodule