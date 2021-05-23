# zsh 和 oh-my-zsh 和 tmux 教程



## zsh 和 oh-my-zsh 简介

- zsh 兼容 Bash，据传说 99% 的 Bash 操作 和 zsh 是相同的。
- oh-my-zsh 帮我们整理了一些常用的 zsh 扩展功能和主题，简单的配置后开箱即用。
- [zsh 官网](http://www.zsh.org/)
- [oh-my-zsh 官网](https://github.com/robbyrussell/oh-my-zsh) 

Github 上的简介是 ”A delightful community-driven framework for managing your zsh configuration。”

（一个令人愉快的社区驱动框架，用于管理您的zsh配置。），概括说就是可以帮助你简单配置轻松使用 zsh，还能让你在无聊时玩耍 140 种主题，200+ 插件的装逼玩意。

## 安装 zsh

```shell
# CentOS 安装 
sudo yum install -y zsh
# Ubuntu 安装 
sudo apt-get install -y zsh
# MacOS 安装
brew install zsh 
```



为当前用户设置默认 zsh 为默认 shell：

``` shell
# chsh -s $(which zsh)
```
## 安装 oh-my-zsh

### 安装前提

- Unix-Like 系统（MacOS 或 Linux）
- 已安装 zsh （v4.3.9 或更高），使用 zsh --version 命令来确认。
- 已安装 curl 或 wget 
- 已安装 git

#### 通过 curl

``` shell 
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/fengzhao/oh-my-zsh/master/tools/install.sh)"
```

#### 通过 wget

``` shell 
$ sh -c "$(wget https://raw.githubusercontent.com/fengzhao/oh-my-zsh/master/tools/install.sh)"
```



## 配置 oh-my-zsh

安装完 oh-my-zsh 。与 bash一样，zsh默认的配置文件在 ~/.zshrc中。这个目录下也会分享我的配置文件。

在配置文件中，有很多主题，每个主题定义都定义了很多样式，包括 prompt 的格式。修改 ZSH_THEME 可以配置主题。可以点击 [主题详解](https://github.com/robbyrussell/oh-my-zsh/wiki/External-themes) 查看更多主题。

一般我常用的主题包括 avit 和 agnoster 这两个。

oh-my-zsh 中定义了很多插件，这些插件在 ~/.oh-my-zsh 的 plugins 目录中定义。可以在 zsh 配置文件中启用这些插件。

有些插件是一些命令别名，有些是一些脚本，有些是一些自动补全或语法高亮之类。熟练掌握并熟悉能有效提高自己的工作效率。

友情提示：开启过多插件会明显影响 zsh 的打开效率。zsh 默认启用了 git 插件，这个插件定义了很多 git 命令的别名。



oh-my-zsh 会定义一个变量 $ZSH_CUSTOM，默认值是 oh-my-zsh 的安装目录 ~/.oh-my-zsh/ 



### ~/.oh-my-zsh 目录
```shell
lib         # 提供核心功能的脚本库
tools       # 提供安装、升级等功能的工具
plugins     # 自带插件的存放位置
templates   # 自带模板的存放位置
themes      # 自带主题的存放位置
custom      # 个性化配置目录，自安装的插件和主题可放这里
```

> oh-my-zsh 开启过多插件，会影响 zsh 的启动效率，并且可能会有卡顿。使用 time zsh -i -c exit 命令可以检测 zsh 的启动速度。


### 插件
```shell
# 在~/.zshrc中找到plugin开头的这一行，填入相关插件名称来启用插件 
plugins=(ssh-agent git zsh-syntax-highlighting zsh-autosuggestions extract) 

# git                       最常用插件，git 相关
# z                         按照使用频率排序曾经进过的目录，进行模糊匹配
# wd                        通过设置 tag，快速切换目录
# extract                   'x'命令，支持自动识别压缩格式并将其解压，任何压缩文件都可以直接用x解压
# colored-man-pages         'man'帮助文档页面开启高亮显示
# zsh-syntax-highlighting   oh-my-zsh 命令行语法高亮插件

# 安装 zsh-syntax-highlighting 和 zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```



#### zsh-autosuggestions

当你输入命令时，它会根据命令历史自动以灰色补全之前执行的命令，按下键盘 -> 键就会自动补全，将光标移动到最后方。



命令建议策略

ZSH_AUTOSUGGEST_STRATEGY 是一个数组变量，用来控制如何生成命令建议，内置有三个变量：

- history —— 根据命令历史生成建议
- completion —— 选择一个命令补全插件（requires `zpty` module）
- match_prev_cmd —— 类似于命令历史，

比如，设置 ZSH_AUTOSUGGEST_STRATEGY=(history completion) ，会先从命令历史中找，如果找不到，会从自动补全引擎里面查找。





在使用 bash 命令行时，在提示符下输入某个命令的前面几个字符，然后按下 TAB 键，就会列出以这几个字符开头的命令供我们选择。

自动补全这个功能是 Bash 自带的，但一般我们会安装 bash-completion 包来得到更好的补全效果，这个包提供了一些现成的命令补全脚本，一些基础的函数方便编写补全脚本，还有一个基本的配置脚本。

可以用命令 `type _init_completion` 检查 bash-completion 是否已安装）。



https://github.com/scop/bash-completion

http://blog.fpliu.com/it/software/bash-completion

https://jasonkayzk.github.io/2020/12/06/Bash%E5%91%BD%E4%BB%A4%E8%87%AA%E5%8A%A8%E8%A1%A5%E5%85%A8%E7%9A%84%E5%8E%9F%E7%90%86/

```shell
yum install -y  bash-completion
```



一般会有一个名为bash_completion的脚本，这个脚本会在shell初始化时加载。

如对于RHEL系统来说，这个脚本位于/etc/bash_completion，而该脚本会由/etc/profile.d/bash_completion.sh中导入，在bash_completion脚本中会加载/etc/bash_completion.d下面的补全脚本：


## tmux

tmux是一款优秀的终端复用软件，它允许

