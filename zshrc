# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
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
export LANG=en_US.UTF-8

#Comppila y abre .tex
alias ltx='~/Documents/Bash/latex.sh'
#Hace que los alias funcionen con sudo
alias sudo='sudo '
alias rm='rm -i'
alias ls='exa'
alias la='exa -a'
alias l='exa'
alias tm='tmux -2'
alias vim='nvim'
alias v='nvim'
alias du='du -h'
alias grep='grep --color=auto'
bindkey '^ ' autosuggest-accept
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
