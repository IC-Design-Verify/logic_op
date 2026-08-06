# 用 Verilator 跑 logic_op UVM 验证环境（基于官方 uvm-verilator 源码）

本目录的 UVM 验证环境已适配 **Verilator 5.050**，UVM 库使用仓库自带的
[`uvm-verilator/`](../uvm-verilator)（即 **chipsalliance/uvm-verilator**，
Accellera UVM 1.2 / IEEE 1800.2-2020，2020.3.1）源码，由 Verilator 直接编译进去
——而不是任何商业仿真器自带的 UVM。

原先的流程是 VCS（`-ntb_opts uvm-1.2` + SVT APB VIP）。Verilator 流程不依赖 VCS、
不依赖 SVT VIP（环境里 svt_apb 相关 import/include 本就被注释掉了），纯开源工具链。

## 环境要求

只需 **Docker**（无需本机装 verilator/gcc/make）：

- 镜像：`verilator/verilator:latest`（内含 Verilator 5.050 + g++ + make + ccache）
- 宿主机：Windows(Git Bash) / Linux / macOS 均可（脚本已处理 Git Bash 路径转换）

首次 `build` 会自动拉取镜像（约 1GB）。后续重建因挂载了 `.ccache`，约 **15 秒**完成。

## 快速开始

入口是 `dv/simulation/verif_env/ut/Makefile_verilator`（详见仓库根 [`README.md`](README.md)）。

在 **logic_op 仓库根目录** 执行（用 Docker 封装脚本，免装工具链）：

```bash
scripts/vlt.sh lint                  # 快速 SystemVerilog 级联检查（~7s）
scripts/vlt.sh build                 # verilate + 编译 -> obj_dir_vlt/Vlogic_op_tb_top
scripts/vlt.sh run                   # 跑默认 logic_op_smoke_test
scripts/vlt.sh run logic_op_and_test # 跑指定用例
scripts/vlt.sh wave logic_op_or_test # 跑并dump tb.vcd
scripts/vlt.sh clean
```

本机已装 verilator 时，也可直接在 `dv/simulation/verif_env/ut/` 下用 Makefile：
```bash
make -f Makefile_verilator run
make -f Makefile_verilator run TEST=logic_op_xor_test
make -f Makefile_verilator dut      # DUT 单独编译（详见 README “DUT 与 UVM 分开编译”）
```

实测结果（smoke / and / or / xor / nxor 各用例）：

```
**********UVM TEST PASSED*********
UVM_ERROR : 0   UVM_FATAL : 0
[CHECK_PASS] 1        <- scoreboard 实际输出 vs DPI 参考模型期望值 比对通过
$finish at 162ns
```

## 关键产物

| 产物 | 路径 | 说明 |
|---|---|---|
| 可执行 | `dv/simulation/verif_env/ut/obj_dir_vlt/Vlogic_op_tb_top` | Verilator 生成的仿真模型 |
| 构建日志 | `dv/simulation/verif_env/ut/logs/vlt_build.log` | verilator + g++ 全量日志 |
| 运行日志 | `dv/simulation/verif_env/ut/logs/vlt_run.log` | UVM 输出 |
| 波形 | `dv/simulation/verif_env/ut/tb.vcd` | GTKWave / Surfer 打开 |
| ccache | `.ccache/` | 跨次构建的 C++ 缓存（挂载进容器） |

## 与原 VCS 流程的关系（做了哪些适配）

对环境源码做了 **4 处最小改动**，全部带保护或不影响语义，**不影响原 VCS 流程**：

1. **`dv/simulation/verif_env/ut/logic_op/tb_top/logic_op_tb_top.sv`**
   在 `` `ifdef VL_RUN_TEST `` 下新增一个 `initial run_test()`。
   原因：VCS 用 `logic_op_test`（`program` 块）作第二个 top 来调 `run_test()`；
   Verilator 需要单一 top，program 块不会被纳入 top 层次，故改由 `logic_op_tb_top`
   启动 UVM。`-DVL_RUN_TEST` 由构建脚本传入，VCS 不定义此宏 → 行为不变。

2. **`dv/simulation/verif_env/ut/logic_op/env/reference_model/logic_op_dpi.cpp`**（新增）
   原 `logic_op_dpi.c` 用了 `extern "C"`（C++ 语法），只能当 C++ 编。
   Verilator 按扩展名分语言，故提供同名 `.cpp`（内容一致），供 Verilator 链接。

3. **`dv/simulation/verif_env/ut/logic_op/env/logic_op_env.svh`**（connect_phase）
   新增 `rgm.map.set_sequencer(apb_env.seqr, reg2apb);`。
   原因：env 从未给寄存器 map 绑定 bus sequencer，导致 `uvm_reg` 前门写/读拿不到
   bus sequencer，报 `sequence_item has null sequencer` 后 FATAL。写 0 的用例（and、
   smoke）因 update 判定无需下发总线而侥幸通过，写非 0 的用例（or/xor/nxor）必崩。
   这是标准写法，VCS 流程同样更正确（不构成 Verilator 专用 hack）。

4. **`dv/simulation/verif_env/ut/logic_op/tests/uvm_test/logic_op_test_base.svh`**
   把 `if(`UVM_VERSION == 2016) uvm_top = uvm_root::get();` 改成无条件赋值。
   原因：chipsalliance UVM 定义 `UVM_VERSION=2020`，原条件不成立导致 `uvm_top` 为
   null → 空指针崩溃。`uvm_root::get()` 在 UVM 1.2 / 1800.2 下均合法，VCS 不受影响。

## 新增的工程文件

- **`dv/simulation/verif_env/ut/Makefile_verilator`** — Verilator 主入口（build/run/wave/
  lint/dut/clean）。
- **`dv/simulation/verif_env/ut/dut.f`** — DUT 文件列表（仅 RTL）。
- **`dv/simulation/verif_env/ut/uvm.f`** — UVM 库 + 测试台文件列表（按 package 依赖顺序，
  含 UVM 源、接口、各 agent/env/seq/testcase package、tb_top；不含 program block）。
- **`dv/simulation/verif_env/ut/filelist_vlt.f`** — = `-f dut.f` + `-f uvm.f` 的薄封装（兼容）。
- **`scripts/run_verilator.sh`** — Docker 容器内执行的构建/运行脚本。
- **`scripts/vlt.sh`** — 宿主机封装：处理 docker 调用、卷挂载、ccache、Git Bash 路径。

## Verilator 关键选项（见 `Makefile_verilator`）

```
verilator --binary -j 16 --Mdir obj_dir \
  --top-module logic_op_tb_top --timescale 1ns/1ps \
  --vpi \                       # UVM DPI(uvm_dpi.cc) 用到 vpi_*
  --trace-vcd --trace-depth 5 \ # 波形（tb_top 内 $dumpfile/$dumpvars）
  -Wall -Wno-fatal \
  -DVL_RUN_TEST -DDEMO_MAKEFILE -DUVM_PACKER_MAX_BYTES=1500000 \
  -f dut.f -f uvm.f \
  logic_op/env/reference_model/logic_op_dpi.cpp \  # DUT 的 DPI 参考模型
  uvm-verilator/src/dpi/uvm_dpi.cc                 # UVM 自带 DPI 实现
```

`--binary` 已隐含 `--timing`（clocking 偏移、`#delay`、UVM 相位时间都需要）。

## 已验证可跑的用例

`logic_op_smoke_test` / `logic_op_and_test` / `logic_op_or_test` /
`logic_op_xor_test` / `logic_op_nxor_test` —— 均走 APB 寄存器前门配置运算模式 +
输入激励 + DPI 参考模型 + scoreboard 比对，`UVM TEST PASSED`。
