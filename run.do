
set target "mips_tb"
set file "${target}.v"
# remove the work directory
if { [file exists "work"] } {
	vdel -all
}

vlog *.v

vsim -voptargs=+acc $target
force -freeze sim:/$target/clk 1 0, 0 {5 ps} -r 10
# force -freeze sim:/mips_tb/rst 0 0, 1 {80 ps} -r 100
add wave -position insertpoint \ ../$target/*
run 1200
