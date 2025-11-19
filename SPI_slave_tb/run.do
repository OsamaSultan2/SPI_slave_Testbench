vlib work
vlog -f src_file.list +define+SIM +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover 
coverage save data.ucdb -onexit
run 0 
do wave.do
run -all
coverage exclude -src SPI_slave.sv -line 36 -code b
coverage exclude -src SPI_slave.sv -line 37 -code s
coverage exclude -src SPI_slave.sv -line 126 -code b
coverage exclude -src SPI_slave.sv -line 127 -code s
coverage exclude -src SPI_slave.sv -line 128 -code s
coverage exclude -src SPI_slave.sv -line 129 -code s
coverage exclude -src SPI_slave.sv -line 130 -code s

