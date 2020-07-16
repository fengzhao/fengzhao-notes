

# 常用 shell



# bash

 Linux 发行版自带的标准 Shell 都是 Bash shell 。无论是 centos 还是 debian ，一般都自带这个 shell，我们平时在服务器操作最多的就是这个 shell 。



bash相关的文件

```shell
#########################################################################
####用户配置文件
# executed by bash(1) for non-login shells.
~/.bashrc
# executed by Bourne-compatible login shells.
~/.profile
# 用户命令历史文件
~/.bash_history

####全局配置文件
# System-wide .bashrc file for interactive bash(1) shells.
/etc/bashrc
# system-wide .profile file for the Bourne shell (sh(1))
/etc/profile



# 1. bashrc是在系统启动后就会自动运行。
# 2. profile是在用户登录后才会运行。
# 3. 进行自定义设置后，可运用source bashrc命令更新bashrc，也可运用source profile命令更新profile。
# 4. /etc/profile中设定的变量(全局)的可以作用于任何用户，而~/.bashrc等中设定的变量(局部)只能继承/etc/profile中的变量，他们是"父子"关系。

# 每个用户都可使用该文件输入专用于自己使用的shell信息，当用户登录时，该文件仅仅执行一次!默认情况下,他设置一些环境变量,执行用户的.bashrc文件。
~/.bash_profile
# 当每次退出系统(退出bash shell)时，执行该文件。
~/.bash_logout 
# 是交互式、login方式进入bash运行的，~/.bashrc是交互式non-login方式进入bash运行的，通常二者设置大致相同，所以通常前者会调用后者。
~/.bash_profile 
# 通常我们修改bashrc,有些linux的发行版本不一定有profile这个文件

# 在 ubuntu 和 debian 中，

```





# zsh



> A delightful community-driven framework for managing your zsh configuration。   from GITHUB

（一个令人愉快的社区驱动框架，用于管理您的zsh配置。）概括说就是可以帮助你简单配置轻松使用 zsh。

- zsh 兼容 Bash，据传说 99% 的 Bash 操作 和 zsh 是相同的。
- oh-my-zsh 帮我们整理了一些常用的 zsh 扩展功能和主题，简单的配置后开箱即用。
- 

```shell
# CentOS 安装 
sudo yum install -y zsh
# Ubuntu 安装 
sudo apt-get install -y zsh
# MacOS 安装
brew install zsh 

### 为当前用户设置默认 zsh 为默认 shell
chsh -s /bin/zsh
### 下载并安装 oh-my-zsh 
#### 使用curl安装
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
#### 使用wget安装
sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# 安装 zsh-syntax-highlighting 和 zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```









# fish

Fish是“the **f**riendly **i**nteractive **sh**ell”的简称，fish最大的特点就是功能强大，智能并且用户友好。

很多其他 Shell 需要配置才有的功能，Fish 默认提供，不需要任何配置。

Fish支持语法高亮，自动建议，标签完成等，而且配置十分简单。





