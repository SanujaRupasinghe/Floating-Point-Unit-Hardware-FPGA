transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Floating-Point-Arithmatic-Unit-Hardware-FPGA {D:/Floating-Point-Arithmatic-Unit-Hardware-FPGA/multiply_24.v}
vlog -vlog01compat -work work +incdir+D:/Floating-Point-Arithmatic-Unit-Hardware-FPGA {D:/Floating-Point-Arithmatic-Unit-Hardware-FPGA/In_Buff.v}
vlog -vlog01compat -work work +incdir+D:/Floating-Point-Arithmatic-Unit-Hardware-FPGA {D:/Floating-Point-Arithmatic-Unit-Hardware-FPGA/negate.v}
vlog -sv -work work +incdir+D:/Floating-Point-Arithmatic-Unit-Hardware-FPGA {D:/Floating-Point-Arithmatic-Unit-Hardware-FPGA/fpu_sp_div.sv}
vlog -sv -work work +incdir+D:/Floating-Point-Arithmatic-Unit-Hardware-FPGA {D:/Floating-Point-Arithmatic-Unit-Hardware-FPGA/fpu_sp_add.sv}
vlog -sv -work work +incdir+D:/Floating-Point-Arithmatic-Unit-Hardware-FPGA {D:/Floating-Point-Arithmatic-Unit-Hardware-FPGA/fpu_sp_mul.sv}

vlog -sv -work work +incdir+D:/Floating-Point-Arithmatic-Unit-Hardware-FPGA {D:/Floating-Point-Arithmatic-Unit-Hardware-FPGA/In_Buff_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run -all
