# zsh 和 oh-my-zsh 和 tmux 教程

## zsh 和 oh-my-zsh 简介

- zsh 兼容 Bash，据传说 99% 的 Bash 操作 和 zsh 是相同的。
- oh-my-zsh 帮我们整理了一些常用的 zsh 扩展功能和主题，简单的配置后开箱即用。
- [zsh 官网](http://www.zsh.org/)
- [oh-my-zsh 官网](https://github.com/robbyrussell/oh-my-zsh) 

Github 上的简介是 ”A delightful community-driven framework for managing your zsh configuration。”（一个令人愉快的社区驱动框架，用于管理您的zsh配置。），概括说就是可以帮助你简单配置轻松使用 zsh，还能让你在无聊时玩耍 140 种主题，200+ 插件的装逼玩意。

## 安装 zsh

- CentOS 安装 zsh：sudo yum install -y zsh
- Ubuntu 安装 zsh：sudo apt-get install -y zsh

设置默认 zsh 为默认 shell：

``` shell
# chsh -s $(which zsh)
```
## 安装 oh-my-zsh

### 安装前提

- Unix-Like 系统（MacOS 或 Linux）
- 已安装 zsh （v4.3.9 或更高），使用 zsh --version 命令来确认。
- 已安装 curl 或 wget 
- 已安装 git

- 通过 curl

``` shell 
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/fengzhao/oh-my-zsh/master/tools/install.sh)"
```

- 通过 wget

``` shell 
$ sh -c "$(wget https://raw.githubusercontent.com/fengzhao/oh-my-zsh/master/tools/install.sh)"
```

## 配置 oh-my-zsh

安装完 oh-my-zsh 。与 bash一样，zsh默认的配置文件在 ~/.zshrc中。这个目录下也会分享我的配置文件。

在配置文件中，有很多主题，每个主题定义都定义了很多样式，包括 prompt 的格式。修改 ZSH_THEME 可以配置主题。可以点击 [主题详解](https://github.com/robbyrussell/oh-my-zsh/wiki/External-themes) 查看更多主题。

一般我常用的主题包括 avit 和 agnoster 。这两个

oh-my-zsh 中定义了很多插件，这些插件在 ~/.oh-my-zsh 的 plugins 目录中定义。可以在 zsh 配置文件中启用这些插件。，有些插件是一些命令别名，有些是一些脚本，有些是一些自动补全或语法高亮之类。熟练掌握并熟悉能有效提高自己的工作效率。友情提示：开启过多插件会明显影响 zsh 的打开效率。zsh 默认启用了 git 插件，这个插件定义了很多 git 命令的别名

常用插件

| 左对齐标题 | 右对齐标题 | 居中对齐标题 |
| :------| ------: | :------: |
| 短文本 | 中等文本 | 稍微长一点的文本 |
| 稍微长一点的文本 | 短文本 | 中等文本 |
