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
## vim-plug官网：https://github.com/junegunn/vim-plug


# 安装的本质就是：把 plug.vim 文件下载到 ~/.vim/autoload/ 这个目录中

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

# 从github上下载配色文件
curl --create-dirs    https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim  -o ~/.vim/colors/molokai.vim    
# 运行vim，进入命令模式，执行 PlugInstall 命令来安装插件
```





## vim配置go开发环境



> 本配置是在 Ubuntu 18.04 下完成的， vim 版本是 `VIM - Vi IMproved 8.0` ，开启 lantern （不考虑网络不通畅的情况）





## CentOS7 升级到 vim8  

### 方法一：编译安装升级vim8 

使用 `:version` 命令将向你展示当前正在运行的 Vim 的所有相关信息，包括它是如何编译的。

第一行告诉你这个二进制文件的编译时间和版本号，比如：7.4。接下来的一行呈现 `Included patches: 1-1051`，这是补丁版本包。因此你 Vim 确切的版本号是 7.4.1051。

Vim 的特性集区分被叫做 `tiny`，`small`，`normal`，`big` and `huge`，所有的都实现不同的功能子集。

其实可以认为特性集就是编译参数的集合，当执行 :version 后，可以看到类似  `Tiny version without GUI` 或者 `Huge version with GUI` 的信息。

`:version` 主要的输出内容是特性列表。`+clipboard` 意味这剪贴板功能被编译支持了，`-clipboard` 意味着剪贴板特性没有被编译支持。

一些功能特性需要编译支持才能正常工作。例如：为了让 `:prof` 工作，你需要使用 `huge` 模式编译的 Vim，因为那种模式启用了 `+profile` 特性。

如果你的输出情况并不是那样，并且你是从包管理器安装 Vim 的，确保你安装了 `vim-x`，`vim-x11`，`vim-gtk`，`vim-gnome` 这些包或者相似的，因为这些包通常都是 `huge` 模式编译的。





```shell
# 升级gcc
sudo yum install centos-release-scl -y
sudo yum install devtoolset-3-toolchain -y
sudo yum install gcc-c++
sudo scl enable devtoolset-3 bash
yum install ncurses-devel

# 升级vim
wget https://github.com/vim/vim/archive/v8.2.0096.tar.gz
tar -zxvf v8.2.0096.tar.gz

cd v8.2.0096/
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





## 深入理解VIM

https://blog.csdn.net/qq_27825451/article/details/100557133

