# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./memory.sv"
vlog "./five_bit_counter.sv"
vlog "./display_num_on_hex.sv"
vlog "./one_sec_clock.sv"
vlog "./ram32x4.v"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -L altera_mf_ver -voptargs="+acc" -t 1ps -lib work memory_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do memory_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
