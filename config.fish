export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# Aliases
abbr rm 'rm -i'
abbr ls 'exa -s modified'

abbr la 'exa -a -s modified'
abbr ll 'exa -a -l'
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
abbr cb 'mold -run cargo build -Zcodegen-backend'
abbr ccc 'mold -run cargo check'
abbr tiempo 'curl http://wttr.in/ -s | head -n-2'
abbr sss 'grim -g "$(slurp)" ~/screenshoots/$(date +%Y-%m-%d_%H-%m-%s).png'
abbr ssc 'grim -g "$(slurp)" - | wl-copy --type image/png'
abbr sf 'rg --files | sk --preview "bat {} --color always"'
abbr rg 'rg -S'
abbr gr 'go run .'
abbr dnd 'makoctl set-mode do-not-disturb'
abbr ddd 'makoctl set-mode default'
abbr gd 'git diff'
abbr gs 'git status'
abbr gl 'git log'
abbr ga 'git add'
abbr gf 'git fetch'
abbr gp 'git push'

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export CARGO_TARGET_DIR='/home/mucinoab/cargo_target_dir'
#export CARGO_PROFILE_DEV_CODEGEN_BACKEND="cranelift"
# export RUSTFLAGS="-C target-cpu=native"
export EDITOR="nvim"
export VISUAL="nvim"
export FLYCTL_INSTALL="/home/mucinoab/.fly"


zoxide init --cmd j fish | source
jj util completion fish | source
zellij setup --generate-completion fish | source
fzf --fish | source

# Bindings 
# funced fish_user_key_bindings
# bind --erase --preset \cd # https://stackoverflow.com/questions/34216850/how-to-prevent-fish-shell-from-closing-when-typing-ctrl-d-eof 
# funcsave fish_user_key_bindings

# Avoid waiting for fish to search for packages
function fish_command_not_found
  echo Did not find command $argv[1]
end

# Pretty csv
function pcsv
    cat $argv[1] | sed 's/,/ ,/g' | column -t -s, | less -S
end


# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Binds for fish_vi_key_bindings, mimic some of my vimrc
bind -M insert jk 'set fish_bind_mode default; commandline -f backward-char force-repaint'
bind -M default H beginning-of-line # Map H to jump to start of line (like g^)
bind -M default L end-of-line # Map L to jump to end of line (like g$)


# Function to handle cursor shape changes
function fish_vi_cursor
    # Block cursor for normal mode
    set -l shape_normal "\e[2 q"
    # Line cursor for insert mode
    set -l shape_insert "\e[6 q"
    
    switch $fish_bind_mode
        case default
            echo -ne $shape_normal
        case insert
            echo -ne $shape_insert
    end
end

# Save the original mode prompt function
functions --copy fish_mode_prompt fish_mode_prompt_original

# Create new function that does both cursor change and mode display
function fish_mode_prompt
    fish_vi_cursor
    fish_mode_prompt_original
end

# Search for text with ripgrep, select files with fzf, and open in nvim at the first match
function rgv
    set search_args $argv
    set files (rg -l $search_args)
    
    if test (count $files) -eq 0
        echo "No files found matching: $search_args"
        return
    else if test (count $files) -eq 1
        # Only one file found, open it directly
        set selected $files
    else
        # Multiple files, use fzf for selection
        set selected (printf '%s\n' $files | fzf --multi --preview "
            echo '=== Matches ==='
            rg --color=always --context=3 --line-number -- (string escape -- $search_args) {} 2>/dev/null
            echo
            echo '=== Full file preview ==='
            bat --theme=GitHub --color=always --line-range=1:50 {}
        ")
    end
    
    if test -n "$selected"
        # Get the first match line number from the first selected file
        set first_file $selected[1]
        set first_line (rg --line-number --no-heading -- $search_args $first_file 2>/dev/null | head -1 | cut -d: -f1)
        
        if test -n "$first_line" -a "$first_line" -gt 0 2>/dev/null
            # Build the nvim command
            if test (count $selected) -eq 1
                set nvim_cmd "nvim +$first_line $selected"
            else
                set nvim_cmd "nvim +$first_line $first_file $selected[2..]"
            end
        else
            # Fallback if no line number found
            set nvim_cmd "nvim $selected"
        end
        
        # Add to history and execute
        history append $nvim_cmd
        eval $nvim_cmd
    end
end

# pnpm
set -gx PNPM_HOME "/home/mucinoab/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Set initial cursor shape
fish_vi_cursor
