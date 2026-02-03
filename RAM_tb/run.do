vlib work
vlog -f src_file.list +define+SIM +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover 
coverage save data.ucdb -onexit
run 0 
do wave.do
run -all

