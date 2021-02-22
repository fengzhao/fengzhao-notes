## 一、Linux 命令和SHELL概念

在计算机中，有很多概念需要重新理解一下。



- **命令行界面** (CLI) = 使用文本命令进行交互的用户界面
- **图形用户界面 (GUI)** = 使用图形界面进行交互
- **终端** (Terminal) = **TTY** = 文本输入/输出环境
- **控制台** (Console) = 一种特殊的终端
- **Shell** = 命令行解释器，执行用户输入的命令并返回结果



### 命令行界面CLI

命令行界面，通俗来讲，就是我们看到的那种满屏幕都是字符的界面。**用户主要使用命令来控制计算机。**

> 命令行界面（英语：Command-line Interface，缩写：CLI）是在图形用户界面得到普及之前使用最为广泛的用户界面，它通常不支持鼠标，用户通过键盘输入指令，计算机接收到指令后，予以执行              
>
> —— 摘自 [Wikipedia](https://zh.wikipedia.org/wiki/%E5%91%BD%E4%BB%A4%E8%A1%8C%E7%95%8C%E9%9D%A2)



在图形化桌面出现之前，与 Unix 系统进行交互的唯一方式就是借助由 shell 所提供的文本命令行界面（command line interface，CLI）。

CLI 只能接受文本输入，也只能显示出文本和基本的图形输出。

#### 控制台终端Terminal

在 Linux 命令行界面模式中，开机后显示器出现的命令行界面（shell CLI）就叫终端，这种模式称作 Linux 控制台，因为它仿真了早期的硬接线控制台终端，而且是一种同 Linux系 统交互的直接接口。

大多数 Linux 发行版会启动5~6个（有时会更多）虚拟控制台（tty），虚拟控制台是运行在Linux系统内存中的终端会话。你在一台计算机的显示器和键盘上就可以访问它们。

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



#### 图形化终端（终端模拟器）

但是在图形界面时，如果我也想使用命令行来操作 Linux 系统时，这样在图形界面中就需要 **终端模拟器（terminal-emulators）**，要想在桌面中使用命令行，关键在于终端模拟器。

可以把终端模拟器看作GUI中（in the GUI）的CLI终端，将虚拟控制台终端看作GUI以外（outside the GUI）的CLI终端。

在 Linux 发行版上，最好用的终端模拟器：

```shell
https://gnometerminator.blogspot.com/p/introduction.html
```



### 图形界面

图形用户界面，我们常见的 Windows 操作就是图形界面，用户主要使用图形界面来控制计算机。

命令行比图形界面在很多方面有一些优势，比如：我要把当前目录下的（包括嵌套的子目录）所有 `*.tpl` 文件的后缀名修改为 `*.blade.php` 。在图形界面操作时，就不是那么方便了，使用命令行，只需要一句命令就可以搞定：

```shell
rename 's/\.tpl$/\.blade.php/' ./**/*.tpl
```



### SHELL

Shell 是 Linux 下的命令交互程序，其实就是一个命令解释器。它用来接收用户输入的指令，传递给内核执行。

所以它可以被理解为内核外面的一层壳，用户通过它来与内核交互。

它虽然不是 Unix/Linux 系统内核的一部分，但它调用了系统核心的大部分功能来执行程序、建立文件并以并行的方式协调各个程序的运行。

因此，对于用户来说，shell 是最重要的实用程序，深入了解和熟练掌握 shell 的基本特性及其使用方法，是用好 Unix/Linux 系统的关键。

#### SHELL的分类

Linux 的 Shell 种类众多，常见的有：

- Bourne Shell（/usr/bin/sh或/bin/sh）

  是UNIX最初使用的 shell，而且在每种 UNIX 上都可以使用。Bourne Shell 在 shell 编程方面相当优秀，但在处理与用户的交互方面做得不如其他几种 shell。

- **Bourne Again Shell（/bin/bash）**

  - **Linux 默认的 shell 它是 Bourne Shell 的扩展。 与 Bourne Shell 完全兼容，并且在 Bourne Shell 的基础上增加了很多特性，可以提供命令补全，命令编辑和命令历史等功能。**
  - **基本上现在各大Linux发行版都是使用 bash 做为默认 shell**

  

- C Shell（/usr/bin/csh）

  是一种比 Bourne Shell 更适合的变种 Shell，它的语法与 C 语言很相似。

- K Shell（/usr/bin/ksh）

  集合了 C Shell 和 Bourne Shell 的优点并且和 Bourne Shell 完全兼容。

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



#### shell 的类型和场景

由于使用场景的不同，Shell 被分为两个类型：

- `login` / `non-login`
- `interactive` / `non-interactive`

这两个类型影响的是 **Shell 的启动文件 (startup files)**。

当我们使用终端登录一台主机时，主机会为我们启动一个 Shell，由于是登录以后启动的，所以是 login Shell。

其他情况的 Shell 就是 non-login 的，比如我登录以后，输入 `bash` 再启动一个 Shell，那么这个 Shell 就是 non-login 的。

```shell
# 举个简单的例子，我们在windows中使用终端工具ssh远程到一个Linux后，通常输入exit，会断开当前ssh连接。
# 如果我们连上去后，多输入几次bash，即多启动几个shell，然后每次输入exit其实是退出当前shell而已，并没有很快断开ssh连接
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

### SHELL脚本

SHELL 脚本，其实就是将一大堆可执行命令放在一个文本文件中，其中也可以包含一些逻辑判断，循环遍历等，就类似一种批处理。



#### 脚本的执行

shell脚本有种执行方式：

- bash ScriptName.sh 或 sh ScriptName.sh 

  这种方式执行，脚本中可以没有执行权限，也可以没指定解释器

- ./ScriptName.sh 或  /path/ScriptName.sh

  这种方式执行，需要脚本有可执行权限，需要在脚本中指定解释器。

- source test.sh    或  .  test.sh

  source 的意思是读入或加载指定的 shell 脚本文件，然后依次执行其中的所有语句。当在脚本中调用其他脚本时，通常使用 source 命令，因为这样子脚本是在父脚本的进程中执行的（其他方式都会启动新的进程执行脚本），因此，**使用这种方式可以将子脚本中的变量值或函数等返回值传递到当前父脚本中使用。这是最重要的区别**

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

变量是暂时存储数据的地方及标记，所存储的数据位于内存空间中，通过正确的调用内存中变量的名字可以取出其变量值。

使用 **$VARIABLES** 或 **${VARIABLES}** 来引用变量。应用程序运行时通过读取环境变量

```shell
# 声明变量 NAME='VALUE'，变量名大写，变量值用引号括起来,防止值中有空格
root@vpsServer:~# NAME='fengzhao'
# 引用变量加上引号，防止变量名中有空格，${VARIABLES}
root@vpsServer:~# echo ${NAME}
fengzhao
root@vpsServer:~# 

```



根据变量的作用范围，变量的类型可以分为两类：环境变量（全局变量）和普通变量（局部变量）。

- 环境变量：可以在创建它们的 shell 及其派生出来的任意子进程 shell 中使用，环境变量又分为用户自定义环境变量和 bash 内置环境变量。
- 普通变量：只能在创建他们的 shell 函数内和 shell 脚本中使用。普通变量一般由开发者在开发脚本时创建。

根据变量的生命周期，可以分为两类：

- 永久的：需要修改配置文件，变量永久生效。（这种变量需要在文件中声明）
- 临时的：使用 `export` 命令声明即可，变量在关闭 shell 时失效。（这种变量在命令中声明）



#### 环境变量

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

```





#### bash 环境变量







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

Bash的数组，其元素的个数没有限制。数组的索引由0开始，但不一定要 连续(可以跳号)。索引也可以算术表达式。bash仅支持一维数组。





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























# SHELL脚本学习笔记

Shell 是 Linux 下的命令交互程序，其实就是一个命令解释器。

它用来接收用户输入的指令，传递给内核进行执行。所以它可以被理解为内核外面的一层壳，用户通过它来与内核交互。

它虽然不是 Unix/Linux 系统内核的一部分，但它调用了系统核心的大部分功能来执行程序、建立文件并以并行的方式协调各个程序的运行。

因此，对于用户来说，shell 是最重要的实用程序，深入了解和熟练掌握 shell 的基本特性及其使用方法，是用好 Unix/Linux 系统的关键。

可以说，shell 使用的熟练程度反映了用户对 Unix/Linux 使用的熟练程度。

## 1、Linux 命令和 SHELL 基础

Linux 命令分为两种类型：

- 一类是 shell 内建命令；

- 一类是应用程序命令。应用程序命令，一般都会有相应的二进制可执行文件，通常存在 /bin , /usr/sbin/ , /usr/bin 等目录中。

  shell 通过读取 $PATH 这个环境变量来查找应用程序执行路径。

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

 Linux 发行版自带的标准 Shell 都是 Bash shell，Linux 的默认命令行就是 Bash，我们的最多的也是这个。

是 BourneAgain Shell 的缩写，内部命令一共有 40 个。一般日常使用 bash 基本上都够了，进阶可以试试 zsh。

 另一个强大的 Shell 就是 zsh，它比 bash 更强大，但是也更复杂，配置起来比较麻烦。所以有个 [on-my-zsh](https://github.com/robbyrussell/oh-my-zsh/)，它大大简化了 zsh 的配置，一般通过包管理器安装 zsh，然后通过 git 安装 on-my-zsh：
```shell
$ git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
$ cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```

Shell脚本和编程语言很相似，也有变量和流程控制语句，但Shell脚本是解释执行的，不需要编译，Shell程序从脚本中一行一行读取并执行这些命令，相当于一个用户把脚本中的命令一行一行敲到Shell提示符下执行。

Unix/Linux上常见的Shell脚本解释器有 bash、sh、csh、ksh、dash  等，习惯上把它们称作一种Shell。



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

  比如，以 ./startup.sh 这样直接运行

- 运行解释器，并将脚本文件名作为参数传入。

  比如，以 bash  startup.sh  这样运行

- 启动解释器，解释器从标准输入读取内容并执行（如果这个标准输入是用户键盘，那就是所谓的“交互式执行”）。

  比如，非常流行的直接运行网络上的脚本。

  ```shell
  # daocloud的设置镜像加速的脚本
  curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
  # rust官方推荐的安装脚本
  curl https://sh.rustup.rs -sSf | sh -s -- --help
  
  # sh -s 用于从标准输入中读取命令，命令在子shell中执行
  # 当sh -s 后面跟的参数,从第一个非 - 开头的参数，就被赋值为子shell的$1,$2,$3....
  
  ## 本质就是下载 set_mirror.sh 这个脚本，然后再执行 ./set_mirror.sh  http://f1361db2.m.daocloud.io
  ```

- 使用 source shellscript.sh 或 . shellscript.sh 这种格式去运行。

source 的意思是读入或加载指定的 shell 脚本文件，然后依次执行其中的所有语句。

当在脚本中调用其他脚本时，通常使用 source 命令，因为这样子脚本是在父脚本的进程中执行的（其他方式都会启动新的进程执行脚本）

**因此，使用 source 这种方式可以将子脚本中的变量值或函数等返回值传递到当前父脚本中使用。这是与其他方式最重要的区别。**

所以我们在 /etc/profile 中声明一些环境变量时，想立马生效，就直接 source /etc/profile ，这样就对当前会话生效，而不需要重新登陆。

这种情况最多的用法就是 shell 脚本中调其他 shell 。在单个进程中执行的。

## 2、变量

变量是暂时存储数据的地方及标记，所存储的数据位于内存空间中，通过正确的调用内存中变量的名字可以取出其变量值，使用 $VARIABLES 或 ${VARIABLES} 来引用变量。

> 注意，$(COMMAND) 或 `COMMAND` 这种属于命令替换。不属于变量。

变量的类型可以分为两类：环境变量（全局变量）和普通变量（局部变量）。

- 环境变量：可以在创建它们的 shell 及其派生出来的任意子进程 shell 中使用，环境变量又分为用户自定义环境变量和 bash 内置环境变量。


- 普通变量：只能在创建他们的 shell 函数内和 shell 脚本中使用。普通变量一般由开发者在开发脚本时创建。



查看变量的命令：

- set 输出所有变量，包括全局变量和局部变量
- env 仅显示全局变量
- echo $VARIABLES 打印VARIABLES变量值
- cat /proc/$PID/environ  查看某个进程运行时的环境变量

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

# 把命令的结果赋值给某个变量，使用 VIRABLES=$(pwd) 和 VIRABLES=`pwd` 两种方式
fengzhao@fengzhao-pc:~$ DIRPATH=$(pwd)
fengzhao@fengzhao-pc:~$ echo $CURRENTPATH
/home/fengzhao
fengzhao@fengzhao-pc:~$
fengzhao@fengzhao-pc:~$ BASEPATH=`basename /home/fengzhao`
fengzhao@fengzhao-pc:~$ echo $BASEPATH
fengzhao
fengzhao@fengzhao-pc:~$

```

根据规范，所有环境变量的名字都定义成大写。在命令行中定义的变量仅在当前 shell 会话有效，一旦退出会话，这些变量就会失效，这样的就是普通变量。如果需要永久保存，可以在 ~/.bash_profile 或 ~/.bashrc 中定义。每次用户登陆时，这些变量都将被初始化。或放到 /etc/pfofile 文件中定义，这是全局配置文件。

### 2.2、变量定义技巧

前面的是介绍变量定义的命令，并不严谨。有几条基本准测：变量定义中，key=value 中的等号两边不能有任何空格。常见的错误之一就是等号两边有空格。

定义变量时，有三种定义方式，即 key=value , key='value' , key="value" 这三种形式。

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

- **变量使用**

```shell
在使用变量的时候，一般用 ${VIRABLE_NAME}
```



### 2.3、常用环境变量

环境变量是操作系统中的软件运行时的一些参数，环境变量一般是由变量名和变量值组成的键值对来表示。应用程序通过读取变量名来获取变量值。通过和设置环境变量，可以调整软件运行时的一些参数。

最著名的操作系统变量就是 PATH 。在 windows 和 linux 都存在这个环境变量。它表示在命令行中执行命令时的查找路径。在 Linux 命令行中，可以通过 echo $VARIABLENAME 来查看变量值。

常用环境变量

- $PATH 决定了shell将到哪些目录中寻找命令或程序(分先后顺序)
- $HOME 当前用户主目录
- $UID 当前用户的UID号，root用户的UID是0
- $HISTSIZE　命令历史记录条数
- $HISTTIMEFORMAT 命令历史时间格式  一般设置为" %F %T 'whoami'"
- $LOGNAME 当前用户的登录名
- $HOSTNAME　指主机的名称
- $SHELL 当前用户Shell类型
- $LANGUGE 　语言相关的环境变量，多语言可以修改此环境变量
- $MAIL　当前用户的邮件存放目录
- $PS1　基本提示符，对于root用户是#，对于普通用户是$


### 2.4、shell 中特殊且重要的变量

在 shell 中存在一些特殊的变量。例如：$0，$1，$2，$3... $n，$#，$*，$@ 等。这些是特殊位置参数变量。要从命令行，函数或脚本传递参数时，就需要使用位置变量参数。例如，经常会有一些脚本，在执行该脚本的时候，会传一些参数来控制服务的运行方式，或者启动关闭等命令的参数。在脚本里面，就使用这些变量来取执行的时候传递的参数。

| 变量值 | 含义                                                         |
| ------ | ------------------------------------------------------------ |
| $0     | 当前执行的 shell 脚本文件名。如果执行时包含路径，那么就包含脚本路径。 |
| $n     | 当前执行的 shell 脚本所有传递的第 n 个参数（参数以空格分开），如果 n>9 ，要用大括号引起来${10} |
| $#     | 当前执行的 shell 脚本传递的参数总个数。                  |
| $*     | 当前执行的 shell 脚本传递的所有参数。"$*" 表示将所有参数一起组成字符串。 |
| $@     | 也是获取所有参数，"$*" 表示将所有参数视为一个一个的字符串。 |





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

Linux shell 中还存在很多变量字串，提供很多控制和提取变量中的相关内容。



| 变量                       | 含义                                         |
| -------------------------- | -------------------------------------------- |
| ${variable}                | 返回变量值                                   |
| ${#variable}               | 返回变量值字符长度                           |
| ${#variable:offset}        | 在变量中，从offset之后提取子串到结尾         |
| ${#variable:offset:length} | 在变量中，从offset之后提取长度为length的子串 |
| ${#variable#word}          |                                              |
|                            |                                              |
|                            |                                              |

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
#! /bin/bash
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







## 3、shell  逻辑运算符





顺序执行 

​	



## 4、标准输入输出重定向



程序=指令+数据

当命令解释程序（即shell）运行一个程序的时候，它将打开三个文件，对应当文件描述符分别为0，1，2，依次表示标准输入、标准输出、标准错误。

一个程序的执行，一般都会有标准输入和标准输出，例如 ls 如果不跟参数，标准输入就是当前路径，标准输出就是列出当前目录和文件

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



**标准输入重定向：**

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







#### set 命令

set 命令在 shell 脚本中有很多用法



##### set -u 

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











# SHELL模式

https://yanbin.blog/bash-zsh-call-emacs-vim-edit-current-command/

https://aidear.blog.csdn.net/article/list/3?t=1







https://cjiayang.github.io/2020/07/13/linux-bash%E5%8D%87%E7%BA%A7/



https://blog.csdn.net/hudashi/article/details/82464995







# Powershell教程



https://www.cnblogs.com/lsgxeva/p/9309576.html

1