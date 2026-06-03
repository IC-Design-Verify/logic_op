export PROJ_HOME           := $(shell pwd | sed -e 's/^\(.*\)\/dv\>.*/\1/')
export DESIGNWARE_HOME     := /common/dw_vip_2025.03
export DESIGNWARE_VIP_HOME := /common/vip_2025.03
export LIGHT_ROOT          := $(shell pwd | sed -e 's/^\(.*ut\>\).*/\1/')


all: comp so run

so:
	gcc -Wall -m64 -g -fPIC -I${VCS_HOME}/include ${VCS_HOME}/include/svdpi.h -shared -o logic_op_dpi.so \
		./logic_op/env/reference_model/logic_op_dpi.c

comp:
	vcs -debug_access -full64 -sverilog -kdb \
		-l comp.log \
		-timescale=1ns/1ps \
		-ntb_opts uvm-1.2 +define+UVM_PACKER_MAX_BYTES=1500000 +define+DEMO_MAKEFILE \
		-f ./logic_op/filelist/tb.f -f ./logic_op/filelist/tc.f \
		-f ./logic_op/filelist/rtl.f \
		-top logic_op_tb_top -top logic_op_test

run:
	./simv -l simv.log +UVM_TESTNAME=logic_op_smoke_test -sv_lib logic_op_dpi

clean:
	rm -rf verdi* comp.log simv* vc_hdrs.h csrc out hierarchy.txt ucli* tr_db.log *xml *log *fsdb novas*

clean_all: clean
	rm -rf env filelist model  reg_model  sequences  tb_top  tests  uvc logic_op common
