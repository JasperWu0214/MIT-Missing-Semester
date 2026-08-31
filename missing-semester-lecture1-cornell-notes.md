# Missing Semester Lecture 1 — Cornell Notes

> 课程：The Missing Semester of Your CS Education  
> Lecture 1：Course Overview + Shell 入门

---

## 1. Shell 到底是什么？

| Cue / 自测问题 | Notes |
|---|---|
| Shell 是什么？ | **文本形式控制计算机的接口**。你输入命令，Shell 解析命令、找到程序并运行它。 |
| Terminal 和 Shell 是一回事吗？ | **不是。** Terminal 是你看到的窗口/界面；Shell 是运行在里面、解释命令的程序。 |
| 常见 Shell？ | `bash`、`zsh`、`fish`。macOS 现在默认通常是 `zsh`。 |
| 为什么学 Shell？ | 可以组合程序、自动化重复任务、管理文件、远程操作服务器、调试程序等。 |
| Shell 最重要的思想？ | **把许多简单程序组合起来完成复杂任务。** |

```text
Terminal
   ↓
 Shell
   ↓
解析你的命令
   ↓
运行 Program
   ↓
显示结果
```

---

## 2. Prompt 是什么？

你可能看到：

```bash
jasper@MacBook ~ %
```

或者：

```bash
missing:~$
```

它不是命令，而是 Shell 的提示符。

例如：

```text
missing     → 机器名
~           → 当前目录
$           → 普通用户
```

后面才是你输入命令的地方。

例如：

```bash
date
```

运行 `date` 程序。

---

## 3. Command = Program + Arguments

例如：

```bash
echo hello
```

Shell 会理解成：

```text
Program:
echo

Arguments:
hello
```

再例如：

```bash
ls -l /Users/jasper
```

可以理解成：

```text
program = ls

arguments:
1. -l
2. /Users/jasper
```

Shell 通常通过**空格**拆分命令。

---

## 4. 参数中有空格怎么办？

假设文件夹叫：

```text
My Photos
```

如果写：

```bash
cd My Photos
```

Shell 会认为：

```text
argument 1 = My
argument 2 = Photos
```

所以要写：

```bash
cd "My Photos"
```

或者：

```bash
cd My\ Photos
```

`\` 可以理解成：让后面的特殊字符按普通字符处理。

---

## 5. 不知道一个命令怎么用怎么办？

### `man`

```bash
man ls
```

`man` = manual。

退出：

```text
q
```

搜索：

```text
/
```

### `--help`

很多程序支持：

```bash
ls --help
```

### `tldr`

```bash
tldr ls
```

可以记成：

```text
tldr → 我只想知道怎么用
man  → 我要知道完整细节
```

---

## 6. 文件系统

Unix/macOS 文件系统可以理解成一棵树：

```text
/
├── bin
├── usr
├── home
├── tmp
└── Users
    └── jasper
        ├── Desktop
        ├── Documents
        └── Downloads
```

最顶层：

```text
/
```

叫：

> root directory

---

## 7. `pwd`

```bash
pwd
```

= **print working directory**

作用：

> 告诉你现在在哪。

例如：

```bash
pwd
```

输出：

```text
/Users/jasper/Desktop
```

---

## 8. `cd`

```bash
cd
```

= **change directory**

例如：

```bash
cd /Users/jasper/Desktop
```

### 为什么 `cd` 必须是 Shell builtin？

因为 `cd` 要改变的是 **Shell 自己的当前目录**。

如果 `cd` 是普通程序：

```text
Shell
 ↓
启动 cd 程序
 ↓
cd 程序改变自己的目录
 ↓
cd 程序退出
```

Shell 自己的位置不会变。

---

## 9. Absolute Path vs Relative Path

### Absolute Path

从 `/` 开始。

```bash
/Users/jasper/Desktop/academic
```

不管当前在哪，都指向同一个位置。

### Relative Path

相对于当前工作目录。

假设当前：

```text
/Users/jasper/Desktop
```

运行：

```bash
cd academic
```

等价于进入：

```text
/Users/jasper/Desktop/academic
```

---

## 10. `.`, `..`, `~`

| 符号 | 意思 |
|---|---|
| `.` | 当前目录 |
| `..` | 上一级目录 |
| `~` | 当前用户的 home directory |

例如：

```bash
cd ..
```

去上一级。

```bash
cd ~
```

回 home。

```bash
./file.txt
```

表示当前目录里的 `file.txt`。

---

## 11. `ls`

```bash
ls
```

列出当前目录内容。

例如：

```bash
ls /
ls ~/Desktop
```

---

## 12. `ls -l`

```bash
ls -l
```

使用 long listing format。

例如：

```text
-rw-r--r--  1 jasper staff 1024 Aug 31 notes.txt
```

前 10 个字符：

```text
- | rw- | r-- | r--
↑    ↑     ↑     ↑
type user group others
```

第一位：

```text
- = 普通文件
d = directory
```

---

## 13. `r w x`

```text
r = read
w = write
x = execute
```

例如：

```text
rwxr-xr--
```

表示：

```text
user:   rwx
group:  r-x
others: r--
```

---

## 14. `chmod +x`

```bash
chmod +x script.sh
```

给文件增加 execute permission。

之后可以：

```bash
./script.sh
```

---

## 15. 为什么经常写 `./program`？

因为当前目录 `.` 通常不在 `$PATH` 中。

假设当前目录有：

```text
hello
```

直接输入：

```bash
hello
```

Shell 会去 `$PATH` 中找。

而：

```bash
./hello
```

明确表示：

> 执行当前目录里的 `hello`。

---

## 16. `$PATH`

```bash
echo $PATH
```

可能输出：

```text
/usr/local/bin:/usr/bin:/bin
```

`$PATH` 是：

> **Shell 搜索可执行程序时要检查的文件夹列表。**

当你输入：

```bash
git
```

Shell 会依次查：

```text
/usr/local/bin/git
/usr/bin/git
/bin/git
```

找到第一个可执行的就运行。

注意：

> `$PATH` 不是 executable 文件列表，而是搜索目录列表。

---

## 17. `which`

```bash
which python
which ls
```

用来查看某个命令实际执行的是哪个文件。

---

## 18. 常见文本命令

| Command | 用途 |
|---|---|
| `cat` | 输出文件内容 |
| `head` | 看前几行 |
| `tail` | 看后几行 |
| `sort` | 排序 |
| `uniq` | 去掉连续重复行 |
| `grep` | 搜索匹配行 |
| `sed` | 文本修改/替换 |
| `find` | 找文件 |
| `awk` | 按列或结构处理文本 |

---

## 19. `cat`

```bash
cat file.txt
```

输出整个文件内容。

---

## 20. `head` / `tail`

```bash
head file.txt
tail file.txt
```

例如：

```bash
tail -n 20 log.txt
```

查看最后 20 行。

---

## 21. `sort`

```bash
sort fruits.txt
```

对文本行排序。

---

## 22. `uniq`

`uniq` 只去除**连续重复行**。

所以常见：

```bash
sort file.txt | uniq
```

先排序，再去重。

---

## 23. `grep`

```bash
grep hello notes.txt
```

找出包含 `hello` 的行。

递归：

```bash
grep -r TODO .
```

表示从当前目录递归搜索 `TODO`。

---

## 24. `find`

例如：

```bash
find ~/Downloads -type f -name "*.zip" -mtime +30
```

拆开：

```text
~/Downloads → 去哪里找
-type f      → 只找普通文件
-name "*.zip"→ 文件名匹配
-mtime +30   → 超过 30 天
```

---

## 25. Glob

### `*`

匹配 0 个或多个任意字符。

```bash
ls *.txt
```

### `?`

匹配恰好一个字符。

```bash
ls file?.txt
```

### `{}`

直接展开成多个字符串。

```bash
ls {a,b,c}.txt
```

展开成：

```text
a.txt
b.txt
c.txt
```

---

## 26. 谁展开 `*.txt`？

通常是 **Shell**。

```bash
ls *.txt
```

大致过程：

```text
Shell 看到 *.txt
↓
展开成 a.txt notes.txt hello.txt
↓
真正执行：
ls a.txt notes.txt hello.txt
```

---

## 27. Pipe `|`

```bash
A | B
```

连接的是：

```text
A 的 stdout
      ↓
B 的 stdin
```

例如：

```bash
cat file.txt | grep hello
```

可以理解为：

```text
file.txt
   ↓
 cat
   │ stdout
   ↓
 grep
```

---

## 28. Unix Philosophy

核心思想：

```text
一个程序
做好一件简单的事
      +
程序之间用文本连接
      +
通过 pipe 组合
```

例如：

```bash
sort file.txt | uniq -c | sort -n
```

---

## 29. stdin / stdout

基本模型：

```text
             ┌────────────┐
stdin ─────→ │  Program   │ ─────→ stdout
             └────────────┘
```

默认：

```text
stdin  ← keyboard
stdout → terminal
```

Pipe：

```bash
A | B
```

表示：

```text
A stdout
↓
B stdin
```

---

## 30. `>`

```bash
echo hello > hello.txt
```

把 stdout 写入文件，并**覆盖**原内容。

---

## 31. `>>`

```bash
echo hello >> log.txt
```

把 stdout **追加**到文件末尾。

---

## 32. `<`

```bash
command < file.txt
```

把文件内容作为程序的 stdin。

---

## 33. `tee`

```bash
command | tee output.log | grep ERROR
```

可以：

```text
command
   ↓
 tee ─────→ output.log
   │
   ↓
 grep ERROR
```

既保存完整输出，又继续 pipe。

---

## 34. Shell 也是编程语言

Bash 支持：

```text
variables
if
while
for
functions
```

---

## 35. Variables

```bash
name=jasper
```

读取：

```bash
echo "$name"
```

注意不要写：

```bash
name = jasper
```

因为空格会被 Shell 用来拆分参数。

---

## 36. `$()` — Command Substitution

```bash
today=$(date)
```

发生：

```text
执行 date
↓
取得 stdout
↓
替换 $(date)
↓
保存进 today
```

例如：

```bash
cp notes.txt "notes_$(date +%Y-%m-%d).txt"
```

---

## 37. `if`

基本结构：

```bash
if command; then
    something
fi
```

Shell 判断的通常是：

> command 是否成功执行。

---

## 38. `test` / `[ ]`

```bash
test -f file.txt
```

常写成：

```bash
[ -f file.txt ]
```

例如：

```bash
if [ -f file.txt ]; then
    echo "exists"
fi
```

---

## 39. `for`

```bash
for x in a b c; do
    echo "$x"
done
```

---

## 40. `while`

```bash
while command; do
    something
done
```

意思：

> 只要 `command` 一直成功，就继续循环。

---

## 41. Shell Script

创建：

```text
script.sh
```

例如：

```bash
#!/bin/bash

echo "hello"
date
```

然后：

```bash
chmod +x script.sh
./script.sh
```

---

## 42. Shebang `#!`

```bash
#!/bin/bash
```

叫 shebang。

作用：

> 告诉系统这个脚本应该交给 `/bin/bash` 解释执行。

---

## 43. `set -euo pipefail`

```bash
set -euo pipefail
```

| option | 意思 |
|---|---|
| `-e` | 某条命令失败时尽快停止脚本 |
| `-u` | 使用未定义变量时报错 |
| `-o pipefail` | pipe 中任意一步失败时，整个 pipeline 视为失败 |

作用：

> 不要让错误静悄悄地发生。

---

## 44. `set -x`

```bash
set -x
```

用于 debug Shell script。

Shell 会显示它实际执行的命令。

可以记：

```text
-x = execution trace
```

---

# 第一讲知识地图

```text
                  Shell
                    │
        ┌───────────┴───────────┐
        ↓                       ↓
    File System             Programs
        │                       │
 pwd / cd / ls                 PATH
        │                       │
        ↓                       ↓
absolute / relative        which / executable
    │   │   │
    .   ..  ~


                  Data
                   │
       ┌───────────┴────────────┐
       ↓                        ↓
    Text tools                Streams
       │                        │
cat / grep / find        stdin / stdout
sort / uniq / sed             │
awk / head / tail             ↓
                         |  >  >>  <


                  Bash
                   │
       ┌───────────┼───────────┐
       ↓           ↓           ↓
    variables    control     scripts
                  flow
                  │
               if / for
                while
```

---

# Cornell Bottom Summary

Shell 是一个文本化的计算机控制环境。Shell 将输入解析成程序和参数，并通过 `$PATH` 查找可执行程序。文件系统围绕当前工作目录运行，因此必须理解绝对路径、相对路径以及 `.`, `..`, `~`。

`ls`、`cat`、`grep`、`find`、`sort`、`uniq`、`sed` 和 `awk` 等 Unix 工具通常只完成一个简单任务，而 Shell 使用 `|` 把程序的 stdout 连接到另一个程序的 stdin，并利用 `>`、`>>`、`<` 重定向数据。

Bash 本身也是一种编程语言，支持变量、`$()`、`if`、`for`、`while` 和脚本；脚本可以利用 shebang 指定解释器，并通过执行权限直接运行。

---

# 15 个核心自测题 + 答案

## 1. Terminal 和 Shell 有什么区别？

**Terminal** 是你看到的终端窗口或界面。

**Shell** 是运行在 Terminal 里面、负责解析和运行命令的程序，比如 `zsh`、`bash`。

```text
Terminal = 窗口
Shell    = 命令解释器
```

---

## 2. `ls -l /` 中 program 和 arguments 分别是什么？

Program：

```bash
ls
```

Arguments：

```text
-l
/
```

也就是：

```text
program: ls
argument 1: -l
argument 2: /
```

---

## 3. Absolute path 和 relative path 有什么区别？

Absolute path 从根目录 `/` 开始：

```bash
/Users/jasper/Desktop/file.txt
```

Relative path 是相对于当前目录：

```bash
Desktop/file.txt
```

核心区别：

> Absolute path 不受当前目录影响；relative path 会受当前工作目录影响。

---

## 4. `.`, `..`, `~` 分别是什么？

```text
.   = 当前目录
..  = 上一级目录
~   = 当前用户的 home directory
```

---

## 5. `pwd` 和 `cd` 做什么？

```bash
pwd
```

显示当前工作目录。

```bash
cd folder
```

改变当前工作目录。

---

## 6. 为什么 `cd` 必须是 Shell builtin？

因为 `cd` 要改变的是 **Shell 自己的当前工作目录**。

如果它是普通独立程序，那么改变的只是那个子程序自己的目录；程序退出后，Shell 的目录并没有改变。

---

## 7. `$PATH` 究竟是什么？Shell 怎么利用它找到 `git`、`python`、`ls`？

`$PATH` 是：

> **Shell 搜索可执行程序时要检查的文件夹列表。**

例如：

```bash
echo $PATH
```

得到：

```text
/usr/local/bin:/usr/bin:/bin
```

输入：

```bash
git
```

Shell 会依次查：

```text
/usr/local/bin/git
/usr/bin/git
/bin/git
```

找到第一个可执行的就运行。

---

## 8. 为什么当前目录的程序经常需要写 `./program`？

因为当前目录 `.` 通常不在 `$PATH` 中。

```bash
./hello
```

明确表示：

> 执行当前目录里的 `hello`。

---

## 9. `rwx` 分别是什么？

```text
r = read
w = write
x = execute
```

例如：

```text
rwxr-xr--
```

表示：

```text
user:   rwx
group:  r-x
others: r--
```

---

## 10. `chmod +x` 做了什么？

```bash
chmod +x script.sh
```

给文件增加 execute permission。

也就是允许它被直接执行。

---

## 11. `*`、`?`、`{a,b}` 分别怎么展开？

### `*`

匹配 0 个或多个任意字符：

```bash
*.txt
```

### `?`

匹配恰好一个字符：

```bash
file?.txt
```

### `{a,b}`

直接展开成多个字符串：

```bash
file{1,2}.txt
```

展开成：

```text
file1.txt
file2.txt
```

最重要的是：

> 它们通常由 Shell 展开，而不是 `ls`、`rm` 自己展开。

---

## 12. `|` 连接的究竟是什么？

```bash
A | B
```

连接的是：

```text
A 的 stdout
      ↓
B 的 stdin
```

所以 pipe 的精确定义是：

> 把前一个程序的标准输出作为后一个程序的标准输入。

---

## 13. `>`、`>>`、`<` 有什么区别？

```text
>   stdout → 文件，覆盖
>>  stdout → 文件，追加
<   文件 → stdin
```

例如：

```bash
echo hello > file.txt
echo hello >> file.txt
command < file.txt
```

---

## 14. `$(date)` 为什么可以嵌进另一个命令？

因为 `$()` 是 **command substitution**。

Shell 会：

```text
1. 执行 date
2. 获取 date 的 stdout
3. 用这个输出替换 $(date)
4. 再执行完整命令
```

例如：

```bash
today=$(date)
```

就是把 `date` 的输出保存到变量 `today`。

---

## 15. `#!/bin/bash` 和 `set -euo pipefail` 分别解决什么问题？

### `#!/bin/bash`

叫 shebang。

告诉系统：

> 这个脚本应该使用 `/bin/bash` 来解释执行。

### `set -euo pipefail`

让 Bash 脚本更严格：

```text
-e
某条命令失败 → 尽快停止脚本

-u
使用未定义变量 → 报错

-o pipefail
pipe 中任意一步失败
→ 整条 pipeline 视为失败
```

可以记：

> `#!` 决定“谁来运行脚本”；  
> `set -euo pipefail` 决定“出错时脚本要多严格”。

---

# 一页速记

| 概念 | 一句话 |
|---|---|
| Terminal | 显示 Shell 的窗口 |
| Shell | 解析并运行命令 |
| absolute path | 从 `/` 开始 |
| relative path | 相对于当前目录 |
| `.` | 当前目录 |
| `..` | 上一级 |
| `~` | home |
| `$PATH` | Shell 找程序的目录清单 |
| `./x` | 当前目录里的 x |
| `rwx` | read / write / execute |
| `chmod +x` | 增加执行权限 |
| glob | Shell 展开文件名模式 |
| `|` | stdout → stdin |
| `> >> <` | 重定向输入输出 |
| `$()` | 用命令输出替换当前位置 |
