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

### `cd`：切换目录

```sh
cd /path/to/directory
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
