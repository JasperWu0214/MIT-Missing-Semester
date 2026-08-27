# Lecture 1 Cheat Sheet：Shell 基础

## 1. 命令与参数

Shell 通常用空格分隔命令及其参数。引号可以把包含空格的内容作为一个参数传入。

下面的命令向 `echo` 传入 **1 个参数**：

```sh
echo "hello world"
```

下面的命令向 `echo` 传入 **2 个参数**：

```sh
echo hello world
```

反斜杠 `\` 可以转义紧随其后的特殊字符。例如，转义空格后，整段内容会被视为一个参数：

```sh
echo hello\ world
```

## 2. 查看帮助

查看命令的使用手册：

```sh
man echo
```

许多程序也支持以下帮助选项：

```sh
command --help
command -h
```

> 并非所有命令都同时支持 `--help` 和 `-h`；具体用法以命令手册为准。

## 3. 文件与目录

### `pwd`：查看当前工作目录

```sh
pwd
```

也可以读取 Shell 保存的当前目录变量：

```sh
echo "$PWD"
```

路径分为两类：

- **绝对路径**：以 `/` 开头，从文件系统根目录出发，例如 `/Users/name/Documents`。
- **相对路径**：不以 `/` 开头，相对于当前工作目录解析。

几个常用的特殊路径：

- `~`：当前用户的 home 目录。
- `.`：当前目录。
- `..`：父目录。

### `cd`：切换目录

```sh
cd /path/to/directory
```

回到 home 目录：

```sh
cd ~
```

进入父目录：

```sh
cd ..
```

输入路径时可按 `Tab` 键自动补全，或查看当前可选的文件与目录。

### `ls`：列出目录内容

列出指定目录中的内容：

```sh
ls /path/to/directory
```

不提供路径时，默认列出当前目录的内容：

```sh
ls
```

以详细格式列出内容：

```sh
ls -l
```

`ls -l` 会显示文件类型、权限、链接数、所有者、所属组、大小和修改时间等信息。

### `cat`：输出文件内容

```sh
cat stata.cfg
```

`cat` 会把文件的原始文本输出到终端，并不会对内容进行渲染。

## 4. 文本处理

### `sort`：排序

```sh
sort file.txt
```

排序并去除重复行：

```sh
sort -u file.txt
```

### `uniq`：处理相邻的重复行

```sh
uniq file.txt
```

`uniq` 只会合并相邻的重复行，因此通常先使用 `sort`：

```sh
sort file.txt | uniq
```

### `head` 和 `tail`：查看文件开头或结尾

查看文件的前 3 行：

```sh
head -n 3 file.txt
```

查看文件的后 3 行：

```sh
tail -n 3 file.txt
```

### `grep`：搜索文本

在文件中搜索文本：

```sh
grep "pattern" file.txt
```

递归搜索目录中的文件：

```sh
grep -r "pattern" directory/
```

### `sed`：替换文本

将匹配文件中的所有 `grep` 替换为 `john`：

```sh
sed -i '' 's/grep/john/g' */*.md
```

说明：

- `-i ''`：直接修改文件；这是 macOS 自带 BSD `sed` 的写法。
- `s/grep/john/g`：把每一行中的所有 `grep` 替换为 `john`。
- `*/*.md`：匹配任意一级子目录中的所有 Markdown 文件。

> 直接修改文件前，建议先去掉 `-i ''` 预览输出，确认替换结果正确。

### `awk`：按列处理文本

输出每一行的第 2 列；默认使用空白字符分隔列：

```sh
awk '{print $2}' file.txt
```

处理以逗号分隔的 CSV 文件：

```sh
awk -F, '{print $2}' file.csv
```

## 5. 查找文件

查找 `Downloads` 目录中修改时间超过 30 天的 ZIP 文件：

```sh
find ~/Downloads -type f -name "*.zip" -mtime +30
```

参数说明：

- `-type f`：只匹配普通文件。
- `-name "*.zip"`：只匹配扩展名为 `.zip` 的文件。
- `-mtime +30`：匹配修改时间超过 30 天的文件。

在 `find` 中使用 `-exec` 时，`\;` 用于结束要执行的命令。例如：

```sh
find . -name "*.txt" -exec echo {} \;
```

其中，`{}` 会被替换为当前匹配到的文件路径。

查找 home 目录中大于 100 MB 的文件，并显示详细信息：

```sh
find ~ -type f -size +100M -exec ls -lh {} \;
```

## 6. 中断命令

在终端中按 `Control + C` 可以向当前前台进程发送中断信号，通常用于停止正在运行的命令。

## 7. 通配符速记

```sh
*/*.md
```

- 第一个 `*`：匹配任意一级子目录名。
- 第二个 `*`：匹配任意文件名。
- `.md`：要求文件以 `.md` 结尾。

该模式只匹配一级子目录中的 Markdown 文件，不会递归匹配更深层的目录。

`?` 匹配任意一个字符：

```sh
ls file?.txt
```

花括号展开可以生成多个字符串：

```sh
touch {a,b,c}.txt
```

为了防止 Shell 提前展开通配符，传给 `find` 的文件名模式通常要放在引号中：

```sh
find . -name "*.md"
```

## 8. 程序查找与 `$PATH`

Shell 会在 `$PATH` 中列出的目录里依次查找可执行程序。各目录之间以冒号 `:` 分隔：

```sh
echo "$PATH"
```

查看某个命令实际对应的位置：

```sh
which echo
```

也可以使用完整路径直接运行程序，从而绕过 `$PATH` 查找：

```sh
/bin/echo "hello"
```

> `cd` 等 Shell 内建命令不一定对应独立的可执行文件。

## 9. 标准流、重定向与管道

程序通常使用三条标准流：

- 标准输入 `stdin`，文件描述符为 `0`。
- 标准输出 `stdout`，文件描述符为 `1`。
- 标准错误 `stderr`，文件描述符为 `2`。

将标准输出写入文件；如果文件已存在，会覆盖原内容：

```sh
echo "hello" > output.txt
```

将标准输出追加到文件末尾：

```sh
echo "world" >> output.txt
```

从文件读取标准输入：

```sh
sort < input.txt
```

将标准输出和标准错误分别保存：

```sh
command > output.log 2> error.log
```

将标准输出和标准错误写入同一个文件：

```sh
command > all.log 2>&1
```

管道 `|` 会把前一个程序的标准输出连接到后一个程序的标准输入：

```sh
sort file.txt | uniq -c | sort -nr | head -n 10
```

`tee` 可以一边把内容写入文件，一边继续传给下一个程序：

```sh
verbose-command | tee verbose.log | grep "CRITICAL"
```

## 10. 退出状态与命令组合

每个命令执行结束后都会返回退出状态。`0` 通常表示成功，非 `0` 表示失败：

```sh
echo "$?"
```

仅当前一条命令成功时，才执行后一条命令：

```sh
mkdir project && cd project
```

仅当前一条命令失败时，才执行后一条命令：

```sh
cd project || echo "project does not exist"
```

无论前一条命令是否成功，都继续执行下一条命令：

```sh
command1; command2
```

## 11. 变量与命令替换

定义和读取 Shell 变量时，等号两侧不能有空格：

```sh
name="Missing Semester"
echo "$name"
```

双引号会展开变量，单引号会保留字面内容：

```sh
echo "$name"
echo '$name'
```

`$(command)` 会执行命令，并用它的输出替换整个表达式：

```sh
echo "Today is $(date +%Y-%m-%d)"
```

创建带日期的备份文件：

```sh
cp notes.txt "notes_$(date +%Y-%m-%d).txt"
```

现代脚本应优先使用 `$()`，而不是旧式反引号，因为 `$()` 更清晰并且支持嵌套。

## 12. 条件判断与循环

使用 `test` 或 `[ ... ]` 判断文件是否存在：

```sh
if [ -f "notes.txt" ]; then
  echo "File exists"
else
  echo "File does not exist"
fi
```

> `[ ... ]` 中的空格不可省略；变量展开通常应放在双引号中。

依次处理多个值：

```sh
for file in *.md; do
  echo "$file"
done
```

只要条件命令成功，就持续执行循环体：

```sh
while command; do
  echo "command succeeded"
done
```

## 13. Shell 脚本基础

脚本第一行的 shebang 用于指定解释器：

```bash
#!/usr/bin/env bash
```

编写 Bash 脚本时，可以启用更严格的错误处理：

```bash
set -euo pipefail
```

- `-e`：命令失败时退出脚本。
- `-u`：使用未定义变量时报错。
- `-o pipefail`：管道中任意命令失败时，让整个管道返回失败。

常用的脚本参数：

- `$1`：第 1 个参数。
- `$2`：第 2 个参数。
- `$@`：所有参数，每个参数保持独立。
- `$#`：参数数量。

一个简单的文件检查脚本：

```bash
#!/usr/bin/env bash
set -euo pipefail

if [ -f "$1" ]; then
  echo "File exists: $1"
else
  echo "File does not exist: $1"
fi
```

添加执行权限并运行：

```sh
chmod +x check.sh
./check.sh notes.txt
```

建议使用 `shellcheck` 检查 Shell 脚本中的常见问题：

```sh
shellcheck check.sh
```

## 14. 参考资料

- [MIT Missing Semester 2026：课程概览 + Shell 入门](https://missing-semester-cn.github.io/2026/course-shell/)
