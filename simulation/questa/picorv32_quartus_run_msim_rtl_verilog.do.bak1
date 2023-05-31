transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/luis/Documents/PicoRV32_quartus/picorv32 {/home/luis/Documents/PicoRV32_quartus/picorv32/picorv32.v}

vlog -vlog01compat -work work +incdir+/home/luis/Documents/PicoRV32_quartus/picorv32 {/home/luis/Documents/PicoRV32_quartus/picorv32/testbench_ez.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

do mywave.do
view structure
view signals
run -all
