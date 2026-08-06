# logic_op

一个用于学习 UVM 的最小单元级验证环境。

- **DUT**：`logic_op` —— 一个可配置的逻辑运算单元。通过 APB 寄存器 `logic_sel` 选择运算模式
  （`0`=AND / `1`=OR / `2`=XNOR / `3`=XOR），对 4-bit 输入 `in1/in2` 做运算后输出 `out`。
- **Testbench**：UVM 环境 —— APB agent（含 driver/monitor/sequencer + reg2apb adapter）+
  输入/输出 agent + 寄存器模型 + **DPI-C 参考模型** + scoreboard 自检。

本仓库支持两套仿真流程：

| 流程 | 工具 | 是否需要商业 VIP | 说明 |
|---|---|---|---|
| **Verilator**（推荐） | Verilator 5.x（开源） | 否 | UVM 用仓库自带的官方源码，纯开源工具链 |
| VCS（原始） | Synopsys VCS | 是（SVT APB VIP） | 需要 `/common/dw_vip` |

---

## 目录结构

```
logic_op/
├── design/logic_op/              # DUT RTL: logic_op.v, logic_op_reg_ctrl.v
├── dv/simulation/verif_env/ut/   # 验证环境（UVM TB）
│   ├── Makefile                  #   VCS 流程
│   ├── Makefile_verilator        #   Verilator 流程（见下）
│   ├── dut.f                     #   DUT 文件列表（仅 RTL）
│   ├── uvm.f                     #   UVM 库 + 测试台文件列表
│   ├── filelist_vlt.f            #   = dut.f + uvm.f 的薄封装（兼容用）
│   ├── common/uvc/               #   APB / op_in / op_out agent + 接口
│   ├── logic_op/                 #   env / reg_model / sequences / tests / tb_top
│   └── logic_op/env/reference_model/logic_op_dpi.cpp   # DPI-C 参考模型（C++）
├── uvm-verilator/                # 官方 UVM 源码（chipsalliance/uvm-verilator，1800.2-2020）
└── scripts/                      # vlt.sh / run_verilator.sh（Docker 封装，可选）
```

---

## 方式一：Verilator 仿真（开源，推荐）

UVM 库使用仓库内的 [`uvm-verilator/`](uvm-verilator)（**chipsalliance/uvm-verilator**，
Accellera UVM 1.2 / IEEE 1800.2-2020），由 Verilator 直接编译进去——**不依赖任何商业仿真器自带的 UVM**，
也不依赖 SVT APB VIP（环境里 svt_apb 相关 import/include 本就被注释掉）。

### 环境要求

满足以下任一即可：

- **本机已装**：`verilator`(≥5.x) + `g++`/`clang` + `make`（Linux / WSL / macOS）
- **或用 Docker**（无需本机装任何工具）：官方镜像 `verilator/verilator:latest`
  （内含 Verilator 5.050 + g++ + make + ccache）

### 快速开始

所有命令都在 `dv/simulation/verif_env/ut/` 目录下执行。

**本机有 verilator 时：**
```bash
cd dv/simulation/verif_env/ut
make -f Makefile_verilator            # 编译 DUT + UVM（verilate + build）
make -f Makefile_verilator run        # 编译并跑默认用例 logic_op_smoke_test
make -f Makefile_verilator run TEST=logic_op_xor_test   # 跑指定用例
make -f Makefile_verilator wave       # 跑并 dump 波形 tb.vcd
make -f Makefile_verilator lint       # 只做 SystemVerilog 级联检查（快）
make -f Makefile_verilator clean
```

**用 Docker 时**（在仓库根目录执行；已挂载 `.ccache` 加速重建）：
```bash
# 仓库根目录下
docker run --rm --entrypoint bash \
  -v "$PWD":/work -v "$PWD/.ccache":/root/.ccache \
  -w /work/dv/simulation/verif_env/ut \
  verilator/verilator:latest -c 'make -f Makefile_verilator run'
```

> 也可用仓库根目录的封装脚本 `scripts/vlt.sh run`（自动处理 Docker 调用、卷挂载、Git Bash 路径转换）。

### DUT 与 UVM 分开编译

文件列表已拆成两个，DUT 可独立编译：

| 目标 | 命令 | 作用 |
|---|---|---|
| `make dut` | `verilator --cc --top-module logic_op -f dut.f` | **单独**编译 DUT，生成模型库 `obj_dir_dut/Vlogic_op.h` + `libVlogic_op.a`（用于 DUT 独立 lint / IP 交付 / 配 C++ harness） |
| `make build`/`run` | `verilator --top-module logic_op_tb_top -f dut.f -f uvm.f` | DUT + UVM **一起** Verilate（完整仿真） |

> **为什么完整仿真必须把 DUT 和 UVM 一起 Verilate？**
> `logic_op_tb_top` 在 SystemVerilog 里直接例化了 DUT（`logic_op u_logic_op`），DUT 端口还
> 经 tb_top 的层次 `assign` 驱动。所以完整 UVM 仿真必须把 DUT 和 TB 放进同一个 Verilator
> elaboration。所谓「DUT 预编成库、TB 再单独链接」只适用于 **C++ 测试台**；纯 SV UVM 做不到。

### 已验证通过的用例

| 用例 | 寄存器配置 | 结果 |
|---|---|---|
| `logic_op_smoke_test` | 默认(AND) | **UVM TEST PASSED** |
| `logic_op_and_test` | sel=0 (AND) | **UVM TEST PASSED** |
| `logic_op_or_test` | sel=1 (OR) | **UVM TEST PASSED** |
| `logic_op_xor_test` | sel=3 (XOR) | **UVM TEST PASSED** |
| `logic_op_nxor_test` | sel=2 (XNOR) | **UVM TEST PASSED** |

均走 APB 寄存器前门配置 + 输入激励 + DPI 参考模型 + scoreboard 比对，
`UVM_ERROR : 0 / UVM_FATAL : 0`，`[CHECK_PASS]`。

### 产物

| 产物 | 路径 |
|---|---|
| 仿真可执行 | `dv/simulation/verif_env/ut/obj_dir/Vlogic_op_tb_top` |
| 构建日志 | `dv/simulation/verif_env/ut/logs/uvm_build.log` |
| 运行日志 | `dv/simulation/verif_env/ut/logs/uvm_run.log` |
| 波形 | `dv/simulation/verif_env/ut/tb.vcd`（GTKWave / Surfer 打开）|
| DUT 独立模型库 | `dv/simulation/verif_env/ut/obj_dir_dut/`（`make dut` 后）|

### Verilator 关键编译选项（见 `Makefile_verilator`）

```bash
verilator --binary -j 16 --vpi --trace-vcd --trace-depth 5 \
  --top-module logic_op_tb_top --timescale 1ns/1ps \
  -Wall -Wno-fatal \
  -DVL_RUN_TEST -DDEMO_MAKEFILE -DUVM_PACKER_MAX_BYTES=1500000 \
  -f dut.f -f uvm.f \
  logic_op/env/reference_model/logic_op_dpi.cpp \  # DUT 的 DPI 参考模型
  uvm-verilator/src/dpi/uvm_dpi.cc                 # UVM 自带 DPI/VPI 实现
```

- `--binary` 隐含 `--timing`（clocking 偏移、`#delay`、UVM 相位时间都需要）
- `--vpi`：UVM 的 DPI（`uvm_dpi.cc`）用到 `vpi_*`
- `-DVL_RUN_TEST`：让 `logic_op_tb_top` 调用 `run_test()`（替代被排除的 program block）

---

## 方式二：VCS 仿真（原始流程，需 SVT APB VIP）

> 前置：需要 SVT APB VIP，默认安装在 `/common/dw_vip`；若路径不同，改 `Makefile` 第 2~3 行。

```bash
cd dv/simulation/verif_env/ut
make            # 编译（vcs）+ 构建 DPI .so
./simv +UVM_TESTNAME=logic_op_smoke_test -sv_lib logic_op_dpi   # 运行
verdi -ssf *.fsdb &     # 看波形
make clean
```

---

## Verilator 适配说明（对源码的改动）

为让原 VCS 环境能在 Verilator 下跑通，对源码做了 **4 处最小改动**，全部带保护或不改变语义，
**不影响原 VCS 流程**：

1. **`logic_op/tb_top/logic_op_tb_top.sv`**：在 `` `ifdef VL_RUN_TEST `` 下新增 `initial run_test()`。
   Verilator 需单一 top，原 VCS 的 `logic_op_test`（program 块）不会被纳入 top 层次，故改由
   `logic_op_tb_top` 启动 UVM。`-DVL_RUN_TEST` 仅 Verilator 流程传入。
2. **`logic_op/env/reference_model/logic_op_dpi.cpp`**（新增）：原 `logic_op_dpi.c` 含 `extern "C"`
   （C++ 语法），Verilator 按扩展名分语言只能当 C++ 编，故提供同名 `.cpp`（内容一致）。
3. **`logic_op/env/logic_op_env.svh`**（connect_phase）：新增 `rgm.map.set_sequencer(apb_env.seqr, reg2apb)`。
   原 env 漏了给寄存器 map 绑定 bus sequencer，导致 `uvm_reg` 前门写非 0 值时报
   `sequence_item has null sequencer` 而 FATAL。标准写法，VCS 同样更正确。
4. **`logic_op/tests/uvm_test/logic_op_test_base.svh`**：`uvm_top = uvm_root::get()` 改为无条件赋值。
   chipsalliance UVM 定义 `UVM_VERSION=2020`，原 `if(UVM_VERSION==2016)` 不成立导致 `uvm_top` 为 null 而崩溃。

更详细的背景说明见 [`VERILATOR_UVM.md`](VERILATOR_UVM.md)。

---

## 目的

学习如何搭建一个单元级 UVM 测试台（agent / 寄存器模型 / 参考模型 / scoreboard），
以及如何用开源 Verilator + 官方 UVM 源码跑 UVM 验证。
