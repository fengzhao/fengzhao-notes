## Linux 命令和 SHELL 基础

在计算机中，有很多概念需要重新理解一下。



- **命令行界面** (CLI) = 使用文本命令进行交互的用户界面
- **图形用户界面 (GUI)** = 使用图形界面进行交互
- **终端** (Terminal) = **TTY** = 文本输入/输出环境
- **控制台** (Console) = 一种特殊的终端
- **Shell** = 命令行解释器，执行用户输入的命令并返回结果



### 命令行界面CLI

命令行界面，通俗来讲，就是我们看到的那种满屏幕都是字符的界面。用户主要使用命令来控制计算机。

> 命令行界面（英语：Command-line Interface，缩写：CLI）是在图形用户界面得到普及之前使用最为广泛的用户界面，它通常不支持鼠标，用户通过键盘输入指令，计算机接收到指令后，予以执行              
>
>  —— 摘自 [Wikipedia](https://zh.wikipedia.org/wiki/%E5%91%BD%E4%BB%A4%E8%A1%8C%E7%95%8C%E9%9D%A2)



在图形化桌面出现之前，与 Unix 系统进行交互的唯一方式就是借助由 shell 所提供的文本命令行界面（command line interface，CLI）。

CLI 只能接受文本输入，也只能显示出文本和基本的图形输出。

#### 控制台终端Terminal

在 Linux 命令行界面模式中，开机后显示器出现的命令行界面（shell CLI）就叫终端，这种模式称作 Linux 控制台，因为它仿真了早期的硬接线控制台终端，而且是一种同 Linux系 统交互的直接接口。

大多数 Linux 发行版会启动5~6个（有时会更多）虚拟控制台（tty），虚拟控制台是运行在Linux系统内存中的终端会话。你在一台计算机的显示器和键盘上就可以访问它们。

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

Shell 是 Linux 下的命令交互程序，其实就是一个命令解释器。它用来接收用户输入的指令，传递给内核执行。所以它可以被理解为内核外面的一层壳，用户通过它来与内核交互。

它虽然不是 Unix/Linux 系统内核的一部分，但它调用了系统核心的大部分功能来执行程序、建立文件并以并行的方式协调各个程序的运行。

因此，对于用户来说，shell 是最重要的实用程序，深入了解和熟练掌握 shell 的基本特性及其使用方法，是用好 Unix/Linux 系统的关键。

#### SHELL的分类

Linux 的 Shell 种类众多，常见的有：

- Bourne Shell（/usr/bin/sh或/bin/sh）

  是UNIX最初使用的 shell，而且在每种 UNIX 上都可以使用。Bourne Shell 在 shell 编程方面相当优秀，但在处理与用户的交互方面做得不如其他几种 shell。

- **Bourne Again Shell（/bin/bash）**

  - **Linux 默认的 shell 它是 Bourne Shell 的扩展。 与 Bourne Shell 完全兼容，并且在 Bourne Shell 的基础上增加了很多特性，可以提供命令补全，命令编辑和命令历史等功能。**

  

- C Shell（/usr/bin/csh）

  是一种比 Bourne Shell 更适合的变种 Shell，它的语法与 C 语言很相似。

- K Shell（/usr/bin/ksh）

  集合了 C Shell 和 Bourne Shell 的优点并且和 Bourne Shell 完全兼容。

这里演示用的是 Bash，也就是 Bourne Again Shell，由于易用和免费，Bash 在日常工作中被广泛使用。同时，Bash 也是大多数Linux 系统默认的 Shell。

在一般情况下，人们并不区分 Bourne Shell 和 Bourne Again Shell，所以，像  **#!/bin/sh**，它同样也可以改为 **#!/bin/bash**。



我们可以通过 /etc/shells 文件来査询 Linux 支持的 Shell。命令如下：

```
$ cat /etc/shells
/bin/sh
/bin/bash
/sbin/nologin
/bin/tcsh
/bin/csh
```

用户信息文件 /etc/passwd 的最后一列就是这个用户的登录 Shell。命令如下：

```
$ cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x: 1:1 :bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
...
```

可以看到，root 用户和其他可以登录系统的普通用户的登录 Shell 都是 /bin/bash，也就是 Linux 的标准 Shell，所以这些用户登录之后可以执行权限允许范围内的所有命令。

不过，所有的系统用户（伪用户）因为登录 Shell 是 /sbin/nologin，所以不能登录系统。



### 命令

Linux 命令分为两种类型：一类是 shell 内建命令；一类是应用程序命令。应用程序命令，一般都会有相应的二进制可执行文件，通常存在 /bin , /usr/sbin/ , /usr/bin 等目录中。shell 通过读取 $PATH 这个环境变量来查找应用程序执行路径。

通过 **type** 命令来查看命令是 shell 内建命令，还是二进制程序（如果是二进制可执行文件，还能打印出所在路径）。


  ```shell
[root@fengzhao ~]# type ls
ls is aliased to `ls --color=auto'
[root@fengzhao ~]# type pwd
pwd is a shell builtin
[root@fengzhao ~]# type w
w is /usr/bin/w
[root@fengzhao ~]# type find
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

变量是暂时存储数据的地方及标记，所存储的数据位于内存空间中，通过正确的调用内存中变量的名字可以取出其变量值，使用 **$VARIABLES** 或 **${VARIABLES}** 来引用变量。应用程序运行时通过读取环境变量

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

环境变量一般是值用 export 命令导出的变量，主要目的是用于控制计算机内所有程序的运行行为，比如：定义 shell 的运行环境，



```shell
# 在命令行中定义一个环境变量，这种变量不持久化，只能在当前shell中有效，退出即失效。
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



## 命令历史



shell 有一个很有用的特性，那就是命令历史。

当前登陆用户在终端进行操作时，该用户操作的历史命令会被记录在内存缓冲区中，使用 history 命令可以列出历史命令。

当关闭终端会话或者会话退出时时，当前用户运行过的所有命令并写入当前用户的命令历史记录文件（~/.bash_history）。如果是 zsh，在记录在 ~/.zsh_history 文件中。



**命令历史一般都有很重要的作用，用来复盘查看以前执行过的命令，其实就是操作记录。所以一般入侵者，入侵离开之前，最后一步就是清理命令历史。**



```shell
# history 命令被用于列出以前执行过的命令

# 在 oh-my-zsh 中。~/.oh-my-zsh/lib/history.zsh 这个脚本定义了一个函数 omz_history 封装 history,也可以用来查看命令历史。


```



### 相关变量

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

history -c ：清空历史命令

history -a : 手动追加会话缓冲区的命令至历史命令文件中。（即不退出当前会话）





**快捷操作（bash和zsh通用）**



!# : 调用命令历史中的第#条命令

!string ： 调用命令历史中的最近一条中以string开头的命令。

!! : 调用命令历史中上一条命令



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











