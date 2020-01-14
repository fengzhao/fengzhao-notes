# If you come from bash you might have to change your $PATH.:wq
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/fengzhao/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# 宿主机跑ss,wsl子系统跑polipo,为linux终端提供http代理。https://liuzhilin.io/archives/46
# export http_proxy=http://localhost:1080

# Setup terminal, and turn on colors 颜色配置
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad


# Uncomment the following line to disable bi-weekly auto-update checks.
# 是否禁用自动更新
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# 自动更新检查日期
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# ls命令彩色
 DISABLE_LS_COLORS="False"



# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="avit"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# 命令历史日期格式
HIST_STAMPS="yyyy-mm-dd"


# git                         最常用插件，git 相关
# extract                     'x'命令，支持自动识别压缩格式并将其解压，任何压缩文件都可以直接用x解压
# zsh-syntax-highlighting     oh-my-zsh 命令行语法高亮插件
# zsh-autosuggestions         根据历史记录智能自动补全命令 
# z                           按照使用频率排序曾经进过的目录，进行模糊匹配
# wd                          通过设置 tag，快速切换目录
# colored-man-pages           'man'帮助文档页面开启高亮显示


plugins=(
  git
  extract
  zsh-syntax-highlighting
  zsh-autosuggestions
  x
  colored-man-pages
)


source $ZSH/oh-my-zsh.sh

# 快速配置zshconfig
alias zshconfig="vim ~/.zshrc"
# 重新载入zshconfig
alias sz='source ~/.zshrc'

# 设置默认编辑器
alias vi='vim'
alias edit=$EDITOR
export EDITOR= "vim"










export LC_ALL=en_US.UTF-8