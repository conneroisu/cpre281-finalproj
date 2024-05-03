
set target "top_tb"
set file "${target}.v"
# remove the work directory
if { [file exists "work"] } {
	vdel -all
}

vlog *.v

vsim -voptargs=+acc $target
add wave -position insertpoint \ ../$target/*
run 1200
