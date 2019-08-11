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

# 设置默认编辑器
alias vi='vim'
alias edit=$EDITOR
export EDITOR= "vim"

# 重新载入zsh配置
alias sz='source ~/.zshrc'

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


plugins=(
  git
  extract
  zsh-syntax-highlighting
 zsh-autosuggestions

)


source $ZSH/oh-my-zsh.sh

# 快速配置zshconfig
alias zshconfig="vim ~/.zshrc"

