## SHELL 概述

Shell 是 Linux 下的命令交互程序，它用来接收用户输入的指令，传递给内核进行执行。所以它可以被理解为内核外面的一层壳，用户通过它来与内核交互。它虽然不是Unix/Linux系统内核的一部分，但它调用了系统核心的大部分功能来执行程序、建立文件并以并行的方式协调各个程序的运行。因此，对于用户来说，shell 是最重要的实用程序，深入了解和熟练掌握shell的特性极其使用方法，是用好Unix/Linux系统的关键。

可以说，shell使用的熟练程度反映了用户对Unix/Linux使用的熟练程度。

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


 




