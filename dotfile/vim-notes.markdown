## Vim学习笔记

Vim 是 Linux 下的编辑器，它的官网是 https://www.vim.org/ 。一般在 Linux 发行版中都已经安装好  Vim，安装目录一般是 /usr/share/vim/ 



### 帮助手册

vimtutor 是 vim 自带的一个小教程，直接在终端中使用 vimtutor 命令就可以查看，使用 vimtutor zh 命令查看中文版。

输入 vim ，进入 vim 编辑器后，输入 :help 就可以打开 vim 帮助文件，默认是用英文显示。

[vimcdoc](https://github.com/fengzhao/vimcdoc) 一个 vim 中文文档项目，可以按照该文档教程安装帮助手册。

### Vim配置文件

vimrc 是 Vim 的配置文件，这个文件分为全局配置文件和用户配置文件。在终端中通过 vim --version 命令可以查看全局配置和用户配置的文件路径。

用户配置文件 $HOME/.vimrc   （如果没有可以用户自己新建）

```shell
 system vimrc file: "$VIM/vimrc"
     user vimrc file: "$HOME/.vimrc"
 2nd user vimrc file: "~/.vim/vimrc"
      user exrc file: "$HOME/.exrc"
       defaults file: "$VIMRUNTIME/defaults.vim"
  fall-back for $VIM: "/usr/share/vim"
```

**配置文件的注释是以 " 号开头的行**



### 安装 vim-plug 插件



```shell
# vim-plug官网：https://github.com/junegunn/vim-plug


# 安装：把 plug.vim 文件下载到 ~/.vim/autoload/ 这个目录中

# Linux/Unix VIM
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim	
	
# Linux/Unix Neovim
 curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim	
	
```



### 获取vimrc配置

```shell
# 从github上下载vimrc配置文件到本地
curl https://raw.githubusercontent.com/fengzhao/fengzhao-notes/master/dotfile/.vimrc  > ~/.vimrc
# 运行vim，进入命令模式，执行 PlugInstall 命令来安装插件
```







