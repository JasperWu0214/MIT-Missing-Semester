# Missing Semester Lecture 3 — Cornell Notes

> **课程：** The Missing Semester of Your CS Education
>
> **Lecture 3：** Development Environment
>
> **主题：** Vim、模态编辑、Vim 操作语言、Language Server、代码智能、AI 编程、IDE 扩展与远程开发
>
> **参考：** [2026 中文课程页面](https://missing-semester-cn.github.io/2026/development-environment/)

---

## 1.
什么是 Development Environment？

开发环境不是单独一个软件，而是一整套帮助你开发软件的工具。

常见能力包括：

```text
文本编辑
语法高亮
自动补全
类型检查
代码格式化
跳转到定义
查找引用
调试
AI 辅助
```

常见的两种路线：

```text
IDE 路线
VS Code / Cursor / JetBrains
        ↓
大部分能力集成在一个应用里
```

```text
Terminal 路线
tmux + Vim + Zsh + CLI tools
        ↓
每个工具负责一部分能力
```

---

## 2.
IDE 和 Terminal Workflow 有什么区别？

| 方式 | 优点 | 缺点 |
|---|---|---|
| IDE | 开箱即用、图形界面友好、扩展丰富、AI 集成方便 | 更重、依赖 GUI |
| Terminal workflow | 轻量、可组合、远程机器也能用 | 学习曲线更陡，需要自己配置 |

课程建议：

> 两种都至少熟悉一种，并精通其中一种。

如果暂时没有偏好，VS Code 是一个很适合入门的选择。

---

## 3. 为什么课程专门讲 Vim？

编程时真正花时间最多的通常不是：

```text
一直连续打字
```

而是：

```text
移动光标
寻找代码
阅读代码
修改已有代码
删除
复制
重构
```

Vim 针对这种工作方式优化。

它最核心的思想是：

> **把文本编辑设计成一种可以组合的语言。**

---

## 4.
Vim 是 Modal Editor

Vim 最大的特点之一：

> **同一个按键在不同 Mode 下有不同意义。**

主要模式：

| Mode | 用途 |
|---|---|
| Normal | 移动、编辑 |
| Insert | 输入文字 |
| Replace | 替换文字 |
| Visual | 选择文字 |
| Visual Line | 按整行选择 |
| Visual Block | 按矩形块选择 |
| Command | 执行 Vim 命令 |

---

## 5.
Normal Mode 为什么是核心？

Vim 默认进入：

```text
Normal Mode
```

Normal Mode 不是“什么都不做”。

它实际上是：

> **用键盘发出编辑命令的模式。**

例如：

```text
w
→ 跳到下一个单词

d
→ delete

p
→ paste
```

所以 Vim 的思想不是：

```text
一直打字
```

而是：

```text
Normal Mode
→ 导航 / 修改

Insert Mode
→ 真正输入文字
```

---

## 6.
如何切换 Mode？

从任意模式回到 Normal：

```text
Esc
```

Normal → Insert：

```text
i
```

Normal → Replace：

```text
R
```

Normal → Visual：

```text
v
```

Normal → Visual Line：

```text
V
```

Normal → Visual Block：

```text
Ctrl-v
```

Normal → Command：

```text
:
```

最基础循环：

```text
Normal
  ↓ i
Insert
  ↓ Esc
Normal
```

---

## 7.
为什么 Vim 不鼓励方向键？

Vim 希望你的手尽量留在：

```text
home row
```

所以移动使用：

```text
h → 左
j → 下
k → 上
l → 右
```

减少：

```text
手离开主键区
↓
找方向键
↓
再回来
```

---

## 8. Vim 中的 Motion

Vim 中负责“去哪里”的命令叫：

> **motion**

也可以理解成：

> **名词 noun**

基础：

```text
h j k l
```

按单词：

```text
w → 下一个单词
b → 上一个 / 当前单词开头
e → 单词结尾
```

---

## 9. 行内移动

```text
0 → 行首
^ → 本行第一个非空白字符
$ → 行尾
```

区别：

```text
0
→ 真正第 1 列

^
→ 第一个不是空格的位置
```

---

## 10.
文件范围移动

```text
gg → 文件开头
G  → 文件结尾
```

跳到指定行：

```text
42G
```

或者：

```vim
:42
```

---

## 11. 屏幕与滚动

```text
H → 屏幕顶部
M → 屏幕中间
L → 屏幕底部
```

滚动：

```text
Ctrl-u → 向上滚
Ctrl-d → 向下滚
```

---

## 12. `%` 是什么？

```text
%
```

会跳到对应的匹配符号。

例如光标在：

```text
(
```

按 `%`：

```text
跳到对应的 )
```

也适用于类似：

```text
{ }
[ ]
```

---

## 13.
`f` 和 `t`

在当前行查找字符：

```text
f{x}
```

表示：

> 跳到下一个字符 x。

例如：

```text
fa
```

跳到下一个 `a`。

`t{x}`：

> 跳到目标字符前一个位置。

---

## 14. `F` 和 `T`

```text
f / t
→ 向右找

F / T
→ 向左找
```

重复最近一次查找：

```text
; → 同方向继续
, → 反方向继续
```

---

## 15. 搜索 `/`

搜索整个文件：

```vim
/hello
```

按 Enter。

之后：

```text
n → 下一个匹配
N → 上一个匹配
```

搜索可以使用 regular expression。

---

## 16.
Visual Mode

进入：

```text
v
```

然后配合 motion 扩大选择。

例如：

```text
v
w
w
```

选择若干单词。

选中后：

```text
d → 删除
c → 修改
y → 复制
```

---

## 17. Visual Line

```text
V
```

按整行选择。

适合：

```text
复制多行
删除多行
批量缩进
```

---

## 18. Visual Block

```text
Ctrl-v
```

按矩形区域选择。

适合：

```text
批量编辑多行同一列
列式修改
给多行加相同前缀
```

---

## 19.
Vim 的核心：Verb + Noun

Vim 编辑命令可以理解成：

```text
Verb + Noun
```

例如：

```text
d + w
```

其中：

```text
d = delete
w = 一个 word 的 motion
```

所以：

```text
dw
→ delete word
```

---

## 20. 常用 Verb

```text
d → delete
c → change
y → yank / copy
```

这些可以和 motion 组合。

例如：

```text
dw
d$
d0
cw
```

---

## 21. `d{motion}`

```text
dw
→ 删除到下一个单词边界

d$
→ 删除到行尾

d0
→ 删除到行首
```

Vim 的威力来自：

> **你不需要记住每一个组合，只要会 verb 和 motion，就能自己组合。**

---

## 22.
`c{motion}`

`c` = change。

例如：

```text
cw
```

可以理解成：

```text
删除当前单词
+
进入 Insert Mode
```

也就是：

```text
change word
```

---

## 23. `x` 和 `s`

```text
x
→ 删除当前字符
```

大致等价：

```text
dl
```

```text
s
→ 替换当前字符
```

大致等价：

```text
cl
```

---

## 24. `o` 和 `O`

```text
o
→ 在当前行下面新建一行并进入 Insert Mode

O
→ 在当前行上面新建一行并进入 Insert Mode
```

---

## 25. Undo / Redo

```text
u
→ undo

Ctrl-r
→ redo
```

---

## 26.
Yank 和 Paste

Vim 中复制叫：

```text
yank
```

命令：

```text
y
```

粘贴：

```text
p
```

例如：

```text
yy
→ 复制整行

p
→ 粘贴
```

---

## 27. 为什么删除后也能 `p`？

很多 Vim 删除操作：

```text
d
```

会把被删内容放进 register。

所以：

```text
dd
p
```

可以实现：

```text
剪切这一行
↓
粘贴
```

---

## 28. Count

Vim 命令前可以加数字。

例如：

```text
3w
→ 向前 3 个单词

5j
→ 向下 5 行

7dw
→ 删除 7 个单词
```

模式：

```text
[count] + command
```

---

## 29.
Text Object

除了 motion，Vim 还能直接表达：

```text
某个结构内部
某个结构整体
```

核心修饰符：

```text
i → inside / inner
a → around
```

---

## 30. `ci(`

```text
ci(
```

拆开：

```text
c  = change
i  = inside
(  = parentheses
```

意思：

> 修改当前这对圆括号里面的内容。

例如：

```python
print(hello_world)
```

光标在括号里：

```text
ci(
```

会删掉：

```text
hello_world
```

并进入 Insert Mode。

---

## 31.
`ci[` 和 `da'`

```text
ci[
→ 修改 [] 内部

da'
→ 删除整个单引号字符串，包括引号
```

理解：

```text
i
→ 内部

a
→ 连外部边界也一起
```

---

## 32. Vim 为什么像语言？

因为它的命令有组合规则：

```text
Verb
+
Count
+
Motion / Text Object
```

例如：

```text
d  + w
c  + i  + "
3  + d  + w
```

所以你不是死记几百个 shortcut。

而是在学习一套：

> **文本编辑语法。**

---

## 33.
Vim 学习方法

课程推荐：

```text
先学最基本操作
↓
在日常编辑器打开 Vim mode
↓
坚持使用
↓
遇到低效操作时去查更好的 Vim 方法
```

重要资源：

```bash
vimtutor
```

它是最适合入门的官方交互教程之一。

---

## 34. 什么是 Language Server？

很多 IDE 功能需要真正理解：

```text
变量
函数
类型
引用关系
项目依赖
```

这不是普通文本编辑器自己就能知道的。

Language Server：

> **专门分析某种编程语言，并把代码智能能力提供给编辑器。**

---

## 35.
LSP 是什么？

LSP：

```text
Language Server Protocol
```

它定义了：

> 编辑器和 Language Server 如何通信。

可以理解成：

```text
VS Code
Vim
Neovim
Cursor
   │
   │ LSP
   ↓
Language Server
   ↓
理解代码
```

---

## 36. 为什么 LSP 很重要？

以前：

```text
每个 Editor
×
每种 Language
```

都可能要单独开发支持。

LSP 之后：

```text
Editor
↓
统一协议
↓
Language Server
```

语言工具可以更容易复用。

---

## 37.
Language Server 能提供什么？

常见能力：

```text
Autocomplete
Hover documentation
Go to definition
Find references
Import assistance
Diagnostics
Type checking
Formatting
```

---

## 38. Go to Definition

例如：

```python
result = calculate_total(items)
```

光标在：

```text
calculate_total
```

使用：

```text
Go to Definition
```

直接跳到函数定义。

这比：

```text
手动 grep 文件
```

高效得多。

---

## 39.
Find References

和 Go to Definition 相反。

```text
Go to Definition
→ 这个东西在哪里定义？

Find References
→ 哪些地方使用了这个东西？
```

重构时非常有用。

---

## 40. Import Assistance

语言服务器通常可以：

```text
自动添加缺失 import
删除未使用 import
整理 import 顺序
```

例如 Python：

```python
Path(...)
```

可能自动建议：

```python
from pathlib import Path
```

---

## 41.
Type Checking / Linting / Formatting

三者不要混：

```text
Formatter
→ 代码长什么样

Linter
→ 是否有可疑 / 不规范写法

Type Checker
→ 类型是否合理
```

例如 Python：

```text
Ruff
→ lint + formatting

Mypy
→ static type checking
```

---

## 42. 为什么 Language Server 需要知道项目环境？

例如 Python 项目：

```text
venv A
安装 requests

venv B
没有 requests
```

如果 IDE 选错 Python interpreter：

```text
Language Server
↓
看不到正确依赖
↓
错误提示 missing import
```

所以：

> **编辑器必须连接到正确的语言环境。**

---

## 43.

AI 编程工具的三种主要形态

课程把 AI coding 大致分成：

```text
Autocomplete
Inline Chat
Coding Agent
```

---

## 44. AI Autocomplete

AI 自动补全根据：

```text
当前文件
已有代码
函数名
注释
周围上下文
```

预测你接下来可能想写的代码。

例如：

```python
def download_contents(url: str) -> str:
```

模型可能自动补完整个函数。

---

## 45.
注释也可以作为 Prompt

例如：

```python
def extract(content: str) -> list[str]:
    # extract all Markdown links
```

AI 会使用注释理解你的意图。

所以：

```text
变量名
函数名
docstring
comment
```

都会影响补全质量。

---

## 46. AI Autocomplete 的局限

Autocomplete 通常主要修改：

```text
光标之后
```

它不一定会主动重构：

```text
已有代码
import 结构
多个文件
```

例如 AI 可能在函数内部生成：

```python
import re
```

虽然更好的代码结构可能应该把它放模块顶部。

所以：

> **AI 生成 ≠ 正确设计。**

---

## 47.
Inline Chat

Inline Chat 可以：

```text
选中已有代码
↓
输入要求
↓
AI 提议修改
```

例如：

```text
把 requests 改成 Python 内置库
```

它和 autocomplete 最大区别：

```text
Autocomplete
→ 补后面的代码

Inline Chat
→ 修改已有代码
```

---

## 48. Coding Agent

Coding Agent 的范围更大。

它可能：

```text
搜索整个项目
读取多个文件
修改多个文件
运行测试
调用命令
迭代修复
```

这比单纯 autocomplete 更接近：

```text
完成一个开发任务
```

---

## 49.
AI Coding 最重要的原则

AI 可以提高速度，但仍然需要你判断：

```text
代码是否正确？
有没有安全问题？
有没有破坏现有逻辑？
是不是最简单方案？
有没有 hallucination？
```

正确工作流：

```text
AI proposal
↓
review
↓
test
↓
accept
```

而不是：

```text
AI proposal
↓
直接相信
```

---

## 50. IDE Extensions

IDE 的能力经常来自扩展。

例如：

```text
Language support
Vim mode
Git
Remote SSH
Containers
Live Share
AI
```

所以你的 IDE 更像：

> **一个可扩展的平台。**

---

## 51.
Development Containers

Development Container：

> **把开发工具和依赖放在一个容器环境中运行。**

优点：

```text
环境隔离
可复现
跨机器一致
减少 "works on my machine"
```

---

## 52. Remote Development

Remote SSH 类工具允许：

```text
本地 VS Code
↓ SSH
远程服务器
↓
编辑 / 运行远程代码
```

特别适合：

```text
云服务器
GPU server
实验室机器
没有本地算力的项目
```

---

## 53.
Collaborative Editing

类似：

```text
Google Docs
```

多人同时编辑代码。

例如：

```text
VS Code Live Share
```

适合：

```text
pair programming
debugging
远程协作
```

---

# 第三讲知识地图

```text
                   Development Environment
                             │
          ┌──────────────────┼──────────────────┐
          ↓                  ↓                  ↓
       Editing          Code Intelligence       AI
          │                  │                  │
         Vim                LSP           Autocomplete
          │                  │            Inline Chat
   ┌──────┼──────┐           │            Coding Agent
   ↓      ↓      ↓           ↓
 Modes  Motion  Editing   Language Server
   │      │      │           │
Normal  hjkl     d        Completion
Insert  w/b/e    c        Definition
Visual  0/$      y        References
Command gg/G     p        Diagnostics
   │      │      │        Type Check
   └──────┴──────┘
          │
    Verb + Noun
          │
      Text Object
        i / a

                             │
                             ↓
                         IDE Extensions
                             │
                ┌────────────┼────────────┐
                ↓            ↓            ↓
          Dev Container   Remote SSH   Collaboration
```

---

# Cornell Bottom Summary

第三讲的核心不是“学几个 Vim 快捷键”，而是建立一个现代开发环境的整体模型。

Vim 最重要的思想是：

```text
编辑 = 可组合的语言
```

Motion 决定“去哪”，operator 决定“做什么”，因此：

```text
d + w
→ 删除一个单词

c + i + (
→ 修改括号内部
```

现代 IDE 的“智能”通常不是编辑器本身完成的，而是通过 Language Server：

```text
Editor
↓ LSP
Language Server
↓
理解程序结构
```

因此可以提供自动补全、跳转定义、查找引用、类型检查等功能。

AI 编程又在此基础上增加：

```text
Autocomplete
Inline Chat
Coding Agent
```

但 AI 生成的代码仍需要 review 和 test。

最后，一个成熟的 Development Environment 往往是：

```text
Editor
+
Language Server
+
Formatter / Linter / Type Checker
+
Extensions
+
Remote / Container tools
+
AI assistance
```

第三讲解决：

> **我应该怎样高效地阅读、导航、修改和理解代码？**

---

# 第三讲 15 个核心自测题 + 答案

## 1.
IDE 和 Terminal-based workflow 的核心区别是什么？

IDE 把大量开发工具整合在一个应用中。

Terminal workflow 则把：

```text
tmux
Vim
Zsh
CLI tools
```

组合起来。

---

## 2. Vim 为什么叫 Modal Editor？

因为同一个按键在不同模式下会有不同含义。

例如：

```text
Insert Mode 的 x
→ 输入字符 x

Normal Mode 的 x
→ 删除当前字符
```

---

## 3. Vim 默认是什么模式？

```text
Normal Mode
```

主要用于导航和编辑。

---

## 4. 如何从 Insert Mode 回到 Normal Mode？

```text
Esc
```

---

## 5.
`hjkl` 分别是什么？

```text
h → 左
j → 下
k → 上
l → 右
```

---

## 6. `w`、`b`、`e` 的区别是什么？

```text
w → 下一个 word
b → word 开头
e → word 结尾
```

---

## 7. `0`、`^`、`$` 的区别是什么？

```text
0 → 真正行首
^ → 第一个非空字符
$ → 行尾
```

---

## 8. `gg` 和 `G` 是什么？

```text
gg → 文件开头
G  → 文件结尾
```

---

## 9. `dw` 为什么不是一个独立需要死记的命令？

因为它是：

```text
d = delete
w = word motion
```

也就是：

```text
Verb + Noun
```

---

## 10.
`ci(` 是什么意思？

```text
c  → change
i  → inside
(  → parentheses
```

所以：

> 修改当前括号内部的内容。

---

## 11. `i` 和 `a` text object modifier 有什么区别？

```text
i → inside，不包含边界
a → around，包含边界
```

---

## 12. Language Server 是什么？

一个专门理解某种编程语言，并向编辑器提供代码智能能力的程序。

---

## 13. LSP 解决什么问题？

统一：

```text
Editor
↔
Language Server
```

之间的通信方式，让不同编辑器可以复用语言工具。

---

## 14.
Formatter、Linter、Type Checker 有什么区别？

```text
Formatter
→ 格式

Linter
→ 可疑代码 / 风格 / 常见错误

Type Checker
→ 类型关系
```

---

## 15.
AI Autocomplete、Inline Chat、Coding Agent 有什么区别？

```text
Autocomplete
→ 补全光标之后

Inline Chat
→ 修改选中的已有代码

Coding Agent
→ 跨文件、运行命令、完成多步骤任务
```

---

# 一页速记

| 概念 | 一句话 |
|---|---|
| Development Environment | 开发软件所用的一整套工具 |
| IDE | 把多种开发能力整合在一起 |
| Vim | 模态文本编辑器 |
| Normal Mode | 导航和编辑 |
| Insert Mode | 输入文本 |
| Visual Mode | 选择文本 |
| Command Mode | 执行 Vim 命令 |
| `Esc` | 回 Normal Mode |
| `i` | 进入 Insert |
| `hjkl` | 左下上右 |
| `w / b / e` | word 移动 |
| `0 / ^ / $` | 行首 / 首个非空字符 / 行尾 |
| `gg / G` | 文件首 / 文件尾 |
| `/pattern` | 搜索 |
| `n / N` | 下一个 / 上一个匹配 |
| `d` | delete |
| `c` | change |
| `y` | yank / copy |
| `p` | paste |
| `u` | undo |
| `Ctrl-r` | redo |
| `dw` | delete word |
| `cw` | change word |
| `ci(` | change inside parentheses |
| `i` text object | inside |
| `a` text object | around |
| LSP | Language Server Protocol |
| Language Server | 为编辑器提供代码语义能力 |
| Go to Definition | 跳到定义 |
| Find References | 找所有使用位置 |
| Formatter | 自动格式化代码 |
| Linter | 检查常见问题 |
| Type Checker | 检查类型 |
| AI Autocomplete | AI 补全代码 |
| Inline Chat | AI 修改已有代码 |
| Coding Agent | AI 执行跨文件多步骤开发任务 |
| Dev Container | 容器化开发环境 |
| Remote SSH | 本地 IDE 操作远程开发环境 |
