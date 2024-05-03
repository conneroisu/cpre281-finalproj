
set target "top_tb"
set file "${target}.v"
# remove the work directory
if { [file exists "work"] } {
	vdel -all
}

vlog *.v

vsim -voptargs=+acc $target
force -freeze sim:/top_tb/clk 1 0, 0 {5 ps} -r 10
add wave -position insertpoint \ ../$target/*
run 1200
