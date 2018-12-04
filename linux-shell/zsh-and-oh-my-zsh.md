# zsh 和 oh-my-zsh 教程

## zsh 简介

- zsh 兼容 Bash，据传说 99% 的 Bash 操作 和 zsh 是相同的。
- oh-my-zsh 帮我们整理了一些常用的 zsh 扩展功能和主题，简单的配置后开箱即用。
- https://github.com/robbyrussell/oh-my-zsh 
- http://www.zsh.org/

## 安装前提

- Unix-Like 系统（macos 或 Linux）
- 已安装 zsh （v4.3.9 或更高），使用 zsh --version 命令来确认。
- 已安装 curl 或 wget 
- 已安装 git


## 安装

- CentOS 安装 zsh：sudo yum install -y zsh
- Ubuntu 安装 zsh：sudo apt-get install -y zsh

设置默认 zsh 为默认 shell：

``` shell
$ chsh -s $(which zsh)
```

安装 oh-my-zsh

- 通过 curl

``` shell 
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/fengzhao/oh-my-zsh/master/tools/install.sh)"
```

- 通过 wget

``` shell 
$ sh -c "$(wget https://raw.githubusercontent.com/fengzhao/oh-my-zsh/master/tools/install.sh)"
```
## 配置

