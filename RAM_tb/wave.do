onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group clk/reset -color Yellow /top/ifc/clk
add wave -noupdate -expand -group clk/reset -color Yellow /top/ifc/rst
add wave -noupdate -expand -group inputs /top/ifc/din
add wave -noupdate -expand -group inputs /top/ifc/rx_valid
add wave -noupdate -expand -group outputs -color Cyan /top/ifc/tx_valid
add wave -noupdate -expand -group outputs -color Cyan /top/ifc/tx_valid_exp
add wave -noupdate -expand -group outputs -color Magenta /top/ifc/dout
add wave -noupdate -expand -group outputs -color Magenta /top/ifc/dout_exp
add wave -noupdate /top/DUT/SVA/RST_CHK
add wave -noupdate /top/DUT/SVA/WRITE_TX_CHK
add wave -noupdate /top/DUT/SVA/WRITE_DATA_TX_CHK
add wave -noupdate /top/DUT/SVA/READ_ADDR_TX_CHK
add wave -noupdate /top/DUT/SVA/READ_DATA_TX_CHK
add wave -noupdate /top/DUT/SVA/WRITE_ADDR_DATA_CHK
add wave -noupdate /top/DUT/SVA/READ_ADDR_DATA_CHK
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {299146 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {299050 ns} {300050 ns}
