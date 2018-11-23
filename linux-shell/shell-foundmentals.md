## SHELL 概述

Shell 是 Linux 下的命令交互程序，它用来接收用户输入的指令，传递给内核进行执行。所以它可以被理解为内核外面的一层壳，用户通过它来与内核交互。它虽然不是Unix/Linux系统内核的一部分，但它调用了系统核心的大部分功能来执行程序、建立文件并以并行的方式协调各个程序的运行。因此，对于用户来说，shell 是最重要的实用程序，深入了解和熟练掌握shell的特性极其使用方法，是用好Unix/Linux系统的关键。

可以说，shell使用的熟练程度反映了用户对Unix/Linux使用的熟练程度。


## Linux 命令类型

Linux 命令分为两种类型，一类是 shell 内建命令。一类是应用程序命令。应用程序命令，一般都会有相应的二进制可执行文件，通常存在 /bin , /usr/sbin/ , /usr/bin 等目录中。shell 通过读取 $PATH 这个环境变量来查找应用程序执行路径。

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


## 环境变量

环境变量是操作系统中的软件运行时的一些参数，环境变量一般是由变量名和变量值组成的键值对来表示。应用程序通过读取变量名来获取变量值。通过和设置环境变量，可以调整软件运行时的一些参数。最著名的操作系统变量就是 PATH 了。在 windows 和 linux 都存在这个环境变量。它表示在命令行中执行命令的查找路径。在 Linux 命令行中，可以通过 echo $VARIABLENAME 来查看变量值。

常用环境变量

- PATH 决定了shell将到哪些目录中寻找命令或程序(分先后顺序)
- HOME 当前用户主目录
- HISTSIZE　命令历史记录条数
- HISTTIMEFORMAT 命令历史时间格式  一般设置为" %F %T 'whoami'"
- LOGNAME 当前用户的登录名
- HOSTNAME　指主机的名称
- SHELL 当前用户Shell类型
- LANGUGE 　语言相关的环境变量，多语言可以修改此环境变量
- MAIL　当前用户的邮件存放目录
- PS1　基本提示符，对于root用户是#，对于普通用户是$






#### Shell有两种执行命令的方式：

- 交互式（Interactive）：解释执行用户的命令，用户输入一条命令，Shell就解释执行一条。
- 批处理（Batch）：用户事先写一个Shell脚本(Script)，其中有很多条命令，让Shell一次把这些命令执行完。


#### 几种常见的 Shell：

 Linux 发行版自带的标准 Shell 都是 Bash shell，Linux 的默认命令行就是 Bash，我们的最多的也是这个。是 BourneAgain Shell 的缩写，内部命令一共有40个。一般日常使用 bash 基本上都够了，进阶可以试试 zsh。

 另一个强大的 Shell 就是 zsh，它比 bash 更强大，但是也更难用，配置起来非常麻烦。所以有个 [on-my-zsh](https://github.com/robbyrussell/oh-my-zsh/)，它大大简化了 zsh 的配置，一般通过包管理器安装zsh，然后通过 git 安装 on-my-zsh：
```shell
$ git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
$ cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```

#### 查看操作系统的 Shell：
``` shell
$ echo $SHELL  # 查看当前使用的 shell
$ cat /etc/shells # 查看当前系统支持的 shell
$ bash   # 切换至 bash ，输入 zsh 切换至 zsh。
$ chsh -s /bin/zsh  # 修改当前用户的 shell
```
#### Shell 配置文件：

- ~/.zshrc 和 ~/.bashrc：分别是当前用户的 bash 和 zsh 的配置文件，这个文件是用户级别的，当用户打开终端时，每一个shell进程生成时，执行的一组命令，包括设置别名，提示文本，颜色等设置。

- ~/.bash_history 和 ~/.zshhistory  记录用户运行的历史命令。


 


搜索

