# 一、Linux 命令和SHELL概念

在计算机中，有很多概念需要重新理解一下。



- **命令行界面** (CLI) = 使用文本命令进行交互的用户界面
- **图形用户界面 (GUI)** = 使用图形界面进行交互
- **终端** (Terminal) = **TTY** = 文本输入/输出环境
- **控制台** (Console) = 一种特殊的终端
- **Shell** = 命令行解释器，执行用户输入的命令并返回结果



### 命令行界面CLI

命令行界面，通俗来讲，就是我们看到的那种满屏幕都是字符的界面。**用户主要使用命令来控制计算机。**

> 命令行界面（英语：Command-line Interface，缩写：CLI）
>
> 是在图形用户界面得到普及之前使用最为广泛的用户界面，它通常不支持鼠标，用户通过键盘输入指令，计算机接收到指令后，予以执行              
>
> —— 摘自 [Wikipedia](https://zh.wikipedia.org/wiki/%E5%91%BD%E4%BB%A4%E8%A1%8C%E7%95%8C%E9%9D%A2)



在图形化桌面出现之前，与 Unix 系统进行交互的唯一方式就是借助由 shell 所提供的文本命令行界面（command line interface，CLI）。

CLI 只能接受文本输入，也只能显示出文本和基本的图形输出。



#### 控制台终端Terminal

在 Linux 命令行界面模式中，开机后显示器出现的命令行界面（shell CLI）就叫终端，这种模式称作 Linux 控制台，因为它仿真了早期的硬接线控制台终端，而且是一种同 Linux系 统交互的直接接口。

大多数 Linux 发行版会启动5~6个（有时会更多）虚拟控制台（tty），虚拟控制台是运行在Linux系统内存中的终端会话。

你在一台计算机的显示器和键盘上就可以访问它们。



> tty和pts的区别
>
> https://zhuanlan.zhihu.com/p/97018747



**Ctrl +Alt 组合键配合 F1 或 F7** 来进入虚拟机控制台终端或图形界面。

命令行终端中，默认的背景色是黑色的，白色字体，但是这些特性都可以调整，使用 **setterm** 命令调整。

```shell
 # 设置背景色
 setterm -background  black 、 red 、 green 、 yellow 、 blue 、magenta 、 cyan 、 white
 # 设置前景色
 setterm -foreground  black 、 red 、 green 、 yellow 、 blue 、magenta 、 cyan 、 white
 # 交换背景色和前景色
 setterm -inversescreen  on 或 off 
 # 恢复默认
 setterm -reset

 setterm -store
 
```

UNIX 系统上的 terminfo 数据库用于定义终端和打印机的属性及功能，包括各设备（例如，终端和打印机）的行数和列数以及要发送至该设备的文本的属性

UNIX 中的几个常用程序都依赖 terminfo 数据库提供这些属性以及许多其他内容，其中包括 vi 和 emacs 编辑器以及 curses 和 man 程序。



tput 命令将通过 terminfo 数据库对您的终端会话进行初始化和操作。

通过使用 tput，您可以更改几项终端功能，如移动或更改光标、更改文本属性，以及清除终端屏幕的特定区域。

```bash
tput clear      # 清除屏幕
tput sc         # 记录当前光标位置
tput rc         # 恢复光标到最后保存位置
tput civis      # 光标不可见
tput cnorm      # 光标闪烁可见
tput cup x y    # 光标按设定坐标点移动

tput blink      # 文本闪烁
tput bold       # 文本加粗
tput el         # 清除到行尾
tput smso       # 启动突出模式
tput rmso       # 停止突出模式
tput smul       # 下划线模式
tput rmul       # 取消下划线模式
tput sgr0       # 恢复默认终端
tput rev        # 反相终端

# 文本加粗
bold=$(tput bold 2>/dev/null)
# 恢复默认终端
sgr0=$(tput sgr0 2>/dev/null)



# 获取当前shell
shell=$(echo $SHELL | awk 'BEGIN {FS="/";} { print $NF }')

echo "Detected shell: ${bold}$shell${sgr0}"

```







#### 图形化终端（终端模拟器）

但是在图形界面时，如果我也想使用命令行来操作 Linux 系统时，这样在图形界面中就需要 **终端模拟器（terminal-emulators）**，要想在桌面中使用命令行，关键在于终端模拟器。

可以把终端模拟器看作GUI中（in the GUI）的CLI终端，将虚拟控制台终端看作GUI以外（outside the GUI）的CLI终端。

在 Linux 发行版上，最好用的终端模拟器：

```shell
https://gnometerminator.blogspot.com/p/introduction.html
```



### 图形界面

图形用户界面，我们常见的 Windows 操作就是图形界面，用户主要使用图形界面来控制计算机。

命令行比图形界面在很多方面有一些优势，比如：我要把当前目录下的（包括嵌套的子目录）所有 `*.tpl` 文件的后缀名修改为 `*.blade.php` 。

在图形界面操作时，就不是那么方便了，使用命令行，只需要一句命令就可以搞定：

```shell
rename 's/\.tpl$/\.blade.php/' ./**/*.tpl
```

### POSIX

早期的Linux可谓是"狂野的西部"，各个公司不断推陈出新，将操作系统引往不同的发展方向。

### SHELL

Shell 是 Linux 下的命令交互程序，其实就是一个命令解释器。它用来接收用户输入的指令，传递给内核执行。

所以它可以被理解为内核外面的一层壳，用户通过它来与内核交互。

它虽然不是 Unix/Linux 系统内核的一部分，但它调用了系统核心的大部分功能来执行程序、建立文件并以并行的方式协调各个程序的运行。

因此，对于用户来说，shell 是最重要的实用程序，深入了解和熟练掌握 shell 的基本特性及其使用方法，是用好 Unix/Linux 系统的关键。

#### SHELL的分类

Linux 的 Shell 种类众多，常见的有：

- Bourne Shell（/usr/bin/sh或/bin/sh）

  是UNIX最初使用的 shell，而且在每种 UNIX 上都可以使用。Bourne Shell 在 shell 编程方面相当优秀，但在处理与用户的交互方面做得不如其他几种 shell。

  **在debian系操作系统中，sh指向dash；在centos系操作系统中，sh指向bash。**

  

- **Bourne Again Shell（/bin/bash）**

  - **Linux 默认的 shell ，它是 Bourne Shell 的扩展。 与 Bourne Shell 完全兼容，并且在 Bourne Shell 的基础上增加了很多特性，可以提供命令补全，命令编辑和命令历史等功能。**
  - **基本上现在各大Linux发行版都是使用 bash 做为默认 shell**

  

- C Shell（/usr/bin/csh）

  是一种比 Bourne Shell 更适合的变种 Shell，它的语法与 C 语言很相似。

- K Shell（/usr/bin/ksh）

  集合了 C Shell 和 Bourne Shell 的优点并且和 Bourne Shell 完全兼容。

- **[Elvish](https://elv.sh/)** 清华的大佬用go语言写的shell

- nushell 

  一款用 rust 语言写的 shell 

  https://www.nushell.sh/zh-cn/book/introduction.html

  https://github.com/nushell/nushell
  
- zsh 

  - 苹果已经[宣布](https://support.apple.com/en-us/HT208050)，从 macOS 10.15 Catalina 开始，系统的默认 Shell 为`zsh`。

  - [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)

    - 作为 zsh 最出名的配置框架。配置 zsh 甚至可以说 oh-my-zsh 和 非 oh-my-zsh。

      自动设置颜色部分。默认配置很完美，配色很干净。

      集成了大量实用的函数和主题（个人推荐 `ys` 主题），比较极端的用户甚至会使用 ramdom 主题，每次开启随机选择一个，保证新鲜感。

      oh-my-zsh 管的东西太多了。oh-my-zsh 的各种插件里面基本上全是 aliases

  - [prezto](https://github.com/sorin-ionescu/prezto)

    oh-my-zsh 之外的另一个选择，或者说是他的的替代品。比 oh-my-zsh 轻量一点。

  - [zimfw](https://github.com/zimfw/zimfw)

    - 用 ruby 的 `erb` 模版引擎，编译产生最终配置文件。

      在 `zimrc` 里面配置启用的插件，然后编译产生 `~/.zshrc` 文件。每次修改更新都要重新编译，不过问题不大，**每天都在修改配置文件才是最大的问题**

      默认会开启 git 插件，注意把 git 插件禁用（我推荐把这个禁用），这个插件全是 git aliases。请仔细阅读代码再决定是否要使用这个插件。

      是时候将你的 oh-my-zsh 换成 zimfw 了，官網附上了 zim 跟其他 framework 的[速度比较](https://github.com/zimfw/zimfw/wiki/Speed)

- [fish](https://fishshell.com/)



https://a-wing.top/shell/2021/05/05/new-shell.html

https://www.jkg.tw/p2876/

https://hiraku.tw/2020/02/5907/



这里演示用的是 Bash，也就是 Bourne Again Shell，由于易用和免费，Bash 在日常工作中被广泛使用。同时，Bash 也是大多数Linux 系统默认的 Shell。

在一般情况下，人们并不区分 Bourne Shell 和 Bourne Again Shell，所以，像  **#!/bin/sh**，它同样也可以改为 **#!/bin/bash**。



我们可以通过 /etc/shells 文件来査询 Linux 支持的 Shell。命令如下：

```shell
$ cat /etc/shells
/bin/sh
/bin/bash
/sbin/nologin
/bin/tcsh
/bin/csh


# 查看bash版本

# CentOS Linux release 7.6.1810
$ bash --version
GNU bash, version 4.2.46(2)-release (x86_64-redhat-linux-gnu)
Copyright (C) 2011 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

# Ubuntu 20.04.1 LTS
$ bash --version
GNU bash, version 5.0.17(1)-release (x86_64-pc-linux-gnu)
Copyright (C) 2019 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

```

**用户信息文件** /etc/passwd 的最后一列就是这个用户的登录 Shell。命令如下：

```shell
$ cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x: 1:1 :bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
...
```

可以看到，root 用户和其他可以登录系统的普通用户的登录 Shell 都是 /bin/bash，也就是 Linux 的标准 Shell，所以这些用户登录之后可以执行权限允许范围内的所有命令。

不过，所有的系统用户（伪用户）因为登录 Shell 是 /sbin/nologin，所以不能登录系统。

#### 守护进程

守护进程，也就是通常所说的 Daemon 进程，是 Linux 中的后台服务进程。周期性的执行某种任务或等待处理某些发生的事件。

Linux系统有很多守护进程，大多数服务都是用守护进程实现的。比如：像我们的tftp，samba，nfs等相关服务。

UNIX的守护进程一般都命名为*d的形式，如httpd，telnetd等等。



**守护进程不依赖于终端**

从终端开始运行的进程都会依附于这个终端，这个终端称为这些进程的控制终端。当控制终端被关闭时，相应的进程都会被自动关闭。

咱们平常写进程时，一个死循环程序，咱们不知道有ctrl+c的时候，怎么关闭它呀，是不是关闭终端呀。

也就是说关闭终端的同时也关闭了我们的程序，但是对于守护进程来说，其生命周期守护需要突破这种限制，它从开始运行，直到整个系统关闭才会退出，所以守护进程不能依赖于终端。



在Linux/Unix中，有这样几个概念：

- **进程组（process group）**：一个或多个进程的集合，每一个进程组有唯一一个**进程组ID**，即**组长进程的ID**。
- **会话（session）**：一个或多个进程组的集合，开始于用户登录，终止与用户退出，此期间所有进程都属于这个会话。一个会话一般包含一个**会话首进程、一个前台进程组和一个后台进程组**。
- **守护进程（daemon）**：Linux大多数服务都是通过守护进程实现的，完成许多系统任务如0号进程为调度进程，是内核一部分；1号进程为init进程,负责内核启动后启动Linux系统。守护进程不因为用户、终端或者其他的变化而受到影响。

当**终端接口检测到网络连接断开，将挂断信号（SIGHUP）发送给控制进程（会话期首进程）**。而挂断信号默认的动作是终止程序。如果会话期首进程终止，则该信号发送到**该会话期前台进程组**。

也就是说：ssh打开以后，bash等都是他的子程序，一旦ssh关闭，系统将所有**前台进程**杀掉。（**后台进程和守护进程不会被关闭**！！！）









#### shell 的类型和场景

由于使用场景的不同，Shell 被分为两个类型：

- `login` / `non-login`
- `interactive` / `non-interactive`

这两个类型影响的是 **Shell 的启动文件 (startup files)**。

当我们使用终端登录一台主机时，主机会为我们启动一个 Shell 进程，由于是登录以后启动的，所以是 login Shell。

其他情况的 Shell 就是 non-login 的，比如我登录以后，输入 `bash` 再启动一个 Shell，那么这个 Shell 就是 non-login 的。

```shell
# 举个简单的例子，我们在windows中使用终端工具ssh远程到一个Linux后，通常输入exit，会断开当前ssh连接。
# 如果我们连上去后，多输入几次bash，即多启动几个shell，然后每次输入exit其实是退出当前shell进程而已，并没有很快断开ssh连接
```

login Shell 会初始化一些针对整个登录会话的任务。

比如说，我希望我每次登录主机，就自动发一封邮件出去，那么这个任务就可以在 login Shell 的启动文件中完成。



### 命令

Linux 命令分为两种类型：

- 一类是 shell 内建命令（[Shell Builtin Commands](https://www.gnu.org/software/bash/manual/html_node/Shell-Builtin-Commands.html)）；
- 一类是应用程序命令。



应用程序命令，一般都会有相应的二进制可执行文件，通常存在 /bin , /usr/sbin/ , /usr/bin 等目录中。

shell 通过读取 $PATH 这个环境变量来查找应用程序执行路径。

通过 **type** 命令来查看命令是 shell 内建命令，还是二进制程序（如果是二进制可执行文件，还能打印出所在路径）。


  ```shell
$ type ls
ls is aliased to `ls --color=auto'
$ type pwd
pwd is a shell builtin
$ type w
w is /usr/bin/w
$ type find
find is /usr/bin/find
  ```

通过 **whereis** 命令来查看二进制文件的存放路径。

- 交互式（Interactive）：解释执行用户的命令，用户输入一条命令，Shell就解释执行一条。
- 批处理（Batch）：用户事先写一个 Shell 脚本(Script)，其中有很多条命令，让Shell一次把这些命令执行完。



#### 冒号

在shell中，冒号“:”是一个内建（builtin）命令，格式如下：

```
: [arguments]
```

冒号命令本身没什么副作用，使用场景有限，一般用于参数扩展，有以下几种用法：

```shell
${parameter:-word}             # 如果parameter没有设置或者为空，替换为word；否则替换为parameter的值。
${parameter:+word}             # 如果parameter没有设置或者为空，不进行任何替换；否则替换为word。
${parameter:=word}             # 如果parameter没有设置或者为空，把word赋值给parameter。最终替换为parameter的值。
${parameter:?word}             # 如果parameter没有设置或者为空，把word输出到stderr，否则替换为parameter的值。
${parameter:offset}            # 扩展为parameter中从offset开始的子字符串。
${parameter:offset:length}     # 扩展为parameter中从offset开始的长度不超过length的字符。
```

#### eval命令

在shell中，内建（builtin）命令eval，格式如下：

```bash
eval [arg ...]
```

eval命令首先读取其参数值，然后把它们连接成一个命令并执行这个命令，这个命令的退出状态即eval的退出状态，如果没有指定参数，其退出状态为0。

args 参数们会被拼接成一个命令，然后被读取并执行。



当我们在命令行前加上eval时，shell就会在执行命令之前扫描它两次。eval命令将首先会先扫描命令行进行所有的置换，然后再执行该命令。

该命令适用于那些一次扫描无法实现其功能的变量。该命令对变量进行两次扫描。

```
$ foo="uname | grep Linux"
$ uname | grep Linux
Linux
$ $foo
uname: extra operand ‘|’
Try 'uname --help' for more information.
$ eval $foo
Linux
```









### SHELL脚本

SHELL 脚本，其实就是将一大堆可执行命令放在一个文本文件中，其中也可以包含一些逻辑判断，循环遍历等，就类似一种批处理。



#### 脚本的执行

shell脚本有种执行方式：

- bash ScriptName.sh 或 sh ScriptName.sh 

  这种方式执行，脚本中可以没有执行权限，也可以没指定解释器。

- ./ScriptName.sh 或  /path/ScriptName.sh

  这种方式执行，需要脚本有可执行权限，需要在脚本中指定解释器。

- source test.sh    或  .  test.sh

  source 的意思是读入或加载指定的 shell 脚本文件，然后依次执行其中的所有语句。当在脚本中调用其他脚本时，通常使用 source 命令，因为这样子脚本是在父脚本的进程中执行的（其他方式都会启动新的进程执行脚本），因此，**使用这种方式可以将子脚本中的变量值或函数等返回值传递到当前父脚本中使用。这是最重要的区别**。

```shell
# 其实就是把 echo 'hello,fengzhao' 这行命令放到文本文件中，调用 shell 解释器来执行里面的命令

root@vpsServer:~# cat test.sh 
echo 'hello,fengzhao'
root@vpsServer:~# 
root@vpsServer:~# sh test.sh 
hello,fengzhao
root@vpsServer:~# 
root@vpsServer:~# bash test.sh 
hello,fengzhao
root@vpsServer:~# 
root@vpsServer:~# source test.sh 
hello,fengzhao
root@vpsServer:~# 
root@vpsServer:~# . test.sh
hello,fengzhao
root@vpsServer:~# 

# test2中把pwd命令执行结果赋给变量home_dir，用bash执行是起新进程执行的，所以无法获取其变量值。
# 用source执行，当前shell可以读到其返回值，并且立马生效。
# 在实际生产中应用场景，比如我们修改了一些系统配置，想立马生效，就使用source来执行一下。
root@vpsServer:~# echo home_dir=`pwd` > test2.sh
root@vpsServer:~# bash test2.sh 
root@vpsServer:~# echo $home_dir
root@vpsServer:~# source  test2.sh 
root@vpsServer:~# echo $home_dir
/root
root@vpsServer:~# 

```



### 变量

**变量是暂时存储数据的地方及标记，所存储的数据位于内存空间中，通过正确的调用内存中变量的名字可以取出其变量值。**

使用 **$VARIABLES** 或 **${VARIABLES}** 来引用变量。应用程序运行时通过读取环境变量。



根据变量的作用范围，变量的类型可以分为两类：环境变量（全局变量）和普通变量（局部变量）。

- 环境变量：可以在创建它们的 shell 及其派生出来的任意子进程 shell 中使用，环境变量又分为用户自定义环境变量和 bash 内置环境变量。
- 普通变量：只能在创建他们的 shell 函数内和 shell 脚本中使用。普通变量一般由开发者在开发脚本时创建。

根据变量的生命周期，可以分为两类：

- 永久的：需要修改配置文件，变量永久生效。（这种变量需要在文件中声明）
- 临时的：使用 `export` 命令声明即可，变量在关闭 shell 时失效。（这种变量在命令或在脚本中声明，用的比较多）

http://c.biancheng.net/view/773.html







```shell
# 变量声明，变量名大写，变量值用引号括起来，防止值中有空格

# 单引号声明变量 NAME='VALUE'  单引号不能识别特殊语法，即raw string
# 双引号声明变量 NAME="VALUE"  双引号不能识别特殊语法，可以实现变量插值

# 单引号变量，raw string
root@vpsServer:~# NAME='fengzhao'
root@vpsServer:~# echo ${NAME}
fengzhao
root@vpsServer:~#

# 单引号变量，raw string
root@vpsServer:~# NAME2='${NAME}'
root@vpsServer:~# echo ${NAME2}
${NAME}
root@vpsServer:~#

# 双引号变量
root@vpsServer:~# NAME3="${NAME}"
root@vpsServer:~# echo ${NAME3}
fengzhao
root@vpsServer:~#
```



#### 环境变量

环境变量是未在当前进程中定义，而从父进程中继承而来的变量。例如环境变量 `HTTP_PROXY` ，它定义了互联网连接应该使用哪个代理服务器。

环境变量一般是值用 export 命令导出的变量，主要目的是用于控制计算机内所有程序的运行行为，比如：定义 shell 的运行环境等等。

```shell
# 在命令行中定义一个环境变量，这种设置的变量不会持久化，只能在当前shell中有效，退出即失效。
export VIRABLES='value'

# 将变量定义在 ~/.bashrc 文件中，每一个 non-login interactive shell 在启动时都会首先读入这个配置文件中的变量
# 将变量定义在 ~/.profile 文件中，每一个login shell 在登录时会读入 ~/.profile（一般在此文件中包含 .bashrc 文件）

# 查看
set
# 
 
```



```shell
# 这是 ~/.profile 文件，在 Ubuntu中叫  ~/.profile ，在 CentOS 中叫 ~/.bash_profile

# ~/.profile: executed by Bourne-compatible login shells.
  
if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

# User specific environment and startup programs
PATH=$PATH:$HOME/.local/bin:$HOME/bin
mesg n || true

```



```shell
# CentOS7中的 /etc/profile 文件

# 这是系统全局环境变量文件，登录后的函数和别名在/etc/bashrc文件中。
# 一般不要直接修改这个文件，除非你知道你在做什么，更好的办法是在 /etc/profile.d/ 中添加一个自己的文件 custom.sh 
# 这可以避免你添加的内容在系统升级时被覆盖掉。

# /etc/profile

# System wide environment and startup programs, for login setup
# Functions and aliases go in /etc/bashrc
# It's NOT a good idea to change this file unless you know what you
# are doing. It's much better to create a custom.sh shell script in
# /etc/profile.d/ to make custom changes to your environment, as this
# will prevent the need for merging in future updates.

# pathmunge大致的作用是：判断当前系统的PATH中是否有该命令的目录，如果没有，则判断是要将该目录放于PATH之前还是之后
pathmunge () {

    case ":${PATH}:" in
        
        *:"$1":*)
            ;;
        *)
            if [ "$2" = "after" ] ; then
                PATH=$PATH:$1
            else
                PATH=$1:$PATH
            fi
    esac
}


if [ -x /usr/bin/id ]; then
    if [ -z "$EUID" ]; then
        # ksh workaround
        EUID=`/usr/bin/id -u`
        UID=`/usr/bin/id -ru`
    fi
    USER="`/usr/bin/id -un`"
    LOGNAME=$USER
    MAIL="/var/spool/mail/$USER"
fi

# Path manipulation
if [ "$EUID" = "0" ]; then
    pathmunge /usr/sbin
    pathmunge /usr/local/sbin
else
    pathmunge /usr/local/sbin after
    pathmunge /usr/sbin after
fi

HOSTNAME=`/usr/bin/hostname 2>/dev/null`
HISTSIZE=1000
if [ "$HISTCONTROL" = "ignorespace" ] ; then
    export HISTCONTROL=ignoreboth
else
    export HISTCONTROL=ignoredups
fi

export PATH USER LOGNAME MAIL HOSTNAME HISTSIZE HISTCONTROL

# By default, we want umask to get set. This sets it for login shell
# Current threshold for system reserved uid/gids is 200
# You could check uidgid reservation validity in

if [ $UID -gt 199 ] && [ "`/usr/bin/id -gn`" = "`/usr/bin/id -un`" ]; then
    umask 002
else
    umask 022
fi

for i in /etc/profile.d/*.sh /etc/profile.d/sh.local ; do
    if [ -r "$i" ]; then
        if [ "${-#*i}" != "$-" ]; then
            . "$i"
        else
            . "$i" >/dev/null
        fi
    fi
done

unset i
unset -f pathmunge

```





#### bash 环境变量





## 数学运算

在Bash shell环境中，可以利用 let 、 (( )) 和 [] 执行基本的算术操作。而在进行高级操作时，expr 和 bc 这两个工具也会非常有用。

可以用普通的变量赋值方法定义数值，这时它会被存储为字符串。

```bash
#!/bin/bash
no1=4;
no2=5;
let result=no1+no2
echo ${result}

# 自加操作
let no1++
```







## 命令历史



bash shell 有一个很有用的特性，那就是命令历史。

当前登陆用户在终端进行操作时，该用户操作的历史命令会被记录在内存缓冲区中，使用 history 命令可以列出历史命令。

当关闭终端会话或者会话退出时时，当前用户运行过的所有命令并写入当前用户的命令历史记录文件（~/.bash_history）。

如果是 zsh，在记录在 ~/.zsh_history 文件中。







**命令历史一般都有很重要的作用，用来复盘查看以前执行过的命令，其实就是操作记录。所以一般入侵者，入侵离开之前，最后一步就是清理命令历史。**



```shell
# history 命令被用于列出以前执行过的命令

# 在 oh-my-zsh 中。~/.oh-my-zsh/lib/history.zsh 这个脚本定义了一个函数 omz_history 封装 history,也可以用来查看命令历史。

# 1．可以按一下上＼下方向键，命令行就会显示相对于当前命令的上一条或下一条历史记录．

# 2．和方向键相同功能的就是组合键Ctrl+ p （前面执行过的命令）,Ctrl +n（后面执行过的命令）．

# 3．上面两个都是相对于当前命令查询上一条或者下一条命令的历史记录．如果搜索命令历史记录，

# 就用 Ctrl+ r 组合键进入历史记录搜寻状态，然后，键盘每按一个字母，当前命令行就会搜索出命令历史记录．


```



### 命令历史的相关变量

**BASH：相关的环境变量（ubuntu一般都在~/.bashrc中定义，centos一般都在/etc/profile中定义）**



```shell
# HISTSIZE：命令历史记录的最大条数。（内存缓冲区中），默认是1000
# HISTFILE：命令历史文件存放路径。默认是 ~/.bash_history
# HISTFILESIZE：命令历史文件记录的历史命令条数。默认是2000
# HISTCONTROL：控制命令历史的记录方式。默认是ignorespace。如果想要让命令
#   ignoredups  忽略重复（连续且完全相同）的命令。
#   ignorespace 忽略以空白开头的命令，命令前面带空格
#   ignoreboth  表示以上两者都生效。
HISTTIMEFORMAT="%F %T"
# 这个值定义命令历史格式，一般设置成如下%F %T，可以方便的查看命令执行时间 



# 对于centos7，默认的命令历史命令参数都存在/etc/profile中，先查找相关参数的默认值


[root@localhost ~]# egrep -R "HISTSIZE|HISTFILE|HISTFILESIZE|HISTCONTROL|HISTFORMAT" /etc/

/etc/profile:HISTSIZE=1000
/etc/profile:if [ "$HISTCONTROL" = "ignorespace" ] ; then
/etc/profile:    export HISTCONTROL=ignoreboth
/etc/profile:    export HISTCONTROL=ignoredups
/etc/profile:export PATH USER LOGNAME MAIL HOSTNAME HISTSIZE HISTCONTROL
/etc/sudoers:Defaults    env_keep =  "COLORS DISPLAY HOSTNAME HISTSIZE KDEDIR LS_COLORS"
```





**显示历史命令** **（bash和zsh通用）**

history  ：显示全部历史命令

history n ：显示最后n条历史命令

history -c ：清空历史命令（清空当前所有的命令历史）

history -a : 手动追加会话缓冲区的命令至历史命令文件中。（即不退出当前会话）





**快捷操作（bash和zsh通用）**

!# : 调用命令历史中的第#条命令

!string ： 调用命令历史中的最近一条中以string开头的命令。

!! : 调用命令历史中上一条命令



### 命令历史清理

有时，我们使用敏感信息运行bash命令。 例如，运行一个shell脚本并传递密码作为命令行参数。 在这种情况下，出于安全原因，最好清除bash历史记录。

如果要完全删除bash历史记录，可以运行`history -c`命令。



如果要从bash历史记录中删除特定条目，请使用`history -d offset`命令。 偏移量是`history`命令输出的行号。

```shell

[root@li1176-230 ~]# ls -1 | wc -l
3
[root@li1176-230 ~]# history
    1  history
    2  ls
    3  cd
    4  ls -1 | wc -l
    5  history
[root@li1176-230 ~]# history -d 4
[root@li1176-230 ~]# history
    1  history
    2  ls
    3  cd
    4  history
    5  history -d 4
    6  history
[root@li1176-230 ~]#
```









## SHELL脚本



#### SHELL脚本的执行

当 SHELL 以非交互式的方式执行时，它会先查找环境变量 ENV ，是











### IO重定向和管道

在 Unix 中，一切皆文件。有 `普通文件`、`目录文件`、`链接文件`和`设备文件`。 然而，进程访问文件数据必须要先 “打开” 这些文件。

内核为了跟踪某个进程打开的文件，则用一个个`文件描述符`组成了一个`打开文件表`。



命令行运行的过程就是通过一些指令来处理某些数据或文件。

程序 = 指令 + 数据

读入数据：input

输出数据：output



文件描述符：每一个打开的文件，都有一个 fd（file descriptor）

文件描述符是与一个打开的文件或数据流相关的整数，文件描述符 0,1,2 是 Linux 系统预留的

- 标准输入：keyboard（键盘），文件描述符用0表示。

标准输入：keyboard（键盘），文件描述符用`0`表示。

- 标准输出：monitor（监视器），文件描述符用`1`表示。
- 标准错误：monitor（监视器），文件描述符用`2`表示。



###### IO重定向：改变标准位置

- **标准输出重定向：一般是把程序运行结果重定向到文件中。**

  - command > new_position     覆盖重定向：覆盖文件，多次执行后，文件中只保留最后一次执行结果。

  - command >> new_position   追加重定向：追加文件，多次执行，每次都在文件中追加执行结果。

  - set -C ： 禁止将内容覆盖重定向到已有文件中。当这个开启后，不允许直接对已有文件进行覆盖重定向。

  - 强制覆盖：command >| new_position ，不管有没有设置 set 。

    set +C :   打开之后，可以进行覆盖重定向。

- **标准错误重定向：把错误输出流进行重定向**

  - command 2> new_position       覆盖
  - command 2>> new_position     追加

- **在一次命令执行过程中，标准输出和标准错误各自重定向至不同位置**：

  - 如果成功了，后面是空，如果失败了，前面是空
  - command   >   /path/file.out         2>  /path/file.error

- **将标准输出和标准错误重定向到同一个位置：**

  command  &>   /path/file.out       追加

  command  &>>   /path/file.out     覆盖

  特殊用法： command  >   /path/file.out   2> &1







### cat命令



**预备知识**

用一个单行命令将标准输入和文件中的数据合并，通常的解决办法是将`stdin`重定向到文件中，再将两个文件拼接在一起。更方便的做法是使用 `cat` 命令。



**实战**

`cat` 命令是一个日常经常使用的，cat 本身表示 concatenate （拼接）：

```shell
# cat 命令的help文档中是这么描述的: 

# concatenate files and print on the standard output
# Concatenate FILE(s) to standard output.
# With no FILE, or when FILE is -, read standard input.

# 拼接文件并将其输出到标准输出，如果参数不是文件，则从标准输入读取


# 所以cat命令的常规用法是这样的，打开两个文本文件，拼接后输出到标准输出

cat file1.txt  file2.txt 	

# 如果cat后面跟的文件不存在，则报错：cat: file3.txt: No such file or directory  
cat file3.txt 

# 如果空输入一个cat，则光标一直闪烁，等待输入，输入一段字符，然后回车，则表示这段输入结束，cat就将其输出到标准输出。


# 输入下面的命令后，光标闪烁，一直在等输入，然后依次输入1234回车换行，再输入5678，再 ctr+c 终止这次输入
# cat > file  这个命令的本质是从标准输入中读取，然后将其重定向到文件。
root@pve:~# cat > file3.txt 
1234
5678
^C
root@pve:~# cat file3.txt
1234
5678
root@pve:~# 




```







### 数组和关联数组

Bash 的数组，其元素的个数没有限制。数组的索引由 0 开始，但不一定要连续(可以跳号)。索引也可以是算术表达式。bash仅支持一维数组。

关联数组从 `Bash4.0` 开始引入。

Bash的数组，其元素的个数没有限制。数组的索引由0开始，但不一定要连续(可以跳号)。索引也可以算术表达式。bash仅支持一维数组。



```shell
#!/bin/bash

# 数组用法
# 声明数组：
# 1、等号两边不要有空格
# 2、数组元素间以空格分隔
# 3、数组元素一般都是基本类型:数字，字符串等
# 4、数组索引从 0 开始
array_var=(1 2 3 4 5 6 'demo')

# 按下标取数组中的元素：demo
echo  ${array_var[6]) 



# 以清单形式打印数组中的所有值


# 数组遍历方法一
for var in ${array_var[@]};
do
	echo $var
done


# 数组遍历方法二
for(( i=0;i<${#array[@]};i++)) do
#${#array[@]}获取数组长度用于循环
echo ${array[i]};
done;




# 关联数组
# 在关联数组中，索引下标可以是任意文本，而在普通数组中，只能用整数做数组索引。

# 声明数组

declare -A ass_array

# 赋值方法1
ass_array=( [index1]=value1 [index2]=value2)
# 赋值方法2
ass_array[index1]=value1
ass_array[index2]=value2
```







## shell 自动补全

在Bash中输入命令时，可以使用 `Tab` 键根据已输入的字符自动补全**路径名**、**文件名**和**可执行程序**；

[bash-completion](https://github.com/scop/bash-completion) 是一组利用了shell可编程特性实现自动补全功能的shell函数。



自动补全依赖于Bash的内置命令`complete`、`compgen`和在`/etc/bash_completion.d/`路径下创建的自动补全脚本；

bash提供了一个`complete`内建命令，它的用途是规定参数怎么自动补全。 有了它，第三方开发的命令就可以根据自己的实际情况指定自动提示功能了！

[参考](https://jasonkayzk.github.io/2020/12/06/Bash%E5%91%BD%E4%BB%A4%E8%87%AA%E5%8A%A8%E8%A1%A5%E5%85%A8%E7%9A%84%E5%8E%9F%E7%90%86/)



## Shell 通配符扩展

Shell 接收到用户输入的命令以后，会根据空格将用户的输入，拆分成一个个词元（`token`）。

这种特殊字符的扩展，称为模式扩展（globbing）。其中有些用到通配符，又称为通配符扩展（wildcard expansion）。Bash 一共提供八种扩展。

- 波浪线扩展
- `?`字符扩展
- `*`字符扩展
- 方括号扩展
- 大括号扩展
- 变量扩展
- 子命令扩展
- 算术扩展



Bash 是先进行扩展，再执行命令。因此，扩展的结果是由 Bash 负责的，与所要执行的命令无关。

命令本身并不存在参数扩展，收到什么参数就原样执行。这一点务必需要记住。

模块扩展的英文单词是`globbing`，这个词来自于早期的 Unix 系统有一个`/etc/glob`文件，保存扩展的模板。

后来 Bash 内置了这个功能，但是这个名字就保留了下来。

**模式扩展与正则表达式的关系是，模式扩展早于正则表达式出现，可以看作是原始的正则表达式。它的功能没有正则那么强大灵活，但是优点是简单和方便。**



Bash 允许用户关闭扩展：

```bash
$ set -o noglob
# 或者
$ set -f
123
```

下面的命令可以重新打开扩展：

```bash
$ set +o noglob
# 或者
$ set +f
```



### 波浪线扩展

波浪线 ~ 会自动扩展成当前用户的主目录：

```shell
$ echo ~
/home/me

# ~/dir 表示扩展成主目录的某个子目录，dir是主目录里面的一个子目录名。
# 进入 /home/me/foo 目录
$ cd ~/foo

```



### 字符扩展

`?`字符代表文件路径里面的任意单个字符，不包括空字符。比如，`Data???` 匹配所有 Data后面跟着三个字符的文件名。

```shell
# 存在文件 a.txt 和 b.txt
$ ls ?.txt
a.txt b.txt

# 上面命令中，?表示单个字符，所以会同时匹配a.txt和b.txt。如果匹配多个字符，就需要多个?连用。
# 存在文件 a.txt、b.txt 和 ab.txt
$ ls ??.txt
ab.txt
```











# SHELL脚本学习笔记

Shell 是 Linux 下的命令交互程序，其实就是一个命令解释器。

它用来接收用户输入的指令，传递给内核进行执行。所以它可以被理解为内核外面的一层壳，用户通过它来与内核交互。

它虽然不是 Unix/Linux 系统内核的一部分，但它调用了系统核心的大部分功能来执行程序、建立文件并以并行的方式协调各个程序的运行。

因此，对于用户来说，shell 是最重要的实用程序，深入了解和熟练掌握 shell 的基本特性及其使用方法，是用好 Unix/Linux 系统的关键。

可以说，shell 使用的熟练程度反映了用户对 Unix/Linux 使用的熟练程度。



Shell脚本语言是实现Linux/UNIX系统管理及自动化[运维](https://cloud.tencent.com/solution/operation?from=20065&from_column=20065)所必备的重要工具， Linux/UNIX系统的底层及基础应用软件的核心大都涉及Shell脚本的内容。

每一个合格 的Linux系统管理员或运维工程师，都需要能够熟练地编写Shell脚本语言，并能够阅 读系统及各类软件附带的Shell脚本内容。

只有这样才能提升运维人员的工作效率，适 应曰益复杂的工作环境，减少不必要的重复工作，从而为个人的职场发展奠定较好的基础。





## 1、Linux 命令和 SHELL 基础

Linux 命令分为两种类型：

- 一类是 [**shell 内建命令**](https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html)；

- 一类是应用程序命令。应用程序命令，一般都会有相应的二进制可执行文件，通常存在 /bin , /usr/sbin/ , /usr/bin 等目录中。

  shell 通过读取 $PATH 这个环境变量来查找应用程序执行路径。



内部命令实际上是shell程序的一部分，其中包含的是一些**比较简单的linux系统命令**，这些命令由shell程序识别并在shell程序内部完成运行，通常在linux系统加载运行时shell就被加载并驻留在系统内存中。

内部命令是写在bash源码里面的，其执行速度比外部命令快，因为解析内部命令shell不需要创建子进程。比如：exit，history，cd，echo等。
有些命令是由于其**必要性**才内建的，例如cd用来改变目录，read会将来自用户（和文件）的输入数据传给Shell外亮。

```
bash,  :,  .,  [, alias, bg, bind, break, builtin, caller, cd, command, compgen, complete, compopt, continue, declare, dirs, disown, echo, enable, eval, exec, exit, export, false, fc, fg, getopts, hash, help, history, jobs, kill, let, local, logout, mapfile, popd, printf, pushd, pwd, read, readonly, return, set, shift, shopt, source, suspend, test, times, trap, true, type, typeset,  ulimit, umask, unalias, unset, wait - bash built-in commands, see bash(1)
```



**三、脚本语言**

**定义：**为了缩短传统的编写-编译-链接-运行（edit-compile-link-run）过程而创建的计算机编程语言。

**特点：**程序代码即是最终的执行文件，只是这个过程需要解释器的参与，所以说脚本语言与解释型语言有很大的联系。脚本语言通常是被解释执行的，而且程序是文本文件。

典型的脚本语言有，JavaScript，Python，shell等。

**其他常用的脚本语句种类**

- **PHP**是网页程序，也是脚本语言。是一款更专注于web页面开发（前端展示）的脚本语言，例如：Dedecms,discuz。PHP程序也可以处理系统日志，配置文件等，php也可以调用系统命令。

- **Perl**脚本语言。比shell脚本强大很多，语法灵活、复杂，实现方式很多，不易读，[团队协作](https://cloud.tencent.com/product/prowork?from=20065&from_column=20065)困难，但仍不失为很好的脚本语言，存世大量的程序软件。MHA高可用Perl写的

- **Python**，不但可以做脚本程序开发，也可以实现web程序以及软件的开发。近两年越来越多的公司都会要求会Python。





**Shell脚本与php/perl/python语言的区别和优势？**

shell脚本的优势在于处理操作系统底层的业务 （linux系统内部的应用都是shell脚本完成）因为有大量的linux系统命令为它做支撑。

2000多个命令都是shell脚本编程的有力支撑，特别是grep、awk、sed等。

例如：一键软件安装、优化、监控报警脚本，常规的业务应用，shell开发更简单快速，符合运维的简单、易用、高效原则。

PHP、Python优势在于开发运维工具以及web界面的管理工具，web业务的开发等。处理一键软件安装、优化，报警脚本。

常规业务的应用等php/python也是能够做到的。但是开发效率和复杂比用shell就差很多了。



通过 type 来查看命令是 shell 内建命令，还是二进制程序（如果是二进制可执行文件，还能打印出所在路径）。

``` shell 
[root@fengzhao ~]# type ls
ls is aliased to `ls --color=auto'
[root@fengzhao ~]# type pwd
pwd is a shell builtin
[root@fengzhao ~]# type w
w is /usr/bin/w
[root@fengzhao ~]# type find
find is /usr/bin/fi
```

通过 whereis 来查看二进制文件的存放路径。

``` shell
[root@fengzhao ~]# whereis find
find: /usr/bin/find
[root@fengzhao ~]# 
```
### 1.1、shell有两种执行命令的方式

- 交互式（Interactive）：解释执行用户的命令，用户输入一条命令，Shell就解释执行一条。
- 批处理（Batch）：用户事先写一个Shell脚本(Script)，其中有很多条命令，让Shell一次把这些命令执行完。

### 1.2、几种常见的 Shell

 Linux 发行版自带的标准 Shell 都是 [Bash shell](https://www.gnu.org/software/bash/)，是 BourneAgain Shell 的缩写，内部命令一共有 40 个。Linux 的默认命令行就是 Bash，我们的最多的也是这个。

一般日常使用 bash 基本上都够了，进阶可以试试 zsh。

 另一个强大的 Shell 就是 zsh，它比 bash 更强大，但是也更复杂，配置起来比较麻烦。

所以有个 [on-my-zsh](https://github.com/robbyrussell/oh-my-zsh/)，它大大简化了 zsh 的配置，一般通过包管理器安装 zsh，然后通过 git 安装 on-my-zsh：

```shell
$ git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
$ cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```

Shell脚本和编程语言很相似，也有变量和流程控制语句，但Shell脚本是解释执行的，不需要编译，Shell程序从脚本中一行一行读取并执行这些命令，相当于一个用户把脚本中的命令一行一行敲到Shell提示符下执行。

Unix/Linux上常见的Shell脚本解释器有 bash、sh、csh、ksh、dash  等，习惯上把它们称作一种Shell。



- oh-my-zsh 

- [prezto](https://github.com/sorin-ionescu/prezto)
- [zinit](https://github.com/zdharma-continuum/zinit)

### 1.3、查看操作系统的 Shell 

``` shell
$ echo $SHELL  # 查看当前使用的 shell
$ cat /etc/shells # 查看当前系统支持的 shell
$ bash   # 切换至 bash ，输入 zsh 切换至 zsh。
$ chsh -s /bin/zsh  # 修改当前用户的 shell
```

### 1.4、Shell 配置文件

- ~/.zshrc 和 ~/.bashrc：分别是当前用户的 bash 和 zsh 的配置文件，这个文件是用户级别的，当用户登陆打开终端后每一个shell进程生成时，执行的一组命令，包括设置别名，提示文本，颜色等设置。
- ~/.bash_history 和 ~/.zshhistory  记录用户运行的历史命令。



### 1.5 、Shell 脚本的运行方式

- 赋予脚本文件可执行权限，直接运行该脚本，系统靠文件第一行的 [shebang](https://blog.wolfogre.com/redirect/v3/A8gOfTBRYllgozADe6yKtmASAwM8Cv46xcXbEm5BCP5rCNCBBG4qO8VBCP5rCMX-UxBaGjsxEgMDPAr-OsXFWhYGO25BBhbcOyH9xTwGTQrFTcU) 来确定解释器。（解释器可以是 py，bash，perl）

  比如，以 ./startup.sh 这样直接运行。**这也是最普遍最常见的运行shell脚本方式。**

- 运行解释器，并将脚本文件名作为参数传入。

  比如，以 bash  startup.sh  这样运行

- 启动解释器，解释器从标准输入读取内容并执行（如果这个标准输入是用户键盘，那就是所谓的“交互式执行”）。

  比如，非常流行的直接运行网络上的脚本。

  ```shell
  # curl 参数
  -s 是slient或 quite mode模式，静默模式，不回显输出
  -S --show-error ，通常跟-sS这样一起使用，如果有报错则输出报错
  -L --location 通常是应对30x跳转
  
  
  # daocloud的设置镜像加速的脚本
  curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
  
  # rust官方推荐的安装脚本
  curl https://sh.rustup.rs -sSf | sh -s -- --help
  
  # 用国内的阿里云安装docker
  curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
  
  # 1. 先用curl访问下载脚本，后跟管道。把下载的输出做为管道后的命令的输出
  # 2. sh -s 用于从标准输入中读取命令，命令在子shell中执行
  # 3. 当sh -s 后面跟的参数,从第一个非 - 开头的参数，就被赋值为子shell的$1,$2,$3....
  
  ## 本质就是下载 set_mirror.sh 这个脚本，然后再执行 ./set_mirror.sh  http://f1361db2.m.daocloud.io
  ## 本质就是下载  https://get.docker.com 里面的脚本，然后执行
  
  #   $ curl -fsSL https://get.docker.com -o get-docker.sh
  #   $ sh get-docker.sh
  ```

- 使用 source shellscript.sh 或 . shellscript.sh 这种格式去运行。

source命令（从 C Shell 而来）是bash shell的内置命令。点命令，就是个点符号，（从Bourne Shell而来）是source的另一名称。它们是等价的。

source 的意思是读入或加载指定的 shell 脚本文件，然后依次执行其中的所有语句。

当在脚本中调用其他脚本时，通常使用 source 命令，因为这样子脚本是在父脚本的进程中执行的（其他方式都会启动新的进程执行脚本）



**因此，使用 source 这种方式可以将子脚本中的变量值或函数等返回值传递到当前父脚本中使用。这是与其他方式最重要的区别。**

所以我们在 /etc/profile 中声明一些环境变量时，想立马生效，就直接 source /etc/profile ，这样就对当前会话生效，而不需要重新登陆。

这种情况最多的用法就是 shell 脚本中调其他 shell 。在单个进程中执行的。





## 2、变量

所有的编程语言都利用变量来存放数据，以备随后使用或修改。变量是暂时存储数据的地方及标记，所存储的数据位于内存空间中。

和编译型语言不同，大多数脚本语言不要求在创建变量之前声明其类型。用到什么类型就是什么类型。在变量名前面加上一个美元符号就可以访问到变量的值。

默认情况下，bash shell是不会区分变量类型的，其它变成语言如（c、c++、java等）在定义一个变量时需要先定义变量的类型，常见的变量类型为整数、字符串、小数等。



**shell变量在定义时可以不用去指定，当然也可以使用declare显示定义变量的类型，一般情况下shell变量没有这个需求。**



通过正确的调用内存中变量的名字可以取出其变量值，使用 $VARIABLES 或 ${VARIABLES} 来引用变量。

> 注意，在shell中直接使用 $(COMMAND) 或  ````COMMAND` ``` 这种属于命令替换。不属于变量。
>

变量的类型可以分为两类：环境变量（全局变量）和普通变量（局部变量）。



- 环境变量：可以在创建它们的 shell 及其派生出来的任意子进程 shell 中使用，环境变量又分为用户自定义环境变量和 bash 内置环境变量。
  - 用户自定义环境变量
  - bash内置全局变量 (https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables)


- 普通变量（局部变量）：只能在创建他们的 shell 函数内和 shell 脚本中使用。普通变量一般由开发者在开发脚本时创建。



环境变量



**环境变量本身是字符串，这些字符串是存在OS内核中，还是存在于用户进程空间？是否有某个后台服务管理着这些环境变量？**

每个进程都有自己的环境变量，在C语言程序中可使用`外部变量(char **environ)`来访问环境，而库函数可允许进程去获取或修改自己环境的值。

环境变量这些字符串，是存在于**进程用户态空间**中，**由用户进程自己管理**，并没有专门管理环境变量的后台服务。在Bash环境下，环境变量的管理者也是Shell进程本身，没有其他服务。

（其实在系统内核中也存放了一份该进程的只读环境变量，这份环境变量的值为该进程从execve得到的字符串数组，并且，进程后续对环境变量的修改不会反应到这里）



某个进程对于环境变量做了一些增删改，会影响自身后续读取对应环境变量所得到的值，也会影响后续创建子进程的环境变量（子进程的环境变量默认继承父进程的环境变量，除非特殊指定子进程的环境变量数组，具体继承方式为execve系统调用传入的参数）。









查看变量的命令：

- set 输出所有变量，包括全局变量和局部变量
- env 仅显示全局变量
- echo $VARIABLES 打印VARIABLES变量值
- cat /proc/$PID/environ  查看某个进程运行时的环境变量
- `export` 命令显示当前系统所有用户自定义的所有环境变量

### 2.1、自定义环境变量

自定义环境变量有如下三种方法：

```shell
# 给变量赋值，并导出变量，注意等号之间不能有空格
fengzhao@fengzhao-pc:~$ VIRABLES=value; export VIRABLES
fengzhao@fengzhao-pc:~$ echo $VIRABLES
value
fengzhao@fengzhao-pc:~$

# 一句命令完成变量定义
fengzhao@fengzhao-pc:~$ export VIRABLES2=value2
fengzhao@fengzhao-pc:~$ echo $VIRABLES2
value2
fengzhao@fengzhao-pc:~$

# 使用 declare 命令定义变量
fengzhao@fengzhao-pc:~$ declare -x VIRABLES3=value3
fengzhao@fengzhao-pc:~$ echo $VIRABLES3
value3
fengzhao@fengzhao-pc:~$

# 把命令的结果赋值给某个变量，使用 VIRABLES="$(pwd)" 和 VIRABLES=`pwd` 两种方式
fengzhao@fengzhao-pc:~$ DIRPATH="$(pwd)"
fengzhao@fengzhao-pc:~$ echo $DIRPATH
/home/fengzhao
fengzhao@fengzhao-pc:~$
fengzhao@fengzhao-pc:~$ BASEPATH=`basename /home/fengzhao`
fengzhao@fengzhao-pc:~$ echo $BASEPATH
fengzhao
fengzhao@fengzhao-pc:~$

```



#### 变量声明关键字

- declare
  - declare命令是bash的一个内建命令，它可以用来声明shell变量，设置变量的属性（Declare variables and/or give them attributes）。
  - 该命令也可以写作typeset。虽然人们很少使用这个命令，如果知道了它的一些用法，就会发现这个命令还是挺有用的。
- let 



根据规范，所有环境变量的名字都定义成大写。在命令行中定义的变量仅在当前 shell 会话有效，一旦退出会话，这些变量就会失效，这样的就是普通变量。

如果需要永久保存，可以在 ~/.bash_profile 或 ~/.bashrc 中定义。每次用户登陆时，这些变量都将被初始化。或放到 /etc/pfofile 文件中定义，这是全局配置文件。



### 2.2、变量使用技巧

前面的是介绍变量定义的命令，并不严谨。

**有几条基本准测：变量定义中，key=value 中的等号两边不能有任何空格。常见的错误之一就是等号两边有空格。**

**定义变量时，有三种定义方式，即 key=value , key='value' , key="value" 这三种形式。**

- **不加引号，value中有变量的会被解析后再输出。**
```shell
fengzhao@fengzhao-pc:~$ DEMO1=1234$PWD
fengzhao@fengzhao-pc:~$ echo $DEMO1
1234/home/fengzhao
fengzhao@fengzhao-pc:~$
```

- **单引号，单引号里面是什么，输出变量就是什么，即使 value 内容中有命令和变量时，也会原样输出。**（适用于显示字符串，即 raw string ）
``` shell
fengzhao@fengzhao-pc:~$ DEMO2='1234$PWD'
fengzhao@fengzhao-pc:~$ echo $DEMO2
1234$PWD
fengzhao@fengzhao-pc:~$
```
- **双引号，输出变量时引号中的变量和命令和经过解析后再输出。(适用于字符串中附带有变量内容的定义)**
``` shell
fengzhao@fengzhao-pc:~$ DEMO4="1234$(pwd)"
fengzhao@fengzhao-pc:~$ echo ${DEMO4}
1234/home/fengzhao
fengzhao@fengzhao-pc:~$

fengzhao@fengzhao-pc:~$ DEMO5="1234$DEMO4"
fengzhao@fengzhao-pc:~$ echo ${DEMO5}
12341234/home/fengzhao
fengzhao@fengzhao-pc:~$

```

- **反引号，一般用于命令，要把命令执行后的结果赋给变量**

```shell
root@vpsServer:~# echo `date`
Tue Apr 7 21:26:16 CST 2020
root@vpsServer:~#
root@vpsServer:~# a=`date`
root@vpsServer:~# echo ${a}
Tue Apr 7 21:26:25 CST 2020
root@vpsServer:~#
# 第二种办法
root@vpsServer:~# a=$(date)
root@vpsServer:~# echo $a
Tue Apr  7 21:40:53 CST 2020
```

- **变量合并，多个变量合并在一起组成一个变量**

```shell
SOFRWARE_NAME="MySQL"
VERSION="5.7.26"

SOFTWARE_FULLNAME="${SOFTWARE_NAME}-${VERSION}.tar.gz"
echo ${SOFTWARE_FULLNAME}

MySQL-5.7.26.tar.gz

```

- **变量引用**

```shell
在引用变量的时候，一般用 ${VIRABLE_NAME}，这是一个好习惯。用大括号把$符号后面的变量名括起来。
```



### 2.3、常用环境变量

环境变量是操作系统中的软件运行时的一些参数，环境变量一般是由变量名和变量值组成的键值对来表示。

应用程序通过读取变量名来获取变量值。**通过和设置环境变量，可以调整软件运行时的一些参数。**

最著名的操作系统变量就是 PATH 。在 windows 和 linux 都存在这个环境变量。它表示在命令行中执行命令时的查找路径。

在 Linux 命令行中，可以通过 `echo $VARIABLENAME` 命令来查看变量值。



常用环境变量

| 环境变量名称    | 变量含义                                                     |      |
| --------------- | ------------------------------------------------------------ | ---- |
| $PATH           | 冒号分隔的一组目录名，shell用它来搜索命令。它决定了shell将到哪些目录中寻找命令或程序(分先后顺序) |      |
| $HOME           | 当前用户主目录，用户家目录                                   |      |
| $UID            | 当前用户的UID号，root用户的UID是0                            |      |
| $IFS            | 用来分隔字段的一组字符，例如空格、水平制表符、换行符，在shell扩展中用于分隔单词。 |      |
| $HISTSIZE       | 命令历史记录条数                                             |      |
| $HISTTIMEFORMAT | 命令历史时间格式  一般设置为" %F %T 'whoami'"                |      |
| $LOGNAME        | 当前用户的登录名                                             |      |
| $SHELL          | 前用户Shell类型                                              |      |
| $LANGUGE        | 语言相关的环境变量，多语言可以修改此环境变量                 |      |
| $MAIL           | 当前用户的邮件存放目录                                       |      |
| $PS1            | 基本提示符，就是命令行终端中的 prompt ，对于root用户是#，对于普通用户是\$ |      |

[参考](https://blog.csdn.net/iEearth/article/details/52694106)






### 2.4、shell 中特殊且重要的变量

在 shell 中存在一些特殊的变量。例如：$0，$1，$2，$3... $n，$#，$*，$@ 等。这些是特殊的位置参数变量。

运行 Shell 脚本文件时我们可以给它传递一些参数，这些参数在脚本文件内部可以使用$n的形式来接收，例如，$1 表示第一个参数，$2 表示第二个参数，依次类推。



同样，在调用函数时也可以传递参数。Shell 函数参数的传递和其它编程语言不同，没有所谓的形参和实参，在定义函数时也不用指明参数的名字和数目。

换句话说，定义 Shell 函数时不能带参数，但是在调用函数时却可以传递参数，这些传递进来的参数，在函数内部就也使用$n的形式接收，例如，$1 表示第一个参数，$2 表示第二个参数，依次类推。

这种通过`$n`的形式来接收的参数，在 Shell 中称为**位置参数**。

**在讲解变量的命名时，我们提到：变量的名字必须以字母或者下划线开头，不能以数字开头；但是位置参数却偏偏是数字，这和变量的命名规则是相悖的，所以我们将它们视为“特殊变量”。**

要从命令行，函数或脚本传递参数时，就需要使用位置变量参数。

例如，经常会有一些脚本，在执行该脚本的时候，会传一些参数来控制服务的运行方式，或者启动关闭等命令的参数。

在脚本里面，就使用这些变量来取执行的时候传递的参数。

| 变量值 | 含义                                                         |
| ------ | ------------------------------------------------------------ |
| ${0}   | 当前执行的 shell 脚本文件名。如果执行时包含路径，那么就包含脚本路径。 |
| ${n}   | 当前执行的 shell 脚本所有传递的第 n 个参数（参数以空格分开），如果 n>9 ，要用大括号引起来${10} |
| ${#}   | 当前执行的 shell 脚本传递的参数总个数。                      |
| ${*}   | 当前执行的 shell 脚本传递的所有参数。"$*" 表示将所有参数一起组成字符串。 |
| ${@}   | 也是获取所有参数，"$*" 表示将所有参数视为一个一个的字符串。  |





```shell
#!/bin/bash

###############################################################################
#
#  Copyleft (C) 2020 FengZhao. All rights reserved.
#   FileName：demo.sh
#   Author：FengZhao
#   Date：2020-02-18
#   Description：可以传参多个文件名做为参数，检查每个文件是否包含 "foobar" 字符串，如果没有，则在行尾加上 "# foobar"
#
###############################################################################

# Echo start time
echo "Starting program at $(date)"

echo "Running program $0 with $# arguments with pid $$"

for file in "$@"; do
        grep foobar "$file" > /dev/null 2>&1

        if [[ "$?" -ne 0]]; then
                echo "File $file does not have any foobar , add one"
                echo "# foobar" >> "#file"
        fi
done


```



``` shell
# 第一行打印执行该脚本时传递的前 15 个参数
# 第二行打印执行该脚本时传递的总参数个数
# 第三行打印执行该脚本时的文件名，此处是在脚本所在目录直接执行的。
# 第四行打印执行该脚本时传递的总参数个数。

fengzhao@fengzhao-pc:~$ cat demo.sh
#! /bin/bash
echo $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15}
echo $#
echo $0
echo $*
fengzhao@fengzhao-pc:~$ bash demo.sh  {a..z}
a b c d e f g h i j k l m n o
26
demo.sh
a b c d e f g h i j k l m n o p q r s t u v w x y z
fengzhao@fengzhao-pc:~$
```

```shell
# 这个脚本，判断如果接收的参数个数不等于 2 ，就打印提示并退出，当前参数满足要求，就都打印参数。

fengzhao@fengzhao-pc:~$ cat demo2.sh
#! /bin/bash
[ $# -ne 2 ] && {
        echo "USAGE $0 must two args"
        exit 1
}
echo $1 $2
fengzhao@fengzhao-pc:~$ bash demo2.sh
USAGE demo2.sh must two args
fengzhao@fengzhao-pc:~$ bash demo2.sh  arg1
USAGE demo2.sh must two args
fengzhao@fengzhao-pc:~$ bash demo2.sh  arg1  arg2
arg1 arg2
fengzhao@fengzhao-pc:~$


```

**生产常用代码段**

生产中，在调一些脚本的时候，经常会对传参进行判断，并执行脚本中相应的函数。下面看一段 openresty（/etc/rc.d/init.d/openresty） 中的代码片段。这个脚本在执行的时候，可以接各种参数，如果匹配到下面这些参数，直接执行相应的函数

``` shell
 case "$1" in
      start)
          rh_status_q && exit 0
          $1
          ;;
      stop)
          rh_status_q || exit 0
          $1
          ;;
      restart|configtest)
          $1
          ;;
      reload)
          rh_status_q || exit 7
          $1
          ;;
      force-reload)
         force_reload
         ;;
     status)
         rh_status
         ;;
     condrestart|try-restart)
         rh_status_q || exit 0
         ;;
     *)
         echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|configtest}"
         exit 2
 esac

```



### 2.5、SHELL 进程特殊状态变量

Linux shell 中存在一类特殊的进程状态变量。可以在命令中使用，也可以在脚本中使用。

| 变量 | 含义                                                         |
| ---- | ------------------------------------------------------------ |
| $?   | 获取上一个命令的执行状态返回值（0为成功，非0为失败），可以在脚本中自定义。 |
| $$   | 获取当前执行的 shell 脚本的进程号（PID）                     |
| $!   | 获取上一个在后台工作的进程的进程号                           |
| $_   | 获取在此之前执行的命令或脚本的最后一个参数                   |

**<font color=#FF0000 >$? 变量常用场景</font>**

在 Linux 命令行中，执行一个复杂的命令或者没有输出的命令时，可以通过 echo $? 来打印这个命令是否执行成功。这个返回值的常规用法如下：

- 判断命令，脚本或函数等程序是否执行成功。
- 若在脚本中调用 "exit 数字"，则会把这个数字返回给 $? 。
- 若是在函数中，调用"return 数字"把这个数字返回给 $? 。

```shell
# demo3.sh ，当执行这个脚本时，判断传参数量是否等于2，如果不等于2，则执行 echo 语句，并且 exit 退出，返回 15 给 $? 
#! /bin/bash
[ $# -ne 2 ] && {
	echo "must two arguments"
    exit 15
}
[root@fengzhao ~]# ./demo3.sh
must two arguments
[root@fengzhao ~]# echo $?
15
[root@fengzhao ~]#


```

<font color=#FF0000 >**$\$变量常用场景**</font>

$$ 变量表示当前 shell 进程号。有时在执行定时任务时频率较快，不知道上一个脚本是否执行完毕。但是业务要求同一时刻必须只有一个脚本在执行。

考虑如下实现思路：

> 把进程号重定向到文件中，在脚本头部，先检查该文件是否存在。如果存在，则杀掉进程，删除文件。

```shell
# demo4.sh
#! /bin/bash
PIDPATH=/tmp/a.pid
if [ -f "$PIDPATH" ]
    then
        kill `cat $PIDPATH` >/dev/null  2&>1
        rm -rf /tmp/a.pid
fi
# something you want to do
echo $$ >$PIDPATH
sleep 300

# 睡眠300秒为了演示效果，
# 后台运行脚本，运行多次，每次检查，都只有一个进程。

fengzhao@fengzhao-pc:~$ ./demo4.sh  &
[2] 313
fengzhao@fengzhao-pc:~$ ps -ef | grep demo4.sh | grep -v grep
fengzhao   313   290  0 22:16 pts/0    00:00:00 /bin/bash ./demo4.sh
[1]-  Terminated              ./demo4.sh
fengzhao@fengzhao-pc:~$ ./demo4.sh  &
[3] 320
fengzhao@fengzhao-pc:~$ ps -ef | grep demo4.sh | grep -v grep
fengzhao   320   290  0 22:17 pts/0    00:00:00 /bin/bash ./demo4.sh
[2]-  Terminated              ./demo4.sh
fengzhao@fengzhao-pc:~$ ./demo4.sh  &
[4] 327
fengzhao@fengzhao-pc:~$ ps -ef | grep demo4.sh | grep -v grep
fengzhao   327   290  1 22:17 pts/0    00:00:00 /bin/bash ./demo4.sh
[3]-  Terminated              ./demo4.sh
fengzhao@fengzhao-pc:~$
```

**<font color=#FF0000 > $_ 变量 </font>** 

$_ 变量表示上一个命令的最后一个参数。这个用的不多，了解即可。

```shell
# 重启ss，输出重启命令的最后一个参数。
[root@fengzhao ~]# ssserver -c /etc/shadowsocks.json -d restart
INFO: loading config from /etc/shadowsocks.json
2019-01-07 22:25:38 INFO     loading libcrypto from libcrypto.so.10
stopped
started
[root@fengzhao ~]# echo $_
restart
[root@fengzhao ~]#
```


### 2.6、SHELL 变量子串

Linux shell 中还存在很多变量子串，提供很多控制和提取变量中的相关内容。

[参考](https://blog.csdn.net/qq_36025814/article/details/109098731)

| 变量                       | 含义                                              |
| -------------------------- | ------------------------------------------------- |
| ${variable}                | 普通变量，shell脚本中引用变量                     |
| ${#variable}               | 返回变量的字符数量长度                            |
| ${#variable:offset}        | 在变量中，从offset之后提取子串到结尾              |
| ${#variable:offset:length} | 在变量中，从offset之后提取长度为length的子串      |
| ${#variable#word}          |                                                   |
| ${var:position}            | 变量var从第position个位置开始到最后的子串         |
| ${var:position:length}     | 在变量var中，从position开始，截取length长度的子串 |
|                            |                                                   |

 **<font color=#FF0000 > ${#variable} 字符长度 </font>** 


：返回变量长度，使用变量子串或管道两种方式。

```shell
fengzhao@fengzhao-pc:~$ DEMO="this is a demo" 
fengzhao@fengzhao-pc:~$ echo ${#DEMO}  
14
fengzhao@fengzhao-pc:~$ echo $DEMO | wc -L  # wc -L 打印最长行的长度
14
fengzhao@fengzhao-pc:~$

```

关于计算字符串的长度，看到一个简单的需求：

> 请编写 shell 脚本输出下面语句中字符数小于6的单词。
>
> "Microsoft love Linux and OpenSource，welcome to GitHub"

实现思路：将字符串存到数组，迭代取出每个单词，判断长度并输出。

```shell
count_words.sh

#!/bin/bash
# 实现思路：将字符串存到数组，迭代取出每个单词，判断长度并输出。
array=($1)
for ((i=0;i<${#array[*]};i++))
do
    if [ ${#array[$i]} -lt 6 ]
        then
            echo "${array[$i]}"
    fi
done

fengzhao@fengzhao-pc:~$ ./count_words.sh  "Microsoft love Linux and OpenSource，welcome to GitHub"
love
Linux
and
to
fengzhao@fengzhao-pc:~$
```





## 3、shell 



### 关键字



简单命令



管道



命令组

与

或



复合语句





## 3、shell  逻辑运算符





顺序执行 

​	



## 4、标准输入输出重定向



程序=指令+数据

当命令解释程序（即shell）运行一个程序的时候，它将打开三个文件，对应当文件描述符分别为0，1，2，依次表示标准输入、标准输出、标准错误。

一个程序的执行，一般都会有标准输入和标准输出，例如 ls 如果不跟参数，标准输入就是当前路径，标准输出就是列出当前目录和文件。

读入数据：input

输出数据：output

文件描述符：每一个打开的文件，都有一个fd（file descriptor）

- 标准输入：keyboard（键盘），文件描述符用0表示。  /dev/stdin

- 标准输出：monitor（监视器），文件描述符用1表示。 /dev/sdtout

- 标准错误：monitor（监视器），文件描述符用2表示。 /dev/stderr



### 标准输出重定向



**标准输出重定向：一般是把程序运行结果重定向到文件中。**

​	command > new_position          覆盖重定向：覆盖文件，多次执行后，文件中只保留最后一次执行结果。

​	command >> new_position        追加重定向：追加文件，多次执行，每次都在文件中追加执行结果。

​	set -C ： 禁止将内容覆盖重定向到已有文件中。当这个开启后，不允许直接对已有文件进行覆盖重定向。

​	强制覆盖：command >| new_position

​	set +C :   打开之后，可以进行覆盖重定向。



### 标准错误重定向



**标准错误重定向：把错误输出流进行重定向 **

 	command 2> new_position       覆盖

​	 command 2>> new_position     追加



**标准输出和标准错误各自重定向至不同位置**：

​	如果成功了，后面是空，如果失败了，前面是空

​	command   >   /path/file.out         2>  /path/file.error



**将标准输出和标准错误重定向到同一个位置：**

​	command  &>   /path/file.out       追加

​	command  &>>   /path/file.out     覆盖

​	特殊用法： command  >   /path/file.out   2> &1



### 标准输入重定向

前面讲到，正常的标准输入是键盘。

可以把上一条的命令的输出作为下一个命令的标准输入。

**标准输入重定向：**

```shell
# wc的用法：wc主要用于统计文件行数
# wc -l FILE 统计FILE文件中的行数
# 如果wc -l 后没跟文件名，那么就会接收标准输入，把当前命令的所在路径作为标准输入。


# 比如统计/etc/passwd文件的行数
# wc命令后跟要统计行数的文件，wc知道自己是从passwd文件中统计
fengzhao@fengzhao-pc:~$  wc -l /etc/passwd
30 /etc/passwd
fengzhao@fengzhao-pc:~$ 

# shell将标准输入从终端重定向到了文件passwd中，就wc而言，它并不知道是来自的是标准输入还是文件。所以没有列出文件名。
fengzhao@fengzhao-pc:~$  wc -l < /etc/passwd
30
fengzhao@fengzhao-pc:~$ 


# 
fengzhao@fengzhao-pc:~$  cat /etc/passwd | wc -l 
30
fengzhao@fengzhao-pc:~$ 
```





​	command < file.txt    

​	举个例子 file.txt 的内容是 /root 

​	当前执行 `ls <  dir.txt > result.txt`  的时候，就是把 `dir.txt` 做为 ls 的标准输入，把 `result.txt` 做为 ls 的标准输出



<https://www.cnblogs.com/sparkdev/p/10247187.html>



### 管道



在 Linux 中，管道符 | 是一个经常用的命令，管道的本质实际上就是 Linux 里面的进程间通讯。

**Linux 中管道符的作用是把上一个命令的标准输出做为下一个命令的标准输入**。

------



#### 管道的特殊用法

命令组

比如，我想将多个命令的标准输入合并到一个流后再用管道传给下一个命令。

可以使用命令组的方式进行：

```shell
# 将多个命令的执行结果，合并到一个流，用 cat 连接起来
(ls -l; echo "hello world"; cat foo.txt;) | cat

# 当然，也可以将多个命令的结果合并到一个流，然后重定向到文件中
(ls -l; echo "hello world"; cat foo.txt;) > output.txt
```





Linux的管道主要包括两种：无名管道和有名管道。



#### 无名管道

 无名管道是Linux中管道通信的一种原始方法，它具有以下特点：

- 它只能用于具有亲缘关系的进程之间的通信（也就是父子进程或者兄弟进程之间）；
- 它是一个半双工的通信模式，具有固定的读端和写端；
- 管道也可以看成是一种特殊的文件，对于它的读写也可以使用普通的 read()、write()等函数。但它不是普通的文件，并不属于其他任何文件系统并且只存在于内存中。





<https://www.cnblogs.com/electronic/p/10939995.html>



### xargs命令









## 5、后台进程

​	











## 6、shell脚本调试开发技巧



### set 命令

set命令为shell内建命令，通过help set可以看到关于set的帮助信息。其主要作用是改变 shell 选项和位置参数的值，或者显示 shell 变量的名称和值。

在终端下，如果执行set命令，就会显示当前shell下所有的环境配置信息。

`set`命令用来修改 Shell 环境的运行参数，也就是可以定制环境。一共有十几个参数可以定制。



#### 错误处理

一般情况下，每个Linux shell 命令执行完毕后，都会返回一个执行结果，并将其保存到$?中，一般0表示命令执行成功，非零表示命令执行失败。

shell脚本中一般会使用到大量的命令，严格意义上，我们应该小心的检查每个关键命令的执行结果，以确定之后的执行逻辑。

```

```

-e选项就是解决这个问题的一种十分优雅的方案，-e表示如果一个命令以非零状态退出，则整个shell脚本程序就会立即退出。比如，





可是有的时候，命令返回1并不代表执行失败，这时如果启用了set -e，那么脚本就会立即退出，这不是我们想看到的，解决办法有两种：



#### 变量未定义

执行脚本的时候，如果遇到不存在的变量，Bash 默认忽略它。

```shell
#!/usr/bin/env bash

echo $a
echo bar


# 上面代码中，$a是一个不存在的变量。执行 bash script.sh 的结果如下:

# bar

# 可以看到，echo $a输出了一个空行，Bash 忽略了不存在的$a，然后继续执行echo bar。
# 大多数情况下，这不是开发者想要的行为，遇到变量不存在，脚本应该报错，而不是一声不响地往下执行。


#  set -u就用来改变这种行为。脚本在头部加上它，遇到不存在的变量就会报错，并停止执行。

# set -o nounset 与 set -u 等价
```













## 7、shell 脚本的执行方式

shell脚本有三种执行方式：

- bash ScriptName.sh 或 sh ScriptName.sh 

  这种方式执行，脚本中可以没有执行权限，也可以没指定解释器。（适用于编写脚本后，手动执行）

- ./ScriptName.sh 或  /path/ScriptName.sh

  这种方式执行，需要脚本有可执行权限，需要在脚本中指定解释器。（绝大多数都要用这种情况执行）

- source test.sh    或  .  test.sh

  source 的意思是读入或加载指定的 shell 脚本文件，然后依次执行其中的所有语句。当在脚本中调用其他脚本时，通常使用 source 命令，因为这样子脚本是在父脚本的进程中执行的（其他方式都会启动新的进程执行脚本），因此，**使用这种方式可以将子脚本中的变量值或函数等返回值传递到当前父脚本中使用。这是最重要的区别**

  （可以理解为将指定的脚本内容拷贝至当前的脚本中，由一个Shell进程来执行。即顺序执行）



使用sh命令则会开启新的Shell进程来执行指定的脚本，这样的话，父进程中的变量在子进程中就无法访问。



# FZF



fzf 是一个通用的命令行模糊搜索工具，用 golang 编写，大家的评价都是目前最快的 fuzzy finder，配合 [ag](https://einverne.github.io/post/2019/04/the-silver-searcher.html) 的使用，依靠模糊的关键词，可以快速定位文件。

配合一些脚本，可以完全颠覆以前使用命令行的工作方式。



# SHELL模式

https://yanbin.blog/bash-zsh-call-emacs-vim-edit-current-command/

https://aidear.blog.csdn.net/article/list/3?t=1

https://cjiayang.github.io/2020/07/13/linux-bash%E5%8D%87%E7%BA%A7/

没接触过的人和新手可能没有意识到 [bash](https://tiswww.case.edu/php/chet/bash/bashtop.html) shell 的默认输入模式是 [Emacs](https://www.gnu.org/software/emacs/) 模式，也就是说命令行中所用的行编辑功能都将使用 [Emacs 风格的“键盘快捷键”](https://en.wikipedia.org/wiki/GNU_Readline#Emacs_keyboard_shortcuts)。

什么是 bash 的键绑定(keybindings) 呢? 就是在 Bash 中的快捷键方案，即相当于某个 IDE 的快捷键配置，或者叫  Keymap。

比如说 IntelliJ IDEA 中可选择的 Keymap 有 Eclipse, Emacs, JBuilder, Mac OS X, Mac OS X 10.5+, NetBean, Visual Studio, 以满足不同使用者的习惯。



相应的， Bash 也为我们提供了两种键绑定的方案，即 emacs(默认) 和 vi 键绑定类型。



我们大多数天天在 Bash 下无意识中使用着 Emacs 键绑定类型，即使可能从未用过 Emacs 本身。比如我们在 Bash 下的按键组合：

```
ctrl + a     跳到命令行的开始
ctrl + e     跳到命令行末尾
!!           重复最后一个命令
ctrl + l     清屏操作，类似于  clear 命令
ctrl + c     中断/杀掉当前运行的进程 (SIGINT)
ctrl + d     发送 EOF 标记，这会关掉当前的 shell (EXIT)
ctrl + z     发送 SIGTSTP 给当前任务，使其挂起送到后台。(所以如果 vi 未正常退出，而是按 ctrl + z 的话，vi 进程还呆在后台
```

它们其实都是来自于 Emacs 键绑定。是不是那么的熟悉啊？



Bash 默认的键绑定是 Emacs，基本上在终端中按下 `ctrl + l` 看是否能成功清屏就知道是否是 Emacs 键绑定，当然 Vi 键绑定也可以自定义 `ctrl + l` 来清屏。

更准确的办法是用 `bind` 命令，这是一个 Bash 内置的命令。`bind -V` 可以看到所有设置，`bind -V | grep -e editing -e keymap` 显示编辑模式与键映射：

```shell
[root@openvpn_server ~]# bind -V | grep -e editing -e keymap
editing-mode is set to `emacs'
keymap is set to `emacs'
[root@openvpn_server ~]#
[root@openvpn_server ~]#
```





# Powershell教程



https://www.cnblogs.com/lsgxeva/p/9309576.html







# Shell 脚本进阶







### 条件判断if

逐条件进行判断，第一次遇为“真”条件时，执行其分支，而后结束整个if。

```shell
if 判断条件 1 ; then
  条件为真的分支代码
elif 判断条件 2 ; then
  条件为真的分支代码
elif 判断条件 3 ; then
  条件为真的分支代码
else
  以上条件都为假的分支代码
fi
```



```shell
#判断年纪
#!/bin/bash
read -p "Please input your age: " age
if [[ $age =~ [^0-9] ]] ;then
    echo "please input a int"
    exit 10
elif [ $age -ge 150 ];then
    echo "your age is wrong"
    exit 20
elif [ $age -gt 18 ];then
    echo "good good work,day day up"
else
    echo "good good study,day day up"
fi
```

**分析**：请输入年纪，先判断输入的是否含有除数字以外的字符，有，就报错；没有，继续判断是否小于150，是否大于18。





### 条件判断case

```shell
case $name in;
PART1)
  cmd
  ;;
PART2)
  cmd
  ;;
*)
  cmd
  ;;
esac
```





## 子shell和shell脚本调用



子shell的概念贯穿整个shell。

所谓子shell，即从当前shell环境新开一个shell环境，这个新开的shell环境就称为子shell(subshell)，而开启子shell的环境称为该子shell的父shell。

子shell和父shell的关系其实就是子进程和父进程的关系，只不过子shell和父shell所关联的进程是bash进程。



子shell会从父shell中继承很多环境，如变量、命令全路径、文件描述符、当前工作目录、陷阱等等，但子shell有很多种类型，不同类型的子shell继承的环境不相同。

可以使用 **${BASH_SUBSHELL}** 变量来查看从当前进程开始的子shell层数，**${BASHPID}** 查看当前所处 BASH 的 PID。

```shell
root@fengzhao-ubuntu ~# cat 1.sh
#!/bin/bash
echo ${BASHPID}
root@fengzhao-ubuntu ~#
root@fengzhao-ubuntu ~# bash 1.sh
2759143
root@fengzhao-ubuntu ~#

#　对于这个脚本，
```







Linux如何创建子进程：

- fork 

  fork是复制进程，它会复制当前进程的副本(不考虑写时复制的模式)，以适当的方式将这些资源交给子进程。

  **所以子进程掌握的资源和父进程是一样的，包括内存中的内容，所以也包括环境变量和变量。但父子进程是完全独立的，它们是一个程序的两个实例。**

  

- 

```

```







# ubuntu/linux修改登录欢迎信息



问题描述: 使用终端登录远程服务器时会有欢迎信息，下面说说如何自定义欢迎信息。

熟悉 Linux 的同学想必对 motd 全称 Message Of The Day 并不陌生。把内容放到 `/etc/motd` 里面然后每次登录显示里面的内容。在 

motd 本身是纯文本，传统的 motd 只能是纯文本。当然，我们可以在 shell 启动执行命令时显示一些东西，达到类似 motd 功能的效果。

















# BASH 常识

——标准

Bash遵循IEEE POSIX标准。

IEEE即Institute of Electrical and Electronics Engineers，电气与电子工程师协会。

POSIX即Portable Operating System Interface，可移植的操作系统接口。



——功能

类似于其它程序设计语言，Bash也有自己的内置函数/命令和变量，可以自定义函数和变量，支持一定的运算符，包括普通运算符和重定向运算符。



——命名

Bash中的变量名可以是字母、数字、下划线，但首字母不能是数字，而且自定义的变量名要避免使用Bash内置的变量，以免产生冲突。



——状态

Bash命令有自己的退出/返回状态，就像其它程序设计语言的函数返回值一样，这个退出状态的最小值为0，最大值为255，也就是一个无符号字节（八个二进制位）的取值范围，一般情况下，状态码为0表示命令执行成功。

对于一个简单的内置命令来说，其退出状态是POSIX中waitpid函数规定的退出状态，如果命令执行期间被信号n中断，退出状态为”128+n“。

如果命令未找到，退出状态为127，找到了却不可执行，退出状态为126，内建命令用法不正确时退出状态为2。



——后缀

shell脚本的后缀一般是“.sh”，但这个后缀并不是必需的，添加后缀的主要目的是与其它的文件进行区分，给我们一个直观的认识，shell脚本可以是任意的后缀或者不使用后缀。



——注释

在shell脚本中，“#”符号是个特殊字符，表示注释，类似于其它程序设计语言的注释符，脚本执行时，这个注释符及后面的内容会被忽略。

在shell命令行（交互式shell）中，“#”也可以作为注释符，前提是shell支持这样的操作，是否支持我们可以使用shell内建命令shopt查看interactive_comments的状态，在shell命令行输入“shopt interactive_comments”，输出“interactive_comments on”表示支持，输出“interactive_comments off”表示不支持，如果想激活这个状态执行命令“shopt -s interactive_comments”，关闭这个状态执行命令“shopt -u interactive_comments”。



——引用

引用即quoting，不同于其它语言如c++的引用reference，在shell中，引用的作用是去除某些字符或变量的特殊含义，保留其字面含义。引用有三种用法，转义字符、单引号和双引号。转义字符即反斜线“\”，用来转义下一个特殊字符为其字面含义，当转义字符出现在行尾时又称为续行符，表示这一行还没有结束，还包括下一行的内容。单引号（”）中的字符串能保留各个字符的字面含义，单引号要成对使用，引号对内不能有别的单个单引号，即使是转义过的单引号也不行，但可以有单个双引号。双引号（”“）中的字符串也能保留各个字符的字面含义，双引号也要成对使用，引号对内虽不能有别的单个双引号，但可以有转义过的双引号，还可以有单个单引号。在双引号中，美元符号“$”保留其特殊功能，反单引号“`”（键盘上与波浪线一个位置）保留其特殊功能，如果打开历史扩展的话感叹号“!”保留其特殊功能，对于转义字符，如果其后面是反斜线、双引号、美元符号、反单引号，转义符号也将保留其转义功能。



——转义

shell中转义字符用法特殊，这里着重介绍一下。在某些场合下，比如说正则表达式，因为有许多字符是特殊字符，有着特殊含义，所以在正则匹配时要对这些特殊字符进行转义，转义成它们的字面意思。对于换行符，不同的操作系统有不同的格式，Linux上为”\n“，Mac上位”\r“， Windows上为”\n\r“。有时候，对一个字符串引用时要使用单引号而非双引号，比如说awk这个命令，字符串中若包含转义字符，会根据一定的规则进行处理，下面是ANSI（即American National Standards Institute美国国家标准学会） C标准定义的转义字符：







# shell脚本中嵌入文件





linux版的jdk安装包是一个.bin后缀文件，下载后给执行权限就能解压安装，即简单又方便，Nvidia的闭源驱动（.run）也是一样。

一直以为这两个安装包是编译好的二进制文件，可安装过程怎么看都像shell脚本，用sh -x 看了下执行过程，果然就是一个shell脚本，只不过脚本最后嵌入了二进制文件。







```shell
#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

# shell self-extracting 


# check operating system
if [ "`uname -s`" = "Linux" ]; then
    echo "Please  Use this script on Linux platfrom"
    exit 1
fi

# check root user
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

TmpDir=/tmp




# 执行时，awk提取当前shell文件下ARCHIVE_BELOW后面的文件内容
ARCHIVE=$(awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0; }' "$0")
# tail获取这些内容，然后提取解压到/tmp/文件夹中
tail -n+$ARCHIVE "$0" | tar -xzvm -C $TmpDir > /dev/null 2>&1 3>&1


if [ $? == 0 ];then
        echo "Success"
else
        echo "Fail"
fi






exit 0  #退出当前脚本，后面内容为压缩进来的二进制内容，不需要再执行
#This line must be the last line of the file
__ARCHIVE_BELOW__

```



# 自动补全

在使用 [bash](http://blog.fpliu.com/it/software/GNU/bash) 命令行时，在提示符下，输入某个命令的前面几个字符， 然后按`TAB`键，就会列出以这几个字符开头的命令供我们选择。 不光如此，还可以进行参数补全，但只限于文件参数，当输入到参数部分时，按`TAB`键， 就会列出以这个参数开头的文件路径供我们选择。





# 文件锁定



# getshell

Getshell 指的是**攻击者通过利用网站或应用程序的漏洞，成功获取到服务器的命令执行权限，能够控制目标系统，发送、接收数据，甚至进行恶意操作**。 

这个过程通常包括了对web 应用的深入理解、漏洞挖掘和利用技巧

# 终极 Bash 脚本指南



还有人记得 IPython Shell 么？曾经想利用 Python 的便利性在 Shell 领域代替 bash/zsh，Python 当然是一门足够强大的通用语言，但在 shell 这个领域，它怎么着都干不过 bash/zsh ，为啥呢？因为 bash/zsh 就是为了操作各种命令和文件而设计的，命令/文件是里面的一等公民，最方便最有力的表达方式都让给了命令以及文件操作，那么做这些事情 bash/zsh 当让比 python 的描述能力更强，更清晰。

当年 IPython Shell 出来的时候，一副秒天秒地秒空气的架势要来做下一代 shell，最后也凉了。

所谓“shell”，首先得是**操作系统界面**(这也是 shell 的原义)，其次才是一个编程语言。而操作系统的职能中，文件系统和进程管理是两块很重要的地方。

因此 shell 十分强调**文件**和**命令**，这是其他脚本语言所不具备的。具体强调的方式，有语义上的，也有语法上的。



在开发的过程中，经常需要处理一些重复的工作，或者逻辑相当简单但耗时的功能，这时我们可能会考虑到用脚本来自动化完成这些工作。

而 Bash 脚本是我们最容易接触到和上手的脚本语言。这里博客汇总一些常用的 Bash 语法，方便日后查阅学习。



## hello world

不管写啥，上来先输出个`hello world`。

```shell
#!/bin/bash

echo "hello world"
```

创建一个文件`hello.sh` 包含以上内容，同时赋予执行权限，然后执行，一个`hello world` 就好了。

```shell
# 添加执行权限
$ chmod +x hello.sh

$ ./hello.sh
hello world
```



## 变量声明





## set命令

set 命令是 bash 脚本的重要环节，却常常被忽视，导致脚本的安全性和可维护性出问题。

```shell
# bash 执行脚本的时候，会创建一个新的 shell 进程
$ bash script.sh
```

上面代码中，script.sh是在一个新的 shell 里面执行。这个 shell 就是脚本的执行环境，bash 默认给定了这个环境的各种参数和环境变量

set命令用来修改 shell 环境的运行参数，也就是可以定制环境。一共有十几个参数可以定制，官方手册有[完整清单](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)

### set -u

执行脚本的时候，如果遇到不存在的变量，bash 默认忽略它，并继续执行后面的语句。

```shell
#!/usr/bin/env bash
echo $a
echo bar
```





## 函数

在`Bash`中，你可以使用`function`关键字或者直接定义一个函数。

```
function function-name(){
	...
}

function-name(){
	...
}
```





## 批处理利器xargs

https://www.cnblogs.com/wangqiguo/p/6464234.html

标准输入：一个程序运行时需要读取的数据

标准输出：

管道符：把上一个命令的标准输出做为下一个命令的标准输入



Linux命令可以从两个地方读取要处理的内容，一个是通过命令行参数，一个是标准输入。

```shell

[root@open_server ~]# cat abc.txt
main
main
[root@open_server ~]#
[root@open_server ~]# echo "main in echo"  | cat abc.txt
main
main
[root@open_server ~]#

# With no FILE, or when FILE is -, read standard input.
[root@open_server ~]# echo "main in echo"  | cat -
main in echo
[root@open_server ~]#
[root@open_server ~]# echo "main in echo"  | cat abc.txt -
main
main
main in echo
[root@open_server ~]# echo "main in echo"  | cat - abc.txt
main in echo
main
main
[root@open_server ~]#
[root@open_server ~]#
[root@open_server ~]# echo 'main in echo' | grep 'main' abc.txt
main
main
[root@open_server ~]#
[root@open_server ~]#
[root@open_server ~]# echo 'main' | grep 'main' abc.txt
main
main
[root@open_server ~]# echo 'main in echo' | grep 'main' abc.txt -
abc.txt:main
abc.txt:main
(standard input):main in echo
[root@open_server ~]#
```



我们看到当命令行参数与标准输入同时存在的时候grep和cat是会同时处理这两个输入的，但是有很多命令并不是都处理。大多命令一般情况下是首先在命令行中查找要处理的内容的来源(是从文件还是从标准输入，还是都有)，如果在命令行中找不到与要处理的内容的来源相关的参数则默认从标准输入中读取要处理的内容了，当然这取决于命令程序的内部实现，就像cat命令，加不加 - 参数他的表现又不同。

这两个命令默认是只接受命令行参数中指定的处理内容，不从标准输入中获取处理内容。

想想也很正常，kill  是结束进程，rm是删除文件，如果要结束的进程pid和要删除的文件名需要从标准输入中读取，这个也很怪异吧。

 但是像  cat与grep这些文字处理工具从标准输入中读取待处理的内容则很自然。



但是有时候我们的脚本却需要 echo '516' | kill 这样的效果，例如 ps -ef | grep 'ddd' | kill  这样的效果，筛选出符合某条件的进程pid然后结束。

这种需求对于我们来说是理所当然而且是很常见的，那么应该怎样达到这样的效果呢。有几个解决办法：

```shell
 kill `ps -ef | grep 'ddd'`    
 # 这种形式，这个时候实际上等同于拼接字符串得到的命令，其效果类似于  kill $pid
 
 
 
 ps -ef | grep 'ddd' | xargs kill  
# 使用了xargs命令，铺垫了这么久终于铺到了主题上。
# xargs命令可以通过管道接受字符串，并将接收到的字符串通过空格分割成许多参数(默认情况下是通过空格分割) 然后将参数传递给其后面的命令，作为后面命令的命令行参数
```





# shell 格式化输出

Linux 默认的 Bash 命令行总是黑底白字，长期看着有些单调。

其实Bash允许自定义彩色的命令提示符、彩色的grep显示、彩色的man显示、彩色的ls显示等等。

我们只需要编辑个人或者全局的shell配置文件就可以构建自己的独特的多姿多彩的shell。

其中，用户个人配置文件是~/.bashrc，全局配置文件是/etc/bash.bashrc（ubuntu) 或者/etc/bashrc（Fedora）。





shell 中的打印有 `echo`和`printf`，不过`printf`就强大了，支持格式化输出，当然我们这里的输出有颜色的文本也是支持的，如果想要`echo`支持则需要使用`echo -e`表示支持转义。



## 基本格式

`背景底色号码;`这部分可以删除，这样就是默认黑色底色了；下面的`\033`与`\e`一样，所以二者可以互换

**默认背景底色号码：40 表示黑色**

**默认字体颜色号码：37 表示白色**



# 终端乱码



一般通过ssh远程到服务器上进行操作。当在终端上执行一些有输出的任务时，有可能会遇到乱码，特别是输出中有中文时。

比如，我登陆上oracle数据库服务器上，查看oracle RAC的状态。



除了英文字母外其它的都成了乱码了。 当然这个与运行什么程序没有什么关系，你可以试一下系统自带的命令，当参数错误时也会也现乱码。



在Linux里面有两个概念与这个问题有关：**国际化（相对应的是本地化）**、**编码**



**国际化-i18n-internationalization**

locale 是Linux中的一组环境变量，为Linux操作系统定义了语言，国家，字符编码设置等。

这些环境变量会被Linux系统库和能意识到locale变量的工具使用。使用locale命令来设置和显示程序运行的语言环境。

locale会根据计算机用户所使用的语言，所在国家或者地区，以及当地的文化传统定义一个软件运行时的语言环境。

Locale会影响到时间日期格式，一周中的第一天，数字，货币等等其他格式。





**编码**

编码是数据（文本）在计算机的内部表示。在数据存储（文件）或传输过程中会以某种规则进行编码（编码规范：UTF-8、GBK等)



程序输出的乱码本质上和文件乱码是一回事。



**编辑打开乱码**：以编码格式”A“写入文件，以编码格式"B“解析文件内容并显示（编辑器打开，浏览器访问等等各种形式）

**终端乱码**：程序以系统要求（LANG）的编码格式"A"输出文本，输出的内容被”终端“程序以自己的编码格式”B"解析并显示。



- LC_CTYPE：用于字符分类和字符串处理，控制所有字符的处理方式，包括字符编码，字符是单字节还是多字节，如何打印等，非常重要的一个变量。
- LC_NUMERIC：用于格式化非货币的数字显示
- LC_TIME：用于格式化时间和日期 
- LC_COLLATE：用于比较和排序 
- LC_MONETARY：用于格式化货币单位 
- LC_MESSAGES：用于控制程序输出时所使用的语言，主要是提示信息，错误信息，状态信息，标题，标签，按钮和菜单等 
- LC_PAPER：默认纸张尺寸大小 
- LC_NAME：姓名书写方式 
- LC_ADDRESS：地址书写方式 
- LC_TELEPHONE：电话号码书写方式 
- LC_MEASUREMENT：度量衡表达方式 
- LC_IDENTIFICATION：locale对自身包含信息的概述



LC_ALL：它不是环境变量，它是一个宏，它可通过该变量的设置覆盖所有 `LC_` 开头的变量，这个变量设置之后，可以废除LC_*的设置值，使得这些变量的设置值与LC_ALL的值一致，注意LANG变量不受影响。



https://wiki.archlinux.org/title/Locale_(简体中文)#变量

设置locale的根本就是设置一组总共12个LC开头的变量，不包括LANG和LC_ALL locale默认文件存放位置： /usr/share/i18n/locales

列出所有启用的locale：分别介绍下

> LANG：LANG的优先级是最低的，它是所有LC_*变量的默认值，下方所有以LC_开头变量（LC_ALL除外）中，如果存在没有设置变量值的变量，那么系统将会使用LANG的变量值来给这个变量进行赋值。如果变量有值，则保持不变 LC_CTYPE：用于字符分类和字符串处理，控制所有字符的处理方式，包括字符编码，字符是单字节还是多字节，如何打印等，非常重要的一个变量。 LC_NUMERIC：用于格式化非货币的数字显示 LC_TIME：用于格式化时间和日期 LC_COLLATE：用于比较和排序 LC_MONETARY：用于格式化货币单位 LC_MESSAGES：用于控制程序输出时所使用的语言，主要是提示信息，错误信息，状态信息，标题，标签，按钮和菜单等 LC_PAPER：默认纸张尺寸大小 LC_NAME：姓名书写方式 LC_ADDRESS：地址书写方式 LC_TELEPHONE：电话号码书写方式 LC_MEASUREMENT：度量衡表达方式 LC_IDENTIFICATION：locale对自身包含信息的概述

LC_ALL：它不是环境变量，它是一个宏，它可通过该变量的设置覆盖所有LC_*变量，这个变量设置之后，可以废除LC_*的设置值，使得这些变量的设置值与LC_ALL的值一致，注意LANG变量不受影响。

优先级：LC_ALL > LC_* > LANG

> 

上面所列的，C是系统默认的locale，POSIX是C的别名，这是标准的C locale ，它所指定的属性和行为由ISO C标准所指定，当我们新安装完一个系统时，默认的locale就是C或POSIX（C就是ASCII编码）