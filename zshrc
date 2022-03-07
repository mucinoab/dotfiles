# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh

# If you come from bash you might have to change your $PATH.
export PATH=~/dev/dotMemory:/usr/local/texlive/2020/bin/x86_64-linux:~/.cargo/bin/:$PATH 
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.config/composer/vendor/bin:$PATH
eval "$(zoxide init --cmd j zsh)"
eval "$(starship init zsh)"


export ZSH="~/.oh-my-zsh"

DISABLE_MAGIC_FUNCTIONS=true
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  #zsh-vi-mode
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
alias ls='exa -s modified'

alias la='exa -a -s modified'
alias lt='exa --tree --level=3 -s modified'
alias l='exa -s modified'
alias tm='tmux -2'
alias vim='nvim'
alias v='nvim'
alias du='dust -b'
alias z='zathura'
alias grep='grep --color=auto'
alias sptr='systemctl restart  --user spotifyd.service && spt'
alias dr='mold -run dotnet run -r linux-x64 --property:Configuration=Debug'
alias db='mold -run dotnet build'
alias cr='mold -run cargo run'
alias crr='mold -run cargo run --release'
alias ct='mold -run cargo test'
alias gt='go test'
alias cb='mold -run cargo build'
alias ccc='mold -run cargo check'
alias tiempo='curl http://wttr.in/ -s | head -n-2'
alias sss='grim -g "$(slurp)" ~/screenshoots/$(date +%Y-%m-%d_%H-%m-%s).png'
alias foto='ffmpeg -loglevel panic -i /dev/video1 -frames 1 -f image2 -| convert - -colorspace gray - > ~/Pictures/$(date +%Y-%m-%d_%H-%m-%s).jpeg'
alias sf='rg --files | sk --preview="bat {} --color=always"'
alias rg='rg -S'
alias gr='go run .'
alias dnd='makoctl set-mode do-not-disturb'
alias ddd='makoctl set-mode default'

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export CARGO_TARGET_DIR='~/cargo_target_dir'
export RUSTFLAGS="-C target-cpu=native"

#no cierra terminal con shift D
set -o ignoreeof

# ctrl + space auto complete 
bindkey '^ ' autosuggest-accept

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

noti() {
  notify-send 'Terminal Done' -u critical
}

rgf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}

function pcsv {
    cat "$@" | sed 's/,/ ,/g' | column -t -s, | less -S
}
