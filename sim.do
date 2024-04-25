# Remove Old Working Library
if { [file exists "work"] } {
    vdel -all
}

# Create new modelsim working library

vlib work

# Compile all the Verilog sources in current folder into working library

vlog proj/*.v

# Open Test Bench Module for Simulation

vsim -novopt work.testbench

# Add all testbench signals to waveform diagram

add wave /testbench/*
onbreak resume

# Run Simulation

run -all
wave zoom full

