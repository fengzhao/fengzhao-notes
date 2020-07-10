# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/root/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="afowler"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  extract
  zsh-syntax-highlighting
  zsh-autosuggestions
  colored-man-pages
  ssh-agent  	
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alia ohmyzsh="mate ~/.oh-my-zsh"


export GOROOT=/usr/local/go
export GOPATH=/root/gopath
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# getIP
# winip=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
export winip=$(ip route | grep default | awk '{print $3}')
export wslip=$(hostname -I | awk '{print $1}')


# gitproxy(){
# 	git config --global https.proxy socks5://${winip}:1080                                                                                                                                             
# 	git config --global http.proxy socks5://${winip}:1080   
# }

# proxy
alias proxy='
        export http_proxy=socks5://$windows_host:1080; 
        export https_proxy=socks5://$windows_host:1080; 
        ALL_PROXY=socks5://$windows_host:1080
        '
alias unproxy='unset http_proxy; unset https_proxy'
alias testproxy='curl -I https://www.google.com'

alias note='cd /mnt/c/Users/fengz/Desktop/fengzhao-notes'

gitproxy(){
	git config --global https.proxy socks5://$windows_host:1080                                                                                                                                             
	git config --global http.proxy socks5://$windows_host:1080   
}


# export http_proxy="${PROXY_HTTP}"
# export HTTP_PROXY="${PROXY_HTTP}"
# export https_proxy="${PROXY_HTTP}"
# export HTTPS_PROXY="${PROXY_HTTP}"
# export ftp_proxy="${PROXY_HTTP}"
# export FTP_PROXY="${PROXY_HTTP}"
# export rsync_proxy="${PROXY_HTTP}"
# export RSYNC_PROXY="${PROXY_HTTP}"
# export ALL_PROXY="${PROXY_SOCKS5}"
# export all_proxy="${PROXY_SOCKS5}"




ssh-add .ssh/vultr

