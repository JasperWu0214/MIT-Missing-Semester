# Missing Semester Lecture 4 — Cornell Notes

> **课程：** The Missing Semester of Your CS Education
>
> **Lecture 4：** Debugging and Profiling
>
> **主题：** Print Debugging、Logging、Debugger、GDB、Record-Replay、System Call Tracing、Memory Debugging、Profiling、Benchmarking
>
> **参考：** [2026 课程页面](https://missing-semester-cn.github.io/2026/debugging-profiling/)

---

## 1.
Debugging 的本质是什么？

程序有一个重要规律：

> **代码不会做你“想让它做”的事，只会做你“写出来让它做”的事。**

Debugging 的目标就是找到：

```text
Expected behavior
        ≠
Actual behavior
```

之间的原因。

---

## 2. Debugging 和 Profiling 有什么区别？

```text
Debugging
→ 为什么程序错了？

Profiling
→ 为什么程序慢 / 占资源？
```

例如：

```text
输出结果错误
→ Debugging

结果正确但运行 30 秒
→ Profiling
```

---

## 3.
最简单的 Debugging：Print

最直接的办法：

```python
print(x)
print("reached here")
```

不断缩小错误范围：

```text
哪里开始不对？
↓
打印状态
↓
缩小范围
↓
再打印
↓
找到 root cause
```

---

## 4. Print Debugging 什么时候最好用？

适合：

```text
你大概知道哪里有问题
代码容易修改
程序容易重新运行
只需要查看少量变量
```

优点：

```text
简单
快
所有语言都能用
```

---

## 5. Logging 和 Print 有什么区别？

Logging 可以理解成：

> **更正式、更可控的 print。**

它通常支持：

```text
时间戳
severity level
输出到文件
结构化数据
筛选
长期保留
```

---

## 6.
Log Level

常见：

```text
DEBUG
INFO
WARN
ERROR
```

可以理解为：

```text
DEBUG
→ 最详细的内部信息

INFO
→ 正常运行信息

WARN
→ 可疑但程序还能继续

ERROR
→ 已经发生错误
```

---

## 7. 为什么修完 bug 后可能要保留 Logging？

Print Debugging 常见流程：

```text
加 print
↓
找到 bug
↓
修复
↓
删掉 print
```

但如果这些信息未来还有诊断价值，可以改成：

```text
proper logging
```

以后同类问题再次出现时，不需要重新改代码。

---

## 8.
第三方程序怎么开详细日志？

很多 CLI 支持：

```bash
-v
```

或者：

```bash
--verbose
```

有些程序甚至支持：

```bash
-vvv
```

信息越来越详细。

---

## 9. Linux 服务日志

常见日志目录：

```text
/var/log/
```

systemd 服务可以：

```bash
journalctl -u <service>
```

例如：

```bash
journalctl -u nginx
```

---

## 10. Debugger 是什么？

Debugger 允许你：

```text
暂停程序
一行一行执行
查看变量
查看 call stack
设置 breakpoint
设置 conditional breakpoint
```

相比 print：

> **你不需要提前知道应该打印什么。**

---

## 11.
什么时候应该使用 Debugger？

尤其适合：

```text
不知道问题在哪
状态非常复杂
程序很难反复启动
bug 难以复现
需要查看 call stack
需要在特定条件暂停
```

---

## 12. Breakpoint

Breakpoint：

> **让程序运行到某个位置时暂停。**

例如：

```text
运行
↓
到 line 42
↓
暂停
↓
检查变量
```

这比：

```python
print(...)
```

更灵活。

---

## 13. Step Into / Step Over / Step Out

三者是 Debugger 最核心的概念之一。

```text
Step Into
→ 进入函数里面

Step Over
→ 执行整个函数，但不进去看

Step Out
→ 继续执行，直到当前函数返回
```

---

## 14.
Call Stack / Backtrace

如果：

```text
main()
  ↓
foo()
  ↓
bar()
  ↓
crash()
```

Call Stack 会显示：

```text
crash
bar
foo
main
```

它回答：

> **程序是怎么走到这里的？**

---

## 15. GDB 是什么？

GDB：

```text
GNU Debugger
```

常用于：

```text
C
C++
Rust
native binaries
```

它可以查看：

```text
variables
registers
stack
program counter
memory
```

---

## 16.
常用 GDB 命令

| Command | 作用 |
|---|---|
| `run` | 启动程序 |
| `b function` | 在函数处 breakpoint |
| `b file:line` | 在指定行 breakpoint |
| `c` | continue |
| `step` | step into |
| `next` | step over |
| `finish` | step out |
| `p var` | print variable |
| `bt` | backtrace |
| `watch expr` | 值变化时暂停 |

---

## 17.
Watchpoint

Breakpoint 通常看：

```text
程序执行到哪里
```

Watchpoint 看：

```text
某个值什么时候发生变化
```

例如：

```gdb
watch balance
```

只要 `balance` 被修改，就暂停。

非常适合：

```text
变量莫名其妙被改坏
```

---

## 18. GDB TUI

可以使用：

```bash
gdb -tui
```

或者 GDB 内：

```text
Ctrl-x a
```

获得：

```text
源码
+
debugger command
```

的分屏界面。

---

## 19.
什么是 Heisenbug？

Heisenbug：

> **你一观察它，它的行为就变了。**

常见原因：

```text
race condition
timing
线程调度
系统状态
```

例如：

```text
加一个 print
↓
程序变慢了一点
↓
race condition 不再发生
```

---

## 20. Record-Replay Debugging

Record-Replay 的思想：

```text
第一次运行
↓
记录完整执行
↓
以后重复播放同一次执行
```

这样：

```text
每次 replay
→ 状态完全一样
```

特别适合难复现 bug。

---

## 21.

rr

Linux 上重要工具：

```bash
rr
```

录制：

```bash
rr record ./my_program
```

回放：

```bash
rr replay
```

回放会进入 GDB 风格的调试环境。

---

## 22. Reverse Debugging

普通 Debugger：

```text
只能往前
```

rr 允许：

```text
往后执行
```

例如：

```text
reverse-continue
reverse-step
reverse-next
reverse-finish
```

可以理解为：

> **给程序执行加“倒带”。**

---

## 23.
rr 查内存损坏的经典方法

如果某个变量最后变坏：

```text
先运行到出错
↓
看到坏值
↓
watch 这个变量
↓
reverse-continue
↓
找到最后一次修改它的代码
```

这比从头猜问题位置强很多。

---

## 24. rr 的局限

主要：

```text
只适用于 Linux
需要硬件 performance counters
某些 VM 不支持
不支持 GPU
```

并发程序也有特殊限制，因为 rr 需要确定性地记录调度。

---

## 25. System Call 是什么？

应用程序不能直接随便控制硬件和操作系统资源。

它通过：

```text
system call
```

请求 kernel 做事情。

例如：

```text
open file
read
write
allocate memory
create process
network
```

---

## 26.
为什么追踪 System Call 有用？

如果程序：

```text
卡住
找不到文件
权限错误
启动很慢
莫名访问网络
```

可以看看：

> **它实际在向操作系统请求什么。**

---

## 27. strace

Linux：

```bash
strace ./my_program
```

可以看到程序发出的 system calls。

---

## 28.
常用 strace

全部：

```bash
strace ./my_program
```

文件相关：

```bash
strace -e trace=file ./my_program
```

跟踪 child processes：

```bash
strace -f ./my_program
```

附加到已有进程：

```bash
strace -p <PID>
```

显示耗时：

```bash
strace -T ./my_program
```

---

## 29. macOS 对应什么？

macOS / BSD 可以使用：

```text
dtruss
```

它基于：

```text
DTrace
```

---

## 30.
eBPF 是什么？

eBPF 允许：

> **在 Linux kernel 中运行受限制的小程序，用来观察系统行为。**

用途：

```text
系统调用
网络
磁盘
性能
kernel functions
latency
```

---

## 31. bpftrace

`bpftrace` 给 eBPF 提供更高层的脚本语法。

适合：

```text
统计调用次数
统计 latency
聚合事件
低开销系统观测
```

---

## 32. strace vs bpftrace

```text
strace
→ 简单、直接、快速开始

bpftrace
→ 更低 overhead
→ 更适合 aggregation
→ 能深入 kernel
```

---

## 33. Network Debugging

常见工具：

```text
tcpdump
Wireshark
Browser DevTools
mitmproxy
```

---

## 34.
tcpdump

抓 HTTP port 80：

```bash
sudo tcpdump -i any port 80
```

保存：

```bash
sudo tcpdump -i any -w capture.pcap
```

然后用：

```text
Wireshark
```

分析。

---

## 35. HTTPS 为什么更难抓？

HTTPS 内容被加密。

所以 tcpdump 通常能看到：

```text
连接
IP
端口
packet timing
```

但不能直接看到明文 HTTP 内容。

Web 开发中更常用：

```text
Browser DevTools → Network
```

因为浏览器已经解密了请求。

---

## 36.
Memory Bug

常见：

```text
buffer overflow
use-after-free
memory leak
uninitialized memory
data race
undefined behavior
```

这些 bug 很危险，因为：

```text
错误发生的位置
≠
程序真正 crash 的位置
```

---

## 37. AddressSanitizer

ASan：

```text
AddressSanitizer
```

用于发现：

```text
buffer overflow
use-after-free
use-after-return
memory leak
```

编译：

```bash
gcc -fsanitize=address -g program.c -o program
```

运行：

```bash
./program
```

---

## 38.
Sanitizer 为什么强大？

它通过编译器在程序里插入额外检测代码。

效果：

```text
普通运行
→ 可能“看起来没问题”

Sanitizer
→ 在错误发生位置直接报告
```

---

## 39. 其他 Sanitizer

```text
TSan
→ ThreadSanitizer
→ data race

MSan
→ MemorySanitizer
→ uninitialized memory

UBSan
→ UndefinedBehaviorSanitizer
→ undefined behavior
```

---

## 40. Valgrind

Valgrind 可以在受控执行环境中运行程序。

例如：

```bash
valgrind --leak-check=full ./my_program
```

特点：

```text
不一定需要重新编译
比 sanitizer 慢
```

---

## 41.
Sanitizer vs Valgrind

```text
Sanitizer
→ 需要重新编译
→ 通常更快
→ 日常开发 / CI 很适合

Valgrind
→ 可以处理不能重新编译的程序
→ 更慢
→ 某些场景工具更丰富
```

---

## 42. AI 可以怎么帮助 Debug？

LLM 比较擅长：

```text
解释复杂错误信息
解释 stack trace
跨语言定位问题
提出可能 root cause
分析 sanitizer 输出
解释 strace
```

---

## 43. AI Debugging 的风险

LLM 可能：

```text
hallucinate
给出听起来合理但错误的解释
只掩盖 symptom
没有修 root cause
```

所以：

```text
AI hypothesis
↓
真实工具验证
```

---

## 44.
Debug Symbols

Native program 调试时建议编译：

```bash
-g
```

这样 binary 会包含 debug symbols。

没有 debug symbols 时：

```text
stack trace
→ 可能只有 address
```

有：

```text
function name
file
line number
```

---

## 45. Profiling 是什么？

Profiling 回答：

```text
程序的时间花在哪里？
CPU 被谁占用？
内存是谁分配的？
I/O 卡在哪里？
```

核心原则：

> **不要凭感觉优化，要先测。**

---

## 46.
为什么不要 Premature Optimization？

因为你猜的瓶颈可能不是实际瓶颈。

错误流程：

```text
我觉得函数 A 慢
↓
花 3 小时优化
↓
整体只快 1%
```

正确：

```text
profile
↓
找到 hotspot
↓
优化
↓
再次 profile
```

---

## 47. `time`

最简单的 performance measurement：

```bash
time command
```

输出：

```text
real
user
sys
```

---

## 48. Real / User / Sys

```text
Real
→ 从开始到结束真实经过的时间

User
→ CPU 执行用户代码的时间

Sys
→ CPU 执行 kernel code 的时间
```

---

## 49.
为什么 Real 可能远大于 User + Sys？

例如：

```bash
curl website
```

大部分时间可能在：

```text
等待网络
```

CPU 实际没有一直工作。

所以：

```text
real = 300ms
user + sys = 100ms
```

说明大约 200ms 是等待。

---

## 50. Resource Monitoring

程序慢时首先问：

```text
CPU 满了吗？
Memory 不够吗？
Disk I/O 卡住了吗？
Network 卡住了吗？
```

---

## 51.
htop / btop

```text
htop
```

查看：

```text
CPU
memory
process
threads
```

常用：

```text
F6 → sort
t  → process tree
h  → toggle threads
```

`btop` 提供更丰富的系统可视化。

---

## 52. I/O Monitoring

```text
iotop
```

查看：

```text
哪些 process 正在大量读写磁盘
```

---

## 53. Memory Monitoring

```text
free
```

查看：

```text
total memory
used memory
free memory
```

---

## 54.
Open Files

```text
lsof
```

= list open files。

可以回答：

```text
哪个进程打开了这个文件？
哪个进程占用了这个资源？
```

---

## 55. Network Connection

```text
ss
```

例如查 8080 端口：

```bash
ss -tlnp | grep :8080
```

回答：

> **哪个进程在监听 8080？**

---

## 56. Network Usage

```text
nethogs
iftop
```

查看：

```text
哪些程序正在使用网络
用了多少 bandwidth
```

---

## 57. 为什么要把 Performance Data 可视化？

人更容易从图形里发现：

```text
趋势
周期
spike
异常值
模式
```

而不是从一大串数字中。

---

## 58.
Log 最好怎样设计方便画图？

不要：

```text
The latency is currently about 42.5 milliseconds at time ...
```

更适合：

```csv
1705012345,42.5
```

或者：

```json
{"timestamp":1705012345,"latency":42.5}
```

这种叫：

> **structured / tidy data**

---

## 59. gnuplot

命令行快速画图：

```bash
gnuplot -e "set datafile separator ','; plot 'latency.csv' using 1:2 with lines"
```

适合快速检查数据趋势。

---

## 60.
matplotlib / ggplot2

需要更复杂分析：

```text
Python → matplotlib
R      → ggplot2
```

适合：

```text
过滤
变换
分组
多次探索
```

---

## 61. CPU Profiler 两大类型

```text
Tracing Profiler
Sampling Profiler
```

---

## 62. Tracing Profiler

Tracing：

> **记录每一次 function call。**

优点：

```text
非常详细
精确 call count
```

缺点：

```text
overhead 较高
```

---

## 63.
Sampling Profiler

Sampling：

```text
每隔一小段时间
↓
看程序现在在哪个函数
↓
记录 stack
```

统计很多样本后：

```text
某函数出现越多
≈
花的时间越多
```

优点：

```text
overhead 较低
```

通常更适合 production profiling。

---

## 64. perf

Linux 标准 profiler：

```text
perf
```

快速概览：

```bash
perf stat ./program
```

可以看到：

```text
cycles
instructions
context switches
page faults
branch misses
```

---

## 65.
perf record

采样 profile：

```bash
perf record -g ./my_program
```

其中：

```text
-g
→ 记录 call graph
```

之后可以分析 stack。

---

## 66. Flame Graph

Flame Graph 用于可视化 profile。

基本理解：

```text
Y axis
→ call stack 层级

X axis
→ 占用时间比例
```

最重要：

> **越宽通常说明占用 CPU 时间越多。**

---

## 67. Flame Graph 怎么找瓶颈？

找：

```text
很宽的 block
```

尤其关注：

```text
宽
+
位于 stack 上层
```

这些通常是值得进一步调查的 hotspot。

---

## 68.
Callgrind

Valgrind 的：

```text
callgrind
```

属于 tracing profiler。

运行：

```bash
valgrind --tool=callgrind ./my_program
```

分析：

```bash
callgrind_annotate callgrind.out.<pid>
```

也可以用：

```text
kcachegrind
```

图形查看。

---

## 69. Sampling vs Callgrind

```text
Sampling
→ overhead 低
→ 近似统计
→ 更适合真实 workload

Callgrind
→ overhead 高
→ call count 更精确
→ 适合深入分析
```

---

## 70.
语言专用 Profiler

```text
Python
→ cProfile
→ py-spy

Go
→ go tool pprof

Rust
→ cargo-flamegraph
```

很多时候专用工具的体验更好。

---

## 71. Memory Profiling

Memory Profiler 回答：

```text
内存什么时候增长？
谁在分配？
有没有 leak？
哪些对象占用最多？
```

---

## 72. Massif

Valgrind 的 memory profiler：

```bash
valgrind --tool=massif ./my_program
```

查看：

```bash
ms_print massif.out.<pid>
```

主要追踪：

```text
heap usage over time
```

---

## 73.

Benchmarking

Profiling：

```text
为什么慢？
```

Benchmarking：

```text
A 和 B 到底谁更快？
快多少？
结果稳定吗？
```

---

## 74. 为什么不能只运行一次看速度？

一次运行会受到：

```text
cache
background processes
CPU frequency
disk state
network
warmup
```

影响。

Benchmark 应该：

```text
多次运行
统计平均值
看波动
必要时 warmup
```

---

## 75.
hyperfine

适合 benchmark CLI：

```bash
hyperfine 'command A' 'command B'
```

加 warmup：

```bash
hyperfine --warmup 3 'command A' 'command B'
```

它会自动多次运行并给：

```text
mean
standard deviation
range
relative speed
```

---

## 76. 一个完整 Debugging Workflow

```text
发现 symptom
↓
能否稳定复现？
↓
缩小范围
↓
先读 error / logs
↓
print / logging
↓
debugger
↓
system tracing / sanitizer
↓
形成 hypothesis
↓
验证 root cause
↓
修复
↓
增加 test
```

---

## 77.
一个完整 Profiling Workflow

```text
程序慢
↓
先测 real / user / sys
↓
看 CPU / memory / I/O / network
↓
确定 resource bottleneck
↓
使用 profiler
↓
找到 hotspot
↓
优化
↓
benchmark
↓
再次 profile
```

---

# 第四讲知识地图

```text
                    Debugging & Profiling
                             │
              ┌──────────────┴──────────────┐
              ↓                             ↓
          Debugging                      Profiling
              │                             │
    ┌─────────┼─────────┐        ┌──────────┼──────────┐
    ↓         ↓         ↓        ↓          ↓          ↓
 Print     Debugger   System    Timing    Resource     CPU
Logging      │        Tracing     │       Monitor    Profiler
    │        │          │         │          │          │
 Levels     GDB       strace     time      htop     Sampling
 Verbose     │        dtruss   real/user   iotop     Tracing
          Breakpoint    │        /sys       lsof        │
          Watchpoint   eBPF                 ss         perf
          Backtrace     │                              │
              │       Network                       Flame Graph
              │       tcpdump                         │
              │       Wireshark                   Callgrind
              │
        Record-Replay
              │
              rr
              │
        Reverse Debugging
              │
        Memory Debugging
              │
      ┌───────┼────────┐
      ↓       ↓        ↓
     ASan    TSan   Valgrind
      │
   Memory Errors

                             │
                             ↓
                         Benchmarking
                             │
                          hyperfine
```

---

# Cornell Bottom Summary

第四讲可以压缩成两个问题：

```text
Debugging
→ 为什么程序行为不正确？

Profiling
→ 为什么程序使用了太多时间或资源？
```

Debugging 的工具从简单到复杂可以理解成：

```text
print
↓
logging
↓
debugger
↓
record-replay
↓
system call tracing
↓
memory tools
```

Debugger 的核心能力是：

```text
Breakpoint
Step
Inspect
Backtrace
Watchpoint
```

而面对更底层的问题：

```text
strace / dtruss
→ 看程序和 OS 怎么交互

ASan / TSan / UBSan
→ 查内存、线程和 undefined behavior

rr
→ 记录并倒放程序执行
```

Profiling 的关键不是“让代码更快”，而是：

> **先找真正的 bottleneck，再优化。**

完整思路：

```text
measure
↓
identify resource
↓
profile
↓
find hotspot
↓
optimize
↓
benchmark
↓
measure again
```

最重要的原则：

> **不要猜哪里慢，也不要猜哪里错；尽量让工具给你证据。**

---

# 第四讲 15 个核心自测题 + 答案

## 1.
Debugging 和 Profiling 有什么区别？

```text
Debugging
→ 找功能错误

Profiling
→ 找性能瓶颈
```

---

## 2. Logging 相比 print 的优势是什么？

Logging 通常支持：

```text
level
timestamp
filtering
不同输出位置
structured data
```

适合长期保留。

---

## 3. Debugger 什么时候比 print 更适合？

当：

```text
不知道该打印什么
状态复杂
bug 难复现
重新运行代价高
```

时。

---

## 4. Step Into、Step Over、Step Out 分别是什么？

```text
Into → 进入函数
Over → 执行函数但不进去
Out  → 执行到当前函数返回
```

---

## 5.
Backtrace 是什么？

显示当前 call stack，也就是程序如何调用到当前位置。

---

## 6. Breakpoint 和 Watchpoint 有什么区别？

```text
Breakpoint
→ 到某个代码位置暂停

Watchpoint
→ 某个变量 / 表达式发生变化时暂停
```

---

## 7. rr 解决什么问题？

它记录一次程序执行，然后允许确定性 replay，甚至 reverse debugging。

特别适合难复现 bug。

---

## 8. strace 是做什么的？

显示 Linux 程序发出的 system calls。

可以用于分析：

```text
文件访问
权限
hang
process
等待
```

---

## 9. ASan 可以检查什么？

典型：

```text
buffer overflow
use-after-free
memory leak
```

---

## 10.
Sanitizer 和 Valgrind 的主要区别是什么？

```text
Sanitizer
→ 编译时 instrumentation
→ 通常更快
→ 需要重新编译

Valgrind
→ 受控执行
→ 更慢
→ 某些情况下不用重编译
```

---

## 11. `time` 中 real、user、sys 是什么？

```text
real → 墙钟时间
user → CPU 跑用户代码时间
sys  → CPU 跑 kernel 时间
```

---

## 12. Sampling Profiler 和 Tracing Profiler 有什么区别？

```text
Sampling
→ 定期采样 stack
→ overhead 较低

Tracing
→ 记录每次 function call
→ 更详细但 overhead 更高
```

---

## 13.
Flame Graph 中“宽”通常代表什么？

某个函数 / stack 在采样中占比大，也就是通常花了更多 CPU 时间。

---

## 14. Profiling 和 Benchmarking 有什么区别？

```text
Profiling
→ 时间花在哪里？

Benchmarking
→ 两种实现性能差多少？
```

---

## 15.
最正确的性能优化顺序是什么？

```text
measure
↓
profile
↓
find hotspot
↓
optimize
↓
benchmark
↓
measure again
```

不是凭感觉直接优化。

---

# 一页速记

| 概念 | 一句话 |
|---|---|
| Debugging | 找程序为什么错 |
| Profiling | 找程序为什么慢 / 占资源 |
| Print Debugging | 用输出观察程序状态 |
| Logging | 可分级、可筛选、可长期保留的输出 |
| `-v` / `--verbose` | 查看第三方程序更多日志 |
| Debugger | 交互控制程序执行 |
| Breakpoint | 到指定位置暂停 |
| Step Into | 进入函数 |
| Step Over | 不进入函数 |
| Step Out | 执行到当前函数返回 |
| Backtrace | 当前 call stack |
| Watchpoint | 值变化时暂停 |
| GDB | GNU Debugger |
| rr | Record-Replay Debugger |
| Reverse Debugging | 倒着执行程序 |
| System Call | 程序向 kernel 请求服务 |
| strace | Linux system call tracer |
| dtruss | macOS/BSD tracing tool |
| eBPF | Linux kernel 可观测技术 |
| bpftrace | eBPF 高层 tracing 工具 |
| tcpdump | 抓网络 packets |
| Wireshark | 图形化网络分析 |
| ASan | AddressSanitizer |
| TSan | ThreadSanitizer |
| MSan | MemorySanitizer |
| UBSan | UndefinedBehaviorSanitizer |
| Valgrind | 动态分析执行环境 |
| `-g` | 编译 debug symbols |
| `time` | 测 real/user/sys |
| htop | process / CPU / memory monitor |
| iotop | I/O monitor |
| lsof | 查看 open files |
| ss | 查看 network connections |
| Sampling Profiler | 定期采样调用栈 |
| Tracing Profiler | 记录函数调用 |
| perf | Linux profiler |
| Flame Graph | 可视化 CPU profile |
| Callgrind | Valgrind tracing profiler |
| Massif | Valgrind memory profiler |
| hyperfine | CLI benchmark 工具 |
