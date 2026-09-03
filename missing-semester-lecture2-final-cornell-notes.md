# Missing Semester Lecture 2 — Cornell Notes

> **课程：** The Missing Semester of Your CS Education
>
> **Lecture 2：** Command-Line Environment
>
> **主题：** 程序参数、数据流、环境变量、退出码、Signals、Job Control、SSH、tmux、dotfiles
>
> **参考：** [2026 中文课程页面](https://missing-semester-cn.github.io/2026/command-line-environment/)

---

## 1. Arguments 参数

| Cue / 自测问题 | Notes |
|---|---|
| Shell 程序收到的参数本质是什么？ | **字符串列表** |
| `ls -l folder/` 怎么理解？ | program = `ls`；arguments = `-l`, `folder/` |
| `$0` | 程序 / 脚本自己的名字 |
| `$1`, `$2`... | 第 1、第 2 个参数 |
| `$@` | 所有参数 |
| `$#` | 参数数量 |
| flag 是什么？ | 修改程序行为的选项，如 `-l`、`--all` |
| `--` 有什么用？ | 后面的内容全部按普通参数处理，不再解析成 flag |

```bash
ls -l folder/
```

```text
program:
ls

arguments:
-l
folder/
```

**重要：Shell 只负责把参数交给程序；参数具体是什么意思，由程序自己规定。**

例如：

```bash
date +%Y-%m-%d
```

这里 `+%Y-%m-%d` 才是 `date` 的 argument。`date` 自己规定这个 argument 表示输出格式。

---

## 2. `--` 是干什么的？

如果文件真的叫：

```text
-myfile
```

运行：

```bash
rm -myfile
```

程序可能把它误认为 flag。

所以：

```bash
rm -- -myfile
```

可以记：

> **`--` = flags 到此结束。**

---

## 3. Globbing 通配符

| Pattern | 含义 |
|---|---|
| `*` | 0 个或多个任意字符 |
| `?` | 恰好 1 个字符 |
| `{a,b}` | 展开成多个字符串 |
| `**` | zsh 等 Shell 中可递归匹配路径 |

例如：

```bash
rm *.py
```

Shell 会先把 `*.py` 展开成实际文件名，再运行 `rm`。

> **Glob 通常由 Shell 展开，不是 `rm`、`ls` 自己展开。**

---

## 4. Streams 数据流

```text
                   ┌─────────────┐
stdin ───────────→ │   Program   │ ─────────→ stdout
                   │             │
                   └─────────────┘ ─────────→ stderr
```

| Stream | 含义 |
|---|---|
| stdin | Standard Input，标准输入 |
| stdout | Standard Output，正常输出 |
| stderr | Standard Error，错误输出 |

默认：

```text
stdin  ← Keyboard
stdout → Terminal
stderr → Terminal
```

---

## 5. Pipe `|`

```bash
A | B
```

真正连接的是：

```text
A 的 stdout
      ↓
B 的 stdin
```

例如：

```bash
cat file.txt | grep hello | uniq
```

Pipeline 中的程序通常同时运行，数据边产生边流过去。

---

## 6. `-` 为什么有时代表 stdin？

很多 Unix 工具约定：

```text
-
=
从 stdin 读取
```

例如：

```bash
echo "hello" | grep hello -
```

很多工具也允许直接省略 `-`：

```bash
echo "hello" | grep hello
```

---

## 7. stdout 和 stderr 为什么分开？

如果：

```bash
ls /nonexistent | grep hello
```

错误仍然会显示在 Terminal，因为 `|` 默认只连接：

```text
stdout → stdin
```

不会自动连接 stderr。

---

## 8. 重定向

| 写法 | 含义 |
|---|---|
| `>` | stdout → 文件，覆盖 |
| `>>` | stdout → 文件，追加 |
| `<` | 文件 → stdin |
| `2>` | stderr → 文件 |
| `&>` | stdout + stderr → 文件 |
| `/dev/null` | 丢弃数据 |

例如：

```bash
echo hello > output.txt
echo hello >> output.txt
ls foobar 2> errors.txt
command &> output.txt
```

---

## 9. `/dev/null`

可以理解成：

> **Unix 黑洞 / 垃圾桶**

```bash
command > /dev/null
```

丢掉 stdout。

```bash
command 2> /dev/null
```

丢掉 stderr。

---

## 10. Shell Variables

赋值：

```bash
foo=bar
```

读取：

```bash
echo "$foo"
```

不要写：

```bash
foo = bar
```

因为 Shell 会按空格拆参数。

---

## 11. Return Code / Exit Status

程序结束时会返回：

```text
exit code
```

Unix 约定：

```text
0      = success
non-0  = failure
```

查看上一条命令：

```bash
echo $?
```

所以：

```text
$?
= 上一条命令的 exit code
```

---

## 12. `&&` 和 `||`

它们根据前一个命令的 **exit code** 工作。

### `&&`

```bash
A && B
```

> **A 成功，才执行 B。**

例如：

```bash
mkdir project && cd project
```

### `||`

```bash
A || B
```

> **A 失败，才执行 B。**

例如：

```bash
grep -q hello file.txt || echo "not found"
```

记忆：

```text
&& = 成功才继续
|| = 失败才继续
```

---

## 13. `'...'` vs `"..."`

假设：

```bash
foo=bar
```

```bash
echo "$foo"
```

输出：

```text
bar
```

而：

```bash
echo '$foo'
```

输出：

```text
$foo
```

记忆：

```text
'...' → 基本原样
"..." → 里面仍会做变量展开等处理
```

---

## 14. `$` 在 Shell 里是什么意思？

`$` 经常表示：

> **不要把后面的东西按普通文字理解，取出 / 展开它对应的值。**

| 写法 | 意思 |
|---|---|
| `$TZ` | 读取变量 `TZ` |
| `$PATH` | 读取变量 `PATH` |
| `$?` | 上一条命令的 exit code |
| `$1` | 第一个 script argument |
| `$@` | 所有 arguments |
| `$#` | argument 数量 |
| `$!` | 最近后台任务的 PID |
| `$(command)` | 执行 command，并用 stdout 替换这里 |

例如：

```text
TZ
→ 变量名

$TZ
→ 变量的值
```

---

## 15. Command Substitution `$()`

```bash
today=$(date)
```

过程：

```text
执行 date
 ↓
得到 stdout
 ↓
用 stdout 替换 $(date)
 ↓
保存到 today
```

所以：

```text
today=$(date)
→ 命令输出 → 变量
```

而：

```bash
date > today.txt
```

是：

```text
命令输出 → 文件
```

---

## 16. Process Substitution `<()`

```bash
diff <(ls src) <(ls docs)
```

区别：

```text
$(command)
→ 我要 command 的输出内容

<(command)
→ 我要一个可以像文件一样使用的结果
```

---

## 17. Environment Variables

可以把 environment 理解成：

> **进程启动时附带的一组配置**

例如：

```text
PATH
HOME
USER
TZ
LANG
```

查看：

```bash
printenv
```

---

## 18. 普通变量 vs Environment Variable

普通变量：

```bash
foo=bar
```

主要存在于当前 Shell。

环境变量：

```bash
export FOO=bar
```

之后启动的 child processes 也能继承它。

---

## 19. 临时环境变量

```bash
TZ=Asia/Tokyo date
```

这里：

```text
TZ=Asia/Tokyo
→ 临时环境变量

date
→ program

arguments
→ 无
```

Shell 会：

```text
创建临时 environment
TZ=Asia/Tokyo
        ↓
运行 date
        ↓
date / 系统时间库读取 TZ
        ↓
显示东京时区
        ↓
date 结束
        ↓
临时 TZ 消失
```

所以之后：

```bash
echo "$TZ"
```

可能什么都不显示。

---

## 20. 为什么 `date` 知道 `TZ` 是时区？

不是 Shell 自动知道。

而是：

> `date` 或它调用的系统时间库已经按约定写了代码去读取名为 `TZ` 的环境变量。

可以粗略理解成：

```c
timezone = getenv("TZ");
```

所以：

```bash
TZ=Asia/Tokyo date
```

有作用。

而：

```bash
BANANA=Asia/Tokyo date
```

通常没有作用，因为程序根本不会读取 `BANANA`。

---

## 21. `export`

```bash
export TZ=Asia/Tokyo
```

区别：

```text
TZ=Asia/Tokyo date
→ 只影响这一次 date

TZ=Asia/Tokyo
→ 当前 Shell 有这个变量

export TZ=Asia/Tokyo
→ 当前 Shell 有
  +
  以后启动的 child processes 也能继承
```

---

## 22. `unset`

删除变量：

```bash
unset DEBUG
```

---

## 23. `$PATH`

`$PATH` 本身就是一个 Environment Variable。

它保存：

> **Shell 搜索 executable 时要检查的目录列表**

Shell 从左到右搜索，找到第一个对应 executable 就运行。

例如：

```bash
which python3
```

可以查看 Shell 最终找到了哪个 `python3`。

---

## 24. `$PATH` 里应该放什么？

应该放：

> **目录**

正确：

```bash
export PATH="/Library/Frameworks/Python.framework/Versions/3.14/bin:$PATH"
```

错误：

```bash
export PATH="$PATH:/usr/local/bin/python3"
```

因为：

```text
/usr/local/bin
→ directory ✅

/usr/local/bin/python3
→ executable file ❌
```

---

## 25. `which`

```bash
which python3
which git
which brew
```

用来查看某个命令最终对应哪个 executable。

---

## 26. `if` / `while` 与 Return Code

例如：

```bash
if grep -q hello file.txt; then
    echo "Found"
fi
```

这里不是 `grep` 返回 `true`。

而是：

```text
grep 成功
↓
exit code = 0
↓
Shell 当作 true
```

---

## 27. Signals

运行：

```bash
sleep 100
```

按：

```text
Ctrl-C
```

发生：

```text
Ctrl-C
↓
SIGINT
↓
发送给 sleep
↓
通常退出
```

Signal 可以理解成：

> **发送给正在运行进程的一条特殊通知**

---

## 28. 常见 Signals

| 操作 | Signal | 含义 |
|---|---|---|
| `Ctrl-C` | `SIGINT` | interrupt |
| `Ctrl-\` | `SIGQUIT` | quit |
| `Ctrl-Z` | `SIGTSTP` | 暂停 |
| `kill PID` | 通常 `SIGTERM` | 请求结束 |
| `kill -9 PID` | `SIGKILL` | 强制杀死 |

通常先：

```text
SIGTERM
↓
不行
↓
SIGKILL
```

---

## 29. `kill`

```bash
kill PID
```

本质是：

> **向某个 PID 发送 signal**

例如：

```bash
kill -TERM 1234
```

### `trap`：退出时清理

Shell 脚本可以用 `trap` 在退出或收到信号时执行清理逻辑：

```bash
#!/usr/bin/env bash

cleanup() {
    rm -f /tmp/my-script.*
}

trap cleanup EXIT
trap cleanup SIGINT SIGTERM
```

`EXIT` 会在脚本退出时触发；`SIGINT` 和 `SIGTERM` 分别覆盖终端中断和常规终止请求。

---

## 30. `Ctrl-C` vs `Ctrl-Z`

```text
Ctrl-C
→ SIGINT
→ 通常结束 / 中断程序

Ctrl-Z
→ SIGTSTP
→ 暂停程序
```

Homebrew 卡住时：

```text
Ctrl-C
→ 想停止

Ctrl-Z
→ 想暂停
```

---

## 31. Job Control

| Command | 用途 |
|---|---|
| `jobs` | 查看当前 Shell jobs |
| `fg` | job 回到 foreground |
| `bg` | 暂停的 job 在 background 继续 |
| `&` | 一开始就在后台运行 |
| `$!` | 最近后台任务的 PID |

---

## 32. Foreground vs Background

Foreground：

```bash
sleep 100
```

程序占着 Terminal。

Background：

```bash
sleep 100 &
```

Shell prompt 可以继续使用。

---

## 33. `Ctrl-Z` + `bg`

```text
Foreground
   ↓ Ctrl-Z
Suspended
   ↓ bg
Background
```

拉回：

```bash
fg
```

查看：

```bash
jobs
```

---

## 34. 为什么关闭 Terminal 后后台程序也可能死？

即使：

```bash
program &
```

程序仍属于当前 Shell session。

Terminal 关闭时可能收到：

```text
SIGHUP
```

可以：

```bash
nohup program &
```

或：

```bash
disown
```

长期 session 更适合用 `tmux`。

---

## 35. `fzf`

`fzf` = fuzzy finder。

例如：

```bash
ls | fzf
```

常见：

```text
Ctrl-R
→ 模糊搜索历史命令
```

安装：

```bash
brew install fzf
```

---

## 36. SSH

SSH = Secure Shell。

作用：

> **从本地电脑操作远程电脑**

```bash
ssh alice@server.example.com
```

---

## 37. SSH 远程执行命令

```bash
ssh alice@server ls
```

`ls` 在远程执行。

```bash
ssh alice@server ls | wc -l
```

这里：

```text
ls = Remote
wc = Local
```

而：

```bash
ssh alice@server 'ls | wc -l'
```

整个 pipeline 都在 Remote。

---

## 38. SSH Keys

```text
~/.ssh/id_ed25519
→ private key

~/.ssh/id_ed25519.pub
→ public key
```

核心：

```text
PUBLIC KEY
→ 可以给服务器

PRIVATE KEY
→ 绝对不能泄露
```

生成：

```bash
ssh-keygen -a 100 -t ed25519
```

---

## 39. `scp` 和 `rsync`

```text
ssh
→ remote shell

scp
→ copy files

rsync
→ smarter file sync
```

例如：

```bash
scp file.txt user@server:/path/
```

---

## 40. `~/.ssh/config`

可以把：

```bash
ssh alice@172.16.174.141 -p 2222
```

配置成：

```text
Host vm
    User alice
    HostName 172.16.174.141
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
```

以后：

```bash
ssh vm
```

---

## 41. tmux

tmux = Terminal Multiplexer。

可以：

```text
           tmux
      ┌─────┼─────┐
      ↓     ↓     ↓
   shell  shell  shell
```

最重要：

> **session 可以 detach，再 attach。**

---

## 42. tmux 三层结构

```text
Session
│
├── Window
│   ├── Pane
│   └── Pane
│
└── Window
    └── Pane
```

类比：

```text
Session ≈ Workspace
Window  ≈ Tab
Pane    ≈ Split Screen
```

---

## 43. tmux 基础命令

```bash
tmux
tmux new -s project
tmux ls
tmux attach
```

快捷键 prefix：

```text
Ctrl-B
```

---

## 44. Dotfiles

例如：

```text
~/.zshrc
~/.bashrc
~/.gitconfig
~/.ssh/config
~/.tmux.conf
```

这些统称：

> **dotfiles**

它们保存各种工具的配置。

---

## 45. `.zshrc`

`~/.zshrc` 是：

> **zsh 启动时会读取的配置文件**

常见放：

- PATH
- environment variables
- aliases
- plugins
- history settings
- completion settings

修改后：

```bash
source ~/.zshrc
```

立即重新加载。

---

## 46. Zsh Plugins

### `zsh-autosuggestions`

根据历史命令显示灰色建议。

### `zsh-syntax-highlighting`

给命令做语法高亮。

### `fzf`

常用于：

```text
Ctrl-R
→ fuzzy history search
```

---

## 47. Alias

例如：

```bash
alias ll="ls -lah"
alias gs="git status"
```

Alias 本质：

> **简单的命令文本替换**

复杂逻辑更适合 Shell function。

---

## 48. Package Manager

macOS：

```text
Homebrew
```

例如：

```bash
brew install fzf
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting
```

---

## 49. `curl | bash` 为什么危险？

```bash
curl https://example.com/install.sh | bash
```

本质：

```text
Internet
 ↓
下载代码
 ↓
直接交给 bash
 ↓
立即执行
```

更稳妥：

```bash
curl ... -o install.sh
less install.sh
bash install.sh
```

---

## 50. `tldr`

```bash
tldr ls
```

记忆：

```text
man
→ 完整手册

tldr
→ 常见用法 + 示例
```

---

## 51. Shell 中的 AI

AI 工具可以在 Shell 中承担不同层次的工作：

```text
Command generation
→ 根据自然语言生成命令

Pipeline integration
→ 从 stdin 读取数据并把结果写到 stdout

AI shell
→ 执行跨命令、跨文件的多步骤任务
```

使用 AI 生成命令时，先检查命令将读取、修改或删除哪些内容，再决定是否执行。尤其要谨慎对待 `rm`、重定向覆盖、权限修改和远程脚本。

---

## 52. Terminal Emulator

Terminal、Shell 和命令行程序是不同层次：

```text
Terminal Emulator
        ↓
      Shell
        ↓
Command-Line Programs
```

Terminal Emulator 负责窗口、字体、配色、快捷键、标签页、分栏和回滚缓冲区；Shell 负责解析并运行命令。

---

# 第二讲知识地图

```text
                 Command-Line Environment
                           │
        ┌──────────────────┼──────────────────┐
        ↓                  ↓                  ↓
      Program          Processes           Workflow
        │                  │                  │
   Arguments            Signals             SSH
        │                  │                  │
   $1 $@ $#          Ctrl-C SIGINT         Keys
     Flags           Ctrl-Z SIGTSTP        scp
     Globs              SIGTERM            rsync
        │               SIGKILL              │
        ↓                  │                tmux
     Streams              Jobs            dotfiles
        │                  │                  │
 stdin/stdout          fg / bg             alias
    stderr               jobs              PATH
        │                  &                fzf
        ↓                nohup               │
 | > >> < 2>              │              Homebrew
        │                  │
        ↓                  │
 Environment Variables    │
        │                  │
 export / unset           │
 PATH / HOME / TZ         │
        │                  │
        ↓                  │
   Return Codes ──────────┘
        │
     0 / non-0
        │
      &&  ||
```

---

# Cornell Bottom Summary

第二讲最重要的是建立一个完整的程序运行模型：

```text
                    Arguments
                        ↓
Environment ─────→ Program
                     │   │
                     │   └────→ stderr
                     ↓
                   stdout
                     │
                     │ |
                     ↓
                  Program
                     │
                     ↓
                 Exit Code
                  0 / non-0
```

程序运行时又是一个 process：

```text
Process
├── 可以收到 Signal
├── 可以 foreground
├── 可以 background
└── 最后返回 exit code
```

真实开发环境进一步扩展：

```text
Your Mac
   │
  SSH
   ↓
Server
   │
 tmux
   ↓
长期 Shell session
   │
dotfiles
   ↓
统一开发环境
```

Terminal Emulator 提供承载 Shell 的窗口和交互界面；AI 工具可以参与命令生成、管道处理和多步骤任务，但执行前仍要检查命令的实际影响。

第一讲解决：

> **我怎么使用 Shell？**

第二讲解决：

> **Shell 中的程序如何接收参数、交换数据、读取环境、报告成功失败，以及被 Shell 和操作系统管理？**

---

# 第二讲 15 个核心自测题 + 答案

## 1. `ls -la folder` 中 program、argument、flag 分别是什么？

```text
program: ls
arguments: -la, folder
flag: -la
```

---

## 2. 为什么 `--` 可以解决 `-myfile` 这种文件名？

因为它告诉程序：后面的内容不再按 flag 解析。

---

## 3. `*.py` 是谁展开的？

通常是 **Shell**。

---

## 4. stdin、stdout、stderr 分别是什么？

```text
stdin  → 标准输入
stdout → 正常输出
stderr → 错误输出
```

---

## 5. `A | B` 真正连接的是什么？

```text
A stdout → B stdin
```

---

## 6. 为什么 stderr 默认不会进入 `|`？

因为 pipe 默认只连接 stdout。

---

## 7. `>`、`>>`、`2>`、`&>` 分别是什么？

```text
>   stdout → 文件，覆盖
>>  stdout → 文件，追加
2>  stderr → 文件
&>  stdout + stderr → 文件
```

---

## 8. `$?` 是什么？

上一条命令的 exit code。

```text
0 = success
non-0 = failure
```

---

## 9. `&&` 和 `||` 有什么区别？

```text
A && B → A 成功才运行 B
A || B → A 失败才运行 B
```

---

## 10. `'...'` 和 `"..."` 有什么区别？

```text
'...' → 基本原样
"..." → 仍会变量展开
```

---

## 11. `$()` 和 `<()` 有什么区别？

```text
$(command) → command 的 stdout
<(command) → 可以像文件一样使用的结果
```

---

## 12. `foo=bar`、`export FOO=bar` 和 `FOO=bar command` 有什么区别？

```text
foo=bar
→ 当前 Shell 变量

export FOO=bar
→ 当前 Shell + 子进程继承

FOO=bar command
→ 只临时提供给这一条 command
```

---

## 13. 为什么 `$PATH` 属于 Environment Variable？

因为它是一项进程环境配置，保存 executable 搜索目录。

---

## 14. `Ctrl-C` 与 `Ctrl-Z` 有什么区别？

```text
Ctrl-C → SIGINT → 通常中断程序
Ctrl-Z → SIGTSTP → 暂停程序
```

---

## 15. SSH、tmux、dotfiles 分别解决什么问题？

```text
SSH      → 操作远程电脑
tmux     → 管理持久 Terminal sessions
dotfiles → 保存和同步配置
```

---

# 一页速记

| 概念 | 一句话 |
|---|---|
| Arguments | 程序收到的字符串参数 |
| `--` | flags 到此结束 |
| Glob | Shell 展开文件名 pattern |
| stdin | 标准输入 |
| stdout | 正常输出 |
| stderr | 错误输出 |
| `|` | stdout → stdin |
| `>` | stdout → 文件，覆盖 |
| `>>` | stdout → 文件，追加 |
| `2>` | stderr → 文件 |
| `$?` | 上一条命令的 exit code |
| `0` | success |
| non-zero | failure |
| `&&` | 成功才继续 |
| `||` | 失败才继续 |
| `$VAR` | 读取变量值 |
| `$()` | command substitution |
| `export` | 让变量进入 environment |
| `VAR=x command` | 临时环境变量 |
| `$PATH` | executable 搜索目录列表 |
| `which` | 查看最终找到的 executable |
| `Ctrl-C` | SIGINT |
| `Ctrl-Z` | 暂停进程 |
| `jobs` | 查看当前 jobs |
| `bg` | 后台继续 |
| `fg` | 拉回前台 |
| SSH | 远程 Shell |
| tmux | Terminal multiplexer |
| dotfiles | 配置文件 |
| `.zshrc` | zsh 配置文件 |
| `fzf` | fuzzy finder |
| autosuggestions | 灰色历史补全 |
| syntax-highlighting | 命令语法高亮 |
| `tldr` | 简化版命令帮助 |
| AI shell | 用自然语言辅助生成或执行 Shell 工作流 |
| Terminal Emulator | 承载 Shell 的图形文本界面 |
