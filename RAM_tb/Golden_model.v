
module Golden_RAM #(
    parameter ADDR_WIDTH = 8, 
    parameter MEM_DEPTH = 256, 
    parameter DATA_WIDTH = 8
)(
    input clk,
    input rst_n,
    input rx_valid,
    input [ADDR_WIDTH+1:0] din, // (DATA_WIDTH+2)-bit input frame
    output reg [DATA_WIDTH-1:0] dout, // DATA_WIDTH-bit output word
    output reg tx_valid
);

    // Memory declaration
    reg [DATA_WIDTH-1:0] mem [MEM_DEPTH-1:0]; 

    // Address and data registers
    reg [ADDR_WIDTH-1:0] wr_addr;
    reg [ADDR_WIDTH-1:0] rd_addr;
    reg [DATA_WIDTH-1:0] data_in;

    // Control signals
    reg read_enable;

    always @(posedge clk) begin
        if (!rst_n) begin
            dout <= 0;
            tx_valid <= 0;
            wr_addr <= 0;
            rd_addr <= 0;
            read_enable <= 0;
        end 
        else if (rx_valid) begin
           
            case ({din[9], din[8]})
                2'b00: begin 
                    wr_addr <= din[7:0]; // Set address for write
                    read_enable <= 0;
                    tx_valid <= 0;
                end
                2'b01: begin
                    mem[wr_addr] <= din[7:0]; // Load data to be written
                    read_enable <= 0;
                    tx_valid <= 0;
                end
                2'b10: begin
                    rd_addr <= din[7:0]; // Set address for read
                    read_enable <= 1;    // Enable read
                    tx_valid <= 0;
                end
                2'b11: begin
                    dout <= mem[rd_addr]; // Read data from memory
                    tx_valid <= 1;
                    read_enable <= 0;
                end
                default: begin
                    read_enable <= 0;
                    tx_valid <= 0;
                end
            endcase        
        end
    end
endmodule