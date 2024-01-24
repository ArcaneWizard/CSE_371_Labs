# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./FIFO_Control.sv"
vlog "./DE1_SoC_FIFO.sv"
vlog "./FIFO.sv"
vlog "./display_num_on_hex.sv"
vlog "./ram16x8.v"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -L altera_mf_ver -voptargs="+acc" -t 1ps -lib work FIFO_Control_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do FIFO_Control_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
