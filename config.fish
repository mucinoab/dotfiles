export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

abbr rm 'rm -i'
abbr ls 'exa -s modified'

abbr la 'exa -a -s modified'
abbr lt 'exa --tree --level 3 -s modified'
abbr l 'exa -s modified'
abbr tm 'tmux -2'
abbr vim 'nvim'
abbr v 'nvim'
abbr du 'dust -b'
abbr z 'zathura'
abbr grep 'grep --color auto'
abbr sptr 'systemctl restart  --user spotifyd.service && spt'
abbr dr 'mold -run dotnet run -r linux-x64 --property:Configuration Debug'
abbr db 'mold -run dotnet build'
abbr cr 'mold -run cargo run'
abbr crr 'mold -run cargo run --release'
abbr ct 'mold -run cargo test'
abbr gt 'go test'
abbr cb 'mold -run cargo build'
abbr ccc 'mold -run cargo check'
abbr tiempo 'curl http://wttr.in/ -s | head -n-2'
abbr sss 'grim -g "$(slurp)" ~/screenshoots/$(date +%Y-%m-%d_%H-%m-%s).png'
abbr foto 'ffmpeg -loglevel panic -i /dev/video1 -frames 1 -f image2 -| convert - -colorspace gray - > ~/Pictures/$(date +%Y-%m-%d_%H-%m-%s).jpeg'
abbr sf 'rg --files | sk --preview "bat {} --color always"'
abbr rg 'rg -S'
abbr gr 'go run .'
abbr dnd 'makoctl set-mode do-not-disturb'
abbr ddd 'makoctl set-mode default'

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export CARGO_TARGET_DIR='/home/mucinoab/cargo_target_dir'
export RUSTFLAGS="-C target-cpu=native"
export EDITOR="nvim"


zoxide init --cmd j fish | source
