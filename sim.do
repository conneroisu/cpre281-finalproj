# Delete old compilation results
if { [file exists "work"] } {
    vdel -all
}

# Create new modelsim working library

vlib work

# Compile all the Verilog sources in current folder into working library

vlog  proj/*.v

# Open testbench module for simulation
# The newest Modelsim versions are sometimes optimizing too greedily and you won't necessarily see all the signals. In those cases, just disable optimizations:

vsim -novopt work.testbench

# Add all testbench signals to waveform diagram

add wave /testbench/*

onbreak resume
# Run simulation
run -all
wave zoom full

