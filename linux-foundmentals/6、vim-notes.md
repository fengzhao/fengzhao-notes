# Vim整理笔记

Vim 是 Linux 下的编辑器，它的官网是 https://www.vim.org/ 。一般在 Linux 发行版中都已经安装好  Vim，安装目录一般是 /usr/share/vim/ 


##　帮助文件

vimtutor 是 vim 自带的一个小教程，直接在终端中使用 vimtutor 命令就可以查看，使用 vimtutor zh 命令查看中文版。

输入 vim ，进入 vim 编辑器后，输入 :help 就可以打开 vim 帮助文件，默认是用英文显示。

[vimcdoc](https://github.com/fengzhao/vimcdoc) 一个 vim 中文文档项目，可以按照该文档教程安装帮助手册。


## Vim 配置文件

vimrc 是 Vim 的配置文件，这个文件分为全局配置文件和用户配置文件。在终端中通过 vim --version 命令可以查看全局配置和用户配置的文件路径。

用户配置文件 $HOME/.vimrc   （如果没有可以用户自己新建）
全局配置文件


```shell
   system vimrc file: "$VIM/vimrc"
     user vimrc file: "$HOME/.vimrc"
 2nd user vimrc file: "~/.vim/vimrc"
      user exrc file: "$HOME/.exrc"
       defaults file: "$VIMRUNTIME/defaults.vim"
  fall-back for $VIM: "/usr/share/vim"

```

配置文件的注释是以 " 号开头的行


## Vim 插件


vim 支持很多插件，这些插件提供了很多方便的设置。

### 插件管理器

[vim-plug](https://github.com/junegunn/vim-plug) 是一个插件管理器，可以用来管理插件。


#### 安装


