# SHELL脚本学习笔记

Shell 是 Linux 下的命令交互程序，其实就是一个命令解释器。它用来接收用户输入的指令，传递给内核进行执行。所以它可以被理解为内核外面的一层壳，用户通过它来与内核交互。它虽然不是 Unix/Linux 系统内核的一部分，但它调用了系统核心的大部分功能来执行程序、建立文件并以并行的方式协调各个程序的运行。因此，对于用户来说，shell 是最重要的实用程序，深入了解和熟练掌握 shell 的基本特性及其使用方法，是用好 Unix/Linux 系统的关键。

可以说，shell使用的熟练程度反映了用户对 Unix/Linux 使用的熟练程度。

## 1、Linux 命令和 SHELL 基础

Linux 命令分为两种类型：一类是 shell 内建命令；一类是应用程序命令。应用程序命令，一般都会有相应的二进制可执行文件，通常存在 /bin , /usr/sbin/ , /usr/bin 等目录中。shell 通过读取 $PATH 这个环境变量来查找应用程序执行路径。

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

 Linux 发行版自带的标准 Shell 都是 Bash shell，Linux 的默认命令行就是 Bash，我们的最多的也是这个。是 BourneAgain Shell 的缩写，内部命令一共有40个。一般日常使用 bash 基本上都够了，进阶可以试试 zsh。

 另一个强大的 Shell 就是 zsh，它比 bash 更强大，但是也更复杂，配置起来比较麻烦。所以有个 [on-my-zsh](https://github.com/robbyrussell/oh-my-zsh/)，它大大简化了 zsh 的配置，一般通过包管理器安装 zsh，然后通过 git 安装 on-my-zsh：
```shell
$ git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
$ cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```

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

## 2、变量

变量是暂时存储数据的地方及标记，所存储的数据位于内存空间中，通过正确的调用内存中变量的名字可以取出其变量值，使用 $VARIABLES 或 ${VARIABLES} 来引用变量。

> 注意，$(COMMAND) 或 `COMMAND` 这种属于命令替换。不属于变量。

变量的类型可以分为两类：环境变量（全局变量）和普通变量（局部变量）。

环境变量：可以在创建它们的 shell 及其派生出来的任意子进程 shell 中使用，环境变量又分为用户自定义环境变量和 bash 内置环境变量。

普通变量：只能在创建他们的 shell 函数内和 shell 脚本中使用。普通变量一般由开发者在开发脚本时创建。


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

定义变量时，有三种定义方式，即 key=value,key='value',key="value" 这三种形式。

- 不加引号，value中有变量的会被解析后再输出。
```shell
fengzhao@fengzhao-pc:~$ DEMO1=1234$PWD
fengzhao@fengzhao-pc:~$ echo $DEMO1
1234/home/fengzhao
fengzhao@fengzhao-pc:~$
```

- 单引号，单引号里面是什么，输出变量就是什么，即使 value 内容中有命令和变量时，也会原样输出。
``` shell
fengzhao@fengzhao-pc:~$ DEMO2='1234$PWD'
fengzhao@fengzhao-pc:~$ echo $DEMO2
1234$PWD
fengzhao@fengzhao-pc:~$
```
- 双引号，输出变量时引号中的变量和命令和经过解析后再输出。
``` shell
fengzhao@fengzhao-pc:~$ DEMO4="1234$(pwd)"
fengzhao@fengzhao-pc:~$ echo $DEMO4
1234/home/fengzhao
fengzhao@fengzhao-pc:~$

fengzhao@fengzhao-pc:~$ DEMO5="1234$DEMO4"
fengzhao@fengzhao-pc:~$ echo $DEMO5
12341234/home/fengzhao
fengzhao@fengzhao-pc:~$

```

### 2.3、常用环境变量

环境变量是操作系统中的软件运行时的一些参数，环境变量一般是由变量名和变量值组成的键值对来表示。应用程序通过读取变量名来获取变量值。通过和设置环境变量，可以调整软件运行时的一些参数。最著名的操作系统变量就是 PATH 了。在 windows 和 linux 都存在这个环境变量。它表示在命令行中执行命令时的查找路径。在 Linux 命令行中，可以通过 echo $VARIABLENAME 来查看变量值。

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
| $0     | 获取当前执行的 shell 脚本文件名。如果执行时包含路径，那么就包含脚本路径。 |
| $n     | 获取当前执行的 shell 脚本所有传递的第 n 个参数（参数以空格分开），如果 n>9 ，要用大括号引起来：${10} |
| $#     | 获取当前执行的 shell 脚本传递的参数总个数。                  |
| $*     | 获取当前执行的 shell 脚本传递的所有参数。"$*" 表示将所有参数一起组成字符串。 |
| $@     | y也是获取所有参数，"$*" 表示将所有参数视为一个一个的字符串。 |



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

生产中，在调一些脚本的时候，经常会对传参进行判断，并执行脚本中相应的函数。下面看一段 openresty 中的代码片段。这个脚本，在执行的时候，可以接各种参数，如果匹配到下面这些参数，直接执行相应的函数，

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
| $?   | 获取上一个命令的执行状态返回值（0为成功，非0为失败），可以在脚本中自定义 |
| $$   | 获取当前执行的 shell 脚本的进程号（PID）                     |
| $!   | 获取上一个在后台工作的进程的进程号                           |
| $_   | 获取在此之前执行的命令或脚本的最后一个参数                   |

**<font color=#FF0000 >$? 变量常用场景</font>**

在 Linux 命令行中，执行一个复杂的命令或者没有输出的命令时，可以通过 echo $? 来打印这个命令是否执行成功。这个返回值的常规用法如下：

- 判断命令，脚本或函数等程序是否执行成功。
- 若在脚本中调用 "exit 数字"，则会把这个数字返回给 $? 。
- 若是在函数中，调用"return 数字"把这个数字返回给 $? 。

```shell
demo3.sh
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

<font color=#FF0000 >$$变量常用场景</font>

$$ 变量表示当前 shell 进程号。有时在执行定时任务时频率较快，不知道上一个脚本是否执行完毕。但是业务要求同一时刻必须只有一个脚本在执行。

考虑如下实现思路：

> 把进程号重定向到文件中，在脚本头部，先检查该文件是否存在。如果存在，则杀掉进程，删除文件。

```shell
demo4.sh
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



















