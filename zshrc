# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ -s /home/bruno/.autojump/etc/profile.d/autojump.sh ]] && source /home/bruno/.autojump/etc/profile.d/autojump.sh
# If you come from bash you might have to change your $PATH.
#export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/usr/local/texlive/2020/bin/x86_64-linux:/home/bruno/.cargo/bin/:$PATH

export ZSH="/home/bruno/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

DISABLE_MAGIC_FUNCTIONS=true
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
export CONDA_AUTO_ACTIVATE_BASE=false
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

#Comppila y abre .tex
#Hace que los alias funcionen con sudo, a veces
alias sudo='sudo '
alias rm='rm -i'
alias ls='exa'
alias la='exa -a'
alias l='exa'
alias tm='tmux -2'
alias vim='nvim'
alias v='nvim'
alias du='du -h'
alias z='zathura'
alias grep='grep --color=auto'
alias sptr='systemctl restart  --user spotifyd.service && spt'
bindkey '^ ' autosuggest-accept
alias cr='cargo run'
alias ct='cargo test'
alias ccc='cargo check'

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/bruno/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/bruno/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/bruno/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/bruno/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

