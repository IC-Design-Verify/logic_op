#!/usr/bin/env bash
# Build/run the logic_op UVM environment with Verilator, using the official
# Accellera UVM source from uvm-verilator/ (chipsalliance/uvm-verilator).
#
# This script runs INSIDE the verilator/verilator docker container.
# PROJ_HOME must point at the logic_op repo root (mounted at /work).
#
#   docker run --rm --entrypoint bash -v <repo>:/work -w /work \
#       verilator/verilator:latest /work/scripts/run_verilator.sh <mode>
#
# modes: lint | build | run | wave | clean
set -uo pipefail

: "${PROJ_HOME:?PROJ_HOME must be set (repo root, e.g. /work)}"
UT="$PROJ_HOME/dv/simulation/verif_env/ut"
VLT=verilator
MODE="${1:-build}"

cd "$UT"
mkdir -p logs out

DPI_CPP="$UT/logic_op/env/reference_model/logic_op_dpi.cpp"
UVM_DPI_CC="$PROJ_HOME/uvm-verilator/src/dpi/uvm_dpi.cc"

# Flags shared by lint and build.
COMMON=(
  --Mdir obj_dir_vlt
  --top-module logic_op_tb_top
  --timescale 1ns/1ps
  -DVL_RUN_TEST -DDEMO_MAKEFILE -DUVM_PACKER_MAX_BYTES=1500000
  -Wall -Wno-fatal
  -f filelist_vlt.f
)

case "$MODE" in
  lint)
    echo "== Verilator lint-only (fast SV check) =="
    exec $VLT --lint-only "${COMMON[@]}"
    ;;
  build)
    echo "== Verilator: verilate + build (Accellera UVM, top=logic_op_tb_top) =="
    $VLT --binary -j 16 \
      --vpi \
      --trace-vcd --trace-depth 5 \
      "${COMMON[@]}" \
      "$DPI_CPP" "$UVM_DPI_CC" \
      2>&1 | tee logs/vlt_build.log
    echo
    echo "Executable: $UT/obj_dir_vlt/Vlogic_op_tb_top"
    echo "Run with:   $0 run"
    ;;
  run)
    EXE="$UT/obj_dir_vlt/Vlogic_op_tb_top"
    [ -x "$EXE" ] || { echo "ERROR: $EXE not built; run 'build' first"; exit 1; }
    echo "== Run simulation =="
    "$EXE" +UVM_TESTNAME="${TEST:-logic_op_smoke_test}" ${TRACE:++trace} \
      2>&1 | tee logs/vlt_run.log
    ;;
  wave)
    EXE="$UT/obj_dir_vlt/Vlogic_op_tb_top"
    [ -x "$EXE" ] || { echo "ERROR: $EXE not built; run 'build' first"; exit 1; }
    "$EXE" +UVM_TESTNAME="${TEST:-logic_op_smoke_test}" +trace 2>&1 | tee logs/vlt_run.log
    echo "Waveform: $UT/tb.vcd"
    ;;
  clean)
    rm -rf "$UT/obj_dir_vlt" "$UT/logs/vlt_build.log" "$UT/logs/vlt_run.log" "$UT/tb.vcd" "$UT/out"
    echo "cleaned"
    ;;
  *)
    echo "usage: $0 {lint|build|run|wave|clean}"; exit 1 ;;
esac
