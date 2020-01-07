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



### 获取vimrc配置(开发版) vim8

```shell
# 从github上下载vimrc配置文件到本地
curl https://raw.githubusercontent.com/fengzhao/fengzhao-notes/master/dotfile/.vimrc  > ~/.vimrc
# 运行vim，进入命令模式，执行 PlugInstall 命令来安装插件
```





## vim配置go开发环境



> 本配置是在 Ubuntu 18.04 下完成的， vim 版本是 `VIM - Vi IMproved 8.0` ，开启 lantern （不考虑网络不通畅的情况）





## CentOS7 升级到 vim8  

### 方法一：编译升级



```shell
# 升级gcc
sudo yum install centos-release-scl -y
sudo yum install devtoolset-3-toolchain -y
sudo yum install gcc-c++
sudo scl enable devtoolset-3 bash
yum install ncurses-devel

# 升级vim
wget https://github.com/vim/vim/archive/v8.1.1053.tar.gz
tar -zxvf v8.1.1053.tar.gz

cd vim-8.1.1053/
# 注意一下我们需要用configure配置一下安装的路径，将Vim8安装到自己账户的目录下，避免干扰到系统上的其他用户
# ./configure --prefix=$HOME/.vim  –-enable-multibyte

./configure

######################################vim常见的编译参数#####################################################
–with-features=huge：支持最大特性
–enable-rubyinterp：打开对ruby编写的插件的支持
–enable-pythoninterp：打开对python编写的插件的支持
–enable-python3interp：打开对python3编写的插件的支持
–enable-luainterp：打开对lua编写的插件的支持
–enable-perlinterp：打开对perl编写的插件的支持
–enable-multibyte：打开多字节支持，可以在Vim中输入中文
–enable-cscope：打开对cscope的支持
–with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu/ 指定python 路径
–with-python-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu/ 指定python3路径
–prefix=/usr/local/vim：指定将要安装到的路径(自行创建)
#######################################################################################################


# 安装 
make && make install

# 设置alias
# alias vim='~/.vim/bin/vim'
# echo "alias vim='~/.local/bin/vim'" >> ~/.bashrc
# echo "alias vim='~/.local/bin/vim'" >> ~/.zshrc


# 检查
vim -version
```





### 方法二：包管理器升级

```shell
rpm -Uvh http://mirror.ghettoforge.org/distributions/gf/gf-release-latest.gf.el7.noarch.rpm
rpm --import http://mirror.ghettoforge.org/distributions/gf/RPM-GPG-KEY-gf.el7
yum -y remove vim-minimal vim-common vim-enhanced sudo
yum -y --enablerepo=gf-plus install vim-enhanced sudo

```







