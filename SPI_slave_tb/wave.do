onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group CLK/RST -color Orange /top/ifc/clk
add wave -noupdate -expand -group CLK/RST -color Orange /top/ifc/rst_n
add wave -noupdate -expand -group INPUTS -color Cyan /top/ifc/MOSI
add wave -noupdate -expand -group INPUTS -color Cyan /top/ifc/SS_n
add wave -noupdate -expand -group INPUTS -color Cyan /top/ifc/tx_valid
add wave -noupdate -expand -group INPUTS -color Cyan /top/ifc/tx_data
add wave -noupdate -color Cyan -radix binary /top/DUT/cs
add wave -noupdate -radix unsigned /top/DUT/counter
add wave -noupdate /top/DUT/received_address
add wave -noupdate -expand -group OUT/OUT_EXP -radix binary /top/ifc/rx_data
add wave -noupdate -expand -group OUT/OUT_EXP -radix binary /top/ifc/rx_data_exp
add wave -noupdate -expand -group OUT/OUT_EXP /top/ifc/rx_valid
add wave -noupdate -expand -group OUT/OUT_EXP /top/ifc/rx_valid_exp
add wave -noupdate -expand -group OUT/OUT_EXP /top/ifc/MISO
add wave -noupdate -expand -group OUT/OUT_EXP /top/ifc/MISO_exp
add wave -noupdate -expand -group ASSERATIONS /uvm_pkg::uvm_reg_map::do_write/#ublk#215181159#1731/immed__1735
add wave -noupdate -expand -group ASSERATIONS /uvm_pkg::uvm_reg_map::do_read/#ublk#215181159#1771/immed__1775
add wave -noupdate -expand -group ASSERATIONS /SPI_slave_seq_pkg::main_sequence::body/#ublk#62382359#15/immed__17
add wave -noupdate -expand -group ASSERATIONS /top/RESET_CHK
add wave -noupdate -expand -group ASSERATIONS /top/DUT/IDLE_TRANS_CHK
add wave -noupdate -expand -group ASSERATIONS /top/DUT/CMD_TRANS_CHK
add wave -noupdate -expand -group ASSERATIONS /top/DUT/WRITE_to_IDLE_TRANS_CHK
add wave -noupdate -expand -group ASSERATIONS /top/DUT/READ_ADDR_to_IDLE_TRANS_CHK
add wave -noupdate -expand -group ASSERATIONS /top/DUT/READ_DATA_to_IDLE_TRANS_CHK
add wave -noupdate -expand -group ASSERATIONS /top/DUT/SVA/WRITE_ADDR_CHK
add wave -noupdate -expand -group ASSERATIONS /top/DUT/SVA/WRITE_DATA_CHK
add wave -noupdate -expand -group ASSERATIONS /top/DUT/SVA/READ_ADDR_CHK
add wave -noupdate -expand -group ASSERATIONS /top/DUT/SVA/READ_DATA_CHK
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3325 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 193
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {149904 ns} {150016 ns}
