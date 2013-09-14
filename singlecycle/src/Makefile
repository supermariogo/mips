# VHDL makefile script



DEBUSSY_PLI="${DEBUSSY_HOME}/share/PLI"
PRUNE_DIR="${WORK_DIR}/prune"
SIM_DIR="${WORK_DIR}/sim"
SRC_DIR="${WORK_DIR}/src"
SYN_DIR="${WORK_DIR}/syn"
TECH_VERILOG="smic18.v"
TOP_DESIGN="controller"
TEST_BENCH="tb_controller"
TEST_BENCH_FILE="tb_controller.vhd"
TEST_BENCH_FSDB="tb_controller.fsdb"

default:
	vlib work
	vcom -work work *.vhd
tb_controller:
	vsim -c -lib work tb_controller -do "run -all; q" 
tb_mips:
	vsim -c -lib work tb_mips -do "run -all; quit"
debug:
	debussy -93 -VHDL *.vhd
clean:
	rm -rf work debussyLog transcript vsim.wlf novas.rc  
