vlib work
vlog fifo_testcase.v
vsim -novopt -suppress 12110 tb +testcase=FULL
add wave *
run -all

