# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ -s /home/bruno/.autojump/etc/profile.d/autojump.sh ]] && source /home/bruno/.autojump/etc/profile.d/autojump.sh
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/usr/local/texlive/2020/bin/x86_64-linux:/home/bruno/.cargo/bin/:/home/bruno/.gem/ruby/2.7.0/bin:$PATH 


export ZSH="/home/bruno/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

DISABLE_MAGIC_FUNCTIONS=true
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  #zsh-vim-mode
)

source $ZSH/oh-my-zsh.sh
export CONDA_AUTO_ACTIVATE_BASE=false
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

#Hace que los alias funcionen con sudo, a veces
alias sudo='sudo '
alias rm='rm -i'
alias ls='exa'
alias la='exa -a'
alias lt='exa --tree --level=3'
alias l='exa'
alias tm='tmux -2'
alias vim='nvim'
alias v='nvim'
alias du='dust -b'
alias z='zathura'
alias grep='grep --color=auto'
alias sptr='systemctl restart  --user spotifyd.service && spt'
bindkey '^ ' autosuggest-accept
alias cr='cargo run'
alias crr='cargo run --release'
alias ct='cargo test'
alias cb='cargo build'
alias ccc='cargo check'
alias tiempo='curl http://wttr.in/ -s | head -n-2'
alias sss='grim -g "$(slurp)" ~/screenshoots/$(date +%Y-%m-%d_%H-%m-%s).png'


export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export CARGO_TARGET_DIR='/home/bruno/cargo_target_dir'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
