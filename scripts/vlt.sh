#!/usr/bin/env bash
#
# Host-side wrapper: build & run the logic_op UVM env with Verilator, using the
# official Accellera UVM source from uvm-verilator/ (chipsalliance/uvm-verilator),
# inside the verilator/verilator docker image. No local toolchain required.
#
# Usage:
#   scripts/vlt.sh lint                 # fast SystemVerilog elaboration check
#   scripts/vlt.sh build                # verilate + compile -> obj_dir_vlt/Vlogic_op_tb_top
#   scripts/vlt.sh run                  # run default smoke test
#   scripts/vlt.sh run logic_op_and_test# run a specific test
#   scripts/vlt.sh wave logic_op_or_test# run and dump tb.vcd waveform
#   scripts/vlt.sh clean
#
# Env overrides:
#   TEST=logic_op_xor_test scripts/vlt.sh run
#   IMAGE=verilator/verilator:latest scripts/vlt.sh build
set -uo pipefail

# Resolve repo root (parent of this script's directory).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

IMAGE="${IMAGE:-verilator/verilator:latest}"
# Cache Verilator's generated C++ across runs for fast rebuilds.
CCACHE_HOST="$REPO_ROOT/.ccache"
mkdir -p "$CCACHE_HOST"

# Git Bash on Windows mangles "-v /work" style args; this disables that.
export MSYS_NO_PATHCONV=1
export MSYS2_ARG_CONV_EXCL="*"

MODE="${1:-build}"; shift || true
TEST_ARG=("$@")
[ "${#TEST_ARG[@]}" -gt 0 ] && [ -z "${TEST:-}" ] && export TEST="${TEST_ARG[0]}"

exec docker run --rm --entrypoint bash \
  -v "$REPO_ROOT:/work" \
  -v "$CCACHE_HOST:/root/.ccache" \
  -w /work -e PROJ_HOME=/work -e TEST="${TEST:-}" \
  "$IMAGE" /work/scripts/run_verilator.sh "$MODE"
